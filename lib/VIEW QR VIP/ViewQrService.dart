import '/GoogleAPIs/GoogleSpreadSheet.dart';
import 'package:intl/intl.dart'; // For date formatting

class AllVVQrService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.qrReportPage == null || GoogleSheets.accountsPage == null) {
      await GoogleSheets.connectToReportList();
      print('Connected to Google Sheets');
    }
  }

  // Fetch all QR code accounts (rows) from Google Sheets
  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    await ensureSheetsConnected();

    // Fetch all rows from the QRReport sheet
    final rows = await GoogleSheets.qrReportPage!.values.allRows();
    print('Total QR code rows fetched: ${rows.length}');

    if (rows.isEmpty) {
      print('No QR code rows found in the sheet');
      return [];
    }

    // Extract relevant columns
    List<Map<String, dynamic>> qrCodes = [];
    for (int i = 1; i < rows.length; i++) { // Start from 1 to skip header
      Map<String, dynamic> row = {
        'QR Code': rows[i][0]?.toString().trim() ?? '',
        'Names': rows[i][1]?.toString().trim() ?? 'Unknown Name',
        'Ic Number': rows[i][2]?.toString().trim() ?? 'Unknown IC/Passport',
        'Car Plate': rows[i][3]?.toString().trim() ?? 'No Car Registered',
        'Phone Number': rows[i][4]?.toString().trim() ?? 'Unknown Phone Number',
        'Start Date': rows[i][5]?.toString().trim() ?? 'Unknown Start Date',
        'End Date': rows[i][6]?.toString().trim() ?? 'Unknown End Date',
        'Status': rows[i][7]?.toString().trim() ?? 'Unknown Status',
        'Records': rows[i][8]?.toString().trim() ?? '',
        'QR Attachments': rows[i][11]?.toString().trim() ?? '',
      };

      print('Row ${i + 1} data: $row');
      qrCodes.add(row);
    }

    return qrCodes;
  }

  // Fetch all user accounts from Google Sheets
  Future<List<Map<String, dynamic>>> getAccounts() async {
    await ensureSheetsConnected();

    // Fetch all rows from the Accounts sheet
    final rows = await GoogleSheets.accountsPage!.values.allRows();
    print('Total account rows fetched: ${rows.length}');

    if (rows.isEmpty) {
      print('No account rows found in the sheet');
      return [];
    }

    // Extract relevant columns (Email in Column A (0), Name in Column C (2))
    List<Map<String, dynamic>> accounts = [];
    for (int i = 1; i < rows.length; i++) { // Start from 1 to skip header
      // Ensure that the row has at least 3 columns to prevent index errors
      if (rows[i].length < 3) {
        print('Row ${i + 1} has insufficient columns. Skipping.');
        continue;
      }

      Map<String, dynamic> account = {
        'Email': rows[i][0]?.toString().trim().toLowerCase() ?? '',
        'Name': rows[i][2]?.toString().trim() ?? 'Unknown',
      };
      print('Account ${i + 1}: $account');
      accounts.add(account);
    }

    return accounts;
  }

  // Fetch user's name by email
  Future<String> getNameByEmail(String email) async {
    await ensureSheetsConnected();
    final accounts = await getAccounts();

    print('Searching for email: $email');
    for (var account in accounts) {
      print('Checking account: ${account['Email']}');
      if (account['Email'] == email.trim().toLowerCase()) {
        print('Found name: ${account['Name']} for email: $email');
        return account['Name'];
      }
    }
    print('No name found for email: $email');
    return 'Unknown User'; // Return 'Unknown User' if no matching email is found
  }

  // Get specific QR Code details from Google Sheets
  Future<Map<String, dynamic>> getQrCodeDetails(String qrCode) async {
    await ensureSheetsConnected();

    final rows = await GoogleSheets.qrReportPage!.values.allRows();
    print('Total QR code rows fetched: ${rows.length}');

    if (rows.isEmpty) {
      print('No QR code rows found in the sheet');
      return {};
    }

    // Traverse the rows to match the specific QR code
    for (int i = 1; i < rows.length; i++) { // Start from 1 to skip header
      Map<String, dynamic> row = {
        'QR Code': rows[i][0]?.toString().trim() ?? '',
        'Names': rows[i][1]?.toString().trim() ?? 'Unknown Name',
        'Ic Number': rows[i][2]?.toString().trim() ?? 'Unknown IC/Passport',
        'Car Plate': rows[i][3]?.toString().trim() ?? 'No Car Registered',
        'Phone Number': rows[i][4]?.toString().trim() ?? 'Unknown Phone Number',
        'Start Date': rows[i][5]?.toString().trim() ?? 'Unknown Start Date',
        'End Date': rows[i][6]?.toString().trim() ?? 'Unknown End Date',
        'Status': rows[i][7]?.toString().trim() ?? 'Unknown Status',
        'Records': rows[i][8]?.toString().trim() ?? '',
        'QR Attachments': rows[i][11]?.toString().trim() ?? '',
      };

      print('Checking QR Code in row ${i + 1}: ${row['QR Attachments']}');

      // Normalize QR code strings
      String sheetQrCode = row['QR Attachments'].toString().trim().toUpperCase();
      String targetQrCode = qrCode.trim().toUpperCase();

      // If the QR Code matches, return the corresponding data
      if (sheetQrCode == targetQrCode) {
        print('QR Code matched in row ${i + 1}: $qrCode');
        return row;
      }
    }

    print('QR Code not found: $qrCode');
    return {}; // Return empty map if the QR Code is not found
  }

  // Update specific QR Code details in Google Sheets and log the changes
  Future<void> updateQrCodeDetails(
      String qrCode, Map<String, dynamic> updates, String editedBy) async {
    await ensureSheetsConnected();

    final rows = await GoogleSheets.qrReportPage!.values.allRows();
    print('Total QR code rows fetched for update: ${rows.length}');

    for (int i = 1; i < rows.length; i++) { // Start from 1 to skip header
      String currentQrCode = rows[i][11]?.toString().trim().toUpperCase() ?? ''; // Column L (11)

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
            column: 7,   // Column G
            row: i + 1,  // 1-based row index
          );
          print('End Date updated to "$newEndDate" for QR Code: $qrCode in row ${i + 1}');

          // Create a log entry
          String timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
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

    // If QR Code was not found
    print('QR Code not found: $qrCode');
    throw 'QR Code not found: $qrCode';
  }
}
