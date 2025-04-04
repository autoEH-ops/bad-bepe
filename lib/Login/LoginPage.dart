import 'dart:math';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import '../DataFields/Accounts/AccountFields.dart';
import '/Login/LoginService.dart';
import '/UserMenuPages/AdminMainMenu.dart';
import '/UserMenuPages/SecurityMenu.dart';
import '/UserMenuPages/SuperAdminMainMenu.dart';
import '/UserMenuPages/ViewerManu.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with TickerProviderStateMixin {
  TextEditingController inputController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  String? countryCode;
  bool isEmailSelected = true;
  LoginService loginService = LoginService();
  AccountFieldsData? accountFieldsData;
  late AnimationController _titleController;
  late AnimationController _starsController;
  late AnimationController _lockIconController;
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _starsController = AnimationController(
      duration: const Duration(seconds: 15),
      vsync: this,
    )..repeat();

    _lockIconController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _starsController.dispose();
    _lockIconController.dispose();
    inputController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Future<void> requestOtp() async {
    String input = isEmailSelected ? inputController.text.trim() : phoneController.text.trim();

    if (input.isEmpty) {
      _showDialog("Empty", "Please enter a valid email or phone number.");
      return;
    }

    // Optionally, add more validation for email or phone number here

    accountFieldsData = await loginService.getData(
      isEmailSelected
          ? input
          : "$countryCode$input",
    );

    if (accountFieldsData != null) {
      // Assuming OTP is sent successfully
      _showOtpDialog();
    } else {
      _showDialog("Error", "Account doesn't exist.");
    }
  }

  Future<void> signIn(String otp) async {
    if (otp.length != 6) {
      _showDialog("Invalid OTP", "OTP must have 6 numbers.");
      return;
    }

    if (accountFieldsData != null) {
      String role = await loginService.login(
          otp, accountFieldsData!.email!);

      switch (role) {
        case "Super Admin":
          _navigateTo(SuperAdminMainMenu(
              email: accountFieldsData!.email, role: "Super Admin"));
          break;
        case "Admin":
          _navigateTo(
              AdminMainMenu(email: accountFieldsData!.email, role: "Admin"));
          break;
        case "Security":
          _navigateTo(SecurityMainMenu(
              email: accountFieldsData!.email, name: accountFieldsData!.name,));
          break;
        case "Viewer":
          _navigateTo(ViewerMenu(
              email: accountFieldsData!.email, name: accountFieldsData!.name));
          break;
        default:
          _showDialog(
              "Invalid OTP", "Please ensure you entered the correct OTP.");
      }
    } else {
      _showDialog("Error", "Please request OTP first.");
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(content),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showOtpDialog() {
    TextEditingController otpController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent closing the dialog by tapping outside
      builder: (context) => AlertDialog(
        title: const Text("Enter OTP"),
        content: TextField(
          controller: otpController,
          decoration: const InputDecoration(
            labelText: "OTP",
            hintText: "Enter the 6-digit OTP",
            prefixIcon: Icon(Icons.lock),
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
          maxLength: 6,
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              String otp = otpController.text.trim();
              Navigator.pop(context); // Close the dialog
              signIn(otp);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text("Login"),
          ),
        ],
      ),
    );
  }

  void _navigateTo(Widget destination) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => destination),
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double containerWidth = screenWidth < 600 ? screenWidth * 0.9 : 400; // Responsive container width

    return Scaffold(
      backgroundColor: Colors.lightBlueAccent, // Bright blue background
      body: Stack(
        children: [
          // Optional: Remove or adjust the starry background
          // _buildStarryBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedBuilder(
                      animation: _titleController,
                      builder: (context, child) {
                        return Text(
                          "Security System",
                          style: TextStyle(
                            color: Color.lerp(
                              Colors.white,
                              Colors.blueAccent,
                              0.5 + 0.5 * sin(_titleController.value * pi),
                            ),
                            fontSize: screenWidth < 600 ? 32 : 40, // Responsive font size
                            fontWeight: FontWeight.w100,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                    const SizedBox(height: 40),
                    Container(
                      padding: const EdgeInsets.all(20.0),
                      width: containerWidth,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.white, width: 2.0),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          AnimatedBuilder(
                            animation: _lockIconController,
                            builder: (context, child) {
                              return Icon(
                                Icons.lock,
                                size: screenWidth < 600 ? 60 : 80, // Responsive icon size
                                color: Color.lerp(
                                  Colors.black,
                                  Colors.blueAccent,
                                  _lockIconController.value,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          _buildEmailPhoneToggle(),
                          const SizedBox(height: 20),
                          isEmailSelected ? _buildEmailField() : _buildPhoneField(),
                          const SizedBox(height: 30),
                          _buildRequestOtpButton(), // Updated button
                        ],
                      ),
                    ),
                    const SizedBox(height: 10), // Add some space before the copyright text
                    AnimatedBuilder(
                      animation: _titleController,
                      builder: (context, child) {
                        return Text(
                          "COPYRIGHT (v2)",
                          style: TextStyle(
                            color: Color.lerp(
                              Colors.white,
                              Colors.blueAccent,
                              0.5 + 0.5 * sin(_titleController.value * pi),
                            ),
                            fontSize: screenWidth < 400 ? 20 : 10, // Responsive font size
                            fontWeight: FontWeight.w100,
                          ),
                          textAlign: TextAlign.center,
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStarryBackground() {
    return AnimatedBuilder(
      animation: _starsController,
      builder: (context, child) {
        return Stack(
          children: List.generate(30, (index) => _buildStar()),
        );
      },
    );
  }

  Widget _buildStar() {
    final size = _random.nextDouble() * 6 + 4;
    final x = _random.nextDouble() * MediaQuery.of(context).size.width;
    final y = _random.nextDouble() * MediaQuery.of(context).size.height;

    return Positioned(
      left: x,
      top: y,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildEmailPhoneToggle() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            setState(() {
              isEmailSelected = true;
              phoneController.clear();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: isEmailSelected ? Colors.blueAccent : Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.email, color: Colors.white),
                SizedBox(width: 8),
                Text("Email", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: () {
            setState(() {
              isEmailSelected = false;
              inputController.clear();
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              color: !isEmailSelected ? Colors.blueAccent : Colors.black,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: const [
                Icon(Icons.phone, color: Colors.white),
                SizedBox(width: 8),
                Text("Phone", style: TextStyle(color: Colors.white)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return TextField(
      controller: inputController,
      decoration: const InputDecoration(
        labelText: "Email",
        hintText: "Enter email",
        prefixIcon: Icon(Icons.email),
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.emailAddress,
    );
  }

  Widget _buildPhoneField() {
    return IntlPhoneField(
      controller: phoneController,
      disableLengthCheck: true, // Disable length validation
      decoration: const InputDecoration(
        labelText: "Phone",
        hintText: "Enter phone number",
        prefixIcon: Icon(Icons.phone),
        border: OutlineInputBorder(),
      ),
      initialCountryCode: 'MY',
      onChanged: (phone) {
        setState(() {
          countryCode = phone.countryCode;
        });
      },
    );
  }

  Widget _buildRequestOtpButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: requestOtp,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent, // Adjust if needed
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text(
          "Request OTP",
          style: TextStyle(
            fontSize: 16,
            color: Colors.white, // White text color
          ),
        ),
      ),
    );
  }
}
