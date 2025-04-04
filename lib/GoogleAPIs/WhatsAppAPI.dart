import 'dart:convert';
import 'package:http/http.dart' as http;
import '/Components/TimeRelatedFunctions.dart';
import '/GoogleAPIs/TelegramAPI.dart';

class WhatsAppAPI {
  static String hourlyPostUpdateGroupID = "120363275860157189@g.us";
  static String rollCallReportGroupID = "120363277036409058@g.us";
  static String roundingReportGroupID = "120363295607845482@g.us";
  static String emergencyReportGroupID = "120363295287820248@g.us";
  static String spotCheckReportGroupID = "120363275494631294@g.us";
  static String shutterReportGroupID = "120363294504275474@g.us";
  static String electricPanelReportGroupID = "120363277516718231@g.us";
  static String glassSlidingDoorReportGroupID = "120363277933304017@g.us";
  static String mainGateReportGroupID = "120363292836710382@g.us";
  static String clampingReportGroupID = "120363292988854863@g.us";
  static String vmsReportGroupID = "120363293387351002@g.us";
  static String passCheckingReportGroupID = "120363294814328425@g.us";

  static String adminGroup = "120363275102258906@g.us";

  static String webHookUrl = "https://api.watoolbox.com/webhooks/20TBXWW1K";

  TelegramAPI telegramAPI = TelegramAPI();
  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();

