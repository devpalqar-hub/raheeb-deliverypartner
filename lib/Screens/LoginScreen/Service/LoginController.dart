import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:raheeb_deliverypartner/Screens/AdminWebviewScreen.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/home_screen.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/LoginScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';



class AuthController extends GetxController {

  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  var isLoading = false.obs;

  /// ✅ BASE URL (NO DOUBLE /v1)
  final String baseUrl = "https://api.ecom.palqar.cloud";

  /// ================= LOGIN =================
 Future<void> login() async {
  try {
    isLoading.value = true;

    print("===== LOGIN STARTED =====");
    print("Email: ${emailController.text.trim()}");

    final url = "$baseUrl/v1/auth/login";
    print("API URL => $url");

    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": emailController.text.trim(),
        "password": passwordController.text.trim(),
      }),
    );

    print("Status Code => ${response.statusCode}");
    print("Raw Response => ${response.body}");

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

      print("TOKEN RECEIVED => $token");
      print("USER INFO => $user");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      // Save admin name instead of user name
      if (name != null && name.isNotEmpty) {
        await prefs.setString("name", name);
      }

      await prefs.setString("email", email);
      await prefs.setString("role", role);
      await prefs.setString("userId", id);

      print("TOKEN & USER INFO SAVED SUCCESSFULLY");

     // ✅ Navigate based on role
if (role.toLowerCase() == "admin") {
  print("ADMIN LOGIN → OPEN WEBVIEW");

  Get.offAll(
    () => AdminWebViewScreen(
      accessToken: token,
    ),
  );
} else {
  print("NORMAL USER LOGIN → HOME");

  Get.offAll(() => const HomeScreen());
}

    } else {
      print("LOGIN FAILED => ${data.toString()}");
      Get.snackbar("Login Failed", "Invalid email or password");
    }

  } catch (e, stack) {
    print("LOGIN ERROR => $e");
    print("STACK TRACE => $stack");
    Get.snackbar("Error", e.toString());
  } finally {
    isLoading.value = false;
    print("===== LOGIN END =====");
  }
}
  /// ================= AUTO LOGIN =================
  Future<Widget> checkLogin() async {
  final prefs = await SharedPreferences.getInstance();

  String? token = prefs.getString("token");
  String? role = prefs.getString("role");

  if (token == null) {
    return const EmailLoginScreen();
  }

  bool expired = JwtDecoder.isExpired(token);

  if (expired) {
    await prefs.clear();
    return const EmailLoginScreen();
  }

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