import 'dart:convert';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:raheeb_deliverypartner/Screens/AdminWebviewScreen.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/DeliveryController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/home_screen.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

String Authtoken = "";

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  /// ✅ BASE URL (NO DOUBLE /v1)

  /// ================= LOGIN =================
  Future<void> login() async {
    try {
      isLoading.value = true;

      //print("===== LOGIN STARTED =====");
      //print("Email: ${emailController.text.trim()}");

      final url = "$baseUrl/auth/login";
      //print("API URL => $url");

      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text.trim(),
          "password": passwordController.text.trim(),
        }),
      );

      //print("Status Code => ${response.statusCode}");
      //print("Raw Response => ${response.body}");

      final data = jsonDecode(response.body);

      if ((response.statusCode == 200 || response.statusCode == 201) &&
          data["success"] == true) {
        // Token
        String token = data["data"]["access_token"];

        // User info
        Map<String, dynamic> user = data["data"]["user"];
        Map<String, dynamic>? admin = user["admin"];

        String? name;
        if (admin != null && admin["name"] != null) {
          name = admin["name"]; // ✅ Use admin.name as username
        }

        String email = user["email"];
        String role = user["role"];
        String id = user["id"];

        //print("TOKEN RECEIVED => $token");
        //print("USER INFO => $user");

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("token", token);

        // Save admin name instead of user name
        if (name != null && name.isNotEmpty) {
          await prefs.setString("name", name);
        }

        await prefs.setString("email", email);
        await prefs.setString("role", role);
        await prefs.setString("userId", id);

        //print("TOKEN & USER INFO SAVED SUCCESSFULLY");

        // ✅ Navigate based on role
        if (role.toLowerCase() == "admin") {
          //print("ADMIN LOGIN → OPEN WEBVIEW");

          Get.offAll(() => AdminWebViewScreen(accessToken: token));
        } else {
          //print("NORMAL USER LOGIN → HOME");

          Get.offAll(() => const HomeScreen());
        }
      } else {
        //print("LOGIN FAILED => ${data.toString()}");
        Get.snackbar("Login Failed", "Invalid email or password");
      }
    } catch (e, stack) {
      //print("LOGIN ERROR => $e");
      //print("STACK TRACE => $stack");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
      //print("===== LOGIN END =====");
    }
  }

  Future<void> _requestNotificationPermissionAndSendToken() async {
    try {
      // Request notification permission
      final FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission for iOS
      NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      print('Notification permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional) {
        // Get FCM token
        String? fcmToken = await messaging.getToken();

        if (fcmToken != null) {
          print('FCM Token: $fcmToken');

          // Send FCM token to backend
          await _sendFCMTokenToBackend(fcmToken);
        } else {
          print('Failed to get FCM token');
        }
      } else {
        print('Notification permission denied');
      }
    } catch (e) {
      print('Error requesting notification permission: $e');
    }
  }

  // Send FCM token to backend
  Future<void> _sendFCMTokenToBackend(String fcmToken) async {
    try {
      final response = await post(
        Uri.parse(baseUrl + "/users/fcm-token/admin/"),
        headers: {
          "Authorization": "Bearer $Authtoken",
          "Content-Type": "application/json",
        },
        body: json.encode({"token": fcmToken}),
      );

      print('FCM Token Response Status: ${response.statusCode}');
      print('FCM Token Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('FCM token sent successfully');
        // Save token locally to avoid sending again
        SharedPreferences preferences = await SharedPreferences.getInstance();
        preferences.setString("fcm_token", fcmToken);
      } else {
        print('Failed to send FCM token to backend');
      }
    } catch (e) {
      print('Error sending FCM token to backend: $e');
    }
  }

  /// ================= AUTO LOGIN =================
  Future<Widget> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    String? token = prefs.getString("token");
    String? role = prefs.getString("role");
    Authtoken = token ?? "";

    if (token == null) {
      return const EmailLoginScreen();
    }

    bool expired = JwtDecoder.isExpired(token);

    if (expired) {
      await prefs.clear();
      return const EmailLoginScreen();
    }
    Authtoken = token;
    _requestNotificationPermissionAndSendToken();

    /// ✅ Admin auto open webview
    if (role?.toLowerCase() == "admin") {
      return AdminWebViewScreen(accessToken: token);
    }

    return const HomeScreen();
  }

  /// ================= LOGOUT =================
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");

    Get.offAll(() => const EmailLoginScreen());
  }
}
