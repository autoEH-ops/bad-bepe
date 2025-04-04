import 'package:cloud_firestore/cloud_firestore.dart';

class ShutterReportSuperAdminSettings {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Shutter Report Settings')
      .doc('Shutter Report Settings');

  Future<void> checkAndCreateDocument() async {
    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        // If the document doesn't exist, create it with the initial field
        await documentReference.set({
          "Title 1": "Shutter Details",
          "Title 2": "Current Shutter : ",
          'Title 3': "Shutter Status : To Be ",
          "Title 4": "Previous Shutter : ",
          "Title 5": "Previous Date & Time : ",
          "Title 6": "Upload Photo",
          "Required 6": true,
          "Title 7": "Additional Remarks",
          "Required 7": true,
          "Button 1": "Click to Submit",
          "Sub Title 1": "Additional Remark",
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
          .collection('Shutter Report Settings')
          .doc('Shutter Report Settings')
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

  Future<void> updateRequired6(bool required) async {
    await documentReference.update({"Required 6": required});
  }

  Future<void> updateRequired7(bool required) async {
    await documentReference.update({"Required 7": required});
  }

  Future<void> updateButton1(String title) async {
    await documentReference.update({"Button 1": title});
  }

  Future<void> updateSubtitle1(String title) async {
    await documentReference.update({"Sub Title 1": title});
  }
}
