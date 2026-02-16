import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/ReturnScreen.dart';
import 'ReturnOrderItemcard.dart';

class ReturnOrderCard extends StatelessWidget {
  final bool isFullReturn;
  final List<Map<String, dynamic>>? items;

  const ReturnOrderCard({
    super.key,
    this.isFullReturn = true,
    this.items,
  });

  @override
  Widget build(BuildContext context) {
    final stripColor =
        isFullReturn ? const Color(0xffF2994A) : const Color(0xff9B51E0);

    return Container(
      margin: EdgeInsets.only(bottom: 18.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.06),
            blurRadius: 14.r,
            offset: const Offset(0, 6),
          )
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [

            /// LEFT COLOR STRIP ✅ AUTO HEIGHT
            Container(
              width: 6.w,
              decoration: BoxDecoration(
                color: stripColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(18.r),
                  bottomLeft: Radius.circular(18.r),
                ),
              ),
            ),

            Expanded(
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// TOP BADGES
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _badge(
                          isFullReturn
                              ? "Full Order Return"
                              : "Partial Return (${items?.length ?? 0} Item)",
                          stripColor,
                        ),
                        _dueBadge(
                          isFullReturn ? "Due by 2:00 PM" : "Urgent",
                          isFullReturn,
                        ),
                      ],
                    ),

                    SizedBox(height: 14.h),

                    /// CUSTOMER ROW
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 22.r,
                          backgroundImage:
                              const AssetImage("assets/images/profile.png"),
                        ),
                        SizedBox(width: 12.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isFullReturn
                                    ? "Sarah Jenkins"
                                    : "Mike Ross",
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                isFullReturn
                                    ? "Order #99281 • 3 Items"
                                    : "Order #88392",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        CircleAvatar(
                          radius: 18.r,
                          backgroundColor:
                              const Color(0xff2F80ED).withOpacity(.1),
                          child: Icon(Icons.call,
                              size: 18.sp,
                              color: const Color(0xff2F80ED)),
                        )
                      ],
                    ),

                    SizedBox(height: 14.h),

                    /// ===== FULL RETURN ADDRESS BOX =====
                    if (isFullReturn)
                      _fullAddress(),

                    /// ===== PARTIAL RETURN ITEMS (EXACT UI) =====
                    if (!isFullReturn &&
                        items != null &&
                        items!.isNotEmpty) ...[
                      SizedBox(height: 12.h),

  Column(
    children: items!
        .map(
          (item) => Padding(
            padding: EdgeInsets.only(bottom: 10.h),
            child: ReturnOrderItemCard(
              image: item["image"],
              title: item["title"],
              color: item["color"],
              qty: item["qty"],
            ),
          ),
        )
        .toList(),
  ),


                      SizedBox(height: 14.h),

                      /// SIMPLE ADDRESS ROW (LIKE IMAGE)
                      Row(
                        children: [
                          Icon(Icons.location_on_outlined,
                              size: 18.sp, color: Colors.grey),
                          SizedBox(width: 6.w),
                          Expanded(
                            child: Text(
                              "450 Highland Park",
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 4.h),
                            decoration: BoxDecoration(
                              color: const Color(0xffF2F4F7),
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            child: Text(
                              "2.4 mi away",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey),
                            ),
                          )
                        ],
                      ),
                    ],

                    SizedBox(height: 18.h),

                    /// BUTTON
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton.icon(
                       onPressed: () {
  Get.to(() => const ProcessReturnScreen());
},
                        icon: Icon(Icons.local_shipping,
                            size: 18.sp, color: Colors.white),
                        label: Text(
                          "Start Return Pick-up",
                          style: TextStyle(
                              fontSize: 15.sp,
                              color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color(0xff2F80ED),
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(12.r),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// FULL ADDRESS BOX
  Widget _fullAddress() {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xffF4F6F8),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined,
              color: Colors.grey, size: 20.sp),
          SizedBox(width: 10.w),
          const Expanded(
            child: Text(
              "123 Maple Ave, Apt 4B\n1.2 mi away • Downtown District",
            ),
          ),
        ],
      ),
    );
  }

  Widget _badge(String text, Color color) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: color.withOpacity(.12),
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(text,
            style: TextStyle(
                color: color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600)),
      );

  Widget _dueBadge(String text, bool normal) => Container(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
        decoration: BoxDecoration(
          color: normal ? Colors.grey.shade200 : Colors.red.shade100,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Text(
          text,
          style: TextStyle(
              fontSize: 12.sp,
              color: normal ? Colors.grey : Colors.red,
              fontWeight: FontWeight.w600),
        ),
      );
}