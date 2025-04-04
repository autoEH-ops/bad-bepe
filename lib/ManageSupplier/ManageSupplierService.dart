import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API

class ManageSupplierService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.supplierPageListPage == null) {
      await GoogleSheets.connectToDataList();
    }
  }

  // Fetch all supplier names from the Google Sheet, excluding the header
  Future<List<String>> getAllSupplier() async {
    await ensureSheetsConnected();

    // Fetch all rows from the "Supplier List" sheet
    final rows = await GoogleSheets.supplierPageListPage!.values.allRows();

    // If no rows found or just the header, return an empty list
    if (rows.length <= 1) {
      return [];
    }

    // Skip the first row (header) and extract the supplier names from the first column
    return rows
        .skip(1) // Skip the header row
        .map((row) => row[0])
        .toList();
  }

  // Add a new supplier to the Google Sheet
  Future<bool> addSupplier(String name) async {
    await ensureSheetsConnected();

    try {
      // Check if supplier name already exists in the sheet (excluding the header)
      final rows = await GoogleSheets.supplierPageListPage!.values.allRows();
      for (var row in rows.skip(1)) {
        // Skip the header row
        if (row[0] == name) {
          return false; // Supplier already exists
        }
      }

      // Append the new supplier to the Google Sheet
      if (name.isNotEmpty) {
        await GoogleSheets.supplierPageListPage!.values.appendRow([name]);
        return true;
      } else {
        return false; // Name is empty
      }
    } catch (e) {
      print("Error adding supplier: $e");
      return false; // Operation failed
    }
  }

  // Update an existing supplier's name
  Future<bool> updateRow(String previousName, String newName) async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows and find the one with the matching previous name (excluding the header)
      final rows = await GoogleSheets.supplierPageListPage!.values.allRows();
      for (int i = 1; i < rows.length; i++) {
        // Start from the second row (skip header)
        if (rows[i][0] == previousName) {
          // Check if the new name already exists
          for (var row in rows.skip(1)) {
            // Skip the header row
            if (row[0] == newName) {
              return false; // New name already exists
            }
          }

          // Update the supplier name in the sheet
          await GoogleSheets.supplierPageListPage!.values.insertValue(
            newName,
            column: 1, // First column (Supplier Name)
            row: i + 1, // Row index in Google Sheets starts from 1
          );
          return true;
        }
      }

      return false; // Supplier not found
    } catch (e) {
      print("Error updating supplier: $e");
      return false; // Operation failed
    }
  }

  // Delete a supplier from the Google Sheet
  Future<bool> deleteRow(String name) async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows and find the one with the matching name (excluding the header)
      final rows = await GoogleSheets.supplierPageListPage!.values.allRows();
      for (int i = 1; i < rows.length; i++) {
        // Start from the second row (skip header)
        if (rows[i][0] == name) {
          // Delete the row from the sheet
          await GoogleSheets.supplierPageListPage!.deleteRow(i + 1);
          return true;
        }
      }

      return false; // Supplier not found
    } catch (e) {
      print("Error deleting supplier: $e");
      return false; // Operation failed
    }
  }
}
