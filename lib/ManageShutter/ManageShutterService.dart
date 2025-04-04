import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API

class ManageShutterService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.shutterPage == null) {
      await GoogleSheets.connectToDataList();
    }
  }

  // Fetch all shutter names from the Google Sheet
  Future<List<String>> getAllShutter() async {
    await ensureSheetsConnected();

    // Fetch all rows from the "Shutter" sheet
    final rows = await GoogleSheets.shutterPage!.values.allRows();

    // Extract the shutter names from the first column
    List<String> shutterNames = [];
    for (var row in rows) {
      shutterNames.add(row[0]); // Assuming 'Shutter' is in the first column
    }

    return shutterNames;
  }

  // Add a new shutter to the Google Sheet
  Future<bool> addShutter(String name) async {
    await ensureSheetsConnected();

    try {
      // Check if the shutter name already exists in the sheet
      final rows = await GoogleSheets.shutterPage!.values.allRows();
      for (var row in rows) {
        if (row[0] == name) {
          return false; // Shutter already exists
        }
      }

      // Append the new shutter to the Google Sheet
      if (name.isNotEmpty) {
        await GoogleSheets.shutterPage!.values.appendRow([name]);
        return true;
      } else {
        return false; // Name is empty
      }
    } catch (e) {
      print("Error adding shutter: $e");
      return false; // Operation failed
    }
  }

  // Update an existing shutter name
  Future<bool> updateRow(String previousName, String newName) async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows and find the one with the matching previous name
      final rows = await GoogleSheets.shutterPage!.values.allRows();
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == previousName) {
          // Check if the new name already exists
          for (var row in rows) {
            if (row[0] == newName) {
              return false; // New name already exists
            }
          }

          // Update the shutter name in the sheet
          await GoogleSheets.shutterPage!.values.insertValue(
            newName,
            column: 1, // First column (Shutter Name)
            row: i + 1, // Row index in Google Sheets starts from 1
          );
          return true;
        }
      }

      return false; // Shutter not found
    } catch (e) {
      print("Error updating shutter: $e");
      return false; // Operation failed
    }
  }

  // Delete a shutter from the Google Sheet
  Future<bool> deleteRow(String name) async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows and find the one with the matching name
      final rows = await GoogleSheets.shutterPage!.values.allRows();
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == name) {
          // Delete the row from the sheet
          await GoogleSheets.shutterPage!.deleteRow(i + 1);
          return true;
        }
      }

      return false; // Shutter not found
    } catch (e) {
      print("Error deleting shutter: $e");
      return false; // Operation failed
    }
  }
}
