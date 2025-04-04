/*import '/GoogleAPIs/GoogleSpreadSheet.dart';

 class SecurityFields {
  static const String name = "Names";
   static const String hourlyPostUpdateStatus =
       "Hourly Post Update Report Status";
   static const String rollCallStatus = "Roll Call Report Status";
   static const String roundingReportStatus = "Rounding Report Status";
  static const String emergencyReportStatus = "Emergency Report Status";
   static const String spotCheckReportStatus = "Spot Check Report Status";
   static const String shutterReportStatus = "Shutter Report Status";
   static const String electricPanelReportStatus =
      "Electric Panel Report Status";
   static const String glassSlidingReportStatus = "Glass Sliding Report Status";
   static const String mainGateReportStatus = "Main Gate Report Status";
   static const String clampingReportStatus = "Clamping Report Status";
   static const String vmsReportStatus = "VMS Report Status";
   static const String qrReportStatus = "QR Report Status";
   static const String passCheckingReportStatus = "Pass Checking Report Status";
   static const String emergencyFollowUpReportStatus =
       "Emergency Follow Up Report Status";
  static const String clampingFollowUpReportStatus =
       "Clamping Follow Up Report Status";
   static const String passCheckFollowUpReportStatus =
       "Pass Check Follow Up Report Status";

   Return a List of fields defined
   static List<String> getFields() => [
         name,
         hourlyPostUpdateStatus,
         rollCallStatus,
         roundingReportStatus,
         emergencyReportStatus,
         spotCheckReportStatus,
         shutterReportStatus,
         electricPanelReportStatus,
         glassSlidingReportStatus,
         mainGateReportStatus,
        clampingReportStatus,
         vmsReportStatus,
         qrReportStatus,
        passCheckingReportStatus,
        emergencyFollowUpReportStatus,
         clampingFollowUpReportStatus,
         passCheckFollowUpReportStatus
      ];

  static Future insert(List<Map<String, dynamic>> rowList) async {
    if (GoogleSheets.securityPersonnelNameListPage == null) return null;
    GoogleSheets.securityPersonnelNameListPage!.values.map.appendRows(rowList);
  }
 }

class SecurityFieldsData {
   String? name;
   String? hourlyPostUpdateStatus;
   String? rollCallStatus;
  String? roundingReportStatus;
 String? emergencyReportStatus;
   String? spotCheckReportStatus;
   String? shutterReportStatus;
  String? electricPanelReportStatus;
   String? glassSlidingReportStatus;
  String? mainGateReportStatus;
  String? clampingReportStatus;
 String? vmsReportStatus;
 String? qrReportStatus;
 String? passCheckingReportStatus;
String? emergencyFollowUpReportStatus;
  String? clampingFollowUpReportStatus;
  String? passCheckFollowUpReportStatus;
 SecurityFieldsData({
   this.name,
   this.hourlyPostUpdateStatus,
    this.rollCallStatus,
    this.roundingReportStatus,
    this.emergencyReportStatus,
     this.spotCheckReportStatus,
    this.shutterReportStatus,
     this.electricPanelReportStatus,
     this.glassSlidingReportStatus,
     this.mainGateReportStatus,
     this.clampingReportStatus,
     this.vmsReportStatus,
     this.qrReportStatus,
     this.passCheckingReportStatus,
   this.emergencyFollowUpReportStatus,
     this.clampingFollowUpReportStatus,
   this.passCheckFollowUpReportStatus,
  });
  static SecurityFieldsData fromJson(Map<String, dynamic> json) =>
      SecurityFieldsData(
           name: json[SecurityFields.name],
           hourlyPostUpdateStatus: json[SecurityFields.hourlyPostUpdateStatus],
           rollCallStatus: json[SecurityFields.rollCallStatus],
           roundingReportStatus: json[SecurityFields.roundingReportStatus],
           emergencyReportStatus: json[SecurityFields.emergencyReportStatus],
           spotCheckReportStatus: json[SecurityFields.spotCheckReportStatus],
           shutterReportStatus: json[SecurityFields.shutterReportStatus],
           electricPanelReportStatus:
               json[SecurityFields.electricPanelReportStatus],
           glassSlidingReportStatus:
               json[SecurityFields.glassSlidingReportStatus],
           mainGateReportStatus: json[SecurityFields.mainGateReportStatus],
           clampingReportStatus: json[SecurityFields.clampingReportStatus],
           vmsReportStatus: json[SecurityFields.vmsReportStatus],
           qrReportStatus: json[SecurityFields.qrReportStatus],
           passCheckingReportStatus:
               json[SecurityFields.passCheckingReportStatus],
           emergencyFollowUpReportStatus:
               json[SecurityFields.emergencyFollowUpReportStatus],
           clampingFollowUpReportStatus:
               json[SecurityFields.clampingFollowUpReportStatus],
           passCheckFollowUpReportStatus:
               json[SecurityFields.passCheckFollowUpReportStatus]);

   Map<String, dynamic> toJson() => {
         SecurityFields.name: name,
         SecurityFields.hourlyPostUpdateStatus: hourlyPostUpdateStatus,
         SecurityFields.rollCallStatus: rollCallStatus,
         SecurityFields.roundingReportStatus: roundingReportStatus,
         SecurityFields.emergencyReportStatus: emergencyReportStatus,
         SecurityFields.spotCheckReportStatus: spotCheckReportStatus,
         SecurityFields.shutterReportStatus: shutterReportStatus,
         SecurityFields.electricPanelReportStatus: electricPanelReportStatus,
         SecurityFields.glassSlidingReportStatus: glassSlidingReportStatus,
         SecurityFields.mainGateReportStatus: mainGateReportStatus,
         SecurityFields.clampingReportStatus: clampingReportStatus,
         SecurityFields.vmsReportStatus: vmsReportStatus,
         SecurityFields.qrReportStatus: qrReportStatus,
         SecurityFields.passCheckingReportStatus: passCheckingReportStatus,
         SecurityFields.emergencyFollowUpReportStatus:
             emergencyFollowUpReportStatus,
         SecurityFields.clampingFollowUpReportStatus:
             clampingFollowUpReportStatus,
         SecurityFields.passCheckFollowUpReportStatus:
             passCheckFollowUpReportStatus
       };
 }
*/
