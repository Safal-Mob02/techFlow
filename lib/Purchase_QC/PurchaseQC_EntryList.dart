import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import '../HomePage/HomePage.dart';
import '../Response_Files/InwardResponse/Inward_ListingResponse.dart';
import '../Response_Files/IssueResponse/Issue_Delete_Response.dart';
import '../Response_Files/IssueResponse/ItemDelete_Response.dart';
import '../Response_Files/IssueResponse/materialissue_List_Response.dart';
import '../Response_Files/IssueResponse/statusRemarks_Response.dart';
import '../Response_Files/IssueResponse/statusUpdate_Response.dart';
import '../Response_Files/PurchaseQC_Response/AddToPendingQCResponse.dart';
import '../Response_Files/PurchaseQC_Response/Purchase_QC_Main_Listing_Response.dart';
import '../Response_Files/PurchaseQC_Response/productionQC_PendingList_Response.dart';
import '../Response_Files/PurchaseQC_Response/purchaseQcPendingListResponse.dart';
import '../Scanner_Pages/Scanner_Issue.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'Purchase_QC_Form_TAB_Page.dart';
import 'ScannerForPurchaseQC.dart';


class PurchaseQC_EntryList extends StatefulWidget {
  const PurchaseQC_EntryList({super.key});

  @override
  State<PurchaseQC_EntryList> createState() => _PurchaseQC_EntryListState();
}

class _PurchaseQC_EntryListState extends State<PurchaseQC_EntryList> {
  var urCode;

  bool isLoading = false;

  var clientUrl;

  var DoPandingListData;

  TextEditingController remarkController = TextEditingController();
  List<String> descriptions = [];
  String selectedDescription = "";
  String? coCode;

