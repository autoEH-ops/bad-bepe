import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';

String createObjectUrlFromBlob(List<int> bytes) {
  final blob = html.Blob([bytes]);
  return html.Url.createObjectUrlFromBlob(blob);
}

/// Web version: Handle QR image upload logic for Web
Future<void> handleQrImageForPlatform(
  Uint8List pngBytes,
  List<XFile> images,
) async {
  print('QR code image generated for Web');

  // Create Blob URL
  final blob = html.Blob([pngBytes], 'image/png');
  final imageUrl = html.Url.createObjectUrlFromBlob(blob);
  print('QR code image URL: $imageUrl');

  // Use byte data for upload
  images.add(XFile.fromData(
    pngBytes,
    mimeType: 'image/png',
    name: 'qr_code.png',
  ));
}
