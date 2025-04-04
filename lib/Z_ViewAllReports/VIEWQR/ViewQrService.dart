import '/GoogleAPIs/GoogleSpreadSheet.dart';
import 'package:intl/intl.dart';

class AllQrvService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Ensure that Google Sheets is connected
  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.qrReportPage == null) {
      await GoogleSheets.connectToReportList();
      print('Connected to Google Sheets');
    }
  }

  // Fetch all accounts (rows) from Google Sheets
  Future<List<Map<String, dynamic>>> getAllAccounts() async {
    await ensureSheetsConnected();

    // Fetch all rows from the QR Code sheet
    final rows = await GoogleSheets.qrReportPage!.values.allRows();
    print('Total rows fetched: \${rows.length}');

    if (rows.isEmpty) {
      print('No rows found in the sheet');
      return [];
    }

    // Extract columns A, B, C, D, E, F, G, H, and L
    List<Map<String, dynamic>> qrCodes = [];
    for (int i = 1; i < rows.length; i++) {
      List<dynamic> currentRow = rows[i];

      // Safely access each column by checking if the index exists
      String qrCode = currentRow.isNotEmpty ? currentRow[0] : '';
      String names = currentRow.length > 1 ? currentRow[1] : '';
      String icNumber = currentRow.length > 2 ? currentRow[2] : '';
      String carPlate = currentRow.length > 3 ? currentRow[3] : '';
      String phoneNumber = currentRow.length > 4 ? currentRow[4] : '';
      String startDate = _formatFlexibleDate(currentRow.length > 5 ? currentRow[5] : '');
      String endDate = _formatFlexibleDate(currentRow.length > 6 ? currentRow[6] : '');
      String status = currentRow.length > 7 ? currentRow[7] : '';
      String records = currentRow.length > 8 ? currentRow[8] : '';
      String timestamp = currentRow.length > 10 ? currentRow[10] : '';
      String passId = currentRow.length > 14 ? currentRow[14] : '';
      String passImage = currentRow.length > 15 ? currentRow[15] : '';
      String remarks = currentRow.length > 16 ? currentRow[16] : '';

      Map<String, dynamic> row = {
        'QR Code': qrCode, // Column A
        'Names': names, // Column B
        'Ic Number': icNumber, // Column C
        'Car Plate': carPlate, // Column D
        'Phone Number': phoneNumber, // Column E
        'Start Date': startDate, // Column F
        'End Date': endDate, // Column G
        'Status': status, // Column H
        'Records': records, // Column I
        'Timestamp': timestamp, // Column K
        'PASS USED': passId, // Column O
        'passimage': passImage, // Column P
        'Remarks': remarks, // Column Q
      };

      print('Row $i data: $row');
      qrCodes.add(row);
    }

    // Sort list by start date in descending order, then by end date in descending order
    qrCodes.sort((a, b) {
      DateTime dateAStart = _parseFlexibleDate(a['Start Date']) ?? DateTime(1970);
      DateTime dateBStart = _parseFlexibleDate(b['Start Date']) ?? DateTime(1970);
      int compareStart = dateBStart.compareTo(dateAStart);
      if (compareStart != 0) {
        return compareStart;
      }
      DateTime dateAEnd = _parseFlexibleDate(a['End Date']) ?? DateTime(1970);
      DateTime dateBEnd = _parseFlexibleDate(b['End Date']) ?? DateTime(1970);
      return dateBEnd.compareTo(dateAEnd);
    });

    return qrCodes;
  }

  // Get specific QR Code details from Google Sheets
  Future<Map<String, dynamic>> getQrCodeDetails(String qrCode) async {
    await ensureSheetsConnected();

    final rows = await GoogleSheets.qrReportPage!.values.allRows();
    print('Total rows fetched for QR Code details: \${rows.length}');

    if (rows.isEmpty) {
      print('No rows found in the sheet');
      return {};
    }

    // Traverse the rows to match the specific QR code
    for (int i = 1; i < rows.length; i++) {
      List<dynamic> currentRow = rows[i];

      // Safely access each column by checking if the index exists
      String qrCodeValue = currentRow.isNotEmpty ? currentRow[0] : '';
      String names = currentRow.length > 1 ? currentRow[1] : '';
      String icNumber = currentRow.length > 2 ? currentRow[2] : '';
      String carPlate = currentRow.length > 3 ? currentRow[3] : '';
      String phoneNumber = currentRow.length > 4 ? currentRow[4] : '';
      String startDate = _formatFlexibleDate(currentRow.length > 5 ? currentRow[5] : '');
      String endDate = _formatFlexibleDate(currentRow.length > 6 ? currentRow[6] : '');
      String status = currentRow.length > 7 ? currentRow[7] : '';
      String records = currentRow.length > 8 ? currentRow[8] : '';
      String timestamp = currentRow.length > 10 ? currentRow[10] : '';
      String passId = currentRow.length > 14 ? currentRow[14] : '';
      String passImage = currentRow.length > 15 ? currentRow[15] : '';
      String remarks = currentRow.length > 16 ? currentRow[16] : '';

      Map<String, dynamic> row = {
        'QR Code': qrCodeValue, // Column A
        'Names': names, // Column B
        'Ic Number': icNumber, // Column C
        'Car Plate': carPlate, // Column D
        'Phone Number': phoneNumber, // Column E
        'Start Date': startDate, // Column F
        'End Date': endDate, // Column G
        'Status': status, // Column H
        'Records': records, // Column I
        'Timestamp': timestamp, // Column K
        'PASS USED': passId, // Column O
        'passimage': passImage, // Column P
        'Remarks': remarks, // Column Q
      };

      print('Checking row $i for QR Code: ${row['QR Code']}');

      // If the QR Code matches, return the corresponding data
      if (row['QR Code'] == qrCode) {
        print('QR Code found: $qrCode');
        return row;
      }
    }

    print('QR Code not found: $qrCode');
    return {}; // Return empty map if the QR Code is not found
  }

  // Helper function to format date in flexible formats and return as dd/MM/yyyy
  String _formatFlexibleDate(String? date) {
    if (date == null || date.isEmpty) return 'N/A';
    List<String> formats = [
      "yyyy-MM-dd",
      "dd/MM/yyyy",
      "MM/dd/yyyy",
      "yyyy/MM/dd",
    ];
    for (String format in formats) {
      try {
        DateTime parsedDate = DateFormat(format).parseStrict(date);
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        // Continue trying other formats
      }
    }
    return 'N/A';
  }

  DateTime? _parseFlexibleDate(String? date) {
    if (date == null) return null;
    List<String> formats = [
      "yyyy-MM-dd",
      "dd/MM/yyyy",
      "MM/dd/yyyy",
      "yyyy/MM/dd",
    ];
    for (String format in formats) {
      try {
        return DateFormat(format).parseStrict(date);
      } catch (e) {
        // Continue trying other formats
      }
    }
    return null;
  }
}

