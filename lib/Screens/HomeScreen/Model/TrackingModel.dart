class TrackingResponse {
  final bool success;
  final TrackingData? data;

  TrackingResponse({
    required this.success,
    this.data,
  });

  factory TrackingResponse.fromJson(Map<String, dynamic> json) {
    return TrackingResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? TrackingData.fromJson(json['data'])
          : null,
    );
  }
}

class TrackingData {
  final String id;
  final String orderId;
  final String carrier;
  final String trackingNumber;
  final String? trackingUrl;
  final String status;
  final String? lastUpdatedAt;
  final TrackingOrder order;

  TrackingData({
    required this.id,
    required this.orderId,
    required this.carrier,
    required this.trackingNumber,
    this.trackingUrl,
    required this.status,
    this.lastUpdatedAt,
    required this.order,
  });

  factory TrackingData.fromJson(Map<String, dynamic> json) {
    return TrackingData(
      id: json['id'] ?? "",
      orderId: json['orderId'] ?? "",
      carrier: json['carrier'] ?? "",
      trackingNumber: json['trackingNumber'] ?? "",
      trackingUrl: json['trackingUrl'],
      status: json['status'] ?? "",
      lastUpdatedAt: json['lastUpdatedAt'],
      order: TrackingOrder.fromJson(json['order'] ?? {}),
    );
  }
}

class TrackingOrder {
  final String orderNumber;
  final String status;
  final CustomerProfile customer;

  TrackingOrder({
    required this.orderNumber,
    required this.status,
    required this.customer,
  });

  factory TrackingOrder.fromJson(Map<String, dynamic> json) {
    return TrackingOrder(
      orderNumber: json['orderNumber'] ?? "",
      status: json['status'] ?? "",
      customer:
          CustomerProfile.fromJson(json['CustomerProfile'] ?? {}),
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
      name: json['name'] ?? "",
      phone: json['phone'] ?? "",
    );
  }
}