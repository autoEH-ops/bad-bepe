import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:gsheets/gsheets.dart';
import '../GoogleAPIs/GoogleDrive.dart';
import '../GoogleAPIs/GoogleSpreadSheet.dart';

/// Enum representing different types of passes.
enum PassType {
  Contractor,
  Duty,
  Supplier,
  Drive,
  Guest,
}

/// Service class for QR Code Approval and Management.
class QrCodeApprovalService {
  final GoogleSheets googleSheetsApi = GoogleSheets();
  final GoogleDrive googleDriveApi = GoogleDrive();

  /// Mapping between PassType and their corresponding Worksheet references.
  final Map<PassType, Worksheet?> passTypeSheetsMap = {
    PassType.Contractor: GoogleSheets.contractorPassPage,
    PassType.Duty: GoogleSheets.dutyPassList,
    PassType.Supplier: GoogleSheets.supplierPassList,
    PassType.Drive: GoogleSheets.GuestDrivelist,
    PassType.Guest: GoogleSheets.GuestPasslist,
  };

  /// Ensures that all necessary Google Sheets are connected.
  Future<void> ensureSheetsConnected() async {
    print("Checking if Google Sheets are connected...");

    bool connected = await GoogleSheets.connectToReportList();
    if (connected) {
      print("Connected to Google Sheets.");
    } else {
      print("Failed to connect to Google Sheets.");
      return;
    }

    // Print headers for debugging
    final qrReportRows = await GoogleSheets.qrReportPage?.values.allRows();
    if (qrReportRows != null && qrReportRows.isNotEmpty) {
      print("QR Code Data Sheet Headers: ${qrReportRows[0]}");
    } else {
      print("QR Code Data Sheet is empty. No headers found.");
    }

    // Verify all pass sheets
    for (var entry in passTypeSheetsMap.entries) {
      final passType = entry.key;
      final sheet = entry.value;
      if (sheet != null) {
        final passRows = await sheet.values.allRows();
        if (passRows != null && passRows.isNotEmpty) {
          print("${_passTypeToString(passType)} Pass Sheet Headers: ${passRows[0]}");
        } else {
          print("${_passTypeToString(passType)} Pass Sheet is empty. No headers found.");
        }
      } else {
        print("No Google Sheets reference found for ${_passTypeToString(passType)} Pass.");
      }
    }
  }

  /// Retrieves QR code details based on the provided ID using improved header-based mapping.
  Future<Map<String, dynamic>> getQrCodeDetails(String ID) async {
    await ensureSheetsConnected();
    print("Fetching QR code details for ID: $ID");

    final rows = await GoogleSheets.qrReportPage?.values.allRows();

    if (rows == null || rows.isEmpty) {
      print("QR Code Data Sheet is empty. No data found.");
      return {};
    }

    // Normalize headers: trim and convert to lowercase
    final headers = rows[0]
        .map((header) => header.toString().trim().toLowerCase())
        .toList();

    // Find the row matching the provided ID
    final dataRow = rows.firstWhere(
          (row) =>
      row.isNotEmpty &&
          row[0].toString().trim().toLowerCase() == ID.trim().toLowerCase(),
      orElse: () => [],
    );

    if (dataRow.isEmpty) {
      print("No matching QR code found for ID: $ID");
      return {};
    }

    // Debugging: Print headers and dataRow
    print("Headers: $headers");
    print("Data Row: $dataRow");

    // Pad dataRow with empty strings if it's shorter than headers
    List<String> paddedDataRow =
    List<String>.from(dataRow.map((e) => e.toString()));
    while (paddedDataRow.length < headers.length) {
      paddedDataRow.add('');
    }

    print("Padded Data Row: $paddedDataRow");

    // Helper function to get value by header name (case-insensitive)
    String getValue(String header) {
      final normalizedHeader = header.toLowerCase().trim();
      final index = headers.indexOf(normalizedHeader);
      if (index != -1 && index < paddedDataRow.length) {
        final value = paddedDataRow[index];
        if (value.isNotEmpty) {
          return value.trim();
        }
      }
      return 'N/A';
    }

    print("Matching QR code found: $dataRow");

    return {
      'ID': getValue('ID'),
      'Names': getValue('Names'),
      'Ic Number': getValue('Ic Number'),
      'Car Plate': getValue('Car Plate'),
      'Phone Number': getValue('Phone Number'),
      'Start Date': getValue('Start Date'),
      'End Date': getValue('End Date'),
      'Status': getValue('Status'),
      'Records': getValue('Records'),
      'VMSRecords': getValue('VMSRecords'),
      'Timestamp': getValue('Timestamp'),
      'Qr Attachments': getValue('Qr Attachments'),
      'Shortened URL': getValue('Shortened URL'),
      'passType': getValue('passType'),
      'passId': getValue('passId'),
      'passimage': getValue('passimage'),
      'Remarks': getValue('Remarks'),
      'email': getValue('email'),
      'status2': getValue('status2'),
      'category': getValue('category'),
    };
  }

