import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../GoogleAPIs/GoogleSpreadSheet.dart';
import 'RollCallReportService.dart';

class SubmitRollCallReport extends StatefulWidget {
  const SubmitRollCallReport({super.key, required this.email, required this.role});
  final String email;
  final String role;

  @override
  State<SubmitRollCallReport> createState() => _SubmitRollCallReportState();
}

class _SubmitRollCallReportState extends State<SubmitRollCallReport> {
  // Section Titles and Labels
  static const String title1 = "Roll Call Reporting";
  static const String title3 = "Last Roll Call: ";
  static const String title4 = "List of Security Personnel";
  static const String title5 = "Upload Photo";
  static const String title6 = "Additional Remarks";
  static const String button1 = "Submit Report";
  static const String subTitle1 = "Enter Remarks... ";

  // State Variables
  Map<String, bool> checkedItems = {};
  List<String> securityPersonnelNameList = [];
  List<XFile> rollCallImages = [];
  bool validationErrorPersonnel = false;
  bool validationErrorImages = false;
  bool validationErrorRemarks = false;

  TextEditingController remarksController = TextEditingController();

  String lastRollCallDetails = "No previous roll call found.";
  String? currentShift; // 'Morning' or 'Night' or null
  bool canSubmit = true; // Determines if the user can submit

  // Services
  RollCallReportService rollCallReportService = RollCallReportService();

  @override
  void initState() {
    super.initState();
    _loadSecurityPersonnel();
    _determineCurrentShift();
    _fetchLastRollCall();
  }

  /// Loads the list of security personnel from Google Sheets.
  Future<void> _loadSecurityPersonnel() async {
    try {
      final rows = await GoogleSheets.accountsPage!.values.allRows();
      if (rows.isNotEmpty) {
        for (var row in rows.skip(1)) {
          if (row.length > 4 && row[4] == "Security") {
            securityPersonnelNameList.add(row[0]);
          }
        }
      }
      setState(() {});
    } catch (e) {
      print("Error fetching security personnel: $e");
    }
  }

  /// Determines the current shift based on the time of the day.
  void _determineCurrentShift() {
    final now = DateTime.now();
    if (now.hour >= 8 && now.hour < 20) {
      currentShift = "Morning";
    } else {
      currentShift = "Night";
    }
    setState(() {});
  }

  /// Fetches the last roll call report in the system.
  Future<void> _fetchLastRollCall() async {
    try {
      final lastRollCall = await rollCallReportService.getLastRollCall();
      if (lastRollCall.isNotEmpty) {
        String timestampStr = lastRollCall['Timestamp'] ?? "";
        DateTime dateTime;

        // Parse the timestamp
        if (timestampStr.contains('/')) {
          // If timestamp is already in MM/dd/yyyy HH:mm:ss format
          dateTime = DateFormat('MM/dd/yyyy HH:mm:ss').parse(timestampStr);
        } else if (timestampStr.contains('-')) {
          // If timestamp is ISO8601
          dateTime = DateTime.parse(timestampStr);
        } else {
          // If it's an Excel serial number
          double timestampValue = double.tryParse(timestampStr) ?? 0;
          dateTime = _convertExcelDate(timestampValue);
        }

        String submittedBy = lastRollCall['Email'] ?? "Unknown";
        String shift = lastRollCall['Shift'] ?? "Unknown";

        lastRollCallDetails = '''
Submitted By: $submittedBy
Shift: $shift
Remarks: ${lastRollCall['Remarks']}
Timestamp: ${DateFormat('MM/dd/yyyy HH:mm:ss').format(dateTime)}
''';
      } else {
        lastRollCallDetails = "No previous roll call found.";
      }
      setState(() {});
    } catch (e) {
      print("Error fetching last roll call: $e");
      lastRollCallDetails = "Error fetching last roll call data.";
      setState(() {});
    }
  }

