import 'package:flutter/material.dart';

class OrderDetailsScreen extends StatelessWidget {
  final Map<String, dynamic> order;

  const OrderDetailsScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F6FA),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: Text(
          "Order ${order["orderId"]}",
          style: const TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    "TRACKING STATUS",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 20),

                  TimelineTile(
                    title: "Order Picked Up",
                    subtitle: "12:45 PM • McDonald's (Main St)",
                    isCompleted: true,
                    isFirst: true,
                  ),
                  TimelineTile(
                    title: "In Transit",
                    subtitle: "1:10 PM • Moving towards destination",
                    isCompleted: true,
                  ),
                  TimelineTile(
                    title: "Out for Delivery",
                    subtitle: "Expected 1:30 PM",
                    isActive: true,
                  ),
                  TimelineTile(
                    title: "Delivered",
                    subtitle: "Pending arrival",
                    isLast: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _card(
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

                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Jane Doe",
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600),
                            ),
                            SizedBox(height: 4),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    size: 14,
                                    color: Colors.amber),
                                SizedBox(width: 4),
                                Text(
                                  "4.8 • 24 orders",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      _roundIcon(Icons.chat_bubble_outline),
                      const SizedBox(width: 8),
                      _roundIcon(Icons.call),
                    ],
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    "DELIVERY ADDRESS",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    children: [
                      const Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on,
                                    size: 16,
                                    color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  "123 Main St, Apt 4B",
                                  style: TextStyle(
                                      fontWeight:
                                      FontWeight.w600),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Springfield, IL 62704",
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey),
                            ),
                            SizedBox(height: 6),
                            Row(
                              children: [
                                Icon(Icons.lock,
                                    size: 14,
                                    color: Colors.grey),
                                SizedBox(width: 4),
                                Text(
                                  "Gate: 4921",
                                  style: TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),

                      Container(
                        height: 52,
                        width: 52,
                        decoration: BoxDecoration(
                          color: const Color(0xffE8F0FE),
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                        child: const Column(
                          mainAxisAlignment:
                          MainAxisAlignment.center,
                          children: [
                            Icon(Icons.navigation,
                                color: Colors.blue),
                            SizedBox(height: 2),
                            Text(
                              "NAV",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blue),
                            )
                          ],
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    "NEXT STEP",
                    style: TextStyle(
                        fontSize: 11,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 12),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "Arrive at Customer Location",
                        style: TextStyle(
                            fontWeight: FontWeight.w600),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4),
                        decoration: BoxDecoration(
                          color:
                          const Color(0xffE8F0FE),
                          borderRadius:
                          BorderRadius.circular(20),
                        ),
                        child: const Text(
                          "Est. 5 mins",
                          style: TextStyle(
                              fontSize: 12,
                              color: Colors.blue),
                        ),
                      )
                    ],
                  ),

                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      icon: const Icon(
                          Icons.check_circle_outline,
                          size: 20),
                      label: const Text(
                        "Mark as Delivered",
                        style:
                        TextStyle(fontSize: 15),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xff3B82F6),
                        padding:
                        const EdgeInsets.symmetric(
                            vertical: 15),
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(
                              28),
                        ),
                        elevation: 6,
                        shadowColor:
                        Colors.blue.shade200,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        "ORDER SUMMARY",
                        style: TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding:
                        const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4),
                        decoration: BoxDecoration(
                          color:
                          Colors.grey.shade200,
                          borderRadius:
                          BorderRadius.circular(
                              20),
                        ),
                        child:
                        const Text("3 items"),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  _summaryRow(
                      "2x Large Pepperoni Pizza",
                      "\$32.00"),
                  _summaryRow(
                      "1x Coke Zero (500ml)",
                      "\$2.50"),

                  const Divider(height: 24),

                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Total (Paid)",
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold),
                      ),
                      Text(
                        "\$34.50",
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            _card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: const [
                      Icon(Icons
                          .warning_amber_rounded,
                          color:
                          Colors.orange),
                      SizedBox(width: 8),
                      Text(
                        "Issues with delivery?",
                        style: TextStyle(
                            fontWeight:
                            FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "If you can’t complete this order due to vehicle issues or emergency, you can transfer it.",
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      style:
                      OutlinedButton.styleFrom(
                        shape:
                        RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius
                              .circular(12),
                        ),
                      ),
                      onPressed: () {},
                      child:
                      const Text("Transfer Order"),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _card({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: child,
    );
  }

  static Widget _summaryRow(
      String title, String price) {
    return Padding(
      padding:
      const EdgeInsets.only(bottom: 10),
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

  static Widget _roundIcon(
      IconData icon) {
    return Container(
      height: 36,
      width: 36,
      decoration: const BoxDecoration(
        color: Color(0xffE8F0FE),
        shape: BoxShape.circle,
      ),
      child: Icon(icon,
          size: 18,
          color: Colors.blue),
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
    Color circleColor =
        Colors.grey.shade300;
    if (isCompleted ||
        isActive) circleColor = Colors.blue;

    return Row(
      crossAxisAlignment:
      CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            if (!isFirst)
              Container(
                width: 2,
                height: 20,
                color: Colors
                    .grey.shade300,
              ),
            Container(
              width: 18,
              height: 18,
              decoration:
              BoxDecoration(
                color: circleColor,
                shape:
                BoxShape.circle,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 40,
                color: Colors
                    .grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Padding(
            padding:
            const EdgeInsets.only(
                bottom: 20),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment
                  .start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontWeight:
                    isActive
                        ? FontWeight
                        .bold
                        : FontWeight
                        .w500,
                  ),
                ),
                const SizedBox(
                    height: 4),
                Text(
                  subtitle,
                  style:
                  TextStyle(
                    fontSize: 13,
                    color: isActive
                        ? Colors
                        .blue
                        : Colors
                        .grey,
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