//Original Code
// import '/GoogleAPIs/GoogleSpreadSheet.dart';
//
// class AllQrvService {
//   final GoogleSheets googleSheetsApi = GoogleSheets();
//
//   // Ensure that Google Sheets is connected
//   Future<void> ensureSheetsConnected() async {
//     if (GoogleSheets.qrReportPage == null) {
//       await GoogleSheets.connectToSpreadsheets();
//       print('Connected to Google Sheets');
//     }
//   }
//
//   // Fetch all accounts (rows) from Google Sheets
//   Future<List<Map<String, dynamic>>> getAllAccounts() async {
//     await ensureSheetsConnected();
//
//     // Fetch all rows from the QR Code sheet
//     final rows = await GoogleSheets.qrReportPage!.values.allRows();
//     print('Total rows fetched: ${rows.length}');
//
//     if (rows.isEmpty) {
//       print('No rows found in the sheet');
//       return [];
//     }
//
//     // Extract columns A, B, C, D, E, F, G, H, and L
//     List<Map<String, dynamic>> qrCodes = [];
//     for (int i = 1; i < rows.length; i++) {
//       List<dynamic> currentRow = rows[i];
//
//       // Safely access each column by checking if the index exists
//       String qrCode = currentRow.isNotEmpty ? currentRow[0] : '';
//       String names = currentRow.length > 1 ? currentRow[1] : '';
//       String icNumber = currentRow.length > 2 ? currentRow[2] : '';
//       String carPlate = currentRow.length > 3 ? currentRow[3] : '';
//       String phoneNumber = currentRow.length > 4 ? currentRow[4] : '';
//       String startDate = currentRow.length > 5 ? currentRow[5] : '';
//       String endDate = currentRow.length > 6 ? currentRow[6] : '';
//       String status = currentRow.length > 7 ? currentRow[7] : '';
//       String records = currentRow.length > 8 ? currentRow[8] : '';
//       String timestamp = currentRow.length > 10 ? currentRow[10] : '';
//       String passId = currentRow.length > 14 ? currentRow[14] : '';
//       String passImage = currentRow.length > 15 ? currentRow[15] : '';
//       String remarks = currentRow.length > 16 ? currentRow[16] : '';
//
//       Map<String, dynamic> row = {
//         'QR Code': qrCode, // Column A
//         'Names': names, // Column B
//         'Ic Number': icNumber, // Column C
//         'Car Plate': carPlate, // Column D
//         'Phone Number': phoneNumber, // Column E
//         'Start Date': startDate, // Column F
//         'End Date': endDate, // Column G
//         'Status': status, // Column H
//         'Records': records, // Column I
//         'Timestamp': timestamp, // Column K
//         'PASS USED': passId, // Column O
//         'passimage': passImage, // Column P
//         'Remarks': remarks, // Column Q
//       };
//
//       print('Row $i data: $row');
//       qrCodes.add(row);
//     }
//
//     return qrCodes;
//   }
//
//   // Get specific QR Code details from Google Sheets
//   Future<Map<String, dynamic>> getQrCodeDetails(String qrCode) async {
//     await ensureSheetsConnected();
//
//     final rows = await GoogleSheets.qrReportPage!.values.allRows();
//     print('Total rows fetched for QR Code details: ${rows.length}');
//
//     if (rows.isEmpty) {
//       print('No rows found in the sheet');
//       return {};
//     }
//
//     // Traverse the rows to match the specific QR code
//     for (int i = 1; i < rows.length; i++) {
//       List<dynamic> currentRow = rows[i];
//
//       // Safely access each column by checking if the index exists
//       String qrCodeValue = currentRow.isNotEmpty ? currentRow[0] : '';
//       String names = currentRow.length > 1 ? currentRow[1] : '';
//       String icNumber = currentRow.length > 2 ? currentRow[2] : '';
//       String carPlate = currentRow.length > 3 ? currentRow[3] : '';
//       String phoneNumber = currentRow.length > 4 ? currentRow[4] : '';
//       String startDate = currentRow.length > 5 ? currentRow[5] : '';
//       String endDate = currentRow.length > 6 ? currentRow[6] : '';
//       String status = currentRow.length > 7 ? currentRow[7] : '';
//       String records = currentRow.length > 8 ? currentRow[8] : '';
//       String timestamp = currentRow.length > 10 ? currentRow[10] : '';
//       String passId = currentRow.length > 14 ? currentRow[14] : '';
//       String passImage = currentRow.length > 15 ? currentRow[15] : '';
//       String remarks = currentRow.length > 16 ? currentRow[16] : '';
//
//       Map<String, dynamic> row = {
//         'QR Code': qrCodeValue, // Column A
//         'Names': names, // Column B
//         'Ic Number': icNumber, // Column C
//         'Car Plate': carPlate, // Column D
//         'Phone Number': phoneNumber, // Column E
//         'Start Date': startDate, // Column F
//         'End Date': endDate, // Column G
//         'Status': status, // Column H
//         'Records': records, // Column I
//         'Timestamp': timestamp, // Column K
//         'PASS USED': passId, // Column O
//         'passimage': passImage, // Column P
//         'Remarks': remarks, // Column Q
//       };
//
//       print('Checking row $i for QR Code: ${row['QR Code']}');
//
//       // If the QR Code matches, return the corresponding data
//       if (row['QR Code'] == qrCode) {
//         print('QR Code found: $qrCode');
//         return row;
//       }
//     }
//
//     print('QR Code not found: $qrCode');
//     return {}; // Return empty map if the QR Code is not found
//   }
// }
