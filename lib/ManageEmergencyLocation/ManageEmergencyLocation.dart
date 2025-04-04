import 'package:flutter/material.dart';

import '../ManageEmergencyLocation/ManageEmergencyLocationService.dart';

class ManageEmergencyLocationPage extends StatefulWidget {
  const ManageEmergencyLocationPage({super.key});

  @override
  State<ManageEmergencyLocationPage> createState() =>
      _ManageEmergencyLocationPageState();
}

class _ManageEmergencyLocationPageState
    extends State<ManageEmergencyLocationPage> {
  final TextEditingController textController = TextEditingController();
  List<String> gatePostLocationPage = [];
  ManageEmergencyLocationService manageEmergencyLocationService =
      ManageEmergencyLocationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a),
      appBar: AppBar(
        title: const Text(
          'Manage GatePost Locations',
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
        future: manageEmergencyLocationService.getAllEmergencyLocations(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Error loading locations',
                style: TextStyle(color: Colors.white70),
              ),
            );
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No Locations Found',
                style: TextStyle(color: Colors.white70),
              ),
            );
          } else {
            gatePostLocationPage = snapshot.data!;
            return ListView.builder(
              itemCount: gatePostLocationPage.length,
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
                          gatePostLocationPage[index],
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
                            onPressed: () => editEmergencyLocationPopUp(
                                gatePostLocationPage[index]),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () =>
                                deleteGatePosts(gatePostLocationPage[index]),
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
        onPressed: addEmergencyLocationPopUp,
        backgroundColor: const Color(0xFF0091EA),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void deleteGatePosts(String name) {
    textController.text = name;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title: const Text(
          'Delete GatePost Location',
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
              bool success =
                  await manageEmergencyLocationService.deleteRow(name);
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

  void addEmergencyLocationPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title: const Text(
          'Add GatePost Location',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter GatePost Location',
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
              bool success = await manageEmergencyLocationService
                  .addEmergencyLocations(textController.text.toUpperCase());
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

  void editEmergencyLocationPopUp(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title: const Text(
          'Edit GatePost Location',
          style: TextStyle(color: Colors.white),
        ),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Update GatePost Location',
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
              bool success = await manageEmergencyLocationService.updateRow(
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
