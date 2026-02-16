import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raheeb_deliverypartner/Screens/TransferScreen/Views/TransferBottomSheet.dart';

class TransferOrderScreen extends StatelessWidget {
  const TransferOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF4F5F7),

      /// ---------------- APP BAR ----------------
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,

        /// BACK BUTTON
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black, size: 22.sp),
          onPressed: () => Navigator.pop(context),
        ),

        centerTitle: true,
        title: Text(
          "Transfer Order #4921",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),

        /// CANCEL BUTTON
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 16.w),
            child: GestureDetector(
              onTap: () => _showCancelDialog(context),
              child: Center(
                child: Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          )
        ],
      ),

      /// ---------------- BODY ----------------
      body: Column(
        children: [
          /// SEARCH BAR
          Padding(
            padding: EdgeInsets.all(16.w),
            child: Container(
              height: 48.h,
              padding: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, size: 20.sp, color: Colors.grey),
                  SizedBox(width: 10.w),
                  Text(
                    "Search partner by name or ID",
                    style:
                        TextStyle(fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          /// PARTNER LIST
          Expanded(
            child: ListView(
              children: [
                _partnerCard(context,
                    name: "Michael Chen",
                    distance: "0.2 mi",
                    active: "0 Active",
                    badge: "FREE",
                    badgeColor: Colors.green.shade100,
                    badgeTextColor: Colors.green,
                    avatarColor: Colors.teal),

                _partnerCard(context,
                    name: "Sarah Jenkins",
                    distance: "0.5 mi",
                    active: "1 Active",
                    avatarAsset: "assets/images/profile.png"),

                _partnerCard(context,
                    name: "David Kim",
                    distance: "0.8 mi",
                    active: "2 Active",
                    initials: "DK"),

                Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                  child: Text(
                    "All Active Partners",
                    style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600),
                  ),
                ),

                _partnerCard(context,
                    name: "Marcus O.",
                    distance: "1.2 mi",
                    active: "4 Active",
                    badge: "FULL",
                    badgeColor: Colors.red.shade100,
                    badgeTextColor: Colors.red,
                    disabled: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// ================= CANCEL CONFIRMATION =================
  void _showCancelDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
        title: Text(
          "Cancel Transfer?",
          style:
              TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        content: Text(
          "Are you sure you want to cancel this transfer?",
          style: TextStyle(fontSize: 14.sp),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("No", style: TextStyle(fontSize: 14.sp)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // close dialog
              Navigator.pop(context); // go back screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff2F80ED),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text("Yes", style: TextStyle(fontSize: 14.sp)),
          ),
        ],
      ),
    );
  }

  /// ================= PARTNER CARD =================
  Widget _partnerCard(
    BuildContext context, {
    required String name,
    required String distance,
    required String active,
    String? badge,
    Color? badgeColor,
    Color? badgeTextColor,
    String? avatarAsset,
    String? initials,
    Color? avatarColor,
    bool disabled = false,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          /// AVATAR
          CircleAvatar(
            radius: 24.r,
            backgroundColor: avatarColor ?? Colors.grey.shade300,
            backgroundImage:
                avatarAsset != null ? AssetImage(avatarAsset) : null,
            child: avatarAsset == null && initials != null
                ? Text(initials,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp))
                : null,
          ),

          SizedBox(width: 12.w),

          /// INFO
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name,
                        style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600)),
                    if (badge != null) ...[
                      SizedBox(width: 8.w),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 8.w, vertical: 3.h),
                        decoration: BoxDecoration(
                          color: badgeColor,
                          borderRadius: BorderRadius.circular(6.r),
                        ),
                        child: Text(
                          badge,
                          style: TextStyle(
                              fontSize: 11.sp,
                              color: badgeTextColor,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ]
                  ],
                ),
                SizedBox(height: 6.h),
                Row(
                  children: [
                    Icon(Icons.navigation,
                        size: 14.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(distance,
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey)),
                    SizedBox(width: 12.w),
                    Icon(Icons.work_outline,
                        size: 14.sp, color: Colors.grey),
                    SizedBox(width: 4.w),
                    Text(active,
                        style: TextStyle(
                            fontSize: 12.sp, color: Colors.grey)),
                  ],
                ),
              ],
            ),
          ),

          /// TRANSFER BUTTON
          ElevatedButton(
            onPressed: disabled
                ? null
                : () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      backgroundColor: Colors.transparent,
                      builder: (_) =>
                          const TransferReasonBottomSheet(),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: disabled
                  ? Colors.grey.shade200
                  : const Color(0xff2F80ED),
              foregroundColor: disabled ? Colors.grey : Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
              padding: EdgeInsets.symmetric(
                  horizontal: 16.w, vertical: 10.h),
            ),
            child: Text(
              disabled ? "Full" : "Transfer",
              style: TextStyle(fontSize: 13.sp),
            ),
          ),
        ],
      ),
    );
  }
}