  Future<void> sendMessage(String msg, String phoneNumber) async {
    String template = "Your OTP : $msg\nRegards by Admin";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": phoneNumber,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  // ================================================================================================================== //
  // These are all WhatsApp Template //
  // ================================================================================================================== //

  Future<void> sendHourlyPostUpdateReport(
      String date,
      String time,
      String names,
      String gatePosts,
      String remarks,
      String repID,
      String files) async {
    String template = "Type of Report : Hourly Post Update Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Security Names : $names\n"
        "Gate Posts : $gatePosts\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": hourlyPostUpdateGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);

      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendRollCallReport(String date, String time, String names,
      String shifts, String remarks, String repID, String files) async {
    String template = "Type of Report : Roll Call Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Security Names : $names\n"
        "Shift : $shifts\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": rollCallReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendRoundingReport(String date, String time, String names,
      String roundingPoint, String remarks, String repID, String files) async {
    String template = "Type of Report : Rounding Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Security Names : $names\n"
        "Rounding Point : $roundingPoint\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": roundingReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendSpotCheck(
      String date,
      String time,
      String names,
      String spotDes,
      String spotFin,
      String remarks,
      String prepBy,
      String repID,
      String files) async {
    String template = "Type of Report : Spot Check Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Spot Check Description : $spotDes\n"
        "Spot Check Findings : $spotFin\n"
        "Remarks for Clients : $remarks\n"
        "Prepared By : $prepBy\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": spotCheckReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendShutterReport(
      String date,
      String time,
      String names,
      String currentShutter,
      String status,
      String remarks,
      String repID,
      String files) async {
    String template = "Type of Report : Shutter Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Current Shutter : $currentShutter"
        "Shutter Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": shutterReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendElectricPanelReport(
      String date,
      String time,
      String names,
      String currentPanel,
      String status,
      String remarks,
      String repID,
      String files) async {
    String template = "Type of Report : Electric Panel Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Current Panel : $currentPanel\n"
        "Panel Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": electricPanelReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendGlassSlidingDoorReport(
      String date,
      String time,
      String names,
      String currentGlass,
      String status,
      String remarks,
      String repID,
      String files) async {
    String template = "Type of Report : Glass Sliding Door Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Current Door : $currentGlass\n"
        "Door Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": glassSlidingDoorReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendMainGateReport(
      String date,
      String time,
      String names,
      String currentGate,
      String status,
      String remarks,
      String repID,
      String files) async {
    String template = "Type of Report : Main Gate Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Current Gate : $currentGate\n"
        "Gate Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": mainGateReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

// ======================================= //
  Future<void> sendVmsSupplierReport(
    String typeofRep,
    String date,
    String time,
    String names,
    String category,
    String supName,
    String inOrOut,
    String phoneNumber,
    String icNumOrPass,
    String passNum,
    String repID,
    String files1,
    String files2,
    String files3,
    String files4,
    String files5,
  ) async {
    String template = "Type of Report : $typeofRep \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Categories : $category\n"
        "Supplier Name : $supName\n"
        "In or Out : $inOrOut\n"
        "Phone Number : $phoneNumber\n"
        "IC / Passport : $icNumOrPass\n"
        "Pass Number : $passNum\n"
        "Report ID : $repID\n"
        "Vehicle Photo : $files1\n"
        "License Photo : $files2\n"
        "Order Photo : $files3\n"
        "Item Photo : $files4\n"
        "Permit Photo : $files5";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": vmsReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendVmsDutyOrContractorReport(
      String typeofRep,
      String date,
      String time,
      String names,
      String category,
      String supName,
      String inOrOut,
      String phoneNumber,
      String icNumOrPass,
      String passNum,
      String repID,
      String files) async {
    String template = "Type of Report : $typeofRep \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Categories : $category\n"
        "Supplier Name : $supName\n"
        "In or Out : $inOrOut\n"
        "Phone Number : $phoneNumber\n"
        "IC / Passport : $icNumOrPass\n"
        "Pass Number : $passNum\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": vmsReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendVmsOutReport(
      String typeofRep,
      String date,
      String time,
      String names,
      String category,
      String supName,
      String inOrOut,
      String phoneNumber,
      String icNumOrPass,
      String passNum,
      String repID,
      String files1,
      String files2,
      String files3) async {
    String template = "Type of Report : $typeofRep \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Categories : $category\n"
        "Supplier Name : $supName\n"
        "In or Out : $inOrOut\n"
        "Phone Number : $phoneNumber\n"
        "IC / Passport : $icNumOrPass\n"
        "Pass Number : $passNum\n"
        "Report ID : $repID\n"
        "Passport : $files1\n"
        "License : $files2\n"
        "Number Plate : $files3";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": vmsReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendKeyCollectionReport(
      String typeofRep,
      String date,
      String time,
      String names,
      String category,
      String phoneNumber,
      String icNumOrPass,
      String key,
      String repID,
      String files,
      String files2) async {
    String template = "Type of Report : $typeofRep \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Categories : $category\n"
        "Phone Number : $phoneNumber\n"
        "IC / Passport : $icNumOrPass\n"
        "Key : $key\n"
        "Report ID : $repID\n"
        "Valid Work Permit or ID : $files"
        "Photo of Key Handed : $files2 ";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": vmsReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendReturnKeyReport(
      String typeofRep,
      String date,
      String time,
      String names,
      String category,
      String key,
      String repID,
      String files) async {
    String template = "Type of Report : $typeofRep \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Categories : $category\n"
        "Pass Number : $key\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": vmsReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendPassCheckingReport(String date, String time, String names,
      String typeofPass, String passJoin, String repID, String files) async {
    String template = "Type of Report : Pass Checking Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Pass Type : $typeofPass\n"
        "Pass Join : $passJoin\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": passCheckingReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendEmergencyReport(
      String incidentDate,
      String incidentTime,
      String names,
      String locationPoint,
      String policeRepMade,
      String status,
      String remarks,
      String repID,
      String files) async {
    String template = "Type of Report : Emergency Report \n"
        "Incident Date : $incidentDate\n"
        "Incident Time : $incidentTime\n"
        "Reported By : $names\n"
        "Incident Location Point : $locationPoint\n"
        "Police Report Made : $policeRepMade\n"
        "Incident Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": emergencyReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendEmergencyFollowUpReport(
      String incidentDate,
      String incidentTime,
      String names,
      String status,
      String remarks,
      String repID,
      String files) async {
    String template = "Type of Report : Emergency Report \n"
        "Incident Date : $incidentDate\n"
        "Incident Time : $incidentTime\n"
        "Reported By : $names\n"
        "Incident Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": emergencyReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendClampingReport(
    String date,
    String time,
    String names,
    String carPlate,
    String status,
    String remarks,
    String repID,
    String files1,
    String files2,
  ) async {
    String template = "Type of Report : Clamping   Report \n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Car Plate : $carPlate\n"
        "Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Car Plate Photo : $files1\n"
        "Car Tyre Photo : $files2";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": clampingReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendClampingFollowUpReport(
    String date,
    String time,
    String names,
    String carPlate,
    String status,
    String remarks,
    String repID,
    String files1,
    String files2,
  ) async {
    String template = "Type of Report : Clamping Follow Up\n"
        "Date : $date\n"
        "Time : $time\n"
        "Reported By : $names\n"
        "Car Plate : $carPlate\n"
        "Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Payment Slip Photo : $files1\n"
        "Unclamping Photo : $files2";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": clampingReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> sendPassCheckingFollowUpReport(
      String incidentDate,
      String incidentTime,
      String names,
      String status,
      String remarks,
      String repID,
      String files) async {
    String template = "Type of Report : Pass Checking Follow Up \n"
        "Date : $incidentDate\n"
        "Time : $incidentTime\n"
        "Reported By : $names\n"
        "Incident Status : $status\n"
        "Remarks : $remarks\n"
        "Report ID : $repID\n"
        "Supporting Files : $files";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": passCheckingReportGroupID,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> adminDelAccount(
    String adminName,
    String email,
    String name,
    String role,
  ) async {
    String template = "Type of Report : Account Removal\n"
        "Date : ${timeRelatedFunction.getCurrentDate()}\n"
        "Time : ${timeRelatedFunction.getCurrentTime()}\n"
        "Account Deleted By : $adminName\n"
        "Deleted Account Details : \n"
        "Email : $email\n"
        "Name : $name\n"
        "Role : $role";

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": adminGroup,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

  Future<void> adminCreateAccount(
      String email,
      String name,
      String role,
      String createdBy // Creator's information
      ) async {
    String template = "Type of Report : Account Creation\n"
        "Date : ${timeRelatedFunction.getCurrentDate()}\n"
        "Time : ${timeRelatedFunction.getCurrentTime()}\n"
        "Account Creation Details : \n"
        "Email : $email\n"
        "Name : $name\n"
        "Role : $role\n"
        "Created By : $createdBy"; // Include creator's details

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": adminGroup,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }



  Future<void> adminCreatePendingAccount(
      String email,
      String name,
      String role,
      String createdBy // Creator's information
      ) async {
    String template = "Type of Report : Account Creation\n"
        "Date : ${timeRelatedFunction.getCurrentDate()}\n"
        "Time : ${timeRelatedFunction.getCurrentTime()}\n"
        "Account Creation Details : \n"
        "Status : Pending\n"
        "Email : $email\n"
        "Name : $name\n"
        "Role : $role\n"
        "Created By : $createdBy"; // Include creator's details

    String webhookURL = webHookUrl;
    Map<String, dynamic> payload = {
      "action": "send-message",
      "type": "text",
      "content": template,
      "phone": adminGroup,
    };

    try {
      http.Response response = await http.post(
        Uri.parse(webhookURL),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(payload),
      );
      telegramAPI.sendMessage(template);
      if (response.statusCode == 200) {
        print("Message sent successfully");
        print("Response body: ${response.body}");
      } else {
        print("Failed to send message: ${response.statusCode}");
        print("Response body: ${response.body}");
      }
    } catch (error) {
      print("Error sending message: $error");
    }
  }

}
