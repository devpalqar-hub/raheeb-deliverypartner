class AnalyticsResponse {
  final bool success;
  final AnalyticsData? data;

  AnalyticsResponse({
    required this.success,
    this.data,
  });

  factory AnalyticsResponse.fromJson(Map<String, dynamic> json) {
    return AnalyticsResponse(
      success: json['success'] ?? false,
      data: json['data'] != null
          ? AnalyticsData.fromJson(json['data'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "success": success,
      "data": data?.toJson(),
    };
  }
}

//////////////////////////////////////////////////////////////

class AnalyticsData {
  final Partner partner;
  final DateRange dateRange;
  final Summary summary;
  final Map<String, dynamic> ordersByStatus;
  final Map<String, dynamic> ordersByPaymentStatus;
  final List<dynamic> recentOrders;

  AnalyticsData({
    required this.partner,
    required this.dateRange,
    required this.summary,
    required this.ordersByStatus,
    required this.ordersByPaymentStatus,
    required this.recentOrders,
  });

  factory AnalyticsData.fromJson(Map<String, dynamic> json) {
    return AnalyticsData(
      partner: Partner.fromJson(json['partner'] ?? {}),
      dateRange: DateRange.fromJson(json['dateRange'] ?? {}),
      summary: Summary.fromJson(json['summary'] ?? {}),
      ordersByStatus:
          Map<String, dynamic>.from(json['ordersByStatus'] ?? {}),
      ordersByPaymentStatus:
          Map<String, dynamic>.from(json['ordersByPaymentStatus'] ?? {}),
      recentOrders: List<dynamic>.from(json['recentOrders'] ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "partner": partner.toJson(),
      "dateRange": dateRange.toJson(),
      "summary": summary.toJson(),
      "ordersByStatus": ordersByStatus,
      "ordersByPaymentStatus": ordersByPaymentStatus,
      "recentOrders": recentOrders,
    };
  }
}

//////////////////////////////////////////////////////////////

class Partner {
  final String id;
  final String email;
  final String name;
  final bool isActive;

  Partner({
    required this.id,
    required this.email,
    required this.name,
    required this.isActive,
  });

  factory Partner.fromJson(Map<String, dynamic> json) {
    return Partner(
      id: json['id']?.toString() ?? "",
      email: json['email'] ?? "",
      name: json['name'] ?? "",
      isActive: json['isActive'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "email": email,
      "name": name,
      "isActive": isActive,
    };
  }
}

//////////////////////////////////////////////////////////////

class DateRange {
  final String startDate;
  final String endDate;

  DateRange({
    required this.startDate,
    required this.endDate,
  });

  factory DateRange.fromJson(Map<String, dynamic> json) {
    return DateRange(
      startDate: json['startDate'] ?? "",
      endDate: json['endDate'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "startDate": startDate,
      "endDate": endDate,
    };
  }
}

//////////////////////////////////////////////////////////////

class Summary {
  final int totalOrders;
  final int totalRevenue;
  final int totalItems;
  final int completedOrders;
  final int pendingOrders;
  final int returnedOrdersCount;
  final int completedRevenue;
  final int averageOrderValue;

  Summary({
    required this.totalOrders,
    required this.totalRevenue,
    required this.totalItems,
    required this.completedOrders,
    required this.pendingOrders,
    required this.returnedOrdersCount,
    required this.completedRevenue,
    required this.averageOrderValue,
  });

  /// SAFE NUMBER PARSER
  static int _parseInt(dynamic value) {
    if (value == null) return 0;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  factory Summary.fromJson(Map<String, dynamic> json) {
    return Summary(
      totalOrders: _parseInt(json['totalOrders']),
      totalRevenue: _parseInt(json['totalRevenue']),
      totalItems: _parseInt(json['totalItems']),
      completedOrders: _parseInt(json['completedOrders']),
      pendingOrders: _parseInt(json['pendingOrders']),
      returnedOrdersCount: _parseInt(json['returnedOrdersCount']),
      completedRevenue: _parseInt(json['completedRevenue']),
      averageOrderValue: _parseInt(json['averageOrderValue']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "totalOrders": totalOrders,
      "totalRevenue": totalRevenue,
      "totalItems": totalItems,
      "completedOrders": completedOrders,
      "pendingOrders": pendingOrders,
      "returnedOrdersCount": returnedOrdersCount,
      "completedRevenue": completedRevenue,
      "averageOrderValue": averageOrderValue,
    };
  }
}