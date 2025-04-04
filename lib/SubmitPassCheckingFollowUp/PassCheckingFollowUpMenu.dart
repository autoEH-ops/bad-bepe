import 'package:created_by_618_abdo/SubmitPassCheckingFollowUp/PassCheckingFollowUp/ManageSpecificPass.dart';
import 'package:created_by_618_abdo/SubmitPassCheckingFollowUp/PassCheckingFollowUp/ManageSpecificPassCompleted.dart';
import 'package:flutter/material.dart';

import 'SubmitPassCheckingFollowUpService.dart';

class PassCheckingFollowUpMenu extends StatefulWidget {
  const PassCheckingFollowUpMenu(
      {super.key, required this.email, required this.role});
  final String email;
  final String role;
  @override
  State<PassCheckingFollowUpMenu> createState() =>
      _PassCheckingFollowUpMenuState();
}

class _PassCheckingFollowUpMenuState extends State<PassCheckingFollowUpMenu> {
  final TextEditingController textController = TextEditingController();

  SubmitPassCheckingFollowUpService submitPassCheckingFollowUpService =
      SubmitPassCheckingFollowUpService();

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Pass Follow Up',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_alt),
            onSelected: (value) {
              setState(() {
                _selectedFilter = value;
              });
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'All',
                child: Text('All'),
              ),
              const PopupMenuItem<String>(
                value: 'Follow Up',
                child: Text('Follow Up'),
              ),
              const PopupMenuItem<String>(
                value: 'Completed',
                child: Text('Completed'),
              ),
              const PopupMenuItem<String>(
                value: 'Supplier',
                child: Text('Supplier Pass'),
              ),
              const PopupMenuItem<String>(
                value: 'Duty',
                child: Text('Duty Pass'),
              ),
              const PopupMenuItem<String>(
                value: 'Contractor',
                child: Text('Contractor Pass'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: submitPassCheckingFollowUpService.getAllPassCheck(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading screen
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message
            return const Center(child: Text('No Records'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Show empty message
            return const Center(child: Text('No data available'));
          } else {
            List<Map<String, String>> accounts = snapshot.data!;

            if (_selectedFilter == 'Supplier' ||
                _selectedFilter == 'Duty' ||
                _selectedFilter == 'Contractor') {
              accounts = accounts
                  .where((account) => account['Category'] == _selectedFilter)
                  .toList();
            } else if (_selectedFilter != 'All') {
              accounts = accounts
                  .where((account) => account['Status'] == _selectedFilter)
                  .toList();
            } else {
              accounts.sort((a, b) {
                // If both have the same status, keep them in their current order
                if (a['Status'] == b['Status']) return 0;
                // Follow Up status first
                if (a['Status'] == 'Follow Up') return -1;
                // Completed status after Follow Up
                return 1;
              });
            }

            return ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                String reportID = accounts[index]['Report ID'] ?? '';
                String missingPass = accounts[index]['Missing Pass'] ?? '';
                String category = accounts[index]['Category'] ?? '';
                String nameOfRespondent =
                    accounts[index]['Name of Respondent'] ?? '';
                String status = accounts[index]['Status'] ?? '';
                Color backgroundColor = status == "Follow Up"
                    ? Colors.redAccent.shade200
                    : Colors.green.shade200;

                return Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, top: 15),
                  child: GestureDetector(
                    onTap: () {
                      if (status == "Completed") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ManageSpecificPassCompletedPage(
                              data: accounts[index],
                              email: widget.email,
                            ),
                          ),
                        );
                      } else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ManageSpecificPassCheckingFollowUpPage(
                              data: accounts[index],
                              email: widget.email,
                              role: widget.role,
                            ),
                          ),
                        );
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(color: backgroundColor),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 0.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Report ID : $reportID",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Missing Pass : $missingPass",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Category : $category",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Submitted by : $nameOfRespondent",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Status : $status",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
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
}
