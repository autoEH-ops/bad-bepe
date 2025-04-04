import 'package:created_by_618_abdo/ManageEmergencyFollowUp/ManageEmergencyFollowUpMenu.dart';
import 'package:created_by_618_abdo/SubmitPassCheckingFollowUp/PassCheckingFollowUpMenu.dart';
import 'package:flutter/material.dart';

class FollowUpMenu extends StatefulWidget {
  const FollowUpMenu({
    super.key,
    required this.email,
    required this.role,
  });
  final String email;
  final String role;
  @override
  State<FollowUpMenu> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<FollowUpMenu> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Follow Up Menu"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    navigateToEmergencyFollowUpReport();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Emergency Report Follow Up",
                      style: TextStyle(
                          fontSize: 15.0, color: Colors.grey.shade800),
                    ),
                  ),
                ),
              ),
            ),
            /* const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 50,
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    navigateToManageClampingMenu();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),*/
            /*  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Clamping Follow Up",
                      style: TextStyle(
                          fontSize: 15.0, color: Colors.grey.shade800),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                height: 50,

                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    navigateToPassCheckingFollowUpReport();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey.shade200,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),*/
            /*  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Pass Checking Follow Up",
                      style: TextStyle(
                          fontSize: 15.0, color: Colors.grey.shade800),*/
            //             ),
            //   ),
            //      ),
            //       ),
            //   ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }

  navigateToEmergencyFollowUpReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManageEmergencyFollowUpMenu(
                  email: widget.email,
                )));
  }

  navigateToPassCheckingFollowUpReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PassCheckingFollowUpMenu(
                  email: widget.email,
                  role: "Security",
                )));
  }
}
