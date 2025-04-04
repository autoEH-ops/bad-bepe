class RollCallReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String shift = "Shift";
  static const String nameLists = "List Of Duty Security Personnel's Name";
  static const String supportingFiles = "Roll Call Supporting Files";
  static const String remarks = "Remarks";
  static const String reportID = "Report ID";
  static const String shortedUrl = "Roll Call Shortened URL";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        shift,
        nameLists,
        supportingFiles,
        remarks,
        reportID,
        shortedUrl
      ];
}
