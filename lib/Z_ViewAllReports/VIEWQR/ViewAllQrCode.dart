//lib/Z_ViewAllReports/VIEWQR/ViewAllQrCode.dart

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart'; // Ensure this is imported
import 'ViewQrService.dart'; // Adjust the path as necessary
import 'package:intl/intl.dart';

class vQrCodePage extends StatefulWidget {
  const vQrCodePage({super.key});

  @override
  State<vQrCodePage> createState() => _AllQrCodePageState();
}

class _AllQrCodePageState extends State<vQrCodePage> {
  Icon searchIcon = const Icon(Icons.search);
  Widget searchField = const Text(
    "View All QR",
    style: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold,
    ),
  );
  String searchQuery = '';

  // Date range state
  DateTimeRange? _selectedDateRange;
  String _startDate = "Start Date";
  String _endDate = "End Date";

  // Initialize DateFormat for your date format
  final DateFormat _dateFormat = DateFormat("dd/MM/yyyy");

  @override
  Widget build(BuildContext context) {
    final allQrService = AllQrvService();

    return Scaffold(
      appBar: AppBar(
        title: searchField,
        centerTitle: true,
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: searchIcon,
            onPressed: () {
              setState(() {
                if (searchIcon.icon == Icons.search) {
                  searchIcon = const Icon(Icons.cancel);
                  searchField = _buildSearchTextField();
                } else {
                  searchIcon = const Icon(Icons.search);
                  searchField = const Text(
                    "View All QR",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                  searchQuery = ''; // Clear search query when cancelling
                }
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today),
            onPressed: _selectDateRange,
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: allQrService.getAllAccounts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            List<Map<String, dynamic>> qrList = snapshot.data!;

            // Filter by search query and date range
            List<Map<String, dynamic>> filteredList = qrList.where((data) {
              String name = data['Names']?.toString().toLowerCase() ?? '';
              String endDate = data['End Date'] ?? '';  // Use end date for filtering

              // Parse the end date using _parseFlexibleDate
              DateTime? endDateTime = _parseFlexibleDate(endDate);

              if (_selectedDateRange != null) {
                return name.contains(searchQuery.toLowerCase()) &&
                    (endDateTime != null &&
                        endDateTime.isAfter(_selectedDateRange!.start.subtract(Duration(days: 1))) &&
                        endDateTime.isBefore(_selectedDateRange!.end.add(Duration(days: 1))));
              } else {
                return name.contains(searchQuery.toLowerCase());
              }
            }).toList();

            // Sort by End Date (if date range is selected) or Timestamp (if no date range selected)
            filteredList.sort((a, b) {
              String endDateA = a['End Date'] ?? '';
              String endDateB = b['End Date'] ?? '';
              String timestampA = a['Start Date'] ?? '';
              String timestampB = b['Start Date'] ?? '';

              // If date range is selected, sort by End Date
              if (_selectedDateRange != null) {
                DateTime? endA = _parseFlexibleDate(endDateA);
                DateTime? endB = _parseFlexibleDate(endDateB);
                if (endA != null && endB != null) {
                  return endB.compareTo(endA); // Sort by End Date in descending order
                }
              }

              // Otherwise, fallback to sorting by Timestamp
              DateTime? timestampAParsed = _parseFlexibleDate(timestampA);
              DateTime? timestampBParsed = _parseFlexibleDate(timestampB);
              if (timestampAParsed != null && timestampBParsed != null) {
                return timestampBParsed.compareTo(timestampAParsed); // Sort by Timestamp in descending order
              }
              return 0; // Default case, no sorting if dates are invalid
            });

            return ListView.builder(
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                Map<String, dynamic> data = filteredList[index];

                // Print entire data map for debugging
                print('Data Map for QR Code \${index + 1}: \$data');

                String documentID = data['QR Code'] ?? 'Unknown QR';
                String name = data['Names'] ?? 'Unknown Name';
                String startDate = data['Start Date'] ?? 'N/A';
                String endDate = data['End Date'] ?? 'N/A';
                String status = data['Status'] ?? 'Unknown Status';
                String passId = data['PASS USED'] ?? 'Unknown passId'; // Corrected key
                String records = data['Records'] ?? 'NOT ACTIVE';
                String passImage = data['passimage'] ?? ''; // Ensure correct key name

                // Expiry logic based on the end date
                DateTime today = DateTime.now();
                bool isExpired = DateTime.tryParse(endDate)?.isBefore(today) ?? false;

                return buildQrTile(
                  context,
                  name,
                  startDate,
                  endDate,
                  status,
                  passId,
                  records,
                  documentID,
                  isExpired,
                  passImage, // Pass passImage to buildQrTile
                );
              },
            );
          } else {
            return const Center(
              child: Text(
                'No QR Codes Found',
                softWrap: true,
                overflow: TextOverflow.visible,
                style: TextStyle(fontSize: 16),
              ),
            );
          }
        },
      ),
    );
  }

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _selectedDateRange,
      firstDate: DateTime(2020),
      lastDate: DateTime(2025),
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _startDate = DateFormat('yyyy-MM-dd').format(picked.start);
        _endDate = DateFormat('yyyy-MM-dd').format(picked.end);
      });
    }
  }

  Widget _buildSearchTextField() {
    return TextField(
      style: const TextStyle(color: Colors.black, fontSize: 16),
      textInputAction: TextInputAction.go,
      decoration: const InputDecoration(
        border: InputBorder.none,
        hintText: "Search Names",
        hintStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: (value) {
        setState(() {
          searchQuery = value;
        });
      },
    );
  }

  // Helper function to parse passImage string
  List<Map<String, String>> parsePassImage(String passImage) {
    List<Map<String, String>> entries = [];

    if (passImage.isEmpty) return entries;

    // Split by comma
    List<String> parts = passImage.split(',');

    for (var part in parts) {
      part = part.trim();
      if (part.isEmpty) continue;

      int colonIndex = part.indexOf(':');
      if (colonIndex == -1) {
        print('Invalid passimage entry (no colon found): \$part');
        continue;
      }

      String label = part.substring(0, colonIndex).trim();
      String url = part.substring(colonIndex + 1).trim();

      if (label.isEmpty || url.isEmpty) {
        print('Invalid passimage entry (empty label or URL): \$part');
        continue;
      }

      // Validate URL
      Uri? uri = Uri.tryParse(url);
      if (uri != null &&
          uri.hasAbsolutePath &&
          url.startsWith('https://drive.google.com/uc?id=')) {
        entries.add({'label': label, 'url': url});
      } else {
        print('Invalid URL encountered: \$url');
      }
    }

    return entries;
  }

  Widget buildQrTile(
      BuildContext context,
      String name,
      String startDate,
      String endDate,
      String status,
      String passId,
      String records,
      String documentID,
      bool isExpired,
      String passImage,
      ) {
    // Debugging: Print passImage content
    print('Pass Image Data for \$name: \$passImage');

    // Parse the passImage string into individual entries
    List<Map<String, String>> imageEntries = parsePassImage(passImage);

    // Debugging: Print parsed image entries
    print('Parsed Image Entries: \$imageEntries');

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: isExpired ? Colors.red.shade400 : Colors.green.shade400,
          borderRadius: BorderRadius.circular(8),
        ),
        child: ExpansionTile(
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildRow("Name: ", name),
              buildRow("Start Date: ", startDate),
              buildRow("End Date: ", endDate),
              buildRow("PASS USED: ", passId),
              buildRow("Current Status: ", status),
              buildRow("Records: ", records),
            ],
          ),
          children: [
            if (imageEntries.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Wrap(
                  spacing: 8.0,
                  runSpacing: 4.0,
                  children: imageEntries.map<Widget>((entry) {
                    return Tooltip(
                      message: 'Open ${entry['label']} Image',
                      child: ElevatedButton.icon(
                        onPressed: () {
                          _launchURL(entry['url']!);
                        },
                        icon: Icon(
                          entry['label']!.toLowerCase().contains('in')
                              ? Icons.login
                              : Icons.logout,
                          color: Colors.white,
                        ),
                        label: Text(
                          entry['label']!,
                          style: const TextStyle(color: Colors.white),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                          entry['label']!.toLowerCase().contains('in')
                              ? Colors.blue
                              : Colors.orange,
                          minimumSize: const Size.fromHeight(40),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            if (imageEntries.isEmpty)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  'No Images Available',
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // Align to the top for better wrapping
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              softWrap: true, // Enables text wrapping
              overflow: TextOverflow.visible, // Allows text to wrap without truncation
            ),
          ),
        ],
      ),
    );
  }

  void _showLogMessage(String message) {
    print(message); // Console logging
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      _showLogMessage('Could not launch \$url');
    }
  }
}

