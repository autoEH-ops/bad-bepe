import '../GoogleAPIs/GoogleSpreadSheet.dart';

class RegisterService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.accountsPage == null) {
      await GoogleSheets.connectToAccountDetails();
    }
  }

  // Helper method to format phone number
  String formatPhoneNumber(String phone) {
    return phone.startsWith('+') ? "'$phone" : phone;
  }

  Future<bool> checkEmailOrPhoneExist(String email, String phone) async {
    try {
      await ensureSheetsConnected(); // Ensure the Google Sheets connection is ready
      List<Map<String, dynamic>> accounts = await googleSheetsApi.getAccounts();

      bool emailExists =
      accounts.any((account) => account['Email'] == email.toLowerCase());
      bool phoneExists = accounts.any((account) => account['Phone'] == phone);

      return !(emailExists || phoneExists);
    } catch (e) {
      print("Error: $e");
      return true; // Assuming true means no error, email/phone doesn't exist
    }
  }

  Future<void> addSuperAdmin(
      String email, String name, String phone, String role, String createdBy) async {
    await ensureSheetsConnected();
    await GoogleSheets.accountsPage!.values.appendRow([
      email.toLowerCase(),
      "",
      name.toUpperCase(),
      formatPhoneNumber(phone), // Formatted phone number
      role,
      DateTime.now().toIso8601String(), // Timestamp
      createdBy // Creator's name or email
    ]);
    // Add the name to the Security Name List page and append TRUE values
    await GoogleSheets.settingpage!.values.appendRow([
      name.toUpperCase(),
      role,
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE"
    ]);
  }

  Future<void> addAdmin(
      String email, String name, String phone, String role, String createdBy) async {
    await ensureSheetsConnected();
    await GoogleSheets.accountsPage!.values.appendRow([
      email.toLowerCase(),
      "",
      name.toUpperCase(),
      formatPhoneNumber(phone), // Formatted phone number
      role,
      DateTime.now().toIso8601String(), // Timestamp
      createdBy // Creator's name or email
    ]);
    // Add the name to the Security Name List page and append TRUE values
    await GoogleSheets.settingpage!.values.appendRow([
      name.toUpperCase(),
       role,
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE"
    ]);
  }

  Future<void> addSecurity(
      String email, String name, String phone, String role, String createdBy) async {
    await ensureSheetsConnected();
    await GoogleSheets.accountsPage!.values.appendRow([
      email.toLowerCase(),
      "",
      name.toUpperCase(),
      formatPhoneNumber(phone), // Formatted phone number
      role,
      DateTime.now().toIso8601String(), // Timestamp
      createdBy // Creator's name or email
    ]);

    // Add the name to the Security Name List page and append TRUE values
    await GoogleSheets.settingpage!.values.appendRow([
      name.toUpperCase(),
      role,
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE"
    ]);
  }

  Future<void> addViewer(
      String email, String name, String phone, String role, String createdBy) async {
    await ensureSheetsConnected();
    await GoogleSheets.accountsPage!.values.appendRow([
      email.toLowerCase(),
      "",
      name.toUpperCase(),
      formatPhoneNumber(phone), // Formatted phone number
      role,
      DateTime.now().toIso8601String(), // Timestamp
      createdBy // Creator's name or email
    ]);
    // Add the name to the Security Name List page and append TRUE values
    await GoogleSheets.settingpage!.values.appendRow([
      name.toUpperCase(),
      role,
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
      "TRUE",
    ]);
  }


  Future<void> addPendingList(
      String email, String name, String phone, String role, String createdBy) async {
    await ensureSheetsConnected();
    await GoogleSheets.accountsPage!.values.appendRow([
      email.toLowerCase(),
      "",
      name.toUpperCase(),
      formatPhoneNumber(phone), // Formatted phone number
      role,
      DateTime.now().toIso8601String(), // Timestamp
      createdBy // Creator's name or email
    ]);
  }
  // In your RegisterService or a suitable class
  Future<String> getNameByEmail(String email) async {
    await ensureSheetsConnected();
    final accounts = await googleSheetsApi.getAccounts();

    for (var account in accounts) {
      if (account['Email'] == email) {
        return account['Name'] ?? 'Unknown'; // Return the name if found
      }
    }
    return 'Unknown'; // Return 'Unknown' if no matching email is found
  }

}
