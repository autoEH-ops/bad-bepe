import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'QrDataDisplay.dart';
// Ensure this imports your QR Code Approval Service

class ScanQrPage extends StatefulWidget {
  const ScanQrPage({super.key, required this.email});

  final String email;

  @override
  State<ScanQrPage> createState() => _ScanQrPageState();
}

class _ScanQrPageState extends State<ScanQrPage> {
  final MobileScannerController cameraController = MobileScannerController();
  String? scannedData; // Variable to hold the scanned QR code data

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner'),
        centerTitle: true,
        backgroundColor: Colors.lightBlue,
      ),
      body: Column(
        children: [
          SizedBox(
            height: 300, // Fixed height for the camera view
            child: MobileScanner(
              controller: cameraController,
              onDetect: (capture) {
                _onBarcodeDetected(capture);
              },
            ),
          ),
        ],
      ),
    );
  }

  void _onBarcodeDetected(BarcodeCapture capture) {
    final List<Barcode> barcodes = capture.barcodes;

    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        print('Detected QR Code: ${barcode.rawValue}');

        // Store the scanned data
        scannedData = barcode.rawValue!;

        // Navigate to QR data display page
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QrDataDisplay(qrData: scannedData!),
          ),
        );

        break; // Break after first detection to avoid multiple navigations
      }
    }
  }
}
