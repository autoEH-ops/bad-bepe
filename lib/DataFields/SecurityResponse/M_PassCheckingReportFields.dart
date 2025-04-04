class PassCheckingReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String nameLists = "Name of Respondent";
  static const String repID = "Report ID";
  static const String type = "Pass Type";
  static const String join = "Pass Join";
  static const String attachments = "Vms Report Supporting Files";
  static const String shorten = "Vms Report Shortened URL";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        nameLists,
        repID,
        type,
        join,
        attachments,
        shorten
      ];
}
