// web_image_utils.dart
import 'dart:html' as html;

String createObjectUrlFromBlob(List<int> bytes) {
  final blob = html.Blob([bytes]);
  return html.Url.createObjectUrlFromBlob(blob);
}
