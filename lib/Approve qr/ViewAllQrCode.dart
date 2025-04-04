import 'package:flutter/material.dart';
import 'ViewQrService.dart';
import 'ViewSpecificQr.dart';

class AllApprovePage extends StatefulWidget {
  const AllApprovePage({super.key});

  @override
  State<AllApprovePage> createState() => _AllApprovePageState();
}

class _AllApprovePageState extends State<AllApprovePage>
    with SingleTickerProviderStateMixin {
  Icon searchIcon = const Icon(Icons.search);
  Widget searchField = const Text("QR Approval");
  String searchQuery = '';

  late TabController _tabController;
  final List<Tab> myTabs = <Tab>[
    const Tab(text: 'Approved'),
    const Tab(text: 'Pending Approval'),
    const Tab(text: 'Deactivated'), // Changed from 'expired' to 'Deactivated'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: myTabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _toggleSearch() {
    setState(() {
      if (searchIcon.icon == Icons.search) {
        searchIcon = const Icon(Icons.cancel);
        searchField = _buildSearchTextField();
      } else {
        searchIcon = const Icon(Icons.search);
        searchField = const Text("QR Approval");
        searchQuery = ''; // Clear search query when cancelling
      }
    });
  }

  void _onSearchChanged(String value) {
    setState(() {
      searchQuery = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allQrService = AllAQrService();

    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: searchField,
          centerTitle: true,
          backgroundColor: Colors.white,
          bottom: TabBar(
            controller: _tabController,
            tabs: myTabs,
            labelColor: Colors.black,
            indicatorColor: Colors.lightBlue.shade900,
          ),
          actions: [
            IconButton(
              icon: searchIcon,
              onPressed: _toggleSearch,
            ),
          ],
        ),
        body: TabBarView(
          controller: _tabController,
          children: myTabs.map((Tab tab) {
            String currentStatus = tab.text ?? '';

            return FutureBuilder<List<Map<String, dynamic>>>(
              future: allQrService.getAllAccounts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  List<Map<String, dynamic>> qrList = snapshot.data!;

                  // Filter based on current tab's status
                  List<Map<String, dynamic>> filteredByStatus = qrList.where((data) {
                    String status2 = data['status2']?.toString().toLowerCase() ?? '';
                    switch (currentStatus.toLowerCase()) {
                      case 'approved':
                        return status2 == 'approved';
                      case 'pending approval':
                        return status2 == 'pending approved';
                      case 'deactivated': // When the tab is 'Deactivated', match it to 'expired' in backend
                        return status2 == 'expired';
                      default:
                        return false;
                    }
                  }).toList();

                  // Further filter based on search query
                  List<Map<String, dynamic>> finalFilteredList = filteredByStatus.where((data) {
                    String name = data['Names']?.toString().toLowerCase() ?? '';
                    return name.contains(searchQuery.toLowerCase());
                  }).toList();

                  return finalFilteredList.isNotEmpty
                      ? ListView.builder(
                    itemCount: finalFilteredList.length,
                    itemBuilder: (context, index) {
                      Map<String, dynamic> data = finalFilteredList[index];
                      String documentID = data['QR Code'] ?? 'Unknown QR';

                      String name = data['Names'] ?? 'Unknown Name';
                      String startDate = data['Start Date'] ?? 'N/A';
                      String endDate = data['End Date'] ?? 'N/A';
                      String status = data['status2'] ?? 'Unknown Status2';

                      // Expiry logic based on the end date
                      DateTime today = DateTime.now();
                      bool isExpired = DateTime.tryParse(endDate)?.isBefore(today) ?? false;

                      return buildQrTile(
                        context,
                        name,
                        startDate,
                        endDate,
                        status,
                        documentID,
                        isExpired,
                      );
                    },
                  )
                      : const Center(child: Text('No QR Codes Found'));
                } else {
                  return const Center(child: Text('No QR Codes Found'));
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildSearchTextField() {
    return TextField(
      style: const TextStyle(color: Colors.black, fontSize: 16),
      textInputAction: TextInputAction.go,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Search Names",
        hintStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: _onSearchChanged,
    );
  }

  Widget buildQrTile(BuildContext context, String name, String startDate,
      String endDate, String status, String documentID, bool isExpired) {
    // Determine tile color based on status
    Color tileColor;
    switch (status.toLowerCase()) {
      case 'approved':
        tileColor = Colors.green.shade400;
        break;
      case 'pending approved':
        tileColor = Colors.orange.shade400;
        break;
      case 'expired':
        tileColor = Colors.red.shade400;
        break;
      default:
        tileColor = Colors.grey.shade400;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OneAQrCodePage(qrData: documentID), // Pass QR Code
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: tileColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRow("Name: ", name),
                buildRow("Start Date: ", startDate),
                buildRow("End Date: ", endDate),
                buildRow("Current Status: ", status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
