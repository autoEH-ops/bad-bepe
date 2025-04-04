import 'package:intl/intl.dart';

import '../../GoogleAPIs/GoogleSpreadSheet.dart';

class ViewHourlyService {
  Future<List<Map<String, dynamic>>> getAllHourly() async {
    try {
      // Fetch all rows from the sheet
      List<List<dynamic>>? rows =
      await GoogleSheets.hourlyPostUpdateReportPage!.values.allRows();

      if (rows.isEmpty) {
        print("No data found in the sheet");
        return [];
      }

      // Log the retrieved rows for debugging
      print("Fetched rows: \${rows.length} records found");

      // Skip the first row (header) and reverse the list to retrieve from bottom to top
      rows = rows.skip(1).toList().reversed.toList();

      // Map each row to a Map<String, dynamic> with column keys
      List<Map<String, dynamic>> accounts = rows.map((row) {
        String timestamp = row.length > 4 ? row[4].toString() : 'N/A';
        DateTime? parsedDate = _parseDate(timestamp);
        String formattedTimestamp = parsedDate != null
            ? DateFormat("dd/MM/yyyy HH:mm:ss").format(parsedDate)
            : 'Invalid date';

        return {
          'ID email':
          row.isNotEmpty ? row[0].toString() : 'N/A', // Column A data
          'Gate post': row.length > 1
              ? row[1].toString().trim()
              : 'N/A', // Column B data (trimmed)
          'image': row.length > 2
              ? row[2].toString().trim()
              : 'N/A', // Column C data (trimmed)
          'REmake': row.length > 3 ? row[3].toString() : 'N/A', // Column D data
          'Report ID':
          row.length > 5 ? row[5].toString() : 'N/A', // Column F data
          'timestamp': formattedTimestamp, // Convert timestamp
        };
      }).toList();

      return accounts;
    } catch (e) {
      // Log error if there's an issue
      print("Error fetching data: $e");
      return [];
    }
  }

  DateTime? _parseDate(String dateString) {
    List<String> dateFormats = [
      "dd/MM/yyyy HH:mm:ss",
      "yyyy-MM-dd HH:mm:ss",
      "MM/dd/yyyy HH:mm:ss",
      "yyyy/MM/dd HH:mm:ss",
      "MM-dd-yyyy HH:mm:ss",
      "dd-MM-yyyy HH:mm:ss",
    ];

    for (String format in dateFormats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        // Continue to try the next format
      }
    }

    // Log unrecognized formats for debugging
    print("Unrecognized date format: $dateString");
    return null; // Return null if no format matches
  }
}

// import 'package:intl/intl.dart';
//
// import '../../GoogleAPIs/GoogleSpreadSheet.dart';
//
// class ViewHourlyService {
//   Future<List<Map<String, dynamic>>> getAllHourly() async {
//     try {
//       // Fetch all rows from the sheet
//       List<List<dynamic>>? rows =
//           await GoogleSheets.hourlyPostUpdateReportPage!.values.allRows();
//
//       if (rows.isEmpty) {
//         print("No data found in the sheet");
//         return [];
//       }
//
//       // Log the retrieved rows for debugging
//       print("Fetched rows: ${rows.length} records found");
//
//       // Skip the first row (header) and reverse the list to retrieve from bottom to top
//       rows = rows.skip(1).toList().reversed.toList();
//
//       // Map each row to a Map<String, dynamic> with column keys
//       List<Map<String, dynamic>> accounts = rows.map((row) {
//         return {
//           'ID email':
//               row.isNotEmpty ? row[0].toString() : 'N/A', // Column A data
//           'Gate post': row.length > 1
//               ? row[1].toString().trim()
//               : 'N/A', // Column B data (trimmed)
//           'image': row.length > 2
//               ? row[2].toString().trim()
//               : 'N/A', // Column C data (trimmed)
//           'REmake': row.length > 3 ? row[3].toString() : 'N/A', // Column D data
//           'Report ID':
//           row.length > 5 ? row[5].toString() : 'N/A', // Column A data
//           'timestamp': row.length > 4
//               ? (row[4].toString())
//               : 'N/A', // Convert timestamp
//         };
//       }).toList();
//
//       return accounts;
//     } catch (e) {
//       // Log error if there's an issue
//       print("Error fetching data: $e");
//       return [];
//     }
//   }
// }
