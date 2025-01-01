import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../Response_Files/IssueResponse/Isssue_additem_SRNO_Response.dart';
import '../Response_Files/IssueResponse/Issue_ItemList_Response.dart';
import '../Response_Files/IssueResponse/ItemDelete_Response.dart';
import '../Response_Files/IssueResponse/LocationSelection_Response.dart';
import '../Response_Files/IssueResponse/LocationWiseStockListing_Response.dart';
import '../Response_Files/IssueResponse/SaveItemIssue_Response.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'package:http/http.dart'as http;

import 'Material_Issue_ItemList.dart';
class AddItemForm extends StatefulWidget {
  var Urn,CategoryCode,categoryName,docNo;
  AddItemForm({Key? key , this.Urn, required this.CategoryCode, required this.categoryName, required this.docNo}) : super(key: key);

  @override
  _AddItemFormState createState() => _AddItemFormState();
}

class _AddItemFormState
    extends State<AddItemForm> {
  bool isChecked = false;
  TextEditingController ItemNameController = TextEditingController();
  TextEditingController SrNoController = TextEditingController();
  TextEditingController SrIndexController = TextEditingController();
  TextEditingController SoNoController = TextEditingController();
  TextEditingController ProductionItemController = TextEditingController();
  TextEditingController ProcessController = TextEditingController();
  TextEditingController UnitController = TextEditingController();
  TextEditingController QuantityController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController StockController = TextEditingController();
  TextEditingController RemarksController = TextEditingController();
  TextEditingController  _searchController = TextEditingController();
  var ItemNameCode;
  var LocationCode;
  var coCode,urCode;
  var LocationResponseData;
var SrNo,Srindex;
  bool isLoading=false;

  String clientUrl="";

  String? SelectedStock;

  var LocationWiseStockListing;

  var IssueItemList;

  String? unitCode;


  @override
  void initState() {
    setState(() {
      // ItemNameCode=widget.FormData.itCode;
      // QuantityController.text=widget.FormData.qty.toString();
      // SoNoController.text=widget.FormData.soNo.toString();
      // LocationController.text="${widget.FormData.location} (Stock: ${widget.FormData.stock})";
      // LocationCode=widget.FormData.locationCode;
      // RemarksController.text=widget.FormData.remarks.toString();
      // SelectedStock=widget.FormData.stock.toString();
      // StockController.text=widget.FormData.stock.toString();
    });
    PreferenceManager.instance
        .getStringValue("urCode")
        .then((value) => setState(() {
      urCode = value;
      log(urCode.toString());
    })); PreferenceManager.instance
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
      // GetLocation("");
      // GetStockLocationWise();
      ItemSR();
      GetItemList("");
    }));
    // TODO: implement initState
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  ItemsPage(Urn:widget.Urn,categoryName: widget.categoryName,CategoryCode: widget.CategoryCode,docNo:widget.docNo)));
      },
      child: Scaffold(
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
                topLeft: Radius.circular(30.0),
                topRight: Radius.circular(30.0)),
            color: Colors.white,
          ),
          child: SingleChildScrollView(
            child:isLoading?  Center(
                child: Container(
                  margin: const EdgeInsets.all(50),
                  child: Lottie.asset(
                    'Assets/loading.json',
                    width: 100,
                    height: 100,
                    fit: BoxFit.fill,
                  ),
                )):Column(
              //mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 5.0),
                    child: Row(
                        children: <Widget>[
                          Expanded(
                              child: Divider(color: Colors.black,)
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Urn: ${widget.Urn}"),
                          ),
                          Expanded(
                              child: Divider(color: Colors.black,)
                          ),
                        ]
                    ),
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          style: TextStyle(color: Colors.grey),
                           controller: SrNoController,
                                         
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              hintText: '',
                              labelText: 'Sr No'),
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
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          style: TextStyle(color: Colors.grey),
                           controller: SrIndexController,
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
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ), 
                  Row(
                    children: [
                      Flexible(
                        child: TextFormField(
                          style: TextStyle(color: Colors.grey),
                            controller: ItemNameController,
                         // initialValue: "${widget.FormData.itemName}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          onTap: () {
                            setState(() {});
                            showDialog(
                              context: context,
                              barrierDismissible: true,
                              builder: (BuildContext context) {
                                return StatefulBuilder(
                                    builder: (context, setState) {
                                      return IssueItemList != null
                                          ? AlertDialog(
                                        title: const Text('Select Item'),
                                        content: Container(
                                          width: double.maxFinite,
                                          //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                          child: SingleChildScrollView(
                                            child: Column(
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              mainAxisSize: MainAxisSize.max,
                                              children: [
                                                CupertinoSearchTextField(
                                                  controller: _searchController,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      GetItemList(value);
                                                      isLoading = true;
                                                      GetItemList(value).then((data) {
                                                        setState(() {
                                                          IssueItemList = data;
                                                          log(data.data.toString());
                                                          isLoading = false;
                                                        });
                                                      }).catchError((error) {
                                                        setState(() {
                                                          isLoading = false;
                                                          // Handle error if necessary
                                                        });
                                                      });
                                                    });
                                                  },
                                                ),
                                                if (isLoading) Center(
                                                  child: Lottie.asset(
                                                    'Assets/loading.json',
                                                    width: 100,
                                                    height: 100,
                                                    fit: BoxFit.fill,
                                                  ),
                                                ) else Container(
                                                  height: MediaQuery.of(context).size.height,
                                                  child: ListView.builder(
                                                    itemCount:
                                                    IssueItemList
                                                        .data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            ItemNameController.text=IssueItemList.data[index].itemName.toString();
                                                            ItemNameCode=IssueItemList.data[index].itemCode.toString();
                                                            UnitController.text=IssueItemList.data[index].unitName.toString();
                                                            unitCode=IssueItemList.data[index].unitCode.toString();
                                                            Navigator.pop(
                                                                context);
                                                            log("Selected SoNO ${SoNoController.text}");
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${IssueItemList.data[index].itemName.toString()} (Unit: ${IssueItemList.data[index].unitName.toString()})",
                                                            style: const TextStyle(
                                                                fontWeight:
                                                                FontWeight
                                                                    .w500,
                                                                fontSize: 15,
                                                                color: Colors
                                                                    .black),
                                                          ),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
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
                              postfixIcon: Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Item Name'),
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
                      InkWell(
                        onTap: () {
                          setState(() {});
                          (ItemNameCode!=""&&ItemNameCode!=null)?
                          GetStockLocationWise().then((value) => showDialog(
                            context: context,
                            barrierDismissible: true,
                            builder: (BuildContext context) {
                              return StatefulBuilder(
                                  builder: (context, setState) {
                                    return LocationWiseStockListing != null
                                        ? AlertDialog(
                                      title: const Text('View Stock'),
                                      content: Container(
                                        width: double.maxFinite,
                                        //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.max,
                                            children: [
                                              // CupertinoSearchTextField(
                                              //   controller: _searchController,
                                              //   onChanged: (value) {
                                              //     setState(() {
                                              //       GetLocation(value);
                                              //       isLoading = true;
                                              //       GetLocation(value)
                                              //           .then((data) {
                                              //         setState(() {
                                              //           LocationResponseData =
                                              //               data;
                                              //           log(data.data.toString());
                                              //           isLoading = false;
                                              //         });
                                              //       }).catchError((error) {
                                              //         setState(() {
                                              //           isLoading = false;
                                              //           // Handle error if necessary
                                              //         });
                                              //       });
                                              //     });
                                              //   },
                                              // ),

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
                                                height: MediaQuery.of(context).size.height,
                                                child: ListView.builder(
                                                  itemCount:
                                                  LocationWiseStockListing
                                                      .data.length,
                                                  itemBuilder:
                                                      (BuildContext context,
                                                      int index) {
                                                    //final item = filteredItems[index];
                                                    return InkWell(
                                                      onTap: () {
                                                        setState(() {
                                                          SoNoController.text=LocationWiseStockListing.data[index].soNo.toString();
                                                          Navigator.pop(
                                                              context);
                                                          log("Selected SoNO ${SoNoController.text}");
                                                        });

                                                      },
                                                      child: ListTile(
                                                        title: Text(
                                                          "${LocationWiseStockListing.data[index].soNo.toString()} (Qty: ${LocationWiseStockListing.data[index].qty.toString()})",
                                                          style: const TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w500,
                                                              fontSize: 15,
                                                              color: Colors
                                                                  .black),
                                                        ),
                                                        subtitle: Text("${LocationWiseStockListing.data[index].location.toString()}") ,
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
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
                          )): Fluttertoast.showToast(
                            msg: "Select Item First",
                            textColor: Colors.white,
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.CENTER,
                          );
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0.0),
                          child: Container(
                            height: 55,
                            width: 55,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                                border: Border.all(
                                  color: kBorderColorTextField,
                                  width: 3,
                                )
                            ),
                            child: Icon(Icons.info_outline,color: kBorderColorTextField,),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          controller: SoNoController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.black),
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              postfixIcon: Icon(Icons.edit),
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              hintText: '',
                              labelText: 'SO NO'),
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

                  TextFormField(
                      controller: UnitController,
                  //  initialValue: "${widget.FormData.unit}",
                    readOnly: true,
                    style: TextStyle(color: Colors.grey),
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration(
                        focusedBorder: myfocusborder(),
                        enabledBorder: myinputborder(),

                        // prefixIcon: Icon(Icons.email_outlined),
                        hintText: '',
                        labelText: 'Unit'),
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
                  TextFormField(
                    controller: QuantityController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration(
                        focusedBorder: myfocusborder(),
                        enabledBorder: myinputborder(),
                        postfixIcon: Icon(Icons.edit),
                        //   prefixIcon: Icon(Icons.email_outlined),
                        hintText: '',
                        labelText: 'Quantity'),
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
                  TextFormField(
                    controller: LocationController,
                    readOnly: true,
                    keyboardType: TextInputType.emailAddress,
                    onTap: () {
                      setState(() {});
                      LocationCode="";
                      (ItemNameCode!=""&&ItemNameCode!=null)?
                      GetLocation("").then((value) => showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (BuildContext context) {
                          return StatefulBuilder(
                              builder: (context, setState) {
                                return LocationResponseData != null
                                    ? AlertDialog(
                                  title: const Text('Select Location'),
                                  content: Container(
                                    width: double.maxFinite,
                                    //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        CupertinoSearchTextField(
                                          controller: _searchController,
                                          onChanged: (value) {
                                            setState(() {
                                              GetLocation(value);
                                              isLoading = true;
                                              GetLocation(value)
                                                  .then((data) {
                                                setState(() {
                                                  LocationResponseData =
                                                      data;
                                                  log(data.data.toString());
                                                  isLoading = false;
                                                });
                                              }).catchError((error) {
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
                                          child: ListView.builder(
                                            itemCount:
                                            LocationResponseData
                                                .data.length,
                                            itemBuilder:
                                                (BuildContext context,
                                                int index) {
                                              //final item = filteredItems[index];
                                              return InkWell(
                                                onTap: () {
                                                  setState(() {
                                                    LocationController.text = "${LocationResponseData.data[index].selectValue.toString()} (Stock: ${LocationResponseData.data[index].stock.toString()})";
                                                    SelectedStock=LocationResponseData.data[index].stock.toString();
                                                    StockController.text=LocationResponseData.data[index].stock.toString();
                                                    LocationCode = LocationResponseData.data[index].selectValueCode;
                                                    Navigator.pop(
                                                        context);
                                                    log("Location ID $LocationCode");
                                                  });

                                                },
                                                child: ListTile(
                                                    title: Text(
                                                      "${LocationResponseData.data[index].selectValue.toString()} (Stock: ${LocationResponseData.data[index].stock.toString()})",
                                                      style: const TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .w500,
                                                          fontSize: 15,
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
                      )): Fluttertoast.showToast(
                      msg: "Select Item First",
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.CENTER,
                      );
                    },
                    decoration: inputDecoration(
                        focusedBorder: myfocusborder(),
                        enabledBorder: myinputborder(),
                        postfixIcon: Icon(Icons.arrow_drop_down,size: 30,),
                        // prefixIcon: Icon(Icons.email_outlined),
                        hintText: '',
                        labelText: 'Location'),
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
                  TextFormField(
                    controller: StockController,
                    keyboardType: TextInputType.emailAddress,
                    style: TextStyle(color: Colors.grey),
                    readOnly: true,
                    decoration: inputDecoration(
                        focusedBorder: myfocusborder(),
                        enabledBorder: myinputborder(),
                        //   prefixIcon: Icon(Icons.email_outlined),
                        hintText: '',
                        labelText: 'Stock'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill this field';
                      }
                      return null;
                    },
                  ), SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: RemarksController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: inputDecoration(
                        focusedBorder: myfocusborder(),
                        enabledBorder: myinputborder(),
                        postfixIcon: Icon(Icons.edit),
                        hintText: '',
                        labelText: 'Remarks'),
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
                      Navigator.pop(context);
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
                   //   log(widget.FormData.srNo.toString());
                      log(LocationCode);
                      log(widget.Urn);
                      if(ItemNameCode!=""&&ItemNameCode!=null){
                      if(double.parse(SelectedStock!)>0){
                        SaveData();
                      }else{
                        Fluttertoast.showToast(
                          msg: "You don't have enough stock",
                          textColor: Colors.white,
                          backgroundColor: Colors.red,
                          gravity: ToastGravity.BOTTOM,
                        );
                      }}else{
                       Fluttertoast.showToast(
                      msg: "Select Item First",
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.CENTER,
                      );
                      }
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
      ),
    );
  }
  Future<void> ItemSR() async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'Urn_No':widget.Urn,
      'CO_Code': coCode,
      'UR_CODE': urCode,
    };
    log("Api Name: ${clientUrl}/Techflow/GenerateIssueCategorySrNo $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/Techflow/GenerateIssueCategorySrNo"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/Techflow/GenerateIssueCategorySrNo $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = IsssueAdditem_SRNO_Response.fromJson(map);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (urnResData.settings.success == "1") {
        setState(() {
          SrIndexController.text= urnResData.data[0].index.toString();
          SrNoController.text=urnResData.data[0].issueSrno.toString();
        });
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
  Future<void> SaveData() async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA={
      'Co_Code': coCode,
      'User_Id':urCode,
      'Urn_No': widget.Urn,
      'Sr_no':  SrNoController.text.toString(),
      'qty':QuantityController.text.toString(),
      'location':LocationCode.toString(),
      'Remarks':RemarksController.text.toString(),
      'Stock':SelectedStock.toString(),
      'db_code':widget.CategoryCode,
      'ITCODE':ItemNameCode.toString(),
      'SoNo':SoNoController.text,
      'Unit':unitCode
    };
    log("Api Name: ${clientUrl}/TechFlow/UpdateMaterialIssueItemDetails $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/TechFlow/UpdateMaterialIssueItemDetails"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/TechFlow/UpdateMaterialIssueItemDetails $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = SaveItemIssueResponse.fromJson(map);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (urnResData.settings.success == "1") {
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>  ItemsPage(Urn:widget.Urn,CategoryCode:widget.CategoryCode,categoryName: widget.categoryName,docNo:widget.docNo)));
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
  Future<LocationSelectionResponse> GetLocation(SearchText) async {
    Map data = {
      "UR_CODE": urCode,
      "Select_Valuecode": LocationCode,
      "Searchtext": SearchText,
      "CO_CODE":coCode,
      "It_code":ItemNameCode
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}TechFlow/SelectionIssueLocation"),
      body: data,
    );
    log("${clientUrl}TechFlow/SelectionIssueLocation$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        LocationResponseData = LocationSelectionResponse.fromJson(map);
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
    Map data = {
      "user_id": urCode,
      "CO_CODE":coCode,
      "IT_Code":ItemNameCode
    };
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
        LocationWiseStockListing = LocationWiseStockListingResponse.fromJson(map);
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
  Future<IssueItemListResponse> GetItemList(search) async {
    Map data = {
      "user_id": urCode,
      "CO_CODE":coCode,
      "search_text":search.toString(),
      'Unit':""
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}Techflow/MaterialIssueAutoIssueItem"),
      body: data,
    );
    log("${clientUrl}Techflow/MaterialIssueAutoIssueItem$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        IssueItemList = IssueItemListResponse.fromJson(map);
      });
      if (IssueItemList.settings.success == "1") {
        setState(() {
          return IssueItemList;
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
    return IssueItemList;
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
}