  /// Retrieves the pass list based on pass type.
  Future<List<Map<String, String?>>> getPassList(PassType passType) async {
    return await fetchPassList(passType);
  }

  /// Generic fetch method to retrieve pass lists based on PassType.
  Future<List<Map<String, String?>>> fetchPassList(PassType passType) async {
    await ensureSheetsConnected();
    final sheet = passTypeSheetsMap[passType];
    if (sheet == null) {
      print('No Google Sheets reference found for pass type: $passType');
      return [];
    }

    final rows = await sheet.values.allRows();

    if (rows == null || rows.isEmpty) {
      print('No data found in sheet for PassType: ${_passTypeToString(passType)}');
      return [];
    }

    // Assuming first row is header
    List<Map<String, String?>> passList = rows.skip(1).map((row) {
      String passName = row.length > 0 ? row[0].toString().trim() : '';
      String passStatus = row.length > 1 ? row[1].toString().trim() : '';

      // Debug: Print each pass entry
      print('Fetched Pass: Name="$passName", Status="$passStatus"');

      return {
        'pass': passName.isNotEmpty ? passName : null,
        'status': passStatus.isNotEmpty ? passStatus : null,
      };
    }).toList();

    // Remove any entries with null 'pass' to prevent invalid dropdown items
    passList = passList.where((pass) => pass['pass'] != null).toList();

    print('Final Pass List for ${_passTypeToString(passType)}: $passList');

    return passList;
  }

