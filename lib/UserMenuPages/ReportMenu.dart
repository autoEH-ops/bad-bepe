import 'package:created_by_618_abdo/Z_ViewAllReports/A_HourlyPostUpdate/ViewHourlyMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/B_RollCallReport/ViewRollCallMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/C_RoundingReport/ViewRoundingMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/D_EmergencyReport/ViewEmergencyMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/E_SpotCheckReport/ViewSpotCheckMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/F_DriverReport/ViewDriverMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/M_SupplierReport/ViewSupplierMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/N_VmsDutyReport/ViewDutyMenu.dart';
import 'package:created_by_618_abdo/Z_ViewAllReports/P_KeyManagementReport/ViewKeyManagementMenu.dart';
import 'package:flutter/material.dart';
import '../Z_ViewAllReports/L_VmsContractorReport/ViewContractorMenu.dart';
import '../Z_ViewAllReports/VIEWQR/ViewAllQrCode.dart';

class ViewRepMenu extends StatefulWidget {
  const ViewRepMenu({super.key});

  @override
  _ViewRepMenuState createState() => _ViewRepMenuState();
}

class _ViewRepMenuState extends State<ViewRepMenu>
    with SingleTickerProviderStateMixin {
  Icon cusIcon = const Icon(Icons.search);
  late AnimationController _titleController;
  Widget cusText = const Text("View Report");
  String searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  final List<String> _menuTitles = [
    'Hourly Post',
    'Roll Call',
    'Rounding',
    'Emergency',
    'Spot',
    'VMS Contractor',
    'VMS Supplier',
    'VMS Visitor',
    'Vehicle Pass',
    'View QR',
    'Key Management',
  ];

  List<String> _filteredMenuTitles = [];
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _titleController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    _filteredMenuTitles = _menuTitles;
    _searchController.addListener(_filterMenuTitles);
    _focusNode.requestFocus();
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterMenuTitles);
    _searchController.dispose();
    _focusNode.dispose();
    _titleController.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _titleController,
          builder: (context, child) {
            return Text(
              "View All Reports",
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
                    ),
                    onChanged: (value) {
                      setState(() {
                        searchQuery = value;
                      });
                    },
                  );
                } else {
                  cusIcon = const Icon(Icons.search);
                  cusText = const Text("View All Reports");
                  _searchController.clear();
                  searchQuery = '';
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: _filteredMenuTitles.length,
        itemBuilder: (context, index) {
          String title = _filteredMenuTitles[index];
          return Padding(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Container(
                width: 800,
                height: 65,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border:
                      Border.all(color: const Color(0xFF0091EA), width: 1.0),
                ),
                alignment: Alignment.center,
                child: ListTile(
                  title: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  onTap: () => _navigateToReport(title),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
