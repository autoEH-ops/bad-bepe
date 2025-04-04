import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '/Components/TimeRelatedFunctions.dart';
import '/ManageEmergencyFollowUp/ManageSpecificEmergencyFollowUp/ManageSpecificEmergencyFollowUpService.dart';

class ManageSpecificEmergencyFollowUpPage extends StatefulWidget {
  const ManageSpecificEmergencyFollowUpPage(
      {super.key, required this.data, required this.email});
  final String email;
  final Map<String, String> data;
  @override
  State<ManageSpecificEmergencyFollowUpPage> createState() =>
      _ManageSpecificEmergencyFollowUpPageState();
}

class _ManageSpecificEmergencyFollowUpPageState
    extends State<ManageSpecificEmergencyFollowUpPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleImages = manageSpecificEmergencyFollowUpService
        .extractFileIDs(widget.data["Emergency Report Supporting Files"]!);
    status = widget.data["Status"] == "Completed";
    loadData();
  }

  void loadData() async {
    nonCurrentFollowers = await manageSpecificEmergencyFollowUpService
        .getAllPersonnelNames(widget.data["Followers"]!);
    currentList =
        widget.data["Followers"]!.split(',').map((e) => e.trim()).toList();

    setState(() {
      print(nonCurrentFollowers);
      print(currentList);
    });
  }

  ManageSpecificEmergencyFollowUpService
      manageSpecificEmergencyFollowUpService =
      ManageSpecificEmergencyFollowUpService();

  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();

  List<String> nonCurrentFollowers = [];

  List<String> currentList = [];

  List<XFile> additionalImages = [];

  List<String> googleImages = [];

  bool status = false;

  TextEditingController remarks = TextEditingController();

  String name = "";

  void removeFromCurrentList(String name) {
    setState(() {
      currentList.remove(name);
      nonCurrentFollowers.add(name);
    });
  }

  void addToCurrentList(String name) {
    setState(() {
      nonCurrentFollowers.remove(name);
      currentList.add(name);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Emergency Incident ${widget.data["Report ID"]}",
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(
              height: 20,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 25),
                      child: Text(
                        "Emergency Incident Report Details",
                        style: TextStyle(
                          fontSize: 18.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "Report ID : ${widget.data["Report ID"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "Incident Date : ${widget.data["Incident Time"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "Incident Time : ${widget.data["Incident Date"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "Incident Description : ${widget.data["Incident"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25),
                          child: Text(
                            "Incident Detailed Description : ${widget.data["Detailed Incident Report"]}",
                            style: const TextStyle(
                              fontSize: 14.0,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Row(
                            children: [
                              Text(
                                "Manage Assignee",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          // Display current followers with remove option
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: currentList.map((name) {
                              return (name.isNotEmpty)
                                  ? Row(
                                      children: [
                                        Text(name),
                                        IconButton(
                                          onPressed: () {
                                            removeFromCurrentList(name);
                                          },
                                          icon: const Icon(Icons.cancel),
                                        ),
                                      ],
                                    )
                                  : Container();
                            }).toList(),
                          ),

                          const SizedBox(height: 10),
                          // Dropdown for adding non-current followers
                          DropdownButton<String>(
                            hint: const Text(
                              'Add Assignee',
                              style: TextStyle(
                                  color: Colors.white), // Hint text color
                            ),
                            value: null,
                            dropdownColor:
                                Colors.white, // Dropdown background color
                            items: nonCurrentFollowers.map((name) {
                              return DropdownMenuItem<String>(
                                value: name,
                                child: Text(
                                  name,
                                  style: const TextStyle(
                                      color: Colors.black), // Item text color
                                ),
                              );
                            }).toList(),
                            onChanged: (selectedName) {
                              if (selectedName != null) {
                                addToCurrentList(selectedName);
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          const Text(
                            "Previous Notes",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            widget.data["Remarks"]!,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 30.0),
                          child: Text(
                            "Previous Emergency Attachments",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.0,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 25.0, right: 25.0, top: 20),
                          child: Container(
                            height: 150,
                            width: double.infinity,
                            color: Colors.white,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: googleImages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return Dialog(
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pop(context);
                                            },
                                            child: SizedBox(
                                              width: double.infinity,
                                              height: 300,
                                              child: PhotoView(
                                                imageProvider: NetworkImage(
                                                    googleImages[index]),
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Stack(
                                    alignment: Alignment.topRight,
                                    children: [
                                      Image.network(
                                        googleImages[index],
                                        fit: BoxFit.cover,
                                      ),
                                      // You can add other widgets here if needed
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SwitchListTile(
                                title: Text(
                                  status
                                      ? "Current Status : Completed"
                                      : "Current Status : Follow Up",
                                  // style: const TextStyle(fontWeight: FontWeight.bold),
                                  style: TextStyle(color: Colors.white),
                                ),
                                value: status,
                                onChanged: (value) {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title:
                                            const Text("Confirm Status Change"),
                                        content: Text(
                                            "Are you sure you want to mark this as ${value ? 'Completed' : 'Follow Up'}?"),
                                        actions: <Widget>[
                                          TextButton(
                                            onPressed: () {
                                              Navigator.of(context)
                                                  .pop(); // Dismiss the dialog
                                            },
                                            child: const Text("Cancel"),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              setState(() {
                                                status = value;
                                              });
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Confirm"),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.green,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                const Padding(
                                  padding:
                                      EdgeInsets.symmetric(horizontal: 20.0),
                                  child: Text(
                                    "Upload Additional Photos",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20.0, top: 20),
                                  child: Container(
                                    height: 150,
                                    width: double.infinity,
                                    color: Colors.grey[200],
                                    child: GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                      ),
                                      itemCount: additionalImages.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Stack(
                                          alignment: Alignment.topRight,
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      content: kIsWeb
                                                          ? Image.network(
                                                              additionalImages[
                                                                      index]
                                                                  .path,
                                                              fit: BoxFit
                                                                  .contain, // Add this line
                                                            )
                                                          : Image.file(
                                                              File(
                                                                  additionalImages[
                                                                          index]
                                                                      .path),
                                                              fit: BoxFit
                                                                  .contain, // Add this line
                                                            ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: kIsWeb
                                                  ? Image.network(
                                                      additionalImages[index]
                                                          .path)
                                                  : Image.file(
                                                      File(additionalImages[
                                                              index]
                                                          .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: () {
                                                setState(() {
                                                  // Remove the selected image from the list
                                                  additionalImages
                                                      .removeAt(index);
                                                });
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    IconButton(
                                      onPressed: _pickImage,
                                      icon: const Icon(
                                        Icons.image,
                                        size: 30,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.green,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.0),
                      child: Text(
                        "Follow Up / Update Remarks",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20.0),
                      child: TextFormField(
                        controller: remarks, // take the text editing controller
                        decoration: InputDecoration(
                          hintText: 'Enter Remarks ... ',
                          hintStyle: TextStyle(
                            color: Colors.white,
                          ),
                          border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.grey.shade100)),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 20.0,
                              horizontal: 15.0), // Adjust padding
                        ),
                        minLines: 3,
                        maxLines: 10,
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _submitForm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5)),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Click to Submit",
                      style: TextStyle(
                          fontSize: 18.0, color: Colors.grey.shade900),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() async {
    currentList.removeWhere((element) => element.trim().isEmpty);

    if (currentList.isEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('No Assignee'),
            content: const SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Text('Assign at least a Security Guard'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Confirmation"),
            content: const Text(
                "I confirm that all provided data is true and accurate. Any incorrect information may result in a RM100 penalty per violation and acceptance of any issued warning letters."),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(); // Returns false to indicate "No"
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () async {
                  Navigator.of(context).pop(); // Close the confirmation dialog
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Updating Report, Please be patient',
                              style: TextStyle(fontSize: 16),
                            ),
                            SizedBox(
                              height: 10,
                              width: 20,
                            ),
                            // Add some spacing between the CircularProgressIndicator and the text
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    },
                  );

                  // Perform the upload task here
                  try {
                    String followers = currentList.join(", ");

                    await manageSpecificEmergencyFollowUpService.updateRow(
                        widget.email,
                        widget.data["Report ID"]!,
                        widget.data["Emergency Report Supporting Files"]!,
                        widget.data["Remarks"]!,
                        widget.data["Emergency Report Shortened URL"]!,
                        additionalImages,
                        getStatusText(status),
                        remarks.text,
                        followers);
                    pop();
                    pop();
                    pop();
                  } catch (e) {}
                },
                child: const Text("Yes"),
              ),
            ],
          );
        },
      );
    }
  }

  // This function is to return the Completed or Follow Up Text
  String getStatusText(bool status) {
    return status ? "Completed" : "Follow Up";
  }

  Future<List<XFile>> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    setState(() {
      // Add the picked images to the list of image XFiles
      additionalImages.addAll(pickedImages);
    });
    return pickedImages;
  }

  pop() {
    Navigator.pop(context);
  }
}
