import 'dart:io';

import 'package:created_by_618_abdo/SubmitFollowUpEmergencyFollowUp/EmergencyFollowUpMenu.dart';
import 'package:created_by_618_abdo/SubmitFollowUpEmergencyFollowUp/SpecificEmergencyFollowUp/SuperAdminSettings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '/Components/TimeRelatedFunctions.dart';
import '/SubmitFollowUpEmergencyFollowUp/SpecificEmergencyFollowUp/SpecificEmergencyFollowUpService.dart';

class SpecificEmergencyFollowUpPage extends StatefulWidget {
  const SpecificEmergencyFollowUpPage(
      {super.key, required this.data, required this.email, required this.role});
  final String email;
  final Map<String, String> data;
  final String role;
  @override
  State<SpecificEmergencyFollowUpPage> createState() =>
      _SpecificEmergencyFollowUpPageState();
}

class _SpecificEmergencyFollowUpPageState
    extends State<SpecificEmergencyFollowUpPage> {
  EmergencyReportFollowUpSuperAdminSettings
      emergencyReportFollowUpSuperAdminSettings =
      EmergencyReportFollowUpSuperAdminSettings();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    googleImages = specificEmergencyFollowUpService
        .extractFileIDs(widget.data["Emergency Report Supporting Files"] ?? "");
    status = widget.data["Status"] == "Completed";
    loadData();
  }

  void loadData() async {
    await emergencyReportFollowUpSuperAdminSettings.checkAndCreateDocument();

    title =
        await emergencyReportFollowUpSuperAdminSettings.getTitleAndRequired();

    name = await specificEmergencyFollowUpService.getName(widget.email);
    setState(() {
      title1.text = title["Title 1"];
      title2.text = title["Title 2"];
      title3.text = title["Title 3"];
      title4.text = title["Title 4"];
      title5.text = title["Title 5"];
      title6.text = title["Title 6"];
      title7.text = title["Title 7"];
      title8.text = title["Title 8"];
      title9.text = title["Title 9"];
      title10.text = title["Title 10"];

      subtitle9.text = title["Sub Title 9"];
      button1.text = title["Button 1"];
      required8 = title["Required 8"];
      required9 = title["Required 9"];
    });
  }

  SpecificEmergencyFollowUpService specificEmergencyFollowUpService =
      SpecificEmergencyFollowUpService();

  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();

  List<XFile> additionalImages = [];

  List<String> googleImages = [];

  bool status = false;

  bool validationError1 = false;
  bool validationError2 = false;

  TextEditingController remarks = TextEditingController();

  String name = "";

  Map<String, dynamic> title = {};

  TextEditingController title1 = TextEditingController();
  TextEditingController title2 = TextEditingController();
  TextEditingController title3 = TextEditingController();
  TextEditingController title4 = TextEditingController();
  TextEditingController title5 = TextEditingController();
  TextEditingController title6 = TextEditingController();
  TextEditingController title7 = TextEditingController();
  TextEditingController title8 = TextEditingController();
  TextEditingController title9 = TextEditingController();
  TextEditingController title10 = TextEditingController();

  TextEditingController button1 = TextEditingController();
  TextEditingController subtitle9 = TextEditingController();

  bool required8 = true;
  bool required9 = true;

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (widget.role == "Super Admin") {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Emergency Incident ${widget.data["Report ID"] ?? ""}",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          actions: widget.role == "Super Admin"
              ? <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () {
                      _removeFocus();
                      navigateToEmergencyFollowUpReport();
                    },
                  ),
                ]
              : null,
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
                    color: Colors.lightBlue.shade900,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            controller: title1,
                            onChanged: (value) async {
                              await emergencyReportFollowUpSuperAdminSettings
                                  .updateTitle1(title1.text);
                              setState(() {});
                            },
                            decoration: const InputDecoration(
                              labelText: "Manage Main Title",
                              labelStyle: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.white,
                              ),
                              border: OutlineInputBorder(),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Border color when not focused
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Colors
                                        .white), // Border color when focused
                              ),
                            ),
                            style: TextStyle(
                              // Text color inside the TextFormField
                              color: Colors
                                  .white, // Change this to your desired text color
                              fontSize: 18.0, // Optional: Set the font size
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: title2,
                                onChanged: (value) async {
                                  await emergencyReportFollowUpSuperAdminSettings
                                      .updateTitle2(title2.text);
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  labelText: "Manage Title",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Border color when not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Border color when focused
                                  ),
                                ),
                                style: TextStyle(
                                  // Text color inside the TextFormField
                                  color: Colors
                                      .white, // Change this to your desired text color
                                  fontSize: 18.0, // Optional: Set the font size
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: title3,
                              onChanged: (value) async {
                                await emergencyReportFollowUpSuperAdminSettings
                                    .updateTitle3(title3.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Border color when not focused
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Border color when focused
                                ),
                              ),
                              style: TextStyle(
                                // Text color inside the TextFormField
                                color: Colors
                                    .white, // Change this to your desired text color
                                fontSize: 18.0, // Optional: Set the font size
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: title4,
                                onChanged: (value) async {
                                  await emergencyReportFollowUpSuperAdminSettings
                                      .updateTitle4(title4.text);
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  labelText: "Manage Title",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Border color when not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Border color when focused
                                  ),
                                ),
                                style: TextStyle(
                                  // Text color inside the TextFormField
                                  color: Colors
                                      .white, // Change this to your desired text color
                                  fontSize: 18.0, // Optional: Set the font size
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: title5,
                                onChanged: (value) async {
                                  await emergencyReportFollowUpSuperAdminSettings
                                      .updateTitle5(title5.text);
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  labelText: "Manage Title",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Border color when not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Border color when focused
                                  ),
                                ),
                                style: TextStyle(
                                  // Text color inside the TextFormField
                                  color: Colors
                                      .white, // Change this to your desired text color
                                  fontSize: 18.0, // Optional: Set the font size
                                ),
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: title6,
                                onChanged: (value) async {
                                  await emergencyReportFollowUpSuperAdminSettings
                                      .updateTitle6(title6.text);
                                  setState(() {});
                                },
                                decoration: const InputDecoration(
                                  labelText: "Manage Title",
                                  labelStyle: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0,
                                    color: Colors.white,
                                  ),
                                  border: OutlineInputBorder(),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Border color when not focused
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                        color: Colors
                                            .white), // Border color when focused
                                  ),
                                ),
                                style: TextStyle(
                                  // Text color inside the TextFormField
                                  color: Colors
                                      .white, // Change this to your desired text color
                                  fontSize: 18.0, // Optional: Set the font size
                                ),
                              )),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.lightBlue.shade900),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: title10,
                              onChanged: (value) async {
                                await emergencyReportFollowUpSuperAdminSettings
                                    .updateTitle10(title10.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Border color when not focused
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Border color when focused
                                ),
                              ),
                              style: TextStyle(
                                // Text color inside the TextFormField
                                color: Colors
                                    .white, // Change this to your desired text color
                                fontSize: 18.0, // Optional: Set the font size
                              ),
                            )),
                        const SizedBox(
                          height: 10,
                        ),
                      ]),
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
                        color: Colors.lightBlue.shade900,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 20,
                            ),
                            TextFormField(
                              controller: title7,
                              onChanged: (value) async {
                                await emergencyReportFollowUpSuperAdminSettings
                                    .updateTitle7(title7.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(),
                                enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Border color when not focused
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors
                                          .white), // Border color when focused
                                ),
                              ),
                              style: TextStyle(
                                // Text color inside the TextFormField
                                color: Colors
                                    .white, // Change this to your desired text color
                                fontSize: 18.0, // Optional: Set the font size
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                          ],
                        ),
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
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade900,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(
                                height: 15,
                              ),
                              Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10.0),
                                  child: TextFormField(
                                    controller: title8,
                                    onChanged: (value) async {
                                      await emergencyReportFollowUpSuperAdminSettings
                                          .updateTitle8(title8.text);
                                      setState(() {});
                                    },
                                    decoration: const InputDecoration(
                                      labelText: "Manage Title",
                                      labelStyle: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18.0,
                                        color: Colors.white,
                                      ),
                                      border: OutlineInputBorder(),
                                      enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Border color when not focused
                                      ),
                                      focusedBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors
                                                .white), // Border color when focused
                                      ),
                                    ),
                                    style: TextStyle(
                                      // Text color inside the TextFormField
                                      color: Colors
                                          .white, // Change this to your desired text color
                                      fontSize:
                                          18.0, // Optional: Set the font size
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20.0, top: 20),
                                child: Container(
                                  height: 150,
                                  width: double.infinity,
                                  color: Colors.white,
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
                                                    File(additionalImages[index]
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
                              const SizedBox(
                                height: 20,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                        color:
                                            Colors.black), // Set border color
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Set border radius
                                  ),
                                  child: SwitchListTile(
                                    title: const Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        "Required",
                                        style: TextStyle(
                                          color: Colors
                                              .white, // Ensure the text color is white
                                        ),
                                      ),
                                    ),
                                    value: required8,
                                    onChanged: (value) async {
                                      setState(() {
                                        required8 = value;
                                      });
                                      await emergencyReportFollowUpSuperAdminSettings
                                          .updateRequired8(required8);
                                    },
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lightBlue.shade900,
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(
                                    height: 15,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: TextFormField(
                                        controller: title9,
                                        onChanged: (value) async {
                                          await emergencyReportFollowUpSuperAdminSettings
                                              .updateTitle9(title9.text);
                                          setState(() {});
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Manage Title",
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.white,
                                          ),
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .white), // Border color when not focused
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .white), // Border color when focused
                                          ),
                                        ),
                                        style: TextStyle(
                                          // Text color inside the TextFormField
                                          color: Colors
                                              .white, // Change this to your desired text color
                                          fontSize:
                                              18.0, // Optional: Set the font size
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 10.0),
                                      child: TextFormField(
                                        controller: subtitle9,
                                        onChanged: (value) async {
                                          await emergencyReportFollowUpSuperAdminSettings
                                              .updateSubtitle9(subtitle9.text);
                                          setState(() {});
                                        },
                                        decoration: const InputDecoration(
                                          labelText: "Manage Sub Title",
                                          labelStyle: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0,
                                            color: Colors.white,
                                          ),
                                          border: OutlineInputBorder(),
                                          enabledBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .white), // Border color when not focused
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors
                                                    .white), // Border color when focused
                                          ),
                                        ),
                                        style: TextStyle(
                                          // Text color inside the TextFormField
                                          color: Colors
                                              .white, // Change this to your desired text color
                                          fontSize:
                                              18.0, // Optional: Set the font size
                                        ),
                                      )),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors
                                                .black), // Set border color
                                        borderRadius: BorderRadius.circular(
                                            8.0), // Set border radius
                                      ),
                                      child: SwitchListTile(
                                        title: const Padding(
                                          padding: EdgeInsets.only(left: 15.0),
                                          child: Text(
                                            "Required",
                                            style: TextStyle(
                                              color: Colors
                                                  .white, // Ensure the text color is white
                                            ),
                                          ),
                                        ),
                                        value: required9,
                                        onChanged: (value) async {
                                          setState(() {
                                            required9 = value;
                                          });
                                          await emergencyReportFollowUpSuperAdminSettings
                                              .updateRequired9(required9);
                                        },
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.lightBlue.shade900,
                              borderRadius: BorderRadius.circular(5),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Align(
                                alignment: Alignment.center,
                                child: TextFormField(
                                  controller:
                                      button1, // Use the TextEditingController
                                  onChanged: (value) async {
                                    await emergencyReportFollowUpSuperAdminSettings
                                        .updateButton1(button1.text);
                                    setState(() {});
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Manage Button Title",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                      color: Colors.white,
                                    ),
                                    border: OutlineInputBorder(),
                                    enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .white), // Border color when not focused
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors
                                              .white), // Border color when focused
                                    ),
                                  ),
                                  style: TextStyle(
                                    // Text color inside the TextFormField
                                    color: Colors
                                        .white, // Change this to your desired text color
                                    fontSize:
                                        18.0, // Optional: Set the font size
                                  ),
                                )), // Adjust padding as needed
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ],
          ),
        ),
      );
    }
    if (widget.role == "Security") {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            "Emergency Incident ${widget.data["Report ID"] ?? ""}",
            style: TextStyle(color: Colors.black),
          ),
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
                    color: Colors.lightBlue.shade900,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25),
                        child: Text(
                          title["Title 1"],
                          style: const TextStyle(
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
                              "${title["Title 2"]} ${widget.data["Report ID"] ?? "No Data"}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 3"]} ${widget.data["Incident Time"] ?? "No Data"}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 4"]} ${widget.data["Incident Date"] ?? "No Data"}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 5"]} ${widget.data["Incident"] ?? "No Data"}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 6"]} ${widget.data["Detailed Incident Report"] ?? "No Data"}",
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
                        color: Colors.lightBlue.shade900,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 25.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              title["Title 10"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.data["Remarks"] ?? "No Data",
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
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
                        color: Colors.lightBlue.shade900,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              title["Title 7"],
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 10),
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
                            height: 15,
                          ),
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
                          decoration: BoxDecoration(
                            color: Colors.lightBlue.shade900,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SwitchListTile(
                              title: Text(
                                status
                                    ? "Current Status : Completed"
                                    : "Current Status : Follow Up",
                                // style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              value: status,
                              onChanged: (value) {
                                status = value;
                                setState(() {});
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              if (status)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.lightBlue.shade900,
                        border: Border.all(
                            color: validationError1
                                ? Colors.red
                                : Colors.transparent)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: Text(
                            title["Title 8"],
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
                            color: Colors.white,
                            child: GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                              ),
                              itemCount: additionalImages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Stack(
                                  alignment: Alignment.topRight,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              content: kIsWeb
                                                  ? Image.network(
                                                      additionalImages[index]
                                                          .path,
                                                      fit: BoxFit
                                                          .contain, // Add this line
                                                    )
                                                  : Image.file(
                                                      File(additionalImages[
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
                                              additionalImages[index].path)
                                          : Image.file(
                                              File(
                                                  additionalImages[index].path),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.cancel),
                                      onPressed: () {
                                        setState(() {
                                          // Remove the selected image from the list
                                          additionalImages.removeAt(index);
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
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.lightBlue.shade900,
                          border: Border.all(
                              color: validationError2
                                  ? Colors.red
                                  : Colors.transparent)),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.0),
                            child: Text(
                              title["Title 9"],
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 15.0),
                            child: TextFormField(
                              controller:
                                  remarks, // take the text editing controller
                              onChanged: (value) {
                                validationError2 = false;
                                setState(() {});
                              },
                              decoration: InputDecoration(
                                hintText: title["Sub Title 9"],
                                hintStyle: TextStyle(
                                  color: Colors.white,
                                ),
                                border: OutlineInputBorder(
                                    borderSide: BorderSide()),
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 20.0,
                                    horizontal: 10.0), // Adjust padding
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
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          _submitForm();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlue.shade900,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5)),
                        ),
                        child: Align(
                          alignment: Alignment.center,
                          child: Text(
                            title["Button 1"],
                            style:
                                TextStyle(fontSize: 18.0, color: Colors.black),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    } else {
      return const Scaffold();
    }
  }

  void _submitForm() async {
    if (!status) {
      if (required9) {
        if (remarks.text.isEmpty) {
          validationError2 = true;
          setState(() {});
        }
      } else {
        validationError2 = false;
      }

      if (validationError2) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Incomplete Details'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Please make sure all details are correct.'),
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
                    Navigator.of(context)
                        .pop(); // Returns false to indicate "No"
                  },
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () async {
                    _removeFocus();
                    Navigator.of(context)
                        .pop(); // Close the confirmation dialog
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
                    try {
                      await specificEmergencyFollowUpService.updateComment(
                        widget.data["Report ID"]!,
                        widget.email,
                        remarks.text,
                        widget.data["Remarks"]!,
                      );

                      pop();
                      pop();
                      pop();
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Incorrect Details'),
                            content: const SingleChildScrollView(
                              child: ListBody(
                                children: <Widget>[
                                  Text('Report Upload Fail'),
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
                    } catch (e) {}
                  },
                  child: const Text("Yes"),
                ),
              ],
            );
          },
        );
      }
    } else {
      if (required8) {
        if (additionalImages.isEmpty) {
          validationError1 = true;
          setState(() {});
        }
      } else {
        validationError1 = false;
      }

      if (required9) {
        if (remarks.text.isEmpty) {
          validationError2 = true;
          setState(() {});
        }
      } else {
        validationError2 = false;
      }

      if (validationError1 || validationError2) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text('Incomplete Details'),
              content: const SingleChildScrollView(
                child: ListBody(
                  children: <Widget>[
                    Text('Please make sure all details are correct.'),
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
                    Navigator.of(context)
                        .pop(); // Returns false to indicate "No"
                  },
                  child: const Text("No"),
                ),
                TextButton(
                  onPressed: () async {
                    _removeFocus();
                    Navigator.of(context)
                        .pop(); // Close the confirmation dialog
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
                    try {
                      bool success =
                          await specificEmergencyFollowUpService.updateRow(
                              widget.email,
                              widget.data["Report ID"]!,
                              widget.data["Emergency Report Supporting Files"]!,
                              widget.data["Remarks"]!,
                              widget.data["Emergency Report Shortened URL"]!,
                              additionalImages,
                              getStatusText(status),
                              remarks.text);

                      if (success) {
                        pop();
                        pop();
                        pop();
                      } else {
                        pop();
                        pop();
                        pop();
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: const Text('Incorrect Details'),
                              content: const SingleChildScrollView(
                                child: ListBody(
                                  children: <Widget>[
                                    Text('Report Upload Fail'),
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
                      }
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
  }

  // This function is to return the Completed or Follow Up Text
  String getStatusText(bool status) {
    return status ? "Completed" : "Follow Up";
  }

  Future<List<XFile>> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    validationError1 = false;
    setState(() {
      // Add the picked images to the list of image XFiles
      additionalImages.addAll(pickedImages);
    });
    return pickedImages;
  }

  void _removeFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  pop() {
    Navigator.pop(context);
  }

  navigateToEmergencyFollowUpReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EmergencyFollowUpMenu(
                  email: widget.email,
                  role: "Super Admin",
                )));
  }
}
