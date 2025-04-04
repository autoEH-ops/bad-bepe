import 'dart:math';

import 'package:created_by_618_abdo/DataFields/Accounts/AccountFields.dart';
import 'package:created_by_618_abdo/GoogleAPIs/EmailAPI.dart';
import 'package:created_by_618_abdo/GoogleAPIs/GoogleSpreadSheet.dart';
import 'package:created_by_618_abdo/GoogleAPIs/WhatsAppAPI.dart';
import 'package:intl/intl.dart';

class LoginService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  // Generate a 6-digit OTP
  int generateSixDigitOTP() {
    Random random = Random();
    return 100000 +
        random.nextInt(900000); // Generates a number between 100000 and 999999
  }

  // Fetch account data and send OTP
  Future<AccountFieldsData?> getData(String input) async {
    try {
      List<Map<String, dynamic>> accounts = await googleSheetsApi.getAccounts();
      Map<String, dynamic>? matchingAccount;

      // Find matching account by email or phone
      for (var account in accounts) {
        if (account["Email"] == input || account["Phone"] == input) {
          matchingAccount = account;
          break;
        }
      }

      if (matchingAccount == null) {
        return null; // No matching account found
      }

      String otp = generateSixDigitOTP().toString();
      final String phone = matchingAccount["Phone"].toString();
      final String email = matchingAccount["Email"];

      // Send OTP via WhatsApp and Email
      sendMessage(otp, phone);
      sendEmail(email, otp);

      // Update OTP in Google Sheets
      await updateOTP(matchingAccount["Email"], otp);
      return AccountFieldsData.fromJson(matchingAccount);
    } catch (e) {
      print('Failed to get data: $e');
      return null;
    }
  }

  // Update the OTP in Google Sheets (column B)
  Future<void> updateOTP(String email, String otp) async {
    List<Map<String, dynamic>> accounts = await googleSheetsApi.getAccounts();

    // Iterate through the accounts to find the correct email and update the OTP in column B (2nd column)
    for (int index = 0; index < accounts.length; index++) {
      if (accounts[index]["Email"] == email) {
        // Update the OTP in column B
        await GoogleSheets.accountsPage!.values.insertValue(otp,
            column: 2,
            row: index +
                2); // +2 to skip the header row and match the correct row number
        break;
      }
    }
  }

  // Send WhatsApp OTP
  void sendMessage(String otp, String phone) {
    WhatsAppAPI whatsAppAPI = WhatsAppAPI();
    whatsAppAPI.sendMessage(otp, phone);
  }

  // Send Email OTP
  void sendEmail(String email, String otp) {
    GmailAPI gmailAPI = GmailAPI();
    gmailAPI.sendEmail(email, otp);
  }

  // Login method
  Future<String> login(String otp, String email) async {
    List<Map<String, dynamic>> accounts = await googleSheetsApi.getAccounts();
    for (var account in accounts) {
      if (account["Email"] == email && account["OTP"].toString() == otp) {
        await updateOTP(email, ""); // Clear OTP on successful login
        return account["Role"]; // Return the user's role
      }
    }
    return ""; // Return empty string if OTP or email is incorrect
  }
  // Custom print function that logs to both console and Google Sheets
  void customPrint(String message) {
    print(message); // Standard print to console
    logToSheet(message); // Log to Google Sheets
  }

  Future<void> logToSheet(String message) async {
    // Ensure connection to Google Sheets
    await GoogleSheets.connectToReportList();

    final logSheet = GoogleSheets.LOGPAGE; // Assuming LOGPAGE is already a valid reference

    if (logSheet == null) {
      customPrint('LOGPAGE is not initialized!');
      return;
    }

    // Format the log message with the current timestamp
    final timestamp = DateFormat('yyyy-MM-dd HH:mm:ss').format(DateTime.now());
    final logEntry = [timestamp, message];  // Create a log entry

    try {
      // Fetch all rows from the sheet to ensure we get the last row
      final rows = await logSheet.values.allRows();
      int lastRow = rows.length;

      // Avoid recursive or duplicate logs by ensuring the function only runs when needed
      if (message != "Data added successfully to Google Sheets!") {
        await logSheet.values.appendRow(logEntry); // Append the log entry to the next available row
        customPrint('Log entry saved to Google Sheets: $message');
      } else {
        customPrint('Skipping log entry for: $message');
      }
    } catch (e) {
      customPrint('Error saving log to Google Sheets: $e');
    }
  }

}

