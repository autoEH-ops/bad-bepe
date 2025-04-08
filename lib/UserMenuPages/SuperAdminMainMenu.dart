import 'package:created_by_618_abdo/SubmitShutterReport/ShutterReportService.dart';
import 'package:created_by_618_abdo/UserMenuPages/ReportMenu.dart';
import 'package:created_by_618_abdo/UserMenuPages/SecurityMenu.dart';
import 'package:created_by_618_abdo/face_recognition_real_time/attendance_admin_page.dart';
import 'package:flutter/material.dart';

import '../Approve qr/ViewAllQrCode.dart';
import '../Login/LoginPage.dart';
import '../ManageAccounts/ManageAccount.dart';
import '../ManageContractorPass/ManageContractor.dart';
import '../ManageContractorPass/VMSmenu.dart';
import '../ManageDrive/ManageDrive.dart';
import '../ManageDutyPass/ManageDuty.dart';
import '../ManageEmergencyLocation/ManageEmergencyLocation.dart';
import '../ManageGuest/ManageGuest.dart';
import '../ManageKey/ManageKey.dart';
import '../ManagePendingList/ManagePendingList.dart';
import '../ManageQrCodeGeneration/ManageQrCodeMenu.dart';
import '../ManageRoundingPoint/ManageRoundingPoint.dart';
import '../ManageSecurityPersonnel/ManageSecurityPersonnel.dart';
import '../ManageSupplier/ManageSupplier.dart';
import '../ManageSupplierPass/ManageSupplier.dart';
import '../Register/RegisterPage.dart';
import '../VIEW QR VIP/ViewAllQrCode.dart';
import '../VIP QR/ManageQrCodeMenu.dart';
import '../VIP QR/QrGenerator.dart';
import 'SuperAdminSettingsPage.dart';

class SuperAdminMainMenu extends StatefulWidget {
  const SuperAdminMainMenu(
      {super.key, required this.email, required this.role});

  final String? email;
  final String role;

  @override
  State<SuperAdminMainMenu> createState() => _SuperAdminMainMenuState();
}

