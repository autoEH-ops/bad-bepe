import 'package:intl/intl.dart';

import '../../GoogleAPIs/GoogleSpreadSheet.dart';

class ViewEmergencyService {
  Future<List<Map<String, String>>> getAllHourly() async {
    try {
      // Fetch all rows from the sheet
      List<List<dynamic>>? rows =
          await GoogleSheets.emergencyReportPage!.values.allRows();

      if (rows.isEmpty) {
        print("No data found in the sheet");
        return [];
      }

      // Log the retrieved rows for debugging
      print("Fetched rows: ${rows.length} records found");

      // Skip the first row (header) and reverse the list to retrieve from bottom to top
      rows = rows.skip(1).toList().reversed.toList();

      // Map each row to a Map<String, String> with column keys
      List<Map<String, String>> accounts = rows.map((row) {
        return {
          'ID': row.isNotEmpty ? row[0].toString() : 'N/A', // Column A data
          'timestamp': row.length > 1
              ? row[1].toString().trim()
              : 'N/A', // Column B data (trimmed)
          'Incident Location':
              row.length > 2 ? row[2].toString() : 'N/A', // Column D data
          'Incident Description':
          row.length > 3 ? row[3].toString() : 'N/A', // Column D data
          'Detailed Incident Report':
              row.length > 4 ? row[4].toString() : 'N/A', // Column E data
          'Police Report':
          row.length > 5 ? row[5].toString() : 'N/A', // Column D data
          'Image': row.length > 6 ? row[6].toString() : 'N/A', // Column G data
          'Remarks':
          row.length > 7 ? row[7].toString() : 'N/A', // Column E data
          'reportId': row.length > 8 ? row[8].toString() : 'N/A', // Column G data

        };
      }).toList();

      return accounts;
    } catch (e) {
      // Log error if there's an issue
      print("Error fetching data: $e");
      return [];
    }
  }
}
