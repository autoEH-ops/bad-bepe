import 'package:gsheets/src/gsheets.dart';
import 'package:image_picker/image_picker.dart';
import '../../GoogleAPIs/GoogleDrive.dart';
import '../../GoogleAPIs/GoogleSpreadSheet.dart';

class DrivePassVmsService {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi = GoogleDrive();

  DrivePassVmsService();

  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.GuestPasslist == null ||
        GoogleSheets.supplierPassList == null ||
        GoogleSheets.dutyPassList == null ||
        GoogleSheets.contractorPassPage == null ||
        GoogleSheets.GuestDrivereport == null) {
      await GoogleSheets.connectToReportList();
    }
  }

  Future<String> getNameByEmail(String email) async {
    await ensureSheetsConnected();
    final accounts = await googleSheetsApi.getAccounts();

    for (var account in accounts) {
      if (account['Email'] == email) {
        return '${account['Email']}\n${account['Name'] ?? 'Unknown'}';
      }
    }
    return 'Unknown\n$email';
  }

  Future<void> insertReportData(String passType, List<Object?> rowData, String email) async {
    await ensureSheetsConnected();

    // Directly set the sheet to GuestDrivereport for all pass types
    Worksheet? sheet = GoogleSheets.GuestDrivereport;

    // If you want to ensure it's specifically for a certain passType, you can throw an exception if it's not 'Drive Pass' or any other desired passType.
    if (passType != 'Drive Pass') {
      throw Exception("Data should only be inserted into the 'GuestDrivereport' sheet.");
    }

    // Retrieve the email and name as a single combined string
    String emailAndName = await getNameByEmail(email);

    // Insert email and name into the report data
    rowData.insert(4, emailAndName);

    await sheet?.values.appendRow(rowData);
  }


  Future<List<Map<String, String?>>> fetchDrivePassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.drivePasslist?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchContractorPassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.contractorPassPage?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchDutyPassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.dutyPassList?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchSupplierPassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.supplierPassList?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchGuestPassList() async { // Added fetchGuestPassList
    await ensureSheetsConnected();
    final rows = await GoogleSheets.GuestPasslist?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchGuestDriverReport() async { // Added fetchGuestDriverReport
    await ensureSheetsConnected();
    final rows = await GoogleSheets.GuestDrivereport?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'reportId': row[0],
        'passType': row[1],
        'phone': row.length > 2 ? row[2] : null,
        'ic': row.length > 3 ? row[3] : null,
        'car_plate': row.length > 4 ? row[4] : null,
      };
    }).toList();
  }

  Future<Map<String, String?>> getLastReportedData(String passName) async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.GuestDrivereport?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return {};
    }

    for (var row in rows.reversed) {
      if (row[0] == passName && row[3] == "Pass In") {
        return {
          'phone': row.length > 4 ? row[4] : '',
          'ic': row.length > 5 ? row[5] : '',
          'carplate': row.length > 6 ? row[6] : '',
        };
      }
    }
    return {};
  }

  Future<void> updatePassStatus(
      List<String> passNames,  // List of pass names
      String currentStatus,    // Current status for both passes (Drive Pass and the second selected pass)
      String passType          // Pass type for the second list (only used for non-Drive Pass types)
      ) async {
    await ensureSheetsConnected();

    // Define the sheet to be used based on the pass type
    Worksheet? sheet;
    switch (passType) {
      case 'Guest Pass':
        sheet = GoogleSheets.GuestPasslist;
        break;
      case 'Supplier Pass':
        sheet = GoogleSheets.supplierPassList;
        break;
      case 'Duty Pass':
        sheet = GoogleSheets.dutyPassList;
        break;
      case 'Contractor Pass':
        sheet = GoogleSheets.contractorPassPage;
        break;
      case 'Drive Pass':
        sheet = GoogleSheets.drivePasslist;
        break;
      default:
        throw Exception("Invalid pass type '$passType'.");
    }

    if (sheet == null) {
      throw Exception("$passType sheet is not connected.");
    }

    final rows = await sheet.values.allRows();
    if (rows.isEmpty) {
      throw Exception("No data found in the $passType sheet.");
    }

    // Loop over each pass name to update status
    for (String passName in passNames) {
      if (passName.isEmpty) {
        continue;  // Skip empty pass names
      }

      bool passUpdated = false;
      for (int i = 0; i < rows.length; i++) {
        // Check if the pass name matches the one in the current sheet's rows
        if (rows[i][0] == passName) {
          // Get the current status from the second column (index 1)
          String currentStatusInSheet = rows[i][1] ?? '';

          // Determine new status based on current status
          String newStatus;
          if (currentStatusInSheet == 'Pass Out') {
            newStatus = 'Pass In';  // If it was "Pass Out", change to "Pass In"
          } else if (currentStatusInSheet == 'Pass In') {
            newStatus = 'Pass Out';  // If it was "Pass In", change to "Pass Out"
          } else {
            newStatus = 'Pass In';  // If it's null or something else, default to "Pass In"
          }

          // Update the status in the sheet
          await sheet.values.insertValue(newStatus, column: 2, row: i + 1);
          print("Updated pass '$passName' in $passType to status '$newStatus'.");
          passUpdated = true;
          break;  // Exit inner loop once pass is updated
        }
      }

      if (!passUpdated) {
        throw Exception("Pass '$passName' not found in $passType.");
      }
    }

    // If current status is "Pass In", we need to update the other pass (e.g., Drive Pass <-> Contractor Pass)
    if (currentStatus == 'Pass In') {
      // Fetch the "GuestDrivereport" sheet to get both pass names (Drive Pass and Contractor Pass)
      Worksheet? guestSheet = GoogleSheets.GuestDrivereport;
      final guestRows = await guestSheet?.values.allRows() ?? [];

      if (guestRows.isEmpty) {
        throw Exception("No data found in the GuestDrivereport sheet.");
      }

      // Find the second pass type that needs to be updated (we use the current pass type to find the other pass name)
      for (var row in guestRows) {
        if (row[0] == passType) {
          String secondPassName = row[2]; // Column C has the second pass name
          if (secondPassName.isNotEmpty) {
            // Determine the corresponding sheet for the second pass type
            Worksheet? secondPassSheet;
            switch (passType) {
              case 'Drive Pass':
                secondPassSheet = GoogleSheets.contractorPassPage;
                break;
              case 'Contractor Pass':
                secondPassSheet = GoogleSheets.drivePasslist;
                break;
            // Handle other pass types similarly...
            }

            // Now, update the second pass status in the corresponding sheet
            if (secondPassSheet != null) {
              await _updatePassInSecondSheet(secondPassSheet, secondPassName, 'Pass In');
            }
          }
        }
      }
    }
  }

