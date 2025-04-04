import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '/Components/TimeRelatedFunctions.dart';
import '/ManageClampingFollowUp/ManageSpecificClampingFollowUp/ManageSpecificClampingFollowUpService.dart';
import 'package:photo_view/photo_view.dart';

import 'SuperAdminSettings.dart';

class ManageSpecificPassCompletedPage extends StatefulWidget {
  const ManageSpecificPassCompletedPage(
      {super.key, required this.data, required this.email});
  final String email;
  final Map<String, String> data;
  @override
  State<ManageSpecificPassCompletedPage> createState() =>
      _ManageSpecificPassCompletedPageState();
}

class _ManageSpecificPassCompletedPageState
    extends State<ManageSpecificPassCompletedPage> {
  ManageSpecificClampingFollowUpService manageSpecificClampingFollowUpService =
      ManageSpecificClampingFollowUpService();

  SpecificPassReportSuperAdminSettings specificPassReportSuperAdminSettings =
      SpecificPassReportSuperAdminSettings();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
    googleImages1 = manageSpecificClampingFollowUpService
        .extractFileIDs(widget.data["Missing Pass Supporting Files"]!);

    googleImagesForDisplay.addAll(googleImages1);

    status = widget.data["Status"] == "Completed";
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

  TimeRelatedFunction timeRelatedFunction = TimeRelatedFunction();

  List<String> nonCurrentFollowers = [];

  List<String> currentList = [];

  List<XFile> unclampingPhoto = [];

  List<XFile> paymentSlip = [];

  List<String> googleImages1 = [];

  List<String> googleImagesForDisplay = [];

  bool status = false;

  Map<String, dynamic> title = {};

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
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text("Pass ${widget.data["Report ID"]}",
            style: TextStyle(
                color: Colors.black),
          ),
          centerTitle: true,
          backgroundColor: Colors.white,
        ),
        body: SingleChildScrollView(
            child: Column(children: [
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
                          "${title["Title 2"]} ${widget.data["Report ID"]}",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "${title["Title 3"]} ${widget.data["Date"]}",
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          "${title["Title 4"]} ${widget.data["Time"]}",
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
          Column(children: [
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
                      Text(
                        title["Title 6"],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        widget.data["Remarks"]!,
                        style: const TextStyle(fontSize: 16,
                          color: Colors.white,
                        ),
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
                              "Previous Attachments",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, right: 25.0, top: 20),
                            child: Container(
                              height: 300,
                              width: double.infinity,
                              color: Colors.white,
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                ),
                                itemCount: googleImagesForDisplay.length,
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
                                                      googleImagesForDisplay[
                                                          index]),
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
                                          googleImagesForDisplay[index],
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
                            height: 30,
                          ),
                        ]))),
            const SizedBox(
              height: 20,
            )
          ])
        ])));
  }
}
