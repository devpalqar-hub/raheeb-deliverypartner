import 'package:flutter/material.dart';
import 'package:raheeb_deliverypartner/Screens/HomeScreen/Views/order_card.dart';
import 'package:raheeb_deliverypartner/Screens/OrderDetails/order_details.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {

    final List<Map<String, dynamic>> orders = [
      {
        "title": "Burger King",
        "orderId": "#OD-4923",
        "branch": "Downtown Branch",
        "pickup": "124 Main Street, West Side",
        "delivery": "Apartment 4B, 892 Broadway",
        "earning": "\$8.50",
        "status": "ASSIGNED",
      },
      {
        "title": "Rose Garden Florist",
        "orderId": "#OD-5102",
        "branch": "East Village",
        "pickup": "45 Flower Ave, Suite 2",
        "delivery": "77 Sunset Blvd, House 12",
        "earning": "\$12.00",
        "status": "QUEUED",
      },
      {
        "title": "City Pharmacy",
        "orderId": "#OD-5299",
        "branch": "North Hill",
        "pickup": "200 Health Plaza",
        "delivery": "Old Town Residency, Apt 5",
        "earning": "\$5.25",
        "status": "QUEUED",
      },
    ];

    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Delivery Dashboard"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                "Assigned Orders",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                "View Map",
                style: TextStyle(color: Colors.blue),
              ),
            ],
          ),

          const SizedBox(height: 16),

          ...orders.map((order) {
            return OrderCard(
              title: order["title"],
              orderId: order["orderId"],
              branch: order["branch"],
              pickup: order["pickup"],
              delivery: order["delivery"],
              earning: order["earning"],
              status: order["status"],
              buttonText: order["status"] == "ASSIGNED"
                  ? "Start Task"
                  : "View Details",
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrderDetailsScreen(order: order),
                  ),
                );
              },
            );
          }).toList(),

          const SizedBox(height: 24),

          const Text(
            "Today's Performance",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 16),

          Row(
            children: const [
              Expanded(
                child: PerformanceCard(
                  icon: Icons.check,
                  iconColor: Colors.green,
                  count: 12,
                  label: "Done",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: PerformanceCard(
                  icon: Icons.access_time,
                  iconColor: Colors.orange,
                  count: 3,
                  label: "Pending",
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: PerformanceCard(
                  icon: Icons.refresh,
                  iconColor: Colors.red,
                  count: 0,
                  label: "Returns",
                ),
              ),
            ],
          ),

          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class PerformanceCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final int count;
  final String label;

  const PerformanceCard({
    super.key,
    required this.icon,
    required this.iconColor,
    required this.count,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          CircleAvatar(
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(icon, color: iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            "$count",
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
