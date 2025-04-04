import 'package:flutter/material.dart';

import '/ManageAccounts/ManageAccountService.dart';

class ManageAccountPage extends StatefulWidget {
  const ManageAccountPage({super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  State<ManageAccountPage> createState() => _ManageAccountPageState();
}

class _ManageAccountPageState extends State<ManageAccountPage>
    with SingleTickerProviderStateMixin {
  final ManageAccountService manageAccountService = ManageAccountService();
  late AnimationController _titleController;

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
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _titleController,
          builder: (context, child) {
            return Text(
              'Manage Personnel',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color.lerp(Colors.white, Colors.blueAccent,
                    0.5 + 0.5 * _titleController.value),
              ),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0091EA),
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
        future: manageAccountService.getAllAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No data available',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            );
          } else {
            List<Map<String, dynamic>> accounts = snapshot.data!;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                final account = accounts[index];

                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: Center(
                    child: Container(
                      width: 800,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF0091EA)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                account['Name'] ?? 'No name',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                account['Email'] ?? 'No Email',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                account['Phone'] ?? 'No Phone',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                              Text(
                                account['Role'] ?? 'Role',
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_forever,
                              color: Colors.redAccent),
                          onPressed: () {
                            _showConfirmationDialog(context, account);
                          },
                        ),
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

  // Helper function to show the confirmation dialog
  void _showConfirmationDialog(
      BuildContext context, Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Confirm Account Deletion?"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Close confirmation dialog
                bool success = await _deleteAccount(account);

                if (success) {
                  setState(() {}); // Refresh UI
                } else {
                  _showErrorDialog(context, "Failed to delete account.");
                }
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  // Helper function to handle account deletion
  Future<bool> _deleteAccount(Map<String, dynamic> account) async {
    try {
      String email = account['Email']?.toString() ?? '';
      String name = account['Name']?.toString() ?? '';

      return await manageAccountService.deleteSpecificPageRow(email, name);
    } catch (e) {
      print("Error during account deletion: $e");
      return false;
    }
  }

  // Show error dialog
  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Error"),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
