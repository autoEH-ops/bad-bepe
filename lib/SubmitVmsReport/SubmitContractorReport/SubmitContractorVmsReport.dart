import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'ContractorVmsService.dart';

class ContractorVmsReport extends StatefulWidget {
  const ContractorVmsReport({super.key, required this.email, required this.role});

  final String email;
  final String role;

  @override
  State<ContractorVmsReport> createState() => _ContractorVmsReportState();
}

class _ContractorVmsReportState extends State<ContractorVmsReport> {
  final ContractorVmsService contractorVmsService = ContractorVmsService();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  List<Map<String, String?>> contractorPassList = [];
  String? selectedPass;
  String? selectedLocation;
  bool isLoading = true;
  bool showForm = false;
  XFile? icImage;

  @override
  void initState() {
    super.initState();
    _fetchContractorPassList();
  }

  Future<void> _fetchContractorPassList() async {
    setState(() {
      isLoading = true;
    });
    contractorPassList = await contractorVmsService.fetchContractorPassList();
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

  Future<void> _fillDetailsForPassOut(String pass) async {
    final details = await contractorVmsService.getLatestPassInDetails(pass);
    setState(() {
      numberController.text = details['number'] ?? '';
      icController.text = details['ic'] ?? '';
      nameController.text = details['name'] ?? '';
    });
  }

  void _submitForm() async {
    if (selectedPass == null ||
        selectedLocation == null ||
        nameController.text.trim().isEmpty || // Validate Name
        numberController.text.trim().isEmpty ||
        icController.text.trim().isEmpty ||
        icImage == null) {
      _showErrorDialog("Please fill in all required fields, including images.");
      return;
    }

    try {
      // Update Pass Status
      await contractorVmsService.updatePassStatus(selectedPass!, selectedLocation!, widget.email);

      // Submit Form with Name
      await contractorVmsService.submitForm(
        selectedPass!,
        selectedLocation!,
        numberController.text.trim(),
        icController.text.trim(),
        widget.email,
        icImage!,
        nameController.text.trim(), // Pass Name
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


  Future<void> _refreshPassList() async {
    setState(() {
      selectedPass = null; // Clear the selected pass to reset the dropdown
    });
    await _fetchContractorPassList();
  }

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
        title: const Text("Contractor VMS Report", style: TextStyle(color: Colors.black)),
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

  Widget _buildToggleButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildButton("Pass In", "Pass In"),
        _buildButton("Pass Out", "Pass Out"),
      ],
    );
  }

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

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle("Contractor VMS Pass"),

        // Existing Dropdown
        _buildDropdown(
          items: filteredContractorPassList.map((pass) => pass['pass']!).toList(),
          value: selectedPass,
          hint: "Select a Contractor Pass",
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

        // New Name TextField
        _buildTextField("Name", nameController, "Enter Name"),

        const SizedBox(height: 16),

        // Existing Fields
        _buildTextField("Valid Malaysia Mobile Number", numberController, "Enter Numbers"),
        const SizedBox(height: 16),
        _buildTextField("IC / Passport Number", icController, "Enter IC Numbers"),
        const SizedBox(height: 16),
        _buildImagePickerButton("IC / Passport / License", () => _pickImage("IC"), icImage),
        const SizedBox(height: 16),

        // Submit Button
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text("Click to Submit"),
        ),
      ],
    );
  }


  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
    );
  }

  List<Map<String, String?>> get filteredContractorPassList {
    if (selectedLocation == null) {
      return contractorPassList;
    }

    return contractorPassList.where((pass) {
      return (selectedLocation == "Pass In" && (pass['status'] == "Pass Out" || pass['status'] == null)) ||
          (selectedLocation == "Pass Out" && pass['status'] == "Pass In");
    }).toList();
  }

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
