import 'dart:async';
import 'dart:math';
import 'package:camera/camera.dart';
import 'package:created_by_618_abdo/GoogleAPIs/GoogleSpreadSheet.dart';
import 'package:created_by_618_abdo/Login/LoginPage.dart';
import 'package:created_by_618_abdo/face_recognition/face_recognition_screen.dart';
import 'package:created_by_618_abdo/face_recognition_real_time/realtime_recognition.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'DataFields/Settings/Create.dart';

late List<CameraDescription> cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyCSkckYyBnKmMVAFN40vqKUpf1NLHL4NQs",
        authDomain: "pb-security-system-b3f0a.firebaseapp.com",
        projectId: "pb-security-system-b3f0a",
        storageBucket: "pb-security-system-b3f0a.firebasestorage.app",
        messagingSenderId: "1013021365519",
        appId: "1:1013021365519:web:6b08ef5145b03af50a1a7a",
        measurementId: "G-Y9F9SLNVPV"),
  );

  bool connected1 = await GoogleSheets.connectToAccountDetails();
  bool connected2 = await GoogleSheets.connectToReportList();
  bool connected3 = await GoogleSheets.connectToDataList();

  if (!connected1 || !connected2 || !connected3) {
    print("Failed to connect to one or more Google Sheets. Exiting...");
    // return;
  }

// Continue with your logic after successful connection

  const mainPrint = 'Create by 618 (Abdo)';

  if (!checkPrintIntegrity(mainPrint)) {
    print("Print statement in main.dart altered! Exiting...");
    return;
  }

  cameras = await availableCameras();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    print('Create by 618 (Abdo)');

    return ScreenUtilInit(
      designSize: Size(375, 812),
      builder: (context, child) {
        return MaterialApp(
          title: 'Security Management',
          theme: ThemeData(
            primarySwatch: Colors.blue,
          ),
          home: RealtimeRecognitionScreen(),
          // FaceRecognitionScreen(),
          // LoadingScreen(),
        );
      },
    );
  }
}

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  bool isConnected = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _initializeData();
  }

  Future<void> _initializeData() async {
    await Future.delayed(Duration(seconds: 5));

    if (GoogleSheets.accountsPage != null) {
      setState(() {
        isConnected = true;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } else {
      setState(() {
        isConnected = true;
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => ErrorPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                return Transform.rotate(
                  angle: _controller.value * 2.0 * pi,
                  child: Icon(
                    Icons.security,
                    size: 80.sp,
                    color: Colors.greenAccent,
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 5),
              builder: (context, value, child) {
                return Opacity(
                  opacity: value,
                  child: Text(
                    'Loading Secure Environment...',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 20.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 20.h),
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(seconds: 3),
              builder: (context, value, child) {
                return Text(
                  _generateRandomCodeSnippet(),
                  style: TextStyle(
                    color: Colors.greenAccent.withOpacity(0.7),
                    fontFamily: 'Courier',
                    fontSize: 16.sp,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  String _generateRandomCodeSnippet() {
    const codeSnippets = [
      "Initializing Firewall...",
      "Encrypting Data...",
      "Generating Secure Keys...",
      "Authenticating...",
      "Establishing Secure Connection...",
    ];
    final random = Random();
    return codeSnippets[random.nextInt(codeSnippets.length)];
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Error"),
      ),
      body: Center(
        child: Text(
          "Failed to connect to Google Sheets. Please try again later.",
          style: TextStyle(fontSize: 18.sp),
        ),
      ),
    );
  }
}
