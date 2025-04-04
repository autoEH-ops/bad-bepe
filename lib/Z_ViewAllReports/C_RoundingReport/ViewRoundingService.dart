import 'package:intl/intl.dart';

import '../../GoogleAPIs/GoogleSpreadSheet.dart';

class ViewRoundingService {
  Future<List<Map<String, String>>> getAllHourly() async {
    // Fetch all rows from the sheet
    List<Map<String, String>>? accounts =
        await GoogleSheets.roundingReportPage!.values.map.allRows();

    if (accounts == null) {
      return [];
    }

    // Reverse the list to retrieve from bottom to top
    accounts = accounts.reversed.toList();

    return accounts;
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
