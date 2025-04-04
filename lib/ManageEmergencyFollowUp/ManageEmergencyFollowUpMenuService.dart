import '../GoogleAPIs/GoogleSpreadSheet.dart';

class ManageEmergencyFollowUpMenuService {
  Future<List<Map<String, String>>> getAllEmergencyIncident() async {
    // Fetch all rows from the sheet

    List<Map<String, String>>? accounts =
    await GoogleSheets.emergencyReportPage!.values.map.allRows();

    return accounts!;
  }
}
