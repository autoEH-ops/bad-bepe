import 'dart:async';

import 'package:created_by_618_abdo/UserMenuPages/SuperAdminMainMenu.dart';
import 'package:created_by_618_abdo/face_recognition_real_time/attendance_registration_screen.dart';
import 'package:created_by_618_abdo/face_recognition_real_time/attendance_taking_screen.dart';
import 'package:created_by_618_abdo/face_recognition_real_time/model/Attendance.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AttendanceAdminPage extends StatefulWidget {
  const AttendanceAdminPage({super.key});

  @override
  State<AttendanceAdminPage> createState() => _AttendanceAdminPageState();
}

class _AttendanceAdminPageState extends State<AttendanceAdminPage> {
  List<Attendance> attendanceList = [];
  bool isLoading = false;
  final supabase = Supabase.instance.client;
  Timer? refreshTimer;

  @override
  void initState() {
    super.initState();
    fetchAttendance();

    // 🔁 Auto-refresh every 10 seconds
    refreshTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      fetchAttendance();
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  Future<void> fetchAttendance() async {
    try {
      final response = await supabase.from('attendance').select();
      final List<Attendance> records = response.map<Attendance>((row) {
        return Attendance(
          row['id'],
          row['name'],
          DateTime.tryParse(row['attendance_time'] ?? ""),
        );
      }).toList();

      setState(() {
        attendanceList = records;
      });
    } catch (e) {
      print("Error fetching attendance: $e");
    }
  }

  String formatDateTime(DateTime? dateTime) {
    if (dateTime == null) return "No time recorded";
    final formatter = DateFormat('EEEE, d MMMM yyyy • h:mm a');
    final adjustedTime = dateTime.add(Duration(hours: 8));
    return formatter.format(adjustedTime);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Attendance Page"),
        leading: IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SuperAdminMainMenu(
                            email: "629@automattor.com",
                            role: "Super Admin",
                          )));
            },
            icon: Icon(Icons.arrow_back)),
      ),
      body: Column(
        children: [
          // 🔘 Buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const AttendanceTakingScreen()),
                    );
                  },
                  child: Text("Take Attendance"),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) =>
                              const AttendanceRegistrationScreen()), // Your register page
                    );
                  },
                  child: Text("Register Face"),
                ),
              ],
            ),
          ),

          // 📋 Attendance List
          Expanded(
            child: attendanceList.isEmpty
                ? Center(child: Text("No attendance records."))
                : ListView.builder(
                    itemCount: attendanceList.length,
                    itemBuilder: (context, index) {
                      final item = attendanceList[index];
                      return ListTile(
                        leading: Icon(Icons.person),
                        title: Text(item.name),
                        subtitle: Text(formatDateTime(item.attendanceTime)),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
