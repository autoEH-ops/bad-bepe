import 'dart:io';

import 'package:created_by_618_abdo/SubmitMainGateReport/SuperAdminSettings.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../SubmitMainGateReport/MainGateReportService.dart';

class SubmitMainGateReport extends StatefulWidget {
  const SubmitMainGateReport(
      {super.key, required this.email, required this.role});
  final String email;
  final String role;
  @override
  State<SubmitMainGateReport> createState() => _SubmitMainGateReportState();
}

class _SubmitMainGateReportState extends State<SubmitMainGateReport> {
  MainGateReportService mainGateReportService = MainGateReportService();

  MainGateReportSuperAdminSettings mainGateReportSuperAdminSettings =
      MainGateReportSuperAdminSettings();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _loadData();
  }

  void _loadData() async {
    await mainGateReportService.checkAndCreateDocument();
    await mainGateReportSuperAdminSettings.checkAndCreateDocument();
    nextMainGate = await mainGateReportService.getMainGate();
    mainGateStatus = await mainGateReportService.getCurrentMainGateStatus();
    latestData = await mainGateReportService.getLastRow();
    title = await mainGateReportSuperAdminSettings.getTitleAndRequired();

    setState(() {
      title1.text = title["Title 1"];
      title2.text = title["Title 2"];
      title3.text = title["Title 3"];
      title4.text = title["Title 4"];
      title5.text = title["Title 5"];
      title6.text = title["Title 6"];
      title7.text = title["Title 7"];
      required6 = title["Required 6"];
      required7 = title["Required 7"];
      button1.text = title["Button 1"];
      subtitle1.text = title["Sub Title 1"];
    });
  }

  bool required6 = false;

  bool required7 = false;

  TextEditingController title1 = TextEditingController();
  TextEditingController title2 = TextEditingController();
  TextEditingController title3 = TextEditingController();
  TextEditingController title4 = TextEditingController();
  TextEditingController title5 = TextEditingController();
  TextEditingController title6 = TextEditingController();
  TextEditingController title7 = TextEditingController();

  TextEditingController button1 = TextEditingController();

  TextEditingController subtitle1 = TextEditingController();

  bool validationError1 = false;

  bool validationError2 = false;

  Map<String, dynamic> title = {};

  String nextMainGate = "";

  String mainGateStatus = "";

  Map<String, dynamic> latestData = {};

  List<XFile> mainGateImages = [];

  late TextEditingController remarks = TextEditingController();

  @override
  Widget build(BuildContext context) {
    if (title.isEmpty) {
      return Scaffold(
        backgroundColor: Colors.grey.shade200,
        body: const Center(child: CircularProgressIndicator()),
      ); // Show loading ind
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text("Main Gate Report Page"),
        actions: widget.role == "Super Admin"
            ? <Widget>[
                IconButton(
                  icon: const Icon(Icons.remove_red_eye),
                  onPressed: () {
                    _removeFocus();
                    navigateToSubmitMainGateReport();
                  },
                ),
              ]
            : null,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
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
                    if (widget.role == "Super Admin")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: title1,
                          onChanged: (value) async {
                            await mainGateReportSuperAdminSettings
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
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          title["Title 1"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    if (widget.role == "Super Admin")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: title2,
                              onChanged: (value) async {
                                await mainGateReportSuperAdminSettings
                                    .updateTitle2(title2.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: title3,
                              onChanged: (value) async {
                                await mainGateReportSuperAdminSettings
                                    .updateTitle3(title3.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: title4,
                              onChanged: (value) async {
                                await mainGateReportSuperAdminSettings
                                    .updateTitle4(title4.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: TextFormField(
                              controller: title5,
                              onChanged: (value) async {
                                await mainGateReportSuperAdminSettings
                                    .updateTitle5(title5.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Title",
                                labelStyle: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                ),
                                border: OutlineInputBorder(),
                              ),
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    if (widget.role == "Security")
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${title["Title 2"]} $nextMainGate",
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${title["Title 3"]} $mainGateStatus",
                              style: const TextStyle(
                                fontSize: 14.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${title["Title 4"]} ${latestData.isNotEmpty ? '${latestData['Previous Gate']}' : 'No data yet'}",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10),
                            child: Text(
                              "${title["Title 5"]} ${latestData.isNotEmpty ? '${latestData['Prev Gate Date']} ${latestData['Prev Gate Time']}' : 'No data yet'}",
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
              height: 20,
            ),
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
                    if (widget.role == "Super Admin")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: title6,
                          onChanged: (value) async {
                            await mainGateReportSuperAdminSettings
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
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          title["Title 6"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25.0, top: 20),
                      child: Container(
                        height: 200,
                        width: double.infinity,
                        color: Colors.grey[200],
                        child: GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ),
                          itemCount: mainGateImages.length,
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
                                                  mainGateImages[index].path,
                                                  fit: BoxFit.contain,
                                                )
                                              : Image.file(
                                                  File(mainGateImages[index]
                                                      .path),
                                                  fit: BoxFit.contain,
                                                ),
                                        );
                                      },
                                    );
                                  },
                                  child: kIsWeb
                                      ? Image.network(
                                          mainGateImages[index].path)
                                      : Image.file(
                                          File(mainGateImages[index].path),
                                          fit: BoxFit.cover,
                                        ),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.cancel),
                                  onPressed: () {
                                    setState(() {
                                      // Remove the selected image from the list
                                      mainGateImages.removeAt(index);
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
                          ),
                        ),
                      ],
                    ),
                    if (widget.role == "Super Admin")
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
                            value: required6,
                            onChanged: (value) async {
                              setState(() {
                                required6 = value;
                              });
                              await mainGateReportSuperAdminSettings
                                  .updateRequired6(required6);
                            },
                          ),
                        ),
                      ),
                    const SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
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
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    if (widget.role == "Super Admin")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: title7,
                          onChanged: (value) async {
                            await mainGateReportSuperAdminSettings
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
                      )
                    else
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Text(
                          title["Title 7"],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                          ),
                        ),
                      ),
                    if (widget.role == "Super Admin")
                      Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            child: TextFormField(
                              controller: subtitle1,
                              style: TextStyle(color: Colors.grey.shade700),
                              onChanged: (value) async {
                                await mainGateReportSuperAdminSettings
                                    .updateSubtitle1(subtitle1.text);
                                setState(() {});
                              },
                              decoration: const InputDecoration(
                                labelText: "Manage Hint Title",
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
                    if (widget.role == "Security")
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: TextFormField(
                          controller: remarks,
                          onChanged: (value) {
                            validationError2 = false;
                            setState(() {});
                          },
                          decoration: InputDecoration(
                            hintText: title["Sub Title 1"],
                            border: InputBorder.none,
                          ),
                          minLines: 3,
                          maxLines: null,
                        ),
                      ),
                    if (widget.role == "Super Admin")
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
                            value: required7,
                            onChanged: (value) async {
                              setState(() {
                                required7 = value;
                              });
                              await mainGateReportSuperAdminSettings
                                  .updateRequired7(required7);
                            },
                          ),
                        ),
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
            if (widget.role == "Super Admin")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: SizedBox(
                  width: double.infinity,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: const EdgeInsets.all(10.0),
                    child: Align(
                        alignment: Alignment.center,
                        child: TextFormField(
                          controller: button1,
                          // Use the TextEditingController
                          onChanged: (value) async {
                            await mainGateReportSuperAdminSettings
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
                        )), // Adjust padding as needed
                  ),
                ),
              ),
            if (widget.role == "Security")
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
                        borderRadius: BorderRadius.circular(5),
                      ),
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
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }

  void _submitForm() {
    if (required6) {
      if (mainGateImages.isEmpty) {
        validationError1 = true;
        setState(() {});
      }
    } else {
      validationError1 = false;
    }

    if (required7) {
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
                  Navigator.of(context).pop(); // Returns false to indicate "No"
                },
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () async {
                  _removeFocus();
                  pop();
                  showDialog(
                    context: context,
                    barrierDismissible:
                        false, // Prevent closing dialog by tapping outside
                    builder: (BuildContext context) {
                      return const AlertDialog(
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Uploading Main Gate Report\nPlease be patient ... ',
                              style: TextStyle(fontSize: 16),
                            ),

                            SizedBox(
                                height: 10,
                                width:
                                    20), // Add some spacing between the CircularProgressIndicator and the text
                            CircularProgressIndicator(),
                          ],
                        ),
                      );
                    },
                  );
                  try {
                    bool success =
                        await mainGateReportService.addMainGateReport(
                            widget.email,
                            nextMainGate,
                            mainGateStatus,
                            mainGateImages,
                            remarks.text);

                    if (success) {
                      pop();
                      pop();
                    } else {
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

  Future<List<XFile>> _pickImage() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();
    validationError1 = false;
    setState(() {
      // Add the picked images to the list of image XFiles
      mainGateImages.addAll(pickedImages);
    });
    return pickedImages;
  }

  void _removeFocus() {
    FocusScope.of(context).requestFocus(FocusNode());
  }

  pop() {
    Navigator.pop(context);
  }

  navigateToSubmitMainGateReport() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SubmitMainGateReport(
                  email: widget.email,
                  role: "Security",
                )));
  }
}
