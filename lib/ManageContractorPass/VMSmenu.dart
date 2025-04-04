import 'package:flutter/material.dart';

import '../ManageDrive/ManageDrive.dart';
import '../ManageDutyPass/ManageDuty.dart';
import '../ManageGuest/ManageGuest.dart';
import '../ManageSupplierPass/ManageSupplier.dart';
import 'ManageContractor.dart';




class VMSMENU extends StatefulWidget {
  const VMSMENU({super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  State<VMSMENU> createState() => _VMSMENU();
}

class _VMSMENU extends State<VMSMENU> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlue.shade900,
        title: const Text(
          "VMS PASS Menu",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            _buildMenuOption(
              icon: Icons.remove_red_eye,
              title: 'Manage Contractor Pass',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManageContractorPage()),
                );
              },
              buttonText: 'Manage Contractor Pass',
            ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.qr_code,
              title: 'Manage Supplier Pass',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManageSupplierPassPage()),
                );
              },
              buttonText: 'Manage Supplier Pass',
            ),
              const SizedBox(height: 20),
              _buildMenuOption(
                icon: Icons.qr_code,
                title: 'Manage Visitor Pass',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ManageDutyPassPage()),
                  );
                },
                buttonText: 'Manage Visitor Pass',
              ),
                const SizedBox(height: 20),
                _buildMenuOption(
                  icon: Icons.qr_code,
                  title: 'Manage GUEST Pass',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ManageGUESTPage()),
                    );
                  },
                  buttonText: 'Manage GUEST Pass',
                ),
            const SizedBox(height: 20),
            _buildMenuOption(
              icon: Icons.qr_code,
              title: 'Manage Drive Pass',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ManageDrivePage()),
                );
              },
              buttonText: 'Manage Drive Pass',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuOption({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    required String buttonText,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Row(
              children: [
                Icon(icon, size: 35, color: Colors.white),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 5),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey.shade800,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    buttonText,
                    style: const TextStyle(fontSize: 18.0, color: Colors.white),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
