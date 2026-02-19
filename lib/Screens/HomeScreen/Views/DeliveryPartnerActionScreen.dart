import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/TrackingController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/order_card.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/returnorder_card.dart';
import 'package:raheeb_deliverypartner/Screens/orderdetails/order_details.dart';

class DeliveryPartnerActionsScreen extends StatefulWidget {
  const DeliveryPartnerActionsScreen({super.key});

  @override
  State<DeliveryPartnerActionsScreen> createState() =>
      _DeliveryPartnerActionsScreenState();
}

class _DeliveryPartnerActionsScreenState
    extends State<DeliveryPartnerActionsScreen> {

  final TrackingController controller = Get.put(TrackingController());

  /// ✅ Toggle state
  bool showOrders = true;

  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await controller.fetchMyOrders();
      await controller.fetchReturns();
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
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.fetchMyOrders();
              await controller.fetchReturns();
            },

            child: Column(
              children: [

                /// ================= TOGGLE =================
                /// ================= TEXT TOGGLE =================
Container(
  padding: EdgeInsets.symmetric(vertical: 14.h),
  margin: EdgeInsets.symmetric(horizontal: 16.w),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [

      /// ORDERS
      GestureDetector(
        onTap: () {
          if (!showOrders) {
            setState(() => showOrders = true);
          }
        },
        child: Column(
          children: [
            Text(
              "Orders",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: showOrders
                    ? const Color(0xff2F80ED)
                    : Colors.grey,
              ),
            ),
            SizedBox(height: 6.h),

            /// underline indicator
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: showOrders ? 40.w : 0,
              decoration: BoxDecoration(
                color: const Color(0xff2F80ED),
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),

      SizedBox(width: 40.w),

      /// RETURNS
      GestureDetector(
        onTap: () {
          if (showOrders) {
            setState(() => showOrders = false);
          }
        },
        child: Column(
          children: [
            Text(
              "Returns",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: !showOrders
                    ? const Color(0xff2F80ED)
                    : Colors.grey,
              ),
            ),
            SizedBox(height: 6.h),

            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              height: 3,
              width: !showOrders ? 40.w : 0,
              decoration: BoxDecoration(
                color: const Color(0xff2F80ED),
                borderRadius: BorderRadius.circular(10),
              ),
            )
          ],
        ),
      ),
    ],
  ),
),

                /// ================= LIST =================
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),

                    children: [

                      /// -------- ORDERS --------
                      if (showOrders) ...[
                        if (controller.filteredOrders.isEmpty)
                          _emptyWidget("No Orders"),

                        ...controller.filteredOrders.map((order) {
                          final firstItem =
                              order.items.isNotEmpty
                                  ? order.items.first
                                  : null;

                          return OrderCard(
                            title:
                                firstItem?.product.name ?? "Order",
                            orderId: order.orderNumber,
                            branch: order.shippingAddress.city,
                            pickup: order.shippingAddress.address,
                            delivery:
                                "${order.customerProfile.name} - ${order.customerProfile.phone}",
                            earning: "₹${order.totalAmount}",
                            status: order.status,

                            /// ✅ no button
                            buttonText: "View Details",
                            onPressed: () { Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              OrderDetailsScreen(order: order),
                                        ),
                                      );}
                          );
                        }),
                      ],

                      /// -------- RETURNS --------
                      if (!showOrders) ...[
                        if (controller.filteredReturnOrders.isEmpty)
                          _emptyWidget("No Returns"),

                        ...controller.filteredReturnOrders.map((ret) {
                          return ReturnOrderCard(
                            returnOrder: ret,
                          );
                        }),
                      ],

                      SizedBox(height: 20.h),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  /// EMPTY STATE
  Widget _emptyWidget(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 40.h),
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