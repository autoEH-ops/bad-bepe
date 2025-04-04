import 'package:created_by_618_abdo/Z_ViewAllReports/A_HourlyPostUpdate/ViewHourlyService.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../Components/TimeRelatedFunctions.dart';
import 'ViewSpecificHourly.dart';

class ViewHourlyReport extends StatefulWidget {
  const ViewHourlyReport({super.key});

  @override
  State<ViewHourlyReport> createState() => _ViewHourlyReportState();
}

class _ViewHourlyReportState extends State<ViewHourlyReport> {
  DateTime? _startDate;
  DateTime? _endDate;

  ViewHourlyService viewHourlyService = ViewHourlyService();
  Widget _buildCurrentHour() {
    final timeRelatedFunction = TimeRelatedFunction();
    return Container(
      color: Colors.grey.shade200,
      padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
      child: Text(
        timeRelatedFunction.getCurrentHour(),
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
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
    return null; // Return null if no format matches
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text(
          'Hourly Reports',
          style: TextStyle(color: Colors.black, fontSize: 20),
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
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: viewHourlyService.getAllHourly(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(child: Text('No data available'));
          } else {
            List<Map<String, dynamic>> allHourly = snapshot.data!;
            List<Map<String, dynamic>> filteredHourly = allHourly;

            if (_startDate != null && _endDate != null) {
              filteredHourly = allHourly.where((report) {
                DateTime? reportDate = _parseDate(report['timestamp']);
                if (reportDate == null) return false;
                return !reportDate.isBefore(_startDate!) && !reportDate.isAfter(_endDate!);
              }).toList();
            }

            return ListView.builder(
              itemCount: filteredHourly.length,
              itemBuilder: (context, index) {
                String reportID = filteredHourly[index]['Report ID'] ?? 'N/A';
                String timestamp = filteredHourly[index]['timestamp'] ?? 'N/A';
                String gatePost = filteredHourly[index]['Gate post'] ?? 'N/A';
                String remarks = filteredHourly[index]['REmake'] ?? 'N/A';

                DateTime? parsedDate = _parseDate(timestamp);
                String displayDate = parsedDate != null
                    ? DateFormat("dd/MM/yyyy HH:mm:ss").format(parsedDate)
                    : "Invalid date";

                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SpecificHourlyPage(
                            data: filteredHourly[index],
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
                              "Report ID: $reportID",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              "timestamp: $displayDate",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              "Gate Post: $gatePost",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            Text(
                              "Remarks: $remarks",
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              softWrap: true,
                              overflow: TextOverflow.visible,
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              "Tap to View More",
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  // Helper method to get the initial date range for the date picker
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

// import 'package:created_by_618_abdo/Z_ViewAllReports/A_HourlyPostUpdate/ViewHourlyService.dart';
// import 'package:flutter/material.dart';
//
// import '../../Components/TimeRelatedFunctions.dart';
// import 'ViewSpecificHourly.dart';
//
// class ViewHourlyReport extends StatefulWidget {
//   const ViewHourlyReport({super.key});
//
//   @override
//   State<ViewHourlyReport> createState() => _ViewHourlyReportState();
// }
//
// class _ViewHourlyReportState extends State<ViewHourlyReport> {
//   DateTime? _startDate;
//   DateTime? _endDate;
//
//   ViewHourlyService viewHourlyService = ViewHourlyService();
//   Widget _buildCurrentHour() {
//     final timeRelatedFunction = TimeRelatedFunction();
//     return Container(
//       color: Colors.grey.shade200,
//       padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
//       child: Text(
//         timeRelatedFunction.getCurrentHour(),
//         style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14.0),
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF1f293a),
//       appBar: AppBar(
//         title: const Text(
//           'Hourly Reports',
//           style: TextStyle(color: Colors.black, fontSize: 20),
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
//       body: FutureBuilder<List<Map<String, dynamic>>>(
//         future: viewHourlyService.getAllHourly(),
//         builder: (context, snapshot) {
//           if (snapshot.connectionState == ConnectionState.waiting) {
//             return const Center(child: CircularProgressIndicator());
//           } else if (snapshot.hasError) {
//             return Center(child: Text('Error: ${snapshot.error}'));
//           } else if (snapshot.data == null || snapshot.data!.isEmpty) {
//             return const Center(child: Text('No data available'));
//           } else {
//             List<Map<String, dynamic>> allHourly = snapshot.data!;
//
//             return ListView.builder(
//               itemCount: allHourly.length,
//               itemBuilder: (context, index) {
//                 String reportID = allHourly[index]['Report ID'] ?? 'N/A';
//                 String timestamp = allHourly[index]['timestamp'] ?? 'N/A';
//                 String gatePost = allHourly[index]['Gate post'] ?? 'N/A';
//                 String remarks = allHourly[index]['REmake'] ?? 'N/A';
//
//                 return Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
//                   child: GestureDetector(
//                     onTap: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => SpecificHourlyPage(
//                             data: allHourly[index],
//                           ),
//                         ),
//                       );
//                     },
//                     child: Container(
//                       width: MediaQuery.of(context).size.width * 0.9,
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         borderRadius: BorderRadius.circular(8),
//                         border: Border.all(color: const Color(0xFF0091EA)),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.1),
//                             blurRadius: 4,
//                             offset: const Offset(2, 2),
//                           ),
//                         ],
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(12.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildCurrentHour(),
//                             Text("Report ID: $reportID",
//                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                               softWrap: true,
//                               overflow: TextOverflow.visible,
//                             ),
//                             Text("timestamp: $timestamp",
//                                 style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                                 softWrap: true,
//                                 overflow: TextOverflow.visible,
//                             ),
//                             Text("Gate Post: $gatePost",
//                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                               softWrap: true,
//                               overflow: TextOverflow.visible,
//                             ),
//                             Text("Remarks: $remarks",
//                               style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//                               softWrap: true,
//                               overflow: TextOverflow.visible,
//                             ),
//                             const SizedBox(height: 8),
//                             const Text("Tap to View More",
//                                 style: TextStyle(
//                                     fontSize: 14,
//                                     fontWeight: FontWeight.bold,
//                                     color: Colors.red)),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//         },
//       ),
//     );
//   }
//
//   // Helper method to get the initial date range for the date picker
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
