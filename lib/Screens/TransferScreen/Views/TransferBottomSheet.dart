import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransferReasonBottomSheet extends StatefulWidget {
  const TransferReasonBottomSheet({super.key});

  @override
  State<TransferReasonBottomSheet> createState() =>
      _TransferReasonBottomSheetState();
}

class _TransferReasonBottomSheetState
    extends State<TransferReasonBottomSheet> {

  int selectedIndex = 0;

  final List<String> reasons = [
    "Vehicle Issue / Breakdown",
    "Order Too Large / Heavy",
    "Personal Emergency",
    "Other"
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24.r),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          /// HANDLE BAR
          Container(
            width: 40.w,
            height: 4.h,
            margin: EdgeInsets.only(bottom: 14.h),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),

          /// TITLE
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Reason for Transfer",
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          SizedBox(height: 6.h),

          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Why are you transferring order #4921 to Michael?",
              style: TextStyle(
                fontSize: 13.sp,
                color: Colors.grey,
              ),
            ),
          ),

          SizedBox(height: 18.h),

          /// REASON LIST
          ...List.generate(
            reasons.length,
            (index) => _reasonTile(index),
          ),

          SizedBox(height: 16.h),

          /// NOTES FIELD
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w),
            height: 55.h,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Add additional notes (optional)...",
                border: InputBorder.none,
                hintStyle: TextStyle(fontSize: 13.sp),
              ),
            ),
          ),

          SizedBox(height: 20.h),

          /// BUTTONS
          Row(
            children: [

              /// CANCEL
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    "Cancel",
                    style: TextStyle(fontSize: 15.sp, color: Colors.black),
                  ),
                ),
              ),

              SizedBox(width: 12.w),

              /// CONFIRM
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff2F80ED),
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                  child: Text(
                    "Confirm Transfer",
                    style: TextStyle(fontSize: 15.sp, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),

          SizedBox(height: 10.h),
        ],
      ),
    );
  }

  /// ================= REASON TILE =================
  Widget _reasonTile(int index) {
    bool selected = selectedIndex == index;

    return GestureDetector(
      onTap: () {
        setState(() => selectedIndex = index);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: selected
              ? const Color(0xffEAF2FF)
              : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: selected
                ? const Color(0xff2F80ED)
                : Colors.transparent,
          ),
        ),
        child: Row(
          children: [

            /// RADIO
            Container(
              width: 22.w,
              height: 22.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected
                      ? const Color(0xff2F80ED)
                      : Colors.grey,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 10.w,
                        height: 10.w,
                        decoration: const BoxDecoration(
                          color: Color(0xff2F80ED),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),

            SizedBox(width: 12.w),

            Text(
              reasons[index],
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}