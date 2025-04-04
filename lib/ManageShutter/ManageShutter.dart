import 'package:flutter/material.dart';
import '../ManageShutter/ManageShutterService.dart';

class ManageShutterPage extends StatefulWidget {
  const ManageShutterPage({super.key});

  @override
  State<ManageShutterPage> createState() => _ManageShutterPageState();
}

class _ManageShutterPageState extends State<ManageShutterPage> {
  final TextEditingController textController = TextEditingController();

  List<String> shutterLists = [];

  ManageShutterService manageShutterService = ManageShutterService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Manage Shutter'),
        backgroundColor: Colors.grey.shade300,
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {});
            },
          ),
        ],
      ),
      body: FutureBuilder<List<String>>(
        future: manageShutterService.getAllShutter(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading screen
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message
            return const Center(child: Text('Add Shutter'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Show empty message
            return const Center(child: Text('Add Shutter'));
          } else {
            // Data is loaded, build the list
            shutterLists = snapshot.data!;
            return ListView.builder(
              itemCount: shutterLists.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25, top: 20, bottom: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.grey.shade400),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          shutterLists[index],
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize
                            .min, // To minimize the width of the Row
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.edit,
                            ),
                            onPressed: () =>
                                editShutterPopUp(shutterLists[index]),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteShutter(shutterLists[index]),
                          ),
                          // Add more IconButton widgets as needed
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
        onPressed: () {
          addShutterPopUp();
        },
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void deleteShutter(String name) {
    textController.text = name; // Set textController.text to the name

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Shutter'),
        content: Text('Delete $name?'),
        actions: [
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              try {
                bool success = await manageShutterService.deleteRow(name);
                if (success) {
                  textController.clear();
                  pop();
                  setState(() {});
                }
              } catch (e) {
                // Handle errors here
                pop();
              }
            },
            child: const Text('Delete'),
          )
        ],
      ),
    );
  }

  void addShutterPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Shutter'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter Shutter', // Add your hint text here
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                bool success = await manageShutterService
                    .addShutter(textController.text.toUpperCase());
                if (success) {
                  textController.clear();
                  pop();
                  setState(() {});
                }
              } catch (e) {
                // Handle errors here
                pop();
              }
            },
            child: const Text('Add'),
          )
        ],
      ),
    );
  }

  void editShutterPopUp(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Shutter'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                bool success = await manageShutterService.updateRow(
                    name, textController.text.toUpperCase());
                if (success) {
                  textController.clear();
                  pop();
                  setState(() {});
                }
              } catch (e) {
                // Handle errors here
                pop();
              }
            },
            child: const Text('Edit'),
          )
        ],
      ),
    );
  }

  // This function is because context are not encouraged across async gaps
  pop() {
    Navigator.pop(context);
  }
}
