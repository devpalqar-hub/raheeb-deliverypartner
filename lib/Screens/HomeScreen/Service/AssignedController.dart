// import 'dart:convert';
// import 'dart:developer';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/DeliveryPartnerModel.dart';
// import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/OrderModel.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class OrderController extends GetxController {
//   bool isLoading = false;
//   List<OrderModel> orders = [];
//   List<OrderModel> filteredOrders = [];

//   List<DeliveryPartnerModel> deliveryPartners = [];
//   List<DeliveryPartnerModel> filteredPartners = [];
//   bool isPartnerLoading = false;

//   Map<String, dynamic> summary = {};
//   Map<String, dynamic> partner = {};
//   Map<String, dynamic> dateRange = {};
//   List<dynamic> recentOrders = [];

//   final TextEditingController searchController = TextEditingController();
//   final TextEditingController orderSearchController = TextEditingController();

//   final String baseUrl = "https://api.ecom.palqar.cloud/v1";

//   int currentPage = 1;
//   int limit = 10;
//   bool hasMoreOrders = true;

//   @override
//   void onInit() {
//     super.onInit();
//     fetchMyOrders(page: 1);
//     fetchAnalytics();
//     fetchDeliveryPartners();
//   }

//   // ================= SEARCH ORDERS =================
//   void searchOrders(String query) {
//     if (query.isEmpty) {
//       filteredOrders = orders;
//     } else {
//       filteredOrders = orders.where((order) {
//         return order.orderNumber.toLowerCase().contains(query.toLowerCase());
//       }).toList();
//     }
//     update();
//   }

//   // ================= SEARCH PARTNERS =================
//   void searchPartners(String query) {
//     if (query.isEmpty) {
//       filteredPartners = deliveryPartners;
//     } else {
//       filteredPartners = deliveryPartners.where((p) {
//         final name = (p.name ?? "").toLowerCase();
//         final email = (p.email ?? "").toLowerCase();
//         return name.contains(query.toLowerCase()) ||
//             email.contains(query.toLowerCase());
//       }).toList();
//     }
//     update();
//   }

//   // ================= FETCH DELIVERY PARTNERS =================
//   Future<void> fetchDeliveryPartners() async {
//     try {
//       isPartnerLoading = true;
//       update();

//       final prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       final response = await http.get(
//         Uri.parse("$baseUrl/delivery-partners"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         deliveryPartners = (data["data"] as List)
//             .map((e) => DeliveryPartnerModel.fromJson(e))
//             .toList();
//         filteredPartners = deliveryPartners;
//       } else {
//         Get.snackbar("Error", "Failed to load partners");
//       }
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isPartnerLoading = false;
//       update();
//     }
//   }

//   // ================= FETCH ORDERS WITH PAGINATION =================
//   Future<void> fetchMyOrders({
//     String? orderId,
//     int page = 1,
//     int limit = 10,
//   }) async {
//     isLoading = true;
//     update();
//     try {
//       if (page == 1) {
//         isLoading = true;
//       }
//       update();

//       final prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       String url =
//           "$baseUrl/orders/delivery-partner/my-orders?page=$page&limit=$limit&pending=true";
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
//       log(response.body);
//       if (response.statusCode == 200 && data["success"] == true) {
//         List<OrderModel> fetchedOrders = (data["data"]["data"] as List)
//             .map((e) => OrderModel.fromJson(e))
//             .toList();

//         if (page == 1) {
//           orders = fetchedOrders;
//         } else {
//           orders.addAll(fetchedOrders);
//         }

//         filteredOrders = orders;
//         hasMoreOrders = fetchedOrders.length == limit;
//         currentPage = page;
//       } else {
//         Get.snackbar("Error", data["message"] ?? "Failed to load orders");
//       }
//     } catch (e, stack) {
//       //print("ORDER ERROR => $e");
//       print(stack);
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }

//   // ================= CHANGE ORDER STATUS =================
//   Future<bool> changeOrderStatus({
//     required String orderId,
//     required String status,
//     bool updateLocally = true,
//   }) async {
//     try {
//       isLoading = true;
//       update();

//       final prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       final url = "$baseUrl/orders/delivery/$orderId/status";
//       final body = jsonEncode({"status": status, "paymentStatus": "completed"});

//       final response = await http.patch(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: body,
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         Get.snackbar("Success", "Order status updated to $status");

//         if (updateLocally) {
//           // update local list immediately
//           int index = orders.indexWhere((o) => o.id == orderId);

//           if (index != -1) {
//             // create updated copy
//             //final updatedOrder = orders[index].copyWith(status: status);

//             // replace item (important)
//           //  orders[index] = updatedOrder;

//             // force new list reference
//             orders = List.from(orders);
//             filteredOrders = List.from(orders);

//             update();
//           }
//         } else {
//           await fetchMyOrders();
//         }

//         return true;
//       } else {
//         Get.snackbar("Error", data["message"] ?? "Failed to update status");
//         return false;
//       }
//     } catch (e, stack) {
//       //print("STATUS UPDATE ERROR => $e");
//       print(stack);
//       Get.snackbar("Error", e.toString());
//       return false;
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }

//   // ================= FETCH ANALYTICS =================
//   Future<void> fetchAnalytics() async {
//     try {
//       final prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       final response = await http.get(
//         Uri.parse("$baseUrl/delivery-partners/analytics/stats"),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         partner = data["data"]["partner"] ?? {};
//         summary = data["data"]["summary"] ?? {};
//         dateRange = data["data"]["dateRange"] ?? {};
//         recentOrders = data["data"]["recentOrders"] ?? [];
//         update();
//       } else {
//         Get.snackbar("Error", "Failed to load analytics");
//       }
//     } catch (e) {
//       //print("ANALYTICS ERROR => $e");
//       Get.snackbar("Error", e.toString());
//     }
//   }

//   // ================= ASSIGN DELIVERY PARTNER =================
//   Future<bool> assignDeliveryPartner({
//     required String orderId,
//     required String deliveryPartnerId,
//     String notes = "",
//   }) async {
//     try {
//       isLoading = true;
//       update();

//       final prefs = await SharedPreferences.getInstance();
//       String? token = prefs.getString("token");

//       final url = "$baseUrl/orders/$orderId/assign-delivery-partner";
//       final body = jsonEncode({
//         "deliveryPartnerId": deliveryPartnerId,
//         "notes": notes,
//       });

//       final response = await http.patch(
//         Uri.parse(url),
//         headers: {
//           "Content-Type": "application/json",
//           "Authorization": "Bearer $token",
//         },
//         body: body,
//       );

//       final data = jsonDecode(response.body);

//       if (response.statusCode == 200 && data["success"] == true) {
//         await fetchMyOrders(page: 1); // refresh orders list
//         return true;
//       } else {
//         return false;
//       }
//     } catch (e, stack) {
//       //print("ASSIGN PARTNER ERROR => $e");
//       print(stack);
//       return false;
//     } finally {
//       isLoading = false;
//       update();
//     }
//   }
// }
