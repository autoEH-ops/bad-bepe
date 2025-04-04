import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '/Components/TimeRelatedFunctions.dart';
import '/DataFields/FolderIDs/FolderIDs.dart';
import '/GoogleAPIs/GoogleDrive.dart';
import '/GoogleAPIs/SwitchyIo.dart';
import '/GoogleAPIs/WhatsAppAPI.dart';
import '../../GoogleAPIs/GoogleSpreadSheet.dart';

class SpecificEmergencyFollowUpService {
  GoogleDrive googleDrive = GoogleDrive();
  FolderIDs folderIDs = FolderIDs();
  SwitchyIo switchyIo = SwitchyIo();
  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();
  WhatsAppAPI whatsAppAPI = WhatsAppAPI();

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

  // get Image NetWork URL
  List<String> extractFileIDs(String files) {
    List<String> urls = files.split(', ');
    List<String> fileIDs = [];

    for (String url in urls) {
      String? fileID = getFileID(url);
      if (fileID != null) {
        fileIDs.add('https://lh3.googleusercontent.com/d/$fileID');
      }
    }
    return fileIDs;
  }

  String? getFileID(String url) {
    RegExp regExp = RegExp(r'/d/(.*?)/');
    RegExpMatch? match = regExp.firstMatch(url);
    if (match != null) {
      return match.group(1);
    }
    return null;
  }

  Future<void> updateComment(
    String id,
    String email,
    String newNotes,
    String existingNotes,
  ) async {
    var rows = await GoogleSheets.emergencyReportPage!.values.map.allRows();

    // Find the row index for the specific Report ID
    int rowIndex = rows!.indexWhere((row) => row['Report ID'] == id);

    String name = await getName(email);

    String notes = "";
    String addNotes =
        "$name '${timeRelatedFunction.getCurrentDate()} '${timeRelatedFunction.getCurrentTime()} $newNotes";
    // merge existing notes
    if (existingNotes.isEmpty) {
      notes = "$addNotes\n";
    } else {
      notes = "$existingNotes$addNotes\n";
    }

    // Update Remarks
    await GoogleSheets.emergencyReportPage!.values
        .insertValue(notes, column: 13, row: (rowIndex + 2));
  }

  Future<bool> updateRow(
    String email,
    String id,
    String existingSupportingFiles,
    String existingNotes,
    String existingShortenUrl,
    List<XFile> newImages,
    String newStatus,
    String newNotes,
  ) async {
    try {
      // get the new shorten URL and Google Drive Image
      List<String> googleDriveImages = await googleDrive.getGoogleDriveFilesUrl(
          newImages, await folderIDs.getEmergencyReportID());
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
      String list_2 = switchIoImages.join(', ');

      // merge with existing google drive links and shorten links
      String newList_1 = "$existingSupportingFiles, $list_1";
      String newList_2 = "$existingShortenUrl, $list_2";

      String name = await getName(email);

      String notes = "";
      String addNotes =
          "$name ${timeRelatedFunction.getCurrentDate()} ${timeRelatedFunction.getCurrentTime()} $newNotes";

      // merge existing notes
      if (existingNotes.isEmpty) {
        notes = "$addNotes\n";
      } else {
        notes = "$existingNotes$addNotes\n";
      }

      // First get all the rows
      var rows = await GoogleSheets.emergencyReportPage!.values.map.allRows();

      // Find the row index for the specific Report ID
      int rowIndex = rows!.indexWhere((row) => row['Report ID'] == id);

      // update google drive images
      await GoogleSheets.emergencyReportPage!.values
          .insertValue(newList_1, column: 12, row: (rowIndex + 2));

      // update shorten url
      await GoogleSheets.emergencyReportPage!.values
          .insertValue(newList_2, column: 18, row: (rowIndex + 2));

      // update new notes
      await GoogleSheets.emergencyReportPage!.values
          .insertValue(notes, column: 13, row: (rowIndex + 2));

      // update status
      await GoogleSheets.emergencyReportPage!.values
          .insertValue(newStatus, column: 16, row: (rowIndex + 2));

      await whatsAppAPI.sendEmergencyFollowUpReport(
          timeRelatedFunction.getCurrentDate(),
          timeRelatedFunction.getCurrentTime(),
          name,
          newStatus,
          newNotes,
          id,
          newList_2);

      return true; // Operation successful
    } catch (e) {
      // Log the error to the error page
      return false; // Operation failed
    }
  }
}
