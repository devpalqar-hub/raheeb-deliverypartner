import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/ReturnOrderModel.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/ReturnOrderController.dart';

class ProcessReturnScreen extends StatefulWidget {
  final ReturnOrder returnOrder;

  const ProcessReturnScreen({super.key, required this.returnOrder});

  @override
  State<ProcessReturnScreen> createState() => _ProcessReturnScreenState();
}

class _ProcessReturnScreenState extends State<ProcessReturnScreen> {
  final ReturnOrderController controller = Get.find<ReturnOrderController>();

  late ReturnOrder _currentReturnOrder;
  late String currentStatus;

  @override
  void initState() {
    super.initState();
    _currentReturnOrder = widget.returnOrder;
    currentStatus = _currentReturnOrder.status;
  }

  bool get isPendingOrApproved {
    final status = currentStatus.toLowerCase();
    return status == "pending" || status == "approved";
  }

  // -------------------- PHONE CALL --------------------
  void _callCustomer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar("Error", "Cannot make call to $phone");
    }
  }

  // -------------------- OPEN MAP --------------------
  void _openMap(String address) async {
    final query = Uri.encodeComponent(address);
    final uri = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$query",
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar("Error", "Could not open Google Maps");
    }
  }

  // -------------------- UPDATE STATUS BOTTOM SHEET --------------------
  void _showStatusUpdateSheet() {
    if (Get.isBottomSheetOpen ?? false) return;

    String? selectedStatus; // 'refunded' or 'rejected'
    String? selectedMethod; // 'cash' or 'online'
    final TextEditingController reasonController = TextEditingController();

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          // Validation logic
          bool canSubmit = false;
          if (selectedStatus == 'rejected' &&
              reasonController.text.trim().isNotEmpty) {
            canSubmit = true;
          } else if (selectedStatus == 'refunded' &&
              selectedMethod != null &&
              reasonController.text.trim().isNotEmpty) {
            canSubmit = true;
          }

          return Padding(
            // Handles keyboard padding so it doesn't cover the textfield
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom,
            ),
            child: Container(
              padding: EdgeInsets.all(20.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(22.r)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40.w,
                        height: 4.h,
                        margin: EdgeInsets.only(bottom: 18.h),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                    ),
                    Center(
                      child: Text(
                        "Update Return Status",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    SizedBox(height: 20.h),

                    // ---- STATUS SELECTION ----
                    Text(
                      "Select Action",
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xff475467),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Row(
                      children: [
                        Expanded(
                          child: _radioOptionTile(
                            title: "Refund",
                            value: "refunded",
                            groupValue: selectedStatus,
                            onTap: () => setModalState(
                              () => selectedStatus = "refunded",
                            ),
                            activeColor: Colors.green,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _radioOptionTile(
                            title: "Reject",
                            value: "rejected",
                            groupValue: selectedStatus,
                            onTap: () => setModalState(() {
                              selectedStatus = "rejected";
                              selectedMethod =
                                  null; // reset payment method if rejected
                            }),
                            activeColor: Colors.red,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.h),

                    // ---- PAYMENT METHOD (Only if Refunded) ----
                    if (selectedStatus == 'refunded') ...[
                      Text(
                        "Refund Payment Method",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff475467),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      _radioOptionTile(
                        title: "Cash (Offline)",
                        value: "cash",
                        groupValue: selectedMethod,
                        onTap: () =>
                            setModalState(() => selectedMethod = "cash"),
                        activeColor: const Color(0xff1E5CC6),
                      ),
                      SizedBox(height: 8.h),
                      _radioOptionTile(
                        title: "Online",
                        value: "online",
                        groupValue: selectedMethod,
                        onTap: () =>
                            setModalState(() => selectedMethod = "online"),
                        activeColor: const Color(0xff1E5CC6),
                      ),
                      SizedBox(height: 20.h),
                    ],

                    // ---- REASON TEXT FIELD ----
                    if (selectedStatus != null) ...[
                      Text(
                        "Reason / Notes",
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xff475467),
                        ),
                      ),
                      SizedBox(height: 10.h),
                      TextField(
                        controller: reasonController,
                        onChanged: (val) => setModalState(
                          () {},
                        ), // Trigger UI update for button state
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: selectedStatus == 'rejected'
                              ? "Enter rejection reason..."
                              : "Enter refund notes...",
                          hintStyle: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14.sp,
                          ),
                          contentPadding: EdgeInsets.all(12.w),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: BorderSide(color: Colors.grey.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.r),
                            borderSide: const BorderSide(
                              color: Color(0xff1E5CC6),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 24.h),
                    ],

                    // ---- SUBMIT BUTTON ----
                    SizedBox(
                      width: double.infinity,
                      height: 50.h,
                      child: ElevatedButton(
                        onPressed: !canSubmit
                            ? null
                            : () async {
                                controller.isLoading = true;
                                controller.update();
                                Get.back(); // Close bottom sheet
                                await Future.delayed(
                                  const Duration(milliseconds: 300),
                                ); // Smooth transition

                                // Pass "none" for payment method if rejected to satisfy API requirements
                                String paymentMethodToPass =
                                    selectedStatus == 'refunded'
                                    ? selectedMethod!
                                    : "none";

                                bool success = await controller
                                    .updateReturnStatus(
                                      returnId: _currentReturnOrder.id,
                                      status: selectedStatus!,
                                      returnPaymentMethod: paymentMethodToPass,
                                      adminNotes: reasonController.text.trim(),
                                    );

                                controller.isLoading = false;
                                controller.update();

                                if (!mounted) return;

                                if (success) {
                                  setState(() {
                                    currentStatus = selectedStatus!;
                                    _currentReturnOrder = _currentReturnOrder
                                        .copyWith(
                                          status: selectedStatus,
                                          returnPaymentMethod:
                                              paymentMethodToPass,
                                          adminNotes: reasonController.text
                                              .trim(),
                                        );
                                  });
                                  Get.snackbar(
                                    "Success",
                                    "Return status updated to $selectedStatus",
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff1E5CC6),
                          disabledBackgroundColor: Colors.grey.shade300,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14.r),
                          ),
                        ),
                        child: Text(
                          "Submit Update",
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w600,
                            color: canSubmit
                                ? Colors.white
                                : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 10.h),
                  ],
                ),
              ),
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }

  // -------------------- REUSABLE RADIO TILE --------------------
  Widget _radioOptionTile({
    required String title,
    required String value,
    required String? groupValue,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    final isSelected = groupValue == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
        decoration: BoxDecoration(
          color: isSelected
              ? activeColor.withOpacity(0.05)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: isSelected ? activeColor : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected ? activeColor : const Color(0xff344054),
                ),
              ),
            ),
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? activeColor : Colors.grey.shade400,
              size: 20.sp,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final shipping = _currentReturnOrder.order.shippingAddress;

    return Scaffold(
      backgroundColor: Colors.white,
      // Only show the bottom navigation bar if the status is pending or approved
      bottomNavigationBar: isPendingOrApproved
          ? Container(
              padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 22.h),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Color(0x14000000),
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  ),
                ],
              ),
              child: SizedBox(
                height: 56.h,
                child: GetBuilder<ReturnOrderController>(
                  builder: (ctrl) => ElevatedButton(
                    onPressed: ctrl.isLoading ? null : _showStatusUpdateSheet,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1E5CC6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: ctrl.isLoading
                        ? SizedBox(
                            height: 22.h,
                            width: 22.h,
                            child: const CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            "Update Status →",
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  GestureDetector(
                    onTap: () => Get.back(),
                    child: Icon(Icons.arrow_back, size: 20.sp),
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
                          "Order #${_currentReturnOrder.order.orderNumber}",
                          style: TextStyle(
                            fontSize: 13.sp,
                            color: const Color(0xff667085),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 26.h),

              // PICKUP LOCATION
              Text(
                "PICKUP LOCATION",
                style: TextStyle(
                  fontSize: 14.sp,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff98A2B3),
                ),
              ),
              SizedBox(height: 14.h),

              // CUSTOMER INFO
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _currentReturnOrder.customerProfile.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff101828),
                          ),
                        ),
                        SizedBox(height: 6.h),
                        GestureDetector(
                          onTap: () => _callCustomer(
                            _currentReturnOrder.customerProfile.phone,
                          ),
                          child: Text(
                            _currentReturnOrder.customerProfile.phone,
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xff2F80ED),
                            ),
                          ),
                        ),
                        SizedBox(height: 3.h),
                        Text(
                          "${shipping?.address ?? ''}, ${shipping?.city ?? ''}, ${shipping?.state ?? ''} ${shipping?.postalCode ?? ''}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: const Color(0xff475467),
                          ),
                        ),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () => _callCustomer(
                      _currentReturnOrder.customerProfile.phone,
                    ),
                    child: Container(
                      width: 48.w,
                      height: 48.w,
                      decoration: const BoxDecoration(
                        color: Color(0xffEAF2FF),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.call,
                        size: 20.sp,
                        color: const Color(0xff2F80ED),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 22.h),

              // MAP CARD
              GestureDetector(
                onTap: () => _openMap(
                  "${shipping?.address ?? ''}, ${shipping?.city ?? ''}, ${shipping?.state ?? ''} ${shipping?.postalCode ?? ''}",
                ),
                child: Container(
                  height: 150.h,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(18.r),
                    image: const DecorationImage(
                      image: AssetImage("assets/map.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 18.w,
                        vertical: 10.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
                        boxShadow: [
                          BoxShadow(color: Colors.black12, blurRadius: 10.r),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.navigation,
                            size: 18.sp,
                            color: const Color(0xff2F80ED),
                          ),
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
              ),
              SizedBox(height: 22.h),

              // ORDER DETAILS
              Text(
                "ORDER DETAILS",
                style: TextStyle(
                  fontSize: 14.sp,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xff98A2B3),
                ),
              ),
              SizedBox(height: 14.h),

              Column(
                children: _currentReturnOrder.returnItems.map((returnItem) {
                  final orderItem = returnItem.orderItem;
                  final product = orderItem.product;
                  final imageUrl = product.images.isNotEmpty
                      ? product.images[0].url
                      : '';

                  return Container(
                    margin: EdgeInsets.only(bottom: 16.h),
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              width: 60.w,
                              height: 60.w,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.r),
                                color: Colors.white,
                                image: imageUrl.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(imageUrl),
                                        fit: BoxFit.cover,
                                      )
                                    : null,
                              ),
                            ),
                            SizedBox(width: 12.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    product.name,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xff101828),
                                    ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    "Price: QAR ${orderItem.discountedPrice}",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: const Color(0xff475467),
                                    ),
                                  ),
                                  SizedBox(height: 2.h),
                                  Text(
                                    "Quantity: ${orderItem.quantity}",
                                    style: TextStyle(
                                      fontSize: 13.sp,
                                      color: const Color(0xff475467),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                "Reason: ${returnItem.reason}",
                                style: TextStyle(
                                  fontSize: 13.sp,
                                  color: const Color(0xff475467),
                                ),
                              ),
                            ),
                            Text(
                              "Refund: QAR ${_currentReturnOrder.refundAmount}",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xff1E5CC6),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4.h),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Status: ${_currentReturnOrder.status}",
                              style: TextStyle(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.w600,
                                color:
                                    _currentReturnOrder.status.toLowerCase() ==
                                        'rejected'
                                    ? Colors.red
                                    : Colors.green,
                              ),
                            ),
                            Text(
                              "Payment: ${_currentReturnOrder.returnPaymentMethod ?? 'N/A'}",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: const Color(0xff344054),
                              ),
                            ),
                          ],
                        ),
                        if (_currentReturnOrder.adminNotes != null &&
                            _currentReturnOrder.adminNotes!.isNotEmpty) ...[
                          SizedBox(height: 8.h),
                          Text(
                            "Notes: ${_currentReturnOrder.adminNotes}",
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontStyle: FontStyle.italic,
                              color: const Color(0xff667085),
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
