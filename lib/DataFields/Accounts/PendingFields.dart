// Only create header
class PendingAccountFields {
  static const String email = "Email";
  static const String name = "Name";
  static const String phone = "Phone";
  static const String role = "Role";

  // Return a List of fields defined
  static List<String> getFields() => [email, name, phone, role];
}
