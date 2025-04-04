import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your GoogleSheets class

class ManageEmergencyLocationService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure the connection to Google Sheets is active
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.gatePostLocationPage == null) {
      await GoogleSheets.connectToDataList(); // Connect to the spreadsheet
    }
  }

  // Fetch all emergency locations from the Google Sheets
  // Fetch all emergency locations from the Google Sheets, excluding the header
  Future<List<String>> getAllEmergencyLocations() async {
    await ensureSheetsConnected(); // Ensure the connection to the sheet is ready
    final rows = await GoogleSheets.gatePostLocationPage!.values.allRows();

    if (rows.length <= 1) {
      return []; // Return empty list if no rows or only header exists
    }

    // Return only the first column from the second row onwards (excluding the header)
    return rows
        .skip(1) // Skip the first row (header)
        .map((row) =>
            row[0]) // Assuming emergency locations are in the first column
        .toList();
  }

  // Add a new emergency location
  Future<bool> addEmergencyLocations(String locationName) async {
    await ensureSheetsConnected(); // Ensure the connection to the sheet is ready

    try {
      await GoogleSheets.gatePostLocationPage!.values.appendRow([locationName]);
      print("Emergency location added: $locationName");
      return true;
    } catch (e) {
      print("Error adding emergency location: $e");
      return false;
    }
  }

  // Update an emergency location row
  Future<bool> updateRow(String oldLocation, String newLocation) async {
    await ensureSheetsConnected(); // Ensure the connection to the sheet is ready
    final rows = await GoogleSheets.gatePostLocationPage!.values.allRows();

    if (rows.isEmpty) {
      return false;
    }

    for (int i = 0; i < rows.length; i++) {
      if (rows[i][0] == oldLocation) {
        // Assuming the location name is in the first column
        await GoogleSheets.gatePostLocationPage!.values.insertValue(newLocation,
            column: 1, row: i + 1); // Update the location
        print("Updated emergency location: $oldLocation to $newLocation");
        return true;
      }
    }

    print("Location not found: $oldLocation");
    return false;
  }

  // Delete an emergency location row
  Future<bool> deleteRow(String locationName) async {
    await ensureSheetsConnected(); // Ensure the connection to the sheet is ready
    final rows = await GoogleSheets.gatePostLocationPage!.values.allRows();

    if (rows.isEmpty) {
      return false;
    }

    for (int i = 0; i < rows.length; i++) {
      if (rows[i][0] == locationName) {
        // Assuming the location name is in the first column
        await GoogleSheets.gatePostLocationPage!
            .deleteRow(i + 1); // Delete the row
        print("Deleted gate location: $locationName");
        return true;
      }
    }

    print("Location not found: $locationName");
    return false;
  }
}
