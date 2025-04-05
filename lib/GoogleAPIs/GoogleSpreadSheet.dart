import 'package:gsheets/gsheets.dart';
import 'package:intl/intl.dart';

class GoogleSheets {
  static const String credentials = r'''
  
 {
  "type": "service_account",
  "project_id": "bp-system-sheets",
  "private_key_id": "d6c217b6341b2994669a5ea15364649a67485a29",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQCu3yRC12WdPYln\nUh5xsvEvHzsp53mZFfX5EhjY8AptsViv6T5fTZgYTrZzXv6WLEYJMpmanuCxjfhI\no1wmvxvVX+1Q2e73/1oGknOOHCcMB5rBUhhuPwtMrPsS+mI6KlIgeHvRiwd8i1pB\nqObFWOc9+to91v/tfZpS6M1Srn3U0MOHKGcM+b3T0wHN3d5qRDv1N5muTpV24TbF\nZNRzBZ/DH8iBbB5iiA9TmNs+Kqoh5FVWx9tDEptNsEmFxvZZR9tEjKfAjOIeh3yL\nWzajuGz/d0yTdR6E41DimQKwkHTRPyLPF6UuKCZ4mLpwl4j0HH+B8JnIucemvM6o\ncZMX2tO/AgMBAAECggEATQEP26s0INCnP+smYtT0Zdav290Fa8cC4KH6dRUG0pTk\nw9nG0Hq/vfxzVUyAeSqX0JcKks7hjO5CZeIhwyImpIgwXYkKNQSp5Pj6j5qQCzkS\nCY0YGvwCAsqtaQb+2DQopAnKJFS/gDVxEjbJIB/s/BsJnW+elTrZCSdguscBvANS\nxadzcdrdqvQWbfGw3KiQQ2Mi4+4Dl1dSXG8udnaoucc8RKvbk+r67CcYDY5njX8f\nji/IxmX8KfVlfi/5mPBAmTLycs55s4WQQsoT/ot319iEMb5VlYVWofodkVZFmH9j\nDaW2gW9tTui1U2JG/Rj1R7w4pOwap/kN9p3HLX7CKQKBgQDpksALyHqjgMoPDc3W\nYg+aBqbKhpO9i0EHEKGnb/zPJ9rzEM4lAmz32DQ6xPsSV+pqNqgkgpIRXgPlfzYU\nS6AHHMN3B6qmd1IX+pUVkqFzK3q0q5VHwixbLghO9X0nsKT367vmfgWfFKOS+vft\n2wJqey2mJEFRN3/au1ApWxuqWwKBgQC/qYBXkNXKrQEBbBCS/2JjbeRy319NSSQ/\nUhs6O3yRMdvHBpxklsDcNy+dFn7BFUGKR/fXIOJy4/6cAOlBR//mvE2vvDzOsbWK\nh3Bedt5FVTQGsJijvxQQwhqsH+I2GdxSCMbyNTSA0rnjBWUJv3/O42zOCckFdxvm\nr2tTXy3RbQKBgGriUquRtD055Dz7TiQ6f3U2cgDfkJ/+J2W6QJ9EaeXKETGFkS/y\najcIYu450cLVJFoyZMNAVONJqHLOwcqLyNE4YmIHyhmfJJwAeVSD4wm27dHbataJ\njo6zA+5N/FW7SeKBp1yUcrIXWbsayXW48OQVNhB/KrylrwZDDS2/mWtdAoGAdmaZ\n+H5q9Gfn5R8DJixKda4foK9JSo9SqyNn2pOBIpkwckUtPB69Sc11xo9tAo7FDE3l\nV6ri+aLLWUhe0ItQFRRi0Ztx3SZ/RfLhghnguegm2bMiuJWEKc4feBHCRzW2m578\neAhSRPrpBswAXQNGS2LHhokY/B1WyS25GaoEvgkCgYAFjeswEyKHlv+AMEWoRdiS\n9xQ4zrN9+wrWipqOsBKJWQwoT712YwK7DC5ZpvwwFdG4nEdiOnFVm2SctmKAlcH9\nQNHjWywtGf21epb/S114Ppw+PReG6aQp+N+dFceJpu4Z1RHmlBdcyDfbh+JBfHoB\njDJ5r5XF+jEX4sYhTwotwQ==\n-----END PRIVATE KEY-----\n",
  "client_email": "firebase-adminsdk-fbsvc@bp-system-sheets.iam.gserviceaccount.com",
  "client_id": "117366191066821920697",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40bp-system-sheets.iam.gserviceaccount.com",
  "universe_domain": "googleapis.com"
}

  ''';

  // Spreadsheet IDs for different sets of data
  static const String accountDetailsSpreadsheetID =
      '1JlYVQyRRH2XGVRNFpgPSsKhg6UTg7MGjhmC7cNPf3K0'; //each one with a sheet
  static const String reportListSpreadsheetID =
      '1m__36YjXYfyJNUpmmcXGR9fAldEdEBLqTiGLmbN55_E';
  static const String dataListSpreadsheetID =
      '1JwVFyzsXhf_VX1vDDi5N2v5QfP_tgajd0lDv8-G6a0M';

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
