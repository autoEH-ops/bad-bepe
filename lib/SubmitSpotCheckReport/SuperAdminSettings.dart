import 'package:cloud_firestore/cloud_firestore.dart';

class SpotCheckReportSuperAdminSettings {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Spot Check Report Settings')
      .doc('Spot Check Report Settings');

  Future<void> checkAndCreateDocument() async {
    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        // If the document doesn't exist, create it with the initial field
        await documentReference.set({
          "Title 1": "Spot Check Reporting",
          "Title 2": "Last Spot Check ID : ",
          'Title 3': "Last Spot Check Date : ",
          "Title 4": "Last Spot Check Time : ",
          "Title 5": "Choose Time",
          "Required 5": true,
          "Title 6": "Spot Check Description",
          "Required 6": true,
          "Title 7": "Spot Check Findings",
          "Required 7": true,
          "Title 8": "Remarks for Clients",
          "Required 8": true,
          "Title 9": "Prepared By",
          "Required 9": true,
          "Title 10": "Upload Photo",
          "Required 10": true,
          "Button 1": "Click to Submit",
          "Sub Title 1": "Enter text ... ",
          "Sub Title 2": "Enter text ... ",
          "Sub Title 3": "Enter text ... ",
          "Sub Title 4": "Enter text ... ",
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
          .collection('Spot Check Report Settings')
          .doc('Spot Check Report Settings')
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

  Future<void> updateTitle10(String title) async {
    await documentReference.update({"Title 10": title});
  }

  Future<void> updateRequired5(bool required) async {
    await documentReference.update({"Required 5": required});
  }

  Future<void> updateRequired6(bool required) async {
    await documentReference.update({"Required 6": required});
  }

  Future<void> updateRequired7(bool required) async {
    await documentReference.update({"Required 7": required});
  }

  Future<void> updateRequired8(bool required) async {
    await documentReference.update({"Required 8": required});
  }

  Future<void> updateRequired9(bool required) async {
    await documentReference.update({"Required 9": required});
  }

  Future<void> updateRequired10(bool required) async {
    await documentReference.update({"Required 10": required});
  }

  Future<void> updateButton1(String title) async {
    await documentReference.update({"Button 1": title});
  }

  Future<void> updateSubTitle1(String title) async {
    await documentReference.update({"Sub Title 1": title});
  }

  Future<void> updateSubTitle2(String title) async {
    await documentReference.update({"Sub Title 2": title});
  }

  Future<void> updateSubTitle3(String title) async {
    await documentReference.update({"Sub Title 3": title});
  }

  Future<void> updateSubTitle4(String title) async {
    await documentReference.update({"Sub Title 4": title});
  }
}
