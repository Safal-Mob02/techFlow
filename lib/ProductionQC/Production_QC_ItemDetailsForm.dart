import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';


import '../Purchase_QC/Purchase_QC_ITEM_SAVE_Response.dart';
import '../Response_Files/InwardResponse/Inward_Location_Response.dart';
import '../Response_Files/IssueResponse/ItemDelete_Response.dart';
import '../Response_Files/IssueResponse/LocationSelection_Response.dart';
import '../Response_Files/IssueResponse/LocationWiseStockListing_Response.dart';
import '../Response_Files/IssueResponse/SaveItemIssue_Response.dart';
import '../Response_Files/PurchaseQC_Response/Purchase_QC_Reason_Response.dart';

import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'package:http/http.dart' as http;


typedef void ApiCallback();

class Production_QC_ItemDetailsForm extends StatefulWidget {
  var FormData, Urn, /*CategoryCode,categoryName,*/ docNo,srno, status;
  final ApiCallback onPopCallback;
  Production_QC_ItemDetailsForm(
      {Key? key,
        required this.FormData,
        required this.Urn,
        /*required this.CategoryCode, required this.categoryName,*/ required this.docNo,
        required this.srno,
        required this.onPopCallback,
        this.status})
      : super(key: key);

  @override
  _Production_QC_ItemDetailsFormState createState() =>
      _Production_QC_ItemDetailsFormState();
}

