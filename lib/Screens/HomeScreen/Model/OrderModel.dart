class OrderModel {
  final String id;
  final String orderNumber;
  String status;
  final String paymentStatus;
  final String paymentMethod;
  final String totalAmount;
  final String shippingCost;
  final String taxAmount;
  final String discountAmount;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final CustomerProfile customerProfile;
  final ShippingAddress shippingAddress;
  final Tracking tracking;
  final List<OrderItem> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.paymentStatus,
    required this.paymentMethod,
    required this.totalAmount,
    required this.shippingCost,
    required this.taxAmount,
    required this.discountAmount,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
    required this.customerProfile,
    required this.shippingAddress,
    required this.tracking,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json["id"] ?? "",
      orderNumber: json["orderNumber"] ?? "",
      status: json["status"] ?? "",
      paymentStatus: json["paymentStatus"] ?? "",
      paymentMethod: json["paymentMethod"] ?? "",
      totalAmount: json["totalAmount"] ?? "0",
      shippingCost: json["shippingCost"] ?? "0",
      taxAmount: json["taxAmount"] ?? "0",
      discountAmount: json["discountAmount"] ?? "0",
      notes: json["notes"],
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
      customerProfile: CustomerProfile.fromJson(json["CustomerProfile"] ?? {}),
      shippingAddress: ShippingAddress.fromJson(json["shippingAddress"] ?? {}),
      tracking: Tracking.fromJson(json["tracking"] ?? {}),
      items: (json["items"] as List<dynamic>? ?? [])
          .map((item) => OrderItem.fromJson(item))
          .toList(),
    );
  }

  // ---------------- COPY WITH ----------------
  OrderModel copyWith({Tracking? tracking, String? status}) {
    return OrderModel(
      id: id,
      orderNumber: orderNumber,
      status: status ?? this.status,
      paymentStatus: paymentStatus,
      paymentMethod: paymentMethod,
      totalAmount: totalAmount,
      shippingCost: shippingCost,
      taxAmount: taxAmount,
      discountAmount: discountAmount,
      notes: notes,
      createdAt: createdAt,
      updatedAt: DateTime.now(),
      customerProfile: customerProfile,
      shippingAddress: shippingAddress,
      tracking: tracking ?? this.tracking,
      items: items,
    );
  }
}

class CustomerProfile {
  final String id;
  final String name;
  final String phone;

  CustomerProfile({required this.id, required this.name, required this.phone});

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}

class ShippingAddress {
  final String id;
  final String customerProfileId;
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String? landmark;
  final String country;
  final String? phone;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  ShippingAddress({
    required this.id,
    required this.customerProfileId,
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    this.landmark,
    required this.country,
    this.phone,
    required this.isDefault,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      id: json["id"] ?? "",
      customerProfileId: json["customerProfileId"] ?? "",
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      city: json["city"] ?? "",
      state: json["state"] ?? "",
      postalCode: json["postalCode"] ?? "",
      landmark: json["landmark"],
      country: json["country"] ?? "",
      phone: json["phone"],
      isDefault: json["isDefault"] ?? false,
      createdAt: DateTime.parse(
        json["createdAt"] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json["updatedAt"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }
}

class Tracking {
  final String id;
  final String orderId;
  final String carrier;
  final String trackingNumber;
  final String? trackingUrl;
  String status;
  // final dynamic statusHistory;
  final DateTime lastUpdatedAt;

  Tracking({
    required this.id,
    required this.orderId,
    required this.carrier,
    required this.trackingNumber,
    this.trackingUrl,
    required this.status,
    //  this.statusHistory,
    required this.lastUpdatedAt,
  });

  factory Tracking.fromJson(Map<String, dynamic> json) {
    return Tracking(
      id: json["id"] ?? "",
      orderId: json["orderId"] ?? "",
      carrier: json["carrier"] ?? "",
      trackingNumber: json["trackingNumber"] ?? "",
      trackingUrl: json["trackingUrl"],
      status: json["status"] ?? "",
      // statusHistory: json["statusHistory"],
      lastUpdatedAt: DateTime.parse(
        json["lastUpdatedAt"] ?? DateTime.now().toIso8601String(),
      ),
    );
  }

  // ---------------- COPY WITH ----------------
  Tracking copyWith({String? status, DateTime? lastUpdatedAt}) {
    return Tracking(
      id: id,
      orderId: orderId,
      carrier: carrier,
      trackingNumber: trackingNumber,
      trackingUrl: trackingUrl,
      status: status ?? this.status,
      //   statusHistory: statusHistory,
      lastUpdatedAt: lastUpdatedAt ?? this.lastUpdatedAt,
    );
  }
}

class OrderItem {
  final String id;
  final int quantity;
  final Product product;
  final dynamic productVariation;

  OrderItem({
    required this.id,
    required this.quantity,
    required this.product,
    this.productVariation,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json["id"] ?? "",
      quantity: json["quantity"] ?? 0,
      product: Product.fromJson(json["product"] ?? {}),
      productVariation: json["productVariation"],
    );
  }
}

class Product {
  final String id;
  final String name;
  final List<dynamic> images;

  Product({required this.id, required this.name, required this.images});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json["id"] ?? "",
      name: json["name"] ?? "",
      images: json["images"] ?? [],
    );
  }
}
