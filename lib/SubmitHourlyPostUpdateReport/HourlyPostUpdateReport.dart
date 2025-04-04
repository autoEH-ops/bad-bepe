import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../Components/TimeRelatedFunctions.dart';
import '../ManageGatePost/ManageGatePostService.dart';
import 'HourlyPostUpdateReportService.dart';

class SubmitHourlyGatePostReport extends StatefulWidget {
  const SubmitHourlyGatePostReport(
      {super.key, required this.email, required this.role});
  final String role;
  final String email;

  @override
  State<SubmitHourlyGatePostReport> createState() =>
      _SubmitHourlyGatePostReportState();
}

class _SubmitHourlyGatePostReportState
    extends State<SubmitHourlyGatePostReport> {
  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();
  ManageGatePostService manageGatePostService = ManageGatePostService();
  HourlyPostUpdateReportService hourlyPostUpdateReportService =
      HourlyPostUpdateReportService();

  List<String> hourlyPostLocations = [];
  String? selectedPost;
  List<XFile> hourlyPostImages = [];
  TextEditingController remarks = TextEditingController();

  bool validationError = false;
  bool validationError2 = false;
  bool validationError3 = false;
  bool validationError4 = false;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    try {
      hourlyPostLocations = await manageGatePostService.getAllGatePosts();

      if (mounted) {
        setState(() {});
      }
    } catch (e) {
      print('Error loading data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (hourlyPostLocations.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Hourly Report",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildSectionHeader("Current Hour"),
            const SizedBox(height: 10),
            _buildCurrentHour(),
            const SizedBox(height: 20),
            _buildPostSelection(),
            const SizedBox(height: 20),
            _buildPhotoUploadSection(),
            const SizedBox(height: 20),
            _buildRemarksSection(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
            const SizedBox(height: 25),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, fontSize: 18.0, color: Colors.white),
      ),
    );
  }

  Widget _buildCurrentHour() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Text(
        timeRelatedFunction.getCurrentHour(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16.0),
      ),
    );
  }

  Widget _buildPostSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: validationError ? Colors.red : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("List of Gate Posts"),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: hourlyPostLocations.length - 1,
            itemBuilder: (context, index) {
              String postName = hourlyPostLocations[index + 1];
              return RadioListTile(
                title: Text(postName),
                activeColor: Colors.green,
                value: postName,
                groupValue: selectedPost,
                onChanged: (value) {
                  setState(() {
                    selectedPost = value;
                    validationError = false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoUploadSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: validationError3 ? Colors.red : Colors.transparent),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader("Upload Photo"),
          GridView.builder(
            shrinkWrap: true,
            itemCount: hourlyPostImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () => _showImageDialog(hourlyPostImages[index].path),
                    child: kIsWeb
                        ? Image.network(hourlyPostImages[index].path)
                        : Image.file(File(hourlyPostImages[index].path),
                            fit: BoxFit.cover),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel, color: Colors.red),
                    onPressed: () {
                      setState(() {
                        hourlyPostImages.removeAt(index);
                      });
                    },
                  ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: _pickImage,
            icon: const Icon(Icons.image, size: 30, color: Colors.blue),
          ),
        ],
      ),
    );
  }

  Widget _buildRemarksSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.blue.shade100,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
            color: validationError4 ? Colors.red : Colors.transparent),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: TextFormField(
        controller: remarks,
        onChanged: (value) {
          validationError4 = false;
          setState(() {});
        },
        decoration: const InputDecoration(
          hintText: "Enter Remarks...",
          border: InputBorder.none,
        ),
        minLines: 3,
        maxLines: null,
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade700,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
        ),
        child: const Text("Submit Report",
            style: TextStyle(fontSize: 18.0, color: Colors.white)),
      ),
    );
  }

  void _submitForm() async {
    validationError = selectedPost == null;
    validationError3 = hourlyPostImages.isEmpty;
    validationError4 = remarks.text.isEmpty;

    if (validationError ||
        validationError2 ||
        validationError3 ||
        validationError4) {
      setState(() {});
      _showErrorDialog();
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
              Text('Submitting...'),
              SizedBox(height: 10),
              CircularProgressIndicator()
            ],
          ),
        );
      },
    );

    try {
      bool success = await hourlyPostUpdateReportService.addHourlyReport(
        widget.email,
        selectedPost!,
        hourlyPostImages,
        remarks.text,
      );

      Navigator.pop(context);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Report submitted successfully."),
        ));
        Navigator.pop(context);
      } else {
        _showErrorDialog();
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog();
    }
  }

  Future<List<XFile>> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    validationError3 = false;
    setState(() {
      hourlyPostImages.addAll(pickedImages);
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
          title: const Text("Incomplete Details"),
          content: const Text("Please ensure all required fields are filled."),
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
