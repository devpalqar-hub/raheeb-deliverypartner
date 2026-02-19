/// =======================================================
/// DELIVERY ACTION RESPONSE MODEL
/// API: /v1/delivery-partners/my/actions
/// =======================================================

class DeliveryActionResponse {
  final bool success;
  final DeliveryActionData data;

  DeliveryActionResponse({
    required this.success,
    required this.data,
  });

  factory DeliveryActionResponse.fromJson(Map<String, dynamic> json) {
    return DeliveryActionResponse(
      success: json["success"] ?? false,
      data: DeliveryActionData.fromJson(json["data"] ?? {}),
    );
  }
}

/// =======================================================
/// MAIN DATA
/// =======================================================

class DeliveryActionData {
  final List<ActionOrder> orders;
  final List<ActionReturn> returns;

  DeliveryActionData({
    required this.orders,
    required this.returns,
  });

  factory DeliveryActionData.fromJson(Map<String, dynamic> json) {
    return DeliveryActionData(
      orders: (json["orders"] as List? ?? [])
          .map((e) => ActionOrder.fromJson(e))
          .toList(),
      returns: (json["returns"] as List? ?? [])
          .map((e) => ActionReturn.fromJson(e))
          .toList(),
    );
  }
}

/// =======================================================
/// ORDER MODEL
/// =======================================================

class ActionOrder {
  final String id;
  final String orderNumber;
  final String status;
  final DateTime createdAt;
  final OrderTracking tracking;
  final ShippingAddress? shippingAddress;
  final CustomerProfile customerProfile;

  ActionOrder({
    required this.id,
    required this.orderNumber,
    required this.status,
    required this.createdAt,
    required this.tracking,
    required this.shippingAddress,
    required this.customerProfile,
  });

  factory ActionOrder.fromJson(Map<String, dynamic> json) {
    return ActionOrder(
      id: json["id"] ?? "",
      orderNumber: json["orderNumber"] ?? "",
      status: json["status"] ?? "",
      createdAt:
          DateTime.tryParse(json["createdAt"] ?? "") ??
              DateTime.now(),
      tracking: OrderTracking.fromJson(json["tracking"] ?? {}),
      shippingAddress: json["shippingAddress"] != null
          ? ShippingAddress.fromJson(json["shippingAddress"])
          : null,
      customerProfile:
          CustomerProfile.fromJson(json["CustomerProfile"] ?? {}),
    );
  }
}

/// =======================================================
/// TRACKING
/// =======================================================

class OrderTracking {
  final String status;
  final DateTime lastUpdatedAt;

  OrderTracking({
    required this.status,
    required this.lastUpdatedAt,
  });

  factory OrderTracking.fromJson(Map<String, dynamic> json) {
    return OrderTracking(
      status: json["status"] ?? "",
      lastUpdatedAt:
          DateTime.tryParse(json["lastUpdatedAt"] ?? "") ??
              DateTime.now(),
    );
  }
}

/// =======================================================
/// CUSTOMER PROFILE
/// =======================================================

class CustomerProfile {
  final String name;
  final String phone;

  CustomerProfile({
    required this.name,
    required this.phone,
  });

  factory CustomerProfile.fromJson(Map<String, dynamic> json) {
    return CustomerProfile(
      name: json["name"] ?? "",
      phone: json["phone"] ?? "",
    );
  }
}

/// =======================================================
/// SHIPPING ADDRESS (nullable from API)
/// =======================================================

class ShippingAddress {
  final String? address;
  final String? city;
  final String? state;
  final String? postalCode;

  ShippingAddress({
    this.address,
    this.city,
    this.state,
    this.postalCode,
  });

  factory ShippingAddress.fromJson(Map<String, dynamic> json) {
    return ShippingAddress(
      address: json["address"],
      city: json["city"],
      state: json["state"],
      postalCode: json["postalCode"],
    );
  }
}

/// =======================================================
/// RETURN MODEL
/// =======================================================

class ActionReturn {
  final String id;
  final String status;
  final String refundAmount;
  final DateTime createdAt;
  final ReturnOrder order;
  final CustomerProfile customerProfile;

  ActionReturn({
    required this.id,
    required this.status,
    required this.refundAmount,
    required this.createdAt,
    required this.order,
    required this.customerProfile,
  });

  factory ActionReturn.fromJson(Map<String, dynamic> json) {
    return ActionReturn(
      id: json["id"] ?? "",
      status: json["status"] ?? "",
      refundAmount: json["refundAmount"]?.toString() ?? "0",
      createdAt:
          DateTime.tryParse(json["createdAt"] ?? "") ??
              DateTime.now(),
      order: ReturnOrder.fromJson(json["order"] ?? {}),
      customerProfile:
          CustomerProfile.fromJson(json["customerProfile"] ?? {}),
    );
  }
}

/// =======================================================
/// RETURN ORDER INFO
/// =======================================================

class ReturnOrder {
  final String id;
  final String orderNumber;

  ReturnOrder({
    required this.id,
    required this.orderNumber,
  });

  factory ReturnOrder.fromJson(Map<String, dynamic> json) {
    return ReturnOrder(
      id: json["id"] ?? "",
      orderNumber: json["orderNumber"] ?? "",
    );
  }
}