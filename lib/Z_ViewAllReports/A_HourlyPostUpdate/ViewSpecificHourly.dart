import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../Components/TimeRelatedFunctions.dart';

class SpecificHourlyPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const SpecificHourlyPage({super.key, required this.data});

  void _openImageUrl(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  String _getFormattedTimestamp(String? timestamp) {
    return timestamp ?? "Invalid Timestamp";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text('Report Details',
            style: TextStyle(color: Colors.black, fontSize: 20)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              _buildDetailBox("Report ID:", data['Report ID'] ?? 'No Data'),
              _buildDetailBox("Report By:", data['ID email'] ?? 'No Data'),
              _buildDetailBox("Gate Post:", data['Gate post'] ?? 'No Data'),
              _buildDetailBox(
                  "Date and Time:", _getFormattedTimestamp(data['timestamp'])),
              _buildDetailBox("Remarks:", data['REmake'] ?? 'No Data'),
              if (data['image'] != null && data['image']!.isNotEmpty) ...[
                const Text("Images:", style: TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                _buildImageButtons(data['image']),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 16.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildCurrentHour() {
    final timeRelatedFunction = TimeRelatedFunction();
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Text(
        timeRelatedFunction.getCurrentHour(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
      ),
    );
  }

  Widget _buildImageButtons(String imageUrls) {
    final urls = imageUrls.split(',').map((url) => url.trim()).toList();
    return Wrap(
      spacing: 6.0,
      runSpacing: 4.0,
      children: urls.map((url) {
        return TextButton(
          onPressed: () => _openImageUrl(url),
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(
                horizontal: 12.0, vertical: 6.0),
          ),
          child: const Text('Open Image', style: TextStyle(fontSize: 14)),
        );
      }).toList(),
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