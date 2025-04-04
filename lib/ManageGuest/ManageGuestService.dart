import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API

class ManageGuestService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.GuestPasslist == null) {
      await GoogleSheets.connectToDataList();
    }
  }

  // Fetch all contractor names from the Google Sheet
  Future<List<String>> getAllContractor() async {
    await ensureSheetsConnected();

    // Fetch all rows from the "Contractor Pass" sheet
    final rows = await GoogleSheets.GuestPasslist!.values.allRows();

    if (rows.length <= 1) {
      return [];
    }

    // Skip the first row (header) and extract the supplier names from the first column
    return rows
        .skip(1) // Skip the header row
        .map((row) => row[0])
        .toList();
  }

  // Add a new contractor to the Google Sheet
  Future<bool> addContractor(String name) async {
    await ensureSheetsConnected();

    try {
      // Check if contractor name already exists in the sheet
      final rows = await GoogleSheets.GuestPasslist!.values.allRows();
      for (var row in rows) {
        if (row[0] == name) {
          return false; // Contractor already exists
        }
      }

      // Append the new contractor to the Google Sheet
      if (name.isNotEmpty) {
        await GoogleSheets.GuestPasslist!.values.appendRow([name]);
        return true;
      } else {
        return false; // Name is empty
      }
    } catch (e) {
      print("Error adding Guest: $e");
      return false; // Operation failed
    }
  }

  // Update an existing contractor's name
  Future<bool> updateRow(String previousName, String newName) async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows and find the one with the matching previous name
      final rows = await GoogleSheets.GuestPasslist!.values.allRows();
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == previousName) {
          // Check if the new name already exists
          for (var row in rows) {
            if (row[0] == newName) {
              return false; // New name already exists
            }
          }

          // Update the contractor name in the sheet
          await GoogleSheets.GuestPasslist!.values.insertValue(
            newName,
            column: 1, // First column (Contractor Name)
            row: i + 1, // Row index in Google Sheets starts from 1
          );
          return true;
        }
      }

      return false; // Contractor not found
    } catch (e) {
      print("Error updating Guest: $e");
      return false; // Operation failed
    }
  }

  // Delete a contractor from the Google Sheet
  Future<bool> deleteRow(String name) async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows and find the one with the matching name
      final rows = await GoogleSheets.GuestPasslist!.values.allRows();
      for (int i = 0; i < rows.length; i++) {
        if (rows[i][0] == name) {
          // Delete the row from the sheet
          await GoogleSheets.GuestPasslist!.deleteRow(i + 1);
          return true;
        }
      }

      return false; // Contractor not found
    } catch (e) {
      print("Error deleting Guest: $e");
      return false; // Operation failed
    }
  }
}
