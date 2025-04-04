import '../GoogleAPIs/GoogleSpreadSheet.dart';

class ManageSecurityService {
  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.securityPersonnelNameListPage == null ||
        GoogleSheets.accountsPage == null) {
      await GoogleSheets.connectToAccountDetails();
    }
  }

  // Extract all personnel names from the "Security Name List" sheet (excluding the header)
  Future<List<String>> getAllPersonnelNames() async {
    await ensureSheetsConnected();
    final rows =
    await GoogleSheets.securityPersonnelNameListPage!.values.allRows();

    if (rows.length <= 1) {
      return []; // Return empty list if no data found or only header exists
    }

    // Skip the header and extract the 'Name' field from each row
    return rows.skip(1).map((row) => row[0]).toList();
  }

  // Fetch all security personnel details from the "Security Name List" sheet (excluding the header)
  Future<List<Map<String, dynamic>>> getAllSecurityGuardDetails() async {
    await ensureSheetsConnected();
    final rows =
    await GoogleSheets.securityPersonnelNameListPage!.values.allRows();

    if (rows.length <= 1) {
      return []; // Return empty list if no data found or only header exists
    }

    // Skip the header and convert the rows to a list of maps
    return rows.skip(1).map((row) {
      return {
        'Name': row[0] ?? '',
        'Position': row[1] ?? '',
        'Shift': row[2] ?? '',
        'Contact': row[3] ?? ''
      };
    }).toList();
  }

  // Update a specific field for a security personnel in the "Security Name List" sheet
  Future<void> updateRow(String name, String title, bool newBool) async {
    await ensureSheetsConnected();
    final rows =
    await GoogleSheets.securityPersonnelNameListPage!.values.allRows();

    if (rows.length <= 1) return;

    for (int i = 1; i < rows.length; i++) {
      // Skip the header row and look for the matching name
      if (rows[i][0] == name) {
        int columnIndex = _getColumnIndex(title);

        if (columnIndex != -1) {
          // Update the field in the sheet
          await GoogleSheets.securityPersonnelNameListPage!.values
              .insertValue(newBool.toString(), column: columnIndex, row: i + 1);
        }
        break;
      }
    }
  }

  // Helper function to map field names to column indices
  int _getColumnIndex(String field) {
    switch (field) {
      case 'Hourly Post Update Report Status':
        return 2;
      case 'Roll Call Report Status':
        return 3;
      case 'Rounding Report Status':
        return 4;
      case 'Emergency Report Status':
        return 5;
      case 'Spot Check Report Status':
        return 6;
      case 'Shutter Report Status':
        return 7;
      case 'Electric Panel Report Status':
        return 8;
      case 'Glass Sliding Report Status':
        return 9;
      case 'Main Gate Report Status':
        return 10;
      case 'Clamping Report Status':
        return 11;
      case 'VMS Report Status':
        return 12;
      case 'QR Report Status':
        return 13;
      case 'Pass Checking Report Status':
        return 14;
      case 'Emergency Follow Up Report Status':
        return 15;
      case 'Clamping Follow Up Report Status':
        return 16;
      case 'Pass Checking Follow Up Report Status':
        return 17;
      case 'Key Management Report Status':
        return 18;
      default:
        return -1; // Return -1 if column not found
    }
  }

  // Retrieve specific security guard details by name (excluding the header)
  Future<Map<String, dynamic>> retrieveSpecificSecurityGuardRow(
      String name) async {
    await ensureSheetsConnected();
    final rows =
    await GoogleSheets.securityPersonnelNameListPage!.values.allRows();

    if (rows.length <= 1) {
      return {}; // Return empty map if no data found
    }

    for (var row in rows.skip(1)) {
      // Skip the header row and look for the matching name
      if (row[0] == name) {
        return {
          'Name': row[0],
          'Position': row[1],
          'Shift': row[2],
          'Contact': row[3]
        };
      }
    }
    return {}; // Return empty map if no match found
  }

  // Retrieve non-admin security personnel from the "Accounts" sheet (excluding the header)
  Future<List<String>> retrieveSecurityNonAdmin() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.accountsPage!.values.allRows();

    if (rows.length <= 1) {
      return []; // Return empty list if no data found or only header exists
    }

    List<String> names = [];
    for (var row in rows.skip(1)) {
      // Skip the header row and filter for non-admin security personnel
      if (row[4] == 'Security') {
        names.add(row[0]); // Assuming 'Name' is in the first column
      }
    }

    return names;
  }

// Fetch permissions for the security role and their associated pages
  Future<List<Map<String, dynamic>>> getPermissionsForSecurityRole(String email,
      String role) async {
    try {
      // Ensure we have a connection to Google Sheets
      await ensureSheetsConnected();

      // Fetch all rows from the sheet
      List<List<dynamic>>? rows = await GoogleSheets.settingpage!.values
          .allRows();

      if (rows.isEmpty) {
        print("No data found in the sheet");
        return []; // Return an empty list if no data is found
      }

      // Log the retrieved rows for debugging
      print("Fetched rows: ${rows.length} records found");

      // Skip the first row (header) and reverse the list to retrieve from bottom to top
      rows = rows
          .skip(1)
          .toList()
          .reversed
          .toList();

      // Map each row to a Map<String, dynamic> with column keys
      List<Map<String, dynamic>> permissions = rows.map((row) {
        return {
          'ID email': row.isNotEmpty ? row[0].toString() : 'N/A',
          // Email (Column A)
          'Role': row.length > 1 ? row[1].toString() : 'N/A',
          // Role (Column B)
          'Permission1': row.length > 2 ? row[2].toString() : 'N/A',
          // Permission 1
          'Permission2': row.length > 3 ? row[3].toString() : 'N/A',
          // Permission 2
          'Permission3': row.length > 4 ? row[4].toString() : 'N/A',
          // Permission 3
          'Permission4': row.length > 5 ? row[5].toString() : 'N/A',
          // Permission 4
          'Permission5': row.length > 6 ? row[6].toString() : 'N/A',
          // Permission 5
          'Permission6': row.length > 7 ? row[7].toString() : 'N/A',
          // Permission 6
          'Permission7': row.length > 8 ? row[8].toString() : 'N/A',
          // Permission 7
          'Permission8': row.length > 9 ? row[9].toString() : 'N/A',
          // Permission 8
        };
      }).toList();

      // Find the entry matching the given email and role
      List<Map<String, dynamic>> matchingPermissions = permissions.where((
          permission) {
        return permission['ID email'] == email && permission['Role'] == role;
      }).toList();

      if (matchingPermissions.isEmpty) {
        return []; // Return an empty list if no matching entry is found
      }

      // Return the matched permissions (optional, you can adjust based on need)
      return matchingPermissions;
    } catch (e) {
      // Log error if there's an issue
      print("Error fetching data: $e");
      return []; // Return empty list in case of an error
    }
  }
}