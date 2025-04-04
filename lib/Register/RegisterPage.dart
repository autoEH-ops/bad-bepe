import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

import '../GoogleAPIs/WhatsAppAPI.dart';
import '../Register/RegisterService.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key, required this.role, required this.email});
  final String role;
  final String email;
  @override
  State<RegisterPage> createState() => _RegisterPage();
}

class _RegisterPage extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final nameController = TextEditingController();
  String? selectedValue;
  String? countryCode;
  List<String> dropDownMenuItems = [];
  final RegisterService registerService = RegisterService();
  final WhatsAppAPI whatsAppAPI = WhatsAppAPI();

  late AnimationController _flashingController;




  @override
  void initState() {
    super.initState();
    setDropDownItems();
    _flashingController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  void setDropDownItems() {
    if (widget.role == "Super Admin") {
      dropDownMenuItems = ["Super Admin", "Admin", "Security", "Viewer"];
    } else if (widget.role == "Admin") {
      dropDownMenuItems = ["Security", "Viewer"];
    }
  }

  @override
  void dispose() {
    _flashingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _flashingController,
          builder: (context, child) {
            return Text(
              "Create Account",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.lerp(
                  Colors.white,
                  Colors.blueAccent,
                  0.5 + 0.5 * _flashingController.value,
                ),
              ),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0091EA),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _flashingController,
                  builder: (context, child) {
                    return Icon(
                      Icons.lock,
                      size: 100,
                      color: Color.lerp(Colors.white, Colors.blueAccent,
                          0.5 + 0.5 * _flashingController.value),
                    );
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Register Account',
                  style: TextStyle(fontSize: 18, color: Colors.white70),
                ),
                const SizedBox(height: 25),
                _buildInputField(
                  controller: emailController,
                  hintText: "Enter Email Address",
                ),
                const SizedBox(height: 10),
                _buildPhoneField(),
                const SizedBox(height: 10),
                _buildInputField(
                  controller: nameController,
                  hintText: "Enter Full Name",
                ),
                const SizedBox(height: 10),
                _buildDropdown(),
                const SizedBox(height: 25),
                _buildCreateAccountButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(
      {required TextEditingController controller, required String hintText}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        style: const TextStyle(color: Colors.black),
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade400),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent),
          ),
          fillColor: Colors.white,
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey.shade600),
        ),
      ),
    );
  }

  Widget _buildPhoneField() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: IntlPhoneField(
          disableLengthCheck: true,
          controller: phoneController,
          dropdownTextStyle: const TextStyle(color: Colors.black),
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            labelText: 'Mobile Number',
            labelStyle: TextStyle(color: Colors.grey),
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

  Widget _buildDropdown() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
        ),
        child: DropdownButton<String?>(
          isExpanded: true,
          dropdownColor: Colors.grey.shade100,
          value: selectedValue,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          onChanged: (value) {
            setState(() {
              selectedValue = value;
            });
          },
          underline: Container(),
          items: [
            DropdownMenuItem(
              value: null,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Text("Select Role",
                    style: TextStyle(color: Colors.grey.shade600)),
              ),
            ),
            ...dropDownMenuItems.map<DropdownMenuItem<String?>>(
              (e) => DropdownMenuItem(
                value: e,
                child: Text(e.toString(),
                    style: const TextStyle(color: Colors.black)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCreateAccountButton() {
    return GestureDetector(
      onTap: () async => await _onCreateAccount(),
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: const Color(0xFF0091EA),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 5,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _flashingController,
            builder: (context, child) {
              return Text(
                "Create Account",
                style: TextStyle(
                  color: Color.lerp(Colors.white, Colors.blueAccent,
                      0.5 + 0.5 * _flashingController.value),
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Future<void> _onCreateAccount() async {
    try {
      String emailInput = emailController.text.toLowerCase();
      String phoneInput = "$countryCode${phoneController.text}";

      if (emailController.text.isEmpty ||
          !emailController.text.contains("@") ||
          phoneController.text.length < 7 ||
          nameController.text.isEmpty ||
          selectedValue == null) {
        _showErrorDialog(
            "Invalid Details", "Please fill in all fields correctly");
      } else {
        _showLoadingDialog();

        bool exist = await registerService.checkEmailOrPhoneExist(
            emailInput, phoneInput);

        if (exist) {
          await _registerAccount(emailInput, phoneInput);
        } else {
          Navigator.pop(context);
          _showErrorDialog(
              "Account Exists", "Please enter another Email and Phone Number");
        }
      }
    } catch (e) {
      print("Error creating account: $e");
      Navigator.pop(context);
      _showErrorDialog(
          "Error", "An error occurred while creating the account.");
    }
  }

  Future<void> _registerAccount(String emailInput, String phoneInput) async {
    String createdByEmail = widget.email; // Get the creator's email
    String createdByName = await registerService.getNameByEmail(createdByEmail); // Get creator's name

    String createdBy = '$createdByName ($createdByEmail)'; // Format the creator's info

    if (selectedValue! == "Super Admin") {
      await registerService.addSuperAdmin(
          emailInput,
          nameController.text,
          phoneInput,
          selectedValue!,
          createdBy // Pass creator's details
      );
      await whatsAppAPI.adminCreateAccount(
          emailInput,
          nameController.text.toUpperCase(),
          selectedValue!,
          createdBy // Pass creator's details
      );
    } else if (selectedValue! == "Admin") {
      await registerService.addAdmin(
          emailInput,
          nameController.text,
          phoneInput,
          selectedValue!,
          createdBy // Pass creator's details
      );
      await whatsAppAPI.adminCreateAccount(
          emailInput,
          nameController.text.toUpperCase(),
          selectedValue!,
          createdBy // Pass creator's details
      );
    } else if (selectedValue! == "Security") {
      if (widget.role == "Super Admin") {
        await registerService.addSecurity(
            emailInput,
            nameController.text,
            phoneInput,
            selectedValue!,
            createdBy // Pass creator's details
        );
        await whatsAppAPI.adminCreateAccount(
            emailInput,
            nameController.text.toUpperCase(),
            selectedValue!,
            createdBy // Pass creator's details
        );
      } else {
        await registerService.addPendingList(
            emailInput,
            nameController.text,
            phoneInput,
            selectedValue!,
            createdBy // Pass creator's details
        );
        await whatsAppAPI.adminCreatePendingAccount(
            emailInput,
            nameController.text.toUpperCase(),
            selectedValue!,
            createdBy // Pass creator's details
        );
      }
    } else if (selectedValue! == "Viewer") {
      await registerService.addViewer(
          emailInput,
          nameController.text,
          phoneInput,
          selectedValue!,
          createdBy // Pass creator's details
      );
      await whatsAppAPI.adminCreateAccount(
          emailInput,
          nameController.text.toUpperCase(),
          selectedValue!,
          createdBy // Pass creator's details
      );
    }
    pop();
    pop();
  }


  void pop() => Navigator.pop(context);

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          title: Text(
            title,
            style: const TextStyle(color: Colors.white),
          ),
          content: Text(
            message,
            style: const TextStyle(color: Colors.white),
          ),
          actions: [
            TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text(
                  "OK",
                  style: TextStyle(color: Colors.blueAccent),
                )),
          ],
        );
      },
    );
  }

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                'Registering account',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 10),
              CircularProgressIndicator(
                color: Colors.white,
              ),
            ],
          ),
        );
      },
    );
  }
}
