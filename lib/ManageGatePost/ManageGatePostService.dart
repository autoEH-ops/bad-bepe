import '../GoogleAPIs/GoogleSpreadSheet.dart'; // Import your GoogleSheets class

class ManageGatePostService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure connection to Google Sheets is established
  Future<void> ensureConnection() async {
    if (GoogleSheets.gatePostLocationPage == null) {
      await GoogleSheets.connectToDataList();
    }
  }

  // Fetch all gate post locations
  Future<List<String>> getAllGatePosts() async {
    await ensureConnection(); // Ensure connection to the sheet
    final rows = await GoogleSheets.gatePostLocationPage!.values.allRows();
    List<String> gatePostLocations = [];

    for (var row in rows) {
      if (row.isNotEmpty) {
        gatePostLocations
            .add(row[0]); // Assuming the location is in the first column
      }
    }

    return gatePostLocations;
  }

  // Add a new gate post location
  Future<bool> addGatePosts(String location) async {
    await ensureConnection(); // Ensure connection to the sheet
    await GoogleSheets.gatePostLocationPage!.values.appendRow([location]);
    return true;
  }

  // Delete a gate post location
  Future<bool> deleteRow(String location) async {
    await ensureConnection(); // Ensure connection to the sheet
    final rows = await GoogleSheets.gatePostLocationPage!.values.allRows();

    for (int i = 0; i < rows.length; i++) {
      if (rows[i].isNotEmpty && rows[i][0] == location) {
        await GoogleSheets.gatePostLocationPage!.deleteRow(i + 1);
        return true;
      }
    }
    return false;
  }

  // Update a gate post location
  Future<bool> updateRow(String oldLocation, String newLocation) async {
    await ensureConnection(); // Ensure connection to the sheet
    final rows = await GoogleSheets.gatePostLocationPage!.values.allRows();

    for (int i = 0; i < rows.length; i++) {
      if (rows[i].isNotEmpty && rows[i][0] == oldLocation) {
        await GoogleSheets.gatePostLocationPage!.values
            .insertValue(newLocation, column: 1, row: i + 1);
        return true;
      }
    }
    return false;
  }
}
