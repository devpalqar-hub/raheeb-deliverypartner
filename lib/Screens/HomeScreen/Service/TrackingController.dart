import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/TrackingModel.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TrackingController extends GetxController {
  bool isLoading = false;
  TrackingResponse? tracking;

  final String baseUrl = "https://api.ecom.palqar.cloud/v1";

  String? currentOrderId;

  /// ==============================
  /// FETCH TRACKING DETAILS
  /// ==============================
  Future<void> fetchTracking(String orderId) async {
    try {
      currentOrderId = orderId;
      isLoading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final url = "$baseUrl/tracking/order/$orderId";

      print("========== TRACKING API REQUEST ==========");
      print("URL => $url");

      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      print("========== TRACKING API RESPONSE ==========");
      print("STATUS => ${response.statusCode}");
      print("BODY => ${response.body}");

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);

        tracking = TrackingResponse.fromJson(decoded);

        print("SUCCESS => ${tracking?.success}");
        print("TRACK STATUS => ${tracking?.data?.status}");
      } else {
        Get.snackbar("Error", "Failed to fetch tracking");
      }
    } catch (e, stack) {
      print("========== TRACKING ERROR ==========");
      print(e);
      print(stack);
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }

  /// ==============================
  /// CHANGE SINGLE ORDER STATUS
  /// ==============================
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

      final body = jsonEncode({
        "status": status,
        "paymentStatus": "completed",
      });

      print("========== SINGLE STATUS UPDATE REQUEST ==========");
      print("URL => $url");
      print("BODY => $body");

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("STATUS UPDATE RESPONSE => ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data["success"] == true) {
        Get.snackbar("Success", "Order status updated to $status");

        // Refresh tracking automatically
        if (currentOrderId != null) {
          await fetchTracking(currentOrderId!);
        }

        return true;
      } else {
        Get.snackbar(
          "Error",
          data["message"] ?? "Failed to update status",
        );
        return false;
      }
    } catch (e) {
      print("STATUS ERROR => $e");
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }
 Future<bool> changeBulkOrderStatus({
    required List<String> orderIds,
    required String status,
  }) async {
    try {
      isLoading = true;
      update();

      final prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString("token");

      final url = "$baseUrl/orders/delivery/bulk/status";

      final body = jsonEncode({
        "orderIds": orderIds,
        "status": status,
        "paymentStatus": "completed",
      });

      print("==== BULK STATUS UPDATE REQUEST ====");
      print("URL => $url");
      print("BODY => $body");

      final response = await http.patch(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: body,
      );

      print("BULK STATUS UPDATE RESPONSE => ${response.body}");

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar("Success", "Bulk order status updated to $status");
        return true;
      } else {
        // Handle message as String or List
        String errorMessage;
        if (data["message"] is List) {
          errorMessage = (data["message"] as List).join(", ");
        } else {
          errorMessage = data["message"] ?? "Failed to update bulk status";
        }

        Get.snackbar("Error", errorMessage);
        return false;
      }
    } catch (e) {
      print("BULK STATUS ERROR => $e");
      Get.snackbar("Error", e.toString());
      return false;
    } finally {
      isLoading = false;
      update();
    }
  }
}