import '../GoogleAPIs/GoogleSpreadSheet.dart';

class ManageEmergencyClampingUpMenuService {
  Future<List<Map<String, String>>> getAllClampingIncident() async {
    // Fetch all rows from the sheet

    List<Map<String, String>>? accounts =
    await GoogleSheets.clampingReportPage!.values.map.allRows();

    return accounts!;
  }
}
