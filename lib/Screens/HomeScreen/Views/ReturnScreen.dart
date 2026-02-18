import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/ReturnOrderModel.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/ReturnOrderController.dart';
import 'package:url_launcher/url_launcher.dart';

class ProcessReturnScreen extends StatefulWidget {
  final ReturnOrder returnOrder;

  const ProcessReturnScreen({
    super.key,
    required this.returnOrder,
  });

  @override
  State<ProcessReturnScreen> createState() =>
      _ProcessReturnScreenState();
}

class _ProcessReturnScreenState extends State<ProcessReturnScreen> {
  final ReturnOrderController controller =
      Get.find<ReturnOrderController>();

  late String currentStatus;

  @override
  void initState() {
    super.initState();
    currentStatus = widget.returnOrder.status;
  }

  bool get isPicked => currentStatus.toLowerCase().contains("picked");

  /// Launch phone dialer
  void _callCustomer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      Get.snackbar("Error", "Cannot make call to $phone");
    }
  }

  /// Launch Google Maps navigation
  void _openMap(String address) async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl = Uri.parse("https://www.google.com/maps/dir/?api=1&destination=$query");

    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl);
    } else {
      Get.snackbar("Error", "Could not open Google Maps");
    }
  }
void _showPaymentMethodSheet() {
    String? selectedMethod;

    Get.bottomSheet(
      StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(22.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  margin: EdgeInsets.only(bottom: 18.h),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                ),

                Text(
                  "Select Return Payment Method",
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),

                SizedBox(height: 20.h),

                /// CASH OPTION
                _paymentTile(
                  title: "Cash",
                  value: "cash",
                  selected: selectedMethod,
                  onTap: () =>
                      setModalState(() => selectedMethod = "cash"),
                ),

                SizedBox(height: 12.h),

                /// ONLINE OPTION
                _paymentTile(
                  title: "Online",
                  value: "online",
                  selected: selectedMethod,
                  onTap: () =>
                      setModalState(() => selectedMethod = "online"),
                ),

                SizedBox(height: 24.h),

                SizedBox(
                  width: double.infinity,
                  height: 50.h,
                  child: ElevatedButton(
                    onPressed: selectedMethod == null
                        ? null
                        : () async {
                            Get.back();

                            bool success =
                                await controller.updateReturnStatus(
                              returnId: widget.returnOrder.id,
                              status: "picked_up",
                              returnPaymentMethod: selectedMethod!,
                            );

                            if (success) {
                              setState(() {
                                currentStatus = "picked_up";
                              });
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff1E5CC6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14.r),
                      ),
                    ),
                    child: Text(
                      "Confirm Collection",
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 10.h),
              ],
            ),
          );
        },
      ),
      isScrollControlled: true,
    );
  }
  Widget _paymentTile({
    required String title,
    required String value,
    required String? selected,
    required VoidCallback onTap,
  }) {
    final isSelected = selected == value;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color:
                isSelected ? const Color(0xff1E5CC6) : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            Icon(
              isSelected
                  ? Icons.radio_button_checked
                  : Icons.radio_button_off,
              color: const Color(0xff1E5CC6),
            )
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    final returnOrder = widget.returnOrder;
    final shipping = returnOrder.order.shippingAddress;

    return Scaffold(
      backgroundColor: Colors.white,

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
          child: GetBuilder<ReturnOrderController>(
            builder: (ctrl) {
              return ElevatedButton(
                onPressed: () async {
                  if (isPicked || ctrl.isLoading) return;

                
                   _showPaymentMethodSheet();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      isPicked ? Colors.green : const Color(0xff1E5CC6),
                  elevation: 0,
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
                        isPicked
                            ? "Picked ✓"
                            : "Confirm Collection  →",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              );
            },
          ),
        ),
      ),

      /// ================= BODY =================
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
  onTap: () {
    Get.back(); 
  },
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
                          "Order #${returnOrder.order.orderNumber}",
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

              /// ================= PICKUP LABEL =================
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
                          returnOrder.customerProfile.name,
                          style: TextStyle(
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xff101828),
                          ),
                        ),
                        SizedBox(height: 6.h),

                        GestureDetector(
                          onTap: () => _callCustomer(returnOrder.customerProfile.phone),
                          child: Text(
                            returnOrder.customerProfile.phone,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: const Color(0xff2F80ED),
                              fontWeight: FontWeight.w600,
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

                  /// CALL BUTTON
                  GestureDetector(
                    onTap: () => _callCustomer(returnOrder.customerProfile.phone),
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

              /// ================= MAP CARD =================
              GestureDetector(
                onTap: () => _openMap(
                    "${shipping?.address ?? ''}, ${shipping?.city ?? ''}, ${shipping?.state ?? ''} ${shipping?.postalCode ?? ''}"),
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
                          horizontal: 18.w, vertical: 10.h),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(30.r),
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
              ),
              SizedBox(height: 22.h),

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

/// ================= RETURN ITEMS =================
Column(
  children: returnOrder.returnItems.map((returnItem) {
    final orderItem = returnItem.orderItem;
    final product = orderItem.product;
    final imageUrl = product.images.isNotEmpty ? product.images[0].url : '';

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
          /// ---------------- Product Info ----------------
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Product Image
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

              /// Name, Price, Quantity
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
                      "Price: ₹${orderItem.discountedPrice}",
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

          /// ---------------- Return Details ----------------
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
                "Refund: ₹${returnOrder.refundAmount}",
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
                "Status: ${returnOrder.status}",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: Colors.green,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "Payment: ${returnOrder.returnPaymentMethod ?? 'N/A'}",
                style: TextStyle(
                  fontSize: 13.sp,
                  color: const Color(0xff344054),
                ),
              ),
            ],
          ),
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