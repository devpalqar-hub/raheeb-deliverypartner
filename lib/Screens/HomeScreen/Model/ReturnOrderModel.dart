// ---------------- Return Order Model ----------------
import 'package:flutter/foundation.dart';

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
  final String? returnPaymentMethod;
  final String? adminNotes;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Order order;
  final CustomerProfile customerProfile;
  final List<ReturnItem> returnItems;

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
    this.returnPaymentMethod,
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
      returnPaymentMethod: json['returnPaymentMethod'],
      adminNotes: json['adminNotes'],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      updatedAt: DateTime.parse(json['updatedAt'] ?? DateTime.now().toIso8601String()),
      order: Order.fromJson(json['order'] ?? {}),
      customerProfile: CustomerProfile.fromJson(json['customerProfile'] ?? {}),
      returnItems: (json['returnItems'] as List<dynamic>? ?? [])
          .map((item) => ReturnItem.fromJson(item))
          .toList(),
    );
  }

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
      returnPaymentMethod: returnPaymentMethod ?? this.returnPaymentMethod,
      adminNotes: adminNotes ?? this.adminNotes,
      createdAt: createdAt,
      updatedAt: updatedAt,
      order: order,
      customerProfile: customerProfile,
      returnItems: returnItems,
    );
  }
}

// ---------------- Order ----------------
class Order {
  final String orderNumber;
  final String totalAmount;
  final ShippingAddress? shippingAddress;

  Order({
    required this.orderNumber,
    required this.totalAmount,
    this.shippingAddress,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      orderNumber: json['orderNumber'] ?? '',
      totalAmount: json['totalAmount'] ?? '0',
      shippingAddress: json['shippingAddress'] != null
          ? ShippingAddress.fromJson(json['shippingAddress'])
          : null,
    );
  }
}

// ---------------- Customer Profile ----------------
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

// ---------------- Shipping Address ----------------
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

// ---------------- Return Item ----------------
class ReturnItem {
  final String id;
  final String returnId;
  final String orderItemId;
  final int quantity;
  final String reason;
  final OrderItem orderItem;

  ReturnItem({
    required this.id,
    required this.returnId,
    required this.orderItemId,
    required this.quantity,
    required this.reason,
    required this.orderItem,
  });

  factory ReturnItem.fromJson(Map<String, dynamic> json) {
    return ReturnItem(
      id: json['id'] ?? '',
      returnId: json['returnId'] ?? '',
      orderItemId: json['orderItemId'] ?? '',
      quantity: json['quantity'] ?? 0,
      reason: json['reason'] ?? '',
      orderItem: OrderItem.fromJson(json['orderItem'] ?? {}),
    );
  }
}

// ---------------- Order Item ----------------
class OrderItem {
  final String id;
  final String orderId;
  final String productId;
  final int quantity;
  final bool isReturned;
  final String discountedPrice;
  final String actualPrice;
  final Product product;

  OrderItem({
    required this.id,
    required this.orderId,
    required this.productId,
    required this.quantity,
    required this.isReturned,
    required this.discountedPrice,
    required this.actualPrice,
    required this.product,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'] ?? '',
      orderId: json['orderId'] ?? '',
      productId: json['productId'] ?? '',
      quantity: json['quantity'] ?? 0,
      isReturned: json['isReturned'] ?? false,
      discountedPrice: json['discountedPrice'] ?? '0',
      actualPrice: json['actualPrice'] ?? '0',
      product: Product.fromJson(json['product'] ?? {}),
    );
  }
}

// ---------------- Product ----------------
class Product {
  final String name;
  final List<ProductImage> images;

  Product({
    required this.name,
    required this.images,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      name: json['name'] ?? '',
      images: (json['images'] as List<dynamic>? ?? [])
          .map((img) => ProductImage.fromJson(img))
          .toList(),
    );
  }
}

// ---------------- Product Image ----------------
class ProductImage {
  final String id;
  final String productId;
  final String url;
  final String altText;
  final bool isMain;

  ProductImage({
    required this.id,
    required this.productId,
    required this.url,
    required this.altText,
    required this.isMain,
  });

  factory ProductImage.fromJson(Map<String, dynamic> json) {
    return ProductImage(
      id: json['id'] ?? '',
      productId: json['productId'] ?? '',
      url: json['url'] ?? '',
      altText: json['altText'] ?? '',
      isMain: json['isMain'] ?? false,
    );
  }
}