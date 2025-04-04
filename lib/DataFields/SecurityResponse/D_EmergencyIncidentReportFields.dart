class EmergencyReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String nameLists = "Name of Respondent";
  static const String incidentDate = "Incident Date";
  static const String incidentTime = "Incident Time";
  static const String location = "Incident Location";
  static const String incident = "Incident";
  static const String detailedReport = "Detailed Incident Report";
  static const String supportingFiles = "Emergency Report Supporting Files";
  static const String remarks = "Remarks";
  static const String reportID = "Report ID";
  static const String policeRep = "Police Report Made";
  static const String status = "Status";
  static const String followers = "Followers";
  static const String shortedUrl = "Emergency Report Shortened URL";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        nameLists,
        incidentDate,
        incidentTime,
        location,
        incident,
        detailedReport,
        supportingFiles,
        remarks,
        reportID,
        policeRep,
        status,
        followers,
        shortedUrl
      ];
}
