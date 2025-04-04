import '/GoogleAPIs/GoogleSpreadSheet.dart';

class ManagePendingListService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.pendingPage == null) {
      await GoogleSheets.connectToAccountDetails();
    }
  }

  // Fetch all pending accounts from the "Pending Accounts" sheet
  Future<List<Map<String, dynamic>>> getAllPending() async {
    await ensureSheetsConnected();

    // Fetch all rows from the pendingPage
    final rows = await GoogleSheets.pendingPage!.values
        .allRows(); // Fetch rows as a list of lists

    if (rows.isEmpty) {
      return [];
    }

    // Convert rows to list of maps assuming the first row is the header
    List<Map<String, dynamic>> pendingAccounts = [];
    List<String> headers = rows[0]; // First row as headers

    for (int i = 1; i < rows.length; i++) {
      // Skip the header row
      Map<String, dynamic> account = {};
      for (int j = 0; j < headers.length; j++) {
        account[headers[j]] = rows[i][j]; // Match header to value in row
      }
      pendingAccounts.add(account);
    }

    return pendingAccounts;
  }

  // Add an account to the database from the pending list
  Future<bool> addAccountToDatabase(String email) async {
    await ensureSheetsConnected();

    final rows = await GoogleSheets.pendingPage!.values
        .allRows(); // Fetch rows as a list of lists

    for (int i = 1; i < rows.length; i++) {
      // Start from the second row (skip header)
      if (rows[i][1] == email) {
        // Assuming the second column is "Email"
        // Move data to accounts database
        await googleSheetsApi.addAccount(
          rows[i][0], // Email
          rows[i][2], // Name
          rows[i][3], // Phone
          rows[i][4], // Role
        );
        return true;
      }
    }
    return false;
  }

  // Delete a pending account from the Google Sheet
  Future<bool> deleteDocument(String email) async {
    await ensureSheetsConnected();

    final rows = await GoogleSheets.pendingPage!.values.allRows();

    for (int i = 1; i < rows.length; i++) {
      if (rows[i][1] == email) {
        // Assuming the second column is "Email"
        await GoogleSheets.pendingPage!.deleteRow(i +
            1); // Delete the row based on its index (account for header row)
        return true;
      }
    }
    return false;
  }

  // Check if the document exists and create one if necessary
  Future<void> checkAndCreateDocument() async {
    await ensureSheetsConnected();
    // Custom logic for checking/creating the document can be added here
  }

  // Get name by email
  Future<String?> getName(String email) async {
    await ensureSheetsConnected();

    final rows = await GoogleSheets.pendingPage!.values.allRows();
    for (int i = 1; i < rows.length; i++) {
      // Skip the header row
      if (rows[i][1] == email) {
        // Assuming the second column is "Email"
        return rows[i][0]; // Assuming the first column is "Name"
      }
    }
    return null;
  }
}
