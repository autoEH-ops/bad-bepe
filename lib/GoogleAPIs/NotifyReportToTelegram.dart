import 'package:http/http.dart' as http;
import 'dart:convert';

class NotifyReportToTelegram {
  static const String telegramBotToken = '6728465310:AAHFjJb9i2v344ajbpcXjgLmSrnZbO6r2xI';

  // Map each report type to its specific Telegram chat ID
  static const Map<String, String> reportChatIds = {
    'Hourly Post Update Report': '-1002360438898',
    'Rounding Point Report': '-1002372925974',
    'Roll Call Report': '-1002314407388',
    'Spot Check Report': '-1002442591831',
    'Emergency Report': '-1002367695011',
    'Key Management Report': '-1002269701369',
    'VMS Contractor Report': '-1002413986229',
    'VMS Supplier Report': '-1002413986229',
    'VMS Duty Report': '-1002413986229',
  };

  // Method to send notification to Telegram
  static Future<void> notify(String sheetName, List<String> rowData) async {
    final chatId = reportChatIds[sheetName];
    if (chatId == null) {
      print("Error: Chat ID not found for report type '$sheetName'.");
      return;
    }

    // Escape Markdown characters in sheetName and rowData
    final escapedSheetName = _escapeMarkdown(sheetName);
    final escapedRowData = rowData.map((item) => _escapeMarkdown(item)).toList();

    // Format the message with escaped Markdown and cleaner presentation
    final message = '''
*New Report Submitted*

*Report Type:* $escapedSheetName
*Details:*
${escapedRowData.map((item) => '\\-$item').join('\n')}
    ''';

    await _sendToTelegram(chatId, message);
  }

  // Method to send the actual message to Telegram
  static Future<void> _sendToTelegram(String chatId, String message) async {
    final url = 'https://api.telegram.org/bot$telegramBotToken/sendMessage';
    final payload = {
      'chat_id': chatId,
      'text': message,
      'parse_mode': 'MarkdownV2',
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {
        print("Telegram notification sent successfully to $chatId.");
      } else {
        print("Telegram API Error for $chatId: ${response.body}");
      }
    } catch (e) {
      print("Error sending Telegram message to $chatId: $e");
    }
  }

  // Method to escape special Markdown characters
  static String _escapeMarkdown(String text) {
    // Escapes all MarkdownV2 special characters
    return text.replaceAllMapped(
      RegExp(r'([_*[\]()~`>#+\-=|{}.!\\])'),
          (match) => '\\${match[0]}',
    );
  }
}