class RoundingPointReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String location = "Rounding Location";
  static const String nameLists = "Name of Respondent";
  static const String supportingFiles = "Rounding Update Supporting Files";
  static const String remarks = "Remarks";
  static const String reportID = "Report ID";
  static const String shortedUrl = "Rounding Update Shortened URL";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        location,
        nameLists,
        supportingFiles,
        remarks,
        reportID,
        shortedUrl
      ];
}
