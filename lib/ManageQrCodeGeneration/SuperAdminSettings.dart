/*

import '../GoogleAPIs/GoogleSpreadSheet.dart';

class QRReportSuperAdminSettings {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  Future<void> checkAndCreateDocument() async {
    try {
      Future<void> ensureSheetsConnected() async {
        if (GoogleSheets.qrReportPage == null) {
          await GoogleSheets.connectToSpreadsheets();

      if (!connectToSpreadsheets.exists) {
        // If the document doesn't exist, create it with the initial field
        await qrReportPage.set({
          "Title 1": "Enter Full Name (Follow IC / Passport)",
          "Sub Title 1": "Enter Name",
          "Title 2": "Enter IC / Passport Number",
          "Sub Title 2": "Enter IC / Passport",
          "Title 3": "Enter Car Plate Number",
          "Sub Title 3": "Enter Car Plate",
          "Required 3": true,
          "Title 4": "Enter Phone Number",
          "Sub Title 4": "Mobile Number",
          "Required 4": true,
          "Title 5": "Select Date (Start & End)",
          "Sub Title 5": "Start Date",
          "Button 1": "Generate QR VMS Pass",
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
          .collection('QR Out Settings')
          .doc('QR Out Settings')
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

  Future<void> updateRequired6(bool required) async {
    await documentReference.update({"Required 6": required});
  }

  Future<void> updateRequired7(bool required) async {
    await documentReference.update({"Required 7": required});
  }

  Future<void> updateRequired8(bool required) async {
    await documentReference.update({"Required 8": required});
  }

  Future<void> updateButton1(String title) async {
    await documentReference.update({"Button 1": title});
  }

  Future<void> updateSubtitle1(String title) async {
    await documentReference.update({"Sub Title 1": title});
  }
}
*/
