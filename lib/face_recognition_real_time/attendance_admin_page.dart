import 'package:created_by_618_abdo/face_recognition_real_time/attendance_registration_screen.dart';
import 'package:created_by_618_abdo/face_recognition_real_time/attendance_taking_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class AttendanceAdminPage extends StatefulWidget {
  const AttendanceAdminPage({super.key});

  @override
  State<AttendanceAdminPage> createState() => _AttendanceAdminPageState();
}

class _AttendanceAdminPageState extends State<AttendanceAdminPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Text("Attendance Admin Page"),
      ),
      floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AttendanceTakingScreen()))),
    );
  }
}
