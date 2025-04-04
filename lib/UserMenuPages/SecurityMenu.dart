import 'package:flutter/material.dart';
import '../Login/LoginPage.dart';
import '../ManageQrCodeGeneration/ManageQrCodeMenu.dart';
import '../ManageQrCodeGeneration/ScanQr.dart';
import '../SubmitEmergencyReport/EmergencyReport.dart';
import '../SubmitHourlyPostUpdateReport/HourlyPostUpdateReport.dart';
import '../SubmitKeyManagementReport/SubmitKeyManagementReportMenu.dart';
import '../SubmitRollCallReport/RollCallReport.dart';
import '../SubmitRoundingReport/RoundingReport.dart';
import '../SubmitSpotCheckReport/SpotCheckReport.dart';
import '../SubmitVmsReport/SubmitVmsReportMenu.dart';
import 'package:flutter/material.dart';


class SecurityMainMenu extends StatefulWidget {
  const SecurityMainMenu(
      {super.key, required this.email, required this.name, this.role});
  final String? email;
  final String? name;
  final String? role;

  @override
  State<SecurityMainMenu> createState() => _SecurityMainMenuState();
}

class _SecurityMainMenuState extends State<SecurityMainMenu>
    with SingleTickerProviderStateMixin {
  late AnimationController _titleController;
  List<String> reportTitles = [
    'Hourly Post',
    'Roll Call',
    'Rounding',
    'Emergency',
    'Spot Check',
    'VMS',
    'QR',
    'Key Management System',
  ];

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _titleController,
          builder: (context, child) {
            return Text(
              "Security Menu",
              style: TextStyle(
                color: Color.lerp(
                  Colors.white,
                  Colors.blueAccent,
                  0.5 + 0.5 * _titleController.value,
                ),
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0091EA),
        leading: widget.role == "Super Admin"
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        )
            : null,
      ),
      backgroundColor: const Color(0xFF1f293a),
      drawer: _buildDrawer(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            _buildReportListBox(),
          ],
        ),
      ),
    );
  }

  Widget _buildReportListBox() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5.0),
      child: Center(
        child: Container(
          width: 800,
          decoration: BoxDecoration(
            color: const Color(0xFF0091EA),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Padding(
                      padding: EdgeInsets.only(left: 15),
                      child: Text(
                        "Available Duty",
                        style: TextStyle(
                          fontSize: 25.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    _buildScannerButton(), // Add the scanner button beside "Available Duty"
                  ],
                ),
              ),
              const Divider(color: Colors.white70, thickness: 1.5),
              ..._buildReportList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildScannerButton() {
    return GestureDetector(
      onTap: () {
        _navigateToScanQrPage();
      },
      child: Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF6A1B9A), Color(0xFFAB47BC)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Row(
          children: const [
            Icon(Icons.qr_code_scanner, color: Colors.white),
            SizedBox(width: 5),
            Text(
              'QR Scanner',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _navigateToScanQrPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanQrPage(email: widget.email!),
      ),
    );
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0091EA),
      child: ListView(
        children: [
          const DrawerHeader(
            child: Center(
              child: Text(
                "Side Menu",
                style: TextStyle(fontSize: 20, color: Colors.white),
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.exit_to_app_rounded, color: Colors.white),
            title: const Text("Log Out",
                style: TextStyle(fontSize: 20, color: Colors.white)),
            onTap: navigateToLoginPage,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildReportList() {
    return reportTitles.map((reportTitle) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
        child: GestureDetector(
          onTap: () {
            navigationFunction(reportTitle);
          },
          child: MouseRegion(
            cursor: SystemMouseCursors.click,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                border: Border.all(color: const Color(0xFF0091EA)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Center(
                  child: Text(
                    reportTitle,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
    }).toList();
  }

  void navigationFunction(String menu) {
    if (menu == "Hourly Post") {
      navigateToSubmitHourlyReport();
    } else if (menu == "Roll Call") {
      navigateToSubmitRollCallReport();
    } else if (menu == "Rounding") {
      navigateToSubmitRoundingReport();
    } else if (menu == "Emergency") {
      navigateToSubmitEmergencyReport();
    } else if (menu == "Spot Check") {
      navigateToSubmitSpotCheckReport();
    } else if (menu == "VMS") {
      navigateToInOutMenu();
    } else if (menu == "QR") {
      navigateToGenerateVisitorPass();
    } else if (menu == "Key Management System") {
      navigateToKeyManagementReport();
    }
  }

  void navigateToSubmitHourlyReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubmitHourlyGatePostReport(
                email: widget.email!, role: "Security")));
  }

  void navigateToSubmitRollCallReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SubmitRollCallReport(email: widget.email!, role: "Security")));
  }

  void navigateToSubmitRoundingReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SubmitRoundingReport(email: widget.email!, role: "Security")));
  }

  void navigateToSubmitEmergencyReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SubmitEmergencyReport(email: widget.email!, role: "Security")));
  }

  void navigateToSubmitSpotCheckReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SubmitSpotCheckReport(email: widget.email!, role: "Security")));
  }

  void navigateToInOutMenu() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                SubmitVmsReportMenu(email: widget.email!, role: "Security")));
  }

  void navigateToGenerateVisitorPass() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                QrMenuPage(email: widget.email!, role: "Security")));
  }

  void navigateToKeyManagementReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubmitKeyManagementReportMenu(
                email: widget.email!, role: "Security")));
  }

  void navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) => false,
    );
  }
}