String _formatDate(String? date) {
  if (date == null) return 'N/A';
  try {
    DateTime parsedDate = _parseFlexibleDate(date) ?? DateTime(1970);
    return DateFormat('dd/MM/yyyy').format(parsedDate);
  } catch (e) {
    return 'N/A';
  }
}

DateTime? _parseFlexibleDate(String? date) {
  if (date == null) return null;
  List<String> formats = [
    "yyyy-MM-dd",
    "yyyy-MM-ddTHH:mm:ss.sss", // ISO 8601 with fractional seconds
    "MM/dd/yyyyTHH:mm:ss.sss",
    "dd/MM/yyyy",
    "MM/dd/yyyy",
    "yyyy/MM/dd",
  ];
  for (String format in formats) {
    try {
      return DateFormat(format).parseStrict(date);
    } catch (e) {
      // Continue trying other formats
    }
  }
  return null;
}

//Original Code
// // lib/Z_ViewAllReports/VIEWQR/ViewAllQrCode.dart
//
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart'; // Ensure this is imported
// import 'ViewQrService.dart'; // Adjust the path as necessary
//
// class vQrCodePage extends StatefulWidget {
//   const vQrCodePage({super.key});
//
//   @override
//   State<vQrCodePage> createState() => _AllQrCodePageState();
// }
//
// class _AllQrCodePageState extends State<vQrCodePage> {
//   Icon searchIcon = const Icon(Icons.search);
//   Widget searchField = const Text(
//     "View All QR",
//     softWrap: true,
//     overflow: TextOverflow.visible,
//     style: TextStyle(
//       color: Colors.black,
//       fontSize: 18,
//       fontWeight: FontWeight.bold,
//     ),
//   );
//   String searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     final allQrService = AllQrvService();
//
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         title: searchField,
//         centerTitle: true,
//         backgroundColor: Colors.white,
//         actions: [
//           IconButton(
//             icon: searchIcon,
//             onPressed: () {
//               setState(() {
//                 if (searchIcon.icon == Icons.search) {
//                   searchIcon = const Icon(Icons.cancel);
//                   searchField = _buildSearchTextField();
//                 } else {
//                   searchIcon = const Icon(Icons.search);
//                   searchField = const Text(
//                     "View All QR",
//                     softWrap: true,
//                     overflow: TextOverflow.visible,
//                     style: TextStyle(
//                       color: Colors.black,
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   );
//                   searchQuery = ''; // Clear search query when cancelling
//                 }
//               });
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: allQrService.getAllAccounts(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(
//               child: Text(
//                 'Error: ${snapshot.error}',
//                 softWrap: true,
//                 overflow: TextOverflow.visible,
//                 style: const TextStyle(fontSize: 16),
//               ),
//             );
//           } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
//             List<Map<String, dynamic>> qrList = snapshot.data!;
//             List<Map<String, dynamic>> filteredList = qrList.where((data) {
//               String name = data['Names']?.toString().toLowerCase() ?? '';
//               return name.contains(searchQuery.toLowerCase());
//             }).toList();
//
//             return ListView.builder(
//               itemCount: filteredList.length,
//               itemBuilder: (context, index) {
//                 Map<String, dynamic> data = filteredList[index];
//
//                 // Print entire data map for debugging
//                 print('Data Map for QR Code ${index + 1}: $data');
//
//                 String documentID = data['QR Code'] ?? 'Unknown QR';
//                 String name = data['Names'] ?? 'Unknown Name';
//                 String startDate = data['Start Date'] ?? 'N/A';
//                 String endDate = data['End Date'] ?? 'N/A';
//                 String status = data['Status'] ?? 'Unknown Status';
//                 String passId = data['PASS USED'] ?? 'Unknown passId'; // Corrected key
//                 String records = data['Records'] ?? 'NOT ACTIVE';
//                 String passImage = data['passimage'] ?? ''; // Ensure correct key name
//
//                 // Expiry logic based on the end date
//                 DateTime today = DateTime.now();
//                 bool isExpired = DateTime.tryParse(endDate)?.isBefore(today) ?? false;
//
//                 return buildQrTile(
//                   context,
//                   name,
//                   startDate,
//                   endDate,
//                   status,
//                   passId,
//                   records,
//                   documentID,
//                   isExpired,
//                   passImage, // Pass passImage to buildQrTile
//                 );
//               },
//             );
//           } else {
//             return const Center(
//               child: Text(
//                 'No QR Codes Found',
//                 softWrap: true,
//                 overflow: TextOverflow.visible,
//                 style: TextStyle(fontSize: 16),
//               ),
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   Widget _buildSearchTextField() {
//     return TextField(
//       style: const TextStyle(color: Colors.black, fontSize: 16),
//       textInputAction: TextInputAction.go,
//       decoration: const InputDecoration(
//         border: InputBorder.none,
//         hintText: "Search Names",
//         hintStyle: TextStyle(color: Colors.grey),
//       ),
//       onChanged: (value) {
//         setState(() {
//           searchQuery = value;
//         });
//       },
//     );
//   }
//
//   // Helper function to parse passImage string
//   List<Map<String, String>> parsePassImage(String passImage) {
//     List<Map<String, String>> entries = [];
//
//     if (passImage.isEmpty) return entries;
//
//     // Split by comma
//     List<String> parts = passImage.split(',');
//
//     for (var part in parts) {
//       part = part.trim();
//       if (part.isEmpty) continue;
//
//       int colonIndex = part.indexOf(':');
//       if (colonIndex == -1) {
//         print('Invalid passimage entry (no colon found): $part');
//         continue;
//       }
//
//       String label = part.substring(0, colonIndex).trim();
//       String url = part.substring(colonIndex + 1).trim();
//
//       if (label.isEmpty || url.isEmpty) {
//         print('Invalid passimage entry (empty label or URL): $part');
//         continue;
//       }
//
//       // Validate URL
//       Uri? uri = Uri.tryParse(url);
//       if (uri != null &&
//           uri.hasAbsolutePath &&
//           url.startsWith('https://drive.google.com/uc?id=')) {
//         entries.add({'label': label, 'url': url});
//       } else {
//         print('Invalid URL encountered: $url');
//       }
//     }
//
//     return entries;
//   }
//
//   Widget buildQrTile(
//       BuildContext context,
//       String name,
//       String startDate,
//       String endDate,
//       String status,
//       String passId,
//       String records,
//       String documentID,
//       bool isExpired,
//       String passImage,
//       ) {
//     // Debugging: Print passImage content
//     print('Pass Image Data for $name: $passImage');
//
//     // Parse the passImage string into individual entries
//     List<Map<String, String>> imageEntries = parsePassImage(passImage);
//
//     // Debugging: Print parsed image entries
//     print('Parsed Image Entries: $imageEntries');
//
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//       child: Container(
//         width: double.infinity,
//         decoration: BoxDecoration(
//           color: isExpired ? Colors.red.shade400 : Colors.green.shade400,
//           borderRadius: BorderRadius.circular(8),
//         ),
//         child: ExpansionTile(
//           title: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               buildRow("Name: ", name),
//               buildRow("Start Date: ", startDate),
//               buildRow("End Date: ", endDate),
//               buildRow("PASS USED: ", passId),
//               buildRow("Current Status: ", status),
//               buildRow("Records: ", records),
//             ],
//           ),
//           children: [
//             if (imageEntries.isNotEmpty)
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Wrap(
//                   spacing: 8.0,
//                   runSpacing: 4.0,
//                   children: imageEntries.map<Widget>((entry) {
//                     return Tooltip(
//                       message: 'Open ${entry['label']} Image',
//                       child: ElevatedButton.icon(
//                         onPressed: () {
//                           _launchURL(entry['url']!);
//                         },
//                         icon: Icon(
//                           entry['label']!.toLowerCase().contains('in')
//                               ? Icons.login
//                               : Icons.logout,
//                           color: Colors.white,
//                         ),
//                         label: Text(
//                           entry['label']!,
//                           style: const TextStyle(color: Colors.white),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor:
//                           entry['label']!.toLowerCase().contains('in')
//                               ? Colors.blue
//                               : Colors.orange,
//                           minimumSize: const Size.fromHeight(40),
//                         ),
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ),
//             if (imageEntries.isEmpty)
//               const Padding(
//                 padding: EdgeInsets.all(8.0),
//                 child: Text(
//                   'No Images Available',
//                   softWrap: true,
//                   overflow: TextOverflow.visible,
//                   style: TextStyle(color: Colors.white),
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget buildRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0, top: 4),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start, // Align to the top for better wrapping
//         children: [
//           Text(label, style: const TextStyle(fontSize: 15)),
//           Expanded(
//             child: Text(
//               value,
//               style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
//               softWrap: true, // Enables text wrapping
//               overflow: TextOverflow.visible, // Allows text to wrap without truncation
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//
//   void _showLogMessage(String message) {
//     print(message); // Console logging
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(message)),
//     );
//   }
//
//   void _launchURL(String url) async {
//     Uri uri = Uri.parse(url);
//     if (await canLaunchUrl(uri)) {
//       await launchUrl(uri, mode: LaunchMode.externalApplication);
//     } else {
//       _showLogMessage('Could not launch $url');
//     }
//   }
// }
