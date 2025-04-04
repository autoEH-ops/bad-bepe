import 'package:flutter/material.dart';

import '../GoogleAPIs/GoogleSpreadSheet.dart';
import '../ManageSupplier/ManageSupplierService.dart';

class ManageSupplierPage extends StatefulWidget {
  final GoogleSheets googleSheetsApi = GoogleSheets();

  ManageSupplierPage({super.key});

  @override
  State<ManageSupplierPage> createState() => _ManageSupplierPageState();
}

class _ManageSupplierPageState extends State<ManageSupplierPage> {
  final TextEditingController textController = TextEditingController();
  List<String> supplierNames = [];
  ManageSupplierService manageSupplierService = ManageSupplierService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1f293a), // Dark background color
      appBar: AppBar(
        title: const Text(
          'Manage Supplier',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFF0091EA), // Blue app bar color
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
        future: manageSupplierService.getAllSupplier(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Error loading suppliers',
                    style: TextStyle(color: Colors.white70)));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('No suppliers found',
                    style: TextStyle(color: Colors.white70)));
          } else {
            supplierNames = snapshot.data!;
            return ListView.builder(
              itemCount: supplierNames.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 25.0, vertical: 10),
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
                            supplierNames[index],
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
                                  editSupplierPopUp(supplierNames[index]),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () =>
                                  deleteSupplier(supplierNames[index]),
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
        onPressed: addSupplierPopUp,
        backgroundColor: const Color(0xFF0091EA),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void deleteSupplier(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title: const Text('Delete Supplier',
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
              bool success = await manageSupplierService.deleteRow(name);
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

  void addSupplierPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title:
            const Text('Add Supplier', style: TextStyle(color: Colors.white)),
        content: TextField(
          controller: textController,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Enter Supplier Name',
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
              bool success = await manageSupplierService
                  .addSupplier(textController.text.toUpperCase());
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

  void editSupplierPopUp(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1f293a),
        title:
            const Text('Edit Supplier', style: TextStyle(color: Colors.white)),
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
            hintText: 'Update Supplier Name',
            hintStyle: TextStyle(color: Colors.grey.shade500),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () async {
              bool success = await manageSupplierService.updateRow(
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
