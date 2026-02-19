import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/AnalyticsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AnalyticsController extends GetxController {
  bool isLoading = false;
  AnalyticsResponse? analytics;

  final String baseUrl = "https://api.ecom.palqar.cloud/v1";

  @override
  void onInit() {
    fetchAnalytics();
    super.onInit();
  }

  Future<void> fetchAnalytics() async {
    //  try {
    isLoading = true;
    update();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    /// ✅ PRINT REQUEST DETAILS
    final url = "$baseUrl/delivery-partners/analytics/stats";

    print("========== ANALYTICS API REQUEST ==========");
    print("URL => $url");
    print("TOKEN => $token");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    /// ✅ PRINT RESPONSE DETAILS
    print("========== ANALYTICS API RESPONSE ==========");
    print("STATUS CODE => ${response.statusCode}");
    print("BODY => ${response.body}");

    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);

      /// DEBUG PARSED JSON
      print("DECODED JSON => $decoded");

      final data = AnalyticsResponse.fromJson(decoded);

      analytics = data;

      /// ✅ SAFE DEBUG PRINTS
      print("SUCCESS => ${analytics?.success}");
      print("SUMMARY EXISTS => ${analytics?.data?.summary != null}");

      print("COMPLETED ORDERS => ${analytics?.data?.summary.completedOrders}");
    } else {
      print("API ERROR => ${response.body}");
      Get.snackbar("Error", "Failed to fetch analytics");
    }
    //} catch (e, stack) {

    // Get.snackbar("Error", e.toString());
    // } finally {
    isLoading = false;
    update();
    //   }
  }
}
