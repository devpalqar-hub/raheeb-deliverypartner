import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/ReturnOrderModel.dart';

class ReturnOrderController extends GetxController {
  bool isLoading = false;
  List<ReturnOrder> returnOrders = [];
  List<ReturnOrder> filteredReturnOrders = [];

  final String baseUrl = "https://api.ecom.palqar.cloud/v1";

  @override
  void onInit() {
    fetchReturns();
    super.onInit();
  }

  Future<void> fetchReturns({String? orderId,int page = 1, int limit = 20}) async {
  try {
    isLoading = true;
    update();

    /// 🔹 Get token
    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    print("========== FETCH RETURNS START ==========");

    if (token == null || token.isEmpty) {
      print("❌ TOKEN MISSING");
      Get.snackbar("Session Expired", "Please login again");
      return;
    }

    /// 🔹 Build URL
    String url = "$baseUrl/returns/delivery-partner/my-returns?page=$page&limit=$limit";

    if (orderId != null && orderId.isNotEmpty) {
      url = "$url?orderId=$orderId";
    }

    print("📡 REQUEST URL => $url");
    print("🔑 TOKEN => Bearer $token");

    /// 🔹 API CALL
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    /// 🔹 RESPONSE DEBUG
    print("✅ STATUS CODE => ${response.statusCode}");
    print("📦 RAW RESPONSE BODY =>");
    print(response.body);

    final data = jsonDecode(response.body);

    /// 🔹 SUCCESS CASE
    if (response.statusCode == 200 && data["success"] == true) {
      final List<dynamic> list = data['data']?['data'] ?? [];

      print("📊 API DATA LENGTH => ${list.length}");

      /// ✅ Clear old list
      returnOrders.clear();

      /// ✅ Parse model
      returnOrders.addAll(
        list.map((e) {
          print("➡️ Parsing Order ID: ${e['_id']}");
          return ReturnOrder.fromJson(e);
        }).toList(),
      );

      /// ✅ Copy for filtering
      filteredReturnOrders = List.from(returnOrders);

      print("✅ Parsed Return Orders Count => ${returnOrders.length}");
    } else {
      print("❌ API ERROR => ${data["message"]}");

      Get.snackbar(
        "Error",
        data["message"] ?? "Failed to fetch return orders",
      );
    }
  } catch (e, stack) {
    print("🚨 RETURN ERROR => $e");
    print("STACK TRACE => $stack");

    Get.snackbar("Error", "Failed to fetch return orders");
  } finally {
    isLoading = false;
    update();
    print("========== FETCH RETURNS END ==========");
  }
}
  /// ---------------- FETCH RETURN BY ID ----------------
  Future<ReturnOrder?> fetchReturnById(String id) async {
    try {
      isLoading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print("TOKEN => $token");

      final url = Uri.parse('$baseUrl/returns/$id');
      print("Fetching return order by ID: $id");
      print("GET Request URL: $url");

      final response = await http.get(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("STATUS => ${response.statusCode}");
      print("BODY => ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final returnOrder = ReturnOrder.fromJson(data['data']);
        print("Fetched Return Order: ${returnOrder.orderId}, Status: ${returnOrder.status}");
        return returnOrder;
      } else {
        Get.snackbar("Error", "Failed to fetch return order by ID");
      }
    } catch (e) {
      print("Error fetching return by id: $e");
      Get.snackbar("Error", "Failed to fetch return order");
    } finally {
      isLoading = false;
      update();
    }
    return null;
  }

  Future<bool> updateReturnStatus({
  required String returnId,
  required String status, // now use the status passed
  String? adminNotes,
  required String returnPaymentMethod, // cash | online
}) async {
  try {
    isLoading = true;
    update();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    if (token == null || token.isEmpty) {
      Get.snackbar("Error", "User not authenticated");
      return false;
    }

    /// ✅ Use status passed instead of fixed "refunded"
    final Map<String, dynamic> bodyMap = {
      "status": status,
      "adminNotes": adminNotes ?? "Items collected successfully",
      "returnPaymentMethod": returnPaymentMethod,
    };

    final String body = json.encode(bodyMap);
    final Uri url = Uri.parse('$baseUrl/returns/delivery-partner/$returnId/status');

    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    if (response.statusCode == 200) {
      /// ✅ Update local list
      int index = returnOrders.indexWhere((r) => r.id == returnId);
      if (index != -1) {
        returnOrders[index] = returnOrders[index].copyWith(
          status: status,
          adminNotes: adminNotes,
          returnPaymentMethod: returnPaymentMethod,
        );
        update();
      }

      Get.snackbar("Success", "Return marked as $status");
      return true;
    } else {
      final data = jsonDecode(response.body);
      Get.snackbar("Error", data["message"] ?? "Failed to update return status");
    }
  } catch (e) {
    Get.snackbar("Error", "Failed to update return status");
    print("Exception updating return: $e");
  } finally {
    isLoading = false;
    update();
  }

  return false;
}}