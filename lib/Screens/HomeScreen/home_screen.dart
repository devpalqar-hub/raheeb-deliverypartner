import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AnalyticsController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AssignedController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/DeliveryController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/ReturnOrderController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/TrackingController.dart';
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
  String userName = "User";

  final ReturnOrderController returnOrderController = Get.put(
    ReturnOrderController(),
  );

  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUserName();
  }

  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");

    setState(() {
      userName = (name != null && name.isNotEmpty) ? name : "User";
    });
  }

  deliveryController t = Get.put(deliveryController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            GestureDetector(
              onTap: _showLogoutSheet,
              child: CircleAvatar(
                radius: 18.r,
                backgroundColor: const Color(0xff2F80ED),
                child: Text(
                  userName[0].toUpperCase(),
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
                  Text(
                    "Welcome back",
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                  Text(
                    userName,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          InkWell(
            onTap: () {
              _showChangeStatusSheet();
            },
            child: Icon(
              Icons.change_circle,
              color: Colors.blue.withOpacity(.7),
              size: 32,
            ),
          ),
          SizedBox(width: 10),
          // InkWell(
          //   onTap: () {
          //     //  Get.to(() => const DeliveryPartnerActionsScreen());
          //   },
          //   child: CircleAvatar(
          //     backgroundColor: Colors.blue.withOpacity(.7),
          //     radius: 15,
          //     child: Icon(Icons.history, color: Colors.white, size: 18),
          //   ),
          // ),

          //          SizedBox(width: 10),
        ],
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            print("refeshing");
            await t.fetchPendingDelivery();
            await t.fetchPendingReturns();
          },
          child: GetBuilder<deliveryController>(
            builder: (context) {
              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: EdgeInsets.only(bottom: 20.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// ================= HEADER =================
                      SizedBox(height: 8.h),
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

                      /// ================= SEARCH =================
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 16.w),
                        child: TextField(
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Search by Order ID",
                            prefixIcon: const Icon(Icons.search),
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onChanged: (value) {
                            t.searchText = value;
                            t.update();
                          },
                        ),
                      ),

                      SizedBox(height: 12.h),

                      if (t.pageloader)
                        Container(
                          height: 60,
                          width: double.infinity,
                          child: Center(child: CircularProgressIndicator()),
                        )
                      else ...[
                        if (selectedTab == 0) ...[
                          for (var order in t.pendingOrders)
                            if (order.orderNumber.contains(t.searchText) ||
                                t.searchText.isEmpty)
                              OrderCard(
                                title: order.items.isNotEmpty
                                    ? order.items.first.product.name
                                    : "No Item",
                                orderId: order.orderNumber,
                                branch: order.customerProfile.name,
                                pickup: "Warehouse Pickup",
                                delivery:
                                    "${order.shippingAddress.address}, ${order.shippingAddress.city}",
                                earning: "QAR ${order.totalAmount}",
                                status:
                                    order.tracking?.status.toUpperCase() ??
                                    order.status.toUpperCase(),
                                buttonText: "View Details",
                                onPressed: () {
                                  Get.to(
                                    () => OrderDetailsScreen(order: order),
                                  );
                                },
                              ),

                          if (t.pendingOrders.isEmpty ||
                              t.pendingOrders
                                  .where(
                                    (it) =>
                                        it.orderNumber.contains(t.searchText),
                                  )
                                  .isEmpty)
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LottieBuilder.asset(
                                    "assets/NodataFound.json",
                                    width: 250.w,
                                  ),
                                  Text(
                                    "No Orders Founds",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Please get back later",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],

                        if (selectedTab == 1) ...[
                          for (var order in t.pendingReturns)
                            if (order.order.orderNumber.contains(
                                  t.searchText,
                                ) ||
                                t.searchText.isEmpty)
                              ReturnOrderCard(returnOrder: order),

                          if (t.pendingReturns.isEmpty ||
                              t.pendingReturns
                                  .where(
                                    (it) => it.order.orderNumber.contains(
                                      t.searchText,
                                    ),
                                  )
                                  .isEmpty)
                            Container(
                              width: double.infinity,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  LottieBuilder.asset(
                                    "assets/NodataFound.json",
                                    width: 250.w,
                                  ),
                                  Text(
                                    "No Orders Founds",
                                    style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  Text(
                                    "Please get back later",
                                    style: TextStyle(
                                      fontSize: 12.sp,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                        ],
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  /// ================= TOGGLE =================
  Widget _toggleButton(String title, int index) {
    final isActive = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (selectedTab == index) return;

          if (index == 0) {
            t.fetchPendingDelivery();
          } else {
            t.fetchPendingReturns();
          }

          setState(() => selectedTab = index);
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive ? const Color(0xff2F80ED) : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isActive ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  /// ================= CHANGE STATUS SHEET =================
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
      isScrollControlled: true,
      SafeArea(
        child: StatefulBuilder(
          builder: (context, setState) {
            return Container(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 30.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// ===== DRAG HANDLE =====
                  Container(
                    height: 5.h,
                    width: 45.w,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  /// ===== TITLE & SUBTITLE =====
                  Text(
                    "Update Order Status",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xff101828),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    "Select the current status and the new status to update orders in bulk.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  SizedBox(height: 28.h),

                  /// ===== CURRENT STATUS DROPDOWN =====
                  _buildDropdownLabel("From Current Status"),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: TextStyle(fontSize: 15.sp, color: Colors.black),
                    decoration: _dropdownDecoration("Select status"),
                    value: selectedCurrent,
                    items: backendStatuses
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.replaceAll("_", " ").toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedCurrent = val),
                  ),

                  SizedBox(height: 20.h),

                  /// ===== NEW STATUS DROPDOWN =====
                  _buildDropdownLabel("To New Status"),
                  DropdownButtonFormField<String>(
                    dropdownColor: Colors.white,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    style: TextStyle(fontSize: 15.sp, color: Colors.black),
                    decoration: _dropdownDecoration("Select target status"),
                    value: selectedNew,
                    items: backendStatuses
                        .map(
                          (s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.replaceAll("_", " ").toUpperCase()),
                          ),
                        )
                        .toList(),
                    onChanged: (val) => setState(() => selectedNew = val),
                  ),

                  SizedBox(height: 32.h),

                  /// ===== APPLY BUTTON =====
                  SizedBox(
                    width: double.infinity,
                    height: 54.h,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (selectedCurrent == null && selectedNew == null) {
                          Fluttertoast.showToast(
                            msg: "Please select both status to continue",
                          );
                        }
                        t.changeBulkOrderStatus(
                          fromStatus: selectedCurrent!,
                          toStatus: selectedNew!,
                        );
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2F80ED),
                        disabledBackgroundColor: Colors.grey.shade300,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                      ),
                      child: Text(
                        "Update Status Now",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  /// Helper widget for clean labels
  Widget _buildDropdownLabel(String label) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h, left: 4.w),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: const Color(0xff344054),
          ),
        ),
      ),
    );
  }

  /// Helper for consistent dropdown decoration
  InputDecoration _dropdownDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12.r),
        borderSide: const BorderSide(color: Color(0xff2F80ED), width: 1.5),
      ),
    );
  }
}

/// ================= HELPER WIDGETS AND FUNCTIONS =================

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
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10.r),
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

/// ================= LOGOUT SHEET =================
void _showLogoutSheet() {
  Get.bottomSheet(
    SafeArea(
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
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
              style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
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
    ),
  );
}
