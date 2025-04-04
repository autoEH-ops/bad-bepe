import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyReportFollowUpSuperAdminSettings {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Emergency Follow Up Report Settings')
      .doc('Emergency Follow Up Report Settings');

  Future<void> checkAndCreateDocument() async {
    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        // If the document doesn't exist, create it with the initial field
        await documentReference.set({
          "Title 1": "Emergency Incident Report Details",
          "Title 2": "Report ID : ",
          "Title 3": "Incident Date : ",
          "Title 4": "Incident Time : ",
          "Title 5": "Incident Description : ",
          "Title 6": "Incident Description : ",
          "Title 7": "Previous Emergency Attachments : ",
          "Title 8": "Upload Pass Found Photo",
          "Required 8": true,
          "Title 9": "Follow Up / Update Remarks",
          "Sub Title 9": "Enter Remarks ... ",
          "Required 9": true,
          "Button 1": "Click to Submit",
          "Title 10": "Previous Notes"
        });
      } else {}
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getTitleAndRequired() async {
    try {
      // Get the document
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Emergency Follow Up Report Settings')
          .doc('Emergency Follow Up Report Settings')
          .get();

      // Get the data
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      if (data != null) {
        return data;
      } else {
        // If the 'ID' field does not exist or is not an integer, return 1
        return {};
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateTitle1(String title) async {
    await documentReference.update({"Title 1": title});
  }

  Future<void> updateTitle2(String title) async {
    await documentReference.update({"Title 2": title});
  }

  Future<void> updateTitle3(String title) async {
    await documentReference.update({"Title 3": title});
  }

  Future<void> updateTitle4(String title) async {
    await documentReference.update({"Title 4": title});
  }

  Future<void> updateTitle5(String title) async {
    await documentReference.update({"Title 5": title});
  }

  Future<void> updateTitle6(String title) async {
    await documentReference.update({"Title 6": title});
  }

  Future<void> updateTitle7(String title) async {
    await documentReference.update({"Title 7": title});
  }

  Future<void> updateTitle8(String title) async {
    await documentReference.update({"Title 8": title});
  }

  Future<void> updateRequired8(bool required) async {
    await documentReference.update({"Required 8": required});
  }

  Future<void> updateTitle9(String title) async {
    await documentReference.update({"Title 9": title});
  }

  Future<void> updateSubtitle9(String title) async {
    await documentReference.update({"Sub Title 9": title});
  }

  Future<void> updateRequired9(bool required) async {
    await documentReference.update({"Required 9": required});
  }

  Future<void> updateButton1(String title) async {
    await documentReference.update({"Button 1": title});
  }

  Future<void> updateTitle10(String title) async {
    await documentReference.update({"Title 10": title});
  }
}
