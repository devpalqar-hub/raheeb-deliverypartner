import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/ReturnOrderModel.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/ReturnScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class ReturnOrderCard extends StatelessWidget {
  final ReturnOrder returnOrder;

  const ReturnOrderCard({super.key, required this.returnOrder});

  /// Helper to get initials from name
  String getInitials(String name) {
    List<String> names = name.split(" ");
    String initials = "";
    for (var part in names) {
      if (part.isNotEmpty) initials += part[0];
    }
    return initials.toUpperCase();
  }

  /// Launch phone dialer
  void _callCustomer(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not launch dialer for $phone");
    }
  }

  /// Open Google Maps
  void _openMap(String address) async {
    final query = Uri.encodeComponent(address);
    final googleMapsUrl = Uri.parse(
      "https://www.google.com/maps/dir/?api=1&destination=$query",
    );
    if (await canLaunchUrl(googleMapsUrl)) {
      await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
    } else {
      debugPrint("Could not open map for $address");
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isFullReturn = returnOrder.returnType.toLowerCase() == "full";
    final status = returnOrder.status.toLowerCase();
    Color statusColor;

    switch (status) {
      case "pending":
        statusColor = Colors.orange;
        break;
      case "picked_up":
      case "completed":
        statusColor = Colors.green;
        break;
      case "returned":
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }

    final shipping = returnOrder.order.shippingAddress;

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
          ),
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
                        isFullReturn ? "Full Order Return" : "Partial Return",
                        isFullReturn
                            ? const Color(0xffF2994A)
                            : const Color(0xff9B51E0),
                      ),
                      _badge(
                        "Status: ${returnOrder.status}",
                        statusColor,
                        textColor: Colors.white,
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  /// CUSTOMER INFO
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 22.r,
                        backgroundColor: Colors.blue.withOpacity(0.2),
                        child: Text(
                          getInitials(returnOrder.customerProfile.name),
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                      SizedBox(width: 12.w),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              returnOrder.customerProfile.name,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(height: 2.h),
                            GestureDetector(
                              onTap: () => _callCustomer(
                                returnOrder.customerProfile.phone,
                              ),
                              child: Text(
                                returnOrder.customerProfile.phone,
                                style: TextStyle(
                                  fontSize: 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                            SizedBox(height: 2.h),
                            Text(
                              "Order: ${returnOrder.order.orderNumber}       Price: QAR ${returnOrder.order.totalAmount}",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// CALL ICON
                      GestureDetector(
                        onTap: () =>
                            _callCustomer(returnOrder.customerProfile.phone),
                        child: CircleAvatar(
                          radius: 18.r,
                          backgroundColor: Colors.blue.withOpacity(.1),
                          child: Icon(
                            Icons.call,
                            color: Colors.blue,
                            size: 18.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 14.h),

                  /// ADDRESS BOX
                  Container(
                    padding: EdgeInsets.all(14.w),
                    decoration: BoxDecoration(
                      color: const Color(0xffF4F6F8),
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          color: Colors.grey,
                          size: 20.sp,
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: Text(
                            shipping != null
                                ? "${shipping.address}, ${shipping.city}, ${shipping.state} ${shipping.postalCode}"
                                : "No address available",
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        if (isFullReturn)
                          GestureDetector(
                            onTap: () => _openMap(
                              "${shipping?.address ?? ''}, ${shipping?.city ?? ''}, ${shipping?.state ?? ''} ${shipping?.postalCode ?? ''}",
                            ),
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 12.w,
                                vertical: 6.h,
                              ),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8.r),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: Text(
                                "NAVIGATE",
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16.h),

                  /// START RETURN PICK-UP BUTTON
                  SizedBox(
                    width: double.infinity,
                    height: 48.h,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) =>
                                ProcessReturnScreen(returnOrder: returnOrder),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.local_shipping,
                        size: 18.sp,
                        color: Colors.white,
                      ),
                      label: Text(
                        "Start Return Pick-up",
                        style: TextStyle(fontSize: 15.sp, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xff2F80ED),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// BADGE
  Widget _badge(String text, Color color, {Color? textColor}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: textColor ?? Colors.black,
          fontSize: 12.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
