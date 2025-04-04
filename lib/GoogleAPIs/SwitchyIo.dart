import 'package:http/http.dart' as http;
import 'dart:convert';

class SwitchyIo {
  Future<List<String>> shortenURLs(List<String> files) async {
    var apiKey = "a98eb03c-e0e0-491c-88bd-056c7cda4f1b";
    var apiUrl = "https://api.switchy.io/v1/links/create";
    var headers = {
      'Api-Authorization': apiKey,
      'Content-Type': 'application/json',
    };

    List<String> shortenedURLs = [];

    for (String file in files) {
      var payloadURL = {
        'link': {
          'url': file,
          'domain': 'r.seripadang.com',
          'masking': true,
        },
      };

      var response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: jsonEncode(payloadURL),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        var responseData = jsonDecode(response.body);
        var id = responseData['id'];
        var shortenedURL = "r.seripadang.com/$id";
        shortenedURLs.add(shortenedURL);
      } else {
        // Handle error
        print('Error: ${response.statusCode}');
      }
    }

    return shortenedURLs;
  }
}
