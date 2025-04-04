import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart'; // Import for formatting dates
import '../GoogleAPIs/GoogleDrive.dart'; // Import your Google Drive API
import '../GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API
import '/GoogleAPIs/NotifyReportToTelegram.dart'; // Import the notification logic

class RoundingReportService {
  final GoogleDrive googleDriveApi = GoogleDrive();
  final GoogleSheets googleSheetsApi = GoogleSheets(); // Initialize Google Sheets API as well

  // Ensure that Google Sheets is connected before performing any operation
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.roundingReportPage == null) {
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

  Future<void> checkAndCreateDocument() async {
    await ensureSheetsConnected();
  }

  Future<Map<String, String>> getRoundingDetails(String email) async {
    await ensureSheetsConnected();

    // Fetch all rows from the rounding report page
    final rows = await GoogleSheets.roundingReportPage!.values.allRows();

    String previousRoundingPoint = 'N/A';
    String previousRoundingTime = 'N/A';
    String currentRoundingPoint = 'N/A';

// Check if any report exists for this user (based on email)
    for (var row in rows.reversed) {
      if (row.isNotEmpty && row[0].split("\n")[0] == email) {
        previousRoundingPoint = row[1]; // Column C for Rounding Location

        // Convert serial number to DateTime if it looks like a number
        if (row[4].isNotEmpty && double.tryParse(row[4]) != null) {
          previousRoundingTime = _convertSerialDateToDateTime(row[4]);
        } else {
          previousRoundingTime = row[4]; // If it's already in ISO format
        }
        break;
      }
    }


    // Debug: Log the final results
    print("Previous Rounding Point: $previousRoundingPoint");
    print("Previous Rounding Time: $previousRoundingTime");

    // Fetch the list of rounding points from roundingPointPage
    final roundingPoints = await GoogleSheets.roundingPointPage!.values.allRows();

    print("Rounding points: $roundingPoints");  // Debug: Log rounding points

    // Determine the current rounding point based on the previous rounding point
    int currentPointIndex = roundingPoints.indexWhere((point) => point[0] == previousRoundingPoint);

    if (currentPointIndex != -1 && currentPointIndex + 1 < roundingPoints.length) {
      currentRoundingPoint = roundingPoints[currentPointIndex + 1][0]; // Next rounding point
    } else {
      currentRoundingPoint = roundingPoints.isNotEmpty
          ? roundingPoints[0][0] // Default to the first point if no next point found
          : 'N/A';
    }
    print("Returning data: $previousRoundingPoint, $previousRoundingTime, $currentRoundingPoint");

    return {
      "previousRoundingPoint": previousRoundingPoint,
      "previousRoundingTime": previousRoundingTime,
      "currentRoundingPoint": currentRoundingPoint,
    };
  }



  // Helper function to convert Google Sheets serial date to DateTime string
  String _convertSerialDateToDateTime(String serialDateString) {
    final serialDate = double.parse(serialDateString);
    final epochStart = DateTime(1899, 12, 30); // Google Sheets epoch start
    final date = epochStart.add(Duration(days: serialDate.floor()));
    final timePart = Duration(
      milliseconds:
      ((serialDate - serialDate.floor()) * 24 * 60 * 60 * 1000).round(),
    );
    final dateTime = date.add(timePart);
    return DateFormat('yyyy/MM/dd HH:mm:ss').format(dateTime);
  }

  // Add a new rounding report to Google Sheets and notify Telegram
  Future<bool> addRoundingReport(
      String email,
      String location,
      List<XFile> images,
      String remarks,
      String reportId,
      ) async {
    await ensureSheetsConnected();

    try {
      // Get the name associated with the email
      String name = await getNameByEmail(email);

      // Concatenate email and name into a single string
      String emailAndName = '$email\n$name';

      // Upload images to Google Drive and get the public URLs
      List<String> imageLinks = await _uploadImagesToDrive(images);

      // Save the report to the Google Sheet with image links and report ID
      await GoogleSheets.roundingReportPage!.values.appendRow([
        emailAndName, // Email and name in the same column
        location,
        remarks,
        imageLinks.join(', '), // Store image URLs as a comma-separated string
        DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()), // Timestamp of report submission
        reportId, // New report ID
      ]);

      // Notify Telegram about the new report
      await NotifyReportToTelegram.notify(
          'Rounding Point Report', // Sheet name
          [
            emailAndName,
            location,
            remarks,
            imageLinks.join(', '),
            DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now()),
            reportId,
          ] // Data for the Telegram message
      );

      return true;
    } catch (e) {
      print("Error adding rounding report: $e");
      return false;
    }
  }
  // Upload images to Google Drive and return their public URLs
  Future<List<String>> _uploadImagesToDrive(List<XFile> images) async {
    List<String> imageLinks = await googleDriveApi.getGoogleDriveFilesUrl(
        images,
        '1lsYeH9r2g0KHBfNad6g1DAIGDjCNOJR_'); // Replace with your folder ID

    return imageLinks
        .map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing")
        .toList();
  }

  // Generate a new Report ID
  Future<String> generateReportId() async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows from the Google Sheets
      final rows = await GoogleSheets.roundingReportPage!.values.allRows();

      // Log the rows for debugging
      print("Rows fetched: ${rows.length} records found");

      // If the sheet is empty or has only the header, start with the first ID
      if (rows.isEmpty || rows.length == 1) {
        print("No existing data rows. Starting with RDR-000001.");
        return 'RDR-000001';
      }

      // Calculate the new Report ID based on the row number
      int newIdNumber = rows.length; // Subtract 1 for the header row
      String newReportId = 'RDR-${newIdNumber.toString().padLeft(6, '0')}';

      print("Generated new Report ID: $newReportId");
      return newReportId;

    } catch (e) {
      // Log the error and provide a fallback ID in case of failure
      print("Error generating new Report ID: $e");
      return 'RDR-000001'; // Fallback ID
    }
  }
}
