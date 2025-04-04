import 'package:intl/intl.dart';

import '/GoogleAPIs/GoogleSpreadSheet.dart';

class AllAQrService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.qrReportPage == null) {
      await GoogleSheets.connectToReportList();
      print('Connected to Google Sheets');
    }
  }

  // Helper method to safely get a value from a row
  dynamic getValue(List<dynamic> row, int index) {
    if (row.length > index) {
      return row[index];
    } else {
      return ''; // Return empty string if index is out of range
    }
  }

  // Fetch all accounts (rows) from Google Sheets
  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    await ensureSheetsConnected();

    // Fetch all rows from the QR Code sheet
    final rows = await GoogleSheets.qrReportPage!.values.allRows();
    print('Total rows fetched: ${rows.length}');

    if (rows.isEmpty) {
      print('No rows found in the sheet');
      return [];
    }

    // Extract columns A to T (indices 0 to 19)
    List<Map<String, dynamic>> qrCodes = [];
    for (int i = 1; i < rows.length; i++) { // Start from 1 to skip headers
      List<dynamic> currentRow = rows[i];
      Map<String, dynamic> row = {
        'QR Code': getValue(currentRow, 0),          // Column A - ID
        'Names': getValue(currentRow, 1),            // Column B - Names
        'Ic Number': getValue(currentRow, 2),        // Column C - Ic Number
        'Car Plate': getValue(currentRow, 3),        // Column D - Car Plate
        'Phone Number': getValue(currentRow, 4),     // Column E - Phone Number
        'Start Date': getValue(currentRow, 5),       // Column F - Start Date
        'End Date': getValue(currentRow, 6),         // Column G - End Date
        'Status': getValue(currentRow, 7),           // Column H - Status
        'Records': getValue(currentRow, 8),          // Column I - Records
        'VMSRecords': getValue(currentRow, 9),       // Column J - VMSRecords
        'Timestamp': getValue(currentRow, 10),       // Column K - Timestamp
        'Qr Attachments': getValue(currentRow, 11),  // Column L - Qr Attachments
        'Shortened URL': getValue(currentRow, 12),   // Column M - Shortened URL
        'passType': getValue(currentRow, 13),        // Column N - passType
        'passId': getValue(currentRow, 14),          // Column O - passId
        'passimage': getValue(currentRow, 15),       // Column P - passimage
        'Remarks': getValue(currentRow, 16),         // Column Q - Remarks
        'email': getValue(currentRow, 17),           // Column R - email
        'status2': getValue(currentRow, 18),         // Column S - status2
        'category': getValue(currentRow, 19),        // Column T - category
      };

      print('Row ${i + 1} data: $row'); // Adding 1 to index for readability
      qrCodes.add(row);
    }

    return qrCodes;
  }

  // Get specific QR Code details from Google Sheets
  Future<Map<String, dynamic>> getQrCodeDetails(String qrCode) async {
    await ensureSheetsConnected();

    final rows = await GoogleSheets.qrReportPage!.values.allRows();
    print('Total rows fetched for QR Code details: ${rows.length}');

    if (rows.isEmpty) {
      print('No rows found in the sheet');
      return {};
    }

    // Traverse the rows to match the specific QR code
    for (int i = 1; i < rows.length; i++) { // Start from 1 to skip headers
      List<dynamic> currentRow = rows[i];
      Map<String, dynamic> row = {
        'QR Code': getValue(currentRow, 0),          // Column A - ID
        'Names': getValue(currentRow, 1),            // Column B - Names
        'Ic Number': getValue(currentRow, 2),        // Column C - Ic Number
        'Car Plate': getValue(currentRow, 3),        // Column D - Car Plate
        'Phone Number': getValue(currentRow, 4),     // Column E - Phone Number
        'Start Date': getValue(currentRow, 5),       // Column F - Start Date
        'End Date': getValue(currentRow, 6),         // Column G - End Date
        'Status': getValue(currentRow, 7),           // Column H - Status
        'Records': getValue(currentRow, 8),          // Column I - Records
        'VMSRecords': getValue(currentRow, 9),       // Column J - VMSRecords
        'Timestamp': getValue(currentRow, 10),        // Column K - Timestamp
        'Qr Attachments': getValue(currentRow, 11),   // Column L - Qr Attachments
        'Shortened URL': getValue(currentRow, 12),    // Column M - Shortened URL
        'passType': getValue(currentRow, 13),         // Column N - passType
        'passId': getValue(currentRow, 14),           // Column O - passId
        'passimage': getValue(currentRow, 15),        // Column P - passimage
        'Remarks': getValue(currentRow, 16),          // Column Q - Remarks
        'email': getValue(currentRow, 17),            // Column R - email
        'status2': getValue(currentRow, 18),          // Column S - status2
        'category': getValue(currentRow, 19),         // Column T - category
      };

      print('Checking row ${i + 1} for QR Code: ${row['QR Code']}'); // Updated here

      // If the QR Code matches, return the corresponding data
      if (row['QR Code'] == qrCode) { // Changed from 'Qr Attachments' to 'QR Code'
        print('QR Code found: $qrCode');
        return row;
      }
    }

    print('QR Code not found: $qrCode');
    return {}; // Return empty map if the QR Code is not found
  }

  Future<bool> updateStatus2(String qrCode, String newStatus) async {
    try {
      await ensureSheetsConnected(); // Ensure persistent connection

      // Fetch all rows to find the target row
      final rows = await GoogleSheets.qrReportPage!.values.allRows();

      if (rows.isEmpty) {
        print('No rows found in the sheet');
        return false;
      }

      for (var i = 0; i < rows.length; i++) {
        final currentRow = rows[i];
        if (getValue(currentRow, 0).toString().trim() == qrCode.trim()) { // Ensure matching 'QR Code'
          print('Updating row $i with new status: $newStatus');
          // Column T is index 19
          await GoogleSheets.qrReportPage!.values.insertValue(newStatus, column: 19, row: i + 1);
          return true;
        }
      }

      print('No matching QR code found');
      return false;
    } catch (e) {
      print('Error occurred while updating status2: $e');
      return false;
    }
  }
  // Update specific QR Code details in Google Sheets and log the changes
  Future<void> updateQrCodeDetails(
      String qrCode, Map<String, dynamic> updates, String editedBy) async {
    await ensureSheetsConnected();

    final rows = await GoogleSheets.qrReportPage!.values.allRows();
    print('Total QR code rows fetched for update: ${rows.length}');

    for (int i = 1; i < rows.length; i++) { // Start from 1 to skip header
      String currentQrCode = rows[i][11]?.toString().trim().toUpperCase() ??
          ''; // Column L (11)

      print('Checking row ${i + 1}: QR Code = $currentQrCode');

      if (currentQrCode == qrCode.trim().toUpperCase()) {
        print('QR Code matched in row ${i + 1}. Preparing to update.');

        if (updates.containsKey('End Date')) {
          // Fetch the current 'End Date' (Column G, index 6)
          String oldEndDate = rows[i][6]?.toString().trim() ?? 'N/A';
          String newEndDate = updates['End Date'].toString();

          // Update the 'End Date' (Column G, 7 in 1-based indexing)
          await GoogleSheets.qrReportPage!.values.insertValue(
            newEndDate, // New end date
            column: 7, // Column G
            row: i + 1, // 1-based row index
          );
          print(
              'End Date updated to "$newEndDate" for QR Code: $qrCode in row ${i +
                  1}');

          // Create a log entry
          String timestamp = DateFormat('dd-MM-yyyy HH:mm:ss').format(
              DateTime.now());
          String logEntry =
              '[$timestamp] End Date changed by $editedBy: "$oldEndDate" -> "$newEndDate"';

          // Fetch existing 'Records' (Column I, index 8)
          String existingRecords = rows[i][8]?.toString().trim() ?? '';

          // Append the new log entry
          String updatedRecords =
          existingRecords.isEmpty ? logEntry : '$existingRecords\n$logEntry';

          // Update the 'Records' field (Column I, 9 in 1-based indexing)
          await GoogleSheets.qrReportPage!.values.insertValue(
            updatedRecords,
            column: 9, // Column I
            row: i + 1, // 1-based row index
          );
          print('Records updated for QR Code: $qrCode in row ${i + 1}');
        }
        return;
      }
    }
  }
}
