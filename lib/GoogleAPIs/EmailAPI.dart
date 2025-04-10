import 'dart:convert';
import 'package:googleapis/gmail/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class GmailAPI {
  final List<String> scopes = ['https://www.googleapis.com/auth/gmail.send'];

  // Send email using Gmail API
  Future<void> sendEmail(String receiverEmail, String code) async {
    var client = http.Client();

    var credentials = ServiceAccountCredentials.fromJson({},
        impersonatedUser: "eh14@kawalanseripadang.com");

    var authClient =
        await clientViaServiceAccount(credentials, scopes, baseClient: client);

    var gmailApi = GmailApi(authClient);
    var from = 'eh14@kawalanseripadang.com'; // The service account email
    var subject = 'Your Code';
    var body = 'Here is your code for the BP System: $code';

    var messageBody = '''
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
to: $receiverEmail
from: $from
subject: $subject

$body
''';

    var message = Message()..raw = base64Url.encode(utf8.encode(messageBody));

    try {
      var sentMessage = await gmailApi.users.messages.send(message, 'me');
      print('Message sent: ${sentMessage.id}');
    } catch (error) {
      print('An error occurred: $error');
    } finally {
      client.close();
    }
  }
}
