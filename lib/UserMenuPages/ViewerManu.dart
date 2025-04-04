import 'package:created_by_618_abdo/Z_ViewAllReports/A_HourlyPostUpdate/ViewHourlyMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/B_RollCallReport/ViewRollCallMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/C_RoundingReport/ViewRoundingMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/D_EmergencyReport/ViewEmergencyMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/E_SpotCheckReport/ViewSpotCheckMenu.dart';
import 'package:flutter/material.dart';

import '../Login/LoginPage.dart';
import '../Z_ViewAllReports/F_DriverReport/ViewDriverMenu.dart';
import '../Z_ViewAllReports/L_VmsContractorReport/ViewContractorMenu.dart';
import '../Z_ViewAllReports/M_SupplierReport/ViewSupplierMenu.dart';
import '../Z_ViewAllReports/N_VmsDutyReport/ViewDutyMenu.dart';
import '../Z_ViewAllReports/P_KeyManagementReport/ViewKeyManagementMenu.dart';
import '../Z_ViewAllReports/VIEWQR/ViewAllQrCode.dart';

class ViewerMenu extends StatefulWidget {
  const ViewerMenu({
    super.key,
    required this.email,
    required this.name,
    this.role,
  });

  final String? email;
  final String? name;
  final String? role;

  @override
  State<ViewerMenu> createState() => _ViewerMenuState();
}

class _ViewerMenuState extends State<ViewerMenu> {
  // Search functionality
  Icon cusIcon = const Icon(Icons.search);
  Widget cusText = const Text("View Report");
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();

  // List of report titles
  final List<String> _menuTitles = [
    'Hourly Post',
    'Roll Call',
    'Rounding',
    'Emergency',
    'Spot',
    'VMS Contractor',
    'VMS Supplier',
    'VMS Visitor',
    //'Vehicle Pass',
    'View QR',
    'Key Management',
  ];

  List<String> _filteredMenuTitles = [];

  @override
  void initState() {
    super.initState();
    _filteredMenuTitles = _menuTitles;
    _searchController.addListener(_filterMenuTitles);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMenuTitles);
    _searchController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _filterMenuTitles() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMenuTitles = _menuTitles
          .where((title) => title.toLowerCase().contains(query))
          .toList();
    });
  }

  void _navigateToReport(String title) {
    _searchController.text = '';
    switch (title) {
      case 'Hourly Post':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewHourlyReport(),
          ),
        );
        break;
      case 'Roll Call':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewRollCallReport(),
          ),
        );
        break;
      case 'Rounding':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewRoundingReport(),
          ),
        );
        break;
      case 'Emergency':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewEmergencyReport(),
          ),
        );
        break;
      case 'Spot':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewSpotCheckReport(),
          ),
        );
        break;
      case 'VMS Supplier':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewSupplierReport(),
          ),
        );
        break;

      case 'View QR':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const vQrCodePage(),
          ),
        );
        break;
      case 'VMS Contractor':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewContractorReport(),
          ),
        );
        break;
      case 'VMS Visitor':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewDutyReport(),
          ),
        );
        break;
      case 'Key Management':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewKeyManagementReport(),
          ),
        );
        break;
      case 'Vehicle Pass':
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const ViewDriverReport(),
          ),
        );
        break;
    }
  }
  void navigateToLoginPage() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: cusText,
        centerTitle: true,
        actions: [
          IconButton(
            icon: cusIcon,
            onPressed: () {
              setState(() {
                if (cusIcon.icon == Icons.search) {
                  _focusNode.requestFocus();
                  cusIcon = const Icon(Icons.cancel);
                  cusText = TextField(
                    focusNode: _focusNode,
                    controller: _searchController,
                    style: const TextStyle(color: Colors.black, fontSize: 16),
                    textInputAction: TextInputAction.go,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Search Titles",
                      hintStyle: TextStyle(color: Colors.grey),
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  );
                } else {
                  cusIcon = const Icon(Icons.search);
                  cusText = const Text("View Report Menu");
                  _searchController.clear();
                  searchQuery = ''; // Clear search query when cancelling
                }
              });
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  "Side Menu",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.exit_to_app_rounded),
              title: const Text("Log Out", style: TextStyle(fontSize: 20)),
              onTap: navigateToLoginPage,
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: _filteredMenuTitles.length,
        itemBuilder: (context, index) {
          String title = _filteredMenuTitles[index];
          return Padding(
            padding: const EdgeInsets.all(5),
            child: Container(
              height: 65,
              decoration: BoxDecoration(
                color: Colors.lightBlue.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: ListTile(
                title: Text(
                  title,
                  style: const TextStyle(fontSize: 16.5),
                ),
                onTap: () => _navigateToReport(title),
              ),
            ),
          );
        },
      ),
    );
  }
}
