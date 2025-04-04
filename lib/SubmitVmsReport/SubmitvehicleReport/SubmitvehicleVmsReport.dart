
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gsheets/gsheets.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import '../../GoogleAPIs/GoogleSpreadSheet.dart';
import '../SubmitSupplierReport/web_image_utils.dart';
import 'Vehicleservice.dart';

class DrivePassPage extends StatefulWidget {
  const DrivePassPage({super.key, required this.email, required this.role});

  final String email;
  final String role;

  @override
  State<DrivePassPage> createState() => _DrivePassPageState();
}

class _DrivePassPageState extends State<DrivePassPage> {
  final DrivePassVmsService drivePassVmsService = DrivePassVmsService();

  final TextEditingController numberController = TextEditingController();
  final TextEditingController icController = TextEditingController();
  final TextEditingController carPlateController = TextEditingController();

  List<Map<String, String?>> drivePassList = [];
  List<Map<String, String?>> contractorPassList = [];
  List<Map<String, String?>> dutyPassList = [];
  List<Map<String, String?>> supplierPassList = [];
  List<Map<String, String?>> guestPassList = []; // Added Guest Pass List

  List<Map<String, String?>> GuestDrivereport = []; // Added GuestDrivereport

  String? selectedDrivePass;
  String? selectedContractorPass;
  String? selectedDutyPass;
  String? selectedSupplierPass;
  String? selectedGuestPass; // Added selectedGuestPass

  String? selectedLocation;
  String? currentPassType;

  bool isLoading = true;
  bool showDriverList = false;
  bool showContractorList = false;
  bool showDutyList = false;
  bool showSupplierList = false;
  bool showGuestList = false; // Added showGuestList

  XFile? driverImage;

