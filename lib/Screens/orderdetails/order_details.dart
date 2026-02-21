import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/OrderModel.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/AssignedController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/DeliveryController.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Service/TrackingController.dart';
import 'package:raheeb_deliverypartner/Screens/TransferScreen/TransferScreen.dart';
import 'package:url_launcher/url_launcher.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;
  OrderDetailsScreen({super.key, required this.order});

  static const List<Map<String, String>> orderFlow = [
    {"title": "Order Placed", "status": "order_placed"},
    {"title": "Processing", "status": "processing"},
    {"title": "Ready to Ship", "status": "ready_to_ship"},
    {"title": "Shipped", "status": "shipped"},
    {"title": "In Transit", "status": "in_transit"},
    {"title": "Out for Delivery", "status": "out_for_delivery"},
    {"title": "Delivered", "status": "delivered"},
  ];

  deliveryController dtClrl = Get.put(deliveryController());

  @override
  Widget build(BuildContext context) {
    //    dtClrl.fetchOrderByID(order.id);
    dtClrl.selectedOrder = order;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text("Order ${order.orderNumber}"),
        ),
        body: GetBuilder<deliveryController>(
          builder: (trackCtrl) {
            if (trackCtrl.orderDetailsLoader) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildTrackingTimeline(),
                  const SizedBox(height: 16),
                  _buildCustomerCard(),
                  const SizedBox(height: 16),
                  _buildNextStepCard(),
                  const SizedBox(height: 16),
                  _buildOrderSummaryCard(),
                  //   const SizedBox(height: 16),
                  // _buildIssueCard(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildTrackingTimeline() {
    final currentStatus = dtClrl.selectedOrder!.tracking.status ?? "processing";

    bool isFailed = currentStatus == "failed_delivery";
    bool isReturned = currentStatus == "returned";

    /// ✅ find next status
    int currentIndex = orderFlow.indexWhere(
      (e) => e["status"] == currentStatus,
    );

    bool isLastStep = currentIndex == orderFlow.length - 1;

    String? nextStatus = !isLastStep && currentIndex != -1
        ? orderFlow[currentIndex + 1]["status"]
        : null;

    String? nextTitle = !isLastStep && currentIndex != -1
        ? orderFlow[currentIndex + 1]["title"]
        : null;

    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TRACKING STATUS",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),

          /// ✅ Timeline Steps
          ...orderFlow.asMap().entries.map((entry) {
            final index = entry.key;
            final step = entry.value;

            bool isCompleted = _isStepCompleted(step["status"]!, currentStatus);

            bool isActive = currentStatus == step["status"];

            return TimelineTile(
              title: step["title"]!,
              subtitle: _getStepSubtitle(step["status"]!),
              isFirst: index == 0,
              isLast: index == orderFlow.length - 1 && !isFailed && !isReturned,
              isCompleted: isCompleted,
              isActive: isActive,
            );
          }).toList(),

          if (isFailed)
            const TimelineTile(
              title: "Delivery Failed",
              subtitle: "Customer unavailable / delivery failed",
              isCompleted: true,
              isActive: true,
              isLast: true,
            ),

          if (isReturned)
            const TimelineTile(
              title: "Returned",
              subtitle: "Order returned to warehouse",
              isCompleted: true,
              isActive: true,
              isLast: true,
            ),

          /// ✅ MARK STATUS BUTTON
          if (nextStatus != null) ...[
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xff2F80ED),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () async {
                  await dtClrl.changeOrderStatus(
                    orderId: order.id,
                    status: nextStatus,
                  );
                },
                child: (dtClrl.isLoading)
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Colors.white,
                        size: 24,
                      )
                    : Text("Mark as $nextTitle"),
              ),
            ),
          ],
        ],
      ),
    );
  }

  bool _isStepCompleted(String status, String currentStatus) {
    final currentIndex = orderFlow.indexWhere(
      (e) => e["status"] == currentStatus,
    );

    final stepIndex = orderFlow.indexWhere((e) => e["status"] == status);

    if (currentIndex == -1 || stepIndex == -1) return false;

    return stepIndex <= currentIndex;
  }

  String _getStepSubtitle(String status) {
    switch (status) {
      case "processing":
        return "Preparing your order";
      case "ready_to_ship":
        return "Order packed and ready";
      case "shipped":
        return "Order shipped from warehouse";
      case "in_transit":
        return "Order is moving";
      case "out_for_delivery":
        return "Driver is on the way";
      case "delivered":
        return "Order delivered successfully";
      default:
        return "";
    }
  }

  Widget _buildCustomerCard() {
    final customer = order.customerProfile;
    final shipping = order.shippingAddress;

    /// ✅ prefer shipping phone, fallback to profile phone
    final String phone = (shipping.phone != null && shipping.phone!.isNotEmpty)
        ? shipping.phone!
        : customer.phone;

    /// ✅ get initials from name
    String getInitials(String name) {
      final names = name.split(' ');
      if (names.isEmpty) return '';
      if (names.length == 1) return names[0][0].toUpperCase();
      return (names[0][0] + names[1][0]).toUpperCase();
    }

    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              /// ✅ CircleAvatar with initials
              CircleAvatar(
                radius: 22,
                backgroundColor: const Color(0xff2F80ED),
                child: Text(
                  getInitials(customer.name),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              /// NAME + PHONE
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      customer.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      phone.isEmpty ? "No phone number" : phone,
                      style: const TextStyle(color: Colors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),

              const SizedBox(width: 12),

              GestureDetector(
                onTap: phone.isEmpty ? null : () => _makePhoneCall(phone),
                child: const Icon(Icons.call, color: Color(0xff2F80ED)),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            "DELIVERY ADDRESS",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "${shipping.address}, ${shipping.city}, ${shipping.state}"
            "${shipping.postalCode.isNotEmpty ? " - ${shipping.postalCode}" : ""}",
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepCard() {
    bool isDelivered = order.tracking.status == "delivered";

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: isDelivered ? Colors.green : Color(0xff2F80ED),
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: isDelivered
            ? null
            : () async {
                await dtClrl.changeOrderStatus(
                  orderId: order.id,
                  status: "delivered",
                );
              },
        child: Text(isDelivered ? "Delivered" : "Mark as Delivered"),
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("${order.items.length} items"),
          SizedBox(height: 12),
          ...order.items.map(
            (item) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "${item.quantity}x ${item.product.name}",
                  style: TextStyle(fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIssueCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.orange),
              SizedBox(width: 8),
              Text(
                "Issues with delivery?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "If you can’t complete this order due to vehicle issues or emergency, you can transfer it.",
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              // Get.to(
              //   () => TransferOrderScreen(
              //     orderNumber: order.orderNumber,
              //     orderId: order.id,
              //   ),
              // );
            },
            child: const Text("Transfer Order"),
          ),
        ],
      ),
    );
  }

  Widget _cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}

class TimelineTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final bool isActive;
  final bool isFirst;
  final bool isLast;
  const TimelineTile({
    super.key,
    required this.title,
    required this.subtitle,
    this.isCompleted = false,
    this.isActive = false,
    this.isFirst = false,
    this.isLast = false,
  });
  @override
  Widget build(BuildContext context) {
    Color circleColor = Colors.grey.shade300;
    if (isCompleted || isActive) circleColor = Colors.blue;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(width: 2, height: 20, color: Colors.grey.shade300),
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: circleColor,
                shape: BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(width: 2, height: 40, color: Colors.grey.shade300),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: isActive ? Colors.blue : Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

Future<void> _makePhoneCall(String phone) async {
  final Uri uri = Uri(scheme: 'tel', path: phone);

  if (await canLaunchUrl(uri)) {
    await launchUrl(uri);
  } else {
    Get.snackbar("Error", "Cannot open dialer");
  }
}
