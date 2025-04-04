import '/GoogleAPIs/GoogleSpreadSheet.dart';

class ManageRoundingPointService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure Google Sheets connection
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.nextRoundingPage == null) {
      await GoogleSheets.connectToDataList();
    }
  }

  // Fetch all rounding points
  Future<List<String>> getAllRoundingPoint() async {
    await ensureSheetsConnected();

    // Fetch all rows from the "Next Rounding" sheet
    final rows = await GoogleSheets.nextRoundingPage!.values.allRows();

    if (rows.length <= 0) {
      return [];
    }

    // Skip the first row (header) and extract the supplier names from the first column
    return rows
        .map((row) => row[0])
        .toList();
  }

  // Add a new rounding point
  Future<bool> addRoundingPoints(String roundingPoint) async {
    await ensureSheetsConnected();

    try {
      // Append the new rounding point to the sheet
      await GoogleSheets.nextRoundingPage!.values.appendRow([roundingPoint]);
      return true;
    } catch (e) {
      print('Error adding rounding point: $e');
      return false;
    }
  }

  // Delete a rounding point by its name
  Future<bool> deleteRow(String roundingPoint) async {
    await ensureSheetsConnected();

    try {
      final rows = await GoogleSheets.nextRoundingPage!.values.allRows();

      // Find the row with the matching rounding point and delete it
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == roundingPoint) {
          await GoogleSheets.nextRoundingPage!
              .deleteRow(i + 1); // Row indices in Google Sheets start at 1
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error deleting rounding point: $e');
      return false;
    }
  }

  // Update an existing rounding point
  Future<bool> updateRow(String oldName, String newName) async {
    await ensureSheetsConnected();

    try {
      final rows = await GoogleSheets.nextRoundingPage!.values.allRows();

      // Find the row with the matching rounding point and update it
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == oldName) {
          await GoogleSheets.nextRoundingPage!.values
              .insertValue(newName, column: 1, row: i + 1);
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error updating rounding point: $e');
      return false;
    }
  }
}


