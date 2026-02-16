import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/OrderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController {

  bool isLoading = false;
  List<OrderModel> orders = [];

  final String baseUrl =
      "https://api.ecom.palqar.cloud/v1";

  @override
  void onInit() {
    fetchMyOrders();
    super.onInit();
  }

  /// ================= FETCH ORDERS =================
  Future<void> fetchMyOrders() async {
    try {
      isLoading = true;
      update(); // 🔥 refresh UI

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      print("TOKEN => $token");

      final response = await http.get(
        Uri.parse("$baseUrl/orders/delivery-partner/my-orders"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("STATUS => ${response.statusCode}");
      print("BODY => ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data["success"] == true) {

        List list = data["data"]["data"];

        orders =
            list.map((e) => OrderModel.fromJson(e)).toList();

      } else {
        Get.snackbar("Error", "Failed to load orders");
      }
    } catch (e) {
      print("ORDER ERROR => $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      update(); // 🔥 refresh UI again
    }
  }
}