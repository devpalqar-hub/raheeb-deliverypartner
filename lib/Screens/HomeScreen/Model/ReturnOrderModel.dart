class ReturnOrder {
  final String id;
  final String orderId;
  final String customerProfileId;
  final String deliveryPartnerId;
  final String status;
  final String returnType;
  final String reason;
  final String refundAmount;
  final String returnFee;
  final String refundMethod;

  /// ✅ NEW FIELD
  final String? returnPaymentMethod;

  final String? adminNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Order order;
  final CustomerProfile customerProfile;
  final List<dynamic> returnItems;

  ReturnOrder({
    required this.id,
    required this.orderId,
    required this.customerProfileId,
    required this.deliveryPartnerId,
    required this.status,
    required this.returnType,
    required this.reason,
    required this.refundAmount,
    required this.returnFee,
    required this.refundMethod,
    this.returnPaymentMethod, // ✅ ADDED
    this.adminNotes,
    required this.createdAt,
    required this.updatedAt,
    required this.order,
    required this.customerProfile,
    required this.returnItems,
  });

  factory ReturnOrder.fromJson(Map<String, dynamic> json) {
    return ReturnOrder(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      customerProfileId: json['customerProfileId'] ?? '',
      deliveryPartnerId: json['deliveryPartnerId'] ?? '',
      status: json['status'] ?? '',
      returnType: json['returnType'] ?? '',
      reason: json['reason'] ?? '',
      refundAmount: json['refundAmount'] ?? '0',
      returnFee: json['returnFee'] ?? '0',
      refundMethod: json['refundMethod'] ?? '',

      /// ✅ PARSE NEW FIELD
      returnPaymentMethod: json['returnPaymentMethod'],

      adminNotes: json['adminNotes'],
      createdAt: DateTime.parse(
        json['createdAt'] ?? DateTime.now().toIso8601String(),
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] ?? DateTime.now().toIso8601String(),
      ),
      order: Order.fromJson(json['order'] ?? {}),
      customerProfile:
          CustomerProfile.fromJson(json['customerProfile'] ?? {}),
      returnItems: json['returnItems'] ?? [],
    );
  }

  /// ✅ UPDATED copyWith
  ReturnOrder copyWith({
    String? status,
    String? adminNotes,
    String? returnPaymentMethod,
  }) {
    return ReturnOrder(
      id: id,
      orderId: orderId,
      customerProfileId: customerProfileId,
      deliveryPartnerId: deliveryPartnerId,
      status: status ?? this.status,
      returnType: returnType,
      reason: reason,
      refundAmount: refundAmount,
      returnFee: returnFee,
      refundMethod: refundMethod,
      returnPaymentMethod:
          returnPaymentMethod ?? this.returnPaymentMethod,
      adminNotes: adminNotes ?? this.adminNotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      order: order,
      customerProfile: customerProfile,
      returnItems: returnItems,
    );
  }
}

class Order {
  final String orderNumber;
  final String totalAmount;
  final ShippingAddress shippingAddress;

  Order({
    required this.orderNumber,
    required this.totalAmount,
    required this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNumber: json['orderNumber'] ?? '',
      totalAmount: json['totalAmount'] ?? '0',
      shippingAddress:
          ShippingAddress.fromJson(json['shippingAddress'] ?? {}),
    );
  }
}

class CustomerProfile {
  final String name;
  final String phone;

  CustomerProfile({
    required this.name,
    required this.phone,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}

class ShippingAddress {
  final String name;
  final String address;
  final String city;
  final String state;
  final String postalCode;
  final String country;
  final String? phone;

  ShippingAddress({
    required this.name,
    required this.address,
    required this.city,
    required this.state,
    required this.postalCode,
    required this.country,
    this.phone,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      city: json['city'] ?? '',
      state: json['state'] ?? '',
      postalCode: json['postalCode'] ?? '',
      country: json['country'] ?? '',
      phone: json['phone'],
    );
  }
}