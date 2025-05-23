import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'RecognitionScreen.dart';
import 'RegistrationScreen.dart';

class FaceRecognitionScreen extends StatefulWidget {
  const FaceRecognitionScreen({Key? key}) : super(key: key);
  @override
  State<FaceRecognitionScreen> createState() => _FaceRecognitionScreenState();
}

class _FaceRecognitionScreenState extends State<FaceRecognitionScreen> {
  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
              margin: const EdgeInsets.only(top: 100),
              child: Image.asset(
                "assets/logo.png",
                width: screenWidth - 40,
                height: screenWidth - 40,
              )),
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            child: Column(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegistrationScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth - 30, 50)),
                  child: const Text("Register"),
                ),
                Container(
                  height: 20,
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RecognitionScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                      minimumSize: Size(screenWidth - 30, 50)),
                  child: const Text("Recognize"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
