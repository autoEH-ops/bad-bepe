import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import '/GoogleAPIs/GoogleDrive.dart';
import '/GoogleAPIs/GoogleSpreadSheet.dart';
import '/GoogleAPIs/NotifyReportToTelegram.dart'; // Import the notification logic

class RollCallReportService {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi = GoogleDrive();

  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.rollCallReportPage == null) {
      await GoogleSheets.connectToReportList();
    }
  }

  // Function to get the name by email
  Future<String> getNameByEmail(String email) async {
    await ensureSheetsConnected();
    final accounts = await googleSheetsApi.getAccounts();

    for (var account in accounts) {
      if (account['Email'] == email) {
        return account['Name'] ?? 'Unknown'; // Return the name if found
      }
    }
    return 'Unknown'; // Return 'Unknown' if no matching email is found
  }

  Future<bool> addRollCallReport(
      String email,
      String personnelNames,
      List<XFile> images,
      String remarks,
      String shift,
      ) async {
    await ensureSheetsConnected();

    // Format the timestamp to 'MM/dd/yyyy HH:mm:ss'
    String formattedTimestamp =
    DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

    try {
      // Upload images to Google Drive and get the public URLs
      List<String> imageLinks = await _uploadImagesToDrive(images);

      // Generate a new report ID
      String reportId = await _generateNewReportId();

      // Get the name associated with the email
      String name = await getNameByEmail(email);

      // Combine email and name with a newline
      String emailAndName = '$email\n$name';

      // Append the report data to Google Sheets
      await GoogleSheets.rollCallReportPage!.values.appendRow([
        emailAndName, // Save email and name in the same column
        personnelNames,
        imageLinks.join(', '),
        remarks,
        formattedTimestamp, // Store as ISO8601 string
        shift,
        reportId,
      ]);

      // Notify Telegram about the new report
      await NotifyReportToTelegram.notify(
          'Roll Call Report', // Sheet name
          [
            emailAndName,
            personnelNames,
            imageLinks.join(', '),
            remarks,
            formattedTimestamp,
            shift,
            reportId,
          ] // Data for the Telegram message
      );

      return true;
    } catch (e) {
      print("Error adding roll call report: $e");
      return false;
    }
  }

  /// Uploads images to Google Drive and returns their shareable URLs
  Future<List<String>> _uploadImagesToDrive(List<XFile> images) async {
    List<String> imageLinks = await googleDriveApi.getGoogleDriveFilesUrl(
        images, '1eC-npAnUGevIA8pHPNp88gk3Vaw6z3T0');
    return imageLinks
        .map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing")
        .toList();
  }

  /// Generates a new report ID in the format RCR-XXXXXX
  Future<String> _generateNewReportId() async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows from the Google Sheets
      final rows = await GoogleSheets.rollCallReportPage!.values.allRows();

      // Log the rows for debugging
      print("Rows fetched: ${rows.length} records found");

      // If the sheet is empty or has only the header, start with the first ID
      if (rows.isEmpty || rows.length == 1) {
        print("No existing data rows. Starting with RCR-000001.");
        return 'RCR-000001';
      }

      // Calculate the new Report ID based on the row number
      int newIdNumber = rows.length; // Subtract 1 for the header row
      String newReportId = 'RCR-${newIdNumber.toString().padLeft(6, '0')}';

      print("Generated new Report ID: $newReportId");
      return newReportId;

    } catch (e) {
      // Log the error and provide a fallback ID in case of failure
      print("Error generating new Report ID: $e");
      return 'RCR-000001'; // Fallback ID
    }
  }

  Future<Map<String, String>> getLastRollCall() async {
    await ensureSheetsConnected();
    final rollCallSheet = GoogleSheets.rollCallReportPage;
    if (rollCallSheet == null) {
      throw Exception('Roll Call Report sheet not found');
    }

    final rows = await rollCallSheet.values.allRows();
    if (rows.isEmpty) {
      return {};
    }

    // Assuming the first row is headers
    final lastRow = rows.last;
    if (lastRow.length >= 7) {
      return {
        'Email': lastRow[0],
        'Personnel': lastRow[1],
        'Images': lastRow[2],
        'Remarks': lastRow[3],
        // Ensure the timestamp is stored in MM/dd/yyyy HH:mm:ss format
        'Timestamp': lastRow[4],
        'Shift': lastRow[5],
        'ReportId': lastRow[6],
      };
    }

    return {};
  }

}
