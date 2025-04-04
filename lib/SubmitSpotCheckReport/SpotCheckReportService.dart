import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import for date formatting
import '../GoogleAPIs/GoogleDrive.dart'; // Import your Google Drive API
import '../GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API
import '/GoogleAPIs/NotifyReportToTelegram.dart'; // Import the notification logic

class SpotCheckReportService {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi = GoogleDrive(); // Add Google Drive API

  // Ensure Google Sheets is connected before performing any operation
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.spotCheckReportPage == null) {
      await GoogleSheets.connectToReportList();
    }
  }

  // Retrieve the name associated with the provided email
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

  // Helper to convert serial date to DateTime and format as required
  String _convertSerialDateToDateTime(String serialDate) {
    try {
      final serialNum = double.tryParse(serialDate);
      if (serialNum != null) {
        final int secondsInDay = 86400;
        final DateTime baseDate = DateTime(1899, 12, 30);
        final date = baseDate.add(
            Duration(seconds: (serialNum * secondsInDay).round()));
        return DateFormat('MM/dd/yyyy HH:mm:ss').format(date);
      }
    } catch (e) {
      print("Error converting serial date: $e");
    }
    return serialDate; // If conversion fails, return as-is
  }

  // Add a spot check report to the Google Sheets page
  Future<bool> addSpotCheckReport(String email,
      String time,
      String description,
      String findings,
      String clientRemarks,
      String preparedBy,
      List<XFile> images) async {
    await ensureSheetsConnected();

    // Format the timestamp to 'MM/dd/yyyy HH:mm:ss'
    String formattedTimestamp = DateFormat('dd/MM/yyyy HH:mm:ss').format(
        DateTime.now());

    try {
      // Generate a unique report ID
      String reportId = await generateReportId();

      // Upload images to Google Drive and get the public URLs
      List<String> imageLinks = await _uploadImagesToDrive(images);

      // Retrieve the name for the security officer based on email
      String name = await getNameByEmail(email);

      // Concatenate email and name into a single string
      String emailAndName = '$email\n$name';

      // Check if the GoogleSheets page is connected
      if (GoogleSheets.spotCheckReportPage != null) {
        final row = [
          emailAndName, // Save both email and name in the same column
          formattedTimestamp, // Save current Timestamp in column B
          description,
          findings,
          clientRemarks,
          preparedBy,
          imageLinks.join(', '), // Store image URLs as a comma-separated string
          reportId // Append report ID as the last item in the row
        ];

        // Append the row to the Google Sheets page
        await GoogleSheets.spotCheckReportPage!.values.appendRow(row);
        print('Row successfully appended to the sheet');

        // Notify Telegram about the new report
        await NotifyReportToTelegram.notify(
            'Spot Check Report', // Report Type
            row // Data to include in the notification
        );

        return true;
      } else {
        print('Failed: Google Sheets page is not connected');
        return false;
      }
    } catch (e) {
      print("Error adding spot check report: $e");
      return false;
    }
  }

  // Upload images to Google Drive and return their public URLs
  Future<List<String>> _uploadImagesToDrive(List<XFile> images) async {
    List<String> imageLinks = await googleDriveApi.getGoogleDriveFilesUrl(
        images,
        '1rzwblT6nd7ORIV4rHpV6QYw5i6qtELUu'); // Replace with your actual folder ID

    return imageLinks
        .map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing")
        .toList();
  }

  // Generate a unique report ID based on existing IDs
  Future<String> generateReportId() async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows from the Google Sheets
      final rows = await GoogleSheets.spotCheckReportPage!.values.allRows();

      // Log the rows for debugging
      print("Rows fetched: ${rows.length} records found");

      // If the sheet is empty or has only the header, start with the first ID
      if (rows.isEmpty || rows.length == 1) {
        print("No existing data rows. Starting with SPT-000001.");
        return 'SPT-000001';
      }

      // Calculate the new Report ID based on the row number
      int newIdNumber = rows.length; // Subtract 1 for the header row
      String newReportId = 'SPT-${newIdNumber.toString().padLeft(6, '0')}';

      print("Generated new Report ID: $newReportId");
      return newReportId;
    } catch (e) {
      // Log the error and provide a fallback ID in case of failure
      print("Error generating new Report ID: $e");
      return 'SPT-000001'; // Fallback ID
    }
  }

  // Get the last spot check details for the given email
  Future<Map<String, String>> getLastSpotCheckDetails(String email) async {
    await ensureSheetsConnected();

    // Fetch all rows, ensuring it handles null cases with an empty list as a fallback
    final rows = await GoogleSheets.spotCheckReportPage!.values.allRows() ?? [];

    // Traverse rows in reverse to find the last spot check for the given email
    for (var row in rows.reversed) {
      if (row.isNotEmpty && row[0].split("\n")[0] == email) {
        // Ensure that column 2 contains a valid date and time
        String formattedDateTime = _convertSerialDateToDateTime(
            row[1]); // Column C for DateTime
        return {
          'lastSpotCheckId': row[0], // Column A for Name/ID
          'lastSpotCheckDateTime': formattedDateTime, // Combined Date and Time
        };
      }
    }

    // If no match is found, return empty map or handle as needed
    return {'lastSpotCheckId': 'N/A', 'lastSpotCheckDateTime': 'N/A'};
  }
}
