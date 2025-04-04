import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ViewQrService.dart';

class OneQrCodePage extends StatefulWidget {
  const OneQrCodePage({super.key, required this.qrData});
  final String qrData;

  @override
  State<OneQrCodePage> createState() => _OneQrCodePageState();
}

class _OneQrCodePageState extends State<OneQrCodePage> {
  final AllQrService allQrService = AllQrService();
  late Future<Map<String, dynamic>> allItems;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    allItems = allQrService.getQrCodeDetails(widget.qrData);
  }

  DateTime serialDateToDateTime(int serialDate) {
    const baseDate = '1899-12-30'; // Base date for Google Sheets serial date
    final baseDateTime = DateTime.parse(baseDate);
    return baseDateTime.add(Duration(days: serialDate));
  }

  String formatDate(String serialDateString) {
    try {
      int serialDate = int.parse(serialDateString);
      DateTime date = serialDateToDateTime(serialDate);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      return serialDateString; // Return as-is if parsing fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QR Code Details',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: allItems,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Data Found'));
          } else {
            Map<String, dynamic> data = snapshot.data!;
            String name = data['Names'] ?? 'Unknown Name';
            String icNumber = data['Ic Number'] ?? 'Unknown IC/Passport';
            String carPlate = data['Car Plate'] ?? 'No Car Registered';
            String startDate =
                formatDate(data['Start Date'] ?? 'Unknown Start Date');
            String endDate = formatDate(data['End Date'] ?? 'Unknown End Date');
            String status = data['Status'] ?? 'Unknown Status';
            String Records = data['Records'] ?? 'Unknown Status';
            String qrAttachments =
                data['QR Attachments'] ?? 'No QR Attachments';

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                buildInfoTile("Name", name),
                buildInfoTile("IC Number / Passport", icNumber),
                buildInfoTile("Car Plate",
                    carPlate.isEmpty ? "No Car Registered" : carPlate),
                buildInfoTile("Current Status", status),
                buildInfoTile("Records", Records),
                buildInfoTile("Start Date", startDate),
                buildInfoTile("End Date", endDate),
                buildQrImageTile(context, "QR IMAGE", qrAttachments),
              ],
            );
          }
        },
      ),
    );
  }

  Widget buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 5),
              Text(
                value,
                style: const TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQrImageTile(BuildContext context, String label, String url) {
    if (url == 'No QR Attachments' || url.isEmpty) {
      return buildInfoTile(label, url);
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              const SizedBox(height: 5),
              ElevatedButton(
                onPressed: () {
                  _launchURL(url);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Background color
                ),
                child: const Text("View QR Image"),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
