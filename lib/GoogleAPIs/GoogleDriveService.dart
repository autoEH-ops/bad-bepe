import 'dart:convert';
import 'package:http/http.dart' as http;

class GoogleDriveService {
  final String folderId;
  final String accessToken;

  GoogleDriveService({required this.folderId, required this.accessToken});

  Future<List<String>> fetchImages() async {
    final List<String> imageUrls = [];
    final String apiUrl =
        'https://www.googleapis.com/drive/v3/files?q=\'$folderId\' in parents and mimeType contains \'image/\'&fields=files(id,name,webContentLink)';

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final List<dynamic> files = data['files'] ?? [];

        for (var file in files) {
          final String? webContentLink = file['webContentLink'];
          if (webContentLink != null) {
            imageUrls.add(webContentLink);
          }
        }
      } else {
        print('Failed to load images: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching images: $e');
    }

    return imageUrls;
  }
}
