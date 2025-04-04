import 'package:created_by_618_abdo/SubmitFollowUpEmergencyFollowUp/SpecificEmergencyFollowUp/SuperAdminSettings.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import '/Components/TimeRelatedFunctions.dart';
import '/SubmitFollowUpEmergencyFollowUp/SpecificEmergencyFollowUp/SpecificEmergencyFollowUpService.dart';

class SpecificEmergencyCompletedPage extends StatefulWidget {
  const SpecificEmergencyCompletedPage(
      {super.key, required this.data, required this.email, required this.role});
  final String email;
  final Map<String, String> data;
  final String role;
  @override
  State<SpecificEmergencyCompletedPage> createState() =>
      _SpecificEmergencyCompletedPageState();
}

class _SpecificEmergencyCompletedPageState
    extends State<SpecificEmergencyCompletedPage> {
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
                  color: Colors.green,
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
                      color: Colors.green,
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
                              fontSize: 16,
                              color: Colors.white,
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
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
              ],
            ),
            const SizedBox(
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
