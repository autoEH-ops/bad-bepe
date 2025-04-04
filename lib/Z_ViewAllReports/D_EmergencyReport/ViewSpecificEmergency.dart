import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '/SubmitFollowUpEmergencyFollowUp/SpecificEmergencyFollowUp/SpecificEmergencyFollowUpService.dart';

class SpecificEmergencyPage extends StatefulWidget {
  const SpecificEmergencyPage({super.key, required this.data});

  final Map<String, String> data;

  @override
  State<SpecificEmergencyPage> createState() => _SpecificEmergencyPageState();
}

class _SpecificEmergencyPageState extends State<SpecificEmergencyPage> {
  SpecificEmergencyFollowUpService specificEmergencyFollowUpService = SpecificEmergencyFollowUpService();

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
        title: Text(
          widget.data["Report ID"] ?? "",
          style: const TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoBox("Report ID:", widget.data["reportId"]),
              _buildInfoBox("Report by:", widget.data["ID"]),
              _buildInfoBox("timestamp:", (widget.data["timestamp"]!)),
              _buildInfoBox("Incident Location:", widget.data["Incident Location"]),
              _buildInfoBox("Incident Description:", widget.data["Incident Description"]),
              _buildInfoBox("Detailed Incident Report:", widget.data["Detailed Incident Report"]),
              _buildInfoBox("Police Report:", widget.data["Police Report"]),
              _buildInfoBox("Remarks:", widget.data["Remarks"]),

              // Display button to open image if available
              if (widget.data["Image"] != null && widget.data["Image"]!.isNotEmpty)
                _buildImageButton(widget.data["Image"]!),
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

  Widget _buildInfoBox(String title, String? data) {
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
