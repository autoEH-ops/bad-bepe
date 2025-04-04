import 'dart:io'; // Only include this for mobile
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'SubmitKeyManagementReportService.dart';

class KeyManagementCollectionReport extends StatefulWidget {
  const KeyManagementCollectionReport({
    super.key,
    required this.email,
    required this.role,
    required this.isCollect, // Differentiating between collection and return
  });

  final String email;
  final String role;
  final bool isCollect;

  @override
  State<KeyManagementCollectionReport> createState() =>
      _KeyManagementCollectionReportState();
}

class _KeyManagementCollectionReportState
    extends State<KeyManagementCollectionReport> {
  SubmitKeyManagementReportService submitKeyManagementReportService =
  SubmitKeyManagementReportService();

  List<XFile> imageUrls = [];
  List<String> availableKeys = []; // List of available keys
  String? selectedKey; // Selected key for the form

  // Controllers for other form fields
  TextEditingController serviceController = TextEditingController();
  TextEditingController icController = TextEditingController();
  TextEditingController remarksController = TextEditingController(); // New Remarks field

  // Form visibility
  bool showForm = false;

  @override
  void initState() {
    super.initState();
    _loadAvailableKeys();
  }

  Future<void> _loadAvailableKeys() async {
    List<String> keys = await submitKeyManagementReportService.fetchKeys(
      isCollect: widget.isCollect,
    );
    setState(() {
      availableKeys = keys;
    });
  }

  Future<void> _fetchLastKeyCollectionData(String key) async {
    if (!widget.isCollect) { // Only autofill on Key Return
      var lastCollectionData = await submitKeyManagementReportService
          .getLastKeyCollectionData(key);
      if (lastCollectionData != null) {
        setState(() {
          serviceController.text = lastCollectionData['serviceNumber'] ?? '';
          icController.text = lastCollectionData['icNumber'] ?? '';
        });
      } else {
        setState(() {
          serviceController.clear();
          icController.clear();
        });
      }
    }
  }

  Future<List<XFile>> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    setState(() {
      imageUrls.addAll(pickedImages);
    });
    return pickedImages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade900,
        title: Text(
          widget.isCollect ? "Key Collection" : "Key Return",
          style:
          const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose a Key',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            _buildKeySelection(),
            const SizedBox(height: 20),
            showForm ? _buildForm() : Container(),
          ],
        ),
      ),
    );
  }

  // Build the key selection section
  Widget _buildKeySelection() {
    return availableKeys.isEmpty
        ? const Center(child: Text('No available keys'))
        : Wrap(
      spacing: 10.0,
      runSpacing: 10.0,
      children: availableKeys.map((key) {
        return ChoiceChip(
          label: Text(key),
          selected: selectedKey == key,
          selectedColor: Colors.blue.shade100,
          backgroundColor: Colors.grey.shade300,
          onSelected: (bool selected) {
            setState(() {
              selectedKey = key;
              showForm = true; // Show form when key is selected
              if (!widget.isCollect) {
                _fetchLastKeyCollectionData(key); // Autofill if returning key
              }
            });
          },
        );
      }).toList(),
    );
  }

  // Build the form for collecting/returning keys
  Widget _buildForm() {
    return Expanded(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTextField('Mobile Number', serviceController,
                'Enter a valid mobile number'),
            const SizedBox(height: 20),
            _buildTextField('IC/Passport Number', icController,
                'Enter your IC or Passport number'),
            const SizedBox(height: 20),
            _buildTextField('Remarks', remarksController, 'Enter remarks'),
            // New Remarks field
            const SizedBox(height: 20),
            _buildPhotoUploadField(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // Helper to build text input fields
  Widget _buildTextField(String label, TextEditingController controller,
      String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
      ],
    );
  }

  // Helper to build photo upload field and display selected images
  Widget _buildPhotoUploadField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Upload Image of Key/ID',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            IconButton(
              onPressed: _pickImage,
              icon: Icon(Icons.image, size: 30, color: Colors.blue.shade900),
            ),
            const SizedBox(width: 10),
            const Text("Choose Images"),
          ],
        ),
        const SizedBox(height: 10),
        _buildSelectedImages(),
      ],
    );
  }

  // Display the selected images
  Widget _buildSelectedImages() {
    return imageUrls.isNotEmpty
        ? GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: imageUrls.length,
      itemBuilder: (BuildContext context, int index) {
        return Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: kIsWeb
              ? Image.network(imageUrls[index].path, fit: BoxFit.cover)
              : Image.file(File(imageUrls[index].path),
              fit: BoxFit.cover),
        );
      },
    )
        : const Text('No images selected');
  }

  // Build submit button with padding
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue.shade900,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: const Text(
          'Submit',
          style: TextStyle(fontSize: 16.0, color: Colors.white),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (selectedKey == null || selectedKey!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select a key to proceed')),
      );
      return;
    }

    await submitKeyManagementReportService.addKeyManagementReport(
      widget.email,
      imageUrls,
      serviceController.text,
      icController.text,
      selectedKey!,
      widget.isCollect,
      remarksController.text, // Add remarks here
    );

    await submitKeyManagementReportService.updateKeyStatus(
      selectedKey!,
      widget.isCollect,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Form submitted successfully')),
    );
    setState(() {
      selectedKey = null;
      showForm = false;
      serviceController.clear();
      icController.clear();
      remarksController.clear(); // Clear remarks after submission
      imageUrls.clear();
    });
  }
}
