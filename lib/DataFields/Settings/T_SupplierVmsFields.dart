class SupplierVmsFields {
  static const String name = "Supplier Pass List";
  static const String missing = "Missing Status";
  static const String using = "Using Status";
  static const String lastCheck = "Last Check";

  // Return a List of fields defined
  static List<String> getFields() => [name, missing, using, lastCheck];
}
