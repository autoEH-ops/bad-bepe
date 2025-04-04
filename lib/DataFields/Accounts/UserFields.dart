class UserFields {
  static const name = "Name";
  static const email = "Email";
  static const contact = "Contact";

  static List<String> getFields() => [name, email, contact];
}

class UserFieldsData {
  String? name;
  String? email;
  String? contact;

  UserFieldsData({
    required this.name,
    required this.email,
    required this.contact,
  });

  Map<String, dynamic> toJson() => {
        UserFields.name: name,
        UserFields.email: email,
        UserFields.contact: contact,
      };
}
