import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ViewQrService.dart';
import 'ViewSpecificQr.dart';

class OneAQrCodePage extends StatefulWidget {
  const OneAQrCodePage({super.key, required this.qrData});
  final String qrData;

  @override
  State<OneAQrCodePage> createState() => _OneAQrCodePageState();
}

class _OneAQrCodePageState extends State<OneAQrCodePage> {
  final AllAQrService allQrService = AllAQrService();
  late Future<Map<String, dynamic>> allItems;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    setState(() {
      allItems = allQrService.getQrCodeDetails(widget.qrData);
    });
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

  Future<void> updateStatus(String newStatus) async {
    setState(() {
      isLoading = true;
    });

    bool success = await allQrService.updateStatus2(widget.qrData, newStatus);

    setState(() {
      isLoading = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Status updated to "$newStatus".')),
      );
      // Notify parent to refresh and close this screen
      Navigator.of(context).pop(true); // Return `true` to indicate success
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update status.')),
      );
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
        iconTheme: const IconThemeData(color: Colors.black), // Ensure back button is visible
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
            String phoneNumber = data['Phone Number'] ?? 'Unknown Phone Number';
            String category = data['category'] ?? 'No Category';
            String status2 = data['status2'] ?? 'No Status';
            String startDate =
            formatDate(data['Start Date']?.toString() ?? 'Unknown Start Date');
            String endDate =
            formatDate(data['End Date']?.toString() ?? 'Unknown End Date');
            String qrAttachment = data['Qr Attachments'] ?? '';
            String email = data['email'] ?? 'No Email Provided';

            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      buildInfoTile("Name", name),
                      buildInfoTile("IC Number / Passport", icNumber),
                      buildInfoTile(
                          "Car Plate", carPlate.isEmpty ? "No Car Registered" : carPlate),
                      buildInfoTile("Current Status", status2),
                      buildInfoTile("Phone Number", phoneNumber),
                      buildInfoTile("Start Date", startDate),
                      buildInfoTile("End Date", endDate),
                      buildInfoTile("Category", category),
                      buildInfoTile("Email", email),
                      // QR Image Button
                      buildQrImageTile(context, "QR Attachment", qrAttachment),
                      const SizedBox(height: 20),
                      // Action Buttons
                      buildActionButtons(status2),
                    ],
                  ),
                ),
                if (isLoading)
                  Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
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
        width: double.infinity,
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
    if (url.toLowerCase() == 'no qr attachments' || url.isEmpty) {
      return buildInfoTile(label, 'No QR Attachments');
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
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
                  backgroundColor: Colors.blue,
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
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch URL: $url')),
      );
      throw 'Could not launch $url';
    }
  }

  Widget buildActionButtons(String currentStatus) {
    List<Widget> buttons = [];

    if (currentStatus.toLowerCase() != 'approved') {
      buttons.add(
        ElevatedButton(
          onPressed: () {
            _showConfirmationDialog('Approved');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text(
            "Approve",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    if (currentStatus.toLowerCase() != 'pending approved') {
      buttons.add(
        const SizedBox(height: 10),
      );
      buttons.add(
        ElevatedButton(
          onPressed: () {
            _showConfirmationDialog('Pending Approved');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orange,
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text(
            "Deactivated",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    if (currentStatus.toLowerCase() != 'expired') {
      buttons.add(
        const SizedBox(height: 10),
      );
      buttons.add(
        ElevatedButton(
          onPressed: () {
            _showConfirmationDialog('expired');
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            minimumSize: const Size.fromHeight(50),
          ),
          child: const Text(
            "Deactivated",
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
        ),
      );
    }

    if (buttons.isEmpty) {
      return Center(
        child: Text(
          'No actions available for the current status.',
          style: TextStyle(fontSize: 16, color: Colors.grey[600]),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
      child: Column(
        children: buttons,
      ),
    );
  }

  void _showConfirmationDialog(String action) {
    String actionText;
    Color actionColor;

    switch (action.toLowerCase()) {
      case 'approved':
        actionText = 'Approve';
        actionColor = Colors.green;
        break;
      case 'pending approved':
        actionText = 'Pending Approved';
        actionColor = Colors.orange;
        break;
      case 'expired':
        actionText = 'Deactivated';
        actionColor = Colors.red;
        break;
      default:
        actionText = action;
        actionColor = Colors.blue;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('$actionText Confirmation'),
          content: Text('Are you sure you want to mark this QR code as "$action"?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
              },
            ),
            TextButton(
              child: Text(
                actionText,
                style: TextStyle(color: actionColor),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss dialog
                updateStatus(action);
              },
            ),
          ],
        );
      },
    );
  }
}
