import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'ManageQrCodeMenu.dart';
import 'ScanQrService.dart';

class QrDataDisplay extends StatefulWidget {
  final String qrData;

  const QrDataDisplay({Key? key, required this.qrData}) : super(key: key);

  @override
  State<QrDataDisplay> createState() => _QrDataDisplayState();
}

class _QrDataDisplayState extends State<QrDataDisplay> {
  late Future<Map<String, dynamic>> qrDetails;
  PassType? selectedPassType;
  List<Map<String, String?>> passList = [];
  String? selectedPass;
  List<XFile> emergencyImages = []; // To store multiple images
  final TextEditingController remarksController = TextEditingController();

  bool isPassIn = true; // Default to true
  String? existingPassType;
  String? existingPassId;

  final QrCodeApprovalService approvalService = QrCodeApprovalService();

  @override
  void initState() {
    super.initState();
    qrDetails = approvalService.getQrCodeDetails(widget.qrData).then((data) {
      // Determine the next action based on current status
      String status = data['Status']?.toString().toLowerCase() ?? '';
      if (status == 'pass out' || status == 'not active') {
        // Next action is 'Pass In'
        isPassIn = true;
      } else if (status == 'pass in') {
        // Next action is 'Pass Out'
        isPassIn = false;
      } else {
        // Default to 'Pass In' action
        isPassIn = true;
      }

      // Extract passType from category
      String category = data['category']?.toString() ?? '';
      selectedPassType = _stringToPassType(category);
      existingPassType = category;
      existingPassId = data['passId'];

      // Debug: Print the determined PassType
      print('Category: "$category" mapped to PassType: $selectedPassType');

      // Fetch pass list based on passType
      if (selectedPassType != null) {
        _fetchPassListByType(selectedPassType!).then((_) {
          setState(() {
            if (isPassIn) {
              // We're going to 'Pass In', so selectedPass is null
              selectedPass = null;
            } else {
              // We're going to 'Pass Out', so selectedPass should be set to existing pass used during 'Pass In'
              selectedPass = data['passId'];
              // Also, set passList to contain only the existing pass
              passList = [
                {'pass': selectedPass, 'status': data['Status']}
              ];
            }
          });
        });
      } else {
        _showLogMessage('Unknown Pass Type derived from category: $category');
      }

      return data;
    });
  }

