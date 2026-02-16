import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/home_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9FAFB),

      /// ✅ SAFE AREA
      body: SafeArea(
        child: Column(
          children: [

            /// -------- TOP PROFILE HEADER --------
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 14),
              color: Colors.white,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundImage:
                        AssetImage("assets/images/profile.png"),
                  ),

                  const SizedBox(width: 12),

                  Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: const [
                      Text(
                        "Welcome back",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Reema Salam",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const Divider(height: 1),

            /// -------- PAGE CONTENT --------
            Expanded(
              child: HomeScreen(), // your screen content
            ),
          ],
        ),
      ),

      /// -------- BOTTOM NAVIGATION --------
      bottomNavigationBar: _bottomBar(),
    );
  }

  /// ================= BOTTOM BAR =================
  Widget _bottomBar() {
    return Container(
      height: 70,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xffE5E7EB)),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceAround,
        children: [
          _navItem(
            Icons.dashboard_outlined,
            "Orders",
            true,
            () => Get.to(HomeScreen()),
          ),
          _navItem(
            Icons.account_balance_wallet_outlined,
            "Earnings",
            false,
            () {},
          ),
          _navItem(
            Icons.history,
            "History",
            false,
            () {},
          ),
          _navItem(
            Icons.person_outline,
            "Profile",
            false,
            () {},
          ),
        ],
      ),
    );
  }

  Widget _navItem(
      IconData icon, String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 24,
            color:
                active ? const Color(0xff2F80ED) : Colors.grey,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight:
                  active ? FontWeight.w600 : FontWeight.w400,
              color: active
                  ? const Color(0xff2F80ED)
                  : Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}