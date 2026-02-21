// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:get/get.dart';
// import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AssignedController.dart';

// class TransferReasonBottomSheet extends StatefulWidget {
//   final String orderId;
//   final String deliveryPartnerId;
//   final String partnerName;

//   const TransferReasonBottomSheet({
//     super.key,
//     required this.orderId,
//     required this.deliveryPartnerId,
//     required this.partnerName,
//   });

//   @override
//   State<TransferReasonBottomSheet> createState() =>
//       _TransferReasonBottomSheetState();
// }

// class _TransferReasonBottomSheetState extends State<TransferReasonBottomSheet> {
//   final OrderController controller = Get.find<OrderController>();
//   final TextEditingController notesController = TextEditingController();

//   int selectedIndex = 0;

//   final List<String> reasons = [
//     "Vehicle Issue / Breakdown",
//     "Order Too Large / Heavy",
//     "Personal Emergency",
//     "Other",
//   ];

//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: SingleChildScrollView(
//         child: Container(
//           padding: EdgeInsets.all(20.w),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
//           ),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               Container(
//                 width: 40.w,
//                 height: 4.h,
//                 margin: EdgeInsets.only(bottom: 14.h),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade300,
//                   borderRadius: BorderRadius.circular(10.r),
//                 ),
//               ),

//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Reason for Transfer",
//                   style: TextStyle(
//                     fontSize: 18.sp,
//                     fontWeight: FontWeight.w700,
//                   ),
//                 ),
//               ),

//               SizedBox(height: 6.h),

//               Align(
//                 alignment: Alignment.centerLeft,
//                 child: Text(
//                   "Why are you transferring order #${widget.orderId} to ${widget.partnerName}?",
//                   style: TextStyle(fontSize: 13.sp, color: Colors.grey),
//                 ),
//               ),

//               SizedBox(height: 18.h),

//               ...List.generate(reasons.length, (index) => _reasonTile(index)),

//               SizedBox(height: 16.h),

//               Container(
//                 padding: EdgeInsets.symmetric(horizontal: 14.w),
//                 height: 55.h,
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(14.r),
//                 ),
//                 child: TextField(
//                   controller: notesController,
//                   decoration: InputDecoration(
//                     hintText: "Add additional notes (optional)...",
//                     border: InputBorder.none,
//                   ),
//                 ),
//               ),

//               SizedBox(height: 20.h),

//               Row(
//                 children: [
//                   Expanded(
//                     child: OutlinedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xff2F80ED),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.r),
//                         ),
//                       ),
//                       onPressed: Get.back,
//                       child: Text(
//                         "Cancel",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),

//                   SizedBox(width: 12.w),

//                   Expanded(
//                     child: ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: const Color(0xff2F80ED),
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 20,
//                           vertical: 12,
//                         ),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(10.r),
//                         ),
//                       ),
//                       onPressed: () async {
//                         String notes =
//                             "${reasons[selectedIndex]} - ${notesController.text}";

//                         controller.assignDeliveryPartner(
//                           orderId: widget.orderId,
//                           deliveryPartnerId: widget.deliveryPartnerId,
//                           notes: notes,
//                         );
//                         Get.back();
//                         Get.back();
//                         Get.back();
//                       },
//                       child: const Text(
//                         "Confirm Transfer",
//                         style: TextStyle(color: Colors.white),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Widget _reasonTile(int index) {
//     bool selected = selectedIndex == index;

//     return GestureDetector(
//       onTap: () {
//         setState(() => selectedIndex = index);
//       },
//       child: Container(
//         margin: EdgeInsets.only(bottom: 12.h),
//         padding: EdgeInsets.all(14.w),
//         decoration: BoxDecoration(
//           color: selected ? const Color(0xffEAF2FF) : Colors.grey.shade100,
//           borderRadius: BorderRadius.circular(14.r),
//           border: Border.all(
//             color: selected ? const Color(0xff2F80ED) : Colors.transparent,
//           ),
//         ),
//         child: Row(
//           children: [
//             Icon(
//               selected ? Icons.radio_button_checked : Icons.radio_button_off,
//               color: const Color(0xff2F80ED),
//             ),
//             SizedBox(width: 12.w),
//             Text(reasons[index]),
//           ],
//         ),
//       ),
//     );
//   }
// }
