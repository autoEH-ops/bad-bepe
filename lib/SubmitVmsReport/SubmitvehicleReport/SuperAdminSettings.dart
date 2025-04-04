import 'package:cloud_firestore/cloud_firestore.dart';

class vehicleInReportSuperAdminSettings {
  DocumentReference documentReference = FirebaseFirestore.instance
      .collection('Supplier In Settings')
      .doc('Supplier In Settings');

  Future<void> checkAndCreateDocument() async {
    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        // If the document doesn't exist, create it with the initial field
        await documentReference.set({
          "Title 1": "Supplier VMS In Pass",
          "Title 2": "Choose VMS Pass",
          "Sub Title 1": "Select Drop Down",
          "Required 1": true,
          "Title 3": "Choose Supplier",
          "Sub Title 2": "Select Drop Down",
          "Required 2": true,
          "Title 4": "Valid Malaysia Mobile Number",
          "Title 5":
              "Without any valid Malaysia Mobile Number, please register with security directly : Example 0101231231",
          "Sub Title 3": "Enter Text",
          "Required 5": true,
          "Title 6": "IC / Passport Number",
          "Sub Title 4": "Enter Ic / Passport",
          "Required 6": true,
          "Title 7": "Add Vehicle Photo",
          "Required 7": true,
          "Title 8": "Upload Driving License Photo",
          "Required 8": true,
          "Title 9": "Upload Delivery Order Photo",
          "Required 9": true,
          "Title 10": "Upload Delivery Item Photo",
          "Required 10": true,
          "Title 11": "Upload Supplier Permit Photo",
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
          .collection('Supplier In Settings')
          .doc('Supplier In Settings')
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

  Future<void> updateTitle11(String title) async {
    await documentReference.update({"Title 11": title});
  }

  Future<void> updateRequired1(bool required) async {
    await documentReference.update({"Required 1": required});
  }

  Future<void> updateRequired2(bool required) async {
    await documentReference.update({"Required 2": required});
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

  Future<void> updateRequired11(bool required) async {
    await documentReference.update({"Required 11": required});
  }

  Future<void> updateButton1(String title) async {
    await documentReference.update({"Button 1": title});
  }

  Future<void> updateSubtitle1(String title) async {
    await documentReference.update({"Sub Title 1": title});
  }

  Future<void> updateSubtitle2(String title) async {
    await documentReference.update({"Sub Title 2": title});
  }

  Future<void> updateSubtitle3(String title) async {
    await documentReference.update({"Sub Title 3": title});
  }

  Future<void> updateSubtitle4(String title) async {
    await documentReference.update({"Sub Title 4": title});
  }
}
