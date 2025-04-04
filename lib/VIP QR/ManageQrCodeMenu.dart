import 'package:flutter/material.dart';

import '../Approve qr/ViewAllQrCode.dart';
import '../VIEW QR VIP/ViewAllQrCode.dart';
import 'QrGenerator.dart';


class QrvvMenuPage extends StatefulWidget {
  const QrvvMenuPage({super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  State<QrvvMenuPage> createState() => _QrvvMenuPage();
}

class _QrvvMenuPage extends State<QrvvMenuPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade900,
        title: const Text(
          "QR MANAGEMENT",
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
                      builder: (context) => const AllVVQrCodePage(email: '', role: '',)),
                );
              },
              buttonText: 'view & edit',
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.qr_code,
              title: 'Generate QR',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const QrvGeneratorPage()),
                );
              },
              buttonText: 'Generate QR',
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.qr_code,
              title: 'Approve QR',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const AllApprovePage()),
                );
              },
              buttonText: 'Approve QR',
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