  /// Updates the QR code details in Google Sheets.
  Future<void> updateQR(
      String ID,
      String status,
      String passType,
      String passId,
      String guestPassName,
      XFile? attachmentImage,
      String remarks,
      ) async {
    await ensureSheetsConnected();



    String? attachmentImageUrl;
    if (attachmentImage != null) {
      try {
        List<String> imageIds = await googleDriveApi.getGoogleDriveFilesUrl(
          [attachmentImage],
          '1_QhWuwCwcvcHmv9IUReX5s_4SbpKkKd4', // Replace with your actual folder ID
        );
        List<String> imageUrls =
        imageIds.map((id) => "https://drive.google.com/uc?id=$id").toList();
        attachmentImageUrl = imageUrls.isNotEmpty ? imageUrls.first : null;
        print('Attachment uploaded to: $attachmentImageUrl');
      } catch (e) {
        print('Error uploading image: $e');
        return; // Early return since image upload failed
      }
    }

    final rows = await GoogleSheets.qrReportPage?.values.allRows();
    if (rows == null || rows.isEmpty) {
      print('QR Code Data Sheet is empty, no data found.');
      return;
    }

    final headers = rows[0];
    int rowIndex = -1;

    for (int i = 1; i < rows.length; i++) {
      final row = rows[i];
      if (row.isNotEmpty &&
          row[0].toString().trim().toLowerCase() == ID.trim().toLowerCase()) {
        rowIndex = i + 1; // Google Sheets rows are 1-based
        break;
      }
    }

    if (rowIndex == -1) {
      print('No matching ID found for update.');
      return;
    }

    try {
      // Helper function for case-insensitive header matching
      int getColumnIndex(String columnName, List<dynamic> headers) {
        return headers.indexWhere(
                (header) =>
            header.toString().trim().toLowerCase() ==
                columnName.toLowerCase()) +
            1; // Convert to 1-based index
      }

      // Retrieve column indexes for QR Code Data sheet
      final statusIndex = getColumnIndex('Status', headers);
      final recordsIndex = getColumnIndex('Records', headers);
      final vmsRecordsIndex = getColumnIndex('VMSRecords', headers);
      final passTypeIndex = getColumnIndex('passType', headers);
      final passIdIndex = getColumnIndex('passId', headers);
      final attachmentIndex = getColumnIndex('passimage', headers);
      final remarksIndex = getColumnIndex('Remarks', headers);
      final namesIndex = getColumnIndex('Names', headers); // Ensure 'Names' column exists

      // Check if any required columns are missing
      List<String> missingColumns = [];
      if (statusIndex == 0) missingColumns.add('Status');
      if (recordsIndex == 0) missingColumns.add('Records');
      if (vmsRecordsIndex == 0) missingColumns.add('VMSRecords');
      if (passTypeIndex == 0) missingColumns.add('passType');
      if (passIdIndex == 0) missingColumns.add('passId');
      if (attachmentIndex == 0) missingColumns.add('passimage');
      if (remarksIndex == 0) missingColumns.add('Remarks');
      if (namesIndex == 0) missingColumns.add('Names');

      if (missingColumns.isNotEmpty) {
        print(
            'One or more required columns are missing in QR Code Data sheet: ${missingColumns.join(', ')}');
        return;
      }

      // Safeguard against row length variations
      List<dynamic> currentRow = rows[rowIndex - 1];
      String recordHistory = (currentRow.length >= recordsIndex)
          ? (currentRow[recordsIndex - 1] ?? '')
          : '';
      String vmsRecord = (currentRow.length >= vmsRecordsIndex)
          ? (currentRow[vmsRecordsIndex - 1] ?? '')
          : '';

      DateTime currentDate = DateTime.now();
      String formattedDate = DateFormat('dd/MM/yyyy').format(currentDate);
      String formattedTime = DateFormat('HH:mm:ss').format(currentDate);
      String updatedRecordHistory =
          "$recordHistory\nStatus set to $status at $formattedTime on $formattedDate (Pass Type: $passType, Pass ID: $passId)";
      String updatedVmsRecord =
          "$vmsRecord\nVMS $status at $formattedTime on $formattedDate";

      String currentAttachment = (currentRow.length >= attachmentIndex)
          ? (currentRow[attachmentIndex - 1] ?? '')
          : '';
      String updatedAttachmentUrl = currentAttachment;
      if (attachmentImageUrl != null) {
        String tag = status.toLowerCase().contains('in') ? "Pass In: " : "Pass Out: ";
        String newUrl = "$tag$attachmentImageUrl";
        updatedAttachmentUrl =
        currentAttachment.isNotEmpty ? "$currentAttachment, $newUrl" : newUrl;
      }

      // Update values in QR Code Data sheet
      await GoogleSheets.qrReportPage!.values.insertValue(
          status, column: statusIndex, row: rowIndex);
      await GoogleSheets.qrReportPage!.values.insertValue(
          updatedRecordHistory, column: recordsIndex, row: rowIndex);
      await GoogleSheets.qrReportPage!.values.insertValue(
          updatedVmsRecord, column: vmsRecordsIndex, row: rowIndex);
      await GoogleSheets.qrReportPage!.values.insertValue(
          passType, column: passTypeIndex, row: rowIndex);
      await GoogleSheets.qrReportPage!.values.insertValue(
          passId, column: passIdIndex, row: rowIndex);
      await GoogleSheets.qrReportPage!.values.insertValue(
          updatedAttachmentUrl, column: attachmentIndex, row: rowIndex);
      await GoogleSheets.qrReportPage!.values.insertValue(
          remarks, column: remarksIndex, row: rowIndex);

      print('Successfully updated row $rowIndex in QR Code Data sheet.');

      // Now, update the status in the corresponding Pass sheet using the provided passType and guestPassName
      if (guestPassName.isEmpty) {
        print('Pass name is empty for ID: $ID. Cannot update Pass sheet.');
        return;
      }

      bool passUpdated = await updatePassStatus(passType, guestPassName, status);
      if (passUpdated) {
        print(
            'Successfully updated status in ${_passTypeToString(_stringToPassType(passType) ?? PassType.Guest)} Pass sheet for Pass: $guestPassName');
      } else {
        print(
            'Failed to update status in ${_passTypeToString(_stringToPassType(passType) ?? PassType.Guest)} Pass sheet for Pass: $guestPassName');
      }
    } catch (e, stackTrace) {
      print('Error updating Google Sheets: $e');
      print('Stack Trace: $stackTrace');
    }
  }

