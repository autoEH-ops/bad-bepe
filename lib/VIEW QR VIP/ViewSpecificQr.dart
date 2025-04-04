import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import 'ViewQrService.dart';

class OneVVQrCodePage extends StatefulWidget {
  const OneVVQrCodePage({
    super.key,
    required this.qrData,
    required this.email,
    required this.role,
  });

  final String qrData;
  final String email;
  final String role;

  @override
  State<OneVVQrCodePage> createState() => _OneVVQrCodePage();
}

class _OneVVQrCodePage extends State<OneVVQrCodePage> {
  final AllVVQrService allQrService = AllVVQrService();
  late Future<Map<String, dynamic>> allItems;
  late TextEditingController endDateController;

  @override
  void initState() {
    super.initState();
    endDateController = TextEditingController();
    loadData();
  }

  Future<void> loadData() async {
    allItems = allQrService.getQrCodeDetails(widget.qrData);
    allItems.then((data) {
      String endDate = formatDate(data['End Date'] ?? 'Unknown End Date');
      endDateController.text = endDate; // Populate text field
    });
  }

  String formatDate(String dateString) {
    try {
      // Attempt to parse as date
      DateTime date = DateTime.parse(dateString);
      return DateFormat('yyyy-MM-dd').format(date);
    } catch (e) {
      // If parsing fails, return the original string
      return dateString;
    }
  }

  Future<void> saveEndDate(String newEndDate) async {
    try {
      Map<String, dynamic> updates = {'End Date': newEndDate};

      // Step 1: Use the passed email to fetch the user's name
      String email = widget.email;

      // Step 2: Fetch the user's name using their email
      String editedBy = await allQrService.getNameByEmail(email);
      if (editedBy == 'Unknown User') {
        editedBy = 'Unknown User'; // Handle cases where the name isn't found
      }

      // Debugging: Print the editor's name
      print('Edited By: $editedBy');

      // Step 3: Update the QR Code details with the editor's name
      await allQrService.updateQrCodeDetails(widget.qrData, updates, editedBy);

      // Step 4: Provide feedback to the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('End Date updated successfully!')),
      );
    } catch (e) {
      // Handle errors gracefully
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update End Date: $e')),
      );
    }
  }

  Future<void> selectEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
      setState(() {
        endDateController.text = formattedDate;
      });
    }
  }

  Widget buildEditableTile(String label, TextEditingController controller) {
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
              TextField(
                controller: controller,
                readOnly: true, // Make TextField read-only
                onTap: () => selectEndDate(), // Open date picker on tap
                decoration: InputDecoration(
                  hintText: "Enter $label",
                  border: const OutlineInputBorder(),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () => selectEndDate(), // Open date picker on icon tap
                  ),
                ),
              ),
            ],
          ),
        ),
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
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
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
            String qrAttachments =
                data['QR Attachments'] ?? 'No QR Attachments';

            return ListView(
              padding: const EdgeInsets.all(8.0),
              children: [
                buildInfoTile("Name", name),
                buildInfoTile("IC Number / Passport", icNumber),
                buildInfoTile("Car Plate",
                    carPlate.isEmpty ? "No Car Registered" : carPlate),
                buildInfoTile("Start Date", startDate),
                buildEditableTile("End Date", endDateController), // Editable
                ElevatedButton(
                  onPressed: () => saveEndDate(endDateController.text),
                  child: const Text("Save End Date"),
                ),
                buildQrImageTile(context, "QR IMAGE", qrAttachments), // Button
              ],
            );
          }
        },
      ),
    );
  }

  // Don't forget to dispose the controller to prevent memory leaks
  @override
  void dispose() {
    endDateController.dispose();
    super.dispose();
  }
}
