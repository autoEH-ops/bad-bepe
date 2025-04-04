import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'DutyVmsService.dart';  // Import the service

class DutyVmsReport extends StatefulWidget {
  const DutyVmsReport({super.key, required this.email, required this.role});

  final String email;
  final String role;

  @override
  State<DutyVmsReport> createState() => _DutyVmsReportState();
}

class _DutyVmsReportState extends State<DutyVmsReport> {
  final DutyVmsService dutyVmsService = DutyVmsService(); // Instance of the service
  final TextEditingController numberController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  List<Map<String, String?>> dutyPassList = [];
  String? selectedPass;
  String? selectedLocation;
  bool isLoading = true;
  bool showForm = false;
  XFile? icImage;

  @override
  void initState() {
    super.initState();
    _fetchDutyPassList();
  }

  // Fetch Duty Pass List using the service instance
  Future<void> _fetchDutyPassList() async {
    setState(() {
      isLoading = true;
    });
    dutyPassList = await dutyVmsService.fetchDutyPassList(); // Calling the service method here
    setState(() {
      isLoading = false;
    });
  }

  // Method to pick an image from the gallery
  Future<void> _pickImage(String type) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        icImage = pickedImage;
      });
    }
  }

  // Method to fill details for Pass Out
  Future<void> _fillDetailsForPassOut(String pass) async {
    final details = await dutyVmsService.getLastReportedDutyData(pass); // Service method to get pass details
    setState(() {
      numberController.text = details['Phone'] ?? '';
      icController.text = details['IC'] ?? '';
      nameController.text = details['names'] ?? '';
    });
  }

  // Method to submit the form
  void _submitForm() async {
    if (selectedPass == null ||
        selectedLocation == null ||
        nameController.text.trim().isEmpty || // Validate Name
        numberController.text.isEmpty ||
        icController.text.isEmpty ||
        icImage == null) {
      _showErrorDialog("Please fill in all required fields, including images.");
      return;
    }

    try {
      await dutyVmsService.updatePassStatus(selectedPass!, selectedLocation!, widget.email); // Service method to update pass status
      await dutyVmsService.submitForm(
        selectedPass!,
        selectedLocation!,
        numberController.text,
        icController.text,
        widget.email,
        icImage!,
        nameController.text,
        _showErrorDialog,
            (message) {
          _showSuccessDialog(message);
          _refreshPassList(); // Refresh the pass list after submission
        },
      );
    } catch (e) {
      _showErrorDialog("An error occurred: ${e.toString()}");
    }
  }

  // Method to refresh the pass list
  Future<void> _refreshPassList() async {
    setState(() {
      selectedPass = null; // Clear the selected pass to reset the dropdown
    });
    await _fetchDutyPassList();
  }

  // Error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  // Success dialog
  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Success"),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text("OK"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Visitor", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          children: [
            _buildToggleButtons(),
            if (showForm) Padding(padding: const EdgeInsets.all(16.0), child: _buildForm()),
          ],
        ),
      ),
    );
  }

  // Toggle buttons for selecting "Pass In" or "Pass Out"
  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton("Pass In", "Pass In"),
        _buildButton("Pass Out", "Pass Out"),
      ],
    );
  }

  // Build the button for Pass In/Out
  Widget _buildButton(String title, String location) {
    return ElevatedButton(
      onPressed: () async {
        setState(() {
          selectedLocation = location;
          selectedPass = null;
          showForm = true;
          numberController.clear();
          icController.clear();
          nameController.clear();
        });

        if (location == "Pass Out" && selectedPass != null) {
          await _fillDetailsForPassOut(selectedPass!);
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: selectedLocation == location ? Colors.blue : Colors.grey,
      ),
      child: Text(title),
    );
  }

  // Build the form
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Visitor Pass"),
        _buildDropdown(
          items: dutyPassList.map((pass) => pass['pass']!).toList(),
          value: selectedPass,
          hint: "Select a Visitor Pass",
          onChanged: (value) async {
            setState(() {
              selectedPass = value;
            });
            if (selectedLocation == "Pass Out" && value != null) {
              await _fillDetailsForPassOut(value);
            }
          },
        ),
        const SizedBox(height: 16),
        _buildTextField("Name", nameController, "Enter Name"),
        const SizedBox(height: 16),
        _buildTextField("Valid Malaysia Mobile Number", numberController, "Enter Numbers"),
        const SizedBox(height: 16),
        _buildTextField("IC / Passport Number", icController, "Enter IC Numbers"),
        const SizedBox(height: 16),
        _buildImagePickerButton("IC / Passport / License", () => _pickImage("IC"), icImage),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text("Click to Submit"),
        ),
      ],
    );
  }

  // Build the section title
  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  // Filtered duty pass list based on location
  List<Map<String, String?>> get filteredDutyPassList {
    // If no location is selected or dutyPassList is empty, return the full list
    if (selectedLocation == null || dutyPassList.isEmpty) {
      return dutyPassList;
    }


    return dutyPassList.where((pass) {
      // Extract the status field from the pass
      String? status = pass['status'];

      // For Pass In, we want to show Pass Out passes or those that are null
      if (selectedLocation == "Pass In") {
        return status == "Pass Out" || status == null;
      }
      // For Pass Out, we only want to show Pass In passes
      else if (selectedLocation == "Pass Out") {
        return status == "Pass In";
      }

      return false;  // If neither "Pass In" nor "Pass Out" is selected
    }).toList();
  }




  // Build dropdown for pass selection
  Widget _buildDropdown({
    required List<String> items,
    String? value,
    required String hint,
    required ValueChanged<String?> onChanged,
  }) {
    return DropdownButton<String>(
      value: value,
      hint: Text(hint),
      items: items.isNotEmpty
          ? items.map((pass) {
        return DropdownMenuItem(value: pass, child: Text(pass));
      }).toList()
          : [],
      onChanged: onChanged,
    );
  }

  // Build text field
  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
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

  // Build image picker button
  Widget _buildImagePickerButton(String title, VoidCallback onPressed, XFile? image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: Text(title),
        ),
        const SizedBox(height: 8),
        if (image != null)
          kIsWeb
              ? Image.network(
            image.path,
            height: 100,
          )
              : Image.file(
            File(image.path),
            height: 100,
          ),
      ],
    );
  }
}
