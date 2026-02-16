class OrderModel {
  final String id;
  final String orderNumber;
  final String status;
  final String paymentStatus;
  final String totalAmount;
  final String customerName;
  final String customerPhone;
  final String address;
  final String city;
  final String trackingStatus;
  final String productName;
  final int quantity;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.totalAmount,
    required this.customerName,
    required this.customerPhone,
    required this.address,
    required this.city,
    required this.trackingStatus,
    required this.productName,
    required this.quantity,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"],
      orderNumber: json["orderNumber"],
      status: json["status"],
      paymentStatus: json["paymentStatus"],
      totalAmount: json["totalAmount"],

      customerName: json["CustomerProfile"]["name"] ?? "",
      customerPhone: json["CustomerProfile"]["phone"] ?? "",

      address: json["shippingAddress"]["address"] ?? "",
      city: json["shippingAddress"]["city"] ?? "",

      trackingStatus: json["tracking"]["status"] ?? "",

      productName:
          json["items"][0]["product"]["name"] ?? "",
      quantity: json["items"][0]["quantity"] ?? 0,
    );
  }

  get postalCode => null;
}