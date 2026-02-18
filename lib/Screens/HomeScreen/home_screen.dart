import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/OrderModel.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AnalyticsController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AssignedController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/ReturnOrderController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/TrackingController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/DeliveryPartnerActionScreen.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/order_card.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/returnorder_card.dart';
import 'package:raheeb_deliverypartner/Screens/LoginScreen/LoginScreen.dart';
import 'package:raheeb_deliverypartner/Screens/orderdetails/order_details.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
  String userName = "User"; // Default fallback

  final OrderController orderController = Get.put(OrderController());
  final ReturnOrderController returnOrderController =
      Get.put(ReturnOrderController());
  final AnalyticsController analyticsController =
      Get.put(AnalyticsController());
  final TrackingController trackingController = Get.put(TrackingController());
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserName(); // Fetch saved username
    orderController.fetchMyOrders();
    returnOrderController.fetchReturns();
    analyticsController.fetchAnalytics();
  }

  // ================= FETCH USER NAME =================
  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? adminName = prefs.getString("name");
    setState(() {
      userName = (adminName != null && adminName.isNotEmpty) ? adminName : "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(bottom: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= HEADER =================
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  color: Colors.white,
                  child: Row(
                    children: [
                      GestureDetector(
                        onTap: _showLogoutSheet,
                        child: CircleAvatar(
                          radius: 22.r,
                          backgroundColor: const Color(0xff2F80ED),
                          child: Text(
                            userName.isNotEmpty ? userName[0].toUpperCase() : "U",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Welcome back",
                                style: TextStyle(
                                    fontSize: 12.sp, color: Colors.grey)),
                            SizedBox(height: 2.h),
                            Text(userName,
                                style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(() => const DeliveryPartnerActionsScreen());
                        },
                        child: Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.file_copy,
                            size: 22.sp,
                            color: Colors.black87,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                SizedBox(height: 20.h),

                Center(
                  child: Text(
                    "Today's Performance",
                    style:
                        TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
                  ),
                ),

                /// ================= ANALYTICS =================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                  child: GetBuilder<AnalyticsController>(
                    builder: (controller) {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      final summary = controller.analytics?.data?.summary;

                      if (summary == null) {
                        return const Center(child: Text("No analytics data"));
                      }

                      return Row(
                        children: [
                          Expanded(
                            child: PerformanceCard(
                              icon: Icons.check,
                              iconColor: Colors.green,
                              count: summary.completedOrders,
                              label: "Done",
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: PerformanceCard(
                              icon: Icons.access_time,
                              iconColor: Colors.orange,
                              count: summary.pendingOrders,
                              label: "Pending",
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: PerformanceCard(
                              icon: Icons.refresh,
                              iconColor: Colors.red,
                              count: summary.returnedOrdersCount,
                              label: "Returns",
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),

                /// ================= CHANGE STATUS BUTTON =================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton(
                      onPressed: _showChangeStatusSheet,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xff2F80ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Text(
                        "Change Status",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),

                /// ================= TOGGLE =================
                Container(
                  margin: EdgeInsets.all(16.w),
                  padding: EdgeInsets.all(4.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Row(
                    children: [
                      _toggleButton("Assigned Orders", 0),
                      _toggleButton("Return Orders", 1),
                    ],
                  ),
                ),

                /// ================= SEARCH FIELD =================
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: TextField(
                    controller: searchController,
                    decoration: InputDecoration(
                      hintText: "Search by Order ID",
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () {
                                searchController.clear();
                                if (selectedTab == 0) {
                                  orderController.fetchMyOrders();
                                } else {
                                  returnOrderController.fetchReturns();
                                }
                                setState(() {});
                              },
                            )
                          : null,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(
                          horizontal: 14.w, vertical: 12.h),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    onChanged: (value) {
                      if (value.trim().isEmpty) {
                        if (selectedTab == 0) {
                          orderController.fetchMyOrders();
                        } else {
                          returnOrderController.fetchReturns();
                        }
                      } else {
                        if (selectedTab == 0) {
                          orderController.fetchMyOrders(orderId: value.trim());
                        } else {
                          returnOrderController.fetchReturns(orderId: value.trim());
                        }
                      }
                    },
                  ),
                ),

                SizedBox(height: 10.h),

                /// ================= ORDERS LIST =================
                if (selectedTab == 0)
                  GetBuilder<OrderController>(
                    builder: (controller) {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.orders.isEmpty) {
                        return const Center(child: Text("No Orders Found"));
                      }
                      return Column(
                        children: controller.orders
                            .map((order) => Padding(
                                  padding: EdgeInsets.fromLTRB(16.w ,10.h,16.w,14.h),
                                  child: OrderCard(
                                    title: order.items.isNotEmpty
                                        ? order.items.first.product.name
                                        : "No Item",
                                    orderId: order.orderNumber,
                                    branch: order.customerProfile.name,
                                    pickup: "Warehouse Pickup",
                                    delivery:
                                        "${order.shippingAddress.address}, ${order.shippingAddress.city}",
                                    earning: "₹${order.totalAmount}",
                                    status: order.status.toUpperCase(),
                                    buttonText: "View Details",
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (_) =>
                                              OrderDetailsScreen(order: order),
                                        ),
                                      );
                                    },
                                  ),
                                ))
                            .toList(),
                      );
                    },
                  )
                else
                  GetBuilder<ReturnOrderController>(
                    builder: (controller) {
                      if (controller.isLoading) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (controller.filteredReturnOrders.isEmpty) {
                        return const Center(child: Text("No Return Orders Found"));
                      }
                      return Column(
                        children: controller.filteredReturnOrders
                            .map((returnOrder) => Padding(
                                  padding: EdgeInsets.only(bottom: 14.h),
                                  child: ReturnOrderCard(returnOrder: returnOrder),
                                ))
                            .toList(),
                      );
                    },
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ================= TOGGLE =================
  Widget _toggleButton(String title, int index) {
    final isActive = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xff2F80ED) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  // ================= CHANGE STATUS BOTTOM SHEET =================
  void _showChangeStatusSheet() {
    const List<String> backendStatuses = [
      "order_placed",
      "processing",
      "ready_to_ship",
      "shipped",
      "in_transit",
      "out_for_delivery",
      "delivered",
      "failed_delivery",
      "returned",
    ];

    String? selectedCurrent;
    String? selectedNew;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: EdgeInsets.all(16.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(18.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Change Status for Orders",
                  style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff101828)),
                ),
                SizedBox(height: 16.h),

                /// CURRENT STATUS DROPDOWN
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Current Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  ),
                  value: selectedCurrent,
                  items: backendStatuses
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedCurrent = val;
                    });
                  },
                ),

                SizedBox(height: 12.h),

                /// NEW STATUS DROPDOWN
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "New Status",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
                  ),
                  value: selectedNew,
                  items: backendStatuses
                      .map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedNew = val;
                    });
                  },
                ),

                SizedBox(height: 20.h),

                /// APPLY BUTTON
                SizedBox(
                  width: double.infinity,
                  height: 48.h,
                  child: ElevatedButton(
                    onPressed: selectedCurrent != null && selectedNew != null
                        ? () async {
                            // Determine order IDs based on selected tab
                            List<String> allOrderIds = selectedTab == 0
                                ? orderController.orders.map((e) => e.id).toList()
                                : returnOrderController.returnOrders
                                    .map((e) => e.orderId)
                                    .toList();

                            if (allOrderIds.isEmpty) {
                              Get.snackbar("Error", "No orders to update");
                              return;
                            }

                            // Filter orders by current status
                            List<String> orderIdsToUpdate = [];
                            if (selectedTab == 0) {
                              orderIdsToUpdate = orderController.orders
                                  .where((o) => o.status == selectedCurrent)
                                  .map((e) => e.id)
                                  .toList();
                            } else {
                              orderIdsToUpdate = returnOrderController.returnOrders
                                  .where((o) => o.status == selectedCurrent)
                                  .map((e) => e.orderId)
                                  .toList();
                            }

                            if (orderIdsToUpdate.isEmpty) {
                              Get.snackbar("Info",
                                  "No orders match the selected current status");
                              return;
                            }

                            // Call bulk status update
                            bool success = await trackingController
                                .changeBulkOrderStatus(
                                    orderIds: orderIdsToUpdate,
                                    status: selectedNew!);

                            if (success) {
                              if (selectedTab == 0) {
                                orderController.fetchMyOrders();
                              } else {
                                returnOrderController.fetchReturns();
                              }
                              Get.back();
                            }
                          }
                        : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1E5CC6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    child: Text(
                      "Apply",
                      style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    ),
                  ),
                ),

                SizedBox(height: 12.h),
              ],
            ),
          );
        },
      ),
    );
  }
}

// ================= PERFORMANCE CARD =================
class PerformanceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int count;
  final String label;

  const PerformanceCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      margin: EdgeInsets.only(bottom: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10.r,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 20.r,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor, size: 20.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            "$count",
            style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4.h),
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ================= LOGOUT SHEET =================
void _showLogoutSheet() {
  Get.bottomSheet(
    Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(18.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 4.h,
            width: 40.w,
            margin: EdgeInsets.only(bottom: 16.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          Text(
            "Account",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 20.h),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red, size: 22.sp),
            title: Text(
              "Logout",
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red,
              ),
            ),
            onTap: () async {
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              Get.offAll(() => const EmailLoginScreen());
            },
          ),
          SizedBox(height: 10.h),
        ],
      ),
    ),
  );
}
