import 'package:created_by_618_abdo/Components/TimeRelatedFunctions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '/DataFields/FolderIDs/FolderIDs.dart';
import '/GoogleAPIs/GoogleDrive.dart';
import '/GoogleAPIs/SwitchyIo.dart';
import '/GoogleAPIs/WhatsAppAPI.dart';
import '../GoogleAPIs/GoogleSpreadSheet.dart';

class SubmitPassCheckingFollowUpService {
  GoogleDrive googleDrive = GoogleDrive();
  FolderIDs folderIDs = FolderIDs();
  SwitchyIo switchyIo = SwitchyIo();
  WhatsAppAPI whatsAppAPI = WhatsAppAPI();
  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();

  Future<void> checkAndCreateDocument() async {
    String collectionId =
        'Missing Pass Report'; // Replace with your collection ID
    String documentId = 'Missing Pass Report';
    String fieldId = 'ID';

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(collectionId).doc(documentId);

    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        // If the document doesn't exist, create it with the initial field
        await documentReference.set({fieldId: 1});
      } else {}
    } catch (e) {
      print('Error checking or creating document: $e');
    }
  }

  Future<List<Map<String, String>>> getAllPassCheck() async {
    // Fetch all rows from the sheet

    List<Map<String, String>>? accounts =
        await GoogleSheets.missingPassReportPage!.values.map.allRows();

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

  Future<int> getID() async {
    try {
      // Get the document
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Missing Pass Report')
          .doc('Missing Pass Report')
          .get();

      // Get the data
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      // Check if the 'ID' field exists and is an integer
      if (data != null && data['ID'] is int) {
        // If the 'ID' field exists and is an integer, increment it by 1
        return data['ID'];
      } else {
        // If the 'ID' field does not exist or is not an integer, return 1
        return 1;
      }
    } catch (e) {
      print('Exception: $e');
      // Return 1 in case of any error
      return 1;
    }
  }

  Future<void> updateID(int newID) async {
    try {
      // Get a reference to the document
      DocumentReference document = FirebaseFirestore.instance
          .collection('Missing Pass Report')
          .doc('Missing Pass Report');

      // Update the 'ID' field with the new value
      await document.update({'ID': newID});
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<bool> addMissingPassCheckingReport(
    String email,
    List<String> passes,
    String category,
  ) async {
    try {
      String name = await getName(email);
      int id = await getID();
      for (String pass in passes) {
        await GoogleSheets.missingPassReportPage!.values.map.appendRow({
          "Frontly ID": id,
          'Date': "'${timeRelatedFunction.getCurrentDate()}",
          'Time': "'${timeRelatedFunction.getCurrentTime()}",
          'Type of Report': "Missing Pass Checking Report",
          'Email Respondent': email,
          'Name of Respondent': name,
          'Report ID': "MISSING-PASS-$id",
          "Missing Pass": pass,
          "Category": category,
          "Status": "Follow Up",
        });
        id += 1;
      }

      await updateID(id);
      return true;
    } catch (e) {
      return false;
    }
  }
}
