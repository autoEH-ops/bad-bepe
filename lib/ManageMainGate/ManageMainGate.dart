import 'package:flutter/material.dart';
import '/ManageMainGate/ManageMainGateService.dart';

class ManageMainGatePage extends StatefulWidget {
  const ManageMainGatePage({super.key});

  @override
  State<ManageMainGatePage> createState() => _ManageMainGatePageState();
}

class _ManageMainGatePageState extends State<ManageMainGatePage> {
  final TextEditingController textController = TextEditingController();

  List<String> mainGate = [];

  ManageMainGateService manageMainGateService = ManageMainGateService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        title: const Text('Manage Main Gate'),
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
        future: manageMainGateService.getAllMainGates(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading screen
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message
            return const Center(child: Text('Add Main Gate'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Show empty message
            return const Center(child: Text('Add Main Gate'));
          } else {
            // Data is loaded, build the list
            mainGate = snapshot.data!;
            return ListView.builder(
              itemCount: mainGate.length,
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
                          mainGate[index],
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
                                editGlassDoorPopUp(mainGate[index]),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () => deleteGlassDoor(mainGate[index]),
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
          addGlassDoorPopUp();
        },
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void deleteGlassDoor(String name) {
    textController.text = name; // Set textController.text to the name

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Main Gate'),
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
                bool success = await manageMainGateService.deleteRow(name);
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

  void addGlassDoorPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Main Gate'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter Main Gate', // Add your hint text here
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                bool success = await manageMainGateService
                    .addMainGate(textController.text.toUpperCase());
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

  void editGlassDoorPopUp(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Main Gate'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                bool success = await manageMainGateService.updateRow(
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
