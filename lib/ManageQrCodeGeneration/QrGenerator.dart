import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'QrGeneratorService.dart';
import 'QrPageSummary.dart';
import 'package:image_picker/image_picker.dart';

class QrGeneratorPage extends StatefulWidget {
  const QrGeneratorPage({super.key});

  @override
  State<QrGeneratorPage> createState() => _QrGeneratorPageState();
}

class _QrGeneratorPageState extends State<QrGeneratorPage> {
  final formKey = GlobalKey<FormState>();
  final QrGeneratorService qrGeneratorService = QrGeneratorService();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController carPlateController = TextEditingController();
  final TextEditingController numberController = TextEditingController();
  final TextEditingController startDateController = TextEditingController();
  final TextEditingController endDateController = TextEditingController();
  final TextEditingController emailController = TextEditingController();

  String? selectedCategory;
  String? countryCode;
  bool _showCarPlateUpload = false;

  final categoryOptions = [
    'Contractor Pass',
    'Duty Pass',
    'Supplier Pass',
    'Drive Pass',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Generate QR Code", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade900,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              _buildSectionHeader("Select Category"),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                items: categoryOptions.map((String category) {
                  return DropdownMenuItem<String>(
                    value: category,
                    child: Text(category),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Car Plate section (added under IC/Passport)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _showCarPlateUpload ? 'Hide Car Plate Upload' : 'Show Car Plate Upload',
                    style: const TextStyle(fontSize: 16),
                  ),
                  Switch(
                    value: _showCarPlateUpload,
                    onChanged: (value) {
                      setState(() {
                        _showCarPlateUpload = value;
                      });
                    },
                  ),
                ],
              ),
              if (_showCarPlateUpload) ...[
                const SizedBox(height: 10),
                _buildSectionHeader("Enter Car Plate"),
                _buildTextInputField(
                  controller: carPlateController,
                  hintText: "Enter Car Plate",
                  prefixIcon: Icons.directions_car,
                ),
                const SizedBox(height: 20),
              ],

              // IC Number Field
              const SizedBox(height: 20),
              _buildSectionHeader("Enter IC Number"),
              _buildTextInputField(
                controller: icController,
                hintText: "Enter IC Number",
                prefixIcon: Icons.credit_card,
              ),
              const SizedBox(height: 20),

              // Name Field
              _buildSectionHeader("Enter Name"),
              _buildTextInputField(
                controller: nameController,
                hintText: "Enter Name",
                prefixIcon: Icons.person,
              ),
              const SizedBox(height: 20),

              // Phone Number Field
              _buildSectionHeader("Enter Phone Number"),
              _buildPhoneNumberField(),
              const SizedBox(height: 20),

              // Email Address Field
              _buildSectionHeader("Enter Email Address"),
              _buildTextInputField(
                controller: emailController,
                hintText: "Enter Email",
                prefixIcon: Icons.email,
              ),
              const SizedBox(height: 20),

              // Start and End Date Fields
              _buildSectionHeader("Select Date (Start & End)"),
              _buildDateField(
                controller: startDateController,
                hintText: 'Start Date',
                onTap: selectStartDate,
              ),
              const SizedBox(height: 10),
              _buildDateField(
                controller: endDateController,
                hintText: 'End Date',
                onTap: selectEndDate,
              ),
              const SizedBox(height: 20),

              // Generate VMS Pass Button
              GestureDetector(
                onTap: () {
                  if (formKey.currentState!.validate()) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => QrSummary(
                          icNum: icController.text,
                          name: nameController.text,
                          number: "$countryCode${numberController.text}",
                          carPlate: carPlateController.text,
                          startDate: startDateController.text,
                          endDate: endDateController.text,
                          email: emailController.text,
                          category: selectedCategory ?? '',
                        ),
                      ),
                    );
                  } else {
                    formKey.currentState!.validate();
                  }
                },
                child: Container(
                  height: 50,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.lightBlue.shade900,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      'Generate VMS Pass',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }


  // Helper method to build section headers
  Widget _buildSectionHeader(String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      color: Colors.black,
      child: Text(
        title,
        style: const TextStyle(
            fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  // Helper method to build text input fields
  Widget _buildTextInputField({
    required TextEditingController controller,
    required String hintText,
    required IconData prefixIcon,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            border: InputBorder.none,
            prefixIcon: Icon(prefixIcon),
          ),
          validator: validator,
        ),
      ),
    );
  }

  // Helper method to build phone number field using IntlPhoneField
  Widget _buildPhoneNumberField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: IntlPhoneField(
          disableLengthCheck: true,
          controller: numberController,
          decoration: const InputDecoration(
            counter: Offstage(),
            labelText: 'Mobile Number',
            border: InputBorder.none,
          ),
          initialCountryCode: 'MY',
          showDropdownIcon: true,
          dropdownIconPosition: IconPosition.trailing,
          onChanged: (phone) {
            countryCode = phone.countryCode;
          },
        ),
      ),
    );
  }

  // Helper method to build date picker fields
  Widget _buildDateField({
    required TextEditingController controller,
    required String hintText,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(8),
        ),
        child: TextFormField(
          controller: controller,
          readOnly: true,
          onTap: onTap,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(fontSize: 14),
            prefixIcon: const Icon(Icons.date_range),
            border: InputBorder.none,
          ),
          validator: (value) => value!.isEmpty ? 'Please pick a date' : null,
        ),
      ),
    );
  }

  // Method to select start date
  void selectStartDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        startDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }

  // Method to select end date
  void selectEndDate() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        endDateController.text = "${pickedDate.toLocal()}".split(' ')[0];
      });
    }
  }
}