import 'package:flutter/material.dart';

import '../GoogleAPIs/GoogleSpreadSheet.dart';
import 'ManageDutyService.dart';

class ManageDutyPassPage extends StatefulWidget {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  ManageDutyPassPage({super.key});

  @override
  State<ManageDutyPassPage> createState() => _ManageDutyPassPageState();
}

class _ManageDutyPassPageState extends State<ManageDutyPassPage> {
  final TextEditingController textController = TextEditingController();
  List<String> dutyPassList = [];
  ManageDutyService manageDutyService = ManageDutyService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text(
          'Manage Visitor Pass',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0091EA),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {}); // Refresh page
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: manageDutyService.getAllDutyPass(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error loading Visitor Passes',
                    style: TextStyle(color: Colors.white70)));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No Duty Passes found',
                    style: TextStyle(color: Colors.white70)));
          } else {
            dutyPassList = snapshot.data!;
            return ListView.builder(
              itemCount: dutyPassList.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10.0),
                  child: Center(
                    child: Container(
                      width: 800,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0091EA),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListTile(
                        title: Padding(
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            dutyPassList[index],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit, color: Colors.white),
                              onPressed: () =>
                                  editDutyPassPopUp(dutyPassList[index]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  deleteDutyPass(dutyPassList[index]),
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
      floatingActionButton: FloatingActionButton(
        onPressed: addDutyPassPopUp,
        backgroundColor: const Color(0xFF0091EA),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void deleteDutyPass(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title: const Text('Delete Visitor Pass',
            style: TextStyle(color: Colors.white)),
        content: Text('Are you sure you want to delete $name?',
            style: const TextStyle(color: Colors.white70)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              bool success = await manageDutyService.deleteRow(name);
              if (success) {
                textController.clear();
                pop();
                setState(() {});
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void addDutyPassPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title:
            const Text('Add Visitor Pass', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter Visitor Pass',
            hintStyle: TextStyle(color: Colors.grey.shade500),
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              bool success = await manageDutyService
                  .addDutyPass(textController.text.toUpperCase());
              if (success) {
                textController.clear();
                pop();
                setState(() {});
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void editDutyPassPopUp(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title:
            const Text('Edit Visitor Pass', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            enabledBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.white70),
            ),
            focusedBorder: const UnderlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent),
            ),
            hintText: 'Update Visitor Pass',
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              bool success = await manageDutyService.updateRow(
                  name, textController.text.toUpperCase());
              if (success) {
                textController.clear();
                pop();
                setState(() {});
              }
            },
            child: const Text('Edit', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void pop() => Navigator.pop(context);
}
