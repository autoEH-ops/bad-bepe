import 'package:flutter/material.dart';

import 'QrGenerator.dart';
import 'ScanQr.dart';
import 'ViewAllQrCode.dart';

class QrMenuPage extends StatefulWidget {
  const QrMenuPage({super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  State<QrMenuPage> createState() => _QrMenuPageState();
}

class _QrMenuPageState extends State<QrMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade900,
        title: const Text(
          "Visitor QR Menu",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildMenuOption(
              icon: Icons.remove_red_eye,
              title: 'View QR',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllQrCodePage()),
                );
              },
              buttonText: 'View All Qr',
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.qr_code,
              title: 'Generate QR',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QrGeneratorPage()),
                );
              },
              buttonText: 'Generate VMS QR Codes',
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.qr_code_scanner_rounded,
              title: 'Scan QR',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ScanQrPage(email: widget.email)),
                );
              },
              buttonText: 'Scan VMS QR Codes',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Icon(icon, size: 35, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
