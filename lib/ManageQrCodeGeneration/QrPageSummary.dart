import 'dart:io';
import 'dart:ui' as ui;
import 'qr_image_handler.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '/GoogleAPIs/GoogleDrive.dart';
import '/GoogleAPIs/SwitchyIo.dart';
import 'QrGeneratorService.dart';

class QrSummary extends StatelessWidget {
  const QrSummary({
    super.key,
    required this.icNum,
    required this.name,
    required this.number,
    required this.carPlate,
    required this.startDate,
    required this.endDate,
    required this.email,
    required this.category,
  });

  final String email;
  final String category;
  final String icNum;
  final String name;
  final String number;
  final String carPlate;
  final String startDate;
  final String endDate;

  @override
  Widget build(BuildContext context) {
    QrGeneratorService qrGeneratorService = QrGeneratorService();
    final String safeEmail = email.isEmpty ? "" : email;
    final String safeNumber = number.isEmpty ? "" : number;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Column(
            children: [
              // Rest of your UI elements
              // ...
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          height: 50, // Adjust the height as needed
                          color: Colors.redAccent,
                          alignment: Alignment.center,
                          child: const Text(
                            "B A C K",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          storeQrImage(
                              "$name|$number|$startDate|$endDate|$icNum|");

                          showDialog(
                            context: context,
                            barrierDismissible: false,
                            builder: (context) {
                              Future.delayed(const Duration(seconds: 2), () {
                                Navigator.of(context).pop();
                                Navigator.pop(context);
                                Navigator.pop(context);
                              });

                              return const AlertDialog(
                                title:
                                    Center(child: Text('Generating QR Code')),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    CircularProgressIndicator(),
                                    SizedBox(height: 16.0),
                                    Text(
                                      'Loading...',
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          height: 50, // Adjust the height as needed
                          color: Colors.green, // Color for right container
                          alignment: Alignment.center,
                          child: const Text(
                            "C O N F I R M",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> storeQrImage(String qrData) async {
    DateTime currentTime = DateTime.now();
    GoogleDrive googleDrive = GoogleDrive();
    SwitchyIo switchyIo = SwitchyIo();
    QrGeneratorService qrGeneratorService = QrGeneratorService();

    String newQrData = "$qrData$currentTime";
    List<XFile> images = [];

    final qrPainter = QrPainter(
      data: newQrData,
      version: QrVersions.auto,
    );

    final picture = qrPainter.toPicture(390);
    final image = await picture.toImage(400, 400);
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);

    if (byteData != null) {
      Uint8List pngBytes = byteData.buffer.asUint8List();

      await handleQrImageForPlatform(pngBytes, images);

      // Proceed with uploading the images
      List<String> googleDriveImages = await googleDrive.getGoogleDriveFilesUrl(
          images, "1ftYwhxUvWmDGttjqVwAZ6JgHKn3IQG0w");
      List<String> newImagesList = List<String>.from(googleDriveImages);

      String image =
          "https://lh3.googleusercontent.com/d/${googleDriveImages[0]}";

      for (int i = 0; i < googleDriveImages.length; i++) {
        newImagesList[i] =
            "https://lh3.googleusercontent.com/d/${googleDriveImages[i]}";
      }

      for (int i = 0; i < googleDriveImages.length; i++) {
        googleDriveImages[i] =
            "https://drive.google.com/file/d/${googleDriveImages[i]}/view?usp=sharing";
      }

      List<String> switchIoImages = await switchyIo.shortenURLs(newImagesList);

      String list_1 = googleDriveImages.join(', ');
      String list_2 = switchIoImages.join(', ');

      // Send WhatsApp Message
      qrGeneratorService.sendWhatsAppMessage(
        msg:
            "QR Link: $list_2\nName: $name\nPhone Number: $number\nIC Number: $icNum\nCar Plate: $carPlate\nStart Date: $startDate\nEnd Date: $endDate",
        phoneNumber: number,
        email: email,
        attachments: image,
      );

      qrGeneratorService.addQrCodes(
        qr: "$name|${number ?? ""}|$startDate|$endDate|$icNum|$currentTime",
        // Ensure number is never null
        name: name,
        ic: icNum,
        car: carPlate,
        num: number ?? "",
        // Default to empty string if number is null
        start: startDate,
        end: endDate,
        googleImage: list_1,
        switchyImage: list_2,
        email: email ?? "",
        // Default to empty string if email is null
        category: category,
        status2: '',
        passType: category,
      );
    }
  }
}
