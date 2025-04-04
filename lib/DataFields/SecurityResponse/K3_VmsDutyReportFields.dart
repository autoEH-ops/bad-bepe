class VmsDutyReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String nameLists = "Name of Respondent";
  static const String repID = "Report ID";
  static const String categories = "Categories";
  static const String inOrOut = "In or Out";
  static const String phone = "Phone Number";
  static const String ic = "IC/Passport Number";
  static const String passNum = "Pass Number";
  static const String dutyFiles = "Duty Vms Report Supporting Files";
  static const String dutyURL = "Duty Vms Report Shortened URL";
  static const String passportFiles = "Passport ID Supporting Files";
  static const String passportURL = "Passport ID Shortened URL";
  static const String licenseFiles = "Driving License Supporting Files";
  static const String licenseURL = "Driving License Shortened URL";
  static const String numberPlateFiles = "Number Plate Supporting Files";
  static const String numberPlateURL = "Number Plate Shortened URL";

  // Return a List of fields defined
  static List<String> getFields() => [
        id,
        date,
        time,
        reportType,
        email,
        nameLists,
        repID,
        categories,
        inOrOut,
        phone,
        ic,
        passNum,
        dutyFiles,
        dutyURL,
        passportFiles,
        passportURL,
        licenseFiles,
        licenseURL,
        numberPlateFiles,
        numberPlateURL
      ];
}
