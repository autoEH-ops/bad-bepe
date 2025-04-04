import 'dart:io';

import 'package:created_by_618_abdo/SubmitPassCheckingFollowUp/PassCheckingFollowUp/SpecificPassService.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '/Components/TimeRelatedFunctions.dart';
import '../PassCheckingFollowUpMenu.dart';
import 'SuperAdminSettings.dart';

class ManageSpecificPassCheckingFollowUpPage extends StatefulWidget {
  const ManageSpecificPassCheckingFollowUpPage(
      {super.key, required this.data, required this.email, required this.role});
  final String email;
  final String role;
  final Map<String, String> data;
  @override
  State<ManageSpecificPassCheckingFollowUpPage> createState() =>
      _ManageSpecificPassCheckingFollowUpPageState();
}

class _ManageSpecificPassCheckingFollowUpPageState
    extends State<ManageSpecificPassCheckingFollowUpPage> {
  SpecificPassFollowUpService specificPassFollowUpService =
      SpecificPassFollowUpService();

  SpecificPassReportSuperAdminSettings specificPassReportSuperAdminSettings =
      SpecificPassReportSuperAdminSettings();

  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();
  @override
  void initState() {
    super.initState();
    status = widget.data["Status"] == "Completed";
    loadData();
  }

  void loadData() async {
    await specificPassReportSuperAdminSettings.checkAndCreateDocument();

    title = await specificPassReportSuperAdminSettings.getTitleAndRequired();

    setState(() {
      title1.text = title["Title 1"];
      title2.text = title["Title 2"];
      title3.text = title["Title 3"];
      title4.text = title["Title 4"];
      title5.text = title["Title 5"];
      title6.text = title["Title 6"];
      title7.text = title["Title 7"];
      title8.text = title["Title 8"];

      subtitle8.text = title["Sub Title 8"];
      button1.text = title["Button 1"];

      required7 = title["Required 7"];
      required8 = title["Required 8"];
    });
  }

  TextEditingController title1 = TextEditingController();
  TextEditingController title2 = TextEditingController();
  TextEditingController title3 = TextEditingController();
  TextEditingController title4 = TextEditingController();
  TextEditingController title5 = TextEditingController();
  TextEditingController title6 = TextEditingController();
  TextEditingController title7 = TextEditingController();
  TextEditingController title8 = TextEditingController();
  TextEditingController subtitle8 = TextEditingController();

  TextEditingController button1 = TextEditingController();

  bool required7 = false;
  bool required8 = false;

  bool validationError1 = false;
  bool validationError2 = false;

  Map<String, dynamic> title = {};

  List<XFile> photoPassFound = [];

  bool status = false;

  TextEditingController remarks = TextEditingController();

  String name = "";

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
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            "Pass Checking ${widget.data["Report ID"] ?? ''}",
            style: TextStyle(color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
          actions: widget.role == "Super Admin"
              ? <Widget>[
                  IconButton(
                    icon: const Icon(Icons.remove_red_eye),
                    onPressed: () {
                      _removeFocus();
                      navigateToPassCheckingFollowUp();
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
                              await specificPassReportSuperAdminSettings
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: title2,
                                onChanged: (value) async {
                                  await specificPassReportSuperAdminSettings
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
                                  await specificPassReportSuperAdminSettings
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
                              )),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: title4,
                                onChanged: (value) async {
                                  await specificPassReportSuperAdminSettings
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
                                  await specificPassReportSuperAdminSettings
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
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 20,
                          ),
                          Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 10.0),
                              child: TextFormField(
                                controller: title6,
                                onChanged: (value) async {
                                  await specificPassReportSuperAdminSettings
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
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
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
                                    controller: title7,
                                    onChanged: (value) async {
                                      await specificPassReportSuperAdminSettings
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
                                    itemCount: photoPassFound.length,
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
                                                            photoPassFound[
                                                                    index]
                                                                .path,
                                                            fit: BoxFit
                                                                .contain, // Add this line
                                                          )
                                                        : Image.file(
                                                            File(photoPassFound[
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
                                                    photoPassFound[index].path)
                                                : Image.file(
                                                    File(photoPassFound[index]
                                                        .path),
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.cancel),
                                            onPressed: () {
                                              setState(() {
                                                // Remove the selected image from the list
                                                photoPassFound.removeAt(index);
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
                                height: 10,
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
                                    value: required7,
                                    onChanged: (value) async {
                                      setState(() {
                                        required7 = value;
                                      });
                                      await specificPassReportSuperAdminSettings
                                          .updateRequired7(required7);
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
                ],
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
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            controller: title8,
                            onChanged: (value) async {
                              await specificPassReportSuperAdminSettings
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
                              fontSize: 18.0, // Optional: Set the font size
                            ),
                          )),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: TextFormField(
                            controller: subtitle8,
                            onChanged: (value) async {
                              await specificPassReportSuperAdminSettings
                                  .updateSubtitle8(subtitle8.text);
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
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.black), // Set border color
                            borderRadius:
                                BorderRadius.circular(8.0), // Set border radius
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
                              await specificPassReportSuperAdminSettings
                                  .updateRequired8(required8);
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
              const SizedBox(
                height: 10,
              ),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: TextFormField(
                    controller: button1,
                    onChanged: (value) async {
                      await specificPassReportSuperAdminSettings
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
                            color:
                                Colors.white), // Border color when not focused
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.white), // Border color when focused
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
                height: 20,
              ),
            ],
          ),
        ),
      );
    }
    if (widget.role == "Security") {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            widget.data["Report ID"] ?? '',
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
                              "${title["Title 2"]} ${widget.data["Report ID"] ?? ''}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 3"]} ${widget.data["Time"] ?? ''}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 4"]} ${widget.data["Date"] ?? ''}",
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 5"]} ${widget.data["Missing Pass"]}",
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
                              height: 20,
                            ),
                            Text(
                              title["Title 6"],
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              widget.data["Remarks"] ?? '',
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.white),
                            ),
                            const SizedBox(
                              height: 10,
                            )
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
                      child: StreamBuilder<Object>(
                          stream: null,
                          builder: (context, snapshot) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Column(
                                  children: <Widget>[
                                    SwitchListTile(
                                      title: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                          status
                                              ? "Status : Completed"
                                              : "Status : Follow Up",
                                        ),
                                      ),
                                      value: status,
                                      onChanged: (value) {
                                        setState(() {
                                          status = value;
                                        });
                                      },
                                    ),
                                  ],
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                              ],
                            );
                          }),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (status)
                    Column(
                      children: [
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
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
                                      itemCount: photoPassFound.length,
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
                                                              photoPassFound[
                                                                      index]
                                                                  .path,
                                                              fit: BoxFit
                                                                  .contain, // Add this line
                                                            )
                                                          : Image.file(
                                                              File(
                                                                  photoPassFound[
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
                                                      photoPassFound[index]
                                                          .path)
                                                  : Image.file(
                                                      File(photoPassFound[index]
                                                          .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: () {
                                                setState(() {
                                                  // Remove the selected image from the list
                                                  photoPassFound
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
                                      onPressed: pickPassFound,
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
                ],
              ),
              const SizedBox(
                height: 10,
              ),
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
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: Text(
                          title["Title 8"],
                          style: const TextStyle(
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
                          controller:
                              remarks, // take the text editing controller
                          onChanged: (value) {
                            validationError2 = false;
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: title["Sub Title 8"],
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
              const SizedBox(
                height: 10,
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
                      backgroundColor: Colors.lightBlue.shade900,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        title["Button 1"],
                        style: TextStyle(fontSize: 18.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      return const Scaffold();
    }
  }

  void _submitForm() async {
    if (status) {
      if (required7) {
        if (photoPassFound.isEmpty) {
          validationError1 = true;
          setState(() {});
        }
      } else {
        validationError1 = false;
      }

      if (required8) {
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
                    Text('Please ensure all details are filled'),
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

                    // Perform the upload task here
                    try {
                      String statusText = getStatusText(status);
                      await specificPassFollowUpService.updateRow(
                        widget.data["Date"] ?? "",
                        widget.data["Time"] ?? "",
                        widget.data["Missing Pass"] ?? '',
                        widget.email,
                        widget.data["Report ID"] ?? '',
                        widget.data["Remarks"] ?? '',
                        photoPassFound,
                        statusText,
                        remarks.text,
                        widget.data["Category"] ?? '',
                      );
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
    } else if (!status) {
      if (required8) {
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
                    Text('Please ensure all details are filled'),
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

                    // Perform the upload task here
                    try {
                      await specificPassFollowUpService.updateComment(
                          widget.data["Date"] ?? '',
                          widget.data["Time"] ?? '',
                          widget.data["Report ID"] ?? '',
                          widget.email,
                          getStatusText(status),
                          remarks.text,
                          widget.data["Remarks"] ?? '');
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
  }

  // This function is to return the Completed or Follow Up Text
  String getStatusText(bool status) {
    return status ? "Completed" : "Follow Up";
  }

  Future<List<XFile>> pickPassFound() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    validationError1 = false;
    setState(() {
      // Add the picked images to the list of image XFiles
      photoPassFound.addAll(pickedImages ?? []);
    });
    return pickedImages ?? [];
  }

  pop() {
    Navigator.pop(context);
  }

  navigateToPassCheckingFollowUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PassCheckingFollowUpMenu(
                  email: widget.email,
                  role: "Security",
                )));
  }

  void _removeFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
