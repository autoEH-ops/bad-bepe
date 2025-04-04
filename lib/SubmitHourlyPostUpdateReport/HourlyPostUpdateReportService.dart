import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '/GoogleAPIs/GoogleDrive.dart'; // Import your Google Drive API
import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API
import '/GoogleAPIs/NotifyReportToTelegram.dart'; // Import the notification logic

class HourlyPostUpdateReportService {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi = GoogleDrive(); // Initialize Google Drive API

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.hourlyPostUpdateReportPage == null) {
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

  // Add a new hourly post update report to Google Sheets
  Future<bool> addHourlyReport(
      String email, String postName, List<XFile> images, String remarks) async {
    await ensureSheetsConnected();

    try {
      // Generate a new Report ID
      String reportId = await generateNewReportId();

      // Get the name associated with the email
      String name = await getNameByEmail(email);

      // Upload images to Google Drive and get the public file IDs
      List<String> imageIds = await googleDriveApi.getGoogleDriveFilesUrl(
          images,
          '1_BSMMxfDPrrPlw24JNthkIgsNbrWhxJg'); // Replace with your folder ID

      // Convert file IDs to public URLs in the required format
      List<String> imageLinks = imageIds
          .map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing")
          .toList();

      // Concatenate email and name, separated by a newline character for better readability
      String emailAndName = '$email\n$name';

      // Format the timestamp to 'MM/dd/yyyy HH:mm:ss'
      String formattedTimestamp = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

      // Append a new row to the Google Sheet with the combined email and name, report ID, etc.
      await GoogleSheets.hourlyPostUpdateReportPage!.values.appendRow([
        emailAndName, // Email and name in the same column
        postName,
        imageLinks.join(', '), // Store image URLs as a comma-separated string
        remarks,
        formattedTimestamp, // Timestamp of report submission
        reportId // Add the generated report ID
      ]);

      // Notify Telegram about the new report
      await NotifyReportToTelegram.notify(
          'Hourly Post Update Report', // Sheet name
          [
            emailAndName,
            postName,
            imageLinks.join(', '),
            remarks,
            formattedTimestamp,
            reportId
          ] // Data for the Telegram message
      );

      return true;
    } catch (e) {
      print("Error adding hourly post report: $e");
      return false;
    }
  }

  Future<String> generateNewReportId() async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows from the Google Sheets
      final rows = await GoogleSheets.hourlyPostUpdateReportPage!.values.allRows();

      // Log the rows for debugging
      print("Rows fetched: ${rows.length} records found");

      // If the sheet is empty or has only the header, start with the first ID
      if (rows.isEmpty || rows.length == 1) {
        print("No existing data rows. Starting with HPR-000001.");
        return 'HPR-000001';
      }

      // Calculate the new Report ID based on the row number
      int newIdNumber = rows.length; // Subtract 1 for the header row
      String newReportId = 'HPR-${newIdNumber.toString().padLeft(6, '0')}';

      print("Generated new Report ID: $newReportId");
      return newReportId;

    } catch (e) {
      // Log the error and provide a fallback ID in case of failure
      print("Error generating new Report ID: $e");
      return 'HPR-000001'; // Fallback ID
    }
  }

}
