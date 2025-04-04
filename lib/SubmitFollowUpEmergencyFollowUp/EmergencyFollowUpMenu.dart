import 'package:created_by_618_abdo/SubmitFollowUpEmergencyFollowUp/SpecificEmergencyFollowUp/SpecificEmergencyFollowUpCompleted.dart';
import 'package:flutter/material.dart';

import '../SubmitFollowUpEmergencyFollowUp/EmergencyFollowUpMenuService.dart';
import '../SubmitFollowUpEmergencyFollowUp/SpecificEmergencyFollowUp/SpecificEmergencyFollowUp.dart';

class EmergencyFollowUpMenu extends StatefulWidget {
  const EmergencyFollowUpMenu(
      {super.key, required this.email, required this.role});
  final String email;
  final String role;
  @override
  State<EmergencyFollowUpMenu> createState() => _EmergencyFollowUpMenuState();
}

class _EmergencyFollowUpMenuState extends State<EmergencyFollowUpMenu> {
  final TextEditingController textController = TextEditingController();

  EmergencyFollowUpMenuService emergencyFollowUpMenuService =
      EmergencyFollowUpMenuService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  loadData() async {
    name = await emergencyFollowUpMenuService.getName(widget.email);
    setState(() {});
  }

  String name = "";

  String _selectedFilter = 'All';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Emergency Follow Up',
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
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: emergencyFollowUpMenuService.getAllEmergencyIncident(),
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
            // Data is loaded, build the list
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

            // Check if any emergency report is assigned to the user
            bool hasAssignedReport = accounts.any((account) {
              List<String> followers = (account['Followers'] ?? '').split(', ');
              return followers.contains(name);
            });

            if (widget.role == "Super Admin") {
              return ListView.builder(
                  itemCount: accounts.length,
                  itemBuilder: (context, index) {
                    String status = accounts[index]['Status']!;
                    String nameOfRespondent =
                        accounts[index]['Name of Respondent']!;
                    Color backgroundColor = status == "Follow Up"
                        ? Colors.redAccent.shade200
                        : Colors.green.shade200;
                    // Check conditions

                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 25.0, right: 25, top: 15),
                      child: GestureDetector(
                        onTap: () {
                          if (status == "Follow Up") {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SpecificEmergencyFollowUpPage(
                                  data: accounts[index],
                                  email: widget.email,
                                  role: "Security",
                                ),
                              ),
                            );
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SpecificEmergencyCompletedPage(
                                  data: accounts[index],
                                  email: widget.email,
                                  role: "Security",
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
                                    "Submitted by : $nameOfRespondent",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Incident Date : ${accounts[index]['Incident Date']!}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Incident Time : ${accounts[index]['Incident Time']!}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Incident Location : ${accounts[index]['Incident Location']!}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Status : ${accounts[index]['Status']!}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  });
            }

            if (widget.role != "Super Admin") {
              if (!hasAssignedReport) {
                return const Center(
                  child: Text('You have no assigned emergency report.'),
                );
              }

              return ListView.builder(
                itemCount: accounts.length,
                itemBuilder: (context, index) {
                  String status = accounts[index]['Status']!;
                  String nameOfRespondent =
                      accounts[index]['Name of Respondent']!;
                  List<String> followers =
                      (accounts[index]['Followers'] ?? '').split(', ');

                  // Check conditions
                  if (followers.contains(name)) {
                    Color backgroundColor = status == "Follow Up"
                        ? Colors.redAccent.shade200
                        : Colors.green.shade200;

                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 25.0, right: 25, top: 15),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  SpecificEmergencyFollowUpPage(
                                data: accounts[index],
                                email: widget.email,
                                role: widget.role,
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
                                    "Submitted by : $nameOfRespondent",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Incident Date : ${accounts[index]['Incident Date']!}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Incident Time : ${accounts[index]['Incident Time']!}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Incident Location : ${accounts[index]['Incident Location']!}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Status : ${accounts[index]['Status']!}",
                                    style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Return an empty container if the conditions are not met
                    return Container();
                  }
                },
              );
            } else {
              return Container();
            }
          }
        },
      ),
    );
  }
}
