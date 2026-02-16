import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReturnOrderItemCard extends StatelessWidget {
  final String image;
  final String title;
  final String color;
  final int qty;

  const ReturnOrderItemCard({
    super.key,
    required this.image,
    required this.title,
    required this.color,
    required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xffF2F4F7),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [

          /// PRODUCT IMAGE
          Container(
            width: 56.w,
            height: 56.w,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.r),
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          /// PRODUCT DETAILS
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xff1D2939),
                  ),
                ),

                SizedBox(height: 4.h),

                Text(
                  "Color: $color • Qty: $qty",
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: const Color(0xff667085),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}