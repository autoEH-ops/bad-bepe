import 'package:flutter/material.dart';
import '/ManageClampingFollowUp/ManageClampingFollowUpMenuService.dart';
import '/ManageClampingFollowUp/ManageSpecificClampingFollowUp/ManageSpecificClampingCompleted.dart';
import '/ManageClampingFollowUp/ManageSpecificClampingFollowUp/ManageSpecificClampingFollowUp.dart';


class ManageClampingMenu extends StatefulWidget {
  const ManageClampingMenu({super.key, required this.email, required this.role});
  final String email;
  final String role;
  @override
  State<ManageClampingMenu> createState() => _ManageClampingMenuState();
}

class _ManageClampingMenuState extends State<ManageClampingMenu> {
  final TextEditingController textController = TextEditingController();

  String _selectedFilter = 'All';

  ManageEmergencyClampingUpMenuService manageEmergencyClampingUpMenuService =
      ManageEmergencyClampingUpMenuService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Clamping Follow Up'),
        backgroundColor: Colors.grey.shade300,
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
                    const PopupMenuItem(value: "All", child: Text("All")),
                    const PopupMenuItem(
                      value: 'Follow Up',
                      child: Text('Follow Up'),
                    ),
                    const PopupMenuItem<String>(
                      value: 'Completed',
                      child: Text('Completed'),
                    ),
                  ])
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: manageEmergencyClampingUpMenuService.getAllClampingIncident(),
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
            // Data is loaded, build the list
            List<Map<String, String>> clampingRecords = snapshot.data!;

            if (_selectedFilter != 'All') {
              clampingRecords = clampingRecords
                  .where((account) => account['Status'] == _selectedFilter)
                  .toList();
            } else {
              clampingRecords.sort((a, b) {
                // If both have the same status, keep them in their current order
                if (a['Status'] == b['Status']) return 0;
                // Follow Up status first
                if (a['Status'] == 'Follow Up') return -1;
                // Completed status after Follow Up
                return 1;
              });
            }

            return ListView.builder(
              itemCount: clampingRecords.length,
              itemBuilder: (context, index) {
                // Check the status
                String status = clampingRecords[index]['Status']!;
                Color backgroundColor = status == "Follow Up"
                    ? Colors.redAccent.shade100
                    : Colors.green.shade100;

                return Padding(
                  padding:
                      const EdgeInsets.only(left: 25.0, right: 25, top: 15),
                  child: GestureDetector(
                    onTap: () {
                      if (status == "Follow Up"){
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  ManageSpecificClampingFollowUpPage(
                                    data: clampingRecords[index],
                                    email: widget.email,
                                    role: widget.role,
                                  )));
                      } else {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ManageSpecificClampingCompletedPage(
                                      data: clampingRecords[index],
                                      email: widget.email,
                                    )));
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
                                "Report ID : ${clampingRecords[index]['Report ID']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Submitted by : ${clampingRecords[index]['Name of Respondent']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Incident Date : ${clampingRecords[index]['Date']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Incident Time : ${clampingRecords[index]['Time']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Car Plate : ${clampingRecords[index]['Car Plate Number']!}",
                                style: const TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Status : ${clampingRecords[index]['Status']!}",
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
