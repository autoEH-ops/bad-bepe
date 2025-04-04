import '/GoogleAPIs/GoogleSpreadSheet.dart';

class ManageMainGateService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure Google Sheets is connected before any operation
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.mainGatePage == null) {
      await GoogleSheets.connectToDataList();
    }
  }

  // Get all Main Gate entries
  Future<List<String>> getAllMainGates() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.mainGatePage!.values
        .column(1); // Assuming column 1 contains the Main Gate names
    return rows.where((row) => row.isNotEmpty).toList();
  }

  // Add a new Main Gate
  Future<bool> addMainGate(String name) async {
    await ensureSheetsConnected();
    try {
      await GoogleSheets.mainGatePage!.values.appendRow([name]);
      return true;
    } catch (e) {
      print('Error adding Main Gate: $e');
      return false;
    }
  }

  // Update an existing Main Gate
  Future<bool> updateRow(String oldName, String newName) async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.mainGatePage!.values.column(1);
    for (int i = 0; i < rows.length; i++) {
      if (rows[i] == oldName) {
        await GoogleSheets.mainGatePage!.values
            .insertValue(newName, column: 1, row: i + 1);
        return true;
      }
    }
    return false;
  }

  // Delete a Main Gate entry
  Future<bool> deleteRow(String name) async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.mainGatePage!.values.column(1);
    for (int i = 0; i < rows.length; i++) {
      if (rows[i] == name) {
        await GoogleSheets.mainGatePage!.deleteRow(i + 1);
        return true;
      }
    }
    return false;
  }
}
