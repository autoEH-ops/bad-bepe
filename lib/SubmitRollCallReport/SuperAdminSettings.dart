import 'package:cloud_firestore/cloud_firestore.dart';

class RollCallReportSuperAdminSettings {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Roll Call Settings')
      .doc('Roll Call Settings');

  Future<void> checkAndCreateDocument() async {
    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        await documentReference.set({
          "Title 1": "Roll Call Reporting",
          "Title 2": "Next Report For : ",
          'Title 3': "Last Roll Call : ",
          "Title 4": "Lists of Security Personnel",
          "Required 4": true,
          "Title 5": "Upload Photo",
          "Required 5": true,
          "Title 6": "Additional Remarks",
          "Required 6": true,
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
          .collection('Roll Call Settings')
          .doc('Roll Call Settings')
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

  Future<void> updateRequired4(bool required) async {
    await documentReference.update({"Required 4": required});
  }

  Future<void> updateRequired5(bool required) async {
    await documentReference.update({"Required 5": required});
  }

  Future<void> updateRequired6(bool required) async {
    await documentReference.update({"Required 6": required});
  }

  Future<void> updateButton1(String title) async {
    await documentReference.update({"Button 1": title});
  }

  Future<void> updateSubTitle1(String title) async {
    await documentReference.update({"Sub Title 1": title});
  }
}
