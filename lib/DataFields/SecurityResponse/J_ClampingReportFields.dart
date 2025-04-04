class ClampingReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String nameLists = "Name of Respondent";
  static const String carPlate = "Car Plate Number";
  static const String supportingFiles1 = "Car Plate Supporting Files";
  static const String supportingFiles2 = "Clamping Supporting Files";
  static const String remarks = "Remarks";
  static const String reportID = "Report ID";
  static const String status = "Status";
  static const String shortedUrl1 = "Car Plate Shortened URL";
  static const String shortedUrl2 = "Clamping Shortened URL";
  static const String update1 = "Unclamp Attachments";
  static const String update2 = "Unclamp Shorten URL";
  static const String update3 = "Payment Slips Attachments";
  static const String update4 = "Payment Slips Shortened";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        nameLists,
        carPlate,
        supportingFiles1,
        supportingFiles2,
        remarks,
        reportID,
        status,
        shortedUrl1,
        shortedUrl2,
        update1,
        update2,
        update3,
        update4
      ];
}
