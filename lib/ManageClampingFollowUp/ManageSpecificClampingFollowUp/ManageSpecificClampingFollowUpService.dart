import 'package:image_picker/image_picker.dart';
import '/Components/TimeRelatedFunctions.dart';
import '/DataFields/FolderIDs/FolderIDs.dart';
import '/GoogleAPIs/GoogleDrive.dart';
import '/GoogleAPIs/SwitchyIo.dart';
import '/GoogleAPIs/WhatsAppAPI.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../GoogleAPIs/GoogleSpreadSheet.dart';

class ManageSpecificClampingFollowUpService {


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

  String? getFileID2(String url) {
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
    var rows = await GoogleSheets.clampingReportPage!.values.map.allRows();

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
    await GoogleSheets.clampingReportPage!.values
        .insertValue(notes, column: 10, row: (rowIndex + 2));
  }

  Future<void> updateRow(
    String carPlate,
    String email,
    String id,
    String existingNotes,
    List<XFile> unclampingPhoto,
    List<XFile> paymentSlip,
    String newStatus,
    String newNotes,
  ) async {
    // get the new shorten URL and Google Drive Image
    List<String> googleDriveImages = await googleDrive.getGoogleDriveFilesUrl(
        unclampingPhoto, await folderIDs.getClampingFolderID());
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

    // ==========================================================================//

    List<String> googleDriveImages2 = await googleDrive.getGoogleDriveFilesUrl(
        unclampingPhoto, await folderIDs.getClampingFolderID());
    List<String> newImagesList2 = List<String>.from(googleDriveImages2);

    for (int i = 0; i < googleDriveImages2.length; i++) {
      newImagesList2[i] =
          "https://lh3.googleusercontent.com/d/${googleDriveImages2[i]}";
    }

    for (int i = 0; i < googleDriveImages2.length; i++) {
      googleDriveImages2[i] =
          "https://drive.google.com/file/d/${googleDriveImages2[i]}/view?usp=sharing";
    }

    List<String> switchIoImages2 = await switchyIo.shortenURLs(newImagesList2);

    String list_3 = googleDriveImages2.join(', ');
    String list_4 = switchIoImages2.join(', ');

    // ==========================================================================//

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

    // First get all the rows
    var rows = await GoogleSheets.clampingReportPage!.values.map.allRows();

    // Find the row index for the specific Report ID
    int rowIndex = rows!.indexWhere((row) => row['Report ID'] == id);

    // Update Google Drive only when status completed
    await GoogleSheets.clampingReportPage!.values
        .insertValue(list_1, column: 15, row: (rowIndex + 2));

    // Update Shorten URL only when status completed
    await GoogleSheets.clampingReportPage!.values
        .insertValue(list_2, column: 16, row: (rowIndex + 2));

    await GoogleSheets.clampingReportPage!.values
        .insertValue(list_3, column: 17, row: (rowIndex + 2));

    // Update Shorten URL only when status completed
    await GoogleSheets.clampingReportPage!.values
        .insertValue(list_4, column: 18, row: (rowIndex + 2));

    await GoogleSheets.clampingReportPage!.values
        .insertValue(newStatus, column: 12, row: (rowIndex + 2));

    // Update Remarks
    await GoogleSheets.clampingReportPage!.values
        .insertValue(notes, column: 10, row: (rowIndex + 2));

    whatsAppAPI.sendClampingFollowUpReport(
        timeRelatedFunction.getCurrentDate(),
        timeRelatedFunction.getCurrentTime(),
        name,
        carPlate,
        newStatus,
        newNotes,
        id,
        list_2,
        list_4);
  }
}
