import 'dart:io'; // Required for File
import 'package:flutter/foundation.dart'; // For kIsWeb
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../Components/TimeRelatedFunctions.dart';
import '../ManageEmergencyLocation/ManageEmergencyLocationService.dart';
import 'EmergencyReportService.dart';

class SubmitEmergencyReport extends StatefulWidget {
  const SubmitEmergencyReport(
      {super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  State<SubmitEmergencyReport> createState() => _SubmitEmergencyReportState();
}

class _SubmitEmergencyReportState extends State<SubmitEmergencyReport> {
  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();
  ManageEmergencyLocationService manageEmergencyLocationService = ManageEmergencyLocationService();
  EmergencyReportService emergencyReportService = EmergencyReportService();

  String? selectedLocation;
  List<String> emergencyLocations = [];
  List<XFile> emergencyImages = [];
  String? policeReportOption; // New variable for Police Report option

  final TextEditingController dateController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  final TextEditingController incident = TextEditingController();
  final TextEditingController detailReport = TextEditingController();
  final TextEditingController remarksController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    emergencyLocations =
    await manageEmergencyLocationService.getAllEmergencyLocations();
    setState(() {});
  }

  Widget _buildDateField() {
    return TextField(
      controller: dateController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Incident Date",
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        prefixIcon: const Icon(Icons.calendar_today, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      readOnly: true,
      onTap: _selectDate, // This method opens the date picker
    );
  }

  Future<void> _selectDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        dateController.text =
        "${pickedDate.year}-${pickedDate.month.toString().padLeft(
            2, '0')}-${pickedDate.day.toString().padLeft(2, '0')}";
      });
    } else if (dateController.text.isEmpty) {
      // Set a fallback default date
      dateController.text =
      "${DateTime
          .now()
          .year}-${DateTime
          .now()
          .month
          .toString()
          .padLeft(2, '0')}-${DateTime
          .now()
          .day
          .toString()
          .padLeft(2, '0')}";
    }
  }

  Widget _buildTimeField() {
    return TextField(
      controller: timeController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Incident Time",
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        prefixIcon: const Icon(Icons.access_time, color: Colors.grey),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      readOnly: true,
      onTap: _selectTime, // Open time picker on tap
    );
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        timeController.text = pickedTime.format(context);
      });
    } else if (timeController.text.isEmpty) {
      // Set a fallback default time
      timeController.text = TimeOfDay.now().format(context);
    }
  }

  Widget _buildLocationDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        hint: const Text("Select Location"),
        value: selectedLocation,
        onChanged: (value) {
          setState(() {
            selectedLocation = value;
          });
        },
        items: emergencyLocations.map((location) {
          return DropdownMenuItem(value: location, child: Text(location));
        }).toList(),
      ),
    );
  }

  Widget _buildIncidentField() {
    return TextField(
      controller: incident,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Incident Description",
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      maxLines: 4,
    );
  }

  Widget _buildDetailsField() {
    return TextField(
      controller: detailReport,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Detailed Report",
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      maxLines: 5,
    );
  }

  Widget _buildRemarksField() {
    return TextField(
      controller: remarksController,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white,
        labelText: "Remarks",
        labelStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Colors.blue),
        ),
      ),
      maxLines: 3,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf0f4f8),
      appBar: AppBar(
        title: const Text(
          "Emergency Report",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0091EA),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDateField(),
            const SizedBox(height: 15),
            _buildTimeField(),
            const SizedBox(height: 15),
            _buildLocationDropdown(),
            const SizedBox(height: 15),
            _buildIncidentField(),
            const SizedBox(height: 15),
            _buildDetailsField(),
            const SizedBox(height: 15),
            _buildRemarksField(), // Add Remarks field here
            const SizedBox(height: 15),
            _buildPoliceReportOption(),
            if (policeReportOption == 'YES') const SizedBox(height: 15),
            if (policeReportOption == 'YES') _buildImageUploader(),
            const SizedBox(height: 20),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  // New method to build Police Report option
  Widget _buildPoliceReportOption() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Police Report",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        Row(
          children: [
            Radio<String>(
              value: "YES",
              groupValue: policeReportOption,
              onChanged: (value) {
                setState(() {
                  policeReportOption = value;
                });
              },
            ),
            const Text("YES"),
            Radio<String>(
              value: "NO",
              groupValue: policeReportOption,
              onChanged: (value) {
                setState(() {
                  policeReportOption = value;
                  emergencyImages.clear(); // Clear images if NO is selected
                });
              },
            ),
            const Text("NO"),
          ],
        ),
      ],
    );
  }

  Widget _buildImageUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Images",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 150,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemCount: emergencyImages.length,
            itemBuilder: (context, index) {
              return Stack(
                children: [
                  kIsWeb
                      ? Image.network(
                      emergencyImages[index].path, fit: BoxFit.cover)
                      : Image.file(
                      File(emergencyImages[index].path), fit: BoxFit.cover),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: IconButton(
                      icon: const Icon(Icons.cancel, color: Colors.red),
                      onPressed: () {
                        setState(() {
                          emergencyImages.removeAt(index);
                        });
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        IconButton(
          icon: const Icon(Icons.camera_alt, color: Colors.blue),
          onPressed: _pickImage,
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _submitForm,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0091EA),
          padding: const EdgeInsets.symmetric(vertical: 15),
        ),
        child: const Text("Submit Report", style: TextStyle(fontSize: 18)),
      ),
    );
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFiles = await picker.pickMultiImage();
    setState(() {
      emergencyImages.addAll(pickedFiles);
    });
  }

  void _submitForm() async {
    // Optionally, you can remove or repurpose these controllers if not needed elsewhere
    /*
  if (dateController.text.isEmpty) {
    dateController.text =
        "${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}";
  }
  if (timeController.text.isEmpty) {
    timeController.text = TimeOfDay.now().format(context);
  }

  print("Submitting Date: ${dateController.text}");
  print("Submitting Time: ${timeController.text}");
  */

    if (selectedLocation == null ||
        incident.text.isEmpty ||
        detailReport.text.isEmpty ||
        (policeReportOption == 'YES' && emergencyImages.isEmpty)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields.")),
      );
      return;
    }

    // Proceed with form submission
    // String date = dateController.text; // Removed
    // String time = timeController.text; // Removed
    String location = selectedLocation!;
    String incidentDescription = incident.text;
    String detail = detailReport.text;
    String remarks = remarksController.text;

    bool success = await emergencyReportService.addEmergencyReport(
      widget.email,
      emergencyImages,
      location,
      incidentDescription,
      detail,
      policeReportOption ?? 'NO',
      remarks,
    );

    if (success) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error submitting report.")),
      );
    }
  }
}