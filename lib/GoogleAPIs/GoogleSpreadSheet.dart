import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class GoogleSheets {
  static const String credentials = r'''
  {
  "type": "service_account",
  "project_id": "pb-security-system-b3f0a",
  "private_key_id": "b2ba460d4c123e68ef47dc82707b6a39ebfc10f6",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvgIBADANBgkqhkiG9w0BAQEFAASCBKgwggSkAgEAAoIBAQDipeCy5YkHybWE\n4d7IfRoklz75AQ9SVM4M/wFbIqAUCGTAoqO7X0gDFFCZkBOexyLC4nFr6xvdX5MZ\nDiLBSCyfaeXClse+F+A5LZsLKcKrkxeKrtBR9mEQlTkSH1PG8TIDeFFFYD0ZYsvw\nMMD/3r0MPsIOaXHGrtq13frYcLxpnw+bkZinU5f0sZ8RRzLfykHcJP4sbrEMdNRT\n2wkH7PrAbk8kAtLvdtAsHXNMjyw//oygPCdHnm3wy1W89EX/I4yXWMVS0Iy9pc5h\nUTzWlHXKzZIcppditnjTUMLxQR4vsjldvlBffUyCPBXWwBm99g94Nn6FNorpoIlN\nbYRua9ePAgMBAAECggEAH6QIUaFBYeYdzQPFWMLnlpUgyZ1aw2PVx4hawEYosoiW\nHDMjCCJIni7ErnN9MbeGLvkdhsiHQX6OvWWKTOZjswuTHk5zayJ6fzD9NJqWCTgw\nhgAFUslCYBDHq16BO8Q/TFm3KtLBJN1J2unLf80GIlf+j7QrxJDI4AaHIZaMzx0O\nGvzYXaICkkjNl4rNH/XWMTW2gwbfC9/Oodb1dmX6DHmK2avXhsPKZJonsOuXg08I\ndhrIHkJeqxyZPhCqLvGKcNNlT9hamX3aZw4WTDk6QKN+SbapVHC5aOJexxVR7Reu\nbC/iRa0L7ZW7BZVPblHRQ3nZfLQXvcX+depgczNhSQKBgQD38Yh1MgJ01Van1dD/\nXpnPTS+X4oKW9mcaEaYK2lN2aV5+ADktKIVoR4Gc+M9HjCp7JAKag/ID8hK9PR5t\nD/Glr0/09x8hh00DMsJbzOskYRyFKkQ8QF/uh/QT69/vBIs6C/odcf0afHc9pJJh\nsk8QhTU/SvsXcw6BrNFkN5SJBwKBgQDqAzPEOzRbpjPUMgkED4v30xInIS+HVaTS\nuA3xKWnhnXVqQhXchxY7u6+F0xiE+CRXjeui1KTk2EEPxZRuUMkJyu82Xnj0j1FD\n4kFMITrResRWAzmvUg2NV1uhPxne22sY5b43hQHdRR9Bp+EgRRu/ZsuNlf4fodE8\nfXdMNP/DOQKBgQDf9C7JjM5jMYAAQUVyJMTRVmqyykoiiZY/Gcnc66+PuUU8kn8S\npxM5Sb1tR+ASRCzq5W/kmWG05qa+f8JHyKsAeQXDwqM/6bJKPUMJIGMUjRLxxWe0\n9ICyN+LjS58NihEn8UGN7zQrBFnAODJwRFreFTQvY07Bs49a2fqYhwuHaQKBgCYP\nXUUGKA7b6kQR2zuI18f30VUB5bwKJuOKweG+TZU/SdB9bRbP9cLDVNncKnm97hM7\nZt613RfHQFWzWd/TTc9E7UEXfm6wPJRg4SPjp7BYWkRvA9vK6Z9aXPHN1IRVhYao\nHxbikBoP2vSPvGLGOqwXqPWfNpSoeeJvuY5wdESpAoGBANruXprMigFr+yNbZExf\ncptzBNveh5x5ZzGvBxwePdRF4tIXI8ZUxwQ2KbWW91ESah958CZg6e5L9RMKe2Ty\nRr2bGF7O6hWDBXnf6fuDijxUaOJRseAA0zPbLlKOVTv3XMWCNMF2aSYC5FTyrGLZ\n7H3Wgv/mlhMCwfKvVgKNELim\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-gwryx@pb-security-system-b3f0a.iam.gserviceaccount.com",
  "client_id": "107350847642804765683",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-gwryx%40pb-security-system-b3f0a.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}
  ''';

  // Spreadsheet IDs for different sets of data
  static const String accountDetailsSpreadsheetID = '1A1r4O4rKhD8KW_eyJ-CKyVBZ5hMdB3Z5tghANm72Oyo';//each one with a sheet
  static const String reportListSpreadsheetID = '10a3JwKATnH0ZU4hrr2eyfD10OuMa1ApvYoerQmBf2og';
  static const String dataListSpreadsheetID = '1_TosSl-RGJtDL7XXSBXoKmmlcg3eqike-8kJIuatpsg';

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
      final spreadsheet = await gsheetsAccountDetails.spreadsheet(accountDetailsSpreadsheetID);
      accountsPage = await getWorkSheets(spreadsheet, title: 'Accounts');
      loginHistoryPage = await getWorkSheets(spreadsheet, title: 'Login History');
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
      final spreadsheet = await gsheetsReportList.spreadsheet(reportListSpreadsheetID);
      hourlyPostUpdateReportPage = await getWorkSheets(spreadsheet, title: 'hourlyPost Report');
      rollCallReportPage = await getWorkSheets(spreadsheet, title: 'rollCall Report');
      roundingReportPage = await getWorkSheets(spreadsheet, title: 'rounding Report');
      emergencyReportPage = await getWorkSheets(spreadsheet, title: 'Emergency Report');
      spotCheckReportPage = await getWorkSheets(spreadsheet, title: 'Spot Report');
      vmsContractorReportPage = await getWorkSheets(spreadsheet, title: 'Contractor Report');
      vmsSupplierReportPage = await getWorkSheets(spreadsheet, title: 'Supplier Report');
      vmsDutyReportPage = await getWorkSheets(spreadsheet, title: 'vmsDuty Report');
      LOGPAGE = await getWorkSheets(spreadsheet, title: 'LOG');
      GuestDrivereport = await getWorkSheets(spreadsheet, title: 'Drive Report');
      qrReportPage = await getWorkSheets(spreadsheet, title: 'QR Code Data');
      ManagekeyReportPage = await getWorkSheets(spreadsheet, title: 'Key Report');
      mainGateReportPage = await getWorkSheets(spreadsheet, title: 'mainGate Report');
      return true;
    } catch (e) {
      print("Error connecting to PB Report List: $e");
      return false;
    }
  }

  // Connect to PB Data List Spreadsheet
  static Future<bool> connectToDataList() async {
    try {
      final spreadsheet = await gsheetsDataList.spreadsheet(dataListSpreadsheetID);
      securityPersonnelNameListPage = await getWorkSheets(spreadsheet, title: "Security Name List");
      supplierPageListPage = await getWorkSheets(spreadsheet, title: 'Supplier List');
      dutyPassList = await getWorkSheets(spreadsheet, title: 'Duty Pass');
      contractorPassPage = await getWorkSheets(spreadsheet, title: 'Contractor Pass');
      supplierPassList = await getWorkSheets(spreadsheet, title: "Supplier Pass");
      GuestPasslist = await getWorkSheets(spreadsheet, title: 'Guest Pass');
      drivePasslist = await getWorkSheets(spreadsheet, title: 'Drive Pass');
      roundingPointPage  = await getWorkSheets(spreadsheet, title: 'Rounding Point');
      nextRoundingPage = await getWorkSheets(spreadsheet, title: "Rounding Point");
      gatePostLocationPage = await getWorkSheets(spreadsheet, title: 'Hourly Gate Post Location');
      Manageaddkey = await getWorkSheets(spreadsheet, title: 'Manage Key');
      emergencyLocationPage = await getWorkSheets(spreadsheet, title: 'Emergency Locations');
      return true;
    } catch (e) {
      print("Error connecting to PB Data List: $e");
      return false;
    }
  }

  static Future<Worksheet> getWorkSheets(Spreadsheet spreadsheet, {required String title}) async {
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
    final data = await vmsContractorReportPage!.values.allRows(fromRow: 2); // Skipping the header row

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

  Future<void> addAccount(String name, String email, String phone, String role) async {
    if (accountsPage == null) await connectToAccountDetails();
    await accountsPage!.values.appendRow([name, email.toLowerCase(), phone, role, "", DateTime.now().toString()]);
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
    await accountsPage!.values.insertValue(otp, column: 2, row: int.parse(rowNumber));
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

  static Future<List<Map<String, dynamic>>> getDailyData(String sheetName) async {
    var today = DateFormat('dd/MM/yyyy').format(DateTime.now());
    var rows = await fetchSheetData(sheetName);

    // Filter rows where 'Date' matches today's date
    return rows.where((row) => row['Date'] == today).toList();
  }

  static Future<List<Map<String, dynamic>>> fetchSheetData(String sheetName) async {
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
