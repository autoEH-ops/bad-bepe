import '../GoogleAPIs/GoogleSpreadSheet.dart';

class ManageSecurityService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.settingpage == null) {
      await GoogleSheets.connectToAccountDetails();
    }
  }

  // Get the security personnel list from the sheet
  Future<List<Map<String, dynamic>>> getSecurityPersonnelList() async {
    await ensureSheetsConnected();
    try {
      var rows = await GoogleSheets.securityPersonnelNameListPage!.values.allRows();
      return rows.map((row) {
        return {
          'Name': row.isNotEmpty ? row[0] : null, // Check if row has data
          'Hourly Post Update Report Status': row.length > 1 ? row[1] : null,
          'Roll Call Report Status': row.length > 2 ? row[2] : null,
        };
      }).toList();
    } catch (e) {
      print("Error fetching security personnel list: $e");
      return [];
    }
  }

  // Retrieve settings from the "Setting Page" sheet
  Future<List<Map<String, dynamic>>> settingpage() async {
    await ensureSheetsConnected();
    try {
      var rows = await GoogleSheets.settingpage!.values.allRows(); // Access settingpage directly
      return rows.map((row) {
        return {
          'Email': row.isNotEmpty ? row[0] : null, // Assuming first column is email
          'Role': row.length > 1 ? row[1] : null, // Assuming second column is role
          'Hourly Post Update Reports Settings': row.length > 2 ? row[2] : null,
          'Roll Call Reports Settings': row.length > 3 ? row[3] : null,
          'Rounding Reports Settings': row.length > 4 ? row[4] : null,
          'Emergency Reports Settings': row.length > 5 ? row[5] : null,
          'VMS Contractor Settings': row.length > 6 ? row[6] : null,
          'Visitor Settings': row.length > 7 ? row[7] : null,
          'VMS Supplier Settings': row.length > 8 ? row[8] : null,
          'Key Management Settings': row.length > 9 ? row[9] : null,
          'Spot': row.length > 10 ? row[10] : null,
          'All Account': row.length > 11 ? row[11] : null,
          'Register Page': row.length > 12 ? row[12] : null,
          'VMS MENU': row.length > 13 ? row[13] : null,
          'QR MANAGEMENT': row.length > 14 ? row[14] : null,
          'Security Guard': row
              .length > 15 ? row[15] : null,
        };
      }).toList();
    } catch (e) {
      print("Error fetching settings data: $e");
      return [];
    }
  }
}