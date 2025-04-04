import 'package:cloud_firestore/cloud_firestore.dart';

class FolderIDs {
  Future<String?> getClampingFolderID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Clamping")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getElectricPanelReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Electric Panel Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getEmergencyReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Emergency Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getKeyManagementReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Key Management Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getHourlyPostReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Hourly Post Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getMainGateReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Main Gate Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getPassCheckingReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Pass Checking Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getQRImagesID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("QR Images")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getRollCallReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Roll Call Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getRoundingReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Rounding Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getShutterReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Shutter Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getSlidingDoorReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Sliding Door Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getSpotCheckReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("Spot Check Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getVMSContractorReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("VMS Contractor Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getVMSDutyReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("VMS Duty Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }

  Future<String?> getVMSSupplierReportID() async {
    try {
      final DocumentSnapshot folder = await FirebaseFirestore.instance
          .collection("Folder ID")
          .doc("VMS Supplier Report")
          .get();

      if (folder.exists) {
        final data = folder.data();
        if (data is Map && data.containsKey("ID")) {
          final currentID = data["ID"] as String?;
          return currentID;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      print("Error: $e");
      return null;
    }
  }
}
