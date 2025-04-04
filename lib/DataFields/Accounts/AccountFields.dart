class AccountFields {
  static const String email = "Email";
  static const String otp = "OTP";
  static const String name = "Name";
  static const String phone = "Phone";
  static const String role = "Role";
  static const String id = "Id";

  // Return a List of fields defined
  static List<String> getFields() => [email, otp, name, phone, role, id];

}

class AccountFieldsData {
  String? email;
  String? otp;
  String? name;
  String? phone;
  String? role;
  String? id;

  AccountFieldsData({
    required this.email,
    required this.otp,
    required this.name,
    required this.phone,
    required this.role,
    required this.id,
  });

  static AccountFieldsData fromJson(Map<String, dynamic> json) =>
      AccountFieldsData(
        email: json[AccountFields.email],
        otp: json[AccountFields.otp],
        name: json[AccountFields.name],
        phone: json[AccountFields.phone],
        role: json[AccountFields.role],
        id: json[AccountFields.id]
      );

  Map<String, dynamic> toJson() => {
        AccountFields.email: email,
        AccountFields.otp: otp,
        AccountFields.name: name,
        AccountFields.phone: phone,
        AccountFields.role: role,
      AccountFields.id: id,
      };
}
