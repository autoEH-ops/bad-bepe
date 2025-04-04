import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SpecificDriverPage extends StatefulWidget {
  const SpecificDriverPage({super.key, required this.data});

  final Map<String, dynamic> data;

  @override
  State<SpecificDriverPage> createState() => _SpecificDriverPageState();
}

class _SpecificDriverPageState extends State<SpecificDriverPage> {
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
    final imageUrls = _extractImageUrls(widget.data["Image"]);

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
              _buildInfoBox("Report ID:", widget.data["report id"] ?? "No Data"),
              _buildInfoBox("Report by:", widget.data["email"] ?? "No Data"),
              _buildInfoBox("Vehicle Pass:", widget.data["Driver Pass"] ?? "No Data"),
              _buildInfoBox("Pass Created:", widget.data["option pass"] ?? "No Data"),
              _buildInfoBox("Car Plate:", widget.data["carplate"] ?? "No Data"),
              _buildInfoBox("Status:", widget.data["location"] ?? "No Data"),
              _buildInfoBox("Phone:", widget.data["Phone"] ?? "No Data"),
              _buildInfoBox("IC:", widget.data["IC"] ?? "No Data"),
              _buildInfoBox("Date & Time:", widget.data["timestamp"] ?? "No Data"),

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
      padding: const EdgeInsets.only(top: 8.0),
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
