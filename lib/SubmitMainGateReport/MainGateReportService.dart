import 'package:image_picker/image_picker.dart';

import '/GoogleAPIs/GoogleDrive.dart'; // Import your Google Drive API
import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API

class MainGateReportService {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi =
      GoogleDrive(); // Initialize Google Drive API

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.mainGateReportPage == null) {
      await GoogleSheets.connectToReportList();
    }
  }

  // Add a new main gate report to Google Sheets
  Future<bool> addMainGateReport(String email, String nextMainGate,
      String mainGateStatus, List<XFile> images, String remarks) async {
    await ensureSheetsConnected();

    try {
      // Upload images to Google Drive and get the public file URLs
      List<String> imageLinks = await _uploadImagesToDrive(images);

      // Append a new row to the Google Sheet
      await GoogleSheets.mainGateReportPage!.values.appendRow([
        email,
        nextMainGate,
        mainGateStatus,
        imageLinks.join(', '), // Store image URLs as a comma-separated string
        remarks,
        DateTime.now().toIso8601String(), // Timestamp of report submission
      ]);

      print("Main gate report added successfully.");
      return true;
    } catch (e) {
      print("Error adding main gate report: $e");
      return false;
    }
  }

  // Upload images to Google Drive and return their public URLs
  Future<List<String>> _uploadImagesToDrive(List<XFile> images) async {
    // Upload images and get the public file IDs from Google Drive
    List<String> imageLinks = await googleDriveApi.getGoogleDriveFilesUrl(
        images,
        '1H78bqokqBzxEgiWo8iGz8lTuB3LsMv2_'); // Replace with your folder ID

    // Convert file IDs to public URLs in the required format
    return imageLinks
        .map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing")
        .toList();
  }

  // Check if the document exists (in this case, ensuring the sheet is connected)
  Future<void> checkAndCreateDocument() async {
    await ensureSheetsConnected();
    // Google Sheets doesn't need document creation like Firestore
  }

  // Get the next main gate (you can implement this to fetch from the Google Sheet)
  Future<String> getMainGate() async {
    await ensureSheetsConnected();
    // This logic assumes there is a method to retrieve the current main gate
    return 'Main Gate Name'; // Placeholder for actual gate data
  }

  // Get the current main gate status (you can implement this to fetch from the Google Sheet)
  Future<String> getCurrentMainGateStatus() async {
    await ensureSheetsConnected();
    // This logic assumes there is a method to retrieve the current gate status
    return 'Main Gate Status'; // Placeholder for actual status data
  }

  // Get the last row of data for reporting (you can implement this to fetch from the Google Sheet)
  Future<Map<String, dynamic>> getLastRow() async {
    await ensureSheetsConnected();
    // Fetch the last row from the sheet (you can implement logic to return the row's content)
    return {}; // Placeholder for actual data fetching
  }
}
