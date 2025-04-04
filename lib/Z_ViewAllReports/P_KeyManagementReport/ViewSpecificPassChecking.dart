import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificPassCheckingPage extends StatefulWidget {
  const SpecificPassCheckingPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<SpecificPassCheckingPage> createState() =>
      _SpecificPassCheckingPageState();
}

class _SpecificPassCheckingPageState extends State<SpecificPassCheckingPage> {
  void _openImageUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  List<String> _extractImageUrls(String? imageData) {
    return imageData?.split(',').map((url) => url.trim()).toList() ?? [];
  }


  @override
  Widget build(BuildContext context) {
    final imageUrls = _extractImageUrls(widget.data["IMAGE"]);

    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text(
          "Pass Checking Report",
          style: TextStyle(color: Colors.black, fontSize: 18),
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
              _buildInfoBox("Report ID:", widget.data["ID"] ?? "No Data"),
              _buildInfoBox("Report by:", widget.data["email"] ?? "No Data"),
              _buildInfoBox("Key:", widget.data["key"] ?? "No Data"),
              _buildInfoBox("Phone:", widget.data["Phone"] ?? "No Data"),
              _buildInfoBox("IC:", widget.data["IC"] ?? "No Data"),
              _buildInfoBox("Remarks:", widget.data["Remarks"] ?? "No Data"),
              _buildInfoBox("Date and Time:", (widget.data["timestamp"] ?? "No Data")),

              if (imageUrls.isNotEmpty)
                Column(
                  children: imageUrls.map((url) => _buildImageButton(url)).toList(),
                ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildImageButton(String imageUrl) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
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
