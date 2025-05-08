import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart' as path;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

import '../Response_Files/InwardResponse/Inward_Location_Response.dart';
import '../Response_Files/IssueResponse/ItemDelete_Response.dart';
import '../Response_Files/IssueResponse/LocationSelection_Response.dart';
import '../Response_Files/IssueResponse/LocationWiseStockListing_Response.dart';
import '../Response_Files/IssueResponse/SaveItemIssue_Response.dart';
import '../Response_Files/PurchaseQC_Response/AttachmentListingDataResponse.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'package:http/http.dart'as http;
import '../Utils/ImageFiles.dart';
import 'package:image_picker/image_picker.dart';

import 'Material_Receipt_ItemList.dart';

class Material_Recepit_ItemDetails_Form extends StatefulWidget {
  var FormData,Urn,CategoryCode,categoryName,docNo,status,barCodeRes;
  Material_Recepit_ItemDetails_Form({Key? key, required this.FormData, required this.Urn, required this.CategoryCode, required this.categoryName, required this.docNo,this.status, this.barCodeRes}) : super(key: key);

  @override
  _Material_Recepit_ItemDetails_FormState createState() => _Material_Recepit_ItemDetails_FormState();
}

class _Material_Recepit_ItemDetails_FormState
    extends State<Material_Recepit_ItemDetails_Form> {
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
  TextEditingController  _searchController1 = TextEditingController();
  TextEditingController  FebricationContractorNameController = TextEditingController();
  TextEditingController  WeldingContractorNameController = TextEditingController();
  TextEditingController PaintContractorNameController = TextEditingController();
  TextEditingController febricationRateController = TextEditingController();
  TextEditingController RateController = TextEditingController();
  TextEditingController processTimeController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController weldingRateController = TextEditingController();
  TextEditingController AssemblyweightController = TextEditingController();
  //TextEditingController FabricationrateController = TextEditingController();
  TextEditingController DrgWeightController = TextEditingController();
  TextEditingController SizeController = TextEditingController();
  TextEditingController StructureController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  var FebricationContractorCode;
  var SizeCode;
  var StructureCode;
  var WeldingContractorCode="";
  var PaintContractorCode;
  var ItemNameCode;
  var processCode;
  var LocationCode;
  var coCode,urCode;
  var LocationResponseData;

  bool isLoading=false;
  var imagePicker;
  final picker = ImagePicker();
  List<PickedFile?> pickedFile = [];
  List<ImageFiles> imageFiles = [];
  String TCRequiredValue = "";
  List<String> descriptions = [];
  var fileName;

  String clientUrl="";
  var fileextention = "";
  var filenameOriginal;

  String? SelectedStock;

  var LocationWiseStockListing;

  var SizeData;
  var locationData;
  var StructureData;

  var ContractorNameData;

  var todayDate;


  @override
  void initState() {
    log(widget.FormData.process.toString());
    setState(() {
      ItemNameCode=widget.FormData.itemCode;
      processCode=widget.FormData.processCode;
      QuantityController.text=widget.FormData.quantity.toString();
      SoNoController.text=widget.FormData.soNo.toString();
      LocationController.text="${widget.FormData.location}";
      LocationCode=widget.FormData.locationCode;
      RemarksController.text=widget.FormData.remarks.toString();
      SelectedStock=widget.FormData.stock.toString();
      StockController.text=widget.FormData.stock.toString();
      febricationRateController.text=widget.FormData.fabricationRateKg.toString();
      FebricationContractorCode=widget.FormData.Fabrication_Contractor_Code.toString();
      FebricationContractorNameController.text=widget.FormData.fabricationContractor.toString();
      WeldingContractorNameController.text=widget.FormData.weldingContractor.toString();
      weldingRateController.text=widget.FormData.weldingRate.toString();
      processTimeController.text=widget.FormData.processTimeHrs.toString();
      RateController.text=widget.FormData.rate.toString();
      AssemblyweightController.text=widget.FormData.assemblyWeight.toString();
      //FabricationrateController.text=widget.FormData.fabricationRateKg.toString();
      DrgWeightController.text=widget.FormData.drgWeight.toString();
      SizeController.text=widget.FormData.size.toString();
      StructureController.text=widget.FormData.structure.toString();
      locationController.text=widget.FormData.location.toString();


      log("Unit ID${widget.FormData.unitCode}");
      _calculateAmount();

      // RateController.addListener(_calculateAmount);
      // processTimeController.addListener(_calculateAmount);


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
      GetStockLocationWise();
      GetContractorName("");
      GetSizeList("");
      GetLocationList("");

      AttachmentList();
    }));
    // TODO: implement initState
    super.initState();
  }

  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    RateController.dispose();
    processTimeController.dispose();
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await Navigator.push(context,
            MaterialPageRoute(builder: (context) =>  Material_Receipt_ItemList(Urn:widget.Urn,categoryName: widget.categoryName,CategoryCode: widget.CategoryCode,docNo:widget.docNo, status: widget.status,)));
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

                  TextFormField(
                    style: TextStyle(color: Colors.grey),
                    //  controller: _emailController,
                    initialValue: "${widget.FormData.index.toString()}",
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
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: locationController,
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
                                return locationData != null
                                    ? AlertDialog(
                                  title: const Text('Select location'),
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
                                                //GetSizeList(value);
                                                //isLoading = true;
                                                GetLocationList(value).then((data) {
                                                  setState(() {
                                                    locationData = data;
                                                    //log(data.data.toString());
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
                                              locationData
                                              ['data'].length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                  int index) {
                                                //final item = filteredItems[index];
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      locationController.text=locationData['data'][index]['Select_Value'].toString();
                                                      //SizeCode=SizeData['Data'][index]['Select_Value_Code'].toString();
                                                      LocationCode=locationData['data'][index]['Select_Value_Code'].toString();
                                                      //GetStructureList("");
                                                      Navigator.pop(
                                                          context);
                                                    });

                                                  },
                                                  child: ListTile(
                                                    title: Text(
                                                      "${locationData['data'][index]['Select_Value'].toString()}",
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
                        postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                        hintText: '',
                        labelText: 'Location'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill this field';
                      }
                      return null;
                    },
                  ),
                  // TextFormField(
                  //   controller: LocationController,
                  //   readOnly: true,
                  //   keyboardType: TextInputType.emailAddress,
                  //   onTap: () {
                  //     setState(() {});
                  //     showDialog(
                  //       context: context,
                  //       barrierDismissible: false,
                  //       builder: (BuildContext context) {
                  //         return StatefulBuilder(
                  //             builder: (context, setState) {
                  //               return LocationResponseData != null
                  //                   ? AlertDialog(
                  //                 title: const Text('Select Location'),
                  //                 content: Container(
                  //                   width: double.maxFinite,
                  //                   //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                  //                   child: Column(
                  //                     crossAxisAlignment:
                  //                     CrossAxisAlignment.start,
                  //                     mainAxisSize: MainAxisSize.min,
                  //                     children: [
                  //                       CupertinoSearchTextField(
                  //                         controller: _searchController,
                  //                         onChanged: (value) {
                  //                           setState(() {
                  //                             GetLocation(value);
                  //                             isLoading = true;
                  //                             GetLocation(value)
                  //                                 .then((data) {
                  //                               setState(() {
                  //                                 LocationResponseData =
                  //                                     data;
                  //                                 log(data.data.toString());
                  //                                 isLoading = false;
                  //                               });
                  //                             }).catchError((error) {
                  //                               setState(() {
                  //                                 isLoading = false;
                  //                                 // Handle error if necessary
                  //                               });
                  //                             });
                  //                           });
                  //                         },
                  //                       ),
                  //                       const SizedBox(height: 10),
                  //                       isLoading
                  //                           ? Center(
                  //                         child: Lottie.asset(
                  //                           'Assets/loading.json',
                  //                           width: 100,
                  //                           height: 100,
                  //                           fit: BoxFit.fill,
                  //                         ),
                  //                       )
                  //                           : Container(
                  //                         height: 200,
                  //                         child: ListView.builder(
                  //                           itemCount:
                  //                           LocationResponseData
                  //                               .data.length,
                  //                           itemBuilder:
                  //                               (BuildContext context,
                  //                               int index) {
                  //                             //final item = filteredItems[index];
                  //                             return InkWell(
                  //                               onTap: () {
                  //                                 setState(() {
                  //                                   LocationController.text = "${LocationResponseData.data[index].selectValue.toString()} (Stock: ${LocationResponseData.data[index].stock.toString()})";
                  //                                   SelectedStock=LocationResponseData.data[index].stock.toString();
                  //                                   StockController.text=LocationResponseData.data[index].stock.toString();
                  //                                   LocationCode = LocationResponseData.data[index].selectValueCode;
                  //                                   Navigator.pop(
                  //                                       context);
                  //                                   log("Location ID $LocationCode");
                  //                                 });
                  //
                  //                               },
                  //                               child: ListTile(
                  //                                   title: Text(
                  //                                     "${LocationResponseData.data[index].selectValue.toString()} (Stock: ${LocationResponseData.data[index].stock.toString()})",
                  //                                     style: const TextStyle(
                  //                                         fontWeight:
                  //                                         FontWeight
                  //                                             .w500,
                  //                                         fontSize: 15,
                  //                                         color: Colors
                  //                                             .black),
                  //                                   )),
                  //                             );
                  //                           },
                  //                         ),
                  //                       ),
                  //                     ],
                  //                   ),
                  //                 ),
                  //                 // actions: <Widget>[
                  //                 //   TextButton(
                  //                 //     onPressed: () {
                  //                 //       Navigator.of(context).pop();
                  //                 //     },
                  //                 //     child: Text('Cancel'),
                  //                 //   ),
                  //                 //   TextButton(
                  //                 //     onPressed: () {
                  //                 //       // Do something with the selected items
                  //                 //       print('Selected Items: $selectedItem');
                  //                 //       // Close the dialog
                  //                 //       Navigator.of(context).pop();
                  //                 //     },
                  //                 //     child: Text('Done'),
                  //                 //   ),
                  //                 // ],
                  //               )
                  //                   : const AlertDialog(
                  //                 title: Text('No Data Available'),
                  //               );
                  //               ;
                  //             });
                  //       },
                  //     );
                  //   },
                  //   decoration: inputDecoration(
                  //       focusedBorder: myfocusborder(),
                  //       enabledBorder: myinputborder(),
                  //       postfixIcon: Icon(Icons.arrow_drop_down,size: 30,),
                  //       // prefixIcon: Icon(Icons.email_outlined),
                  //       hintText: '',
                  //       labelText: 'Location'),
                  //   validator: (value) {
                  //     if (value == null || value.isEmpty) {
                  //       return 'Please fill this field';
                  //     }
                  //     return null;
                  //   },
                  // ),
                  SizedBox(
                    height: 10,
                  ),
                  if(widget.FormData.process=="Cutting")
                  Column(
                    children: [
                      TextFormField(
                        controller: SoNoController,
                        // initialValue: "${widget.FormData.soNo}",
                        style: TextStyle(color: Colors.grey),
                        readOnly: true,
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
                      SizedBox(
                        height: 10,
                      ),
                      TextFormField(
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                        initialValue: "${widget.FormData.itemName}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,

                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            // postfixIcon: Icon(CupertinoIcons.info),
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

                      TextFormField(
                        style: TextStyle(color: Colors.green),
                        //  controller: _emailController,
                        initialValue: "${widget.FormData.process}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            // postfixIcon: Icon(CupertinoIcons.info),
                            hintText: '',
                            labelText: 'Process'),
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
                        style: TextStyle(color: Colors.grey),
                        //  controller: _emailController,
                        initialValue: "${widget.FormData.unit}",
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            // postfixIcon: Icon(CupertinoIcons.info),
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
                        style: TextStyle(color: Colors.grey),
                        controller: QuantityController,
                        //initialValue: "${widget.FormData.quantity}",
                        readOnly: false,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            // postfixIcon: Icon(CupertinoIcons.info),
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


                    ],
                  ),
                  if(widget.FormData.process=="Structure Cutting")
                    Column(
                      children: [
                        TextFormField(
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.itemName}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,

                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                        TextFormField(
                          style: TextStyle(color: Colors.green),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.process}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
                              hintText: '',
                              labelText: 'Process'),
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
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.unit}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: TextStyle(color: Colors.grey),
                           controller: QuantityController,
                          //initialValue: "${widget.FormData.quantity}",
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          controller: SoNoController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.grey),
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                           //   postfixIcon: Icon(Icons.edit),
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: FebricationContractorNameController,
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
                                      return ContractorNameData != null
                                          ? AlertDialog(
                                        title: const Text('Select Fabrication Contractor'),
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
                                                      GetContractorName(value);
                                                      isLoading = true;
                                                      GetContractorName(value).then((data) {
                                                        setState(() {
                                                          ContractorNameData = data;
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
                                                    ContractorNameData
                                                        .data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            FebricationContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                                                            FebricationContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${ContractorNameData.data[index].selectValue.toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Fabrication Contractor'),
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
                          controller: RateController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.black),
                          // readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              postfixIcon: Icon(Icons.edit),
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              hintText: '',
                              labelText: 'Rate'),
                          onChanged: (value) {
                            _calculateAmount(); // Call _calculateAmount when value changes
                          },
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
                          controller: processTimeController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.black),
                          // readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              postfixIcon: Icon(Icons.edit),
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              hintText: '',
                              labelText: 'Process Time(Hrs)'),
                          onChanged: (value) {
                            _calculateAmount(); // Call _calculateAmount when value changes
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 10),
                        TextFormField(
                          controller: amountController,
                          readOnly: true, // Make this field read-only
                          style: TextStyle(color: Colors.black),
                          decoration: inputDecoration(
                            postfixIcon: Icon(Icons.calculate),
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Amount',
                          ),
                        ),
                      ],
                    ),
                  if(widget.FormData.process=="Tagging")
                    Column(
                      children: [
                        TextFormField(
                          controller: SoNoController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.grey),
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                            //   postfixIcon: Icon(Icons.edit),
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.itemName}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,

                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                        TextFormField(
                          style: TextStyle(color: Colors.green),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.process}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
                              hintText: '',
                              labelText: 'Process'),
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
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.unit}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: TextStyle(color: Colors.grey),
                          controller: QuantityController,
                          //initialValue: "${widget.FormData.quantity}",
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: const TextStyle(color: Colors.black),
                          controller: FebricationContractorNameController,
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
                                      return ContractorNameData != null
                                          ? AlertDialog(
                                        title: const Text('Select Fabrication Contractor'),
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
                                                      GetContractorName(value);
                                                      isLoading = true;
                                                      GetContractorName(value).then((data) {
                                                        setState(() {
                                                          ContractorNameData = data;
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
                                                    ContractorNameData
                                                        .data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            FebricationContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                                                            FebricationContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${ContractorNameData.data[index].selectValue.toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Fabrication Contractor'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                        ),

                      ],
                    ),
                  if(widget.FormData.process=="Welding")
                    Column(
                      children: [
                        TextFormField(
                          controller: SoNoController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.grey),
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                            //   postfixIcon: Icon(Icons.edit),
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.itemName}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,

                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                        TextFormField(
                          style: TextStyle(color: Colors.green),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.process}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
                              hintText: '',
                              labelText: 'Process'),
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
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.unit}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: TextStyle(color: Colors.grey),
                          controller: QuantityController,
                          //initialValue: "${widget.FormData.quantity}",
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: const TextStyle(color: Colors.black),
                          controller: FebricationContractorNameController,
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
                                      return ContractorNameData != null
                                          ? AlertDialog(
                                        title: const Text('Select Fabrication Contractor'),
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
                                                      GetContractorName(value);
                                                      isLoading = true;
                                                      GetContractorName(value).then((data) {
                                                        setState(() {
                                                          ContractorNameData = data;
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
                                                    ContractorNameData
                                                        .data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            FebricationContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                                                            FebricationContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${ContractorNameData.data[index].selectValue.toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Fabrication Contractor'),
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
                          style: const TextStyle(color: Colors.black),
                          controller: WeldingContractorNameController,
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
                                      return ContractorNameData != null
                                          ? AlertDialog(
                                        title: const Text('Select Welding Contractor'),
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
                                                      GetContractorName(value);
                                                      isLoading = true;
                                                      GetContractorName(value).then((data) {
                                                        setState(() {
                                                          ContractorNameData = data;
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
                                                    ContractorNameData
                                                        .data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            WeldingContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                                                            WeldingContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                                                            Navigator.pop(context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${ContractorNameData.data[index].selectValue.toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Welding Contractor'),
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
                          controller: weldingRateController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.black),
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              postfixIcon: Icon(Icons.edit),
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              hintText: '',
                              labelText: 'Welding Rate'),
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
                          style: const TextStyle(color: Colors.black),
                          controller: SizeController,
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
                                      return SizeData != null
                                          ? AlertDialog(
                                        title: const Text('Select Size'),
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
                                                  controller: _searchController1,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      GetSizeList(value);
                                                      //isLoading = true;
                                                      GetSizeList(value).then((data) {
                                                        setState(() {
                                                          SizeData = data;
                                                          //log(data.data.toString());
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
                                                    SizeData
                                                        ['Data'].length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            SizeController.text=SizeData['Data'][index]['Select_Value'].toString();
                                                            SizeCode=SizeData['Data'][index]['Select_Value_Code'].toString();
                                                            _searchController.clear();
                                                            GetStructureList("");
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${SizeData['Data'][index]['Select_Value'].toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Size'),
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
                          style: const TextStyle(color: Colors.black),
                          controller: StructureController,
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
                                      return StructureData != null
                                          ? AlertDialog(
                                        title: const Text('Select Size'),
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
                                                      GetStructureList(value);
                                                      //isLoading = true;
                                                      GetStructureList(value).then((data) {
                                                        setState(() {
                                                          StructureData = data;
                                                          //log(data.data.toString());
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
                                                    StructureData
                                                    ['Data'].length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            StructureController.text=StructureData['Data'][index]['Select_Value'].toString();
                                                            StructureCode=StructureData['Data'][index]['Select_Value_Code'].toString();
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${StructureData['Data'][index]['Select_Value'].toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Structure'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                        ),

                      ],
                    ),
                  if(widget.FormData.process=="Finishing")
                    Column(
                      children: [
                        TextFormField(
                          controller: SoNoController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.grey),
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                            //   postfixIcon: Icon(Icons.edit),
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.itemName}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,

                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                        TextFormField(
                          style: TextStyle(color: Colors.green),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.process}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
                              hintText: '',
                              labelText: 'Process'),
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
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.unit}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: TextStyle(color: Colors.grey),
                          controller: QuantityController,
                          //initialValue: "${widget.FormData.quantity}",
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: const TextStyle(color: Colors.black),
                          controller: FebricationContractorNameController,
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
                                      return ContractorNameData != null
                                          ? AlertDialog(
                                        title: const Text('Select Fabrication Contractor'),
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
                                                      GetContractorName(value);
                                                      isLoading = true;
                                                      GetContractorName(value).then((data) {
                                                        setState(() {
                                                          ContractorNameData = data;
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
                                                    ContractorNameData
                                                        .data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            FebricationContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                                                            FebricationContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${ContractorNameData.data[index].selectValue.toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Fabrication Contractor'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                        ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // TextFormField(
                        //   style: const TextStyle(color: Colors.black),
                        //   controller: WeldingContractorNameController,
                        //   // initialValue: "${widget.FormData.itemName}",
                        //   readOnly: true,
                        //   keyboardType: TextInputType.emailAddress,
                        //   onTap: () {
                        //     setState(() {});
                        //     showDialog(
                        //       context: context,
                        //       barrierDismissible: true,
                        //       builder: (BuildContext context) {
                        //         return StatefulBuilder(
                        //             builder: (context, setState) {
                        //               return ContractorNameData != null
                        //                   ? AlertDialog(
                        //                 title: const Text('Select Welding Contractor'),
                        //                 content: Container(
                        //                   width: double.maxFinite,
                        //                   //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                        //                   child: SingleChildScrollView(
                        //                     child: Column(
                        //                       crossAxisAlignment:
                        //                       CrossAxisAlignment.start,
                        //                       mainAxisSize: MainAxisSize.max,
                        //                       children: [
                        //                         CupertinoSearchTextField(
                        //                           controller: _searchController,
                        //                           onChanged: (value) {
                        //                             setState(() {
                        //                               GetContractorName(value);
                        //                               isLoading = true;
                        //                               GetContractorName(value).then((data) {
                        //                                 setState(() {
                        //                                   ContractorNameData = data;
                        //                                   log(data.data.toString());
                        //                                   isLoading = false;
                        //                                 });
                        //                               }).catchError((error) {
                        //                                 setState(() {
                        //                                   isLoading = false;
                        //                                   // Handle error if necessary
                        //                                 });
                        //                               });
                        //                             });
                        //                           },
                        //                         ),
                        //                         if (isLoading) Center(
                        //                           child: Lottie.asset(
                        //                             'Assets/loading.json',
                        //                             width: 100,
                        //                             height: 100,
                        //                             fit: BoxFit.fill,
                        //                           ),
                        //                         ) else Container(
                        //                           height: MediaQuery.of(context).size.height,
                        //                           child: ListView.builder(
                        //                             itemCount:
                        //                             ContractorNameData
                        //                                 .data.length,
                        //                             itemBuilder:
                        //                                 (BuildContext context,
                        //                                 int index) {
                        //                               //final item = filteredItems[index];
                        //                               return InkWell(
                        //                                 onTap: () {
                        //                                   setState(() {
                        //                                     WeldingContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                        //                                     WeldingContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                        //                                     Navigator.pop(context);
                        //                                   });
                        //
                        //                                 },
                        //                                 child: ListTile(
                        //                                   title: Text(
                        //                                     "${ContractorNameData.data[index].selectValue.toString()}",
                        //                                     style: const TextStyle(
                        //                                         fontWeight:
                        //                                         FontWeight
                        //                                             .w500,
                        //                                         fontSize: 15,
                        //                                         color: Colors
                        //                                             .black),
                        //                                   ),
                        //                                 ),
                        //                               );
                        //                             },
                        //                           ),
                        //                         ),
                        //                       ],
                        //                     ),
                        //                   ),
                        //                 ),
                        //                 // actions: <Widget>[
                        //                 //   TextButton(
                        //                 //     onPressed: () {
                        //                 //       Navigator.of(context).pop();
                        //                 //     },
                        //                 //     child: Text('Cancel'),
                        //                 //   ),
                        //                 //   TextButton(
                        //                 //     onPressed: () {
                        //                 //       // Do something with the selected items
                        //                 //       print('Selected Items: $selectedItem');
                        //                 //       // Close the dialog
                        //                 //       Navigator.of(context).pop();
                        //                 //     },
                        //                 //     child: Text('Done'),
                        //                 //   ),
                        //                 // ],
                        //               )
                        //                   : const AlertDialog(
                        //                 title: Text('No Data Available'),
                        //               );
                        //               ;
                        //             });
                        //       },
                        //     );
                        //   },
                        //   decoration: inputDecoration(
                        //       focusedBorder: myfocusborder(),
                        //       enabledBorder: myinputborder(),
                        //       postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                        //       hintText: '',
                        //       labelText: 'Welding Contractor'),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please fill this field';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        // SizedBox(
                        //   height: 10,
                        // ),
                        // TextFormField(
                        //   controller: weldingRateController,
                        //   // initialValue: "${widget.FormData.soNo}",
                        //   style: TextStyle(color: Colors.black),
                        //   readOnly: false,
                        //   keyboardType: TextInputType.emailAddress,
                        //   decoration: inputDecoration(
                        //       postfixIcon: Icon(Icons.edit),
                        //       focusedBorder: myfocusborder(),
                        //       enabledBorder: myinputborder(),
                        //       hintText: '',
                        //       labelText: 'Welding Rate'),
                        //   validator: (value) {
                        //     if (value == null || value.isEmpty) {
                        //       return 'Please fill this field';
                        //     }
                        //     return null;
                        //   },
                        // ),
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          controller: febricationRateController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.black),
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              postfixIcon: Icon(Icons.edit),
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              hintText: '',
                              labelText: 'Fabrication rate/kg'),
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
                          style: TextStyle(color: Colors.grey),
                          controller: DrgWeightController,
                          //initialValue: "${widget.FormData.drgWeight}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
                              hintText: '',
                              labelText: 'Drg Weight'),
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
                          controller: AssemblyweightController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.black),
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              postfixIcon: Icon(Icons.edit),
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              hintText: '',
                              labelText: 'Assembly weight'),
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
                          style: const TextStyle(color: Colors.black),
                          controller: SizeController,
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
                                      return SizeData != null
                                          ? AlertDialog(
                                        title: const Text('Select Size'),
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
                                                      GetSizeList(value);
                                                      //isLoading = true;
                                                      GetSizeList(value).then((data) {
                                                        setState(() {
                                                          SizeData = data;
                                                          //log(data.data.toString());
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
                                                    SizeData
                                                    ['Data'].length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            SizeController.text=SizeData['Data'][index]['Select_Value'].toString();
                                                            SizeCode=SizeData['Data'][index]['Select_Value_Code'].toString();
                                                            GetStructureList("");
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${SizeData['Data'][index]['Select_Value'].toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Size'),
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
                          style: const TextStyle(color: Colors.black),
                          controller: StructureController,
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
                                      return StructureData != null
                                          ? AlertDialog(
                                        title: const Text('Select Size'),
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
                                                      GetStructureList(value);
                                                      //isLoading = true;
                                                      GetStructureList(value).then((data) {
                                                        setState(() {
                                                          StructureData = data;
                                                          //log(data.data.toString());
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
                                                    StructureData
                                                    ['Data'].length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            StructureController.text=StructureData['Data'][index]['Select_Value'].toString();
                                                            StructureCode=StructureData['Data'][index]['Select_Value_Code'].toString();
                                                            GetContractorRate();
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${StructureData['Data'][index]['Select_Value'].toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Structure'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                        ),




                      ],
                    ),
                  if(widget.FormData.process=="Paint")
                    Column(
                      children: [
                        TextFormField(
                          controller: SoNoController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.grey),
                          readOnly: true,
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.itemName}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,

                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                        TextFormField(
                          style: TextStyle(color: Colors.green),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.process}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
                              hintText: '',
                              labelText: 'Process'),
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
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.unit}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: TextStyle(color: Colors.grey),
                          controller: QuantityController,
                          //initialValue: "${widget.FormData.quantity}",
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          controller: AssemblyweightController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.black),
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              postfixIcon: Icon(Icons.edit),
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              hintText: '',
                              labelText: 'Assembly weight'),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                        ),


                      ],
                    ),
                  if(widget.FormData.process=="Assembly")
                    Column(
                      children: [
                        TextFormField(
                          controller: SoNoController,
                          // initialValue: "${widget.FormData.soNo}",
                          style: TextStyle(color: Colors.grey),
                          readOnly: true,
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
                        SizedBox(
                          height: 10,
                        ),
                        TextFormField(
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.itemName}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,

                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                        TextFormField(
                          style: TextStyle(color: Colors.green),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.process}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
                              hintText: '',
                              labelText: 'Process'),
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
                          style: TextStyle(color: Colors.grey),
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.unit}",
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                          style: TextStyle(color: Colors.grey),
                          controller: QuantityController,
                          //initialValue: "${widget.FormData.quantity}",
                          readOnly: false,
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),
                              // postfixIcon: Icon(CupertinoIcons.info),
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
                                                          LocationController.text = "${LocationResponseData.data[index].selectValue.toString()} (Stock: ${LocationResponseData.data[index].stock.toString()})";
                                                          SelectedStock=LocationResponseData.data[index].stock.toString();
                                                          StockController.text=LocationResponseData.data[index].stock.toString();
                                                          LocationCode = LocationResponseData.data[index].selectValueCode;
                                                          _searchController.clear();
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
                      ],
                    ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                          value: TCRequiredValue!.isNotEmpty
                              ? TCRequiredValue
                              : null, // Ensure default value is set
                          onChanged: (String? newValue) {
                            setState(() {
                              TCRequiredValue =
                              newValue!; // Update the state with selected value
                            });
                          },
                          items: <String>['Yes', 'No']
                              .map<DropdownMenuItem<String>>(
                                  (String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                          decoration: InputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            hintText: '',
                            labelText: 'Attachment',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please fill this field';
                            }
                            return null;
                          },
                        ),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      descriptions.isNotEmpty
                          ? Container(
                        height: 65,
                        width: 55,
                        decoration: BoxDecoration(
                            borderRadius:
                            const BorderRadius.all(
                                Radius.circular(20)),
                            border: Border.all(
                              color: kBorderColorTextField,
                              width: 3,
                            )),
                        child: IconButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder:
                                    (BuildContext context) {
                                  return StatefulBuilder(
                                      builder:
                                          (context, setState) {
                                        return descriptions != null
                                            ? AlertDialog(
                                          title: const Text(
                                              'Uploaded Attachments'),
                                          content: Container(
                                            width: double
                                                .maxFinite,
                                            //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                            child:
                                            SingleChildScrollView(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment
                                                    .start,
                                                mainAxisSize:
                                                MainAxisSize
                                                    .max,
                                                children: [
                                                  if (isLoading)
                                                    Center(
                                                      child: Lottie
                                                          .asset(
                                                        'Assets/loading.json',
                                                        width:
                                                        100,
                                                        height:
                                                        100,
                                                        fit: BoxFit
                                                            .fill,
                                                      ),
                                                    )
                                                  else
                                                    Container(
                                                      height: MediaQuery.of(context)
                                                          .size
                                                          .height,
                                                      child: ListView
                                                          .builder(
                                                        itemCount:
                                                        descriptions.length,
                                                        itemBuilder:
                                                            (BuildContext context, int index) {
                                                          //final item = filteredItems[index];
                                                          return InkWell(
                                                            child: Card(
                                                              color: Colors.greenAccent,
                                                              child: ListTile(
                                                                trailing: const Icon(
                                                                  CupertinoIcons.check_mark_circled,
                                                                  color: Colors.white,
                                                                ),
                                                                title: Text(
                                                                  "${descriptions[index]}",
                                                                  style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15, color: Colors.white),
                                                                ),
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
                                          title: Text(
                                              'No Data Available'),
                                        );
                                        ;
                                      });
                                },
                              );
                            },
                            icon:
                            const Icon(CupertinoIcons.eye)),
                      )
                          : const SizedBox.shrink(),
                      const SizedBox(
                        width: 2,
                      ),
                      TCRequiredValue == "Yes"
                          ? InkWell(
                        onTap: () {
                          permissionServiceCall(
                              context, "FromCamera");
                        },
                        child: Container(
                            height: 65,
                            width: 55,
                            decoration: BoxDecoration(
                                borderRadius:
                                const BorderRadius.all(
                                    Radius.circular(20)),
                                border: Border.all(
                                  color: kBorderColorTextField,
                                  width: 3,
                                )),
                            child: const Icon(Icons
                                .image) /*Image.asset(
                            "Assets/Image.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.fill,
                          )*/
                        ),
                      )
                          : const SizedBox.shrink(),
                    ],
                  ),
                  if (imageFiles.length > 0)
                    SizedBox(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: imageFiles.length,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (_, index) {
                          return InkWell(
                            child: Card(
                              clipBehavior:
                              Clip.antiAliasWithSaveLayer,
                              // margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(10),
                                      bottomRight:
                                      Radius.circular(10))),
                              elevation: 5,
                              child: imageFiles[index] != null
                                  ? Column(children: [
                                Image.file(
                                    File(imageFiles[index]
                                        .path
                                        .toString()),
                                    fit: BoxFit.fitWidth,
                                    width:
                                    MediaQuery.of(context)
                                        .size
                                        .width,
                                    height: 150),
                                const SizedBox(
                                  height: 10,
                                ),
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  mainAxisSize:
                                  MainAxisSize.max,
                                  mainAxisAlignment:
                                  MainAxisAlignment.start,
                                  children: [
                                    Flexible(
                                      child: Container(
                                        width: MediaQuery.of(
                                            context)
                                            .size
                                            .width,
                                        padding:
                                        const EdgeInsets
                                            .all(10.0),
                                        child: Text(
                                          imageFiles[index]
                                              .name
                                              .toString()
                                              .length >
                                              30
                                              ? '${imageFiles[index].name.toString().substring(0, 25)}...'
                                              : imageFiles[
                                          index]
                                              .name
                                              .toString(),
                                          style: const TextStyle(
                                              fontFamily:
                                              "poppins_regular",
                                              fontSize: 12,
                                              color: Color(
                                                  0xff555555),
                                              fontWeight:
                                              FontWeight
                                                  .bold),
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          removeListItem(index);
                                        });
                                      },
                                      child: const Padding(
                                        padding:
                                        EdgeInsets.only(
                                            right: 8.0),
                                        child: Icon(
                                            CupertinoIcons
                                                .delete),
                                      ),
                                    )
                                  ],
                                )
                              ])
                                  : null,
                            ),
                          );
                        },
                      ),
                    ),
             /*     Row(
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
                      SizedBox(
                        width: 5,
                      ),
                      Flexible(
                        flex: 1,
                        child: TextFormField(
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.stock}",
                          style: TextStyle(color: Colors.grey),
                          readOnly: true,
                          keyboardType: TextInputType.emailAddress,
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
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.process}",
                          readOnly: true,
                          style: TextStyle(color: Colors.grey),
                          keyboardType: TextInputType.emailAddress,
                          decoration: inputDecoration(
                              focusedBorder: myfocusborder(),
                              enabledBorder: myinputborder(),

                              //   prefixIcon: Icon(Icons.email_outlined),
                              hintText: '',
                              labelText: 'Process'),
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
                          //  controller: _emailController,
                          initialValue: "${widget.FormData.unit}",
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
                      ),
                      SizedBox(width: 5,),
                      Expanded(
                        flex: 1,
                        child: TextFormField(
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10
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
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          style: const TextStyle(color: Colors.black),
                          controller: FebricationContractorNameController,
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
                                      return ContractorNameData != null
                                          ? AlertDialog(
                                        title: const Text('Select Fabrication Contractor'),
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
                                                      GetContractorName(value);
                                                      isLoading = true;
                                                      GetContractorName(value).then((data) {
                                                        setState(() {
                                                          ContractorNameData = data;
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
                                                    ContractorNameData
                                                        .data.length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                        int index) {
                                                      //final item = filteredItems[index];
                                                      return InkWell(
                                                        onTap: () {
                                                          setState(() {
                                                            FebricationContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                                                            FebricationContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                                                            Navigator.pop(
                                                                context);
                                                          });

                                                        },
                                                        child: ListTile(
                                                          title: Text(
                                                            "${ContractorNameData.data[index].selectValue.toString()}",
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
                              postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                              hintText: '',
                              labelText: 'Fabrication Contractor'),
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
                        child: TextFormField(
                          controller: febricationRateController,
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
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    style: const TextStyle(color: Colors.black),
                    controller: WeldingContractorNameController,
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
                                return ContractorNameData != null
                                    ? AlertDialog(
                                  title: const Text('Select Welding Contractor'),
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
                                                GetContractorName(value);
                                                isLoading = true;
                                                GetContractorName(value).then((data) {
                                                  setState(() {
                                                    ContractorNameData = data;
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
                                              ContractorNameData
                                                  .data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                  int index) {
                                                //final item = filteredItems[index];
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      WeldingContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                                                      WeldingContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                                                      Navigator.pop(context);
                                                    });

                                                  },
                                                  child: ListTile(
                                                    title: Text(
                                                      "${ContractorNameData.data[index].selectValue.toString()}",
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
                        postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                        hintText: '',
                        labelText: 'Welding Contractor'),
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
                    style: const TextStyle(color: Colors.black),
                    controller: PaintContractorNameController,
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
                                return ContractorNameData != null
                                    ? AlertDialog(
                                  title: const Text('Select Paint Contractor'),
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
                                                GetContractorName(value);
                                                isLoading = true;
                                                GetContractorName(value).then((data) {
                                                  setState(() {
                                                    ContractorNameData = data;
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
                                              ContractorNameData
                                                  .data.length,
                                              itemBuilder:
                                                  (BuildContext context,
                                                  int index) {
                                                //final item = filteredItems[index];
                                                return InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      PaintContractorNameController.text=ContractorNameData.data[index].selectValue.toString();
                                                      PaintContractorCode=ContractorNameData.data[index].selectValueCode.toString();
                                                      Navigator.pop(context);
                                                    });

                                                  },
                                                  child: ListTile(
                                                    title: Text(
                                                      "${ContractorNameData.data[index].selectValue.toString()}",
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
                        postfixIcon: const Icon(Icons.arrow_drop_down,size: 30,),
                        hintText: '',
                        labelText: 'Paint Contractor'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please fill this field';
                      }
                      return null;
                    },
                  ),*/

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
            Visibility(
              visible:widget.status!="Approved"&&widget.status!="Forwarded",
              child: Flexible(
                child: Container(
                  color: Colors.white,
                  padding: const EdgeInsets.only(
                      left: 5.0, right: 15.0, top: 0, bottom: 10),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        if(widget.status!="Approved"&&widget.status!="Forwarded"){
                          if (TCRequiredValue == "Yes") {
                            if (imageFiles.length > 0 ||
                                descriptions.isNotEmpty) {
                              SaveData(imageFiles);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please Attach Image",
                                textColor: Colors.white,
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.CENTER,
                              );
                            }
                          } else {
                            SaveData(imageFiles);
                          }
                          //SaveData();
                        }else{
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>  Material_Receipt_ItemList(Urn:widget.Urn,CategoryCode:widget.CategoryCode,categoryName: widget.categoryName,docNo:widget.docNo, status: widget.status,)));
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
            ),
          ],
        ),
      ),
    );
  }
  Future<InwardLocationResponse> GetContractorName(SearchText) async {
    Map data = {
      "UR_CODE": urCode,
      "Select_Valuecode": "",
      "Searchtext": SearchText,
      "CO_CODE":coCode,
      "It_code":widget.FormData.itemCode.toString()
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}QC/SelectionContractorName"),
      body: data,
    );
    log("${clientUrl}QC/SelectionContractorName$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        ContractorNameData = InwardLocationResponse.fromJson(map);
      });

      if (ContractorNameData.settings.success == "1") {
        setState(() {
          return ContractorNameData;
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
    return ContractorNameData;
  }

  Future<Map<String, dynamic>>  GetSizeList(SearchText) async {
    Map data = {
      "UR_CODE": urCode,
      "Select_Valuecode": "",
      "Searchtext": SearchText,
      "CO_CODE":coCode,
      "IT_Code":ItemNameCode,
      "Process_code":processCode,
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}MaterialReceipt/SelectionSizeList"),
      body: data,
    );
    log("${clientUrl}MaterialReceipt/SelectionSizeList$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      log(map.toString());



      if (map['settings']['success'] == "1") {
        setState(() {
          SizeData = map;
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
    return SizeData!=null ? SizeData:[];
  }

  Future<Map<String, dynamic>>  GetLocationList(SearchText) async {


    Map data = {
      "user_id": urCode,
      "CO_CODE":coCode,
      "URN_No":widget.Urn,
      "Select_Valuecode":widget.Urn,
      "item_filertext":SearchText,
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}MobileApp_MaterialReceipt/MaterialReceiptLocationList"),
      body: data,
    );
    log("${clientUrl}MobileApp_MaterialReceipt/MaterialReceiptLocationList$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      log(map.toString());



      if (map['settings']['success'] == "1") {
        setState(() {
          locationData = map;
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
    return locationData;
  }

  Future<Map<String, dynamic>>  GetStructureList(SearchText) async {
    Map data = {
      "UR_CODE": urCode,
      "Select_Valuecode": "",
      "Searchtext": SearchText,
      "CO_CODE":coCode,
      "IT_Code":ItemNameCode,
      "Size":SizeController.text.toString(),
      "Process_code":processCode,
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}MaterialReceipt/SelectionStructureList"),
      body: data,
    );
    log("${clientUrl}MaterialReceipt/SelectionStructureList$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      log(map.toString());



      if (map['settings']['success'] == "1") {

        setState(() {
          StructureData = map;
        });

      } else {
        GetContractorRate();
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
    return StructureData;
  }

  Future<Map<String, dynamic>> GetContractorRate() async {
    // Construct the query string
    final queryParams = {
      "UR_CODE": urCode,
      "CO_CODE": coCode,
      "IT_Code": ItemNameCode,
      "Size": SizeController.text.toString(),
      "Structure": StructureController.text.toString(),
      "Process_code": processCode,
    };

    // Build the full URL with query parameters
    final uri = Uri.parse("${clientUrl}MaterialReceipt/GetContractorRate")
        .replace(queryParameters: queryParams);

    setState(() {
      isLoading = true;
    });

    // Make the GET request
    final response = await http.get(uri);

    log(uri.toString()); // Log the full URL
    log(response.body.toString());

    setState(() {
      isLoading = false;
    });

    var jsonData;
    if (response.statusCode == 200) {
      setState(() {
        isLoading = false;
      });

      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      log(map.toString());

      if (map['settings']['success'] == "1") {
        setState(() {
          febricationRateController.text=map['Data'][0]['Rate'].toString();
        });
      } else {
        Fluttertoast.showToast(
          msg: "Data Not Found!",
          textColor: Colors.white,
          backgroundColor: Colors.red[800],
          gravity: ToastGravity.BOTTOM,
        );
      }
    } else {
      Fluttertoast.showToast(
        msg: "Something Wrong Please try again!",
        textColor: Colors.white,
        backgroundColor: Colors.red[800],
        gravity: ToastGravity.BOTTOM,
      );
    }
    return StructureData;
  }


  Future<void> SaveData(List images) async {
    setState(() {
      isLoading = true;
    });

    try {
      // Create a multipart request to handle both form data and images
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${clientUrl}MaterialReceipt/UpdateMaterialReceiptItemDetails"),
      );

      // Add form data (BODYDATA) to the request
      request.fields['Sr_no'] = widget.FormData.index.toString();
      request.fields['Co_Code'] = coCode;
      request.fields['urn_no'] = widget.Urn;
      request.fields['Item_Code'] = ItemNameCode.toString();
      request.fields['Fabrication_Contractor'] = FebricationContractorCode;
      request.fields['Fabrication_Rate_Kg'] = febricationRateController.text.toString();
      request.fields['Welding_Contractor'] = WeldingContractorCode;
      request.fields['Welding_Rate'] = weldingRateController.text.toString();
      request.fields['Process_Time_Hrs'] = processTimeController.text.toString();
      request.fields['Rate'] = RateController.text.toString();
      request.fields['location'] = LocationCode.toString();
      request.fields['Drg_Weight'] = DrgWeightController.text.toString();
      request.fields['Assembly_Weight'] = AssemblyweightController.text.toString();
      request.fields['Ur_Code'] = urCode;
      request.fields['Size'] = SizeController.text.toString();
      request.fields['Structure'] = StructureController.text.toString();
      request.fields['Amount'] = amountController.text.toString();
      request.fields['Quantity'] = QuantityController.text.toString();

      // Log the form data (payload)
      log("Form Data Payload: ${clientUrl}MaterialReceipt/UpdateMaterialReceiptItemDetails${request.fields}");

      // Convert ImageFiles to File and add the images to the request as files
      for (int i = 0; i < images.length; i++) {
        request.files.add(http.MultipartFile(
            'files',
            File(images[i].path).readAsBytes().asStream(),
            File(images[i].path).lengthSync(),
            filename: images[i].path.split("/").last));
      }

      // Log the image file details (payload)
      for (var element in request.files) {
        log('Image File Payload ==> Filename: ${element.filename}, Length: ${element.length}');
      }

      // Send the request
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);
      log("Response Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");

      // Handle the response
      if (response.statusCode == 200) {
        var jsonData = json.decode(response.body);
        var urnResData = SaveItemIssueResponse.fromJson(Map<String, dynamic>.from(jsonData));

        if (!mounted) return;
        setState(() {
          isLoading = false;
        });

        if (urnResData.settings.success == "1") {
          if(widget.barCodeRes!=null ){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Material_Receipt_ItemList(
                  Urn: widget.Urn,
                  CategoryCode: widget.CategoryCode,
                  categoryName: widget.categoryName,
                  docNo: widget.docNo,
                  status: widget.status, barcoderes:widget.barCodeRes,
                ),
              ),
            );
          }else{
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Material_Receipt_ItemList(
                  Urn: widget.Urn,
                  CategoryCode: widget.CategoryCode,
                  categoryName: widget.categoryName,
                  docNo: widget.docNo,
                  status: widget.status, /*barcoderes:widget.barCodeRes,*/
                ),
              ),
            );
          }

          Fluttertoast.showToast(
            msg: urnResData.message,
            textColor: Colors.white,
            backgroundColor: Colors.green,
            gravity: ToastGravity.BOTTOM,
          );
        } else {
          Fluttertoast.showToast(
            msg: urnResData.message ?? "Upload failed!",
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
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      log("Error during file upload: $e");
      Fluttertoast.showToast(
        msg: "An error occurred! Please try again.",
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

  Future<Map<Permission, PermissionStatus>> permissionServices() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.storage,
      Permission.camera,
      // Add more permissions to request here if needed
    ].request();

    // Handle storage permission
    if (statuses[Permission.storage]!.isPermanentlyDenied) {
      await openAppSettings();
    } else if (statuses[Permission.storage]!.isDenied) {
      // Optionally handle if storage permission is denied
      // You might want to prompt again or handle this case
    }

    // Handle camera permission
    if (statuses[Permission.camera]!.isPermanentlyDenied) {
      await openAppSettings();
    } else if (statuses[Permission.camera]!.isDenied) {
      // Optionally handle if camera permission is denied
      // You might want to prompt again or handle this case
    }

    return statuses;
  }

  Future<void> permissionServiceCall(BuildContext context, String type) async {
    Map<Permission, PermissionStatus> statuses = await permissionServices();

    if (statuses[Permission.camera]!.isGranted) {
      if (type == "FromCamera") {
        _showChoiceDialog(context);
      } else {
        // Handle other cases if needed
      }
    } else {
      // Optionally handle cases where permissions are not granted
      // Maybe show a message or prompt to grant permissions
    }
  }

  void removeListItem(int index) {
    imageFiles = List.from(imageFiles)..removeAt(index);
  }

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text(
              "Choose option",
              style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: const Text("Gallery"),
                    leading: const Icon(
                      Icons.account_box,
                      color: Colors.blue,
                    ),
                  ),
                  const Divider(
                    height: 1,
                    color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: const Text("Camera"),
                    leading: const Icon(
                      Icons.camera,
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );
    final bytes = (await pickedFile?.readAsBytes())?.lengthInBytes;
    final kb = (bytes! / 1024);
    final mb = (kb / 1024);
    log('KB ==> $kb MB ==> $mb');
    if (mb < 10) {
      if (!mounted) return;
      setState(() {
        // filenameOriginal = "${widget.barcodeResponse}$todayDate";
        final File _file = File(pickedFile!.path.toString());
        fileextention = path.extension(_file.path);
        log('Original path: ${pickedFile.path} ');
        fileName = '$filenameOriginal$fileextention';
        log('New path: $fileName ');
        imageFiles.add(ImageFiles(
            fileName, pickedFile.path.toString(), fileextention.toString()));
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please select image less than or equal to 10 MB",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: Colors.red);
    }
    Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
      imageQuality: 85,
    );
    final bytes = (await pickedFile?.readAsBytes())?.lengthInBytes;
    final kb = (bytes! / 1024);
    final mb = (kb / 1024);
    log('KB ==> $kb MB ==> $mb');

    if (mb < 10) {
      if (!mounted) return;
      setState(() {
        filenameOriginal = "SalesOrder_$todayDate";
        final File _file = File(pickedFile!.path.toString());
        fileextention = path.extension(_file.path);
        log('Original path: ${pickedFile.path} ');
        fileName = '$filenameOriginal$fileextention';
        log('New path: $fileName ');
        imageFiles.add(ImageFiles(
            fileName, pickedFile.path.toString(), fileextention.toString()));
      });
    } else {
      Fluttertoast.showToast(
          msg: "Please select image less than or equal to 10 MB",
          gravity: ToastGravity.CENTER,
          toastLength: Toast.LENGTH_SHORT,
          textColor: Colors.white,
          backgroundColor: Colors.red);
    }
    Navigator.pop(context);
  }

  Future<void> AttachmentList() async {
    var BODYDATA = {
      'CO_CODE': coCode,
      'urn_no': widget.Urn,
    };
    log("Api Name: ${clientUrl}MaterialReceipt/MaterialReceiptAttachmentData $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}MaterialReceipt/MaterialReceiptAttachmentData"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}MaterialReceipt/MaterialReceiptAttachmentData $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = AttachmentListingDataResponse.fromJson(map);
      if (!mounted) return;

      if (urnResData.settings.success == "1") {

        TCRequiredValue = 'Yes';
        setState(() {
          setState(() {
            descriptions =
                urnResData.data.map((item) => item.attachment).toList();
            log(descriptions.toList().toString());
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

  void _calculateAmount() {
    final double rate = double.tryParse(RateController.text) ?? 0;
    final double processTime = double.tryParse(processTimeController.text) ?? 0;
    final double amount = rate * processTime;

    // Update the amount field
    amountController.text = amount.toStringAsFixed(2);
  }
}