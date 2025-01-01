import 'dart:convert';
import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../Response_Files/InwardResponse/Inward_Location_Response.dart';
import '../Response_Files/IssueResponse/ItemDelete_Response.dart';
import '../Response_Files/IssueResponse/LocationSelection_Response.dart';
import '../Response_Files/IssueResponse/LocationWiseStockListing_Response.dart';
import '../Response_Files/IssueResponse/SaveItemIssue_Response.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'package:http/http.dart'as http;
typedef void ApiCallback();

class Inward_ItemDetails_form extends StatefulWidget {
  var FormData,Urn,/*CategoryCode,categoryName,*/docNo,status;
  final ApiCallback onPopCallback;
  Inward_ItemDetails_form({Key? key, required this.FormData, required this.Urn, /*required this.CategoryCode, required this.categoryName,*/ required this.docNo,required this.onPopCallback,this.status}) : super(key: key);

  @override
  _Inward_ItemDetails_formState createState() => _Inward_ItemDetails_formState();
}

class _Inward_ItemDetails_formState
    extends State<Inward_ItemDetails_form> {
  bool isChecked = false;
  TextEditingController ItemNameController = TextEditingController();
  TextEditingController SoNoController = TextEditingController();
  TextEditingController ProductionItemController = TextEditingController();
  TextEditingController ProcessController = TextEditingController();
  TextEditingController UnitController = TextEditingController();
  TextEditingController QuantityController = TextEditingController();
  TextEditingController LocationController = TextEditingController();
  TextEditingController StockController = TextEditingController();
  TextEditingController RemarksController = TextEditingController();
  TextEditingController  _searchController = TextEditingController();
  TextEditingController  InUnitController = TextEditingController();
  TextEditingController  InQTYController = TextEditingController();
  TextEditingController  AmountController = TextEditingController();
  TextEditingController  disAmountController = TextEditingController();

  var ItemNameCode;
  var LocationCode;
  var coCode,urCode;
  var LocationResponseData;

  bool isLoading=false;

  String clientUrl="";

  String? SelectedStock;

  var LocationWiseStockListing;




  @override
  void initState() {
    setState(() {
      // ItemNameCode=widget.FormData.itCode;
      // QuantityController.text=widget.FormData.qty.toString();
      // SoNoController.text=widget.FormData.soNo.toString();
      LocationController.text="${widget.FormData.location}";
      // QuantityController.text="${widget.FormData.quantity}";
      LocationCode="${widget.FormData.locationCode}";
      ItemNameCode="${widget.FormData.itemCode}";
      InUnitController.text= widget.FormData.inUnit.toString();
      AmountController.text= widget.FormData.amount.toString();
      SoNoController.text= widget.FormData.soNo.toString();
      InQTYController.text= widget.FormData.inQty.toString();
      QuantityController.text= widget.FormData.quantity.toString();
      disAmountController.text= widget.FormData.disAmount.toString();
       //LocationCode=widget.FormData.locationCode;
      // RemarksController.text=widget.FormData.remarks.toString();
      // SelectedStock=widget.FormData.stock.toString();
      // StockController.text=widget.FormData.stock.toString();
      // log("Unit ID"+widget.FormData.unitCode.toString());
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
       GetLocation("");
      // GetStockLocationWise();
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
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                         initialValue: "${widget.FormData.index.toString()}",
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
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                         initialValue: "${widget.FormData.purInwardSrNo.toString()}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Inward SR No'),
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
                  style: TextStyle(color: Colors.black),
                  //  controller: _emailController,
                  initialValue: "${widget.FormData.itemName}",
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  /*onTap: () {
                    setState(() {});
                    showDialog(
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
                              )
                                  : const AlertDialog(
                                title: Text('No Data Available'),
                              );
                              ;
                            });
                      },
                    );
                  },*/
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      postfixIcon: Icon(CupertinoIcons.info),
                      hintText: '',
                      labelText: 'Item Name'),
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
                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                         controller: InQTYController,
                        readOnly: false,
                        onChanged: (value) {
                          setState(() {
                            QuantityController.text=value;
                            if(value!="") {
                             if(widget.FormData.discount!="") {
                                      disAmountController.text = ((double.parse(
                                                      QuantityController.text) *
                                                  widget.FormData.rate) *
                                              widget.FormData.discount /
                                              100)
                                          .toString();
                                      AmountController.text = ((double.parse(
                                                      QuantityController.text) *
                                                  widget.FormData.rate) -
                                              (double.parse(
                                                  disAmountController.text)))
                                          .toString();
                                    }else{
                               AmountController.text = ((double.parse(QuantityController.text) * widget.FormData.rate)).toString();
                             }
                                  }
                                });
                        },
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            postfixIcon: Icon(Icons.edit),
                            labelText: 'In Qty'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        controller: QuantityController,
                        readOnly: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            postfixIcon: Icon(Icons.edit),
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Quantity'),
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
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                       // controller: InQTYController,
                        readOnly: true,
                        initialValue: widget.FormData.rate.toString(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            // postfixIcon: Icon(Icons.edit),
                            labelText: 'Rate'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ), Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        controller: disAmountController,
                        readOnly: true,
                        // initialValue: widget.FormData.rate.toString(),
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            // postfixIcon: Icon(Icons.edit),
                            labelText: 'Discount Amount'),
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
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                         controller: InUnitController,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'In Unit'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                        initialValue: "${widget.FormData.unit.toString()}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Unit'),
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
                ),Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                        initialValue: "${widget.FormData.discount.toString()}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Discount'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        controller: AmountController,
                        // initialValue: "${widget.FormData.amount.toString()}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Amount'),
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
                      flex: 1,
                      child: TextFormField(
                       controller: SoNoController,
                        // initialValue: "${widget.FormData.soNo}",
                        style: TextStyle(color: Colors.black),
                        readOnly: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            // postfixIcon: Icon(Icons.edit),
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
                    SizedBox(
                      width: 5,
                    ),
                    Flexible(
                      flex: 1,
                      child: TextFormField(
                        //  controller: _emailController,
                         initialValue: "${widget.FormData.qcItem}",
                        style: TextStyle(color: Colors.grey),
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),

                            //   prefixIcon: Icon(Icons.email_outlined),
                            hintText: '',
                            labelText: 'Qc Item'),
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
                  controller: LocationController,
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
                                                  LocationController.text = "${LocationResponseData.data[index].selectValue.toString()}";
                                                  LocationCode = LocationResponseData.data[index].selectValueCode;
                                                  Navigator.pop(
                                                      context);
                                                  log("Location ID $LocationCode");
                                                });

                                              },
                                              child: ListTile(
                                                  title: Text(
                                                    "${LocationResponseData.data[index].selectValue.toString()}",
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
                 // controller: StockController,
                  initialValue: "${widget.FormData.description.toString()}",
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.grey),
                  readOnly: true,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Description'),
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

                Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                        initialValue: "${widget.FormData.pONo.toString()}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Po No'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(width: 5,),
                    Expanded(
                      flex: 1,
                      child: TextFormField(
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                        initialValue: "${widget.FormData.pODate.toString()}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Po Date'),
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
                    log(widget.status.toString());
                    if(widget.status!="Approved"&&widget.status!="Forwarded"){
                    SaveData();
                    }else{
                      popCurrentPage();
                    }
                    // log(widget.FormData.srNo.toString());
                    // log(LocationCode);
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
    var BODYDATA={
      'Co_Code': coCode,
      'urn_no': widget.Urn,
      'In_Qty': InQTYController.text.toString(),
      'Quantity':QuantityController.text.toString(),
      'In_Unit':widget.FormData.inUnit.toString(),
      'Rate':widget.FormData.rate.toString(),
      'Discount':widget.FormData.discount.toString(),
      'Dis_Amount':disAmountController.text.toString(),
      'Amount':AmountController.text.toString(),
      'location':LocationCode.toString(),
      'Description':widget.FormData.description.toString(),
      // 'Remarks':widget.FormData.remarks.toString(),
      'Lot_No':widget.FormData.lotNo.toString(),
      'Sr_no':widget.FormData.purInwardSrNo.toString(),
      'Item_Code':ItemNameCode.toString(),
      'SO_No':SoNoController.text,
      'unit':widget.FormData.unitCode.toString()
    };
    log("Api Name: ${clientUrl}purchase/UpdatePurchaseInwardItemDetails $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}purchase/UpdatePurchaseInwardItemDetails"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}purchase/UpdatePurchaseInwardItemDetails $BODYDATA");
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
  Future<LocationSelectionResponse> GetLocation(SearchText) async {
    Map data = {
      "UR_CODE": urCode,
      "Select_Valuecode": "",
      "item_filertext": SearchText,
      "CO_CODE":coCode,
      "itcode":widget.FormData.itemCode.toString()
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}purchase/SelectionInwardLocation"),
      body: data,
    );
    log("${clientUrl}purchase/SelectionInwardLocation$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        LocationResponseData = InwardLocationResponse.fromJson(map);
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