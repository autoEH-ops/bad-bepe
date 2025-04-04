class SpotCheckReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String name = "Name of Respondent";
  static const String timeOfRep = "Time of Report";
  static const String spotCheckDes = "Spot Check Description";
  static const String spotCheckFin = "Spot Check Findings";
  static const String remarks = "Remarks for Clients";
  static const String prepBy = "Prepared By";
  static const String reportID = "Report ID";
  static const String supportingFiles = "Spot Check Supporting Files";
  static const String shortedUrl = "Spot Check Shortened URL";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        name,
        timeOfRep,
        spotCheckDes,
        spotCheckFin,
        remarks,
        prepBy,
        reportID,
        supportingFiles,
        shortedUrl
      ];
}
