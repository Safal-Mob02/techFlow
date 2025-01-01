import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../HomePage/HomePage.dart';
import '../Response_Files/IssueResponse/Issue_Delete_Response.dart';
import '../Response_Files/IssueResponse/ItemDelete_Response.dart';
import '../Response_Files/IssueResponse/materialissue_List_Response.dart';
import '../Response_Files/IssueResponse/statusRemarks_Response.dart';
import '../Response_Files/IssueResponse/statusUpdate_Response.dart';
import '../Scanner_Pages/Scanner_Issue.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'Material_Issue_ItemList.dart';

class Material_Issue_ListScreen extends StatefulWidget {
  const Material_Issue_ListScreen({super.key});

  @override
  State<Material_Issue_ListScreen> createState() =>
      _Material_Issue_ListScreenState();
}

class _Material_Issue_ListScreenState extends State<Material_Issue_ListScreen> {
  var urCode;

  bool isLoading = false;

  var clientUrl;

  var DoPandingListData;

  TextEditingController remarkController = TextEditingController();
  List<String> descriptions = [];
  String selectedDescription = "";
  String? coCode;

  @override
  void initState() {
    PreferenceManager.instance
        .getStringValue("urCode")
        .then((value) => setState(() {
              urCode = value;
              log(urCode.toString());
            }));
    PreferenceManager.instance
        .getStringValue("clientUrl")
        .then((value) => setState(() {
              clientUrl = value;
              log(clientUrl.toString());
              fetchdata("");
            }));
    PreferenceManager.instance
        .getStringValue("coCode")
        .then((value) => setState(() {
              coCode = value;
              log(coCode.toString());
            }));
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.push(context,
            MaterialPageRoute(builder: (context) => const HomeScreen()));
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: kMainColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kMainColor,
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: const IconThemeData(color: Colors.white),
          title: Text(
            'Material Issue List',
            maxLines: 2,
            style: kTextStyle.copyWith(color: Colors.white, fontSize: 20.0),
          ),
        ),
        body: Center(
            child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSearchTextField(
                        //controller: controller,
                        onChanged: (value) {
                          fetchdata(value.toString());
                        },
                        onSubmitted: (value) {},
                        autocorrect: true,
                      ),
                    ),
                    isLoading
                        ? Center(
                            child: Container(
                            child: Lottie.asset(
                              'Assets/loading.json',
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          ))
                        : DoPandingListData != null
                            ? Expanded(
                                child: ListView.builder(
                                    padding: const EdgeInsets.all(1),
                                    itemCount: DoPandingListData.data.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Dismissible(
                                        confirmDismiss: (direction) async {
                                          if (direction == DismissDirection.endToStart) {
                                            setState(() {
                                             if(DoPandingListData.data[index].status != "Approved") {
                                                _delete(context,DoPandingListData.data[index].urnNo);
                                                fetchdata("");
                                              }
                                            });
                                            // final bool res = await showDialog(
                                            //     context: context,
                                            //     builder: (BuildContext context) {
                                            //       return Container();
                                            //     });
                                            // return res;
                                          } else {
                                            setState(() {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ItemsPage(
                                                              Urn:
                                                                  DoPandingListData
                                                                      .data[
                                                                          index]
                                                                      .urnNo)));
                                              //  onNextPageChangeTapped();
                                            });
                                            fetchdata("");
                                            // TODO: Navigate to edit page;
                                          }
                                        },
                                        background: slideLeftBackground(),
                                        secondaryBackground:
                                            slideRightBackground(),
                                        key: Key(DoPandingListData.data[index]
                                            .toString()),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            child: Material(
                                              elevation: 2.0,
                                              child: Container(
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 0.0,
                                                        vertical: 0),
                                                decoration: const BoxDecoration(
                                                  border: Border(
                                                    left: BorderSide(
                                                      color: kMainColor,
                                                      width: 3.0,
                                                    ),
                                                  ),
                                                  color: Colors.white,
                                                ),
                                                child: InkWell(
                                                  onTap: () {
                                                    // setState(() {
                                                    //   Navigator.push(
                                                    //       context,
                                                    //       MaterialPageRoute(
                                                    //           builder: (context) =>
                                                    //               ItemsPage(Urn: DoPandingListData
                                                    //                   .data[
                                                    //               index]
                                                    //                   .urnNo)));
                                                    //   //  onNextPageChangeTapped();
                                                    // });

                                                    // Navigator.push(context, MaterialPageRoute(builder: (context) => DO_Item_Roll_List(urn:DoPandingListData.data[index].urnNo.toString(),itemName:DoPandingListData.data[index].itemName.toString())));
                                                  },
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.start,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Align(
                                                        alignment:
                                                            Alignment.topRight,
                                                        child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Spacer(),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      top: 0.0,
                                                                      left: 0.0,
                                                                      right: 0),
                                                              child: Container(
                                                                height: 28,
                                                                width: 150,
                                                                alignment: Alignment
                                                                    .centerRight,
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left:
                                                                            0.0,
                                                                        right:
                                                                            0,
                                                                        top: 0),
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: DoPandingListData
                                                                              .data[
                                                                                  index]
                                                                              .status ==
                                                                          "Approved"
                                                                      ? Colors
                                                                          .green
                                                                          .withOpacity(
                                                                              0.8)
                                                                      : DoPandingListData.data[index].status ==
                                                                              "Not Approved"
                                                                          ? Colors
                                                                              .orange
                                                                          : DoPandingListData.data[index].status == "Cancel"
                                                                              ? Colors.red
                                                                              : Colors.blue,
                                                                  // Consider adding a border if desired:
                                                                  // border: Border(top: BorderSide(color: Colors.grey, width: 5)),
                                                                  borderRadius:
                                                                      const BorderRadius
                                                                          .only(
                                                                    bottomLeft:
                                                                        Radius.circular(
                                                                            20.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                            0.0),
                                                                  ),
                                                                ),
                                                                child: DoPandingListData
                                                                            .data[index]
                                                                            .status !=
                                                                        "Draft"
                                                                    ? Padding(
                                                                        padding: const EdgeInsets
                                                                            .only(
                                                                            left:
                                                                                8.0),
                                                                        child:
                                                                            Center(
                                                                          child:
                                                                              DropdownButtonHideUnderline(
                                                                            child:
                                                                                DropdownButton<String>(
                                                                              value: DoPandingListData.data[index].status,
                                                                              isExpanded: true, // Ensures the button fills the container width
                                                                              icon: const Icon(Icons.arrow_drop_down),
                                                                              dropdownColor: kMainColor, // Adjust dropdown color as needed
                                                                              elevation: 16,
                                                                              iconDisabledColor: Colors.white,
                                                                              // Optional elevation for a more raised effect
                                                                              style: const TextStyle(color: Colors.white, fontSize: 16.0),
                                                                              onChanged: (String? newStatus) {
                                                                                setState(() {
                                                                                  DoPandingListData.data[index].status = newStatus!;
                                                                                  RemarksList(DoPandingListData.data[index].srNo.toString(), DoPandingListData.data[index].urnNo.toString());
                                                                                  if (newStatus == 'Cancel') {
                                                                                    showDialog(
                                                                                      context: context,
                                                                                      builder: (BuildContext context) {
                                                                                        final remarksController = TextEditingController();
                                                                                        String? selectedDescription;
                                                                                        return StatefulBuilder(
                                                                                          builder: (context, setState) {
                                                                                            return SizedBox(
                                                                                              child: AlertDialog(
                                                                                                title: const Text('Enter Remarks'),
                                                                                                content: descriptions.isEmpty
                                                                                                    ? CircularProgressIndicator()
                                                                                                    : SizedBox(
                                                                                                        child: DropdownButton<String>(
                                                                                                          padding: EdgeInsets.all(0),
                                                                                                          hint: Text('Select Description',style: TextStyle(fontSize: 12),),
                                                                                                          value: selectedDescription,
                                                                                                          onChanged: (newValue) {
                                                                                                            setState(() {
                                                                                                              selectedDescription = newValue;
                                                                                                            });
                                                                                                          },
                                                                                                          items: descriptions.map((String description) {
                                                                                                            return DropdownMenuItem<String>(
                                                                                                              value: description,
                                                                                                              child: Text(description,style: TextStyle(fontSize: 12),),
                                                                                                            );
                                                                                                          }).toList(),
                                                                                                        ),
                                                                                                      ),
                                                                                                actions: [
                                                                                                  TextButton(
                                                                                                    child: const Text('Cancel'),
                                                                                                    onPressed: () => Navigator.of(context).pop(),
                                                                                                  ),
                                                                                                  TextButton(
                                                                                                    child: const Text('OK'),
                                                                                                    onPressed: () {
                                                                                                      if (selectedDescription != "" && selectedDescription != null && selectedDescription != "null" && selectedDescription!.isNotEmpty) {
                                                                                                        setState(() {
                                                                                                          UpdateStatus(
                                                                                                            newStatus,
                                                                                                            DoPandingListData.data[index].urnNo,
                                                                                                          );
                                                                                                          Navigator.of(context).pop();
                                                                                                        });
                                                                                                      } else {
                                                                                                        Fluttertoast.showToast(
                                                                                                          msg: "Please Enter Status Remarks",
                                                                                                          textColor: Colors.white,
                                                                                                          backgroundColor: Colors.red,
                                                                                                          gravity: ToastGravity.BOTTOM,
                                                                                                        );
                                                                                                      }
                                                                                                      // Perform actions based on remarks (e.g., print, store)
                                                                                                      // Add additional logic for handling remarks here

                                                                                                    },
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                        );
                                                                                      },
                                                                                    );
                                                                                  } else {
                                                                                    UpdateStatus(newStatus, DoPandingListData.data[index].urnNo);
                                                                                    print('Status changed to $newStatus');
                                                                                  }
                                                                                });
                                                                              },
                                                                              items: [
                                                                                DropdownMenuItem<String>(
                                                                                  value: 'Approved',
                                                                                  child: Text('Approved'),
                                                                                ),
                                                                                DropdownMenuItem<String>(
                                                                                  value: 'Not Approved',
                                                                                  child: Text('Not Approved'),
                                                                                ),
                                                                                DropdownMenuItem<String>(
                                                                                  value: 'Cancel',
                                                                                  child: Text('Cancel'),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ),
                                                                        ),
                                                                      )
                                                                    : Center(
                                                                        child:
                                                                            Text(
                                                                          DoPandingListData
                                                                              .data[index]
                                                                              .status,
                                                                          style:
                                                                              const TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                          ),
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                              ),
                                                            )
                                                          ],
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 5,
                                                      ),
                                                      Row(
                                                        children: [
                                                          ///////////
                                                          Flexible(
                                                            child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(0)),
                                                                  // color: Colors.grey,
                                                                ),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    const Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Text(
                                                                        "URN",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.black,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                    DoPandingListData
                                                                            .data[index]
                                                                            .urnNo ??
                                                                        "---",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          ///////////
                                                          Flexible(
                                                            child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(0)),
                                                                  // color: Colors.grey,
                                                                ),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    const Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Text(
                                                                        "So No",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.black,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                    DoPandingListData
                                                                            .data[index]
                                                                            .soNo ??
                                                                        "---",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          ///////////
                                                          Flexible(
                                                            child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(0)),
                                                                  // color: Colors.grey,
                                                                ),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    const Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Text(
                                                                        "Issue Date",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.black,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                    DoPandingListData
                                                                            .data[index]
                                                                            .issueDate ??
                                                                        "---",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        children: [
                                                          ///////////
                                                          Flexible(
                                                            child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.only(
                                                                          bottomLeft:
                                                                              Radius.circular(0)),
                                                                  // color: Colors.grey,
                                                                ),
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child:
                                                                    const Column(
                                                                  children: [
                                                                    Padding(
                                                                      padding:
                                                                          EdgeInsets.all(
                                                                              5.0),
                                                                      child:
                                                                          Text(
                                                                        "Issue No",
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                        style: TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                            color: Colors.black,
                                                                            fontSize: 16),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )),
                                                          ),
                                                          Flexible(
                                                            child: Container(
                                                                alignment: Alignment
                                                                    .centerLeft,
                                                                child: Padding(
                                                                  padding: EdgeInsets
                                                                      .only(
                                                                          left:
                                                                              10),
                                                                  child: Text(
                                                                    DoPandingListData
                                                                            .data[index]
                                                                            .issueNo ??
                                                                        "---",
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis,
                                                                    style: TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w400,
                                                                        color: Colors
                                                                            .black,
                                                                        fontSize:
                                                                            16),
                                                                  ),
                                                                )),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }),
                              )
                            : Text("No Data"),
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Scanner_Issue()));
              //  onNextPageChangeTapped();
            });
          },
          child: Container(
            //width: 100.0,
            height: 60.0,
            decoration:
                BoxDecoration(color: kMainColor, shape: BoxShape.circle),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: const Center(
                child: CircleAvatar(
                  backgroundColor: kMainColor,
                  child: Icon(
                    Icons.document_scanner,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void _delete(BuildContext context, Urn) {
    showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: const Text('Please Confirm'),
            content: const Text('Are you sure want to Delete Item?'),
            actions: [
              // The "Yes" button
              TextButton(
                  onPressed: () {
                                        Navigator.pop(context);
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      DeleteItem(Urn.toString());
                    });
                    // Close the dialog
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }

  Future<void> DeleteItem(Urn) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'User_id':urCode,
      'CO_CODE': coCode,
      'urn_no': Urn,
    };
    log("Api Name: ${clientUrl}/TechFlow/MaterialIssueDeleteItemlist $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/TechFlow/MaterialIssueDeleteItemlist"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/TechFlow/MaterialIssueDeleteItemlist $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
    var  urnResData = IssueDeleteResponse.fromJson(map);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (urnResData.settings.success == "1") {
        Navigator.of(context).pop();
        fetchdata("");
        Fluttertoast.showToast(
          msg: urnResData.message,
          textColor: Colors.white,
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
        );
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "${urnResData.message}",
          textColor: Colors.white,
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Please try again!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    }
  }


  Future<void> UpdateStatus(newStatus, urn) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_CODE': coCode,
      'UR_CODE': urCode,
      'Urn_No': urn,
      'Status': newStatus,
      'Remark': selectedDescription
    };
    log("Api Name: ${clientUrl}/TechFlow/MaterialIssueUpdateStatus $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/TechFlow/MaterialIssueUpdateStatus"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/TechFlow/MaterialIssueUpdateStatus $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = StatusUpdateResponse.fromJson(map);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (urnResData.settings.success == "1") {
        setState(() {});
        fetchdata("");
        Fluttertoast.showToast(
          msg: urnResData.message,
          textColor: Colors.white,
          backgroundColor: Colors.green,
          gravity: ToastGravity.CENTER,
        );
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "${urnResData.message}",
          textColor: Colors.white,
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Please try again!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> RemarksList(srNo, urn) async {
    var BODYDATA = {
      'CO_CODE': coCode,
      'SR_No': srNo,
      'urn_no': urn,
    };
    log("Api Name: ${clientUrl}/TechFlow/Material_Issue_Cancel_Status_Remark $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/TechFlow/Material_Issue_Cancel_Status_Remark"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/TechFlow/Material_Issue_Cancel_Status_Remark $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = StatusRemarksResponse.fromJson(map);
      if (!mounted) return;

      if (urnResData.settings.success == "1") {
        setState(() {
          setState(() {
            descriptions =
                urnResData.data.map((item) => item.paraDescription).toList();
          });
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "${urnResData.message}",
          textColor: Colors.white,
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Please try again!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Future<void> fetchdata(SearchText) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'page_index': "1",
      'user_id': urCode,
      'search_text': SearchText.toString()
    };
    final response = await http.post(
      Uri.parse("${clientUrl}TechFlow/MaterialIssueListing"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}TechFlow/MaterialIssueListing $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      DoPandingListData = MaterialissueListResponse.fromJson(map);
      if (DoPandingListData.settings.success == "1") {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "${DoPandingListData.settings.message}",
          textColor: Colors.white,
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
        );
      }
    } else {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
        msg: "Please try again!",
        textColor: Colors.white,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    }
  }

  Widget slideLeftBackground() {
    return Container(
      color: Colors.green,
      child: const Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              Icons.edit,
              color: Colors.white,
            ),
            Text(
              " Edit",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
          ],
        ),
      ),
    );
  }

  Widget slideRightBackground() {
    return Container(
      color: Colors.red,
      child: const Align(
        alignment: Alignment.centerRight,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Icon(
              Icons.delete,
              color: Colors.white,
            ),
            Text(
              " Delete",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.right,
            ),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
