import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
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
  String userName = "User";

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
    fetchUserName();
    _initialLoad();
  }

  /// ================= INITIAL LOAD =================
  Future<void> _initialLoad() async {
    await Future.wait([
      orderController.fetchMyOrders(),
      returnOrderController.fetchReturns(),
      analyticsController.fetchAnalytics(),
    ]);
  }

  /// ================= PULL TO REFRESH =================
  Future<void> _onRefresh() async {
    if (selectedTab == 0) {
      await orderController.fetchMyOrders();
    } else {
      await returnOrderController.fetchReturns();
    }

    await analyticsController.fetchAnalytics();
  }

  /// ================= FETCH USER =================
  Future<void> fetchUserName() async {
    final prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString("name");

    setState(() {
      userName =
          (name != null && name.isNotEmpty) ? name : "User";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Padding(
              padding: EdgeInsets.only(bottom: 20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// ================= HEADER =================
                  Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 16.w, vertical: 14.h),
                    color: Colors.white,
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: _showLogoutSheet,
                          child: CircleAvatar(
                            radius: 22.r,
                            backgroundColor: const Color(0xff2F80ED),
                            child: Text(
                              userName[0].toUpperCase(),
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text("Welcome back",
                                  style: TextStyle(
                                      fontSize: 12.sp,
                                      color: Colors.grey)),
                              Text(userName,
                                  style: TextStyle(
                                      fontSize: 16.sp,
                                      fontWeight:
                                          FontWeight.w600)),
                            ],
                          ),
                        ),

                        GestureDetector(
                          onTap: () {
                            Get.to(() =>
                                const DeliveryPartnerActionsScreen());
                          },
                          child: Container(
                            padding: EdgeInsets.all(10.w),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(Icons.file_copy,
                                size: 22.sp),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1),

                  SizedBox(height: 20.h),

                  /// ================= ANALYTICS =================
                  Center(
                    child: Text(
                      "Today's Performance",
                      style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),

                  Padding(
                    padding: EdgeInsets.all(16.w),
                    child: GetBuilder<AnalyticsController>(
                      builder: (c) {
                        if (c.isLoading) {
                          return const Center(
                              child:
                                  CircularProgressIndicator());
                        }

                        final summary =
                            c.analytics?.data?.summary;

                        if (summary == null) {
                          return const Center(
                              child: Text("No analytics"));
                        }

                        return Row(
                          children: [
                            Expanded(
                                child: PerformanceCard(
                                    icon: Icons.check,
                                    iconColor: Colors.green,
                                    count:
                                        summary.completedOrders,
                                    label: "Done")),
                            SizedBox(width: 12.w),
                            Expanded(
                                child: PerformanceCard(
                                    icon: Icons.access_time,
                                    iconColor: Colors.orange,
                                    count:
                                        summary.pendingOrders,
                                    label: "Pending")),
                            SizedBox(width: 12.w),
                            Expanded(
                                child: PerformanceCard(
                                    icon: Icons.refresh,
                                    iconColor: Colors.red,
                                    count: summary
                                        .returnedOrdersCount,
                                    label: "Returns")),
                          ],
                        );
                      },
                    ),
                  ),

                  /// ================= TOGGLE =================
                  Container(
                    margin: EdgeInsets.all(16.w),
                    padding: EdgeInsets.all(4.w),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.circular(12.r)),
                    child: Row(
                      children: [
                        _toggleButton("Assigned Orders", 0),
                        _toggleButton("Return Orders", 1),
                      ],
                    ),
                  ),

                  /// ================= SEARCH =================
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.w),
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: "Search by Order ID",
                        prefixIcon:
                            const Icon(Icons.search),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(12.r),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onChanged: (value) {
                        if (selectedTab == 0) {
                          orderController.fetchMyOrders(
                              orderId: value.trim());
                        } else {
                          returnOrderController.fetchReturns(
                              orderId: value.trim());
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 12.h),

                  /// ================= ORDERS =================
                  selectedTab == 0
                      ? GetBuilder<OrderController>(
                          builder: (controller) {
                            if (controller.isLoading) {
                              return const Center(
                                  child:
                                      CircularProgressIndicator());
                            }

                            if (controller.orders.isEmpty) {
                              return const Center(
                                  child:
                                      Text("No Orders Found"));
                            }

                            return Column(
                              children: controller.orders
                                  .map((order) => Padding(
                                        padding:
                                            EdgeInsets.all(
                                                14.w),
                                        child: OrderCard(
                                          title: order.items
                                                  .isNotEmpty
                                              ? order
                                                  .items
                                                  .first
                                                  .product
                                                  .name
                                              : "No Item",
                                          orderId:
                                              order.orderNumber,
                                          branch: order
                                              .customerProfile
                                              .name,
                                          pickup:
                                              "Warehouse Pickup",
                                          delivery:
                                              "${order.shippingAddress.address}, ${order.shippingAddress.city}",
                                          earning:
                                              "QAR ${order.totalAmount}",
                                          status: order
                                                  .tracking
                                                  ?.status
                                                  .toUpperCase() ??
                                              order.status
                                                  .toUpperCase(),
                                          buttonText:
                                              "View Details",
                                          onPressed: () {
                                            Get.to(() =>
                                                OrderDetailsScreen(
                                                    order:
                                                        order));
                                          },
                                        ),
                                      ))
                                  .toList(),
                            );
                          },
                        )
                      : GetBuilder<ReturnOrderController>(
                          builder: (controller) {
                            if (controller.isLoading) {
                              return const Center(
                                  child:
                                      CircularProgressIndicator());
                            }

                            if (controller
                                .filteredReturnOrders
                                .isEmpty) {
                              return const Center(
                                  child: Text(
                                      "No Return Orders"));
                            }

                            return Column(
                              children: controller
                                  .filteredReturnOrders
                                  .map((e) => Padding(
                                        padding:
                                            EdgeInsets.all(
                                                14.w),
                                        child:
                                            ReturnOrderCard(
                                                returnOrder:
                                                    e),
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

          setState(() => selectedTab = index);

          if (index == 0) {
            orderController.fetchMyOrders();
          } else {
            returnOrderController.fetchReturns();
          }
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xff2F80ED)
                : Colors.transparent,
            borderRadius:
                BorderRadius.circular(10.r),
          ),
          child: Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive
                      ? Colors.white
                      : Colors.grey)),
        ),
      ),
    );
  }
}
class PerformanceCard extends StatelessWidget { final IconData icon; final Color iconColor; final int count; final String label; const PerformanceCard({ super.key, required this.icon, required this.iconColor, required this.count, required this.label, }); @override Widget build(BuildContext context) { return Container( padding: EdgeInsets.all(16.w), margin: EdgeInsets.only(bottom: 8.h), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(16.r), boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.05), blurRadius: 10.r, ), ], ), child: Column( children: [ CircleAvatar( radius: 20.r, backgroundColor: iconColor.withOpacity(0.15), child: Icon(icon, color: iconColor, size: 20.sp), ), SizedBox(height: 10.h), Text( "$count", style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold), ), SizedBox(height: 4.h), Text( label, style: TextStyle(fontSize: 12.sp, color: Colors.grey), ), ], ), ); } } // ================= LOGOUT SHEET ================= 
void _showLogoutSheet() { Get.bottomSheet( Container( padding: EdgeInsets.all(20.w), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.vertical( top: Radius.circular(18.r), ), ), child: Column( mainAxisSize: MainAxisSize.min, children: [ Container( height: 4.h, width: 40.w, margin: EdgeInsets.only(bottom: 16.h), decoration: BoxDecoration( color: Colors.grey.shade300, borderRadius: BorderRadius.circular(10.r), ), ), Text( "Account", style: TextStyle( fontSize: 18.sp, fontWeight: FontWeight.bold, ), ), SizedBox(height: 20.h), ListTile( leading: Icon(Icons.logout, color: Colors.red, size: 22.sp), title: Text( "Logout", style: TextStyle( fontSize: 15.sp, fontWeight: FontWeight.w600, color: Colors.red, ), ), onTap: () async { final prefs = await SharedPreferences.getInstance(); await prefs.clear(); Get.offAll(() => const EmailLoginScreen()); }, ), SizedBox(height: 10.h), ], ), ), ); }