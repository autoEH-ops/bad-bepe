import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'ViewContractorService.dart';
import 'ViewSpecificContractor.dart';

class ViewContractorReport extends StatefulWidget {
  const ViewContractorReport({super.key});

  @override
  State<ViewContractorReport> createState() => _ViewContractorReportState();
}

class _ViewContractorReportState extends State<ViewContractorReport> {
  final TextEditingController textController = TextEditingController();
  DateTime? _startDate;
  DateTime? _endDate;

  ViewContractorService viewGateService = ViewContractorService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text(
          'Contractor Reports',
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
        future: viewGateService.getAllHourly(),
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
                            builder: (context) => SpecificContractorPage(
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
                                "Report ID: ${filteredReports[index]['report id'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Reported By: ${filteredReports[index]['email'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Contractor Pass: ${filteredReports[index]['Contractor Pass'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Status: ${filteredReports[index]['location'] ?? 'N/A'}",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "Date & Time: $formattedTimestamp",
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
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
              return const Center(child: Text("No Report"));
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

  String _formatTimestamp(String timestamp) {
    try {
      DateTime parsedDate = _parseDate(timestamp) ?? DateTime(1970, 1, 1);
      return DateFormat("dd/MM/yyyy HH:mm:ss").format(parsedDate);
    } catch (e) {
      return "Invalid Timestamp";
    }
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
