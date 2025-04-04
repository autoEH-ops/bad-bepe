import 'package:flutter/material.dart';
import '/ManageGatePost/ManageGatePostService.dart';

class ManageGatePostsPage extends StatefulWidget {
  const ManageGatePostsPage({super.key});

  @override
  State<ManageGatePostsPage> createState() => _ManageGatePostsPageState();
}

class _ManageGatePostsPageState extends State<ManageGatePostsPage> {
  final TextEditingController textController = TextEditingController();

  List<String> gatePostLocations = [];

ManageGatePostService manageGatePostService = ManageGatePostService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Manage Gate Posts',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
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
        future: manageGatePostService.getAllGatePosts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show loading screen
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Show error message
            return const Center(child: Text('Add Gate Posts'));
          } else if (snapshot.data == null || snapshot.data!.isEmpty) {
            // Show empty message
            return const Center(child: Text('Add Gate Posts'));
          } else {
            // Data is loaded, build the list
            gatePostLocations = snapshot.data!;
            return ListView.builder(
              itemCount: gatePostLocations.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(
                      left: 25.0, right: 25, top: 20, bottom: 10),
                  child: Container(
                    height: 50,
                    decoration: BoxDecoration(color: Colors.black,
                      border: Border.all(color: Colors.white, width: 2), // Border color and width
                      borderRadius: BorderRadius.circular(8), // Circular border
                    ),
                    child: ListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          gatePostLocations[index],
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                            fontFamily: 'Roboto',
                          ),
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
                            color: Colors.white,
                            onPressed: () =>
                                editGatePostPopUp(gatePostLocations[index]),
                          ),
                          IconButton(
                            icon: const Icon(
                              Icons.delete,
                              color: Colors.red,
                            ),
                            onPressed: () =>
                                deleteGatePosts(gatePostLocations[index]),
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
          addGatePostsPopUp();
        },
        backgroundColor: Colors.grey.shade300,
        child: const Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  void deleteGatePosts(String name) {
    textController.text = name; // Set textController.text to the name

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Gate Posts'),
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
                bool success = await manageGatePostService.deleteRow(name);
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

  void addGatePostsPopUp() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Gate Posts'),
        content: TextField(
          controller: textController,
          decoration: const InputDecoration(
            hintText: 'Enter Gate Posts', // Add your hint text here
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                bool success = await manageGatePostService
                    .addGatePosts(textController.text.toUpperCase());
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

  void editGatePostPopUp(String name) {
    textController.text = name;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Gate Posts'),
        content: TextField(
          controller: textController,
        ),
        actions: [
          ElevatedButton(
            onPressed: () async {
              try {
                bool success = await manageGatePostService.updateRow(
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
  pop(){
    Navigator.pop(context);
  }
}
