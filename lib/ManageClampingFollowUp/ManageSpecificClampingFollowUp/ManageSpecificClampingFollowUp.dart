import 'dart:io';

import 'package:created_by_618_abdo/ManageClampingFollowUp/ManageSpecificClampingFollowUp/SuperAdminSettings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '/Components/TimeRelatedFunctions.dart';
import '/ManageClampingFollowUp/ManageSpecificClampingFollowUp/ManageSpecificClampingFollowUpService.dart';
import '../ManageClampingFollowUpMenu.dart';

class ManageSpecificClampingFollowUpPage extends StatefulWidget {
  const ManageSpecificClampingFollowUpPage(
      {super.key, required this.data, required this.email, required this.role});
  final String email;
  final Map<String?, String?> data;
  final String role;
  @override
  State<ManageSpecificClampingFollowUpPage> createState() =>
      _ManageSpecificClampingFollowUpPageState();
}

class _ManageSpecificClampingFollowUpPageState
    extends State<ManageSpecificClampingFollowUpPage> {
  ManageSpecificClampingFollowUpService manageSpecificClampingFollowUpService =
      ManageSpecificClampingFollowUpService();

  ClampingFollowUpReportSuperAdminSettings clampingReportSuperAdminSettings =
      ClampingFollowUpReportSuperAdminSettings();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    googleImages1 = manageSpecificClampingFollowUpService
        .extractFileIDs(widget.data["Car Plate Supporting Files"] ?? "");
    googleImages2 = manageSpecificClampingFollowUpService
        .extractFileIDs(widget.data["Clamping Supporting Files"] ?? "");
  }

  void loadData() async {
    await clampingReportSuperAdminSettings.checkAndCreateDocument();

    title = await clampingReportSuperAdminSettings.getTitleAndRequired();

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
      title11.text = title["Title 11"];

      subtitle11.text = title["Sub Title 11"];

      button1.text = title["Button 1"];

      required9 = title["Required 9"];
      required10 = title["Required 10"];
      required11 = title["Required 11"];
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
  TextEditingController title9 = TextEditingController();
  TextEditingController title10 = TextEditingController();
  TextEditingController title11 = TextEditingController();

  TextEditingController subtitle11 = TextEditingController();

  TextEditingController button1 = TextEditingController();

  bool required9 = false;
  bool required10 = false;
  bool required11 = false;

  bool validationError1 = false;
  bool validationError2 = false;
  bool validationError3 = false;

  Map<String, dynamic> title = {};

  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();

  List<String> nonCurrentFollowers = [];

  List<String> currentList = [];

  List<XFile> unclampingPhoto = [];
  List<XFile> paymentSlip = [];

  List<String?> googleImages1 = [];
  List<String?> googleImages2 = [];
  bool? status = false;

  TextEditingController remarks = TextEditingController();

  String name = "";

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: const Center(child: CircularProgressIndicator()),
      );
    }
    if (widget.role == "Super Admin") {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Clamp Incident ${widget.data["Report ID"] ?? ""}"),
          centerTitle: true,
          backgroundColor: Colors.grey.shade200,
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
                    color: Colors.grey.shade300,
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
                            await clampingReportSuperAdminSettings
                                .updateTitle1(title1.text);
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            labelText: "Manage Main Title",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
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
                                await clampingReportSuperAdminSettings
                                    .updateTitle2(title2.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Main Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
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
                              controller: title3,
                              onChanged: (value) async {
                                await clampingReportSuperAdminSettings
                                    .updateTitle3(title3.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Main Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
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
                                await clampingReportSuperAdminSettings
                                    .updateTitle4(title4.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Main Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
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
                              controller: title5,
                              onChanged: (value) async {
                                await clampingReportSuperAdminSettings
                                    .updateTitle5(title5.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Main Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
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
                        color: Colors.grey.shade300,
                      ),
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
                              controller: title6,
                              onChanged: (value) async {
                                await clampingReportSuperAdminSettings
                                    .updateTitle6(title6.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Main Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: title7,
                          onChanged: (value) async {
                            await clampingReportSuperAdminSettings
                                .updateTitle7(title7.text);
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            labelText: "Manage Main Title",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 20),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: googleImages1.length,
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
                                                  googleImages1[index]!),
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
                                      googleImages1[index]!,
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
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: title8,
                          onChanged: (value) async {
                            await clampingReportSuperAdminSettings
                                .updateTitle8(title8.text);
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            labelText: "Manage Main Title",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25.0, top: 20),
                        child: Container(
                          height: 150,
                          width: double.infinity,
                          color: Colors.grey[200],
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: googleImages2.length,
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
                                                  googleImages2[index]!),
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
                                      googleImages2[index]!,
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
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
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
                                  controller: title9,
                                  onChanged: (value) async {
                                    await clampingReportSuperAdminSettings
                                        .updateTitle9(title9.text);
                                    setState(() {});
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Manage Main Title",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                    border: OutlineInputBorder(),
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
                                    itemCount: unclampingPhoto.length,
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
                                                            unclampingPhoto[
                                                                    index]
                                                                .path,
                                                            fit: BoxFit
                                                                .contain, // Add this line
                                                          )
                                                        : Image.file(
                                                            File(
                                                                unclampingPhoto[
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
                                                    unclampingPhoto[index].path)
                                                : Image.file(
                                                    File(unclampingPhoto[index]
                                                        .path),
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.cancel),
                                            onPressed: () {
                                              setState(() {
                                                // Remove the selected image from the list
                                                unclampingPhoto.removeAt(index);
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
                                        color: Colors.grey), // Set border color
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Set border radius
                                  ),
                                  child: SwitchListTile(
                                    title: const Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Text("Required"),
                                    ),
                                    value: required9,
                                    onChanged: (value) async {
                                      setState(() {
                                        required9 = value;
                                      });
                                      await clampingReportSuperAdminSettings
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
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
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
                                  controller: title10,
                                  onChanged: (value) async {
                                    await clampingReportSuperAdminSettings
                                        .updateTitle10(title10.text);
                                    setState(() {});
                                  },
                                  decoration: const InputDecoration(
                                    labelText: "Manage Main Title",
                                    labelStyle: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18.0,
                                    ),
                                    border: OutlineInputBorder(),
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
                                    itemCount: paymentSlip.length,
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
                                                            paymentSlip[index]
                                                                .path,
                                                            fit: BoxFit
                                                                .contain, // Add this line
                                                          )
                                                        : Image.file(
                                                            File(paymentSlip[
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
                                                    paymentSlip[index].path)
                                                : Image.file(
                                                    File(paymentSlip[index]
                                                        .path),
                                                    fit: BoxFit.cover,
                                                  ),
                                          ),
                                          IconButton(
                                            icon: const Icon(Icons.cancel),
                                            onPressed: () {
                                              setState(() {
                                                // Remove the selected image from the list
                                                paymentSlip.removeAt(index);
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
                                        color: Colors.grey), // Set border color
                                    borderRadius: BorderRadius.circular(
                                        8.0), // Set border radius
                                  ),
                                  child: SwitchListTile(
                                    title: const Padding(
                                      padding: EdgeInsets.only(left: 15.0),
                                      child: Text("Required"),
                                    ),
                                    value: required10,
                                    onChanged: (value) async {
                                      setState(() {
                                        required10 = value;
                                      });
                                      await clampingReportSuperAdminSettings
                                          .updateRequired10(required10);
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
                    color: Colors.grey.shade300,
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
                          controller: title11,
                          onChanged: (value) async {
                            await clampingReportSuperAdminSettings
                                .updateTitle11(title11.text);
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            labelText: "Manage Main Title",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller:
                              remarks, // take the text editing controller
                          decoration: InputDecoration(
                            hintText: title["Sub Title 11"],
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
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: Colors.grey), // Set border color
                            borderRadius:
                                BorderRadius.circular(8.0), // Set border radius
                          ),
                          child: SwitchListTile(
                            title: const Padding(
                              padding: EdgeInsets.only(left: 15.0),
                              child: Text("Required"),
                            ),
                            value: required11,
                            onChanged: (value) async {
                              setState(() {
                                required11 = value;
                              });
                              await clampingReportSuperAdminSettings
                                  .updateRequired11(required11);
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
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: button1,
                          onChanged: (value) async {
                            await clampingReportSuperAdminSettings
                                .updateButton1(button1.text);
                            setState(() {});
                          },
                          decoration: const InputDecoration(
                            labelText: "Manage Button Title",
                            labelStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 18.0,
                            ),
                            border: OutlineInputBorder(),
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
                height: 5,
              ),
            ],
          ),
        ),
      );
    }

    if (widget.role == "Security") {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        appBar: AppBar(
          title: Text("Clamp Incident ${widget.data["Report ID"] ?? ""}"),
          centerTitle: true,
          backgroundColor: Colors.grey.shade200,
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
                    color: Colors.grey.shade300,
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
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 3"]} ${widget.data["Time"] ?? "No Data"}",
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 4"]} ${widget.data["Date"] ?? "No Data"}",
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 25),
                            child: Text(
                              "${title["Title 5"]} ${widget.data["Car Plate Number"] ?? "No Data"}",
                              style: const TextStyle(
                                fontSize: 14.0,
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
                        color: Colors.grey.shade300,
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
                              title["Title 6"],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            Text(
                              widget.data["Remarks"] ?? "No Data",
                              style: const TextStyle(fontSize: 16),
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          title["Title 7"],
                          style: const TextStyle(
                            color: Colors.black,
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
                          color: Colors.grey[200],
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: googleImages1.length,
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
                                                  googleImages1[index]!),
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
                                      googleImages1[index]!,
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
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 15,
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30.0),
                        child: Text(
                          title["Title 8"],
                          style: const TextStyle(
                            color: Colors.black,
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
                          color: Colors.grey[200],
                          child: GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                            ),
                            itemCount: googleImages2.length,
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
                                                  googleImages2[index]!),
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
                                      googleImages2[index]!,
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
                child: Container(
                  decoration: BoxDecoration(color: Colors.grey.shade300),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: SwitchListTile(
                      title: Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Text(
                          status! ? "Status : Completed" : "Status : Follow Up",
                        ),
                      ),
                      value: status!,
                      onChanged: (value) {
                        setState(() {
                          status = value;
                        });
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              if (status!)
                Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
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
                                    title["Title 9"],
                                    style: const TextStyle(
                                      color: Colors.black,
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
                                      itemCount: unclampingPhoto.length,
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
                                                              unclampingPhoto[
                                                                      index]
                                                                  .path,
                                                              fit: BoxFit
                                                                  .contain, // Add this line
                                                            )
                                                          : Image.file(
                                                              File(
                                                                  unclampingPhoto[
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
                                                      unclampingPhoto[index]
                                                          .path)
                                                  : Image.file(
                                                      File(
                                                          unclampingPhoto[index]
                                                              .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: () {
                                                setState(() {
                                                  // Remove the selected image from the list
                                                  unclampingPhoto
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
                                      onPressed: pickUnclampingPhoto,
                                      icon: const Icon(
                                        Icons.image,
                                        size: 30,
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                border: Border.all(
                                    color: validationError2
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
                                    title["Title 10"],
                                    style: const TextStyle(
                                      color: Colors.black,
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
                                      itemCount: paymentSlip.length,
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
                                                              paymentSlip[index]
                                                                  .path,
                                                              fit: BoxFit
                                                                  .contain, // Add this line
                                                            )
                                                          : Image.file(
                                                              File(paymentSlip[
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
                                                      paymentSlip[index].path)
                                                  : Image.file(
                                                      File(paymentSlip[index]
                                                          .path),
                                                      fit: BoxFit.cover,
                                                    ),
                                            ),
                                            IconButton(
                                              icon: const Icon(Icons.cancel),
                                              onPressed: () {
                                                setState(() {
                                                  // Remove the selected image from the list
                                                  paymentSlip.removeAt(index);
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
                                      onPressed: pickPaymentSlipPhoto,
                                      icon: const Icon(
                                        Icons.image,
                                        size: 30,
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
                      color: Colors.grey.shade300,
                      border: Border.all(
                          color: validationError3
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
                          title["Title 11"],
                          style: const TextStyle(
                            fontSize: 16.0,
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
                            validationError3 = false;
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: title["Sub Title 11"],
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
                      backgroundColor: Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5)),
                    ),
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        title["Button 1"],
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
    } else {
      return const Scaffold();
    }
  }

  void _submitForm() async {
    if (status!) {
      if (required9) {
        if (unclampingPhoto.isEmpty) {
          validationError1 = true;
          setState(() {});
        }
      } else {
        validationError1 = false;
      }

      if (required10) {
        if (paymentSlip.isEmpty) {
          validationError2 = true;
          setState(() {});
        }
      } else {
        validationError2 = false;
      }

      if (required11) {
        if (remarks.text.isEmpty) {
          validationError3 = true;
          setState(() {});
        }
      } else {
        validationError3 = false;
      }

      if (validationError1 || validationError2 || validationError3) {
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
                      String statusText = getStatusText(status!);

                      await manageSpecificClampingFollowUpService.updateRow(
                          widget.data["Car Plate Number"]!,
                          widget.email,
                          widget.data["Report ID"]!,
                          widget.data["Remarks"]!,
                          unclampingPhoto,
                          paymentSlip,
                          statusText,
                          remarks.text);
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
    } else if (!status!) {
      if (required11) {
        if (remarks.text.isEmpty) {
          validationError3 = true;
          setState(() {});
        }
      } else {
        validationError3 = false;
      }
      if (validationError3) {
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
                      await manageSpecificClampingFollowUpService.updateComment(
                          widget.data["Report ID"]!,
                          widget.email,
                          remarks.text,
                          widget.data["Remarks"]!);

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

  Future<List<XFile>> pickUnclampingPhoto() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    validationError1 = false;
    setState(() {
      // Add the picked images to the list of image XFiles
      unclampingPhoto.addAll(pickedImages);
    });
    return pickedImages;
  }

  Future<List<XFile>> pickPaymentSlipPhoto() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    validationError2 = false;
    setState(() {
      // Add the picked images to the list of image XFiles
      paymentSlip.addAll(pickedImages);
    });
    return pickedImages;
  }

  pop() {
    Navigator.pop(context);
  }

  navigateToPassCheckingFollowUp() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ManageClampingMenu(
                  email: widget.email,
                  role: "Security",
                )));
  }

  void _removeFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}
