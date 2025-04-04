// QrGeneratorService.dart

import 'package:http/http.dart' as http;
import 'dart:convert';
import '../GoogleAPIs/EmailAPI.dart'; // Ensure GmailAPI is correctly implemented
import '../GoogleAPIs/GoogleSpreadSheet.dart';

class QrvGeneratorService {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  Future<void> ensureSheetsConnected() async {
    if (GoogleSheets.qrReportPage == null) {
      await GoogleSheets.connectToReportList(); // Ensure connection to Google Sheets
    }
  }

  // Define sendEmail method
  Future<void> sendEmail(String receiverEmail, String messageContent) async {
    GmailAPI gmailAPI = GmailAPI();
    await gmailAPI.sendEmail(receiverEmail, messageContent); // Send email using GmailAPI
  }

  // Example method where you call generateAndSendEmail
  Future<void> generateAndSendEmail(String email, String code) async {
    GmailAPI gmailAPI = GmailAPI();
    await gmailAPI.sendEmail(email, code); // Send the email using GmailAPI
  }

  Future<void> addQrCodes({
    required String qr,
    required String name,
    required String ic,
    String? car,
    required String num,
    required String start,
    required String end,
    required String googleImage,
    required String switchyImage,
    required String email,
    required String passType,
    required String status2,
    required String category,
  }) async {
    // Debug print statements for each parameter
    print("Debugging Data Before Submission:");
    print("QR Code: $qr");
    print("Name: $name");
    print("IC: $ic");
    print("Car Plate: $car");
    print("Phone Number: $num");
    print("Start Date: $start");
    print("End Date: $end");
    print("Google Image Link (QR Attachment): $googleImage");
    print("Shortened URL: $switchyImage");
    print("Email: $email");
    print("passType: $passType");
    print("status2: $status2");
    print("Category: $category");

    await ensureSheetsConnected(); // Ensure Google Sheets is connected

// Validate email
    if (!isValidEmail(email)) {
      print("Invalid email address detected: $email");
      // Continue execution even if email is invalid
    } else {
      // Proceed with further logic if the email is valid
    }


    // Data mapping
    Map<String, dynamic> data = {
      'QR Code': qr,
      'Names': name,
      'Ic Number': ic,
      'Car Plate': car ?? '',
      'Phone Number': num,
      'Start Date': start,
      'End Date': end,
      'Status': 'Not Active',
      'Records': '',
      'VMS Records': '',
      'Timestamp': DateTime.now().toIso8601String(),
      'Qr Attachments': googleImage,
      'Qr Shortened URL': switchyImage,
      'email': email.trim(),
      'passType': category,
      'status2': 'Approved',
      'category': category,
    };

    // Debug: Print category before appending to sheet
    print("Category before saving to sheet: $category");

    // Append row to Google Sheets
    try {
      await GoogleSheets.qrReportPage!.values.appendRow([
        data['QR Code'],           // ID
        data['Names'],             // Names
        data['Ic Number'],         // Ic Number
        data['Car Plate'],         // Car Plate
        data['Phone Number'],      // Phone Number
        data['Start Date'],        // Start Date
        data['End Date'],          // End Date
        data['Status'],            // Status
        data['Records'],           // Records
        data['VMS Records'],       // VMSRecords
        data['Timestamp'],         // Timestamp
        data['Qr Attachments'],    // Qr Attachments
        data['Qr Shortened URL'],  // Shortened URL
        data['passType'],          // passType
        data['passId'],            // passId
        data['passimage'],         // passimage
        data['Remarks'],           // Remarks
        data['email'],             // email
        data['status2'],           // status2
        data['category'],          // category
      ]);
      print('Data added successfully to Google Sheets!');
    } catch (e) {
      print("Error appending data to Google Sheets: $e");
    }

    // Add a delay to ensure data has been written to Google Sheets
    await Future.delayed(Duration(seconds: 2));

    // Retrieve and verify the data from Google Sheets
    final savedData = await getVerifiedDataFromGoogleSheets(num, email);
    if (savedData == null) {
      print("Failed to verify data in Google Sheets. No message will be sent.");
      return;
    }

    // Send email and WhatsApp message if verification is successful
    await sendEmail(savedData['email'], savedData['QR Code']);

    // Use named parameters to ensure the correct values are passed
    await sendWhatsAppMessage(
      msg: "Here is your QR code link: ${savedData['Qr Shortened URL']}",
      phoneNumber: savedData['Phone Number'],
      email: savedData['email'],
      attachments: savedData['Qr Attachments'],
    );
  }

  // Function to retrieve data from Google Sheets by matching phone number and email
  Future<Map<String, dynamic>?> getVerifiedDataFromGoogleSheets(
      String phoneNumber, String email) async {
    // Load all rows from Google Sheets
    final rows = await GoogleSheets.qrReportPage!.values.allRows();

    print("Total rows fetched: ${rows.length}"); // Display only the total number of rows

    // Iterate over the rows to find a match for phone number and email
    for (var row in rows) {
      // Trim whitespace around phone number and email for accurate matching
      String sheetPhoneNumber = row[4].toString().trim(); // Column E for phone number
      String sheetEmail = row[17].toString().trim(); // Column R for email

      // Debug print statements to check values being compared
      print("Comparing phone: $sheetPhoneNumber with $phoneNumber");
      print("Comparing email: $sheetEmail with ${email.trim()}");

      if (sheetPhoneNumber == phoneNumber && sheetEmail == email.trim()) {
        print("Match found in Google Sheets.");

        return {
          'QR Code': row[0],
          'Names': row[1],
          'Ic Number': row[2],
          'Car Plate': row[3],
          'Phone Number': row[4],
          'Start Date': row[5],
          'End Date': row[6],
          'Status': row[7],
          'Records': row[8],
          'VMS Records': row[9],
          'Timestamp': row[10],
          'Qr Attachments': row[11],
          'Qr Shortened URL': row[12],
          'passType': row[13],
          'passId': row[14],
          'passimage': row[15],
          'Remarks': row[16],
          'email': row[17],
          'status2': row[18],
          'category': row[19],
        };
      }
    }

    print('No matching row found for the given phone number and email.');
    return null;
  }

  // Email validation function
  bool isValidEmail(String email) {
    print("Validating email: '$email'"); // Debug statement for email validation
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    bool isValid = regex.hasMatch(email);
    print("Is valid: $isValid"); // Debug statement for validation result
    return isValid;
  }

  Future<void> sendWhatsAppMessage({
    required String msg,
    required String phoneNumber,
    required String email,
    required String attachments,
  }) async {
    if (phoneNumber.isEmpty) {
      print("Phone number is required to send WhatsApp message.");
      return;
    }

    String webhookURL = "https://api.watoolbox.com/webhooks/20TBXWW1K"; // Update webhook URL
    String fullMessage = "BIG Caring Group Sdn Bhd\n" +
        "Jln Astana 3, 41050 Shah Alam, Selangor\n" +
        "3.0832459335986795, 101.45765923165037\n" +
        "Use Waze to drive to Received location: https://waze.com/ul/hw281s9r1n\n" +
        msg;

    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "media",
      "content": fullMessage,
      "phone": phoneNumber,
      "email": email,
      // Email is included but not necessary for WhatsApp sending
      "attachments": [attachments],
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("Message sent successfully to WhatsApp");

        // Send email if email exists and is valid
        if (isValidEmail(email)) {
          await generateAndSendEmail(
              email, fullMessage); // Send the WhatsApp message to email
        }
      } else {
        print("Failed to send WhatsApp message: ${response.statusCode}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }
}