class _Production_QC_ItemDetailsFormState
    extends State<Production_QC_ItemDetailsForm> {
  bool isChecked = false;
  TextEditingController ItemNameController = TextEditingController();
  TextEditingController SoNoController = TextEditingController();
  TextEditingController ProductionItemController = TextEditingController();
  TextEditingController ProcessController = TextEditingController();
  TextEditingController UnitController = TextEditingController();
  TextEditingController QuantityController = TextEditingController();
  TextEditingController ReasonController = TextEditingController();
  TextEditingController StockController = TextEditingController();
  TextEditingController RemarksController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  TextEditingController InUnitController = TextEditingController();
  TextEditingController InQTYController = TextEditingController();
  TextEditingController AmountController = TextEditingController();
  TextEditingController disAmountController = TextEditingController();
  TextEditingController FebricationContractorNameController = TextEditingController();

  var ItemNameCode;
  var SelectedReasonCode="";
  var coCode, urCode;
  var LocationResponseData;

  bool isLoading = false;

  String clientUrl = "";

  String? SelectedStock;

  var LocationWiseStockListing;

  var reasonValue;

  var ContractorNameData;

  String FebricationContractorCode="";

  List<Map<String, String>> StatusList=[];

  @override
  void initState() {
    setState(() {
      reasonValue = widget.FormData.status;
      ReasonController.text = widget.FormData.reason.toString();
      InQTYController.text =widget.FormData.qty.toString();

    });
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
      GetLocation("");
      fetchdata("");

      // GetStockLocationWise();
    }));
    // TODO: implement initState
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    InQTYController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kMainColor,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: kMainColor,
        elevation: 0.0,
        titleSpacing: 0.0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Item Details",
          maxLines: 2,
          style: kTextStyle.copyWith(color: Colors.white, fontSize: 20.0),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: isLoading
              ? Center(
              child: Container(
                margin: const EdgeInsets.all(50),
                child: Lottie.asset(
                  'Assets/loading.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ))
              : Column(
            //mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(bottom: 5.0),
                  child: Row(children: <Widget>[
                    Expanded(
                        child: Divider(
                          color: Colors.black,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Urn: ${widget.Urn}"),
                    ),
                    Expanded(
                        child: Divider(
                          color: Colors.black,
                        )),
                  ]),
                ),
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                        initialValue:
                        "${widget.FormData.index.toString()}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Index'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        controller: InQTYController,
                        //initialValue: "${widget.FormData.qty.toString()}",
                        readOnly: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Qty'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
        DropdownButtonFormField<String>(
          value: reasonValue, // Initially selected value
          onChanged: (String? newValue) {
            setState(() {
              reasonValue = newValue!; // Update selected value
            });
          },
          items: StatusList
              .map<DropdownMenuItem<String>>((Map<String, String> item) {
            return DropdownMenuItem<String>(
              value: item["Select_Value"], // Use Select_Value as the value
              child: Text(item["Select_Value"]!), // Display Select_Value as the label
            );
          }).toList(),
          decoration: InputDecoration(
            focusedBorder: myfocusborder(),
            enabledBorder: myinputborder(),
            hintText: '',
            labelText: 'Reason',
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please fill this field';
            }
            return null;
          },
        ),

        SizedBox(
                  height: 10,
                ),
                reasonValue == "Accept"
                    ? SizedBox.shrink()
                    : TextFormField(
                  controller: ReasonController,
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  onTap: () {
                    setState(() {});
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        return StatefulBuilder(
                            builder: (context, setState) {
                              return LocationResponseData != null
                                  ? AlertDialog(
                                title:
                                const Text('Select Reason'),
                                content: Container(
                                  width: double.maxFinite,
                                  //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize:
                                    MainAxisSize.min,
                                    children: [
                                      CupertinoSearchTextField(
                                        controller:
                                        _searchController,
                                        onChanged: (value) {
                                          setState(() {
                                            GetLocation(value);
                                            isLoading = true;
                                            GetLocation(value)
                                                .then((data) {
                                              setState(() {
                                                LocationResponseData =
                                                    data;
                                                log(data.data
                                                    .toString());
                                                isLoading = false;
                                              });
                                            }).catchError(
                                                    (error) {
                                                  setState(() {
                                                    isLoading = false;
                                                    // Handle error if necessary
                                                  });
                                                });
                                          });
                                        },
                                      ),
                                      const SizedBox(height: 10),
                                      isLoading
                                          ? Center(
                                        child: Lottie.asset(
                                          'Assets/loading.json',
                                          width: 100,
                                          height: 100,
                                          fit: BoxFit.fill,
                                        ),
                                      )
                                          : Container(
                                        height: 200,
                                        child: ListView
                                            .builder(
                                          itemCount:
                                          LocationResponseData
                                              .data
                                              .length,
                                          itemBuilder:
                                              (BuildContext
                                          context,
                                              int index) {
                                            //final item = filteredItems[index];
                                            return InkWell(
                                              onTap: () {
                                                setState(
                                                        () {
                                                      ReasonController
                                                          .text =
                                                      "${LocationResponseData.data[index].selectValue.toString()}";
                                                      SelectedReasonCode = LocationResponseData
                                                          .data[
                                                      index]
                                                          .selectValueCode;
                                                      Navigator.pop(
                                                          context);
                                                      log("SelectedReasonCode:: $SelectedReasonCode");
                                                    });
                                              },
                                              child:
                                              ListTile(
                                                  title:
                                                  Text(
                                                    "${LocationResponseData.data[index].selectValue.toString()}",
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight
                                                            .w500,
                                                        fontSize:
                                                        15,
                                                        color: Colors
                                                            .black),
                                                  )),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                // actions: <Widget>[
                                //   TextButton(
                                //     onPressed: () {
                                //       Navigator.of(context).pop();
                                //     },
                                //     child: Text('Cancel'),
                                //   ),
                                //   TextButton(
                                //     onPressed: () {
                                //       // Do something with the selected items
                                //       print('Selected Items: $selectedItem');
                                //       // Close the dialog
                                //       Navigator.of(context).pop();
                                //     },
                                //     child: Text('Done'),
                                //   ),
                                // ],
                              )
                                  : const AlertDialog(
                                title: Text('No Data Available'),
                              );
                              ;
                            });
                      },
                    );
                  },
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      postfixIcon: Icon(
                        Icons.arrow_drop_down,
                        size: 30,
                      ),
                      // prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Reason'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill this field';
                    }
                    return null;
                  },
                ),
                SizedBox(
                  height: 10,
                ),

                SizedBox(
                  height: 10,
                ),
              ]),
        ),
      ),
      bottomNavigationBar: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  left: 15.0, right: 5.0, top: 0, bottom: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    popCurrentPage();
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
                  child: const Center(
                    child: Text(
                      'Cancel',
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
          Flexible(
            child: Container(
              color: Colors.white,
              padding: const EdgeInsets.only(
                  left: 5.0, right: 15.0, top: 0, bottom: 10),
              child: InkWell(
                onTap: () {
                  setState(() {
                    log(widget.status.toString());
                    if (widget.status != "Approved" &&
                        widget.status != "Forwarded") {
                      SaveData();
                    } else {
                      popCurrentPage();
                    }
                    // log(widget.FormData.srNo.toString());
                    // log(SelectedReasonCode);
                    // log(widget.Urn);
                    // if(double.parse(SelectedStock!)>0){
                    //   SaveData();
                    // }else{
                    //   Fluttertoast.showToast(
                    //     msg: "You don't have enough stock",
                    //     textColor: Colors.white,
                    //     backgroundColor: Colors.red,
                    //     gravity: ToastGravity.BOTTOM,
                    //   );
                    // }
                    //  widget.tabController.animateTo(0);
                  });
                },
                child: Container(
                  height: 60.0,
                  decoration: BoxDecoration(
                    color: kMainColor,
                    border: Border.all(color: Colors.white, width: 1.0),
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: const Center(
                    child: Text(
                      'Save',
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
        ],
      ),
    );
  }

  void popCurrentPage() {
    // Perform any necessary actions before popping

    // Call the callback function to trigger API call on the previous page
    widget.onPopCallback();

    Navigator.pop(context);
  }

  Future<void> SaveData() async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'Co_Code': coCode,
      'Urn_No': widget.Urn,
      'Status': reasonValue.toString(),
      'Qty': InQTYController.text,
      'Reason': SelectedReasonCode,
      'SR_No': widget.srno,
    };
    log("Api Name: ${clientUrl}QC/UpdateQCSummaryItemDetails $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}QC/UpdateQCSummaryItemDetails"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/UpdateQCSummaryItemDetails $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = PurchaseQcItemSaveResponse.fromJson(map);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (urnResData.settings.success == "1") {
        setState(() {
          /*Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  ItemsPage(Urn:widget.Urn,CategoryCode:widget.CategoryCode,categoryName: widget.categoryName,docNo:widget.docNo)));
         */
          popCurrentPage();
          Fluttertoast.showToast(
            msg: urnResData.message,
            textColor: Colors.white,
            backgroundColor: Colors.green,
            gravity: ToastGravity.BOTTOM,
          );
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
          gravity: ToastGravity.BOTTOM,
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

  Future<PurchaseQcReasonResponse> GetLocation(SearchText) async {
    Map data = {
      "Searchtext": SearchText,
      "Select_Valuecode": "",
      "CO_CODE": coCode,
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}QC/SelectionQCReason"),
      body: data,
    );
    log("${clientUrl}QC/SelectionQCReason$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        LocationResponseData = PurchaseQcReasonResponse.fromJson(map);
      });

      if (LocationResponseData.settings.success == "1") {
        setState(() {
          return LocationResponseData;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Data Not Found!",
            textColor: Colors.white,
            backgroundColor: Colors.red[800],
            gravity: ToastGravity.BOTTOM);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Something Wrong Please try again!",
          textColor: Colors.white,
          backgroundColor: Colors.red[800],
          gravity: ToastGravity.BOTTOM);
    }
    return LocationResponseData;
  }

  Future<LocationWiseStockListingResponse> GetStockLocationWise() async {
    Map data = {"user_id": urCode, "CO_CODE": coCode, "IT_Code": ItemNameCode};
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}Techflow/LocationWiseStockListing"),
      body: data,
    );
    log("${clientUrl}Techflow/LocationWiseStockListing$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        LocationWiseStockListing =
            LocationWiseStockListingResponse.fromJson(map);
      });

      if (LocationWiseStockListing.settings.success == "1") {
        setState(() {
          return LocationWiseStockListing;
        });
      } else {
        Fluttertoast.showToast(
            msg: "Data Not Found!",
            textColor: Colors.white,
            backgroundColor: Colors.red[800],
            gravity: ToastGravity.BOTTOM);
      }
    } else {
      Fluttertoast.showToast(
          msg: "Something Wrong Please try again!",
          textColor: Colors.white,
          backgroundColor: Colors.red[800],
          gravity: ToastGravity.BOTTOM);
    }
    return LocationWiseStockListing;
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

  Future<void> fetchdata(search) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'UR_CODE': urCode,
      'CO_Code': coCode,
      'search_text': search,
      'Select_Valuecode': "",
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCSummeryStatus"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCSummeryStatus $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      // var batch_qty =map["Data"][0]["Batch Qty"];


      setState(() {
        isLoading = false;
        //DoPandingListData = PurchaseQcMainData.fromJson(map);
      });
      if (map['settings']['success'] == "1") {


        setState(() {
          isLoading = false;

        });
        List<dynamic> dataList = map['Data'];

        // Convert to a List<Map<String, String>>
         StatusList = dataList.map((item) {
          return {
            "Select_Value": item["Select_Value"].toString(),
            "Select_Value_Code": item["Select_Value_Code"].toString(),
          };
        }).toList();
         log("StatusList${StatusList.toString()}");

      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: "${map['message']}",
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


}
