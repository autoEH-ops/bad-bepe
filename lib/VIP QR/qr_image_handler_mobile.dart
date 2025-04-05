import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_picker/image_picker.dart';

/// Mobile/Desktop version: Save as file and prepare for upload
Future<void> handleQrImageForPlatform(
  Uint8List pngBytes,
  List<XFile> images,
) async {
  final directory = await getApplicationCacheDirectory();
  final file = File('${directory.path}/qr.png');
  await file.writeAsBytes(pngBytes);

  print('QR code image saved at ${file.path}');

  images.add(XFile(file.path));
}
