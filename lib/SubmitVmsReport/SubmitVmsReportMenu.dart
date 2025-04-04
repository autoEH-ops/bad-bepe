import 'package:created_by_618_abdo/SubmitVmsReport/SubmitSupplierReport/SubmitSupplierVmsReport.dart';
import 'package:flutter/material.dart';
import 'SubmitContractorReport/SubmitContractorVmsReport.dart';
import 'SubmitDutyReport/SubmitDutyVmsReport.dart';
import 'SubmitvehicleReport/SubmitvehicleVmsReport.dart';

class SubmitVmsReportMenu extends StatelessWidget {
  const SubmitVmsReportMenu({
    super.key,
    required this.email,
    required this.role,
  });

  final String email;
  final String role;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "VMS Report",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Report List',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(
                          Icons.security,
                          size: 25,
                          color: Colors.white,
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    buildReportTile(context, 'VMS Contractor', Icons.work,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ContractorVmsReport(email: email, role: role),
                        ),
                      );
                    }),
                    const SizedBox(height: 15),
                    buildReportTile(
                        context, 'VMS Supplier', Icons.fire_truck_sharp, () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              SupplierVmsReport(email: email, role: role),
                        ),
                      );
                    }),
                    const SizedBox(height: 15),
                    buildReportTile(
                        context, 'VMS Visitor', Icons.local_police_outlined,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DutyVmsReport(email: email, role: role),
                        ),
                      );
                    }),
                   const SizedBox(height: 15),
                    buildReportTile(
                        context, 'Vehicle Pass', Icons.drive_eta,
                        () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DrivePassPage(email: email, role: role),
                        ),
                      );
                    }),

                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildReportTile(
      BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(icon, color: Colors.black),
            const SizedBox(width: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
