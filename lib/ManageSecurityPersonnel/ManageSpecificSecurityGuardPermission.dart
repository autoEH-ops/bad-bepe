/*import 'package:flutter/material.dart';

import '../ManageSecurityPersonnel/ManageSecurityService.dart';
//import '../ManageVMS/ContractorPass/ManageContractorVmsService.dart';

class ManageSpecificSecurityGuard extends StatefulWidget {
  const ManageSpecificSecurityGuard({super.key, required this.data});
  final Map<String, dynamic> data;
  @override
  State<ManageSpecificSecurityGuard> createState() =>
      _ManageSpecificSecurityGuardState();
}

class _ManageSpecificSecurityGuardState
    extends State<ManageSpecificSecurityGuard> {
  bool hourlyPostUpdateStatus = false;
  bool rollCallStatus = false;
  bool roundingReportStatus = false;
  bool emergencyReportStatus = false;
  bool spotCheckReportStatus = false;
  bool shutterReportStatus = false;
  bool electricPanelReportStatus = false;
  bool glassSlidingReportStatus = false;
  bool mainGateReportStatus = false;
  bool clampingReportStatus = false;
  bool vmsReportStatus = false;
  bool qrReportStatus = false;
  bool passCheckingReportStatus = false;
  bool emergencyFollowUpReportStatus = false;
  bool clampingFollowUpReportStatus = false;
  bool passCheckingFollowUpReportStatus = false;
  bool keyManagementReportStatus = false;

  @override
  void initState() {
    super.initState();
    // Set initial values based on the data map
    hourlyPostUpdateStatus =
        widget.data['Hourly Post Update Report Status'] == true ? true : false;
    rollCallStatus =
        widget.data['Roll Call Report Status'] == true ? true : false;
    roundingReportStatus =
        widget.data['Rounding Report Status'] == true ? true : false;
    emergencyReportStatus =
        widget.data['Emergency Report Status'] == true ? true : false;
    spotCheckReportStatus =
        widget.data['Spot Check Report Status'] == true ? true : false;
    shutterReportStatus =
        widget.data['Shutter Report Status'] == true ? true : false;
    electricPanelReportStatus =
        widget.data['Electric Panel Report Status'] == true ? true : false;
    glassSlidingReportStatus =
        widget.data['Glass Sliding Report Status'] == true ? true : false;
    mainGateReportStatus =
        widget.data['Main Gate Report Status'] == true ? true : false;
    clampingReportStatus =
        widget.data['Clamping Report Status'] == true ? true : false;
    vmsReportStatus = widget.data['VMS Report Status'] == true ? true : false;
    qrReportStatus = widget.data['QR Report Status'] == true ? true : false;
    passCheckingReportStatus =
        widget.data['Pass Checking Report Status'] == true ? true : false;
    emergencyFollowUpReportStatus =
        widget.data['Emergency Follow Up Report Status'] == true ? true : false;
    clampingFollowUpReportStatus =
        widget.data['Clamping Follow Up Report Status'] == true ? true : false;
    passCheckingFollowUpReportStatus =
        widget.data['Pass Check Follow Up Report Status'] == true
            ? true
            : false;
    keyManagementReportStatus =
        widget.data['Key Management Report Status'] == true ? true : false;
  }

  bool parseBool(String value) {
    return value.toLowerCase() == 'true';
  }

  ManageSecurityService manageSecurityService = ManageSecurityService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          widget.data["Name"]!,
          style: TextStyle(color: Colors.black), // Set the text color to black
        ),
        centerTitle: true,
        backgroundColor: Colors.white, // Set the background color to white
        elevation: 0, // Optional: remove shadow for a flat look
      ),
      body: SingleChildScrollView(
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Hourly Post Update Permission"),
                      value: hourlyPostUpdateStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          hourlyPostUpdateStatus = value;
                        });
                        await manageSecurityService.updateRow(
                            widget.data["Name"]!,
                            "Hourly Post Update Status",
                            hourlyPostUpdateStatus);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Roll Call Report Permission"),
                      value: rollCallStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          rollCallStatus = value;
                        });
                        await manageSecurityService.updateRow(
                            widget.data["Name"]!,
                            "Roll Call Status",
                            rollCallStatus);
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Rounding Report Permission"),
                      value: roundingReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          roundingReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Rounding Report Status",
                          roundingReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Emergency Report Permission"),
                      value: emergencyReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          emergencyReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Emergency Report Status",
                          emergencyReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Spot Check Report Permission"),
                      value: spotCheckReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          spotCheckReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Spot Check Report Status",
                          spotCheckReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Shutter Report Permission"),
                      value: shutterReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          shutterReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Shutter Report Status",
                          shutterReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Electric Panel Report Permission"),
                      value: electricPanelReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          electricPanelReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Electric Panel Report Status",
                          electricPanelReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Glass Sliding Report Permission"),
                      value: glassSlidingReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          glassSlidingReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Glass Sliding Report Status",
                          glassSlidingReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Main Gate Report Permission"),
                      value: mainGateReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          mainGateReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Main Gate Report Status",
                          mainGateReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Clamping Report Permission"),
                      value: clampingReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          clampingReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Clamping Report Status",
                          clampingReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Key Management Report Permission"),
                      value: keyManagementReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          keyManagementReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Key Management Report Status",
                          keyManagementReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("VMS Report Permission"),
                      value: vmsReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          vmsReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "VMS Report Status",
                          vmsReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("QR Report Permission"),
                      value: qrReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          qrReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "QR Report Status",
                          qrReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Pass Checking Report Permission"),
                      value: passCheckingReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          passCheckingReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Pass Checking Report Status",
                          passCheckingReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title:
                          const Text("Emergency Follow Up Report Permission"),
                      value: emergencyFollowUpReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          emergencyFollowUpReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Emergency Follow Up Report Status",
                          emergencyFollowUpReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Clamping Follow Up Report Permission"),
                      value: clampingFollowUpReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          clampingFollowUpReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Clamping Follow Up Report Status",
                          clampingFollowUpReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white, // Set the background color to white
                    border: Border.all(
                      color: Colors.black, // Set the border color to black
                      width: 1.0, // Set the border width
                    ),
                    borderRadius: BorderRadius.circular(
                        4.0), // Optional: add rounded corners
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: SwitchListTile(
                      title: const Text("Pass Checking Follow Up Permission"),
                      value: passCheckingFollowUpReportStatus,
                      activeColor: Colors.green,
                      inactiveThumbColor: Colors.red,
                      inactiveTrackColor: Colors.red.shade100,
                      onChanged: (bool value) async {
                        setState(() {
                          passCheckingFollowUpReportStatus = value;
                        });
                        await manageSecurityService.updateRow(
                          widget.data["Name"]!,
                          "Pass Checking Follow Up Report Status",
                          passCheckingFollowUpReportStatus,
                        );
                      },
                    ),
                  ),
                ),
              ),
            ]),
      ),
    );
  }

  void pop() {
    Navigator.pop(context);
  }
}
*/