class _SuperAdminMainMenuState extends State<SuperAdminMainMenu>
    with SingleTickerProviderStateMixin {
  final ShutterReportService shutterReportService = ShutterReportService();
  String searchQuery = '';
  String? name;
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

  void loadData() async {
    if (widget.email != null) {
      name = await shutterReportService.getName(widget.email!);
      setState(() {});
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> menuItems = [
      {
        'icon': Icons.admin_panel_settings_outlined,
        'text': "All Account",
        'onTap': navigateToManageAllAccount
      },
      {
        'icon': Icons.pending_actions,
        'text': "Register Page",
        'onTap': navigateToRegisterPage
      },
      {
        'icon': Icons.qr_code,
        'text': "QR Page",
        'onTap': navigateToQrvvMenuPage
      },
      {
        'icon': Icons.list,
        'text': "Pending List",
        'onTap': navigateToPendingList
      },
      {
        'icon': Icons.security_sharp,
        'text': "Security Guard",
        'onTap': navigateToManageSpecificSecurityGuar
      },
      {
        'icon': Icons.fire_truck_outlined,
        'text': "VMS MENU",
        'onTap': navigateToVMSMENU
      },
      {
        'icon': Icons.route_sharp,
        'text': "Rounding Points",
        'onTap': navigateToRoundingPointPage
      },
      {
        'icon': Icons.warning_amber_rounded,
        'text': "Hourly Page Post",
        'onTap': navigateToEmergencyLocationPage
      },
      {'icon': Icons.vpn_key, 'text': "Key", 'onTap': navigateToManageKeyPage},
      {
        'icon': Icons.person_search,
        'text': "Attendance",
        'onTap': navigateToAttendance
      },
    ];

    List<Map<String, dynamic>> filteredMenuItems = menuItems
        .where((item) =>
            item['text'].toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: AnimatedBuilder(
          animation: _titleController,
          builder: (context, child) {
            return Text(
              "Super Admin Page",
              style: TextStyle(
                color: Color.lerp(
                  Colors.white,
                  Colors.blueAccent,
                  0.5 + 0.5 * _titleController.value,
                ),
                fontSize: 28, // Increased font size for larger display
                fontWeight: FontWeight.bold, // Added bold weight for emphasis
              ),
            );
          },
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0091EA),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              showSearch(
                  context: context,
                  delegate: MenuSearch(menuButtons: menuItems));
            },
          ),
        ],
      ),
      drawer: _buildDrawer(context),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Wrap(
            spacing: 20,
            runSpacing: 20,
            alignment: WrapAlignment.center,
            children: filteredMenuItems.map((item) {
              return GestureDetector(
                onTap: item['onTap'],
                child: MouseRegion(
                  onEnter: (_) => setState(() {}),
                  onExit: (_) => setState(() {}),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    width: 250,
                    height: 130,
                    decoration: BoxDecoration(
                      color: const Color(0xFF0091EA),
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
                    child: Center(
                      child: ListTile(
                        leading:
                            Icon(item['icon'], color: Colors.white, size: 40),
                        title: Text(
                          item['text'],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }

  Drawer _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF2A3D50),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const DrawerHeader(
            child: Center(
              child: Text("Side Menu",
                  style: TextStyle(fontSize: 20, color: Colors.white)),
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildDrawerTile(context, Icons.content_paste_go, "View Report",
                    navigateToViewRepMenu),
                _buildDrawerTile(context, Icons.security_rounded,
                    "Switch to Security", navigateToSecurity),
                // _buildDrawerTile(context, Icons.admin_panel_settings_outlined,
                //  "User Settings", navigateToUserSettingsPage),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0),
            child: Center(
              child: ListTile(
                leading:
                    const Icon(Icons.exit_to_app_rounded, color: Colors.white),
                title: const Text("Log Out",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                onTap: navigateToLoginPage,
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildDrawerTile(
      BuildContext context, IconData icon, String title, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 16.0),
      child: ListTile(
        leading: Icon(icon, color: Colors.white),
        title: Text(title,
            style: const TextStyle(fontSize: 20, color: Colors.white)),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  // Menu navigation functions
  void navigateToManageAllAccount() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ManageAccountPage(email: widget.email!, role: widget.role)));
  }

  void navigateToPendingList() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManagePendingPage(email: widget.email!)));
  }

  void navigateToAttendance() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AttendanceAdminPage()));
  }

  void navigateToRegisterPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                RegisterPage(role: "Super Admin", email: widget.email!)));
  }

  void navigateToManageSpecificSecurityGuar() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ManageSecurityPersonnelPage()));
  }

  void navigateToVMSMENU() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => VMSMENU(
                  email: '',
                  role: '',
                )));
  }

  void navigateToRoundingPointPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ManageRoundingPoint()));
  }

  void navigateToEmergencyLocationPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => const ManageEmergencyLocationPage()));
  }

  void navigateToQrvvMenuPage() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                QrvvMenuPage(role: "Super Admin", email: widget.email!)));
  }

  void navigateToManageKeyPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => const ManageKeyPage()));
  }

  void navigateToViewRepMenu() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const ViewRepMenu()));
  }

  void navigateToSecurity() {
    if (name != null && widget.email != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => SecurityMainMenu(
                  email: widget.email!, name: name!, role: "Super Admin")));
    }
  }

  /* void navigateToUserSettingsPage() {
    if (name != null && widget.email != null) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => UserSettingsPage()));
    }
  }
*/
  void navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
        (Route<dynamic> route) => false);
  }
}

class MenuSearch extends SearchDelegate {
  final List<Map<String, dynamic>> menuButtons;

  MenuSearch({required this.menuButtons});

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Map<String, dynamic>> results = menuButtons
        .where(
            (item) => item['text'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFF1f293a),
      child: ListView(
        children: results.map((item) {
          return ListTile(
            leading: Icon(item['icon'], color: Colors.white),
            title:
                Text(item['text'], style: const TextStyle(color: Colors.white)),
            onTap: item['onTap'],
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Map<String, dynamic>> suggestions = menuButtons
        .where(
            (item) => item['text'].toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      color: const Color(0xFF1f293a),
      child: ListView(
        children: suggestions.map((item) {
          return ListTile(
            leading: Icon(item['icon'], color: Colors.white),
            title:
                Text(item['text'], style: const TextStyle(color: Colors.white)),
            onTap: () {
              query = item['text'];
              showResults(context);
            },
          );
        }).toList(),
      ),
    );
  }
}
