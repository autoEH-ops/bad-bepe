class ShutterReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String name = "Name of Respondent";
  static const String status = "Open or Close";
  static const String shutter = "Shutter";
  static const String remarks = "Remarks";
  static const String reportID = "Report ID";
  static const String supportingFiles = "Shutter Report Supporting Files";
  static const String shortedUrl = "Shutter Report Shortened URL";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        name,
        status,
        shutter,
        supportingFiles,
        remarks,
        reportID,
        shortedUrl
      ];
}