  /// Updates the Status of a Pass in the corresponding Pass sheet.
  Future<bool> updatePassStatus(String passType, String passName, String status) async {
    try {
      PassType? passTypeEnum = _stringToPassType(passType);
      if (passTypeEnum == null) {
        print('Invalid pass type: $passType');
        return false;
      }

      final sheet = passTypeSheetsMap[passTypeEnum];
      if (sheet == null) {
        print('No Google Sheets reference found for pass type: $passType');
        return false;
      }

      final passRows = await sheet.values.allRows();
      if (passRows == null || passRows.isEmpty) {
        print('${_passTypeToString(passTypeEnum)} Pass sheet is empty.');
        return false;
      }

      final headers = passRows[0];
      int getColumnIndex(String columnName) {
        return headers.indexWhere(
                (header) =>
            header.toString().trim().toLowerCase() ==
                columnName.toLowerCase()) +
            1; // 1-based index
      }

      final passColumnIndex = getColumnIndex('pass');
      final statusColumnIndex = getColumnIndex('status');

      if (passColumnIndex == 0 || statusColumnIndex == 0) {
        print('Required columns are missing in ${_passTypeToString(passTypeEnum)} Pass sheet.');
        return false;
      }

      int passRowIndex = -1;
      for (int i = 1; i < passRows.length; i++) {
        final row = passRows[i];
        String sheetPassName = row[passColumnIndex - 1].toString().trim().toLowerCase();
        String inputPassName = passName.trim().toLowerCase();
        if (sheetPassName == inputPassName) {
          passRowIndex = i + 1; // 1-based indexing
          break;
        }
      }

      if (passRowIndex == -1) {
        print('Pass "$passName" not found in ${_passTypeToString(passTypeEnum)} Pass sheet.');
        return false;
      }

      // Update the Status cell
      await sheet.values.insertValue(
          status, column: statusColumnIndex, row: passRowIndex);

      print('Updated ${_passTypeToString(passTypeEnum)} Pass "$passName" with status "$status".');
      return true;
    } catch (e, stackTrace) {
      print('Error updating ${passType} Pass sheet: $e');
      print('Stack Trace: $stackTrace');
      return false;
    }
  }

  /// Fetch methods for each pass type.
  Future<List<Map<String, String?>>> fetchContractorPassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.contractorPassPage?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchDutyPassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.dutyPassList?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchSupplierPassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.supplierPassList?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchDrivePassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.GuestDrivelist?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  Future<List<Map<String, String?>>> fetchGuestPassList() async {
    await ensureSheetsConnected();
    final rows = await GoogleSheets.GuestPasslist?.values.allRows();

    if (rows == null || rows.isEmpty) {
      return [];
    }

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : null,
      };
    }).toList();
  }

  /// Converts PassType enum to string.
  String _passTypeToString(PassType passType) {
    switch (passType) {
      case PassType.Contractor:
        return 'Contractor';
      case PassType.Duty:
        return 'Duty';
      case PassType.Supplier:
        return 'Supplier';
      case PassType.Drive:
        return 'Drive';
      case PassType.Guest:
        return 'Guest';
      default:
        return 'Unknown';
    }
  }

  /// Converts string to PassType enum.
  PassType? _stringToPassType(String passTypeStr) {
    switch (passTypeStr.toLowerCase()) {
      case 'contractor':
        return PassType.Contractor;
      case 'duty':
        return PassType.Duty;
      case 'supplier':
        return PassType.Supplier;
      case 'drive':
        return PassType.Drive;
      case 'guest':
        return PassType.Guest;
      default:
        return null;
    }
  }
}
