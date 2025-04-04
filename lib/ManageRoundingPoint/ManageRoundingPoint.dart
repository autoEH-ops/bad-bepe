import 'package:flutter/material.dart';

import '../ManageRoundingPoint/ManageRoundingPointService.dart';

class ManageRoundingPoint extends StatefulWidget {
  const ManageRoundingPoint({super.key});

  @override
  State<ManageRoundingPoint> createState() => _ManageRoundingPointState();
}

class _ManageRoundingPointState extends State<ManageRoundingPoint> {
  final TextEditingController textController = TextEditingController();
  List<String> roundingPoints = [];
  ManageRoundingPointService manageRoundingPointService =
      ManageRoundingPointService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text(
          'Manage Rounding Points',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF0091EA),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () => setState(() {}),
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: manageRoundingPointService.getAllRoundingPoint(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading points',
                style: TextStyle(color: Colors.white70),
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Rounding Points Found',
                style: TextStyle(color: Colors.white70),
              ),
            );
          } else {
            roundingPoints = snapshot.data!;
            return ListView.builder(
              itemCount: roundingPoints.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF0091EA),
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 5,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          roundingPoints[index],
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
                                editRoundingPointPopUp(roundingPoints[index]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                deleteRoundingPoint(roundingPoints[index]),
                          ),
                        ],
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
        onPressed: addRoundingPointPopUp,
        backgroundColor: const Color(0xFF0091EA),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void deleteRoundingPoint(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title: const Text(
          'Delete Rounding Point',
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          'Delete $name?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel", style: TextStyle(color: Colors.blue)),
          ),
          TextButton(
            onPressed: () async {
              bool success = await manageRoundingPointService.deleteRow(name);
              if (success) {
                textController.clear();
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void addRoundingPointPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title: const Text(
          'Add Rounding Point',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter Rounding Point',
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
              bool success = await manageRoundingPointService
                  .addRoundingPoints(textController.text.toUpperCase());
              if (success) {
                textController.clear();
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Add', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }

  void editRoundingPointPopUp(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title: const Text(
          'Edit Rounding Point',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Update Rounding Point',
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
              bool success = await manageRoundingPointService.updateRow(
                  name, textController.text.toUpperCase());
              if (success) {
                textController.clear();
                Navigator.pop(context);
                setState(() {});
              }
            },
            child: const Text('Edit', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
    );
  }
}
