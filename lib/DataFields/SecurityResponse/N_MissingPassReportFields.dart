class MissingPassReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String nameLists = "Name of Respondent";
  static const String repID = "Report ID";
  static const String type = "Missing Pass";
  static const String status = "Status";
  static const String category = "Category";
  static const String remark = "Remarks";
  static const String attachments = "Missing Pass Supporting Files";
  static const String shorten = "Missing Pass Shortened URL";

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
        status,
        category,
        remark,
        attachments,
        shorten
      ];
}
