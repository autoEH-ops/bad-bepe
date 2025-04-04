import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../Components/TimeRelatedFunctions.dart';
import '../DataFields/FolderIDs/FolderIDs.dart';
import '../GoogleAPIs/GoogleDrive.dart';
import '../GoogleAPIs/GoogleSpreadSheet.dart';
import '../GoogleAPIs/SwitchyIo.dart';
import '../GoogleAPIs/WhatsAppAPI.dart';
import '../ManageShutter/ManageShutterService.dart';

class ShutterReportService {
  ManageShutterService manageShutterService = ManageShutterService();
  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();
  GoogleDrive googleDrive = GoogleDrive();
  FolderIDs folderIDs = FolderIDs();
  SwitchyIo switchyIo = SwitchyIo();
  WhatsAppAPI whatsAppAPI = WhatsAppAPI();

  Future<void> checkAndCreateDocument() async {
    String collectionId = 'Shutter Report'; // Replace with your collection ID
    String documentId = 'Shutter Report';
    String fieldId = 'ID';

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection(collectionId).doc(documentId);

    List<String> lists = await manageShutterService.getAllShutter();

    try {
      // Get the document snapshot
      DocumentSnapshot documentSnapshot = await documentReference.get();

      if (!documentSnapshot.exists) {
        // If the document doesn't exist, create it with the initial field
        await documentReference.set({
          fieldId: 1,
          "Next Shutter": lists[0],
          "Status": "Open",
          "Previous Shutter": "",
          "Prev Shutter Date": "",
          "Prev Shutter Time": ""
        });
      } else {}
    } catch (e) {
      print('Error checking or creating document: $e');
    }
  }

  Future<int> getID() async {
    try {
      // Get the document
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Shutter Report')
          .doc('Shutter Report')
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

  Future<void> updateID(
      int newID, String shutter, String prevDate, String prevTime) async {
    try {
      // Get a reference to the document
      DocumentReference document = FirebaseFirestore.instance
          .collection('Shutter Report')
          .doc('Shutter Report');

      // Update the 'ID' field with the new value
      await document.update({
        'ID': newID + 1,
        "Previous Shutter": shutter,
        "Prev Shutter Date": prevDate,
        "Prev Shutter Time": prevTime
      });
    } catch (e) {
      print('Exception: $e');
    }
  }

  Future<Map<String, dynamic>> getLastRow() async {
    try {
      // Get the document
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Shutter Report')
          .doc('Shutter Report')
          .get();

      // Get the data
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      // Check if the 'ID' field exists and is an integer
      if (data != null) {
        // If the 'ID' field exists and is an integer, increment it by 1
        return data;
      } else {
        // If the 'ID' field does not exist or is not an integer, return 1
        return {};
      }
    } catch (e) {
      print('Exception: $e');
      // Return 1 in case of any error
      return {};
    }
  }

  Future<String> getCurrentShutter() async {
    try {
      List<String> lists = await manageShutterService.getAllShutter();
      // Get the document
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Shutter Report')
          .doc('Shutter Report')
          .get();

      // Get the data
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      // Check if the 'ID' field exists and is an integer
      if (data != null) {
        // If the 'ID' field exists and is an integer, increment it by 1
        return data['Next Shutter'];
      } else {
        // If the 'ID' field does not exist or is not an integer, return 1
        return lists[0];
      }
    } catch (e) {
      print('Exception: $e');
      // Return 1 in case of any error
      return "";
    }
  }

  Future<String> getCurrentShutterStatus() async {
    try {
      // Get the document
      DocumentSnapshot document = await FirebaseFirestore.instance
          .collection('Shutter Report')
          .doc('Shutter Report')
          .get();

      // Get the data
      Map<String, dynamic>? data = document.data() as Map<String, dynamic>?;

      // Check if the 'ID' field exists and is an integer
      if (data!["Status"] == null) {
        // If the 'ID' field exists and is an integer, increment it by 1
        return "Open";
      } else {
        // If the 'ID' field does not exist or is not an integer, return 1
        return data["Status"];
      }
    } catch (e) {
      print('Exception: $e');
      // Return 1 in case of any error
      return "";
    }
  }

  Future<List<String>> getShutterLists() async {
    List<String> lists = await manageShutterService.getAllShutter();
    return lists;
  }

  // update shutter status
  Future<void> updateCurrentShutter(
      String currentShutter, String status) async {
    DocumentReference document = FirebaseFirestore.instance
        .collection('Shutter Report')
        .doc('Shutter Report');

    List<String> lists = await manageShutterService.getAllShutter();
    int currentIndex = lists.indexOf(currentShutter);
    if (currentIndex == -1) {
      await document.update({
        "Next Shutter": lists[0],
      });
      await document.update({
        "Status": status,
      });
    } else if (currentIndex == lists.length - 1) {
      // If the current rounding point is the last item in the list, return the first item
      await document.update({
        "Next Shutter": lists[0],
      });
      await openOrClose(status);
    } else {
      await document.update({
        "Next Shutter": lists[currentIndex + 1],
      });
      await document.update({
        "Status": status,
      });
    }
  }

  // update current shutter status
  Future<void> openOrClose(String status) async {
    DocumentReference document = FirebaseFirestore.instance
        .collection('Shutter Report')
        .doc('Shutter Report');

    if (status == "Open") {
      await document.update({'Status': "Close"});
    } else if (status == "Close") {
      await document.update({'Status': "Open"});
    }
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

  Future<bool> addShutterReport(String email, String currentShutter,
      String currentStatus, List<XFile> images, String remarks) async {
    try {
      List<String> googleDriveImages = await googleDrive.getGoogleDriveFilesUrl(
          images, await folderIDs.getShutterReportID());
      List<String> newImagesList = List<String>.from(googleDriveImages);

      for (int i = 0; i < googleDriveImages.length; i++) {
        newImagesList[i] =
            "https://lh3.googleusercontent.com/d/${googleDriveImages[i]}";
      }

      for (int i = 0; i < googleDriveImages.length; i++) {
        googleDriveImages[i] =
            "https://drive.google.com/file/d/${googleDriveImages[i]}/view?usp=sharing";
      }

      List<String> switchIoImages = await switchyIo.shortenURLs(newImagesList);

      String list_1 = googleDriveImages.join(', ');
      String list_2 = googleDriveImages.join(', ');
      String list_22 = switchIoImages.join(', ');

      int id = await getID();
      String name = await getName(email);

      // If there are no rows, simply append the new report
      await GoogleSheets.shutterReportPage!.values.map.appendRow({
        'Frontly ID': id,
        'Date': "'${timeRelatedFunction.getCurrentDate()}",
        'Time': "'${timeRelatedFunction.getCurrentTime()}",
        "Type of Report": "Shutter Report",
        "Email Respondent": email,
        "Name of Respondent": name,
        "Open or Close": currentStatus,
        "Shutter": currentShutter,
        "Shutter Report Supporting Files": list_1,
        "Remarks": remarks,
        "Report ID": "SHUT-$id",
        "Shutter Report Shortened URL": list_2,
      });
      await updateID(id, currentShutter, timeRelatedFunction.getCurrentDate(),
          timeRelatedFunction.getCurrentTime());

      await updateCurrentShutter(currentShutter, currentStatus);

      await whatsAppAPI.sendShutterReport(
          timeRelatedFunction.getCurrentDate(),
          timeRelatedFunction.getCurrentTime(),
          name,
          currentShutter,
          currentStatus,
          remarks,
          "SHUT-$id",
          list_2);

      // If everything is successful, return true
      return true;
    } catch (e) {
      return false;
    }
  }
}
