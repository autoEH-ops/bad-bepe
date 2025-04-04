import '../GoogleAPIs/GoogleSpreadSheet.dart'; // Import your GoogleSheets class

class ManageKeyService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure connection to Google Sheets is established
  Future<void> ensureConnection() async {
    if (GoogleSheets.Manageaddkey == null) {
      await GoogleSheets.connectToDataList();
    }
  }

  // Fetch all keys from the Google Sheet
  Future<List<String>> getAllKeys() async {
    await ensureConnection(); // Ensure connection to the sheet
    final rows = await GoogleSheets.Manageaddkey!.values.allRows();
    List<String> keys = [];

    for (var row in rows) {
      if (row.isNotEmpty) {
        keys.add(row[0]); // Assuming the key name is in the first column
      }
    }

    return keys;
  }

  // Add a new key to the Google Sheet
  Future<bool> addKey(String key) async {
    await ensureConnection(); // Ensure connection to the sheet
    await GoogleSheets.Manageaddkey!.values.appendRow([key]);
    return true;
  }

  // Delete a key from the Google Sheet
  Future<bool> deleteRow(String key) async {
    await ensureConnection(); // Ensure connection to the sheet
    final rows = await GoogleSheets.Manageaddkey!.values.allRows();

    for (int i = 0; i < rows.length; i++) {
      if (rows[i].isNotEmpty && rows[i][0] == key) {
        await GoogleSheets.Manageaddkey!.deleteRow(i + 1); // Delete the row
        return true;
      }
    }
    return false;
  }

  // Update an existing key in the Google Sheet
  Future<bool> updateRow(String oldKey, String newKey) async {
    await ensureConnection(); // Ensure connection to the sheet
    final rows = await GoogleSheets.Manageaddkey!.values.allRows();

    for (int i = 0; i < rows.length; i++) {
      if (rows[i].isNotEmpty && rows[i][0] == oldKey) {
        await GoogleSheets.Manageaddkey!.values
            .insertValue(newKey, column: 1, row: i + 1);
        return true;
      }
    }
    return false;
  }
}
