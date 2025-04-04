import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your GoogleSheets class

class ManageAccountService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  /// Fetches all accounts from the Google Sheets
  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    try {
      // Fetch all accounts from Google Sheets
      List<Map<String, dynamic>> accounts = await googleSheetsApi.getAccounts();
      return accounts;
    } catch (e) {
      print("Error fetching accounts: $e");
      return [];
    }
  }

  /// Deletes a specific account row based on email
  Future<bool> deleteSpecificPageRow(
      String deletedEmail, String deletedName) async {
    try {
      // Fetch all accounts from Google Sheets
      List<Map<String, dynamic>> accounts = await googleSheetsApi.getAccounts();

      // Find the row with the matching email
      int rowIndex =
          accounts.indexWhere((account) => account['Email'] == deletedEmail);

      if (rowIndex == -1) {
        print("No account found with email $deletedEmail");
        return false;
      }

      // Delete the row using the GoogleSheets method `deleteRowByEmail`
      await googleSheetsApi
          .deleteRowByIndex(rowIndex + 2); // +2 to account for header row
      print("Account with email $deletedEmail deleted successfully");

      return true;
    } catch (e) {
      print("Error deleting account with email $deletedEmail: $e");
      return false;
    }
  }
}
