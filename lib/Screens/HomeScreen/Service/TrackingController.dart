// import 'dart:convert';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;

// import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/OrderModel.dart';
// import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/ReturnOrderModel.dart';
// import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/TrackingModel.dart';
// import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AssignedController.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class TrackingController extends GetxController {
//   bool isLoading = false;
//   TrackingResponse? tracking;

//   final String baseUrl = "https://api.ecom.palqar.cloud/v1";

//   String? currentOrderId;

//   List<OrderModel> orders = [];
//   List<OrderModel> filteredOrders = [];

//   List<ReturnOrder> returnOrders = [];
//   List<ReturnOrder> filteredReturnOrders = [];

//   int currentPage = 1;
//   bool hasMoreOrders = true;

//   /// ==============================
//   /// FETCH TRACKING DETAILS
//   /// ==============================
//   Future<void> fetchTracking(String orderId) async {
//     try {
//       currentOrderId = orderId;
//       isLoading = true;
//       update();

//       final prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       final url = "$baseUrl/tracking/order/$orderId";

//       //print("========== TRACKING API REQUEST ==========");
//       //print("URL => $url");

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       //print("========== TRACKING API RESPONSE ==========");
//       //print("STATUS => ${response.statusCode}");
//       //print("BODY => ${response.body}");

//       if (response.statusCode == 200) {
//         final decoded = jsonDecode(response.body);

//         tracking = TrackingResponse.fromJson(decoded);

//         //print("SUCCESS => ${tracking?.success}");
//         //print("TRACK STATUS => ${tracking?.data?.status}");
//       } else {
//         Get.snackbar("Error", "Failed to fetch tracking");
//       }
//     } catch (e, stack) {
//       //print("========== TRACKING ERROR ==========");
//       print(e);
//       print(stack);
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }

//   /// ==============================
//   /// CHANGE SINGLE ORDER STATUS
//   /// ==============================
//   Future<bool> changeOrderStatus({
//     required String orderId,
//     required String status,
//   }) async {
//     try {
//       isLoading = true;
//       update();

//       final prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       final url = "$baseUrl/orders/delivery/$orderId/status";


//       final response = await http.patch(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: jsonEncode({"status": status, "paymentStatus": "completed"}),
//       );

//       //print("STATUS UPDATE RESPONSE => ${response.body}");

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         Get.snackbar("Success", "Order status updated to $status");

//         // Refresh tracking automatically
//         if (currentOrderId != null) {
//           await fetchTracking(currentOrderId!);
//         }

//         return true;
//       } else {
//         Get.snackbar("Error", data["message"] ?? "Failed to update status");
//         return false;
//       }
//     } catch (e) {
//       //print("STATUS ERROR => $e");
//       Get.snackbar("Error", e.toString());
//       return false;
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }

  

//   Future<void> fetchMyOrders({
//     String? orderId,
//     int page = 1,
//     int limit = 10,
//   }) async {
//     try {
//       if (page == 1) isLoading = true;
//       update();

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("token");

//       String url =
//           "$baseUrl/orders/delivery-partner/my-orders?page=$page&limit=$limit";

//       if (orderId != null && orderId.isNotEmpty) {
//         url += "&orderId=$orderId";
//       }

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         List<OrderModel> fetched = (data["data"]["data"] as List)
//             .map((e) => OrderModel.fromJson(e))
//             .toList();

//         if (page == 1) {
//           orders = fetched;
//         } else {
//           orders.addAll(fetched);
//         }

//         filteredOrders = List.from(orders);
//         hasMoreOrders = fetched.length == limit;
//         currentPage = page;
//         await fetchMyOrders();
//         await fetchReturns();
//       } else {
//         Get.snackbar("Error", data["message"]);
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }

//   Future<void> fetchReturns({
//     String? orderId,
//     int page = 1,
//     int limit = 20,
//   }) async {
//     try {
//       isLoading = true;
//       update();

//       final prefs = await SharedPreferences.getInstance();
//       final token = prefs.getString("token");

//       if (token == null || token.isEmpty) {
//         Get.snackbar("Session Expired", "Please login again");
//         return;
//       }

//       String url =
//           "$baseUrl/returns/delivery-partner/my-returns?page=$page&limit=$limit";

//       if (orderId != null && orderId.isNotEmpty) {
//         url += "&orderId=$orderId";
//       }

//       final response = await http.get(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         final List<dynamic> list = data['data']?['data'] ?? [];

//         returnOrders = list.map((e) => ReturnOrder.fromJson(e)).toList();

//         filteredReturnOrders = List.from(returnOrders);
//       } else {
//         Get.snackbar("Error", data["message"] ?? "Failed to fetch returns");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }
// }
