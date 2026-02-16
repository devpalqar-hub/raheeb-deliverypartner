import 'package:flutter/material.dart';
import '../widgets/order_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text("Delivery Dashboard"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          OrderCard(
            title: "Burger King",
            orderId: "#ORD-4923",
            pickup: "124 Main Street, West Side",
            delivery: "Apartment 4B, 892 Broadway",
            earning: "\$8.50",
            status: "ASSIGNED",
            buttonText: "Start Task",
            onPressed: () {},
          ),

          OrderCard(
            title: "Rose Garden Florist",
            orderId: "#ORD-5102",
            pickup: "45 Flower Ave, Suite 2",
            delivery: "77 Sunset Blvd, House 12",
            earning: "\$12.00",
            status: "QUEUED",
            buttonText: "View Details",
            onPressed: () {},
          ),

        ],
      ),
    );
  }
}
