class HourlyPostReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String gatePost = "Gate Post";
  static const String nameLists = "List Of Duty Security Personnel's Name";
  static const String supportingFiles = "Hourly Post Supporting Files";
  static const String remarks = "Remarks";
  static const String reportID = "Report ID";
  static const String shortedUrl = "Hourly Post Shortened URL";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        gatePost,
        nameLists,
        supportingFiles,
        remarks,
        reportID,
        shortedUrl
      ];
}
