import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';

import '../../GoogleAPIs/GoogleSpreadSheet.dart';
import '/Components/TimeRelatedFunctions.dart';
import '/DataFields/FolderIDs/FolderIDs.dart';
import '/GoogleAPIs/GoogleDrive.dart';
import '/GoogleAPIs/SwitchyIo.dart';
import '/GoogleAPIs/WhatsAppAPI.dart';

class SpecificPassFollowUpService {
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

  Future<void> updateComment(
    String date,
    String time,
    String id,
    String email,
    String newStatus,
    String newNotes,
    String existingNotes,
  ) async {
    var rows = await GoogleSheets.missingPassReportPage!.values.map.allRows();

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
    await GoogleSheets.missingPassReportPage!.values
        .insertValue(notes, column: 11, row: (rowIndex + 2));

    whatsAppAPI.sendPassCheckingFollowUpReport(date, time, name, newStatus,
        newNotes, id, "No Image for comment Update");
  }

  Future<void> updateRow(
    String date,
    String time,
    String passNumber,
    String email,
    String id,
    String existingNotes,
    List<XFile> passFound,
    String newStatus,
    String newNotes,
    String category,
  ) async {

    if (newStatus == "Completed") {
      if (category == "Contractor") {
        final CollectionReference contractor =
            FirebaseFirestore.instance.collection("ContractorPassList");

        QuerySnapshot querySnapshot = await contractor
            .where('Contractor Pass List', isEqualTo: passNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          await contractor.doc(doc.id).update({'Missing Status': false});
        }
      }
      if (category == "Duty") {
        final CollectionReference duty =
            FirebaseFirestore.instance.collection("DutyPassList");

        QuerySnapshot querySnapshot =
            await duty.where('Duty Pass List', isEqualTo: passNumber).get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          await duty.doc(doc.id).update({'Missing Status': false});
        }
      }
      if (category == "Supplier") {
        final CollectionReference supplier =
            FirebaseFirestore.instance.collection("SupplierPassList");

        QuerySnapshot querySnapshot = await supplier
            .where('Supplier Pass List', isEqualTo: passNumber)
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot doc = querySnapshot.docs.first;
          await supplier.doc(doc.id).update({'Missing Status': false});
        }
      }
    }

    // get the new shorten URL and Google Drive Image
    List<String> googleDriveImages = await googleDrive.getGoogleDriveFilesUrl(
        passFound, await folderIDs.getPassCheckingReportID());
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
    var rows = await GoogleSheets.missingPassReportPage!.values.map.allRows();

    // Find the row index for the specific Report ID
    int rowIndex = rows!.indexWhere((row) => row['Report ID'] == id);

    // Update Google Drive only when status completed
    await GoogleSheets.missingPassReportPage!.values
        .insertValue(list_1, column: 12, row: (rowIndex + 2));

    // Update Shorten URL only when status completed
    await GoogleSheets.missingPassReportPage!.values
        .insertValue(list_2, column: 13, row: (rowIndex + 2));

    await GoogleSheets.missingPassReportPage!.values
        .insertValue(newStatus, column: 9, row: (rowIndex + 2));

    // Update Remarks
    await GoogleSheets.missingPassReportPage!.values
        .insertValue(notes, column: 11, row: (rowIndex + 2));

    whatsAppAPI.sendPassCheckingFollowUpReport(
        date, time, name, newStatus, newNotes, id, list_2);
  }
}
