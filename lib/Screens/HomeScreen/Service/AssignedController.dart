import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/DeliveryPartnerModel.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/OrderModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderController extends GetxController {
  bool isLoading = false;
  List<OrderModel> orders = [];

  // ================= ANALYTICS =================
  Map<String, dynamic> summary = {};
  Map<String, dynamic> partner = {};
  Map<String, dynamic> dateRange = {};
  List<dynamic> recentOrders = [];
  /// ================= DELIVERY PARTNERS =================
List<DeliveryPartnerModel> deliveryPartners = [];
bool isPartnerLoading = false;

  final String baseUrl = "https://api.ecom.palqar.cloud/v1";

  @override
  void onInit() {
    fetchMyOrders();
    fetchAnalytics(); 
     fetchDeliveryPartners(); 
    super.onInit();
  }

  /// ================= FETCH ORDERS =================
  Future<void> fetchMyOrders() async {
    try {
      isLoading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("$baseUrl/orders/delivery-partner/my-orders"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        List list = data["data"]["data"];
        orders = list.map((e) => OrderModel.fromJson(e)).toList();
      } else {
        Get.snackbar("Error", "Failed to load orders");
      }
    } catch (e) {
      print("ORDER ERROR => $e");
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  /// ================= CHANGE ORDER STATUS =================
 Future<bool> changeOrderStatus({
  required String orderId,
  required String status,
}) async {
  try {
    isLoading = true;
    update();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = "$baseUrl/orders/delivery/$orderId/status";

    final bodyMap = {
      "status": status,
      "paymentStatus": "completed",
    };

    final body = jsonEncode(bodyMap);

    /// ================= DEBUG REQUEST =================
    print("========== STATUS UPDATE REQUEST ==========");
    print("URL => $url");
    print("TOKEN => $token");
    print("BODY MAP => $bodyMap");
    print("BODY JSON => $body");

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    /// ================= DEBUG RESPONSE =================
    print("========== STATUS UPDATE RESPONSE ==========");
    print("STATUS CODE => ${response.statusCode}");
    print("RAW BODY => ${response.body}");

    final data = jsonDecode(response.body);

    print("DECODED RESPONSE => $data");
    print("SUCCESS FIELD => ${data["success"]}");
    print("MESSAGE FIELD => ${data["message"]}");

    if (response.statusCode == 200 && data["success"] == true) {
      Get.snackbar("Success", "Order status updated to $status");

      /// refresh orders
      await fetchMyOrders();

      return true;
    } else {
      Get.snackbar(
        "Error",
        data["message"] ?? "Failed to update status",
      );
      return false;
    }
  } catch (e, stack) {
    print("========== STATUS ERROR ==========");
    print("ERROR => $e");
    print("STACK => $stack");

    Get.snackbar("Error", e.toString());
    return false;
  } finally {
    isLoading = false;
    update();
  }
}
  /// ================= FETCH ANALYTICS =================
  Future<void> fetchAnalytics() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final response = await http.get(
        Uri.parse("$baseUrl/delivery-partners/analytics/stats"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        partner = data["data"]["partner"] ?? {};
        summary = data["data"]["summary"] ?? {};
        dateRange = data["data"]["dateRange"] ?? {};
        recentOrders = data["data"]["recentOrders"] ?? [];
        update(); // update UI after fetching analytics
      } else {
        Get.snackbar("Error", "Failed to load analytics");
      }
    } catch (e) {
      print("ANALYTICS ERROR => $e");
      Get.snackbar("Error", e.toString());
    }
  }

/// ================= FETCH DELIVERY PARTNERS =================
Future<void> fetchDeliveryPartners() async {
  try {
    isPartnerLoading = true;
    update();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url = "$baseUrl/delivery-partners";

    /// ===== DEBUG REQUEST =====
    print("===== FETCH DELIVERY PARTNERS =====");
    print("URL => $url");
    print("TOKEN => $token");

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    print("STATUS CODE => ${response.statusCode}");
    print("RAW RESPONSE => ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      List list = data["data"];

      deliveryPartners =
          list.map((e) => DeliveryPartnerModel.fromJson(e)).toList();

      print("TOTAL PARTNERS => ${deliveryPartners.length}");
    } else {
      Get.snackbar("Error", data["message"] ?? "Failed to load partners");
    }
  } catch (e, stack) {
    print("PARTNER ERROR => $e");
    print(stack);
    Get.snackbar("Error", e.toString());
  } finally {
    isPartnerLoading = false;
    update();
  }
}

/// ================= ASSIGN DELIVERY PARTNER =================
Future<bool> assignDeliveryPartner({
  required String orderId,
  required String deliveryPartnerId,
  String notes = "",
}) async {
  try {
    isLoading = true;
    update();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    final url =
        "$baseUrl/orders/$orderId/assign-delivery-partner";

    final bodyMap = {
      "deliveryPartnerId": deliveryPartnerId,
      "notes": notes,
    };

    final body = jsonEncode(bodyMap);

    /// ===== DEBUG REQUEST =====
    print("========== ASSIGN DELIVERY PARTNER REQUEST ==========");
    print("URL => $url");
    print("TOKEN => $token");
    print("BODY => $bodyMap");

    final response = await http.patch(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    /// ===== DEBUG RESPONSE =====
    print("STATUS CODE => ${response.statusCode}");
    print("RAW RESPONSE => ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      Get.snackbar("Success", "Delivery partner assigned successfully");

      /// refresh orders list
      await fetchMyOrders();

      return true;
    } else {
      Get.snackbar(
        "Error",
        data["message"] ?? "Failed to assign delivery partner",
      );
      return false;
    }
  } catch (e, stack) {
    print("ASSIGN PARTNER ERROR => $e");
    print(stack);
    Get.snackbar("Error", e.toString());
    return false;
  } finally {
    isLoading = false;
    update();
  }
}
}