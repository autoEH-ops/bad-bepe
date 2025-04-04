import 'package:created_by_618_abdo/SubmitShutterReport/ShutterReportService.dart';
import 'package:created_by_618_abdo/UserMenuPages/ReportMenu.dart';
import 'package:created_by_618_abdo/UserMenuPages/SecurityMenu.dart';
import 'package:flutter/material.dart';

import '../Components/MenuButton.dart';
import '../Login/LoginPage.dart';
import '../ManageAccounts/ManageAccount.dart';
import '../ManageContractorPass/VMSmenu.dart';
import '../ManageDrive/ManageDrive.dart';
import '../ManageGuest/ManageGuest.dart';
import '../ManageQrCodeGeneration/ManageQrCodeMenu.dart';
import '../ManageSecurityPersonnel/ManageSecurityPersonnel.dart';
import '../ManageSupplier/ManageSupplier.dart';
import '../Register/RegisterPage.dart';
import '../VIEW QR VIP/ViewAllQrCode.dart';
import '../VIP QR/ManageQrCodeMenu.dart';

class AdminMainMenu extends StatefulWidget {
  const AdminMainMenu({super.key, required this.email, required this.role});
  final String? email;
  final String role;

  @override
  State<AdminMainMenu> createState() => _SuperAdminMainMenuState();
}

class _SuperAdminMainMenuState extends State<AdminMainMenu> {
  final ShutterReportService shutterReportService = ShutterReportService();
  String searchQuery = '';
  String? name;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  void loadData() async {
    name = await shutterReportService.getName(widget.email!);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    List<MenuButton> menuButtons = [
      MenuButton(
        icon: Icons.admin_panel_settings_outlined,
        primaryText: "All Account",
        secondaryText: "Manage All Accounts",
        onPressed: navigateToManageAllAccount,
      ),
      MenuButton(
        icon: Icons.pending_actions,
        primaryText: "Register Page",
        secondaryText: "Register New Accounts",
        onPressed: navigateToRegisterPage,
      ),
      MenuButton(
        icon: Icons.man,
        primaryText: "VMS MENU",
        secondaryText: "VMS MENU",
        onPressed: navigateToVMSMENU,
      ),

      MenuButton(
        icon: Icons.qr_code_sharp,
        primaryText: "QR MANAGEMENT",
        secondaryText: "QR MANAGEMENT",
        onPressed: navigateToQrvvMenuPage,
      ),

      MenuButton(
        icon: Icons.security_sharp,
        primaryText: "Security Guard",
        secondaryText: "Manage Security Guard",
        onPressed: navigateToManageSecurityGuard,
      ),
    ];

    List<MenuButton> filteredMenuButtons = menuButtons
        .where((button) => button.primaryText
        .toLowerCase()
        .contains(searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Page"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: MenuSearch(menuButtons: menuButtons),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const DrawerHeader(
              child: Center(
                child: Text(
                  "Side Menu",
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Center(
                      child: ListTile(
                        leading: const Icon(Icons.content_paste_go),
                        title: const Text(
                          "View Report",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          navigateToViewRepMenu();
                        },
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0),
                    child: Center(
                      child: ListTile(
                        leading: const Icon(Icons.security_rounded),
                        title: const Text(
                          "Switch to Security",
                          style: TextStyle(fontSize: 20),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          navigateToSecurity();
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Center(
                child: ListTile(
                  leading: const Icon(Icons.exit_to_app_rounded),
                  title: const Text(
                    "Log Out",
                    style: TextStyle(fontSize: 20),
                  ),
                  onTap: navigateToLoginPage,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            ...filteredMenuButtons.map((button) => Column(
              children: [
                button,
                const SizedBox(height: 20),
              ],
            ))
          ],
        ),
      ),
    );
  }

  void navigateToManageAllAccount() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ManageAccountPage(
          email: widget.email!,
          role: widget.role,
        ),
      ),
    );
  }

  void navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => RegisterPage(role: "Admin", email: widget.email!),
      ),
    );
  }

  void navigateToManageSecurityGuard() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ManageSecurityPersonnelPage(),
      ),
    );
  }

  void navigateToQrvvMenuPage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => QrvvMenuPage(email: '', role: '',)));
  }
  void navigateToAllVVQrCodePage() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => AllVVQrCodePage(role: "Admin", email: widget.email!),));
  }
  void navigateToVMSMENU() {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => VMSMENU(email: '', role: '',)));
  }


  void navigateToViewRepMenu() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ViewRepMenu()),
    );
  }

  void navigateToSecurity() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SecurityMainMenu(
          email: widget.email!,
          name: name!,
          role: "Super Admin",
        ),
      ),
    );
  }

  void navigateToLoginPage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
          (Route<dynamic> route) =>
      false, // This will remove all the previous routes
    );
  }
}

class MenuSearch extends SearchDelegate<String> {
  final List<MenuButton> menuButtons;

  MenuSearch({required this.menuButtons});

  @override
  List<Widget>? buildActions(BuildContext context) {
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
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List<MenuButton> filteredMenuButtons = menuButtons
        .where((button) =>
        button.primaryText.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: filteredMenuButtons
          .map((button) => ListTile(
        title: Text(button.primaryText),
        subtitle: Text(button.secondaryText),
        leading: Icon(button.icon),
        onTap: button.onPressed,
      ))
          .toList(),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<MenuButton> filteredMenuButtons = menuButtons
        .where((button) =>
        button.primaryText.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return ListView(
      children: filteredMenuButtons
          .map((button) => ListTile(
        title: Text(button.primaryText),
        subtitle: Text(button.secondaryText),
        leading: Icon(button.icon),
        onTap: button.onPressed,
      ))
          .toList(),
    );
  }
}
