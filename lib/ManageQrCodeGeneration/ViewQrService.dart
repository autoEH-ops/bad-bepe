import '/GoogleAPIs/GoogleSpreadSheet.dart';

class AllQrService {
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
    print('Total rows fetched: ${rows.length}');

    if (rows.isEmpty) {
      print('No rows found in the sheet');
      return [];
    }

    // Extract columns A, B, C, D, E, F, G, H, and L
    List<Map<String, dynamic>> qrCodes = [];
    for (int i = 1; i < rows.length; i++) {
      Map<String, dynamic> row = {
        'QR Code': rows[i][0], // Column A (Added this for correct qrData)
        'Names': rows[i][1], // Column B
        'Ic Number': rows[i][2], // Column C
        'Car Plate': rows[i][3], // Column D
        'Phone Number': rows[i][4], // Column E
        'Start Date': rows[i][5], // Column F
        'End Date': rows[i][6], // Column G
        'Status': rows[i][7], // Column H
        'Records': rows[i][8], // Column H
        'QR Attachments': rows[i][11], // Column L
      };

      print('Row $i data: $row');
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
    for (int i = 1; i < rows.length; i++) {
      Map<String, dynamic> row = {
        'QR Code': rows[i][0], // Column A
        'Names': rows[i][1], // Column B
        'Ic Number': rows[i][2], // Column C
        'Car Plate': rows[i][3], // Column D
        'Phone Number': rows[i][4], // Column E
        'Start Date': rows[i][5], // Column F
        'End Date': rows[i][6], // Column G
        'Status': rows[i][7], // Column H
        'Records': rows[i][8], // Column H
        'QR Attachments': rows[i][11], // Column L
      };

      print('Checking row $i for QR Code: ${row['QR Attachments']}');

      // If the QR Code matches, return the corresponding data
      if (row['QR Attachments'] == qrCode) {
        print('QR Code found: $qrCode');
        return row;
      }
    }

    print('QR Code not found: $qrCode');
    return {}; // Return empty map if the QR Code is not found
  }
}