  @override
  void initState() {
    super.initState();
    _fetchAllPassLists();
  }
  List<String> getPassStatus(String passType, String passName) {
    List<Map<String, String?>> passList;

    // Select the correct pass list based on pass type
    switch (passType) {
      case 'Drive Pass':
        passList = drivePassList;
        break;
      case 'Contractor Pass':
        passList = contractorPassList;
        break;
      case 'Duty Pass':
        passList = dutyPassList;
        break;
      case 'Supplier Pass':
        passList = supplierPassList;
        break;
      case 'Guest Pass':
        passList = guestPassList;
        break;
      default:
        passList = [];
        break;
    }

    // Find the pass in the selected list
    final pass = passList.firstWhere(
            (pass) => pass['pass'] == passName,
        orElse: () => {} // Return an empty map if not found
    );

    // Return both "Pass In" and "Pass Out" if present, otherwise default to "Pass In"
    List<String> statuses = [];

    if (pass['status'] != null) {
      statuses.add(pass['status']!); // Add the existing status
    }

    // Ensure "Pass In" and "Pass Out" are always in the result if needed
    if (!statuses.contains('Pass In')) {
      statuses.add('Pass In');
    }
    if (!statuses.contains('Pass Out')) {
      statuses.add('Pass Out');
    }

    return statuses;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drive Pass Page'),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildPassTypeButtons(),
              SizedBox(height: 20),
              if (selectedLocation == 'Pass In') ...[
                _buildPassButtonsRow(),
                if (showContractorList) _buildContractorList(),
                if (showDutyList) _buildDutyList(),
                if (showSupplierList) _buildSupplierList(),
                if (showGuestList) _buildGuestList(), // Added Guest List
              ],
              if (selectedLocation == 'Pass Out') ...[
                _buildPassButtonsRow(),
                if (showContractorList) _buildContractorList(),
                if (showDutyList) _buildDutyList(),
                if (showSupplierList) _buildSupplierList(),
                if (showGuestList) _buildGuestList(),
              ],
              SizedBox(height: 20),
              if (showDriverList) _buildDriverList(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPassTypeButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedLocation = 'Pass In';
                currentPassType = 'Drive Pass';
                showDriverList = true;
                _resetOtherPassLists();
                // Fetch the filtered pass lists for Pass In
                _fetchAllPassLists();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedLocation == 'Pass In' ? Colors.blue : Colors.grey,
            ),
            child: Text('Pass In'),
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              setState(() {
                selectedLocation = 'Pass Out';
                currentPassType = 'Drive Pass';
                showDriverList = true;
                _resetOtherPassLists();
                // Fetch the filtered pass lists for Pass Out
                _fetchAllPassLists();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: selectedLocation == 'Pass Out' ? Colors.blue : Colors.grey,
            ),
            child: Text('Pass Out'),
          ),
        ),
      ],
    );
  }


  Widget _buildPassButtonsRow() {
    return Row(
      children: [
        _buildPassButton('Contractor Pass', () {
          setState(() {
            showContractorList = !showContractorList;
            _collapseOtherPassLists('Contractor');
          });
        }, showContractorList),
        SizedBox(width: 10),
        _buildPassButton('Duty Pass', () {
          setState(() {
            showDutyList = !showDutyList;
            _collapseOtherPassLists('Duty');
          });
        }, showDutyList),
        SizedBox(width: 10),
        _buildPassButton('Supplier Pass', () {
          setState(() {
            showSupplierList = !showSupplierList;
            _collapseOtherPassLists('Supplier');
          });
        }, showSupplierList),
        SizedBox(width: 10),
        _buildPassButton('Guest Pass', () { // Added Guest Pass Button
          setState(() {
            showGuestList = !showGuestList;
            _collapseOtherPassLists('Guest');
          });
        }, showGuestList),
      ],
    );
  }

  Widget _buildPassButton(String label, VoidCallback onPressed, bool isSelected) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isSelected ? Colors.green : Colors.grey,
        ),
        child: Text(label),
      ),
    );
  }

  Widget _buildContractorList() {
    return _buildPassList('Contractor Pass', selectedContractorPass, (value) {
      setState(() {
        selectedContractorPass = value;
        currentPassType = 'Contractor Pass';
        _autoFillData(value ?? '');
      });
    });
  }

  Widget _buildDutyList() {
    return _buildPassList('Duty Pass', selectedDutyPass, (value) {
      setState(() {
        selectedDutyPass = value;
        currentPassType = 'Duty Pass';
        _autoFillData(value ?? '');
      });
    });
  }

  Widget _buildSupplierList() {
    return _buildPassList('Supplier Pass', selectedSupplierPass, (value) {
      setState(() {
        selectedSupplierPass = value;
        currentPassType = 'Supplier Pass';
        _autoFillData(value ?? '');
      });
    });
  }

  Widget _buildGuestList() { // Added Guest List Widget
    return _buildPassList('Guest Pass', selectedGuestPass, (value) {
      setState(() {
        selectedGuestPass = value;
        currentPassType = 'Guest Pass';
        _autoFillData(value ?? '');
      });
    });
  }

  Widget _buildPassList(String passType, String? selectedPass, Function(String?) onChanged) {
    List<Map<String, String?>> list;
    switch (passType) {
      case 'Contractor Pass':
        list = contractorPassList;
        break;
      case 'Duty Pass':
        list = dutyPassList;
        break;
      case 'Supplier Pass':
        list = supplierPassList;
        break;
      case 'Guest Pass': // Handle Guest Pass
        list = guestPassList;
        break;
      default:
        list = drivePassList;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedPass,
        decoration: InputDecoration(
          labelText: 'Select a $passType',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        items: list.map((pass) => DropdownMenuItem(
          value: pass['pass'],
          child: Text(pass['pass'] ?? ''),
        )).toList(),
        onChanged: onChanged,
      ),
    );
  }

  Widget _buildDriverList() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('Driver Pass'),
        _buildDropdown('Drive Pass', selectedDrivePass, (value) {
          setState(() {
            selectedDrivePass = value;
            currentPassType = 'Drive Pass';
            _autoFillData(value ?? '');
          });
        }),
        SizedBox(height: 20),
        _buildForm(),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    );
  }

  Widget _buildDropdown(String title, String? selectedValue, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      value: selectedValue,
      items: drivePassList.map((pass) {
        return DropdownMenuItem(value: pass['pass'], child: Text(pass['pass'] ?? ''));
      }).toList(),
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: title,
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField('Valid Malaysia Mobile Number', numberController, 'Enter Numbers'),
        SizedBox(height: 16),
        _buildTextField('IC / Passport Number', icController, 'Enter IC Numbers'),
        SizedBox(height: 16),
        _buildTextField('Vehicle Plate', carPlateController, 'Enter Vehicle Plate'),
        SizedBox(height: 16),
        _buildImagePickerButton('Vehicle Image', () => _pickImage('Driver'), driverImage),
        SizedBox(height: 16),
        ElevatedButton(
          onPressed: _submitForm,
          child: const Text('Click to Submit'),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, String hint) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: Colors.grey.shade400),
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _fetchAllPassLists() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch all pass lists
      drivePassList = await drivePassVmsService.fetchDrivePassList();
      contractorPassList = await drivePassVmsService.fetchContractorPassList();
      dutyPassList = await drivePassVmsService.fetchDutyPassList();
      supplierPassList = await drivePassVmsService.fetchSupplierPassList();
      guestPassList = await drivePassVmsService.fetchGuestPassList(); // Fetch Guest Pass List

      // Filter based on Pass In or Pass Out selection
      if (selectedLocation == 'Pass In') {
        _filterPassLists('Pass Out');
      } else if (selectedLocation == 'Pass Out') {
        _filterPassLists('Pass In');
      }

      GuestDrivereport = await drivePassVmsService.fetchGuestDriverReport(); // Fetch Guest Driver Report
    } catch (e) {
      _showErrorDialog('Error fetching pass lists. Please try again.');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterPassLists(String status) {
    // Filter each list based on the pass status
    drivePassList = drivePassList.where((pass) => pass['status'] == status || pass['status'] == null).toList();
    contractorPassList = contractorPassList.where((pass) => pass['status'] == status || pass['status'] == null).toList();
    dutyPassList = dutyPassList.where((pass) => pass['status'] == status || pass['status'] == null).toList();
    supplierPassList = supplierPassList.where((pass) => pass['status'] == status || pass['status'] == null).toList();
    guestPassList = guestPassList.where((pass) => pass['status'] == status || pass['status'] == null).toList();
  }


  Future<void> _autoFillData(String passName) async {
    var lastData = await drivePassVmsService.getLastReportedData(passName);
    setState(() {
      if (selectedLocation == 'Pass Out') {
        numberController.text = lastData['phone'] ?? '';
        icController.text = lastData['ic'] ?? '';
        carPlateController.text = lastData['carplate'] ?? '';
      }
    });
  }


  Future<void> _pickImage(String type) async {
    final picker = ImagePicker();
    final XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (type == 'Driver') {
          driverImage = pickedImage;
        }
      });
    }
  }

  Widget _buildImagePickerButton(String title, VoidCallback onPressed, XFile? image) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ElevatedButton(
          onPressed: onPressed,
          child: Text(title),
        ),
        const SizedBox(height: 8),
        if (image != null)
          kIsWeb
              ? Image.network(
            image.path,
            height: 100,
          )
              : Image.file(
            File(image.path),
            height: 100,
          ),
      ],
    );
  }

  Widget _displayImage(String imageUrlOrPath) {
    if (kIsWeb && imageUrlOrPath.startsWith('data:image')) {
      // Web: Display Base64-encoded image
      return Image.memory(base64Decode(imageUrlOrPath.split(',').last), height: 100);
    } else {
      // Non-web: Display image file
      return Image.file(File(imageUrlOrPath), height: 100);
    }
  }

  Future<String> _getImageUrl(XFile image) async {
    final bytes = await image.readAsBytes();
    return createObjectUrlFromBlob(bytes);
  }

  // Define the _updatePassStatus method
  Future<void> _updatePassStatus(String? passName, String passType) async {
    if (passName?.isNotEmpty ?? false) {
      print("Updating pass status for $passName of type $passType");

      // Call the service to update the pass status (this depends on your service method)
      try {
        await drivePassVmsService.updatePassStatus(
            [passName!],  // Pass name for each type (ensure it's not null)
            selectedLocation!,  // Current location or status for each pass
            passType  // Pass type (e.g., Drive Pass, Contractor Pass, etc.)
        );
        print("Pass status updated successfully for $passName");
      } catch (e) {
        print("Error updating pass status for $passName: $e");
      }
    }
  }

  Future<void> _submitForm() async {
    if ((currentPassType == 'Drive Pass' && selectedDrivePass == null) ||
        (currentPassType == 'Contractor Pass' && selectedContractorPass == null) ||
        (currentPassType == 'Duty Pass' && selectedDutyPass == null) ||
        (currentPassType == 'Supplier Pass' && selectedSupplierPass == null) ||
        (currentPassType == 'Guest Pass' && selectedGuestPass == null) ||
        selectedLocation == null ||
        numberController.text.isEmpty ||
        icController.text.isEmpty ||
        carPlateController.text.isEmpty) {
      _showErrorDialog('Please fill in all required fields, including images.');
      return;
    }

    try {
      String reportId = await drivePassVmsService.generateReportId();
      List<XFile> imagesToUpload = [];
      if (driverImage != null) {
        imagesToUpload.add(driverImage!);
      }

      List<String> imageLinks = await drivePassVmsService.uploadImagesToDrive(imagesToUpload);
      String currentDateTime = DateFormat('dd/MM/yyyy HH:mm:ss').format(DateTime.now());

      // Prepare the pass type combination (if multiple passes are selected)
      String combinedPassTypes = '';
      if (selectedDrivePass != null && selectedDrivePass!.isNotEmpty) {
        combinedPassTypes += 'Drive Pass, ';
      }
      if (selectedContractorPass != null && selectedContractorPass!.isNotEmpty) {
        combinedPassTypes += 'Contractor Pass, ';
      }
      if (selectedDutyPass != null && selectedDutyPass!.isNotEmpty) {
        combinedPassTypes += 'Duty Pass, ';
      }
      if (selectedSupplierPass != null && selectedSupplierPass!.isNotEmpty) {
        combinedPassTypes += 'Supplier Pass, ';
      }
      if (selectedGuestPass != null && selectedGuestPass!.isNotEmpty) {
        combinedPassTypes += 'Guest Pass, ';
      }

      // Remove trailing comma and space
      if (combinedPassTypes.isNotEmpty) {
        combinedPassTypes = combinedPassTypes.substring(0, combinedPassTypes.length - 2);
      } else {
        combinedPassTypes = 'No Pass Selected';
      }

      // Prepare the data to save
      List<Object?> rowData = [
        combinedPassTypes, // Save all pass types as a combined string
        selectedDrivePass ?? selectedContractorPass ?? selectedDutyPass ?? selectedSupplierPass ?? selectedGuestPass ?? '',
        selectedContractorPass ?? selectedDutyPass ?? selectedSupplierPass ?? selectedGuestPass ?? '',
        selectedLocation,
        numberController.text,
        icController.text,
        carPlateController.text,
        widget.email,
        imageLinks.isNotEmpty ? imageLinks[0] : 'No Vehicle Image',
        reportId,
        currentDateTime,
      ];

      // Ensure saving data only to the 'GuestDrivereport' sheet
      Worksheet? sheet = GoogleSheets.GuestDrivereport;

      await sheet?.values.appendRow(rowData);

      // Debugging: Check what values are being passed
      print("selectedDrivePass: $selectedDrivePass");
      print("selectedContractorPass: $selectedContractorPass");
      print("selectedDutyPass: $selectedDutyPass");
      print("selectedSupplierPass: $selectedSupplierPass");
      print("selectedGuestPass: $selectedGuestPass");

      // Update status for each pass type that has been selected
      if (selectedDrivePass != null && selectedDrivePass!.isNotEmpty) {
        print("Updating Drive Pass Status");
        await _updatePassStatus(selectedDrivePass, 'Drive Pass');
      }
      if (selectedContractorPass != null && selectedContractorPass!.isNotEmpty) {
        print("Updating Contractor Pass Status");
        await _updatePassStatus(selectedContractorPass, 'Contractor Pass');
      }
      if (selectedDutyPass != null && selectedDutyPass!.isNotEmpty) {
        print("Updating Duty Pass Status");
        await _updatePassStatus(selectedDutyPass, 'Duty Pass');
      }
      if (selectedSupplierPass != null && selectedSupplierPass!.isNotEmpty) {
        print("Updating Supplier Pass Status");
        await _updatePassStatus(selectedSupplierPass, 'Supplier Pass');
      }
      if (selectedGuestPass != null && selectedGuestPass!.isNotEmpty) {
        print("Updating Guest Pass Status");
        await _updatePassStatus(selectedGuestPass, 'Guest Pass');
      }

      _showSuccessDialog('Data submitted successfully with Report ID: $reportId!');
      _fetchAllPassLists();
      _resetForm();
    } catch (e, stack) {
      // Log the error to the console for debugging
      print('Error during form submission: $e');
      print('Stack trace: $stack');

      // Show the error message to the user, including the exception details
      _showErrorDialog('Failed to submit data. Please try again.\nError: $e');
    }
  }





  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _showSuccessDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Success'),
        content: Text(message),
        actions: [
          TextButton(
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          )
        ],
      ),
    );
  }

  void _resetOtherPassLists() {
    showContractorList = false;
    showDutyList = false;
    showSupplierList = false;
    showGuestList = false; // Reset Guest Pass List
    selectedDrivePass = null;
    selectedContractorPass = null;
    selectedDutyPass = null;
    selectedSupplierPass = null;
    selectedGuestPass = null; // Reset selectedGuestPass
  }

  void _collapseOtherPassLists(String passType) {
    if (passType != 'Contractor') showContractorList = false;
    if (passType != 'Duty') showDutyList = false;
    if (passType != 'Supplier') showSupplierList = false;
    if (passType != 'Guest') showGuestList = false; // Collapse Guest List
  }

  void _resetForm() {
    setState(() {
      selectedDrivePass = null;
      selectedContractorPass = null;
      selectedDutyPass = null;
      selectedSupplierPass = null;
      selectedGuestPass = null; // Reset selectedGuestPass
      numberController.clear();
      icController.clear();
      carPlateController.clear();
      driverImage = null;
      selectedLocation = null;
      currentPassType = null;
      showDriverList = false;
      showContractorList = false;
      showDutyList = false;
      showSupplierList = false;
      showGuestList = false; // Reset Guest Pass List
    });
  }
}

