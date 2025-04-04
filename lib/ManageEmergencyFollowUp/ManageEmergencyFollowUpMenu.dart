import 'package:flutter/material.dart';
import '/ManageEmergencyFollowUp/ManageEmergencyFollowUpMenuService.dart';
import '/ManageEmergencyFollowUp/ManageSpecificEmergencyFollowUp/ManageSpecificEmergencyFollowUp.dart';

class ManageEmergencyFollowUpMenu extends StatefulWidget {
  const ManageEmergencyFollowUpMenu({super.key, required this.email});
  final String email;
  @override
  State<ManageEmergencyFollowUpMenu> createState() =>
      _ManageEmergencyFollowUpMenuState();
}

class _ManageEmergencyFollowUpMenuState
    extends State<ManageEmergencyFollowUpMenu> {
  final TextEditingController textController = TextEditingController();

  ManageEmergencyFollowUpMenuService manageEmergencyFollowUpMenuService =
  ManageEmergencyFollowUpMenuService();

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Emergency Follow Up',
          style: TextStyle(
              color: Colors.black),
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
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: manageEmergencyFollowUpMenuService.getAllEmergencyIncident(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading screen
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Show empty message
            return const Center(child: Text('No data available'));
          } else {

            List<Map<String, String>> accounts = snapshot.data!;


            if (_selectedFilter != 'All') {
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
                String status = accounts[index]['Status']!;
                Color backgroundColor = status == "Follow Up"
                    ? Colors.redAccent.shade100
                    : Colors.green.shade100;

                return Padding(
                  padding:
                  const EdgeInsets.only(left: 25.0, right: 25, top: 15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ManageSpecificEmergencyFollowUpPage(
                                data: accounts[index],
                                email: widget.email,
                              ),
                        ),
                      );
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
                                "Report ID : ${accounts[index]['Report ID']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Submitted by : ${accounts[index]['Name of Respondent']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Incident Date : ${accounts[index]['Incident Date']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Incident Time : ${accounts[index]['Incident Time']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Incident Location : ${accounts[index]['Incident Location']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Status : ${accounts[index]['Status']!}",
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
