import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../SubmitSpotCheckReport/SpotCheckReportService.dart';

class SubmitSpotCheckReport extends StatefulWidget {
  const SubmitSpotCheckReport(
      {super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  State<SubmitSpotCheckReport> createState() => _SubmitSpotCheckReportState();
}

class _SubmitSpotCheckReportState extends State<SubmitSpotCheckReport> {
  SpotCheckReportService spotCheckReportService = SpotCheckReportService();

  // Controllers
  final TextEditingController timeController = TextEditingController();
  final TextEditingController spotCheckDes = TextEditingController();
  final TextEditingController spotCheckFin = TextEditingController();
  final TextEditingController remarksForClients = TextEditingController();
  final TextEditingController prepBy = TextEditingController();

  // Image storage
  List<XFile> spotCheckImages = [];

  // Error flags
  bool validationError1 = false;
  bool validationError2 = false;
  bool validationError3 = false;
  bool validationError4 = false;
  bool validationError5 = false;
  bool validationError6 = false;

  // Report data
  String lastSpotCheckId = "N/A";
  String lastSpotCheckDateTime = "N/A";

  @override
  void initState() {
    super.initState();
    _loadReportDetails();
  }

  Future<void> _loadReportDetails() async {
    final details =
        await spotCheckReportService.getLastSpotCheckDetails(widget.email);
    setState(() {
      lastSpotCheckId = details['lastSpotCheckId'] ?? "N/A";
      lastSpotCheckDateTime = details['lastSpotCheckDateTime'] ?? "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Spot Check Reporting",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildInfoLine("Last Spot Check ID: $lastSpotCheckId"),
            _buildInfoLine(
                "Last Spot Check Date and Time: $lastSpotCheckDateTime"),
            const SizedBox(height: 20),
            _buildTimePicker(),
            const SizedBox(height: 20),
            _buildTextInput("Spot Check Description", spotCheckDes,
                "Enter description...", validationError2),
            const SizedBox(height: 20),
            _buildTextInput("Spot Check Findings", spotCheckFin,
                "Enter findings...", validationError3),
            const SizedBox(height: 20),
            _buildTextInput("Remarks for Clients", remarksForClients,
                "Enter remarks...", validationError4),
            const SizedBox(height: 20),
            _buildTextInput(
                "Prepared By", prepBy, "Enter name...", validationError5),
            const SizedBox(height: 20),
            _buildPhotoUploadSection(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoLine(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(text, style: const TextStyle(fontSize: 16.0)),
      ),
    );
  }

  Widget _buildTimePicker() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextField(
        controller: timeController,
        decoration: InputDecoration(
          labelText: "Choose Time",
          labelStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18.0,
            color: Colors.lightBlue,
          ),
          filled: true,
          fillColor: Colors.lightBlue.shade100,
          prefixIcon: const Icon(Icons.access_time, color: Colors.lightBlue),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: validationError1 ? Colors.red : Colors.transparent,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(
              color: validationError1 ? Colors.red : Colors.transparent,
            ),
          ),
        ),
        readOnly: true,
        onTap: () => _selectTime(),
      ),
    );
  }

  Widget _buildTextInput(String label, TextEditingController controller,
      String hint, bool validationError) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18.0,
                color: Colors.black),
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.lightBlue.shade100,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                  color: validationError ? Colors.red : Colors.transparent),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: TextFormField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: hint,
                  border: InputBorder.none,
                ),
                minLines: 2,
                maxLines: null,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightBlue.shade100,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: validationError6 ? Colors.red : Colors.transparent,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTitle("Upload Photo"),
            GridView.builder(
              shrinkWrap: true,
              itemCount: spotCheckImages.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2),
              itemBuilder: (context, index) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _showImageDialog(spotCheckImages[index].path);
                      },
                      child: kIsWeb
                          ? Image.network(spotCheckImages[index].path)
                          : Image.file(File(spotCheckImages[index].path),
                              fit: BoxFit.cover),
                    ),
                    IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () {
                        setState(() {
                          spotCheckImages.removeAt(index);
                        });
                      },
                    ),
                  ],
                );
              },
            ),
            IconButton(
              onPressed: _pickImage,
              icon: const Icon(Icons.image, size: 30),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade900,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: _submitForm,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.lightBlue.shade900,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: const Padding(
            padding: EdgeInsets.symmetric(vertical: 15.0),
            child: Text(
              "Submit Report",
              style: TextStyle(fontSize: 18.0, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (timeController.text.isEmpty) validationError1 = true;
    if (spotCheckDes.text.isEmpty) validationError2 = true;
    if (spotCheckFin.text.isEmpty) validationError3 = true;
    if (remarksForClients.text.isEmpty) validationError4 = true;
    if (prepBy.text.isEmpty) validationError5 = true;
    if (spotCheckImages.isEmpty) validationError6 = true;

    if (validationError1 ||
        validationError2 ||
        validationError3 ||
        validationError4 ||
        validationError5 ||
        validationError6) {
      setState(() {});
      _showErrorDialog("Please ensure all required fields are filled.");
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Submitting report...'),
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );

    try {
      bool success = await spotCheckReportService.addSpotCheckReport(
        widget.email,
        timeController.text,
        spotCheckDes.text,
        spotCheckFin.text,
        remarksForClients.text,
        prepBy.text,
        spotCheckImages,
      );

      Navigator.pop(context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Report submitted successfully.")));
        Navigator.pop(context);
      } else {
        _showErrorDialog("Failed to submit report. Please try again.");
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog("An error occurred: $e");
    }
  }

  Future<void> _selectTime() async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: false),
            child: child!);
      },
    );

    if (picked != null) {
      setState(() {
        validationError1 = false;
        timeController.text = picked.format(context);
      });
    }
  }

  Future<List<XFile>> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    setState(() {
      validationError6 = false;
      spotCheckImages.addAll(pickedImages);
    });
    return pickedImages;
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
            content: kIsWeb
                ? Image.network(imagePath)
                : Image.file(File(imagePath)));
      },
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submission Error"),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
