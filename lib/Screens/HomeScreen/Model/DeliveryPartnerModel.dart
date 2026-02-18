class DeliveryPartnerModel {
  final String id;
  final String email;
  final String role;
  final bool isActive;
  final String? name;
  final String? phone;
  final String? profilePicture;

  DeliveryPartnerModel({
    required this.id,
    required this.email,
    required this.role,
    required this.isActive,
    this.name,
    this.phone,
    this.profilePicture,
  });

  factory DeliveryPartnerModel.fromJson(Map<String, dynamic> json) {
    final profile = json["AdminProfile"];

    return DeliveryPartnerModel(
      id: json["id"] ?? "",
      email: json["email"] ?? "",
      role: json["role"] ?? "",
      isActive: json["isActive"] ?? false,
      name: profile?["name"],
      phone: profile?["phone"],
      profilePicture: profile?["profilePicture"],
    );
  }
}