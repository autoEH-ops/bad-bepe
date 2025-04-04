import 'package:http/http.dart' as http;
import 'dart:convert';

class ApiService {
  // Counter for API calls
  int apiCallCount = 0;

  // Example API endpoint
  final String apiUrl = "https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}/values/{range}";

  // Function to make an API call
  Future<void> makeApiCall() async {
    apiCallCount++;  // Increment the API call counter
    print("API Call Count: $apiCallCount");

    // Call the API (make sure to replace with actual logic)
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful response
      var data = json.decode(response.body);
      print("Response: $data");
    } else {
      print("Error: ${response.statusCode}");
    }
  }
}
