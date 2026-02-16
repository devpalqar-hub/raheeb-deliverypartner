import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ReturnOrderCard extends StatelessWidget {
  final bool isFullReturn;

  const ReturnOrderCard({
    super.key,
    this.isFullReturn = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10.r,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [

          /// LEFT COLOR STRIP
          Container(
            width: 6.w,
            height: 210.h,
            decoration: BoxDecoration(
              color: isFullReturn
                  ? const Color(0xffF2994A)
                  : const Color(0xff9B51E0),
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
                            : "Partial Return (1 Item)",
                        isFullReturn
                            ? const Color(0xffF2994A)
                            : const Color(0xff9B51E0),
                      ),

                      _dueBadge(
                        isFullReturn ? "Due by 2:00 PM" : "Urgent",
                        isFullReturn,
                      )
                    ],
                  ),

                  SizedBox(height: 14.h),

                  /// CUSTOMER
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundImage: const AssetImage(
                            "assets/images/profile.png"),
                      ),
                      SizedBox(width: 12.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment.start,
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
                            Colors.blue.withOpacity(.1),
                        child: Icon(Icons.call,
                            color: Colors.blue, size: 18.sp),
                      )
                    ],
                  ),

                  SizedBox(height: 14.h),

                  /// ADDRESS BOX
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xffF4F6F8),
                      borderRadius:
                          BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.location_on_outlined,
                            color: Colors.grey,
                            size: 20.sp),
                        SizedBox(width: 10.w),

                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment.start,
                            children: [
                              Text(
                                isFullReturn
                                    ? "123 Maple Ave, Apt 4B"
                                    : "450 Highland Park",
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight:
                                      FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                isFullReturn
                                    ? "1.2 mi away • Downtown District"
                                    : "2.4 mi away",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey,
                                ),
                              ),
                            ],
                          ),
                        ),

                        if (isFullReturn)
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(8.r),
                              border: Border.all(
                                  color: Colors.blue),
                            ),
                            child: Text(
                              "NAVIGATE",
                              style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.blue,
                                  fontWeight:
                                      FontWeight.w600),
                            ),
                          )
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.local_shipping,
                          size: 18.sp,color: Colors.white,),
                      label: Text(
                        "Start Return Pick-up",
                        style: TextStyle(fontSize: 15.sp,color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color(0xff2F80ED),
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
    );
  }

  /// BADGE
  Widget _badge(String text, Color color) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _dueBadge(String text, bool normal) {
    return Container(
      padding:
          EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: normal
            ? Colors.grey.shade200
            : Colors.red.shade100,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 12.sp,
          color: normal ? Colors.grey : Colors.red,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}