import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: Text("Order ${order["orderId"]}"),
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


  Widget _buildTrackingCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "TRACKING STATUS",
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 16),

          TrackingItem(title: "Order Picked Up", active: true),
          TrackingItem(title: "In Transit", active: true),
          TrackingItem(title: "Out for Delivery", active: false),
          TrackingItem(title: "Delivered", active: false),
        ],
      ),
    );
  }

  Widget _buildCustomerCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            children: const [
              CircleAvatar(
                radius: 22,
                backgroundImage: NetworkImage(
                    "https://i.pravatar.cc/100"),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Text(
                  "Jane Doe",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16),
                ),
              ),
              Icon(Icons.chat, color: Colors.blue),
              SizedBox(width: 12),
              Icon(Icons.call, color: Colors.blue),
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

          const Text(
            "123 Main St, Apt 4B\nSpringfield, IL 62704",
          ),
        ],
      ),
    );
  }


  Widget _buildNextStepCard() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30)),
            ),
            onPressed: () {},
            child: const Text("Mark as Delivered"),
          ),
        ),
      ],
    );
  }


  Widget _buildOrderSummaryCard() {
    return _cardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "ORDER SUMMARY",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
              Text("3 items"),
            ],
          ),

          SizedBox(height: 16),

          _SummaryRow("Large Pepperoni Pizza", "\$32.00"),
          _SummaryRow("Coke Zero (500ml)", "\$2.50"),

          SizedBox(height: 12),
          Divider(),
          SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total (Paid)",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
              Text(
                "\$34.50",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ],
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
            children: const [
              Icon(Icons.warning_amber_rounded,
                  color: Colors.orange),
              SizedBox(width: 8),
              Text(
                "Issues with delivery?",
                style: TextStyle(
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "If you can’t complete this order due to vehicle issues or emergency, you can transfer it.",
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {},
            child: const Text("Transfer Order"),
          )
        ],
      ),
    );
  }


  Widget _cardContainer({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: child,
    );
  }
}


class TrackingItem extends StatelessWidget {
  final String title;
  final bool active;

  const TrackingItem({
    super.key,
    required this.title,
    required this.active,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 18,
          height: 18,
          decoration: BoxDecoration(
            color: active
                ? Colors.blue
                : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontWeight:
            active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

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