  String EntryPendingValue="Entry";

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
    }));
    PreferenceManager.instance
        .getStringValue("coCode")
        .then((value) => setState(() {
      coCode = value;
      log(coCode.toString());
      if(EntryPendingValue=="Entry"){
      fetchdataForEntry("");
      }else{
        fetchdataForPending("");
      }
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
            'Inward Qc',
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  EntryPendingValue == "Entry"
                                      ? kMainColor
                                      : Colors.grey),
                              onPressed: () {
                                setState(() {
                                  EntryPendingValue = "Entry";
                                  fetchdataForEntry("");
                                });

                              },
                              child: const Text(
                                "Entry",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width / 2.5,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                  EntryPendingValue ==
                                      "Pending" ? kMainColor : Colors.grey),
                              onPressed: () {
                                setState(() {});
                                EntryPendingValue = "Pending";
                                fetchdataForPending("");
                              },
                              child: Text(
                                "Pending",
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: CupertinoSearchTextField(
                        //controller: controller,
                        onChanged: (value) {
                          if(EntryPendingValue=="Entry"){
                          fetchdataForEntry(value.toString());
                          }else{
                            fetchdataForPending(value.toString());
                          }
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
                        ? EntryPendingValue=="Entry"?
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(1),
                          itemCount: DoPandingListData.data.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Dismissible(
                              confirmDismiss: (direction) async {
                                if (direction ==
                                    DismissDirection.endToStart) {
                                  setState(() {
                                    if (DoPandingListData
                                        .data[index].status !=
                                        "Approved") {
                                      _delete(
                                          context,
                                          DoPandingListData
                                              .data[index].urnNo);

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
                                                Purchase_QC_Form_TAB_Page(
                                                    Urn:
                                                    DoPandingListData
                                                        .data[
                                                    index]
                                                        .urnNo,status:DoPandingListData
                                                    .data[
                                                index]
                                                    .status)));
                                    //  onNextPageChangeTapped();
                                  });
                                  fetchdataForEntry("");
                                  // TODO: Navigate to edit page;
                                }
                              },
                              background: slideLeftBackground(DoPandingListData.data[index].status),
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
                                                      child: (DoPandingListData.data[index].status !=
                                                          "Draft" &&
                                                          DoPandingListData.data[index].status !=
                                                              "Forwarded" &&DoPandingListData.data[index].status !=
                                                              "")
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
                                                              value: DoPandingListData.data[index].status??"Not Approved",
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
                                                                  // RemarksList(DoPandingListData.data[index].srNo.toString(), DoPandingListData.data[index].urnNo.toString());
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
                                                                                    hint: Text(
                                                                                      'Select Description',
                                                                                      style: TextStyle(fontSize: 12),
                                                                                    ),
                                                                                    value: selectedDescription,
                                                                                    onChanged: (newValue) {
                                                                                      setState(() {
                                                                                        selectedDescription = newValue;
                                                                                      });
                                                                                    },
                                                                                    items: descriptions.map((String description) {
                                                                                      return DropdownMenuItem<String>(
                                                                                        value: description,
                                                                                        child: Text(
                                                                                          description,
                                                                                          style: TextStyle(fontSize: 12),
                                                                                        ),
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
                                                                                            DoPandingListData.data[index].urnNo, DoPandingListData.data[index].srNo
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
                                                                    UpdateStatus(newStatus, DoPandingListData.data[index].urnNo, DoPandingListData.data[index].srNo);
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
                                                                // DropdownMenuItem<String>(
                                                                //   value: 'Cancel',
                                                                //   child: Text('Cancel'),
                                                                // ),
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
                                                Container(
                                                    decoration:
                                                    const BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          bottomLeft:
                                                          Radius.circular(
                                                              0)),
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
                                                          child: Text(
                                                            "Item : ",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                16),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
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
                                                              .itemName ??
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
                                                              "Doc Date :",
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
                                                              .docDate ??
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
                                                              "DocNo :",
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
                                                              .docNo ??
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
                                                              "Party :",
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
                                                              .partyDetails ??
                                                              "---",
                                                          overflow:
                                                          TextOverflow
                                                              .visible,
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
                                                              "SoNo :",
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
                                                              .visible,
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
                    ):
                    Expanded(
                      child: ListView.builder(
                          padding: const EdgeInsets.all(1),
                          itemCount: DoPandingListData.data.length,
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Dismissible(
                              confirmDismiss: (direction) async {
                                if (direction ==
                                    DismissDirection.endToStart) {

                                  // final bool res = await showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return Container();
                                  //     });
                                  // return res;
                                } else {
                                  QCInwardQRCheck("${DoPandingListData.data[index].urnNo}-${DoPandingListData.data[index].srNo}");

                                  //GetURN_FOR_PurchaceQC("${DoPandingListData.data[index].urnNo}-${DoPandingListData.data[index].Sr_No}" );
                                  // TODO: Navigate to edit page;
                                }
                              },
                              background: slideLeftBackground(DoPandingListData.data[index].status),
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
                                                      child: Center(
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
                                              height: 10,
                                            ),
                                            Row(
                                              children: [
                                                ///////////
                                                Container(
                                                    decoration:
                                                    const BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          bottomLeft:
                                                          Radius.circular(
                                                              0)),
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
                                                          child: Text(
                                                            "Item : ",
                                                            overflow:
                                                            TextOverflow
                                                                .ellipsis,
                                                            style: TextStyle(
                                                                fontWeight: FontWeight
                                                                    .w500,
                                                                color: Colors
                                                                    .black,
                                                                fontSize:
                                                                16),
                                                          ),
                                                        ),
                                                      ],
                                                    )),
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
                                                              .itemName ??
                                                              "---",
                                                          overflow:
                                                          TextOverflow
                                                              .visible,
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
                                                              "Urn No :",
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
                                                              "OrderDate :",
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
                                                              .orderDate ??
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
                                                              "SoNo :",
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
                                                              "Qty :",
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
                                                              .qty.toString()??
                                                              "---",
                                                          overflow:
                                                          TextOverflow
                                                              .visible,
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
                        : const Text("No Data"),
                  ],
                ))),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScannerForPurchaseQC(menuName: "PurchaseQC",)));
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
      // 'User_id': urCode,
      'CO_CODE': coCode,
      'urn_no': Urn,
    };
    log("Api Name: ${clientUrl}QC/QCAnalysisDelete $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCAnalysisDelete"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCAnalysisDelete $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = IssueDeleteResponse.fromJson(map);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (urnResData.settings.success == "1") {
        Navigator.of(context).pop();
        fetchdataForEntry("");
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

  Future<void> UpdateStatus(newStatus, urn,srNo) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_Code': coCode,
      'UR_CODE': urCode,
      'Urn_No': urn,
      'Status': newStatus,
      'Remark': selectedDescription,
      'EntrySrNo':srNo.toString()
    };
    log("Api Name: ${clientUrl}QC/QCListUpdateStatus $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCListUpdateStatus"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCListUpdateStatus $BODYDATA");
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
        fetchdataForEntry("");
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

  Future<void> fetchdataForEntry(SearchText) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'UR_CODE': urCode,
      'searchtext': SearchText.toString(),
      'Co_Code': coCode,
      'startrecordno':'0',
      'recordlength': '10',
      'Search': 'IQC',
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCAlysisItemDAta"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCAlysisItemDAta $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      DoPandingListData = PurchaseQcMainListingResponse.fromJson(map);
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
  Future<void> fetchdataForPending(SearchText) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'user_id': urCode,
      'search_text': SearchText.toString(),
      'Co_Code': coCode,
      'startrecordno':'0',
      'recordlength': '10'
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCAnalysisPendingList"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCAnalysisPendingList $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      DoPandingListData = PurchaseQcPendingListResponse.fromJson(map);
      log(DoPandingListData.toString());
      if(map['settings']['success']=="0"){
        Fluttertoast.showToast(
          msg: "${map['settings']['message']}",
          textColor: Colors.white,
          backgroundColor: Colors.red,
          gravity: ToastGravity.CENTER,
        );
      }
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

  Widget slideLeftBackground(status) {
    return Container(
      color: Colors.green,
      child:  Align(
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              width: 20,
            ),
            Icon(
              status=="Approved"||status=="Forwarded"?CupertinoIcons.eye:Icons.edit,
              color: Colors.white,
            ),
            Text(
              status=="Approved"||status=="Forwarded"?" View":" Edit",
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

  Future<void> QCInwardQRCheck(BarcodeRes) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_CODE':coCode,
      'UR_CODE': urCode,
      'recordlength': "",
      'Searchtext': "",
      'startrecordno': "0",
      'RefNo': "${BarcodeRes}",
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCInwardQRCheck"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCInwardQRCheck $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      //var DoPandingListData = AddToPendingQcResponse.fromJson(map);
      if ( map["settings"]["success"] == "1") {
        // if (!mounted) return;
        // setState(() {
        //   isLoading = false;
        // });
        // setState(() {
        //   String Urn =DoPandingListData.data[0].urnNo.toString();
        //   log(Urn);
        //   controller!.stopCamera();
        //   if(Urn.isNotEmpty){
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => Purchase_QC_Form_TAB_Page(Urn: Urn,)));
        //   }
        // });
        GetURN_FOR_PurchaceQC(BarcodeRes);


      } else {
        setState(() {
          isLoading = false;
        });
        //Navigator.pop(context);
        //Navigator.pop(context);
        Fluttertoast.showToast(
          msg: map["settings"]["message"]??"QR is not available",
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

  Future<void> GetURN_FOR_PurchaceQC(BarcodeRes) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'urn_no': "${BarcodeRes}",
      'user_id': urCode,
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCToAnalysis"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCToAnalysis $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      var DoPandingListData = AddToPendingQcResponse.fromJson(map);
      if (DoPandingListData.settings.success == "1") {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        setState(() {
          String Urn =DoPandingListData.data[0].urnNo.toString();
          log(Urn);
          //controller!.stopCamera();
          if(Urn.isNotEmpty){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Purchase_QC_Form_TAB_Page(Urn: Urn,)));
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        // Fluttertoast.showToast(
        //   msg: DoPandingListData.settings.message??"NO Data Available",
        //   textColor: Colors.white,
        //   backgroundColor: Colors.red,
        //   gravity: ToastGravity.CENTER,
        // );
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text(DoPandingListData.settings.message ?? "Invalid Data"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    // Navigator.push(context, MaterialPageRoute(builder: (context) => Material_Issue_ListScreen(),));// Close the dialog
                  },
                ),
              ],
            );
          },
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
}
