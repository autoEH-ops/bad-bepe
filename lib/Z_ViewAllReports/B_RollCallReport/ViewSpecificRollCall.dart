import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificRollCallPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const SpecificRollCallPage({super.key, required this.data});

  void _openImageUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text('Report Details', style: TextStyle(color: Colors.black, fontSize: 18)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildDetailBox('Report ID:', data['reportId'] ?? "N/A"),
              _buildDetailBox('Report by:', data['Personal ID'] ?? "N/A"),
              _buildDetailBox('Shift:', data['Shift'] ?? "N/A"),
              _buildDetailBox('Remarks:', data['Remarks'] ?? "N/A"),
              _buildDetailBox('Duty Security:', data['List Of Duty Security Personnels Name'] ?? "N/A"),
              _buildDetailBox('Timestamp:', (data['timestamp'])),
              if (data['Supporting Image'] != null && data['Supporting Image']!.isNotEmpty)
                _buildImageButton(data['Supporting Image']!),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageButton(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.only(top: 12.0),
      child: TextButton(
        onPressed: () => _openImageUrl(imageUrl),
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.blue,
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        child: const Text('Open Image', style: TextStyle(fontSize: 14)),
      ),
    );
  }

  Widget _buildDetailBox(String title, String? data) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF0091EA)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 4,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            const SizedBox(height: 4), // Space between title and data
            Text(
              data ?? "No Data",
              style: const TextStyle(fontSize: 14),
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
          ],
        ),
      ),
    );
  }

}
