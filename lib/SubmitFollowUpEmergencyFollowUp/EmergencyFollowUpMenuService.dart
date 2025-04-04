import 'package:cloud_firestore/cloud_firestore.dart';

import '../GoogleAPIs/GoogleSpreadSheet.dart';

class EmergencyFollowUpMenuService {
  Future<List<Map<String, String>>> getAllEmergencyIncident() async {
    // Fetch all rows from the sheet

    List<Map<String, String>>? accounts =
        await GoogleSheets.emergencyReportPage!.values.map.allRows();

    return accounts!;
  }


  final CollectionReference accounts =
  FirebaseFirestore.instance.collection("Accounts");

  Future<String> getName(String email) async {
    // Get the document snapshot for the given email
    var snapshot = await accounts.where('Email', isEqualTo: email).get();

    // If there's no matching document, return an empty string
    if (snapshot.docs.isEmpty) {
      return "";
    }

    // Get the data of the first matching document
    var data = snapshot.docs.first.data() as Map<String, dynamic>;

    return data['Name'];
  }

}
