import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Model/ReturnOrderModel.dart';

class ReturnOrderController extends GetxController {
  bool isLoading = false;
  List<ReturnOrder> returnOrders = [];

  final String baseUrl = "https://api.ecom.palqar.cloud/v1";

  @override
  void onInit() {
    fetchReturns();
    super.onInit();
  }

  /// ---------------- FETCH ALL RETURNS ----------------
  Future<void> fetchReturns() async {
    try {
      isLoading = true;
      update(); // notify UI

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");
      print("TOKEN => $token");

      final url = Uri.parse('$baseUrl/returns/delivery-partner/my-returns');
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
        final List<dynamic> list = data['data']['data'] ?? [];
        returnOrders = list.map((e) => ReturnOrder.fromJson(e)).toList();
        print("Parsed Return Orders Count: ${returnOrders.length}");
      } else {
        Get.snackbar("Error", "Failed to fetch return orders");
      }
    } catch (e) {
      print("Error fetching returns: $e");
      Get.snackbar("Error", "Failed to fetch return orders");
    } finally {
      isLoading = false;
      update();
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

  /// ---------------- UPDATE RETURN STATUS ----------------
 Future<bool> updateReturnStatus({
  required String returnId,
  required String status,
  String? adminNotes,
  required String returnPaymentMethod, // ✅ ADD THIS
}) async {
  try {
    isLoading = true;
    update();

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString("token");

    /// ✅ FORCE STATUS
    const String fixedStatus = "picked_up";

    /// ✅ Request Body
    final bodyMap = {
      "status": fixedStatus,
      "adminNotes": adminNotes ?? "Items collected successfully",
      "returnPaymentMethod": returnPaymentMethod, // cash | online
    };

    final body = json.encode(bodyMap);

    final url =
        Uri.parse('$baseUrl/returns/delivery-partner/$returnId/status');

    print("===== UPDATE RETURN STATUS REQUEST =====");
    print("URL: $url");
    print("BODY: $body");
    print("========================================");

    final response = await http.patch(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: body,
    );

    print("===== RESPONSE =====");
    print("STATUS CODE: ${response.statusCode}");
    print("BODY: ${response.body}");
    print("====================");

    if (response.statusCode == 200) {
      /// ✅ Update local list
      int index = returnOrders.indexWhere((r) => r.id == returnId);

      if (index != -1) {
        returnOrders[index] = returnOrders[index].copyWith(
          status: fixedStatus,
          adminNotes: adminNotes,
          returnPaymentMethod: returnPaymentMethod,
        );
        update();
      }

      Get.snackbar("Success", "Return marked as Picked Up");
      return true;
    } else {
      final data = jsonDecode(response.body);
      Get.snackbar(
        "Error",
        data["message"] ?? "Failed to update return status",
      );
    }
  } catch (e) {
    print("Error updating return status: $e");
    Get.snackbar("Error", "Failed to update return status");
  } finally {
    isLoading = false;
    update();
  }

  return false;
}}