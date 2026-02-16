import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/order_card.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/returnorder_card.dart';
import 'package:raheeb_deliverypartner/Screens/TransferScreen/TransferScreen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  int selectedTab = 0; // 0 = Assigned, 1 = Return

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,

      body: SafeArea(
        child: Column(
          children: [

            /// -------- PROFILE HEADER --------
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 14.h,
              ),
              color: Colors.white,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 22.r,
                    backgroundImage: const AssetImage(
                      "assets/images/profile.png",
                    ),
                  ),

                  SizedBox(width: 12.w),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Welcome back",
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: Colors.grey,
                        ),
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

            /// -------- TOGGLE BUTTONS --------
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

            /// -------- ORDER LIST --------
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
    bool isActive = selectedTab == index;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedTab = index;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xff2F80ED)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
          ),
          alignment: Alignment.center,
          child: Text(
            title,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color:
                  isActive ? Colors.white : Colors.grey,
            ),
          ),
        ),
      ),
    );
  }

  /// ================= ASSIGNED ORDERS =================
  Widget _assignedOrders() {
  return ListView(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    children: [
      OrderCard(
        title: "Burger King",
        orderId: "#ORD-4923",
        pickup: "124 Main Street, West Side",
        delivery: "Apartment 4B, 892 Broadway",
        earning: "\$8.50",
        status: "ASSIGNED",
        buttonText: "View Details",
        branch: '',
        onPressed: () {
          Get.to(() => const TransferOrderScreen());
        },
      ),
    ],
  );
}

  /// ================= RETURN ORDERS =================
 Widget _returnOrders() {
  return ListView(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    children: const [
      ReturnOrderCard(isFullReturn: true),
      ReturnOrderCard(isFullReturn: false),
    ],
  );
}
}