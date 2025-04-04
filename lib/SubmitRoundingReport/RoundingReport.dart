import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'RoundingReportService.dart';

class SubmitRoundingReport extends StatefulWidget {
  const SubmitRoundingReport(
      {super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  State<SubmitRoundingReport> createState() => _SubmitRoundingReportState();
}

class _SubmitRoundingReportState extends State<SubmitRoundingReport> {
  RoundingReportService roundingReportService = RoundingReportService();

  String previousRoundingPoint = "N/A";
  String currentRoundingPoint = "N/A";
  String previousRoundingTime = "N/A";
  List<XFile> roundingImages = [];
  TextEditingController remarksController = TextEditingController();
  bool validationError = false;
  bool validationError2 = false;

  @override
  void initState() {
    super.initState();
    _loadRoundingDetails();
  }

  Future<void> _loadRoundingDetails() async {
    Map<String, String> roundingDetails =
        await roundingReportService.getRoundingDetails(widget.email);
    setState(() {
      previousRoundingPoint = roundingDetails["previousRoundingPoint"] ?? "N/A";
      currentRoundingPoint = roundingDetails["currentRoundingPoint"] ?? "N/A";
      previousRoundingTime = roundingDetails["previousRoundingTime"] ?? "N/A";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Rounding Report Page",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTitleContainer("Rounding Reporting"),
              const SizedBox(height: 20),
              _buildInfoLine("Current Rounding Point: $currentRoundingPoint"),
              _buildInfoLine("Previous Rounding Point: $previousRoundingPoint"),
              _buildInfoLine("Previous Rounding Time: $previousRoundingTime"),
              const SizedBox(height: 20),
              _buildPhotoUploadSection(),
              const SizedBox(height: 20),
              _buildRemarksSection(),
              const SizedBox(height: 20),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTitleContainer(String title) {
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

  Widget _buildInfoLine(String text) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(text, style: const TextStyle(fontSize: 16.0)),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: validationError ? Colors.red : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 10.0),
            child: Text(
              "Upload Photo",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: roundingImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () {
                      _showImageDialog(roundingImages[index].path);
                    },
                    child: kIsWeb
                        ? Image.network(roundingImages[index].path)
                        : Image.file(File(roundingImages[index].path),
                            fit: BoxFit.cover),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        roundingImages.removeAt(index);
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
    );
  }

  Widget _buildRemarksSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.lightBlue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: validationError2 ? Colors.red : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: TextFormField(
          controller: remarksController,
          decoration: const InputDecoration(
            hintText: "Enter Remarks...",
            border: InputBorder.none,
          ),
          minLines: 3,
          maxLines: null,
        ),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.lightBlue.shade900,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            "Submit Report",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Future<void> _submitForm() async {
    if (roundingImages.isEmpty) {
      setState(() {
        validationError = true;
      });
      return;
    }

    if (remarksController.text.isEmpty) {
      setState(() {
        validationError2 = true;
      });
      return;
    }

    String reportId = await roundingReportService.generateReportId();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Submitting...'),
              SizedBox(height: 10),
              CircularProgressIndicator()
            ],
          ),
        );
      },
    );

    bool success = await roundingReportService.addRoundingReport(
      widget.email,
      currentRoundingPoint,
      roundingImages,
      remarksController.text,
      reportId,
    );

    Navigator.pop(context);

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Rounding report submitted successfully.")));
      Navigator.pop(context);
    } else {
      _showErrorDialog();
    }
  }

  Future<List<XFile>> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    setState(() {
      roundingImages.addAll(pickedImages);
    });
    return pickedImages;
  }

  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content:
              kIsWeb ? Image.network(imagePath) : Image.file(File(imagePath)),
        );
      },
    );
  }

  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submission Failed"),
          content: const Text("Something went wrong, please try again."),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("OK")),
          ],
        );
      },
    );
  }
}
