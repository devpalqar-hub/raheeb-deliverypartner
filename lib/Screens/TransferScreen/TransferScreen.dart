import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AssignedController.dart';
import 'package:raheeb_deliverypartner/Screens/TransferScreen/Views/TransferBottomSheet.dart';

class TransferOrderScreen extends StatefulWidget {
  final String orderNumber;
  final String orderId;

  const TransferOrderScreen({
    super.key,
    required this.orderNumber,
    required this.orderId,
  });

  @override
  State<TransferOrderScreen> createState() =>
      _TransferOrderScreenState();
}

class _TransferOrderScreenState extends State<TransferOrderScreen> {

  final OrderController controller = Get.find<OrderController>();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchDeliveryPartners();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
 backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
       backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back,
              color: Colors.black, size: 22.sp),
          onPressed: Get.back,
        ),
        centerTitle: true,
        title: Text(
          "Transfer Order #${widget.orderNumber}",
          style: TextStyle(
            color: Colors.black,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      body: Column(
        children: [

          /// SEARCH BAR (UNCHANGED)
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
                  Icon(Icons.search,
                      size: 20.sp, color: Colors.grey),
                  SizedBox(width: 10.w),
                  Text(
                    "Search partner by name or ID",
                    style: TextStyle(
                        fontSize: 14.sp, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: GetBuilder<OrderController>(
              builder: (ctrl) {

                if (ctrl.isPartnerLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (ctrl.deliveryPartners.isEmpty) {
                  return const Center(
                    child: Text("No delivery partners found"),
                  );
                }

                return ListView.builder(
                  itemCount: ctrl.deliveryPartners.length,
                  itemBuilder: (_, index) {

                    final partner =
                        ctrl.deliveryPartners[index];

                    return _partnerCard(
                      name: partner.name ?? "Unknown",
                      email: partner.email,
                      partnerId: partner.id ?? "",
                      initials:
                          _getInitials(partner.name ?? "DP"),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final parts = name.split(" ");
    if (parts.length == 1) {
      return parts.first[0].toUpperCase();
    }
    return parts[0][0].toUpperCase() +
        parts[1][0].toUpperCase();
  }

  /// ✅ ONLY LOGIC ADDED HERE
  Widget _partnerCard({
    required String name,
    required String email,
    required String initials,
    required String partnerId,
  }) {
    return Container(
      margin:
          EdgeInsets.symmetric(horizontal: 16.w, vertical: 6.h),
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24.r,
            backgroundColor: Colors.grey.shade300,
            child: Text(
              initials,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14.sp,
              ),
            ),
          ),

          SizedBox(width: 12.w),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w600)),
                SizedBox(height: 6.h),
                Text(email,
                    style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey)),
              ],
            ),
          ),

          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:  const Color(0xff2F80ED),
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            onPressed: () {
              Get.bottomSheet(
                TransferReasonBottomSheet(
                  orderId: widget.orderId,
                  deliveryPartnerId: partnerId,
                  partnerName: name,
                ),
                isScrollControlled: true,
                backgroundColor: Colors.transparent,
              );
            },
            child: const Text("Transfer",style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}