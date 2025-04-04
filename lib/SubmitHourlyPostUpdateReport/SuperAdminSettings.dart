import 'package:cloud_firestore/cloud_firestore.dart';

class HourlyPostUpdateReportSuperAdminSettings {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Hourly Post Update Settings')
      .doc('Hourly Post Update Settings');

  Future<void> checkAndCreateDocument() async {
    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        // If the document doesn't exist, create it with the initial field
        await documentReference.set({
          "Title 1": "Current Hour",
          "Title 2": "Lists of Gate Posts",
          "Required 2": true,
          "Title 4": "Upload Photo",
          "Required 4": true,
          "Title 5": "Additional Remarks",
          "Required 5": true,
          "Button 1": "Click to Submit",
          "Sub Title 1": "Enter Remarks ... "
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
          .collection('Hourly Post Update Settings')
          .doc('Hourly Post Update Settings')
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

  Future<void> updateTitle4(String title) async {
    await documentReference.update({"Title 4": title});
  }

  Future<void> updateTitle5(String title) async {
    await documentReference.update({"Title 5": title});
  }

  Future<void> updateRequired2(bool required) async {
    await documentReference.update({"Required 2": required});
  }

  Future<void> updateRequired3(bool required) async {
    await documentReference.update({"Required 3": required});
  }

  Future<void> updateRequired4(bool required) async {
    await documentReference.update({"Required 4": required});
  }

  Future<void> updateRequired5(bool required) async {
    await documentReference.update({"Required 5": required});
  }

  Future<void> updateButton1(String title) async {
    await documentReference.update({"Button 1": title});
  }

  Future<void> updateSubtitle1(String title) async {
    await documentReference.update({"Sub Title 1": title});
  }
}
