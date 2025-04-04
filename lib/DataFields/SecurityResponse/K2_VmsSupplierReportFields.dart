class VmsSupplierReportFields {
  static const String id = "ID";
  static const String date = "Date";
  static const String time = "Time";
  static const String reportType = "Type of Report";
  static const String email = "Email Respondent";
  static const String nameLists = "Name of Respondent";
  static const String repID = "Report ID";
  static const String categories = "Categories";
  static const String supplier = "Supplier Name";
  static const String inOrOut = "In or Out";
  static const String phone = "Phone Number";
  static const String ic = "IC/Passport Number";
  static const String passNum = "Pass Number";
  static const String vehicleFiles = "Vehicle Photo Supporting Files";
  static const String vehicleURL = "Vehicle Photo Shortened URL";
  static const String licenseFiles = "Driving License Supporting Files";
  static const String licenseURL = "Driving License Shortened URL";
  static const String orderFiles = "Delivery Order Supporting Files";
  static const String orderURL = "Delivery Order Shortened URL";
  static const String itemFiles = "Delivery Item Supporting Files";
  static const String itemURL = "Delivery Item Shortened URL";
  static const String permitFiles = "Supplier Permit Supporting Files";
  static const String permitURL = "Supplier Permit Shortened URL";
  static const String passportFiles = "Passport ID Supporting Files";
  static const String passportURL = "Passport ID Shortened URL";
  static const String licenseFilesOut = "Driving License Out Supporting Files";
  static const String licenseURLOut = "Driving License Out Shortened URL";
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
        supplier,
        inOrOut,
        phone,
        ic,
        passNum,
        vehicleFiles,
        vehicleURL,
        licenseFiles,
        licenseURL,
        orderFiles,
        orderURL,
        itemFiles,
        itemURL,
        permitFiles,
        permitURL,
        passportFiles,
        passportURL,
        licenseFilesOut,
        licenseURLOut,
        numberPlateFiles,
        numberPlateURL
      ];
}