  /// Converts Excel serial date to DateTime
  DateTime _convertExcelDate(double serialDate) {
    // Excel's epoch starts on 1899-12-30
    return DateTime(1899, 12, 30).add(Duration(
      days: serialDate.toInt(),
      milliseconds: ((serialDate - serialDate.toInt()) * 86400000).toInt(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return securityPersonnelNameList.isEmpty
        ? Scaffold(
      backgroundColor: Colors.grey.shade200,
      body: const Center(child: CircularProgressIndicator()),
    )
        : Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        title: const Text(
          "Roll Call Report",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding:
          const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle(context, title1),
              const SizedBox(height: 20),
              _buildLastRollCall(),
              const SizedBox(height: 20),
              _buildCurrentShiftDisplay(),
              if (currentShift != null) ...[
                const SizedBox(height: 20),
                _buildPersonnelSelection(),
                const SizedBox(height: 20),
                _buildPhotoUploadSection(),
                const SizedBox(height: 20),
                _buildRemarksSection(),
                const SizedBox(height: 20),
                _buildSubmitButton(),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the section title widget.
  Widget _buildSectionTitle(BuildContext context, String title) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.blue.shade700,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 18.0,
        ),
      ),
    );
  }

  /// Builds the last roll call display widget.
  Widget _buildLastRollCall() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title3,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            lastRollCallDetails,
            style: const TextStyle(fontSize: 16.0),
          ),
        ],
      ),
    );
  }

  /// Builds the current shift display widget.
  Widget _buildCurrentShiftDisplay() {
    String displayText;
    Color bgColor;
    IconData iconData;
    Color iconColor;

    if (currentShift == "Morning") {
      displayText = "You can submit a Morning shift report.";
      bgColor = Colors.green.shade100;
      iconData = Icons.sunny;
      iconColor = Colors.orange;
    } else if (currentShift == "Night") {
      displayText = "You can submit a Night shift report.";
      bgColor = Colors.blue.shade100;
      iconData = Icons.nightlight_round;
      iconColor = Colors.blue;
    } else {
      displayText =
      "You have already submitted both Morning and Night shift reports for today.";
      bgColor = Colors.red.shade100;
      iconData = Icons.block;
      iconColor = Colors.red;
    }

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            iconData,
            color: iconColor,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              displayText,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16.0,
                color: iconColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the personnel selection widget.
  Widget _buildPersonnelSelection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: validationErrorPersonnel ? Colors.red : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              title4,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          const SizedBox(height: 10),
          ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: securityPersonnelNameList.length,
            itemBuilder: (context, index) {
              String personnelName = securityPersonnelNameList[index];
              return CheckboxListTile(
                controlAffinity: ListTileControlAffinity.leading,
                title: Text(personnelName),
                value: checkedItems[personnelName] ?? false,
                activeColor: Colors.green,
                onChanged: (bool? value) {
                  setState(() {
                    checkedItems[personnelName] = value ?? false;
                    validationErrorPersonnel = false;
                  });
                },
              );
            },
          ),
        ],
      ),
    );
  }

  /// Builds the photo upload section widget.
  Widget _buildPhotoUploadSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: validationErrorImages ? Colors.red : Colors.transparent,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: Text(
              title5,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: rollCallImages.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) {
              return Stack(
                alignment: Alignment.topRight,
                children: [
                  GestureDetector(
                    onTap: () =>
                        _showImageDialog(rollCallImages[index].path),
                    child: kIsWeb
                        ? Image.network(
                      rollCallImages[index].path,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    )
                        : Image.file(
                      File(rollCallImages[index].path),
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.cancel),
                    onPressed: () {
                      setState(() => rollCallImages.removeAt(index));
                    },
                  ),
                ],
              );
            },
          ),
          IconButton(
            onPressed: _pickImage,
            icon: const Icon(Icons.image, size: 30),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }

  /// Builds the remarks section widget.
  Widget _buildRemarksSection() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: validationErrorRemarks ? Colors.red : Colors.transparent,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10.0),
        child: TextFormField(
          controller: remarksController,
          onChanged: (value) => setState(() => validationErrorRemarks = false),
          decoration: InputDecoration(
              hintText: subTitle1, border: InputBorder.none),
          minLines: 3,
          maxLines: null,
        ),
      ),
    );
  }

  /// Builds the submit button widget.
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: canSubmit ? _submitForm : null,
        style: ElevatedButton.styleFrom(
          backgroundColor:
          canSubmit ? Colors.blue.shade800 : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0),
          child: Text(
            button1,
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  /// Handles the form submission.
  void _submitForm() async {
    List<String> selectedPersonnel = checkedItems.entries
        .where((element) => element.value)
        .map((element) => element.key)
        .toList();

    // Validate inputs
    if (selectedPersonnel.isEmpty || rollCallImages.isEmpty || remarksController.text.isEmpty) {
      setState(() {
        validationErrorPersonnel = selectedPersonnel.isEmpty;
        validationErrorImages = rollCallImages.isEmpty;
        validationErrorRemarks = remarksController.text.isEmpty;
      });
      _showErrorDialog();
      return;
    }

    _showLoadingDialog();

    try {
      bool success = await rollCallReportService.addRollCallReport(
        widget.email,
        selectedPersonnel.join(', '),
        rollCallImages,
        remarksController.text,
        currentShift!,
      );

      if (success) {
        Navigator.pop(context); // Close the loading dialog

        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text("Roll call report submitted successfully."),
        ));
        setState(() {
          checkedItems.clear();
          rollCallImages.clear();
          remarksController.clear();
        });
        // Refresh submission status and last roll call
        _determineCurrentShift();
        await _fetchLastRollCall();
      } else {
        Navigator.pop(context); // Close the loading dialog
        _showErrorDialog();
      }
    } catch (e) {
      print("Error submitting roll call report: $e");
      Navigator.pop(context); // Close the loading dialog
      _showErrorDialog();
    }
  }

  /// Handles image picking using the ImagePicker package.
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    setState(() => rollCallImages.addAll(pickedImages));
  }

  /// Displays the selected image in a dialog.
  void _showImageDialog(String imagePath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: kIsWeb
              ? Image.network(
            imagePath,
            fit: BoxFit.cover,
          )
              : Image.file(
            File(imagePath),
            fit: BoxFit.cover,
          ),
        );
      },
    );
  }

  /// Displays a loading dialog during submission.
  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Submitting...'),
              SizedBox(height: 10),
              CircularProgressIndicator(),
            ],
          ),
        );
      },
    );
  }

  /// Displays an error dialog for incomplete details or submission failures.
  void _showErrorDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submission Error"),
          content: const Text("There was an error submitting your report. Please try again."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  /// Displays a dialog indicating that both shifts have been submitted.
  void _showShiftSubmittedDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Submission Denied"),
          content: const Text("You have already submitted both Morning and Night shift reports for today."),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }
}
