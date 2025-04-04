import 'package:flutter/material.dart';

import '../GoogleAPIs/GoogleSpreadSheet.dart';


class UserSettingsPage extends StatefulWidget {
  @override
  _UserSettingsPageState createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends State<UserSettingsPage> {
  List<Map<String, dynamic>> emailsData = [];  // List to hold email and its settings data
  bool isLoading = true;  // Flag to indicate if data is still loading

  @override
  void initState() {
    super.initState();
    _fetchEmails();
  }

  // Fetch emails, roles, and their settings from Google Sheets
  Future<void> _fetchEmails() async {
    try {

      final settingsSheet = GoogleSheets.settingpage;  // The settings sheet reference

      if (settingsSheet == null) {
        throw Exception("Settings sheet not found.");
      }

      // Retrieve all rows from Google Sheets
      final rows = await settingsSheet.values.allRows();

      if (rows == null || rows.isEmpty) {
        throw Exception("No data found in the settings sheet.");
      }

      print("Fetched rows: ${rows.length}");  // Debugging: Check the number of rows fetched

      // Skip header row and add rows with a valid email and role
      setState(() {
        emailsData = rows.skip(1).where((row) => row.length > 1 && row[0].isNotEmpty && row[1].isNotEmpty).map((row) {
          return {
            'email': row[0],
            'role': row[1],
            'settings': row.length > 2
                ? row.sublist(2, row.length).map((value) => value.toLowerCase() == 'true').toList()
                : List<bool>.filled(15, false), // Ensure 15 settings, as per sheet columns
          };
        }).toList();
        isLoading = false;  // Loading is complete
      });
    } catch (e) {
      // Handle any errors that might occur during data fetching
      print("Error fetching email data: $e");
      setState(() {
        isLoading = false;  // Stop loading on error
      });
    }
  }

  // Update the sheet when a setting is toggled
  Future<void> _updateSetting(String email, int settingIndex, bool value) async {
    try {
      final settingsSheet = GoogleSheets.settingpage;

      if (settingsSheet == null) {
        throw Exception("Settings sheet not found.");
      }

      // Find the row corresponding to the email
      final rows = await settingsSheet.values.allRows();
      final rowIndex = rows.indexWhere((row) => row.isNotEmpty && row[0] == email);

      if (rowIndex != -1) {
        // Save the updated setting (`true` or `false`)
        await settingsSheet.values.insertValue(
          value ? 'true' : 'false',
          column: settingIndex + 3, // Add 3 because column index starts at 1 and first two columns are email and role
          row: rowIndex + 1, // Row index is 0-based, Google Sheets uses 1-based
        );
        print("Updated setting for $email at index $settingIndex to ${value ? 'true' : 'false'}");
      }
    } catch (e) {
      // Handle errors during update
      print("Error updating settings for $email: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<String> roles = ['Admin', 'Security', 'Viewer'];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Role"),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator()) // Show loading indicator while fetching data
          : ListView.builder(
        itemCount: roles.length,
        itemBuilder: (context, index) {
          final role = roles[index];
          return ListTile(
            title: Text(role),
            onTap: () {
              // Navigate to email list page for the selected role
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailListPage(
                    role: role,
                    emailsData: emailsData.where((data) => data['role'] == role).toList(),
                    onSettingChanged: _updateSetting,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EmailListPage extends StatelessWidget {
  final String role;
  final List<Map<String, dynamic>> emailsData;
  final Function(String, int, bool) onSettingChanged;

  const EmailListPage({
    required this.role,
    required this.emailsData,
    required this.onSettingChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Emails for $role"),
      ),
      body: emailsData.isEmpty
          ? const Center(child: Text("No emails found for this role")) // Display message if no data is available
          : ListView.builder(
        itemCount: emailsData.length,
        itemBuilder: (context, index) {
          final email = emailsData[index]['email'];
          final role = emailsData[index]['role'];
          return ListTile(
            title: Text(email),
            onTap: () async {
              // Navigate to settings page for the selected email
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EmailSettingDetailPage(
                    email: email,
                    role: role,
                    settings: List<bool>.from(emailsData[index]['settings']),
                    onSettingChanged: (settingIndex, value) {
                      // Update settings in the list first
                      emailsData[index]['settings'][settingIndex] = value;

                      // Then update the Google Sheet
                      onSettingChanged(email, settingIndex, value);
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class EmailSettingDetailPage extends StatefulWidget {
  final String email;
  final String role;
  final List<bool> settings;
  final Function(int, bool) onSettingChanged;

  const EmailSettingDetailPage({
    required this.email,
    required this.role,
    required this.settings,
    required this.onSettingChanged,
  });

  @override
  _EmailSettingDetailPageState createState() => _EmailSettingDetailPageState();
}

class _EmailSettingDetailPageState extends State<EmailSettingDetailPage> {
  late List<bool> localSettings;

  // Define a map to associate each role with their allowed columns
  Map<String, List<int>> roleColumnMap = {
    'Admin': [
      // Admin can access all columns starting from index 8
      0, 1,2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21,23 ,24
    ],
    'Security': [
      // Security has access to specific columns
      0, 1, 2, 3, 4, 5, 6, 7, 8, 9
    ],
    'Viewer': [
      // Viewer can access only a few columns, starting after index 8
      0, 1, 9, 10, 11, 12, 13, 14, 15, 16, 17
    ],
  };

  @override
  void initState() {
    super.initState();

    // Define setting titles based on role
    final settingTitles = _getSettingTitles(widget.role);

    // Initialize local settings list from the passed data
    localSettings = List<bool>.from(widget.settings);
    if (localSettings.length < settingTitles.length) {
      localSettings.addAll(List<bool>.filled(settingTitles.length - localSettings.length, false));
    } else if (localSettings.length > settingTitles.length) {
      localSettings = localSettings.sublist(0, settingTitles.length);
    }
  }

  List<String> _getSettingTitles(String role) {
    if (role == 'Security') {
      return [
        'Hourly Post',
        'Roll Call',
        'Rounding',
        'Emergency',
        'Spot Check',
        'VMS',
        'QR',
        'Key Management',
      ];
    } else if (role == 'Viewer') {
      return [
        'Hourly Post',
        'Roll Call',
        'Rounding',
        'Emergency',
        'Spot Check',
        'VMS Contractor',
        'VMS Duty',
        'VMS Supplier',
        'View QR',
        'Key Management',
      ];
    } else {
      return [
        'Hourly Post Report',
        'Roll Call Report',
        'Rounding Report',
        'Emergency Report',
        'Spot Check Report',
        'VMS Reports',
        'QR Report',
        'Key Management Report',
        'View Hourly Post',
        'View Roll Call',
        'View Rounding',
        'View Emergency',
        'View Spot Check',
        'View VMS Contractor',
        'View VMS Duty',
        'View VMS Supplier',
        'View QR',
        'View Key Management',
        'All Account',
        'Register Page',
        'VMS MENU',
        'QR MANAGEMENT',
        'Security Guard',
      ];
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingTitles = _getSettingTitles(widget.role);

    return Scaffold(
      appBar: AppBar(
        title: Text("${widget.email} Settings"),
      ),
      body: ListView.builder(
        itemCount: settingTitles.length,
        itemBuilder: (context, index) {
          if (settingTitles[index].isEmpty) return Container(); // Skip empty columns

          return SwitchListTile(
            title: Text(settingTitles[index]),
            value: localSettings[index],
            onChanged: (bool value) {
              setState(() {
                localSettings[index] = value;
              });

              // Determine the correct column index based on role and setting
              final columnIndex = roleColumnMap[widget.role]![index];

              // Call the callback to update Google Sheets with the correct column index
              widget.onSettingChanged(columnIndex, value);
            },
          );
        },
      ),
    );
  }
}
