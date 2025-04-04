import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '/GoogleAPIs/GoogleDrive.dart';
import '/GoogleAPIs/GoogleSpreadSheet.dart';
import '/GoogleAPIs/NotifyReportToTelegram.dart'; // Import the notification logic

class SubmitKeyManagementReportService {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi = GoogleDrive();

  Future<void> ensureSheetsConnected() async {
    try {
      if (GoogleSheets.Manageaddkey == null ||
          GoogleSheets.ManagekeyReportPage == null) {
        print("Connecting to Google Sheets...");
        await GoogleSheets.connectToReportList();
        if (GoogleSheets.Manageaddkey != null &&
            GoogleSheets.ManagekeyReportPage != null) {
          print("Google Sheets connected successfully.");
        } else {
          print("Failed to connect to Google Sheets.");
        }
      } else {
        print("Google Sheets already connected.");
      }
    } catch (e) {
      print("Error connecting to Google Sheets: $e");
    }
  }

  Future<String> getNameByEmail(String email) async {
    await ensureSheetsConnected();
    final accounts = await googleSheetsApi.getAccounts();

    for (var account in accounts) {
      if (account['Email'] == email) {
        return account['Name'] ?? 'Unknown';
      }
    }
    return 'Unknown';
  }

  Future<List<String>> fetchKeys({required bool isCollect}) async {
    await ensureSheetsConnected();
    try {
      var rows = await GoogleSheets.Manageaddkey!.values.allRows();
      if (rows.isEmpty || rows.length <= 1) {
        print("No rows found in Manage Key sheet.");
        return [];
      }

      List<String> filteredKeys = rows.skip(1).where((row) {
        final keyState = row.length > 1 ? row[1] : '';
        return isCollect ? keyState.isEmpty : keyState == 'collected';
      }).map((row) => row[0].toString()).toList();

      print("Filtered keys: $filteredKeys");
      return filteredKeys;
    } catch (e) {
      print("Error fetching key list: $e");
      return [];
    }
  }

  Future<Map<String, String?>?> getLastKeyCollectionData(String key) async {
    await ensureSheetsConnected();
    var rows = await GoogleSheets.ManagekeyReportPage!.values.allRows();

    if (rows.length <= 1) {
      return null;
    }

    for (var i = rows.length - 1; i > 0; i--) {
      var row = rows[i];
      if (row[2] == key && row[8] == 'collected') {
        return {
          'serviceNumber': row[3],
          'icNumber': row[4]
        };
      }
    }
    return null;
  }

  Future<bool> addKeyManagementReport(
      String email,
      List<XFile> images1,
      String serviceNumber,
      String icNumber,
      String selectedKey,
      bool isCollect,
      String remarks) async {
    await ensureSheetsConnected();

    // Format the timestamp to 'MM/dd/yyyy HH:mm:ss'
    String formattedTimestamp = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    try {
      final reportId = await generateReportId();
      final name = await getNameByEmail(email);
      final emailAndName = '$email\n$name';

      List<String> imageLinks1 = await googleDriveApi.getGoogleDriveFilesUrl(
          images1, '1FWdXL5g9xdZGRBy3tNK6ay88T020MDiL');

      List<String> publicLinks1 = imageLinks1
          .map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing")
          .toList();

      // Append data to the Google Sheet
      await GoogleSheets.ManagekeyReportPage!.values.appendRow([
        reportId,
        emailAndName,
        selectedKey,
        serviceNumber,
        icNumber,
        publicLinks1.join(', '),
        formattedTimestamp,
        isCollect ? 'collected' : 'returned',
        remarks  // Add Remarks to the sheet row
      ]);

      // Update the status of the key
      await updateKeyStatus(selectedKey, isCollect);

      // Notify Telegram about the new report
      await NotifyReportToTelegram.notify(
          'Key Management Report', // Report Type
          [
            reportId,
            emailAndName,
            selectedKey,
            serviceNumber,
            icNumber,
            publicLinks1.join(', '),
            formattedTimestamp,
            isCollect ? 'collected' : 'returned',
            remarks
          ] // Data for the Telegram message
      );

      return true;
    } catch (e) {
      print("Error adding key management report: $e");
      return false;
    }
  }

  Future<void> updateKeyStatus(String selectedKey, bool isCollect) async {
    await ensureSheetsConnected();
    try {
      var rows = await GoogleSheets.Manageaddkey!.values.allRows();
      if (rows.isEmpty || rows.length <= 1) return;

      for (int i = 1; i < rows.length; i++) {
        if (rows[i][0] == selectedKey) {
          await GoogleSheets.Manageaddkey!.values.insertValue(
            isCollect ? 'collected' : '',
            column: 2,
            row: i + 1,
          );
          break;
        }
      }
    } catch (e) {
      print("Error updating key status: $e");
    }
  }

  Future<String> generateReportId() async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows from the Google Sheets
      final rows = await GoogleSheets.ManagekeyReportPage!.values.allRows();

      // Log the rows for debugging
      print("Rows fetched: ${rows.length} records found");

      // If the sheet is empty or has only the header, start with the first ID
      if (rows.isEmpty || rows.length == 1) {
        print("No existing data rows. Starting with KMR-000001.");
        return 'KMR-000001';
      }

      // Calculate the new Report ID based on the row number
      int newIdNumber = rows.length; // Subtract 1 for the header row
      String newReportId = 'KMR-${newIdNumber.toString().padLeft(6, '0')}';

      print("Generated new Report ID: $newReportId");
      return newReportId;

    } catch (e) {
      // Log the error and provide a fallback ID in case of failure
      print("Error generating new Report ID: $e");
      return 'KMR-000001'; // Fallback ID
    }
  }
}
