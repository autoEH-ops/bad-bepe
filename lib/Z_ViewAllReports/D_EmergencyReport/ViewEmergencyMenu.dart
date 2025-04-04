import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'ViewEmergencyService.dart';
import 'ViewSpecificEmergency.dart';

class ViewEmergencyReport extends StatefulWidget {
  const ViewEmergencyReport({super.key});

  @override
  State<ViewEmergencyReport> createState() => _ViewEmergencyReportState();
}

class _ViewEmergencyReportState extends State<ViewEmergencyReport> {
  final TextEditingController textController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  ViewEmergencyService viewEmergencyService = ViewEmergencyService();

  String _formatTimestamp(String timestamp) {
    try {
      // Parse the timestamp in the format `dd-MM-yyyy HH:mm:ss`
      DateTime parsedDate = DateFormat('dd-MM-yyyy HH:mm:ss').parse(timestamp);

      // Format it in `d/M/yyyy HH:mm:ss` format
      return DateFormat('d/M/yyyy HH:mm:ss').format(parsedDate);
    } catch (e) {
      return 'Invalid Date Format';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text(
          'Emergency Reports',
          style: TextStyle(color: Colors.black, fontSize: 18),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.date_range),
            onPressed: () async {
              final selectedRange = await showDateRangePicker(
                context: context,
                firstDate: DateTime(2020),
                lastDate: DateTime.now(),
                initialDateRange: _getInitialDateRange(),
              );

              if (selectedRange != null) {
                setState(() {
                  _startDate = selectedRange.start;
                  _endDate = selectedRange.end.add(const Duration(hours: 23, minutes: 59, seconds: 59));
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, String>>>(
        future: viewEmergencyService.getAllHourly(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<Map<String, String>> allHourly = snapshot.data!;
            List<Map<String, String>> filteredReports = allHourly.where((report) {
              DateTime? reportDate = _parseDate(report['timestamp'] ?? '');
              if (reportDate == null) return false;
              return (_startDate == null || !reportDate.isBefore(_startDate!)) &&
                  (_endDate == null || !reportDate.isAfter(_endDate!));
            }).toList();

            if (filteredReports.isNotEmpty) {
              return ListView.builder(
                itemCount: filteredReports.length,
                itemBuilder: (context, index) {
                  String formattedTimestamp = _formatTimestamp(filteredReports[index]['timestamp'] ?? 'N/A');
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SpecificEmergencyPage(
                              data: filteredReports[index],
                            ),
                          ),
                        );
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF0091EA)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                              offset: const Offset(2, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Report ID: ${filteredReports[index]['reportId'] ?? 'N/A'}",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                "timestamp: $formattedTimestamp",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              Text(
                                "ID: ${filteredReports[index]['ID'] ?? 'N/A'}",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                softWrap: true,
                                overflow: TextOverflow.visible,
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                "Tap to View More",
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return const Center(child: Text("No Report Found"));
            }
          }
        },
      ),
    );
  }

  DateTime? _parseDate(String dateString) {
    List<String> dateFormats = [
      "dd/MM/yyyy HH:mm:ss",
      "yyyy-MM-dd HH:mm:ss",
      "MM/dd/yyyy HH:mm:ss",
      "yyyy/MM/dd HH:mm:ss",
      "MM-dd-yyyy HH:mm:ss",
      "dd-MM-yyyy HH:mm:ss",
    ];

    for (String format in dateFormats) {
      try {
        return DateFormat(format).parse(dateString);
      } catch (e) {
        // Continue to try the next format
      }
    }

    // Log unrecognized formats for debugging
    print("Unrecognized date format: $dateString");
    return null; // Return null if no format matches
  }


  DateTimeRange _getInitialDateRange() {
    if (_startDate != null && _endDate != null) {
      return DateTimeRange(start: _startDate!, end: _endDate!);
    } else {
      final DateTime now = DateTime.now();
      final DateTime lastWeek = now.subtract(const Duration(days: 7));
      return DateTimeRange(start: lastWeek, end: now);
    }
  }
}

// import 'package:flutter/material.dart';
//
// import 'ViewEmergencyService.dart';
// import 'ViewSpecificEmergency.dart';
//
// class ViewEmergencyReport extends StatefulWidget {
//   const ViewEmergencyReport({super.key});
//
//   @override
//   State<ViewEmergencyReport> createState() => _ViewEmergencyReportState();
// }
//
// class _ViewEmergencyReportState extends State<ViewEmergencyReport> {
//   final TextEditingController textController = TextEditingController();
//   DateTime? _startDate;
//   DateTime? _endDate;
//
//   ViewEmergencyService viewEmergencyService = ViewEmergencyService();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1f293a),
//       appBar: AppBar(
//         title: const Text(
//           'Emergency Reports',
//           style: TextStyle(color: Colors.black, fontSize: 18),
//         ),
//         backgroundColor: Colors.white,
//         centerTitle: true,
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.date_range),
//             onPressed: () async {
//               final selectedRange = await showDateRangePicker(
//                 context: context,
//                 firstDate: DateTime(2020),
//                 lastDate: DateTime.now(),
//                 initialDateRange: _getInitialDateRange(),
//               );
//
//               if (selectedRange != null) {
//                 setState(() {
//                   _startDate = selectedRange.start;
//                   _endDate = selectedRange.end;
//                 });
//               }
//             },
//           ),
//         ],
//       ),
//       body: FutureBuilder<List<Map<String, String>>>(
//         future: viewEmergencyService.getAllHourly(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No data available'));
//           } else {
//             List<Map<String, String>> allHourly = snapshot.data!;
//             List<Map<String, String>> filteredReports = allHourly.where((report) {
//               DateTime reportDate = _convertSerialToDate(report['Date'] ?? '0');
//               return (_startDate == null || reportDate.isAfter(_startDate!)) &&
//                   (_endDate == null || reportDate.isBefore(_endDate!));
//             }).toList();
//
//             if (filteredReports.isNotEmpty) {
//               return ListView.builder(
//                 itemCount: filteredReports.length,
//                 itemBuilder: (context, index) {
//                   return Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                     child: GestureDetector(
//                       onTap: () {
//                         Navigator.push(
//                           context,
//                           MaterialPageRoute(
//                             builder: (context) => SpecificEmergencyPage(
//                               data: filteredReports[index],
//                             ),
//                           ),
//                         );
//                       },
//                       child: Container(
//                         width: MediaQuery.of(context).size.width * 0.9,
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: const Color(0xFF0091EA)),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.black.withOpacity(0.1),
//                               blurRadius: 4,
//                               offset: const Offset(2, 2),
//                             ),
//                           ],
//                         ),
//                         child: Padding(
//                           padding: const EdgeInsets.all(12.0),
//                           child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Text(
//                                 "Report ID: ${filteredReports[index]['reportId'] ?? 'N/A'}",
//                             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                             softWrap: true,
//                             overflow: TextOverflow.visible,
//                           ),
//                               Text(
//                                 "timestamp: ${filteredReports[index]['timestamp'] ?? 'N/A'}",
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                 softWrap: true,
//                                 overflow: TextOverflow.visible,
//                               ),
//                               Text(
//                                 "ID: ${filteredReports[index]['ID'] ?? 'N/A'}",
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                 softWrap: true,
//                                 overflow: TextOverflow.visible,
//                               ),
//                               Text(
//                                 "timestamp: ${filteredReports[index]['timestamp'] ?? 'N/A'}",
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                 softWrap: true,
//                                 overflow: TextOverflow.visible,
//                               ),
//                               const SizedBox(height: 8),
//                               const Text(
//                                 "Tap to View More",
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
//                               ),
//                             ],
//                           ),
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             } else {
//               return const Center(child: Text("No Report Found"));
//             }
//           }
//         },
//       ),
//     );
//   }
//
//   DateTime _convertSerialToDate(String serial) {
//     try {
//       int serialDate = int.parse(serial);
//       return DateTime.fromMillisecondsSinceEpoch(
//           DateTime(1899, 12, 30).millisecondsSinceEpoch +
//               (serialDate * 24 * 60 * 60 * 1000));
//     } catch (e) {
//       print("Error converting serial to date: $e");
//       return DateTime(1970, 1, 1);
//     }
//   }
//
//   String _convertSerialToTime(String serial) {
//     try {
//       double serialTime = double.parse(serial);
//       int totalMinutes = (serialTime * 24 * 60).round();
//       int hours = totalMinutes ~/ 60;
//       int minutes = totalMinutes % 60;
//       return '${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}';
//     } catch (e) {
//       print("Error converting serial to time: $e");
//       return "Invalid Time";
//     }
//   }
//
//   DateTimeRange _getInitialDateRange() {
//     if (_startDate != null && _endDate != null) {
//       return DateTimeRange(start: _startDate!, end: _endDate!);
//     } else {
//       final DateTime now = DateTime.now();
//       final DateTime lastWeek = now.subtract(const Duration(days: 7));
//       return DateTimeRange(start: lastWeek, end: now);
//     }
//   }
// }
