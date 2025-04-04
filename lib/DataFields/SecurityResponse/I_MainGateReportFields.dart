class MainGateReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String name = "Name of Respondent";
  static const String status = "Open or Close";
  static const String shutter = "Main Gate";
  static const String remarks = "Remarks";
  static const String reportID = "Report ID";
  static const String supportingFiles = "Main Gate Report Supporting Files";
  static const String shortedUrl = "Main Gate Shortened URL";

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
