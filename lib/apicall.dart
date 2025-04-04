import 'dart:async';
import 'dart:convert';

class ApiService {
  int apiCallCount = 0;
  final int maxApiCallsPerSecond = 60;
  final Duration delayDuration = Duration(milliseconds: 1000 ~/ 60);

  get http => null; // 1 second / 60 = ~16ms per request

  Future<void> makeApiCall() async {
    // Check if we are over the limit
    if (apiCallCount >= maxApiCallsPerSecond) {
      print('Rate limit reached. Waiting for the next second...');
      await Future.delayed(Duration(seconds: 1)); // wait for the next second
      apiCallCount = 0; // Reset counter
    }

    apiCallCount++;  // Increment the API call counter
    print("API Call Count: $apiCallCount");

    // Make the API call
    await _callGoogleSheetsApi();
  }

  Future<void> _callGoogleSheetsApi() async {
    final response = await http.get(
      Uri.parse('https://sheets.googleapis.com/v4/spreadsheets/{spreadsheetId}/values/{range}'),
      headers: {
        'Authorization': 'Bearer YOUR_ACCESS_TOKEN',
      },
    );

    if (response.statusCode == 200) {
      var data = json.decode(response.body);
      print('API Response: $data');
    } else {
      print('Failed to load data: ${response.statusCode}');
    }
  }
}
