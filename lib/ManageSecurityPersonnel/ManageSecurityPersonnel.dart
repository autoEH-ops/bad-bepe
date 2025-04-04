import 'package:flutter/material.dart';

import '../ManageSecurityPersonnel/ManageSecurityService.dart';

class ManageSecurityPersonnelPage extends StatefulWidget {
  const ManageSecurityPersonnelPage({super.key});

  @override
  State<ManageSecurityPersonnelPage> createState() =>
      _ManageSecurityPersonnelPageState();
}

class _ManageSecurityPersonnelPageState
    extends State<ManageSecurityPersonnelPage> {
  final TextEditingController textController = TextEditingController();
  final ManageSecurityService manageSecurityService = ManageSecurityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a), // Dark background color
      appBar: AppBar(
        title: const Text(
          'Manage Security Personnel',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0091EA),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {}); // Refresh page
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: manageSecurityService.getAllSecurityGuardDetails(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error loading security personnel',
                    style: TextStyle(color: Colors.white70)));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No Security Personnel Available',
                    style: TextStyle(color: Colors.white70)));
          } else {
            List<Map<String, dynamic>> securityDetails = snapshot.data!;
            return ListView.builder(
              itemCount: securityDetails.length,
              itemBuilder: (context, index) {
                String? name = securityDetails[index]['Name'];
                Map<String, dynamic> currentSecurityDetail =
                    securityDetails[index];

                if (currentSecurityDetail.isEmpty) {
                  return const SizedBox.shrink();
                }

                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 15.0, vertical: 10.0),
                  child: Center(
                    child: Container(
                      width: 800,
                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF0091EA), // Background for each item
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 20.0),
                        title: Text(
                          name ?? 'No name available',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          // Add functionality for tapping on each personnel item
                        },
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF1f293a),
          title: const Text(
            "Error",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(message, style: const TextStyle(color: Colors.white70)),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK", style: TextStyle(color: Colors.blue)),
            ),
          ],
        );
      },
    );
  }
}