  void _showLogMessage(String message) {
    print(message); // Console logging
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  void dispose() {
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code Details'),
        backgroundColor: Colors.grey.shade300,
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: qrDetails,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data ?? {};

          // Debug: Print the entire data map
          print("QR Data Retrieved: $data");

          // Retrieve 'status2' from data
          String status2 = data['status2']?.toString().toLowerCase() ?? '';

          // Handle different 'status2' values
          if (status2 == 'approved') {
            // Show the QR data as usual
            return _buildQrDataContent(data);
          } else if (status2 == 'pending approved') {
            // Show waiting for approval message
            return _buildStatusMessage("Pending Admin Approval");
          } else if (status2 == 'expired') {
            // Show QR deleted message
            return _buildStatusMessage("This QR Not Available");
          } else {
            // Handle unexpected status2 values
            return _buildStatusMessage("Unknown Status");
          }
        },
      ),
    );
  }

  /// Widget to display QR data details
  Widget _buildQrDataContent(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _fullWidthDetailTile("ID", data['ID'] ?? 'N/A'),
          _fullWidthDetailTile("Name", data['Names'] ?? 'N/A'),
          _fullWidthDetailTile(
              "IC Number / Passport", data['Ic Number'] ?? 'N/A'),
          _fullWidthDetailTile(
              "Car Plate", data['Car Plate'] ?? 'No Car Registered'),
          _fullWidthDetailTile(
              "Phone Number", data['Phone Number'] ?? 'N/A'),
          _fullWidthDetailTile(
              "Start Date", _formatDate(data['Start Date'])),
          _fullWidthDetailTile("End Date", _formatDate(data['End Date'])),
          _fullWidthDetailTile("Status", data['Status'] ?? 'N/A'),
          _fullWidthDetailTile("Email", data['email'] ?? 'N/A'),
          _fullWidthDetailTile("Category", data['category'] ?? 'N/A'),
          if (selectedPassType != null) _passSelector(),
          _buildImageUploader(),
          _remarksSection(),
          if (data['Status'] != null)
            _actionButton(data['Status'] ?? 'Not Active'),
        ],
      ),
    );
  }

  /// Widget to display status messages
  Widget _buildStatusMessage(String message) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Text(
          message,
          style: const TextStyle(
              fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  /// Widget to display full-width detail tiles
  Widget _fullWidthDetailTile(String title, String value) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            "$title: ",
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ),
        ],
      ),
    );
  }

  /// Formats date values into 'dd/MM/yyyy' format.
  String _formatDate(dynamic dateValue) {
    if (dateValue == null || dateValue.toString().isEmpty) return 'N/A';
    if (dateValue is int) {
      var baseDate = DateTime(1899, 12, 30);
      return DateFormat('dd/MM/yyyy')
          .format(baseDate.add(Duration(days: dateValue)));
    } else if (dateValue is String) {
      try {
        DateTime parsedDate = DateTime.parse(dateValue);
        return DateFormat('dd/MM/yyyy').format(parsedDate);
      } catch (e) {
        return dateValue;
      }
    } else {
      return 'N/A';
    }
  }

  /// Converts PassType enum to string.
  String _passTypeToString(PassType passType) {
    switch (passType) {
      case PassType.Contractor:
        return 'Contractor';
      case PassType.Duty:
        return 'Duty';
      case PassType.Supplier:
        return 'Supplier';
      case PassType.Drive:
        return 'Drive';
      case PassType.Guest:
        return 'Guest';
      default:
        return 'Unknown';
    }
  }

  /// Converts string to PassType enum.
  PassType? _stringToPassType(String passTypeStr) {
    passTypeStr = passTypeStr.toLowerCase().trim();
    if (passTypeStr.endsWith(' pass')) {
      passTypeStr =
          passTypeStr.substring(0, passTypeStr.length - ' pass'.length).trim();
    }
    switch (passTypeStr) {
      case 'contractor':
        return PassType.Contractor;
      case 'duty':
        return PassType.Duty;
      case 'supplier':
        return PassType.Supplier;
      case 'drive':
        return PassType.Drive;
      case 'guest':
        return PassType.Guest;
      default:
        print('Unknown Pass Type: $passTypeStr'); // Debug statement
        return null;
    }
  }

  /// Fetches the pass list based on PassType and updates the state.
  Future<void> _fetchPassListByType(PassType passType) async {
    List<Map<String, String?>> fetchedPassList =
    await approvalService.getPassList(passType);
    print('Pass List for ${_passTypeToString(passType)}: $fetchedPassList'); // Debug

    setState(() {
      if (isPassIn) {
        // We're going to 'Pass In', so use the full pass list
        passList = fetchedPassList;
        selectedPass = null; // Reset selected pass
      } else {
        // We're going to 'Pass Out', so show only the pass used during 'Pass In'
        selectedPass = existingPassId;
        passList = [
          {'pass': selectedPass, 'status': 'In Use'}
        ];
      }
    });
  }

  /// Widget to select a pass from the fetched pass list.
  Widget _passSelector() {
    print('Building _passSelector with passList: $passList'); // Debug

    if (passList.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0),
        child: Text(
          "No Passes Available for the Selected Pass Type.",
          style: TextStyle(color: Colors.red, fontSize: 16),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 10),
        const Text("Select Pass",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        DropdownButton<String>(
          value: selectedPass,
          hint: const Text("Choose Pass"),
          isExpanded: true,
          items: passList.map((pass) {
            final passName = pass['pass'];
            if (passName == null || passName.isEmpty) {
              return const DropdownMenuItem<String>(
                value: '',
                child: Text('Invalid Pass'),
              );
            }
            return DropdownMenuItem<String>(
              value: passName,
              child: Text(passName),
            );
          }).toList(),
          onChanged: isPassIn
              ? (value) {
            setState(() {
              selectedPass = value;
              _showLogMessage('Selected Pass: $selectedPass');
            });
          }
              : null, // Disable dropdown during 'Pass Out'
        ),
      ],
    );
  }

  /// Widget to upload and display images.
  Widget _buildImageUploader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Upload Images",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          height: 150,
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, crossAxisSpacing: 4, mainAxisSpacing: 4),
            itemCount: emergencyImages.length + 1, // +1 for the add button
            itemBuilder: (context, index) {
              if (index == emergencyImages.length) {
                // Add button
                return GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.add, size: 40, color: Colors.white),
                  ),
                );
              }
              return Stack(
                children: [
                  emergencyImages[index].path.startsWith('http')
                      ? Image.network(
                    emergencyImages[index].path,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  )
                      : Image.file(
                    File(emergencyImages[index].path),
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          emergencyImages.removeAt(index);
                          _showLogMessage('Image removed.');
                        });
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.cancel,
                            color: Colors.red, size: 20),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }

  /// Picks multiple images using ImagePicker.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages =
    await picker.pickMultiImage(); // Allows multiple image selection
    if (pickedImages != null && pickedImages.isNotEmpty) {
      setState(() {
        emergencyImages.addAll(pickedImages);
        _showLogMessage('${pickedImages.length} Image(s) Selected.');
      });
    }
  }

  /// Widget for additional remarks.
  Widget _remarksSection() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(10.0),
        decoration: BoxDecoration(color: Colors.grey.shade200),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Additional Remarks (Optional)",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            TextFormField(
              controller: remarksController,
              decoration: const InputDecoration(hintText: "Enter Remarks"),
              maxLines: null,
            ),
          ],
        ),
      ),
    );
  }

  /// Widget for the action button to update status.
  Widget _actionButton(String status) {
    String buttonLabel;
    String newStatus;
    Color buttonColor;

    if (status.toLowerCase() == 'not active' ||
        status.toLowerCase().contains('pass out')) {
      buttonLabel = 'Pass In';
      newStatus = 'Pass In';
      buttonColor = Colors.green.shade300;
    } else if (status.toLowerCase().contains('pass in')) {
      buttonLabel = 'Pass Out';
      newStatus = 'Pass Out';
      buttonColor = Colors.red.shade300;
    } else {
      buttonLabel = 'Pass In';
      newStatus = 'Pass In';
      buttonColor = Colors.green.shade300;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
            backgroundColor: buttonColor,
            minimumSize: const Size.fromHeight(50)),
        onPressed: () {
          if (selectedPassType == null) {
            _showLogMessage('Pass Type is not set.');
            return;
          }
          if (selectedPass == null || selectedPass!.isEmpty) {
            _showLogMessage('Please select a Pass.');
            return;
          }
          _updateStatus(newStatus);
          _showLogMessage('Status Update: $newStatus');
        },
        child: Text(buttonLabel,
            style: const TextStyle(color: Colors.white, fontSize: 18)),
      ),
    );
  }

  /// Updates the status by calling the service and handles UI accordingly.
  void _updateStatus(String status) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return const AlertDialog(
          title: Center(child: Text('Updating Status')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16.0),
              Text('Updating QR status...'),
            ],
          ),
        );
      },
    );

    String passTypeToSend =
    selectedPassType != null ? _passTypeToString(selectedPassType!) : 'Unknown';

    String guestPassNameToSend = selectedPass ?? 'No Pass Selected';
    String passIdToSend = guestPassNameToSend; // PassId now correctly set to Pass Name

    approvalService
        .updateQR(
      widget.qrData,
      status,
      passTypeToSend,
      passIdToSend,
      guestPassNameToSend,
      _convertXFilesToSingleImage(emergencyImages),
      remarksController.text,
    )
        .then((_) {
      Navigator.of(context).pop(); // Close the dialog
      setState(() {
        qrDetails =
            approvalService.getQrCodeDetails(widget.qrData); // Refresh data
        emergencyImages.clear(); // Clear images after update
        if (status.toLowerCase().contains('pass in')) {
          isPassIn = false;
          existingPassType = passTypeToSend;
          existingPassId = passIdToSend;
        } else {
          isPassIn = true;
          existingPassType = null;
          existingPassId = null;
          selectedPassType = null;
          selectedPass = null;
        }
      });
      _showLogMessage('QR status updated successfully');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => QrMenuPage(email: '', role: '',)), // Navigate to QrMenuPage
      );
    }).catchError((error) {
      Navigator.of(context).pop(); // Close the dialog
      _showLogMessage('Error updating status: $error');
    });
  }

  /// Converts a list of XFile to a single XFile or handles multiple images as needed
  XFile? _convertXFilesToSingleImage(List<XFile> images) {
    // For simplicity, we'll return the first image. Modify as per your requirements.
    if (images.isNotEmpty) {
      return images.first;
    }
    return null;
  }
}
