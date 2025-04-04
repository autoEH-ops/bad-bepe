import '../../GoogleAPIs/GoogleSpreadSheet.dart';

class LoginHistoryFields {
  static const String timestamp = "Timestamp";
  static const String email = "Email";

  static List<String> getFields() => [timestamp, email];

  static Future insertLoginHistory(List<Map<String, dynamic>> rowList) async {
    if (GoogleSheets.loginHistoryPage == null) return null;
    GoogleSheets.loginHistoryPage!.values.map.appendRows(rowList);
  }
}

class LoginHistoryFieldsData {
  String? timestamp;
  String? email;

  LoginHistoryFieldsData({
    required this.timestamp,
    required this.email,
  });

  static LoginHistoryFieldsData fromJson(Map<String, dynamic> json) =>
      LoginHistoryFieldsData(
        timestamp: json[LoginHistoryFields.timestamp],
        email: json[LoginHistoryFields.email],
      );

  Map<String, dynamic> toJson() => {
        LoginHistoryFields.timestamp: timestamp,
        LoginHistoryFields.email: email,
      };
}
