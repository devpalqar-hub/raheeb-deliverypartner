import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../Service/TrackingController.dart';

class DeliveryPartnerActionsScreen extends StatefulWidget {
  const DeliveryPartnerActionsScreen({super.key});

  @override
  State<DeliveryPartnerActionsScreen> createState() =>
      _DeliveryPartnerActionsScreenState();
}

class _DeliveryPartnerActionsScreenState
    extends State<DeliveryPartnerActionsScreen> {
  final TrackingController controller =
      Get.put(TrackingController());

  @override
  void initState() {
    super.initState();

    /// ✅ fetch delivery actions
    Future.microtask(() {
      controller.fetchDeliveryActions();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      appBar: AppBar(
        title: const Text("History of Actions"),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),

      body: GetBuilder<TrackingController>(
        builder: (controller) {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return RefreshIndicator(
            onRefresh: () =>
                controller.fetchDeliveryActions(),
            child: ListView(
              padding: EdgeInsets.all(16.w),
              children: [

                /// ================= ORDERS =================
                Text(
                  "Orders",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),

                if (controller.actionOrders.isEmpty)
                  _emptyWidget("No Order Actions"),

                ...controller.actionOrders
                    .map((order) => _orderCard(order)),

                SizedBox(height: 25.h),

                /// ================= RETURNS =================
                Text(
                  "Returns",
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12.h),

                if (controller.actionReturns.isEmpty)
                  _emptyWidget("No Return Actions"),

                ...controller.actionReturns
                    .map((ret) => _returnCard(ret)),
              ],
            ),
          );
        },
      ),
    );
  }

  /// =====================================================
  /// ORDER CARD
  /// =====================================================
  Widget _orderCard(order) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping,
              color: Colors.green),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderNumber,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  order.customerProfile.name,
                  style: TextStyle(fontSize: 13.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Status : ${order.tracking.status}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          _statusChip(order.status),
        ],
      ),
    );
  }

  /// =====================================================
  /// RETURN CARD
  /// =====================================================
  Widget _returnCard(ret) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 4)
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.assignment_return,
              color: Colors.orange),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  ret.order.orderNumber,
                  style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  ret.customerProfile.name,
                  style: TextStyle(fontSize: 13.sp),
                ),
                SizedBox(height: 4.h),
                Text(
                  "Refund : ₹${ret.refundAmount}",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          _statusChip(ret.status),
        ],
      ),
    );
  }

  /// =====================================================
  /// STATUS CHIP
  /// =====================================================
  Widget _statusChip(String status) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        status.replaceAll("_", " ").toUpperCase(),
        style: TextStyle(
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
          color: Colors.green,
        ),
      ),
    );
  }

  /// =====================================================
  /// EMPTY
  /// =====================================================
  Widget _emptyWidget(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Center(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}