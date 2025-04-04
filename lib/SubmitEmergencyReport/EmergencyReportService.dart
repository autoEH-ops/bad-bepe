import 'package:image_picker/image_picker.dart';
import '/GoogleAPIs/GoogleDrive.dart'; // Import your Google Drive API
import '/GoogleAPIs/GoogleSpreadSheet.dart'; // Import your Google Sheets API
import 'package:flutter/material.dart';
import '/GoogleAPIs/NotifyReportToTelegram.dart'; // Import the notification logic

class EmergencyReportService {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi = GoogleDrive();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.emergencyReportPage == null) {
      await GoogleSheets.connectToReportList();
    }
  }

  // Function to get the name by email
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

  Future<bool> addEmergencyReport(
      String email,
      List<XFile> images,
      String location,
      String incident,
      String detailReport,
      String policeReportOption,
      String remarks,
      ) async {
    await ensureSheetsConnected();

    try {
      // Generate the current timestamp in DD-MM-YYYY HH:MM:SS format
      DateTime now = DateTime.now();
      String timestamp =
          "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year} "
          "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";

      print("Generated Timestamp: $timestamp");

      // Append the new row without a Report ID first
      String name = await getNameByEmail(email);
      String emailAndName = '$email\n$name';
      List<String> imageLinks = await _uploadImagesToDrive(images);

      await GoogleSheets.emergencyReportPage!.values.appendRow([
        emailAndName,
        timestamp, // Timestamp column
        location,
        incident,
        detailReport,
        policeReportOption,
        imageLinks.join(", "),
        remarks,
        "" // Placeholder for the Report ID
      ]);

      // Fetch all rows again to determine the new row's position
      final rows = await GoogleSheets.emergencyReportPage!.values.allRows();

      // Calculate the Report ID based on the new row's position
      int newIdNumber = rows.length - 1; // Subtract 1 for the header row
      String newReportId = 'EMG-${newIdNumber.toString().padLeft(6, '0')}';

      // Update the Report ID in the last row
      await GoogleSheets.emergencyReportPage!.values.insertValue(
          newReportId,
          column: 9, // Column I (0-based index: 8) assuming timestamp is column B
          row: rows.length);

      print("Emergency report added successfully with Report ID: $newReportId.");

      // Notify Telegram about the new report
      await NotifyReportToTelegram.notify(
        'Emergency Report', // Report Type
        [
          emailAndName,
          timestamp,
          location,
          incident,
          detailReport,
          policeReportOption,
          imageLinks.join(", "),
          remarks,
          newReportId
        ], // Data for the Telegram message
      );

      return true;
    } catch (e) {
      print("Error adding emergency report: $e");
      return false;
    }
  }

  // Upload images to Google Drive and return their public URLs
  Future<List<String>> _uploadImagesToDrive(List<XFile> images) async {
    List<String> imageLinks = await googleDriveApi.getGoogleDriveFilesUrl(
        images,
        '12FqxsCAe98eBlAd1D_3A7RTRUa6Pf2uC'); // Replace with your folder ID

    return imageLinks
        .map((id) => "https://drive.google.com/file/d/$id/view?usp=sharing")
        .toList();
  }

  // Generate a unique report ID
  Future<String> generateNewReportId() async {
    await ensureSheetsConnected();

    try {
      // Fetch all rows from the Google Sheets
      final rows = await GoogleSheets.emergencyReportPage!.values.allRows();

      // Log the rows for debugging
      print("Rows fetched: ${rows.length} records found");

      // If the sheet is empty or has only the header, start with the first ID
      if (rows.isEmpty || rows.length == 1) {
        print("No existing data rows. Starting with EMG-000001.");
        return 'EMG-000001';
      }

      // Calculate the new Report ID based on the row number
      int newIdNumber = rows.length; // Subtract 1 for the header row
      String newReportId = 'EMG-${newIdNumber.toString().padLeft(6, '0')}';

      print("Generated new Report ID: $newReportId");
      return newReportId;
    } catch (e) {
      // Log the error and provide a fallback ID in case of failure
      print("Error generating new Report ID: $e");
      return 'EMG-000001'; // Fallback ID
    }
  }
}
