import 'package:cloud_firestore/cloud_firestore.dart';

class ClampingFollowUpReportSuperAdminSettings {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Clamping Follow Up Report Settings')
      .doc('Clamping Follow Up Report Settings');

  Future<void> checkAndCreateDocument() async {
    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        // If the document doesn't exist, create it with the initial field
        await documentReference.set({
          "Title 1": "Clamping Details",
          "Title 2": "Report ID : ",
          "Title 3": "Date : ",
          "Title 4": "Time : ",
          "Title 5": "Car Plate : ",
          "Title 6": "Previous Notes",
          "Title 7": "Previous Car Plate Attachments",
          "Title 8": "Previous Clamping Attachments",
          "Title 9": "Upload Unclamping Photos",
          "Required 9": true,
          "Title 10": "Upload Payment Slips",
          "Required 10": true,
          "Title 11": "Follow Up / Update Remarks",
          "Sub Title 11": "Enter Remarks ... ",
          "Required 11": true,
          "Button 1": "Click to Submit",
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
          .collection('Clamping Follow Up Report Settings')
          .doc('Clamping Follow Up Report Settings')
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

  Future<void> updateTitle9(String title) async {
    await documentReference.update({"Title 9": title});
  }

  Future<void> updateRequired9(bool required) async {
    await documentReference.update({"Required 9": required});
  }

  Future<void> updateTitle10(String title) async {
    await documentReference.update({"Title 10": title});
  }

  Future<void> updateRequired10(bool required) async {
    await documentReference.update({"Required 10": required});
  }

  Future<void> updateTitle11(String title) async {
    await documentReference.update({"Title 11": title});
  }

  Future<void> updateSubtitle11(String title) async {
    await documentReference.update({"Sub Title 11": title});
  }

  Future<void> updateRequired11(bool required) async {
    await documentReference.update({"Required 11": required});
  }

  Future<void> updateButton1(String title) async {
    await documentReference.update({"Button 1": title});
  }
}