// Helper method to update the second pass status in its corresponding sheet
  Future<void> _updatePassInSecondSheet(Worksheet sheet, String passName, String newStatus) async {
    final rows = await sheet.values.allRows();
    for (int i = 0; i < rows.length; i++) {
      if (rows[i][0] == passName) {
        await sheet.values.insertValue(newStatus, column: 2, row: i + 1);  // Update the status
        print("Updated second pass '$passName' to status '$newStatus'.");
        break;
      }
    }
  }


  Future<String> generateReportId() async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows from the Google Sheets
      final rows = await GoogleSheets.GuestDrivereport!.values.allRows();

      // Log the rows for debugging
      print("Rows fetched: ${rows.length} records found");

      // If the sheet is empty or has only the header, start with the first ID
      if (rows.isEmpty || rows.length == 1) {
        print("No existing data rows. Starting with VPR-000001.");
        return 'VPR-000001';
      }

      // Calculate the new Report ID based on the row number
      int newIdNumber = rows.length; // Subtract 1 for the header row
      String newReportId = 'VPR-${newIdNumber.toString().padLeft(6, '0')}';

      print("Generated new Report ID: $newReportId");
      return newReportId;

    } catch (e) {
      // Log the error and provide a fallback ID in case of failure
      print("Error generating new Report ID: $e");
      return 'VPR-000001'; // Fallback ID
    }
  }

  Future<List<String>> uploadImagesToDrive(List<XFile> images) async {
    List<String> imageLinks = await googleDriveApi.getGoogleDriveFilesUrl(
        images, '1YB5QLSC77q8P3HrBzzU7WrefTIbYN6oO'); // Replace with your folder ID

    return imageLinks.map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing").toList();
  }
}
