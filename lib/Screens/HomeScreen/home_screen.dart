import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/simple/get_state.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AssignedController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/order_card.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/returnorder_card.dart';
import 'package:raheeb_deliverypartner/Screens/orderdetails/order_details.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedTab = 0;
final OrderController orderController =
    Get.put(OrderController());
  /// ---------------- ORDERS ----------------
  final List<Map<String, dynamic>> orders = [
    {
      "title": "Burger King",
      "orderId": "#OD-4923",
      "branch": "Downtown Branch",
      "pickup": "124 Main Street, West Side",
      "delivery": "Apartment 4B, 892 Broadway",
      "earning": "\$8.50",
      "status": "ASSIGNED",
    },
    {
      "title": "Rose Garden Florist",
      "orderId": "#OD-5102",
      "branch": "East Village",
      "pickup": "45 Flower Ave, Suite 2",
      "delivery": "77 Sunset Blvd, House 12",
      "earning": "\$12.00",
      "status": "QUEUED",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Column(
          children: [

            /// -------- PROFILE HEADER --------
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage:
                        const AssetImage("assets/images/profile.png"),
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back",
                        style:
                            TextStyle(fontSize: 12.sp, color: Colors.grey),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        "Reema Salam",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            /// -------- TOGGLE --------
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

            /// -------- BODY --------
            Expanded(
              child: selectedTab == 0
                  ? _assignedOrders()
                  : _returnOrders(),
            ),
          ],
        ),
      ),
    );
  }

  /// ================= TOGGLE BUTTON =================
  Widget _toggleButton(String title, int index) {
    final isActive = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => selectedTab = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color:
                isActive ? const Color(0xff2F80ED) : Colors.transparent,
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

  Widget _assignedOrders() {
  return GetBuilder<OrderController>(
    builder: (orderController) {

      /// ---------- LOADING ----------
      if (orderController.isLoading) {
        return const Center(child: CircularProgressIndicator());
      }

      /// ---------- EMPTY ----------
      if (orderController.orders.isEmpty) {
        return const Center(child: Text("No Orders Found"));
      }

      /// ---------- LIST ----------
      return ListView(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        children: [

          SizedBox(height: 16.h),

          ...orderController.orders.map((order) {
            return Padding(
              padding: EdgeInsets.only(bottom: 14.h),
              child: OrderCard(
                title: order.productName,
                orderId: order.orderNumber,
                branch: order.customerName,
                pickup: "Warehouse Pickup",
                delivery: "${order.address}, ${order.city}",
                earning: "₹${order.totalAmount}",
                status: order.status.toUpperCase(),

                buttonText:
                    order.trackingStatus == "out_for_delivery"
                        ? "Start Task"
                        : "View Details",

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
            );
          }).toList(),

          /// ---------- PERFORMANCE ----------
          SizedBox(height: 24.h),

          Text(
            "Today's Performance",
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),

          SizedBox(height: 16.h),

          Row(
            children: const [
              Expanded(
                child: PerformanceCard(
                    icon: Icons.check,
                    iconColor: Colors.green,
                    count: 12,
                    label: "Done"),
              ),
              SizedBox(width: 12),
              Expanded(
                child: PerformanceCard(
                    icon: Icons.access_time,
                    iconColor: Colors.orange,
                    count: 3,
                    label: "Pending"),
              ),
              SizedBox(width: 12),
              Expanded(
                child: PerformanceCard(
                    icon: Icons.refresh,
                    iconColor: Colors.red,
                    count: 0,
                    label: "Returns"),
              ),
            ],
          ),

          SizedBox(height: 40.h),
        ],
      );
    },
  );
}
  /// ================= RETURN ORDERS =================
  Widget _returnOrders() {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      children: [
        SizedBox(height: 16.h),

        /// FULL RETURN
        const ReturnOrderCard(isFullReturn: true),

        /// PARTIAL RETURN WITH ITEMS
        ReturnOrderCard(
          isFullReturn: false,
          items: [
            {
              "image": "assets/images/headphone.png",
              "title": "Wireless Headphones",
              "color": "Matte Black",
              "qty": 1,
            },
            {
              "image": "assets/images/watch.png",
              "title": "Smart Watch",
              "color": "Silver",
              "qty": 1,
            },
          ],
        ),

        SizedBox(height: 30.h),
      ],
    );
  }
}
class PerformanceCard extends StatelessWidget { final IconData icon; final Color iconColor; final int count; final String label; const PerformanceCard({ super.key, required this.icon, required this.iconColor, required this.count, required this.label, }); @override Widget build(BuildContext context) { return Container( padding: EdgeInsets.all(16.w), margin: EdgeInsets.only(bottom: 8.h), decoration: BoxDecoration( color: Colors.white, borderRadius: BorderRadius.circular(16.r), boxShadow: [ BoxShadow( color: Colors.black.withOpacity(0.05), blurRadius: 10.r, ), ], ), child: Column( children: [ CircleAvatar( radius: 20.r, backgroundColor: iconColor.withOpacity(0.15), child: Icon(icon, color: iconColor, size: 20.sp), ), SizedBox(height: 10.h), Text( "$count", style: TextStyle( fontSize: 20.sp, fontWeight: FontWeight.bold, ), ), SizedBox(height: 4.h), Text( label, style: TextStyle( fontSize: 12.sp, color: Colors.grey, ), ), ], ), ); } }