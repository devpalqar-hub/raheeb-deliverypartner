import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/DeliveryController.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/ReturnOrderModel.dart';

class ReturnOrderController extends GetxController {
  bool isLoading = false;
  List<ReturnOrder> returnOrders = [];
  List<ReturnOrder> filteredReturnOrders = [];


  @override
  void onInit() {
    fetchReturns();
    super.onInit();
  }

  Future<void> fetchReturns({
    String? orderId,
    int page = 1,
    int limit = 20,
  }) async {
    //  try {
    isLoading = true;
    update();

    /// 🔹 Get token
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    //print("========== FETCH RETURNS START ==========");

    if (token == null || token.isEmpty) {
      //print("❌ TOKEN MISSING");
      Get.snackbar("Session Expired", "Please login again");
      return;
    }

    /// 🔹 Build URL
    String url =
        "$baseUrl/returns/delivery-partner/my-returns?page=$page&limit=$limit&status=pending";

    if (orderId != null && orderId.isNotEmpty) {
      url = "$url?orderId=$orderId";
    }

    //print("📡 REQUEST URL => $url");
    //print("🔑 TOKEN => Bearer $token");

    /// 🔹 API CALL
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    /// 🔹 RESPONSE DEBUG
    //print("✅ STATUS CODE => ${response.statusCode}");
    //print("📦 RAW RESPONSE BODY =>");
    print(response.body);

    final data = jsonDecode(response.body);

    /// 🔹 SUCCESS CASE
    if (response.statusCode == 200 && data["success"] == true) {
      final List<dynamic> list = data['data']?['data'] ?? [];

      /// ✅ Clear old list
      returnOrders.clear();

      /// ✅ Parse model
      returnOrders.addAll(
        list.map((e) {
          //  //print("➡️ Parsing Order ID: ${e['_id']}");
          return ReturnOrder.fromJson(e);
        }).toList(),
      );

      /// ✅ Copy for filtering
      filteredReturnOrders = List.from(returnOrders);

      //print("✅ Parsed Return Orders Count => ${returnOrders.length}");
    } else {
      //print("❌ API ERROR => ${data["message"]}");
      Get.snackbar("Error", data["message"] ?? "Failed to fetch return orders");
    }
    // } catch (e, stack) {
    //   //print("🚨 RETURN ERROR => $e");
    //   //print("STACK TRACE => $stack");

    //   Get.snackbar("Error", "Failed to fetch return orders");
    // }

    isLoading = false;
    update();
    //print("========== FETCH RETURNS END ==========");
  }
}
