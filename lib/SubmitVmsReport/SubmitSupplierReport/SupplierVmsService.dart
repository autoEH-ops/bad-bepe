import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '../../GoogleAPIs/GoogleDrive.dart';
import '../../GoogleAPIs/GoogleSpreadSheet.dart';
import '/GoogleAPIs/NotifyReportToTelegram.dart'; // Import the notification logic

class SupplierVmsService  {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi = GoogleDrive();

  SupplierVmsService ();

  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.vmsSupplierReportPage == null) {
      await GoogleSheets.connectToReportList();
    }
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

  Future<void> updatePassStatus(String passName, String newStatus, String email) async {
    await ensureSheetsConnected();
    final sheet = GoogleSheets.supplierPassList;

    if (sheet == null) {
      throw Exception("Supplier Pass sheet is not connected.");
    }

    final rows = await sheet.values.allRows();
    if (rows.isEmpty) {
      throw Exception("No data found in the Supplier Pass sheet.");
    }

    for (int i = 0; i < rows.length; i++) {
      if (rows[i][0] == passName) {
        await sheet.values.insertValue(newStatus, column: 2, row: i + 1);
        print("Updated pass '$passName' to status '$newStatus'.");
        return;
      }
    }
    throw Exception("Pass '$passName' not found.");
  }

  Future<Map<String, String?>> getLastReportedDutyData(String passName) async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.vmsSupplierReportPage?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return {};
    }

    for (var row in rows.reversed) {
      if (row[0] == passName && row[1] == "Pass In") {
        return {
          'Phone': row.length > 2 ? row[2] : '',
          'IC': row.length > 3 ? row[3] : '',
          'names': row.length > 10 ? row[10] : ''
        };
      }
    }
    return {};
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

  Future<List<String>> uploadImagesToDrive(List<XFile> images) async {
    List<String> imageLinks = await googleDriveApi.getGoogleDriveFilesUrl(
        images, '1YB5QLSC77q8P3HrBzzU7WrefTIbYN6oO'); // Replace with your folder ID

    return imageLinks.map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing").toList();
  }

  Future<String> generateReportId() async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows from the Google Sheets
      final rows = await GoogleSheets.vmsSupplierReportPage?.values.allRows();

      // Log the rows for debugging
      print("Rows fetched: ${rows?.length ?? 0} records found");

      // If the sheet is null, empty, or has only the header, start with the first ID
      if (rows == null || rows.isEmpty || rows.length == 1) {
        print("No existing data rows. Starting with SVR-000001.");
        return 'SVR-000001';
      }

      // Calculate the new Report ID based on the row number
      int newIdNumber = rows.length; // Subtract 1 for the header row
      String newReportId = 'SVR-${newIdNumber.toString().padLeft(6, '0')}';

      print("Generated new Report ID: $newReportId");
      return newReportId;

    } catch (e) {
      // Log the error and provide a fallback ID in case of failure
      print("Error generating new Report ID: $e");
      return 'SVR-000001'; // Fallback ID
    }
  }

  Future<void> submitForm(
      String pass,
      String location,
      String number,
      String ic,
      String email,
      XFile image,
      String names, // New Parameter
      Function(String) showErrorDialog,
      Function(String) showSuccessDialog) async {
    try {
      String reportId = await generateReportId();
      List<String> imageLinks = await uploadImagesToDrive([image]);
      String name = await getNameByEmail(email);
      String emailAndName = '$email\n$name';

      // Format the timestamp to 'MM/dd/yyyy HH:mm:ss'
      String formattedTimestamp = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

      final row = [
        pass,
        location,
        number,
        ic,
        emailAndName,
        imageLinks.isNotEmpty ? imageLinks[0] : 'No Image',
        reportId,
        formattedTimestamp,
        '',
        '',
        names, // Insert Name here
      ];

      if (GoogleSheets.vmsSupplierReportPage != null) {
        // Append the row to Google Sheets
        await GoogleSheets.vmsSupplierReportPage!.values.appendRow(row);

        // Notify Telegram about the new report
        await NotifyReportToTelegram.notify(
            'VMS Supplier Report', // Report Type
            row // Data for the Telegram message
        );

        // Show success dialog to the user
        showSuccessDialog('Data submitted successfully with Report ID: $reportId!');
      } else {
        showErrorDialog('Failed: Google Sheets page is not connected');
      }
    } catch (e) {
      print("Error submitting form: $e");
      showErrorDialog("Failed to submit data. Please try again.");
    }
  }
}
