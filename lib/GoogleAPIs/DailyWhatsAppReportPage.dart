import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:created_by_618_abdo/GoogleAPIs/GoogleSpreadSheet.dart';
import 'WhatsAppAPI.dart';

class DailyWhatsAppReportPage extends StatefulWidget {
  const DailyWhatsAppReportPage({super.key});

  @override
  _DailyWhatsAppReportPageState createState() => _DailyWhatsAppReportPageState();
}

class _DailyWhatsAppReportPageState extends State<DailyWhatsAppReportPage> {
  final WhatsAppAPI whatsAppAPI = WhatsAppAPI();
  bool isSending = false;

  final DateTime today = DateTime.now();
  final String date = DateFormat('MM/dd/yyyy').format(DateTime.now());
  final String time = DateFormat('HH:mm:ss').format(DateTime.now());

  Future<void> sendDailyReports() async {
    setState(() {
      isSending = true;
    });

    try {
      await sendHourlyPostUpdates();
      await sendRollCallReports();
      await sendRoundingReports();
      await sendEmergencyReports();
      await sendSpotCheckReports();
      await sendVmsReports();
      await sendKeyManagementReports();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Daily reports sent successfully!')),
      );
    } catch (e) {
      print("Error sending reports: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to send daily reports.')),
      );
    } finally {
      setState(() {
        isSending = false;
      });
    }
  }

  Future<void> sendHourlyPostUpdates() async {
    var data = await GoogleSheets.getDailyData('hourlyPostUpdateReportPage');
    for (var report in data) {
      await whatsAppAPI.sendHourlyPostUpdateReport(
        date,
        report['Time'],
        report['Names'],
        report['Gate Posts'],
        report['Remarks'],
        report['Report ID'],
        report['Files'],
      );
    }
  }

  Future<void> sendRollCallReports() async {
    var data = await GoogleSheets.getDailyData('rollCallReportPage');
    for (var report in data) {
      await whatsAppAPI.sendRollCallReport(
        date,
        report['Time'],
        report['Names'],
        report['Shift'],
        report['Remarks'],
        report['Report ID'],
        report['Files'],
      );
    }
  }

  Future<void> sendRoundingReports() async {
    var data = await GoogleSheets.getDailyData('roundingReportPage');
    for (var report in data) {
      await whatsAppAPI.sendRoundingReport(
        date,
        report['Time'],
        report['Names'],
        report['Rounding Point'],
        report['Remarks'],
        report['Report ID'],
        report['Files'],
      );
    }
  }

  Future<void> sendEmergencyReports() async {
    var data = await GoogleSheets.getDailyData('emergencyReportPage');
    for (var report in data) {
      await whatsAppAPI.sendEmergencyReport(
        report['Incident Date'],
        report['Incident Time'],
        report['Names'],
        report['Location Point'],
        report['Police Report Made'],
        report['Status'],
        report['Remarks'],
        report['Report ID'],
        report['Files'],
      );
    }
  }

  Future<void> sendSpotCheckReports() async {
    var data = await GoogleSheets.getDailyData('spotCheckReportPage');
    for (var report in data) {
      await whatsAppAPI.sendSpotCheck(
        date,
        report['Time'],
        report['Names'],
        report['Spot Check Description'],
        report['Spot Check Findings'],
        report['Remarks for Clients'],
        report['Prepared By'],
        report['Report ID'],
        report['Files'],
      );
    }
  }

  Future<void> sendVmsReports() async {
    var contractorData = await GoogleSheets.getDailyData('vmsContractorReportPage');
    var supplierData = await GoogleSheets.getDailyData('vmsSupplierReportPage');
    var dutyData = await GoogleSheets.getDailyData('vmsDutyReportPage');

    for (var report in contractorData) {
      await whatsAppAPI.sendVmsDutyOrContractorReport(
        "VMS Contractor Report",
        date,
        report['Time'],
        report['Names'],
        report['Category'],
        report['Supplier Name'],
        report['In or Out'],
        report['Phone Number'],
        report['IC / Passport'],
        report['Pass Number'],
        report['Report ID'],
        report['Files'],
      );
    }

    for (var report in supplierData) {
      await whatsAppAPI.sendVmsSupplierReport(
        "VMS Supplier Report",
        date,
        report['Time'],
        report['Names'],
        report['Category'],
        report['Supplier Name'],
        report['In or Out'],
        report['Phone Number'],
        report['IC / Passport'],
        report['Pass Number'],
        report['Report ID'],
        report['Files1'],
        report['Files2'],
        report['Files3'],
        report['Files4'],
        report['Files5'],
      );
    }

    for (var report in dutyData) {
      await whatsAppAPI.sendVmsDutyOrContractorReport(
        "VMS Duty Report",
        date,
        report['Time'],
        report['Names'],
        report['Category'],
        report['Supplier Name'],
        report['In or Out'],
        report['Phone Number'],
        report['IC / Passport'],
        report['Pass Number'],
        report['Report ID'],
        report['Files'],
      );
    }
  }

  Future<void> sendKeyManagementReports() async {
    var keyCollectionData = await GoogleSheets.getDailyData('ManagekeyReportPage');

    for (var report in keyCollectionData) {
      await whatsAppAPI.sendKeyCollectionReport(
        "Key Collection Report",
        date,
        report['Time'],
        report['Names'],
        report['Category'],
        report['Phone Number'],
        report['IC / Passport'],
        report['Key'],
        report['Report ID'],
        report['Files'],
        report['Files2'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Send Daily Reports to WhatsApp'),
      ),
      body: Center(
        child: isSending
            ? const CircularProgressIndicator()
            : ElevatedButton(
          onPressed: sendDailyReports,
          child: const Text('Send Daily Reports'),
        ),
      ),
    );
  }
}
