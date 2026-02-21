import 'dart:convert';
import 'dart:developer';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:http/http.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/OrderModel.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/ReturnOrderModel.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/Service/LoginController.dart';

String baseUrl = "https://api.raheeb.qa/v1";

class deliveryController extends GetxController {
  List<ReturnOrder> pendingReturns = [];
  List<OrderModel> pendingOrders = [];
  bool returnLoading = false;
  bool isLoading = false;
  OrderModel? selectedOrder;
  bool orderDetailsLoader = false;
  bool pageloader = false;
  String searchText = "";

  fetchPendingDelivery() async {
    pendingOrders = [];
    pageloader = true;
    update();
    final response = await get(
      Uri.parse(
        baseUrl +
            "/orders/delivery-partner/my-orders?page=1&limit=120&pending=true",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $Authtoken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var body = json.decode(response.body);
      for (var data in body["data"]["data"]) {
        pendingOrders.add(OrderModel.fromJson(data));
      }
      update();
    }
    pageloader = false;
    update();
  }

  fetchPendingReturns() async {
    pendingReturns = [];
    pageloader = true;
    update();
    final response = await get(
      Uri.parse(
        baseUrl +
            "/returns/delivery-partner/my-returns?limit=120&page=1&status=pending",
      ),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $Authtoken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      var body = json.decode(response.body);

      for (var data in body["data"]["data"]) {
        pendingReturns.add(ReturnOrder.fromJson(data));
      }
      update();
    }
    pageloader = false;
    update();
  }

  Future<bool> changeBulkOrderStatus({
    required String fromStatus,
    required String toStatus,
  }) async {
    isLoading = true;
    update();

    final response = await patch(
      Uri.parse("$baseUrl/orders/delivery/bulk/status"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $Authtoken",
      },
      body: jsonEncode({
        "fromTrackingStatus": fromStatus,
        "toTrackingStatus": toStatus,
        "paymentStatus": "completed",
      }),
    );

    final data = jsonDecode(response.body);
    isLoading = false;
    update();
    log(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      fetchPendingDelivery();
      return true;
    } else {
      Fluttertoast.showToast(msg: data["message"] ?? "failed to process");
      return false;
    }
  }

  Future<bool> updateReturnStatus({
    required String returnId,
    required String status, // now use the status passed
    String? adminNotes,
    required String returnPaymentMethod, // cash | online
  }) async {
    returnLoading = true;
    update();

    final response = await patch(
      Uri.parse('$baseUrl/returns/delivery-partner/$returnId/status'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $Authtoken",
      },
      body: json.encode({
        "status": status,
        "adminNotes": adminNotes ?? "Items collected successfully",
        if (returnPaymentMethod != "none")
          "returnPaymentMethod": returnPaymentMethod,
      }),
    );
    log(
      json.encode({
        "status": status,
        "adminNotes": adminNotes ?? "Items collected successfully",
        if (returnPaymentMethod != "none")
          "returnPaymentMethod": returnPaymentMethod,
      }),
    );
    log(response.body);

    if (response.statusCode == 200) {
      fetchPendingReturns();
      return true;
    } else {
      final data = jsonDecode(response.body);
      Fluttertoast.showToast(
        msg: data["message"] ?? "Failed to update return status",
      );
    }

    returnLoading = false;
    update();

    return false;
  }

  Future<bool> changeOrderStatus({
    required String orderId,
    required String status,
    bool updateLocally = true,
  }) async {
    isLoading = true;
    update();

    final response = await patch(
      Uri.parse("$baseUrl/orders/delivery/$orderId/status"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $Authtoken",
      },
      body: jsonEncode({"status": status, "paymentStatus": "completed"}),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200 && data["success"] == true) {
      selectedOrder!.tracking.status = status;
      Fluttertoast.showToast(msg: "Order Status updated");
      isLoading = false;
      update();
      fetchPendingDelivery();
      return true;
    } else {
      Fluttertoast.showToast(msg: data["message"] ?? "Failed to update status");
      isLoading = false;
      update();
      return false;
    }
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    fetchPendingReturns();
    fetchPendingDelivery();
  }
}
