import 'dart:convert';

import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class GoogleSheets {
  // Spreadsheet IDs for different sets of data
  static const String accountDetailsSpreadsheetID =
      '1JlYVQyRRH2XGVRNFpgPSsKhg6UTg7MGjhmC7cNPf3K0'; //each one with a sheet
  static const String reportListSpreadsheetID =
      '1m__36YjXYfyJNUpmmcXGR9fAldEdEBLqTiGLmbN55_E';
  static const String dataListSpreadsheetID =
      '1JwVFyzsXhf_VX1vDDi5N2v5QfP_tgajd0lDv8-G6a0M';

  static const credentials = r'''
   
  ''';
  // GSheets instances for each spreadsheet
  static final gsheetsAccountDetails = GSheets(credentials);
  static final gsheetsReportList = GSheets(credentials);
  static final gsheetsDataList = GSheets(credentials);

  // Worksheet variables for PB Account Details
  static Worksheet? accountsPage;
  static Worksheet? loginHistoryPage;
  static Worksheet? adminsPage;
  static Worksheet? superAdminsPage;
  static Worksheet? securityPage;
  static Worksheet? pendingPage;
  static Worksheet? settingpage;

  // Worksheet variables for PB Report List
  static Worksheet? hourlyPostUpdateReportPage;
  static Worksheet? rollCallReportPage;
  static Worksheet? roundingReportPage;
  static Worksheet? emergencyReportPage;
  static Worksheet? spotCheckReportPage;
  static Worksheet? vmsContractorReportPage;
  static Worksheet? vmsSupplierReportPage;
  static Worksheet? vmsDutyReportPage;
  static Worksheet? GuestDrivereport;
  static Worksheet? LOGPAGE;
  static Worksheet? qrReportPage;
  static Worksheet? ManagekeyReportPage;
  static Worksheet? mainGateReportPage;
  static Worksheet? clampingReportPage;
  static Worksheet? missingPassReportPage;
  static Worksheet? shutterReportPage;

  // Worksheet variables for PB Data List
  static Worksheet? securityPersonnelNameListPage;
  static Worksheet? securityNameListPage;
  static Worksheet? supplierPageListPage;
  static Worksheet? dutyPassList;
  static Worksheet? contractorPassPage;
  static Worksheet? contractorPassList;
  static Worksheet? supplierPassList;
  static Worksheet? GuestPasslist;
  static Worksheet? GuestDrivelist;
  static Worksheet? roundingPointPage;
  static Worksheet? nextRoundingPage;
  static Worksheet? gatePostLocationPage;
  static Worksheet? Manageaddkey;
  static Worksheet? drivePasslist;
  static Worksheet? emergencyLocationPage;
  static Worksheet? shutterPage;
  static Worksheet? shutterStatusPage;
  static Worksheet? nextShutterPage;
  static Worksheet? electricPanelPage;
  static Worksheet? electricPanelStatusPage;
  static Worksheet? nextElectricPanelPage;
  static Worksheet? glassDoorPage;
  static Worksheet? glassSlidingDoorStatusPage;
  static Worksheet? nextGlassSlidingDoorPage;
  static Worksheet? mainGatePage;
  static Worksheet? mainGateStatusPage;
  static Worksheet? nextMainGatePage;

  // Connect to PB Account Details Spreadsheet
  static Future<bool> connectToAccountDetails() async {
    try {
      final spreadsheet =
          await gsheetsAccountDetails.spreadsheet(accountDetailsSpreadsheetID);
      accountsPage = await getWorkSheets(spreadsheet, title: 'Accounts');
      loginHistoryPage =
          await getWorkSheets(spreadsheet, title: 'Login History');
      adminsPage = await getWorkSheets(spreadsheet, title: 'Admins');
      superAdminsPage = await getWorkSheets(spreadsheet, title: 'Super Admins');
      securityPage = await getWorkSheets(spreadsheet, title: 'Security');
      pendingPage = await getWorkSheets(spreadsheet, title: 'Pending Accounts');
      settingpage = await getWorkSheets(spreadsheet, title: 'setting page');
      return true;
    } catch (e) {
      print("Error connecting to PB Account Details: $e");
      return false;
    }
  }

  // Connect to PB Report List Spreadsheet
  static Future<bool> connectToReportList() async {
    try {
      final spreadsheet =
          await gsheetsReportList.spreadsheet(reportListSpreadsheetID);
      hourlyPostUpdateReportPage =
          await getWorkSheets(spreadsheet, title: 'hourlyPost Report');
      rollCallReportPage =
          await getWorkSheets(spreadsheet, title: 'rollCall Report');
      roundingReportPage =
          await getWorkSheets(spreadsheet, title: 'rounding Report');
      emergencyReportPage =
          await getWorkSheets(spreadsheet, title: 'Emergency Report');
      spotCheckReportPage =
          await getWorkSheets(spreadsheet, title: 'Spot Report');
      vmsContractorReportPage =
          await getWorkSheets(spreadsheet, title: 'Contractor Report');
      vmsSupplierReportPage =
          await getWorkSheets(spreadsheet, title: 'Supplier Report');
      vmsDutyReportPage =
          await getWorkSheets(spreadsheet, title: 'vmsDuty Report');
      LOGPAGE = await getWorkSheets(spreadsheet, title: 'LOG');
      GuestDrivereport =
          await getWorkSheets(spreadsheet, title: 'Drive Report');
      qrReportPage = await getWorkSheets(spreadsheet, title: 'QR Code Data');
      ManagekeyReportPage =
          await getWorkSheets(spreadsheet, title: 'Key Report');
      mainGateReportPage =
          await getWorkSheets(spreadsheet, title: 'mainGate Report');
      return true;
    } catch (e) {
      print("Error connecting to PB Report List: $e");
      return false;
    }
  }

  // Connect to PB Data List Spreadsheet
  static Future<bool> connectToDataList() async {
    try {
      final spreadsheet =
          await gsheetsDataList.spreadsheet(dataListSpreadsheetID);
      securityPersonnelNameListPage =
          await getWorkSheets(spreadsheet, title: "Security Name List");
      supplierPageListPage =
          await getWorkSheets(spreadsheet, title: 'Supplier List');
      dutyPassList = await getWorkSheets(spreadsheet, title: 'Duty Pass');
      contractorPassPage =
          await getWorkSheets(spreadsheet, title: 'Contractor Pass');
      supplierPassList =
          await getWorkSheets(spreadsheet, title: "Supplier Pass");
      GuestPasslist = await getWorkSheets(spreadsheet, title: 'Guest Pass');
      drivePasslist = await getWorkSheets(spreadsheet, title: 'Drive Pass');
      roundingPointPage =
          await getWorkSheets(spreadsheet, title: 'Rounding Point');
      nextRoundingPage =
          await getWorkSheets(spreadsheet, title: "Rounding Point");
      gatePostLocationPage =
          await getWorkSheets(spreadsheet, title: 'Hourly Gate Post Location');
      Manageaddkey = await getWorkSheets(spreadsheet, title: 'Manage Key');
      emergencyLocationPage =
          await getWorkSheets(spreadsheet, title: 'Emergency Locations');
      return true;
    } catch (e) {
      print("Error connecting to PB Data List: $e");
      return false;
    }
  }

  static Future<Worksheet> getWorkSheets(Spreadsheet spreadsheet,
      {required String title}) async {
    return spreadsheet.worksheetByTitle(title)!;
  }

  static Future<List<Map<String, String>>> getDutyPassList() async {
    if (dutyPassList == null) await connectToDataList();
    final rows = await dutyPassList?.values.allRows();
    if (rows == null || rows.isEmpty) return [];

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : '',
      };
    }).toList();
  }

  static Future<List<Map<String, String>>> getSupplierPassList() async {
    if (supplierPassList == null) await connectToDataList();
    final rows = await supplierPassList?.values.allRows();
    if (rows == null || rows.isEmpty) return [];

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : '',
      };
    }).toList();
  }

  static Future<List<Map<String, String>>> getContractorPassList() async {
    if (contractorPassPage == null) await connectToDataList();
    final rows = await contractorPassPage?.values.allRows();
    if (rows == null || rows.isEmpty) return [];

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : '',
      };
    }).toList();
  }

  Future<List<List<String>>> getAvailableContractorPassList() async {
    if (vmsContractorReportPage == null) await connectToReportList();
    final data = await vmsContractorReportPage!.values
        .allRows(fromRow: 2); // Skipping the header row

    if (data.isEmpty) {
      return [];
    }

    return data;
  }

  static Future<List<Map<String, String>>> getGuestDriveList() async {
    if (GuestDrivelist == null) await connectToDataList();
    final rows = await GuestDrivelist?.values.allRows();
    if (rows == null || rows.isEmpty) return [];

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : '',
      };
    }).toList();
  }

  static Future<List<Map<String, String>>> getGuestPassList() async {
    if (GuestPasslist == null) await connectToDataList();
    final rows = await GuestPasslist?.values.allRows();
    if (rows == null || rows.isEmpty) return [];

    return rows.skip(1).map((row) {
      return {
        'pass': row[0],
        'status': row.length > 1 ? row[1] : '',
      };
    }).toList();
  }

  Future<void> addAccount(
      String name, String email, String phone, String role) async {
    if (accountsPage == null) await connectToAccountDetails();
    await accountsPage!.values.appendRow([
      name,
      email.toLowerCase(),
      phone,
      role,
      "",
      DateTime.now().toString()
    ]);
    print("Account added successfully: $name");
  }

  Future<List<Map<String, dynamic>>> getAccounts() async {
    if (accountsPage == null) await connectToAccountDetails();
    final rows = await accountsPage!.values.map.allRows();
    if (rows == null) return [];
    return rows.map((row) {
      return {
        'Name': row['Name'] ?? '',
        'Email': row['Email'] ?? '',
        'Phone': row['Phone'] ?? '',
        'OTP': row['OTP'] ?? '',
        'Role': row['Role'] ?? '',
      };
    }).toList();
  }

  Future<void> updateOTP(String otp, String rowNumber) async {
    if (accountsPage == null) await connectToAccountDetails();
    await accountsPage!.values
        .insertValue(otp, column: 2, row: int.parse(rowNumber));
  }

  Future<void> deleteRowByIndex(int rowIndex) async {
    if (accountsPage == null) await connectToAccountDetails();
    await accountsPage!.deleteRow(rowIndex);
  }

  static Future<List<List<String>>> fetchAllKeys() async {
    if (Manageaddkey == null) await connectToDataList();
    final rows = await Manageaddkey?.values.allRows();
    return rows ?? [];
  }

  static Future<void> updateKeyStatus(String key, String status) async {
    if (Manageaddkey == null) await connectToDataList();
    final rows = await Manageaddkey?.values.allRows();
    for (int i = 0; i < (rows?.length ?? 0); i++) {
      if (rows![i][0] == key) {
        await Manageaddkey!.values.insertValue(status, column: 2, row: i + 1);
        print("Updated key '$key' to status '$status'");
        return;
      }
    }
    print("Key '$key' not found.");
  }

  static Future<List<Map<String, dynamic>>> getDailyData(
      String sheetName) async {
    var today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    var rows = await fetchSheetData(sheetName);

    // Filter rows where 'Date' matches today's date
    return rows.where((row) => row['Date'] == today).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchSheetData(
      String sheetName) async {
    // Connect to the spreadsheet if not already connected
    await connectToReportList();

    Worksheet? sheet;
    switch (sheetName) {
      case 'hourlyPostUpdateReportPage':
        sheet = hourlyPostUpdateReportPage;
        break;
      case 'rollCallReportPage':
        sheet = rollCallReportPage;
        break;
      case 'roundingReportPage':
        sheet = roundingReportPage;
        break;
      case 'emergencyReportPage':
        sheet = emergencyReportPage;
        break;
      case 'spotCheckReportPage':
        sheet = spotCheckReportPage;
        break;
      case 'vmsContractorReportPage':
        sheet = vmsContractorReportPage;
        break;
      case 'vmsSupplierReportPage':
        sheet = vmsSupplierReportPage;
        break;
      case 'vmsDutyReportPage':
        sheet = vmsDutyReportPage;
        break;
      case 'ManagekeyReportPage':
        sheet = ManagekeyReportPage;
        break;
      default:
        throw Exception("Sheet name $sheetName not recognized.");
    }

    // Retrieve all rows and convert to List<Map<String, dynamic>>
    final rows = await sheet?.values.map.allRows();
    if (rows == null || rows.isEmpty) return [];

    // Assume the first row contains the headers and use it to create a map for each row
    final headers = rows.first.keys.toList();
    return rows.map((row) {
      final Map<String, dynamic> rowData = {};
      for (final header in headers) {
        rowData[header] = row[header];
      }
      return rowData;
    }).toList();
  }
}
