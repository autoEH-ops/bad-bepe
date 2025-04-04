import 'package:flutter/material.dart';

import 'SubmitKeyCollectionReport/SubmitKeyManagementReport.dart';

class SubmitKeyManagementReportMenu extends StatelessWidget {
  const SubmitKeyManagementReportMenu(
      {super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text(
          "Key Management",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.blue.shade900,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildManagementOption(
                context,
                label: 'KEY COLLECTION',
                icon: Icons.exit_to_app_rounded,
                description: 'Key Collection',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KeyManagementCollectionReport(
                        email: email,
                        role: role,
                        isCollect: true,
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 20),
              _buildManagementOption(
                context,
                label: 'RETURN KEY',
                icon: Icons.keyboard_return,
                description: 'Return Key',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => KeyManagementCollectionReport(
                        email: email,
                        role: role,
                        isCollect: false,
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Build a reusable container widget for key collection and return options
  Widget _buildManagementOption(
    BuildContext context, {
    required String label,
    required IconData icon,
    required String description,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue.shade800,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 10),
              Icon(icon, size: 28, color: Colors.white),
            ],
          ),
          const SizedBox(height: 20),
          GestureDetector(
            onTap: onTap,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 15),
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, color: Colors.blue.shade800),
                  const SizedBox(width: 10),
                  Text(
                    description,
                    style: const TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
