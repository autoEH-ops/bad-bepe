import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API

class ManageDutyService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.dutyPassList == null) {
      await GoogleSheets.connectToDataList();
    }
  }

  // Fetch all duty passes from the Google Sheet
  Future<List<String>> getAllDutyPass() async {
    await ensureSheetsConnected();

    // Fetch all rows from the "Duty Pass List" sheet
    final rows = await GoogleSheets.dutyPassList!.values.allRows();

    if (rows.length <= 1) {
      return [];
    }

    // Skip the first row (header) and extract the supplier names from the first column
    return rows
        .skip(1) // Skip the header row
        .map((row) => row[0])
        .toList();
  }

  // Add a new duty pass to the Google Sheet
  Future<bool> addDutyPass(String name) async {
    await ensureSheetsConnected();

    try {
      // Check if duty pass name already exists in the sheet
      final rows = await GoogleSheets.dutyPassList!.values.allRows();
      for (var row in rows) {
        if (row[0] == name) {
          return false; // Duty Pass already exists
        }
      }

      // Append the new duty pass to the Google Sheet
      if (name.isNotEmpty) {
        await GoogleSheets.dutyPassList!.values.appendRow([name]);
        return true;
      } else {
        return false; // Name is empty
      }
    } catch (e) {
      print("Error adding duty pass: $e");
      return false; // Operation failed
    }
  }

  // Update an existing duty pass's name
  Future<bool> updateRow(String previousName, String newName) async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows and find the one with the matching previous name
      final rows = await GoogleSheets.dutyPassList!.values.allRows();
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == previousName) {
          // Check if the new name already exists
          for (var row in rows) {
            if (row[0] == newName) {
              return false; // New name already exists
            }
          }

          // Update the duty pass name in the sheet
          await GoogleSheets.dutyPassList!.values.insertValue(
            newName,
            column: 1, // First column (Duty Pass Name)
            row: i + 1, // Row index in Google Sheets starts from 1
          );
          return true;
        }
      }

      return false; // Duty Pass not found
    } catch (e) {
      print("Error updating duty pass: $e");
      return false; // Operation failed
    }
  }

  // Delete a duty pass from the Google Sheet
  Future<bool> deleteRow(String name) async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows and find the one with the matching name
      final rows = await GoogleSheets.dutyPassList!.values.allRows();
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == name) {
          // Delete the row from the sheet
          await GoogleSheets.dutyPassList!.deleteRow(i + 1);
          return true;
        }
      }

      return false; // Duty Pass not found
    } catch (e) {
      print("Error deleting duty pass: $e");
      return false; // Operation failed
    }
  }
}
