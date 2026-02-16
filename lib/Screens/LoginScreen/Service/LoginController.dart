import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
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

    /// ✅ SUCCESS CHECK
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        data["success"] == true) {

      String token = data["data"]["access_token"];

      print("TOKEN RECEIVED => $token");

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      print("TOKEN SAVED SUCCESSFULLY");

      Get.offAll(() => const HomeScreen());

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

    if (token == null) {
      return const EmailLoginScreen();
    }

    bool expired = JwtDecoder.isExpired(token);

    if (expired) {
      await prefs.remove("token");
      return const EmailLoginScreen();
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