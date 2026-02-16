import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Model/OrderModel.dart';
import 'package:raheeb_deliverypartner/Screens/TransferScreen/TransferScreen.dart';

class OrderDetailsScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Order ${order.orderNumber}"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildTrackingCard(),
            const SizedBox(height: 16),
            _buildCustomerCard(),
            const SizedBox(height: 16),
            _buildNextStepCard(),
            const SizedBox(height: 16),
            _buildOrderSummaryCard(),
            const SizedBox(height: 16),
            _buildIssueCard(),
          ],
        ),
      ),
    );
  }

  /// ================= TRACKING =================
  Widget _buildTrackingCard() {
    final status = order.trackingStatus;

    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "TRACKING STATUS",
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),

          TrackingItem(
              title: "Order Picked Up",
              active: status != null),
          TrackingItem(
              title: "In Transit",
              active: status == "in_transit" ||
                  status == "out_for_delivery"),
          TrackingItem(
              title: "Out for Delivery",
              active: status == "out_for_delivery"),
          TrackingItem(
              title: "Delivered",
              active: status == "delivered"),
        ],
      ),
    );
  }

  /// ================= CUSTOMER =================
  Widget _buildCustomerCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 22,
                backgroundImage:
                    NetworkImage("https://i.pravatar.cc/100"),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  order.customerName,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              const Icon(Icons.chat, color: Colors.blue),
              const SizedBox(width: 12),
              const Icon(Icons.call, color: Colors.blue),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            "DELIVERY ADDRESS",
            style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
                fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),

          Text(
            "${order.address},\n${order.city}, ${order.postalCode}",
          ),
        ],
      ),
    );
  }

  /// ================= NEXT STEP =================
  Widget _buildNextStepCard() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
        onPressed: () {},
        child: const Text("Mark as Delivered"),
      ),
    );
  }

  /// ================= ORDER SUMMARY =================
  Widget _buildOrderSummaryCard() {
  return _cardContainer(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [

        const Text(
          "ORDER SUMMARY",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 16),

        /// SINGLE ITEM (as per model)
        _SummaryRow(
          order.productName,
          "Qty ${order.quantity}",
        ),

        const SizedBox(height: 12),
        const Divider(),
        const SizedBox(height: 8),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Total (Paid)",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              "₹${order.totalAmount}",
              style: const TextStyle(
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ],
    ),
  );
}

  /// ================= ISSUE =================
  Widget _buildIssueCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.orange),
              SizedBox(width: 8),
              Text(
                "Issues with delivery?",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
              "If you can’t complete this order due to vehicle issues or emergency, you can transfer it."),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              Get.to(() => const TransferOrderScreen());
            },
            child: const Text("Transfer Order"),
          )
        ],
      ),
    );
  }

  /// ================= CARD CONTAINER =================
  Widget _cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16)),
      child: child,
    );
  }
}

/// ================= TRACKING ITEM =================
class TrackingItem extends StatelessWidget {
  final String title;
  final bool active;

  const TrackingItem(
      {super.key, required this.title, required this.active});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color:
                  active ? Colors.blue : Colors.grey.shade300,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
                fontWeight:
                    active ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }
}

/// ================= SUMMARY ROW =================
class _SummaryRow extends StatelessWidget {
  final String title;
  final String price;

  const _SummaryRow(this.title, this.price);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Text(title),
          Text(price),
        ],
      ),
    );
  }
}