import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProcessReturnScreen extends StatelessWidget {
  const ProcessReturnScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:Colors.white,
      /// ================= BOTTOM BUTTON =================
      bottomNavigationBar: Container(
        padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 22.h),
        decoration: const BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 10,
              offset: Offset(0, -2),
            )
          ],
        ),
        child: SizedBox(
          height: 56.h,
          child: ElevatedButton(
            onPressed: () {},
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff1E5CC6),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
            ),
            child: Text(
              "Confirm Collection  →",
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ),

      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: 8.h),

              /// ================= HEADER =================
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Icon(Icons.arrow_back_ios_new,
                        size: 20.sp),
                  ),

                  Expanded(
                    child: Column(
                      children: [
                        Text(
                          "Process Return",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff101828),
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          "Order #RT-9821",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xff667085),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Icon(Icons.more_horiz, size: 22.sp),
                ],
              ),

              SizedBox(height: 26.h),

              /// ================= PICKUP LABEL =================
              Text(
                "PICKUP LOCATION",
                style: TextStyle(
                  fontSize: 12.sp,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff98A2B3),
                ),
              ),

              SizedBox(height: 14.h),

              /// ================= CUSTOMER INFO =================
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sarah Jenkins",
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff101828),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        Text(
                          "42 Sunset Boulevard, Apt 4B",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff475467),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "San Francisco, CA 94110",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff475467),
                          ),
                        ),
                      ],
                    ),
                  ),

                  /// CALL BUTTON
                  Container(
                    width: 48.w,
                    height: 48.w,
                    decoration: BoxDecoration(
                      color: const Color(0xffEAF2FF),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.call,
                      size: 20.sp,
                      color: const Color(0xff2F80ED),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 22.h),

              /// ================= MAP CARD =================
              Container(
                height: 150.h,
                width: double.infinity,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18.r),
                  image: const DecorationImage(
                    image: AssetImage("assets/images/map.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: 18.w, vertical: 10.h),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(30.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10.r,
                        )
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.navigation,
                            size: 18.sp,
                            color: const Color(0xff2F80ED)),
                        SizedBox(width: 8.w),
                        Text(
                          "Get Directions",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xff344054),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}