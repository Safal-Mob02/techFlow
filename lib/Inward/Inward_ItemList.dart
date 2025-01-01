import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart'as http;
import '../Material_Issue/Material_Issue_ListScreen.dart';
import '../Response_Files/InwardResponse/Inward_ItemList_Response.dart';
import '../Response_Files/IssueResponse/ItemDelete_Response.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'InwardListScreen.dart';
import 'Inward_ItemDetails_form.dart';
class Inward_ItemList extends StatefulWidget {
  final TabController tabController;
  var urn,status;
  Inward_ItemList(
      {Key? key,
   required this.tabController, required this.urn,this.status
      })
      : super(key: key);
  @override
  State<Inward_ItemList> createState() => _Inward_ItemListState();
}

class _Inward_ItemListState extends State<Inward_ItemList> {
  var urCode;

  bool isLoading = false;
  var clientUrl;
  var DoPandingListData;
  var coCode;
  var urnResData;
  TextEditingController CategoryController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  var CategoryCode;
  var LocationResponseData;
  String? docNo;

  double totalWidhth=0.0;
  // var _searchController;
  @override
  void initState() {
    PreferenceManager.instance
        .getStringValue("urCode")
        .then((value) => setState(() {
      urCode = value;
      log(urCode.toString());
    }));
    PreferenceManager.instance
        .getStringValue("coCode")
        .then((value) => setState(() {
      coCode = value;
      log(coCode.toString());
    }));
    PreferenceManager.instance
        .getStringValue("clientUrl")
        .then((value) => setState(() {
      clientUrl = value;
      log(clientUrl.toString());
      fetchdata("");
      //GetLocation("");
      // CategoryController.text = widget.categoryName ?? "";
      // CategoryCode = widget.CategoryCode.toString();
      // docNo = widget.docNo ?? "";
    }));
    log(widget.urn);

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>  InwardListScreen()));
      },
      child: Scaffold(
        backgroundColor: kMainColor,
        resizeToAvoidBottomInset: true,
        body: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0)),
              color: Colors.white,
            ),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                          color: Colors.black,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(0.0),
                      child: Text("Urn: ${widget.urn}\n\n    Total: $totalWidhth"),
                    ),
                    Expanded(
                        child: Divider(
                          color: Colors.black,
                        )),
                  ]),
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoSearchTextField(
                      //controller: controller,
                      onChanged: (value) {
                        fetchdata(value.toString());
                      },
                      onSubmitted: (value) {},
                      autocorrect: true,
                    )),
                Expanded(
                    child: isLoading
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
                        ? SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                          padding: EdgeInsets.all(1),
                          itemCount: DoPandingListData.data.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder:
                              (BuildContext context, int index) {
                            return Dismissible(
                              confirmDismiss: (direction) async {
                                if (direction ==
                                    DismissDirection.endToStart) {
                                  setState(() {
                                    // fetchdata("");
                                    _delete(
                                        context,
                                        DoPandingListData
                                            .data[index].purInwardSrNo);
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
                                                Inward_ItemDetails_form(
                                                    FormData:
                                                    DoPandingListData.data[
                                                    index],
                                                    Urn: widget.urn,
                                                    // CategoryCode:
                                                    // CategoryCode,
                                                    // categoryName:
                                                    // CategoryController
                                                    //     .text
                                                    //     .toString(),
                                                    docNo: docNo,
                                                onPopCallback: () => fetchdata(""),status: widget.status,)));
                                    // if ((CategoryCode != "" &&
                                    //     CategoryCode != null) &&
                                    //     (docNo != "" &&
                                    //         docNo != null)) {
                                    //
                                    // } else {
                                    //   Fluttertoast.showToast(
                                    //     msg: "Select Category First",
                                    //     textColor: Colors.white,
                                    //     backgroundColor: Colors.red,
                                    //     gravity: ToastGravity.BOTTOM,
                                    //   );
                                    // }
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
                                padding: EdgeInsets.all(8.0),
                                child: Container(
                                  child: Material(
                                    elevation: 2.0,
                                    child: Container(
                                      width: MediaQuery.of(context)
                                          .size
                                          .width,
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 0.0,
                                          vertical: 0),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          left: BorderSide(
                                            color: kMainColor,
                                            width: 4.0,
                                          ),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: InkWell(
                                        onTap: () {},
                                        child: Column(
                                          mainAxisAlignment:
                                          MainAxisAlignment.start,
                                          crossAxisAlignment:
                                          CrossAxisAlignment
                                              .start,
                                          children: [
                                            Padding(
                                              padding:
                                              EdgeInsets
                                                  .all(5.0),
                                              child:Row(
                                                children: [
                                                  Text("Item:  ",style: TextStyle(
                                                  fontWeight: FontWeight
                                                  .w500,
                                                  color: Colors
                                                      .green,
                                                  fontSize:
                                                  14),),
                                                  Flexible(
                                                    child: Text(
                                                      "${DoPandingListData.data[index].itemName}",
                                                      overflow:
                                                      TextOverflow
                                                          .visible,
                                                      style: TextStyle(
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          color: Colors
                                                              .black,
                                                          fontSize:
                                                          14),
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ),
                                            SizedBox(height: 5,),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              //  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                Container(
                                                    decoration:
                                                    BoxDecoration(
                                                      borderRadius: BorderRadius.only(
                                                          bottomLeft:
                                                          Radius.circular(
                                                              0)),
                                                      // color: Colors.grey,
                                                    ),
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Padding(
                                                      padding:
                                                      EdgeInsets.all(
                                                          5.0),
                                                      child: Text(
                                                        "Index",
                                                        overflow:
                                                        TextOverflow
                                                            .ellipsis,
                                                        style: TextStyle(
                                                            fontWeight: FontWeight
                                                                .w500,
                                                            color: Colors
                                                                .green,
                                                            fontSize:
                                                            14),
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            5),
                                                        child: Text(
                                                          DoPandingListData
                                                              .data[index]
                                                              .index
                                                              .toString() ??
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
                                                              13),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                            Radius.circular(0)),
                                                        // color: Colors.grey,
                                                      ),
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                5.0),
                                                            child:
                                                            Text(
                                                              "In Qty",
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  color: Colors.green,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            5),
                                                        child: Text(
                                                          DoPandingListData
                                                              .data[index]
                                                              .inQty.toString() ??
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
                                                              13),
                                                        ),
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                            Radius.circular(0)),
                                                        // color: Colors.grey,
                                                      ),
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                5.0),
                                                            child:
                                                            Text(
                                                              "In Unit",
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  color: Colors.green,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            5),
                                                        child: Text(
                                                          DoPandingListData
                                                              .data[index]
                                                              .inUnit.toString() ??
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
                                                              13),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                ///////////
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                            Radius.circular(0)),
                                                        // color: Colors.grey,
                                                      ),
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                5.0),
                                                            child:
                                                            Text(
                                                              "QTY",
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  color: Colors.green,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            5),
                                                        child: Text(
                                                          DoPandingListData
                                                              .data[index]
                                                              .quantity.toString() ??
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
                                                              13),
                                                        ),
                                                      )),
                                                ),

                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                            Radius.circular(0)),
                                                        // color: Colors.grey,
                                                      ),
                                                      alignment: Alignment.centerLeft,
                                                      child: const Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                5.0),
                                                            child:
                                                            Text(
                                                              "Unit",
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  color: Colors.green,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            0,
                                                            right:
                                                            10),
                                                        child: Text(
                                                          DoPandingListData
                                                              .data[index]
                                                              .unit.toString() ??
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
                                                              13),
                                                        ),
                                                      )),
                                                ),

                                                SizedBox(
                                                  width: 10,
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                            Radius.circular(0)),
                                                        // color: Colors.grey,
                                                      ),
                                                      alignment: Alignment.centerLeft,
                                                      child: const Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                5.0),
                                                            child:
                                                            Text(
                                                              "Rate",
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.bold,
                                                                  color: Colors.green,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            0,
                                                            right:
                                                            10),
                                                        child: Text(
                                                          DoPandingListData
                                                              .data[index]
                                                              .rate.toString() ??
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
                                                              13),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [
                                                ///////////
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                            Radius.circular(0)),
                                                        // color: Colors.grey,
                                                      ),
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Column(
                                                        children: [
                                                          Padding(
                                                            padding:
                                                            EdgeInsets.all(
                                                                5.0),
                                                            child:
                                                            Text(
                                                              "Amount",
                                                              overflow:
                                                              TextOverflow.ellipsis,
                                                              style: TextStyle(
                                                                  fontWeight:
                                                                  FontWeight.w500,
                                                                  color: Colors.green,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            5),
                                                        child: Text(
                                                          DoPandingListData
                                                              .data[index]
                                                              .amount.toString() ??
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
                                                              13),
                                                        ),
                                                      )),
                                                ),



                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      decoration:
                                                      BoxDecoration(
                                                        borderRadius:
                                                        BorderRadius.only(
                                                            bottomLeft:
                                                            Radius.circular(0)),
                                                        // color: Colors.grey,
                                                      ),
                                                      alignment: Alignment.centerLeft,
                                                      child: const Column(
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
                                                                  FontWeight.bold,
                                                                  color: Colors.green,
                                                                  fontSize: 14),
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                ),
                                                Expanded(
                                                  flex: 1,
                                                  child: Container(
                                                      alignment: Alignment
                                                          .centerLeft,
                                                      child: Padding(
                                                        padding: EdgeInsets
                                                            .only(
                                                            left:
                                                            0,
                                                            right:
                                                            10),
                                                        child: Text(
                                                          DoPandingListData
                                                              .data[index]
                                                              .soNo.toString() ??
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
                                                              13),
                                                        ),
                                                      )),
                                                ),
                                              ],
                                            ),
                                            Row(children: [

                                              Container(
                                                  decoration:
                                                  BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.only(
                                                        bottomLeft:
                                                        Radius.circular(0)),
                                                    // color: Colors.grey,
                                                  ),
                                                  alignment: Alignment.centerLeft,
                                                  child: const Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                        EdgeInsets.all(
                                                            5.0),
                                                        child:
                                                        Text(
                                                          "Location",
                                                          overflow:
                                                          TextOverflow.ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors.green,
                                                              fontSize: 14),
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                              SizedBox(width: 10,),
                                              Expanded(
                                                flex: 1,
                                                child: Container(
                                                    alignment: Alignment
                                                        .centerLeft,
                                                    child: Padding(
                                                      padding: EdgeInsets
                                                          .only(
                                                          left:
                                                          0,
                                                          right:
                                                          10),
                                                      child: Text(
                                                        DoPandingListData
                                                            .data[index]
                                                            .location.toString() ??
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
                                                            13),
                                                      ),
                                                    )),
                                              ),
                                            ],)
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
                        : Text("No Data"))
              ],
            )),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 5.0, right: 15.0, top: 0, bottom: 10),
          child: InkWell(
            onTap: () {
              setState(() {
                Navigator.push(context, MaterialPageRoute(builder: (context) => InwardListScreen(),));
                //  widget.tabController.animateTo(0);
              });
            },
            child: Container(
              //width: 100.0,
              height: 60.0,
              decoration: BoxDecoration(
                color: kMainColor,
                border: Border.all(color: Colors.white, width: 1.0),
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Center(
                child: Text(
                  'Submit',
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'poppins_regular',
                      fontSize: 17,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Future<SelectCategoryIssueResponse> GetLocation(SearchText) async {
  //   Map data = {
  //     "UR_CODE": urCode,
  //     "Select_Valuecode": "",
  //     "Searchtext": SearchText,
  //     "CO_CODE": coCode,
  //   };
  //   setState(() {
  //     isLoading = true;
  //   });
  //   final response = await http.post(
  //     Uri.parse("${clientUrl}TechFlow/SelectionIssueCategory"),
  //     body: data,
  //   );
  //   log("${clientUrl}TechFlow/SelectionIssueCategory$data");
  //   log(response.body.toString());
  //   setState(() {
  //     isLoading = false;
  //   });
  //   var jsonData;
  //   if (response.statusCode == 200) {
  //     jsonData = json.decode(response.body);
  //     var map = Map<String, dynamic>.from(jsonData);
  //     setState(() {
  //       LocationResponseData = SelectCategoryIssueResponse.fromJson(map);
  //     });
  //
  //     if (LocationResponseData.settings.success == "1") {
  //       setState(() {
  //         return LocationResponseData;
  //       });
  //     } else {
  //       Fluttertoast.showToast(
  //           msg: "Data Not Found!",
  //           textColor: Colors.white,
  //           backgroundColor: Colors.red[800],
  //           gravity: ToastGravity.BOTTOM);
  //     }
  //   } else {
  //     Fluttertoast.showToast(
  //         msg: "Something Wrong Please try again!",
  //         textColor: Colors.white,
  //         backgroundColor: Colors.red[800],
  //         gravity: ToastGravity.BOTTOM);
  //   }
  //   return LocationResponseData;
  // }
  //
  // Future<void> SaveData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var BODYDATA = {
  //     'Urn_No': widget.Urn,
  //     'CO_Code': coCode,
  //     'User_id': urCode,
  //     'DOC_No': docNo.toString(),
  //     'DB_CODE': CategoryCode.toString()
  //   };
  //   log("Api Name: ${clientUrl}/TechFlow/MaterialIssueUpdateData $BODYDATA");
  //   final response = await http.post(
  //     Uri.parse("${clientUrl}/TechFlow/MaterialIssueUpdateData"),
  //     body: BODYDATA,
  //   );
  //   log("Api Name: ${clientUrl}/TechFlow/MaterialIssueUpdateData $BODYDATA");
  //   log("Response Status Code: ${response.statusCode}");
  //   log("Response Body: ${response.body}");
  //   if (!mounted) return;
  //   setState(() {
  //     isLoading = false;
  //   });
  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body);
  //     var map = Map<String, dynamic>.from(jsonData);
  //     var urnResData = SaveItemIssueResponse.fromJson(map);
  //
  //     if (urnResData.settings.success == "1") {
  //       setState(() {
  //         Navigator.push(
  //             context,
  //             MaterialPageRoute(
  //               builder: (context) => Material_Issue_ListScreen(),
  //             ));
  //         Fluttertoast.showToast(
  //           msg: urnResData.message,
  //           textColor: Colors.white,
  //           backgroundColor: Colors.green,
  //           gravity: ToastGravity.BOTTOM,
  //         );
  //       });
  //     } else {
  //       if (!mounted) return;
  //       setState(() {
  //         isLoading = false;
  //         AwesomeDialog(
  //           btnCancelColor: Colors.black,
  //           btnOkColor: kMainColor,
  //           btnOkText: "Yes",
  //           context: context,
  //           // dialogType: DialogType.error,
  //           borderSide: const BorderSide(
  //             color: kMainColor,
  //             width: 2,
  //           ),
  //           width: double.infinity,
  //           buttonsBorderRadius: const BorderRadius.all(
  //             Radius.circular(2),
  //           ),
  //           dismissOnTouchOutside: true,
  //           dismissOnBackKeyPress: false,
  //           headerAnimationLoop: false,
  //           animType: AnimType.bottomSlide,
  //           title: "Warning!!",
  //
  //           //  dialogType: DialogType.info,
  //           desc: "${urnResData.message}",
  //           descTextStyle: const TextStyle(fontSize: 17),
  //           showCloseIcon: false,
  //           btnCancelOnPress: () {},
  //           btnOkOnPress: () {},
  //         ).show();
  //       });
  //     }
  //   } else {
  //     if (!mounted) return;
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Fluttertoast.showToast(
  //       msg: "Please try again!",
  //       textColor: Colors.white,
  //       backgroundColor: Colors.red,
  //       gravity: ToastGravity.CENTER,
  //     );
  //   }
  // }

  void _delete(BuildContext context, srNO) {
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
                    // Close the dialog
                    setState(() {
                      cancel();
                    });
                  },
                  child: const Text('No')),
              TextButton(
                  onPressed: () {
                    // Remove the box
                    setState(() {
                      DeleteItem(srNO.toString());
                    });
                    // Close the dialog
                  },
                  child: const Text('Yes')),
            ],
          );
        });
  }

  Future<void> DeleteItem(srNo) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_CODE': coCode,
      'urn_no': widget.urn,
      'User_id': urCode.toString(),
      'oasrno': srNo,
    };
    log("Api Name: ${clientUrl}/purchase/PurchaseInwardDeleteItemlist $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/purchase/PurchaseInwardDeleteItemlist"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/purchase/PurchaseInwardDeleteItemlist $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      urnResData = ItemDeleteResponse.fromJson(map);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (urnResData.settings.success == "1") {
        Navigator.of(context).pop();
        fetchdata("");
        Fluttertoast.showToast(
          msg: urnResData.settings.message,
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
          msg: "${urnResData.settings.message}",
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


  void cancel() {
    Navigator.pop(context);
  }

  Widget slideLeftBackground() {
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
              widget.status=="Approved"||widget.status=="Forwarded"?CupertinoIcons.eye:Icons.edit,
              color: Colors.white,
            ),
            Text(
              widget.status=="Approved"||widget.status=="Forwarded"?" View":" Edit",
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

  Future<void> fetchdata(SearchText) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'UrnNo': widget.urn.toString(),
      'UR_CODE': urCode,
      'Co_Code': coCode,
      'FrmName':"",
      'GridName':""

    };
    final response = await http.post(
      Uri.parse("${clientUrl}purchase/PurchaseInwardGetItemCol"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}purchase/PurchaseInwardGetItemCol $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        isLoading = false;
        DoPandingListData = InwardItemListResponse.fromJson(map);
      });
      if (DoPandingListData.settings.success == "1") {
        totalWidhth=0.0;
        setState(() {
          for(var i in DoPandingListData.data){
            double tempval= double.parse(i.amount.toString());
            // double temptotalQty = double.parse(i.totalQty.toString());
            totalWidhth +=tempval;
            //  totalQty +=temptotalQty;
          }});
          log(totalWidhth.toString());
        setState(() {
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "${DoPandingListData.message}",
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

  OutlineInputBorder myinputborder() {
    //return type is OutlineInputBorder
    return OutlineInputBorder(
      //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: kBorderColorTextField,
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: kMainColor,
          width: 3,
        ));
  }

  // Future<void> GetURN(BarcodeRes) async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var BODYDATA = {
  //     'DB_CODE': "${BarcodeRes}",
  //     'UR_CODE': urCode,
  //     'URN_No': widget.Urn,
  //     'CO_CODE': coCode,
  //   };
  //   final response = await http.post(
  //     Uri.parse("${clientUrl}TechFlow/SelectionIssueCategoryDocNo"),
  //     body: BODYDATA,
  //   );
  //   log("Api Name: ${clientUrl}TechFlow/SelectionIssueCategoryDocNo $BODYDATA");
  //   log("Response Status Code: ${response.statusCode}");
  //   log("Response Body: ${response.body}");
  //   if (response.statusCode == 200) {
  //     var jsonData = json.decode(response.body);
  //     log(jsonData.toString());
  //     var map = Map<String, dynamic>.from(jsonData);
  //     var DoPandingListData = DocNoResponse.fromJson(map);
  //     if (DoPandingListData.settings.success == "1") {
  //       if (!mounted) return;
  //       setState(() {
  //         isLoading = false;
  //       });
  //       setState(() {
  //         docNo = DoPandingListData.data[0].docNo.toString();
  //         if (docNo!.isNotEmpty) {
  //           Navigator.pop(context);
  //         }
  //       });
  //     } else {
  //       if (!mounted) return;
  //       setState(() {
  //         isLoading = false;
  //       });
  //       Fluttertoast.showToast(
  //         msg: "${DoPandingListData.message}",
  //         textColor: Colors.white,
  //         backgroundColor: Colors.red,
  //         gravity: ToastGravity.CENTER,
  //       );
  //     }
  //   } else {
  //     if (!mounted) return;
  //     setState(() {
  //       isLoading = false;
  //     });
  //     Fluttertoast.showToast(
  //       msg: "Please try again!",
  //       textColor: Colors.white,
  //       backgroundColor: Colors.red,
  //       gravity: ToastGravity.CENTER,
  //     );
  //   }
  // }

  InputDecoration inputDecoration({
    InputBorder? enabledBorder,
    InputBorder? focusedBorder,
    InputBorder? border,
    Color? fillColor,
    bool? filled,
    Widget? prefixIcon,
    Widget? postfixIcon,
    String? hintText,
    String? labelText,
  }) =>
      InputDecoration(
          labelStyle: TextStyle(color: Colors.grey),
          enabledBorder: enabledBorder ??
              OutlineInputBorder(
                  borderSide:
                  BorderSide(color: kBorderColorTextField, width: 2.0)),
          focusedBorder: focusedBorder ??
              OutlineInputBorder(
                  borderSide:
                  BorderSide(color: kBorderColorTextField, width: 2.0)),
          border: border ??
              OutlineInputBorder(
                  borderSide: BorderSide(color: kBorderColorTextField)),
          fillColor: fillColor ?? Colors.white,
          filled: filled ?? true,
          prefixIcon: prefixIcon,
          suffixIcon: postfixIcon,
          hintText: hintText,
          labelText: labelText);
}
