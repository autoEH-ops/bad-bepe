import 'package:http/http.dart' as http;

class TelegramAPI {
  Future<void> sendMessage(String message) async {
    var url =
        'https://api.telegram.org/bot6728465310:AAHFjJb9i2v344ajbpcXjgLmSrnZbO6r2xI/sendMessage';
    var response = await http.post(
      Uri.parse(url),
      body: {
        'chat_id': "-4267435258",
        'text': message,
      },
    );

    if (response.statusCode == 200) {

    } else {
      print('Failed to send message: ${response.statusCode}');
    }
  }
}
