import 'package:created_by_618_abdo/GoogleAPIs/WhatsAppAPI.dart';
import 'package:flutter/material.dart';

import '/ManagePendingList/ManagePendingListService.dart';

class ManagePendingPage extends StatefulWidget {
  const ManagePendingPage({super.key, required this.email});
  final String email;

  @override
  State<ManagePendingPage> createState() => _ManagePendingPageState();
}

class _ManagePendingPageState extends State<ManagePendingPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController textController = TextEditingController();
  final WhatsAppAPI whatsAppAPI = WhatsAppAPI();
  final ManagePendingListService managePendingListService =
      ManagePendingListService();
  late AnimationController _titleController;

  @override
  void initState() {
    super.initState();
    loadData();
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

  void loadData() async {
    await managePendingListService.checkAndCreateDocument();
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
              "Pending Lists",
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
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: managePendingListService.getAllPending(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator(color: Colors.white));
          } else if (snapshot.hasError ||
              snapshot.data == null ||
              snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No Pending List Available',
                    style: TextStyle(color: Colors.white)));
          } else {
            List<Map<String, dynamic>> accounts = snapshot.data!;
            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
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
                      title: Padding(
                        padding: const EdgeInsets.only(left: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildInfoText(
                                "Name", accounts[index]['Name'] ?? 'No name'),
                            _buildInfoText("Email",
                                accounts[index]['Email'] ?? 'No Email'),
                            _buildInfoText("Phone",
                                accounts[index]['Phone'] ?? 'No Phone'),
                            _buildInfoText(
                                "Role", accounts[index]['Role'] ?? 'No Role'),
                          ],
                        ),
                      ),
                      trailing: _buildActionButtons(context, accounts, index),
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

  Widget _buildInfoText(String label, String value) {
    return Text(
      "$label : $value",
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
    );
  }

  Widget _buildActionButtons(
      BuildContext context, List<Map<String, dynamic>> accounts, int index) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.delete_forever, color: Colors.red),
          onPressed: () => _showDeleteConfirmation(context, accounts[index]),
        ),
        IconButton(
          icon: const Icon(Icons.approval, color: Colors.green),
          onPressed: () => _showApprovalConfirmation(context, accounts[index]),
        ),
      ],
    );
  }

  void _showDeleteConfirmation(
      BuildContext context, Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Delete Pending Account?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No")),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _showLoadingDialog("Deleting Account");
                await _deleteAccount(account);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  void _showApprovalConfirmation(
      BuildContext context, Map<String, dynamic> account) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirmation"),
          content: const Text("Approve Pending Account?"),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("No")),
            TextButton(
              onPressed: () async {
                Navigator.pop(context);
                _showLoadingDialog("Approving Account");
                await _approveAccount(account);
              },
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAccount(Map<String, dynamic> account) async {
    try {
      bool success =
          await managePendingListService.deleteDocument(account['Email']!);
      await whatsAppAPI.adminDelAccount(
          account['Email']!, account['Name']!, account['Role']!, widget.email);

      Navigator.pop(context);
      if (success) {
        setState(() {});
      } else {
        _showErrorDialog("Failed to delete row",
            "There was an error deleting the row from the Google Sheet.");
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog("Error", "An error occurred: $e");
    }
  }

  Future<void> _approveAccount(Map<String, dynamic> account) async {
    try {
      bool complete = await managePendingListService
          .addAccountToDatabase(account['Email']!);

      await whatsAppAPI.adminCreateAccount(
          account['Email']!,
          account['Name']!,
          account['Role']!,
          widget.email // Pass the approver's email or name as `createdBy`
      );

      if (complete) {
        bool success = await managePendingListService.deleteDocument(account['Email']!);
        Navigator.pop(context);
        if (success) {
          setState(() {});
        } else {
          _showErrorDialog("Failed to delete row",
              "There was an error deleting the row from the Google Sheet.");
        }
      }
    } catch (e) {
      Navigator.pop(context);
      _showErrorDialog("Error", "An error occurred: $e");
    }
  }


  void _showLoadingDialog(String action) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(action,
                  style: const TextStyle(color: Colors.white, fontSize: 16)),
              const SizedBox(height: 10),
              const CircularProgressIndicator(color: Colors.blueAccent),
            ],
          ),
        );
      },
    );
  }

  void _showErrorDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("OK"))
          ],
        );
      },
    );
  }
}
