import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ViewQrService.dart';
import 'ViewSpecificQr.dart';

class AllQrCodePage extends StatefulWidget {
  const AllQrCodePage({super.key});

  @override
  State<AllQrCodePage> createState() => _AllQrCodePageState();
}

class _AllQrCodePageState extends State<AllQrCodePage> {
  Icon searchIcon = const Icon(Icons.search);
  Widget searchField = const Text("View All QR");
  String searchQuery = '';

  // Date range state
  DateTimeRange? _selectedDateRange;
  String _startDate = "Start Date";
  String _endDate = "End Date";

  @override
  Widget build(BuildContext context) {
    final allQrService = AllQrService();

    return Scaffold(
      backgroundColor: Colors.white,
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
                  searchField = const Text("View All QR");
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
      body: FutureBuilder<List<Map<String, dynamic>>>(  // Fetch QR data
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
                String documentID = data['QR Attachments'] ?? 'Unknown QR';
                String name = data['Names'] ?? 'Unknown Name';

                // Format the start and end dates as dd/MM/yyyy
                String startDate = _formatDate(data['Start Date']);
                String endDate = _formatDate(data['End Date']);

                String status = data['Status'] ?? 'Unknown Status';

                // Expiry logic based on the end date
                DateTime today = DateTime.now();
                bool isExpired = _parseFlexibleDate(data['End Date'])?.isBefore(today) ?? false;

                return buildQrTile(
                  context,
                  name,
                  startDate,
                  endDate,
                  status,
                  documentID,
                  isExpired,
                );
              },
            );
          } else {
            return const Center(child: Text('No QR Codes Found'));
          }
        },
      ),
    );
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

  Widget buildQrTile(BuildContext context, String name, String startDate,
      String endDate, String status, String documentID, bool isExpired) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => OneQrCodePage(qrData: documentID),
            ),
          );
        },
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: isExpired ? Colors.red.shade400 : Colors.green.shade400,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildRow("Name: ", name),
                buildRow("Start Date: ", startDate),
                buildRow("End Date: ", endDate),
                buildRow("Current Status: ", status),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 4),
      child: Row(
        children: [
          Text(label, style: const TextStyle(fontSize: 15)),
          Text(value,
              style:
              const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
        ],
      ),
    );
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


  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDateRange: _selectedDateRange,
    );
    if (picked != null && picked != _selectedDateRange) {
      setState(() {
        _selectedDateRange = picked;
        _startDate = _formatDate(picked.start.toString());
        _endDate = _formatDate(picked.end.toString());
      });
    }
  }
}

//Original Code
// import 'package:flutter/material.dart';
//
// import 'ViewQrService.dart';
// import 'ViewSpecificQr.dart';
//
// class AllQrCodePage extends StatefulWidget {
//   const AllQrCodePage({super.key});
//
//   @override
//   State<AllQrCodePage> createState() => _AllQrCodePageState();
// }
//
// class _AllQrCodePageState extends State<AllQrCodePage> {
//   Icon searchIcon = const Icon(Icons.search);
//   Widget searchField = const Text("View All QR");
//   String searchQuery = '';
//
//   @override
//   Widget build(BuildContext context) {
//     final allQrService = AllQrService();
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
//                   searchField = const Text("View All QR");
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
//             return Center(child: Text('Error: ${snapshot.error}'));
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
//                 String documentID = data['QR Attachments'] ?? 'Unknown QR';
//                 String name = data['Names'] ?? 'Unknown Name';
//
//                 // Directly use the start and end dates as strings
//                 String startDate = data['Start Date'] ?? 'N/A';
//                 String endDate = data['End Date'] ?? 'N/A';
//
//                 String status = data['Status'] ?? 'Unknown Status';
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
//                   documentID,
//                   isExpired,
//                 );
//               },
//             );
//           } else {
//             return const Center(child: Text('No QR Codes Found'));
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
//   Widget buildQrTile(BuildContext context, String name, String startDate,
//       String endDate, String status, String documentID, bool isExpired) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
//       child: GestureDetector(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => OneQrCodePage(qrData: documentID),
//             ),
//           );
//         },
//         child: Container(
//           width: double.infinity,
//           decoration: BoxDecoration(
//             color: isExpired ? Colors.red.shade400 : Colors.green.shade400,
//             borderRadius: BorderRadius.circular(8),
//           ),
//           child: ListTile(
//             title: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 buildRow("Name: ", name),
//                 buildRow("Start Date: ", startDate),
//                 buildRow("End Date: ", endDate),
//                 buildRow("Current Status: ", status),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget buildRow(String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.only(left: 10.0, top: 4),
//       child: Row(
//         children: [
//           Text(label, style: const TextStyle(fontSize: 15)),
//           Text(value,
//               style:
//               const TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
//         ],
//       ),
//     );
//   }
// }
