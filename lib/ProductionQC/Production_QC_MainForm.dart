import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import '../Response_Files/InwardResponse/Inward_Location_Response.dart';
import '../Response_Files/InwardResponse/SaveInwardMainResponse.dart';
import '../Response_Files/IssueResponse/LocationSelection_Response.dart';
import '../Response_Files/IssueResponse/SaveItemIssue_Response.dart';
import '../Response_Files/IssueResponse/statusUpdate_Response.dart';
import '../Response_Files/PurchaseQC_Response/AttachmentListingDataResponse.dart';
import '../Response_Files/PurchaseQC_Response/Purchase_QC_ItemList_Response.dart';
import '../Response_Files/PurchaseQC_Response/Purchase_QC_MainData.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'package:path/path.dart' as path;
import '../Utils/ImageFiles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class Producion_QC_MainForm extends StatefulWidget {
  final TabController tabController;
  var urn, status;
  Producion_QC_MainForm(
      {Key? key, required this.tabController, required this.urn, this.status})
      : super(key: key);

  @override
  _Producion_QC_MainFormState createState() => _Producion_QC_MainFormState();
}

class _Producion_QC_MainFormState extends State<Producion_QC_MainForm> {
  bool isChecked = false;

  bool isLoading = false;

  final ScrollController _scrollController = ScrollController();

  TextEditingController inwardDateController = TextEditingController();
  TextEditingController challanDateController = TextEditingController();
  TextEditingController challanNoController = TextEditingController();
  TextEditingController billNoController = TextEditingController();
  TextEditingController billDateController = TextEditingController();
  TextEditingController ewayBillNoController = TextEditingController();
  TextEditingController ewayBillDateController = TextEditingController();
  TextEditingController sampleQTYController = TextEditingController();
  TextEditingController RemarkController = TextEditingController();
  TextEditingController Inspection_ByController = TextEditingController();

  String TCRequiredValue = "";
  String userId = "";
  String customerId = "";
  String page_index = "1";
  String searchText = "";

  var jsonData;
  late Map<String, dynamic> map;
  var mapEntry;

  var imagePicker;
  final picker = ImagePicker();
  List<PickedFile?> pickedFile = [];
  List<ImageFiles> imageFiles = [];

  var imageFile;

  var fileName;

  var message;
  var inputFormat = DateFormat('mm_ss_SSS');
  var todayDate;
  var fileextention = "";
  var filenameOriginal;

  var ContractorNameData;

  TextEditingController _searchController = TextEditingController();
  TextEditingController ContractorNameController = TextEditingController();
  TextEditingController welderNameController = TextEditingController();
  TextEditingController batchQtyController = TextEditingController();
  TextEditingController drgWaightController = TextEditingController();
  TextEditingController AssemblyWaightController = TextEditingController();
  var selectedWelderrCode;

  var itemcode;

  String selectedContractorCode = "";

  var welderNameData;

  var Qty;

  // var batchQtyController;

  // var sampleQTYController;
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  var urCode;
  var clientUrl;
  var DoPandingListData;
  var coCode;
  @override
  void initState() {
    setState(() {
      TCRequiredValue = 'Yes';
    });
    imagePicker = ImagePicker();

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
              AttachmentList();
              fetchitemData();
              /* ewayBillDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      billDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
      challanDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());*/

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
  //  TCRequiredValue = 'Yes';
    todayDate = inputFormat.format(DateTime.now());
    filenameOriginal = "$todayDate";
    return Scaffold(
        backgroundColor: kMainColor,
        resizeToAvoidBottomInset: true,
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
                    ? Column(
                        //mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    //  controller: _emailController,
                                    initialValue:
                                        DoPandingListData.data[0].category,
                                    readOnly: true,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        //   prefixIcon: Icon(Icons.email_outlined),
                                        hintText: '',
                                        labelText: 'Category'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    //  controller: _emailController,
                                    initialValue: DateFormat('yyyy-MM-dd')
                                        .format(DoPandingListData.data[0].date)
                                        .toString(),
                                    readOnly: true,
                                    keyboardType: TextInputType.emailAddress,
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        //   prefixIcon: Icon(Icons.email_outlined),
                                        hintText: '',
                                        labelText: 'Date'),
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
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              //  controller: _emailController,
                              initialValue: DoPandingListData.data[0].party,
                              readOnly: true,
                              keyboardType: TextInputType.emailAddress,
                              decoration: inputDecoration(
                                  focusedBorder: myfocusborder(),
                                  enabledBorder: myinputborder(),
                                  //   prefixIcon: Icon(Icons.email_outlined),
                                  hintText: '',
                                  labelText: 'Party'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              //  controller: _emailController,
                              initialValue: DoPandingListData.data[0].item,
                              readOnly: true,
                              keyboardType: TextInputType.emailAddress,
                              decoration: inputDecoration(
                                  focusedBorder: myfocusborder(),
                                  enabledBorder: myinputborder(),
                                  //   prefixIcon: Icon(Icons.email_outlined),
                                  hintText: '',
                                  labelText: 'Item'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    //  controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: true,
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue:
                                        DoPandingListData.data[0].soNo,
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        //   prefixIcon: Icon(Icons.email_outlined),
                                        hintText: '',
                                        labelText: 'SoNo'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    //  controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: true,
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue: DoPandingListData
                                        .data[0].batchQty
                                        .toString(),
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        //   prefixIcon: Icon(Icons.email_outlined),
                                        hintText: '',
                                        labelText: 'BatchQty'),
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    //  controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: true,
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue:
                                        DoPandingListData.data[0].location,
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        //   prefixIcon: Icon(Icons.email_outlined),
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
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    //  controller: _emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: true,
                                    style: const TextStyle(color: Colors.grey),
                                    initialValue: DoPandingListData
                                        .data[0].process
                                        .toString(),
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
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: batchQtyController,
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: false,
                                    style: const TextStyle(color: Colors.black),
                                    // initialValue: DoPandingListData.data[0].batchQty,
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        postfixIcon: const Icon(Icons.edit),
                                        hintText: '',
                                        labelText: 'BatchQty'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: sampleQTYController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.black),
                                    readOnly: false,
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        postfixIcon: const Icon(Icons.edit),
                                        hintText: '',
                                        labelText: 'Sample QTY'),
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
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: drgWaightController,
                                    keyboardType: TextInputType.emailAddress,
                                    readOnly: true,
                                    style: const TextStyle(color: Colors.black),
                                    // initialValue: DoPandingListData.data[0].batchQty,
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        postfixIcon: const Icon(Icons.edit),
                                        hintText: '',
                                        labelText: 'Drg Weight'),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please fill this field';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                const SizedBox(
                                  width: 5,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: TextFormField(
                                    controller: AssemblyWaightController,
                                    keyboardType: TextInputType.emailAddress,
                                    style: const TextStyle(color: Colors.black),
                                    readOnly: false,
                                    decoration: inputDecoration(
                                        focusedBorder: myfocusborder(),
                                        enabledBorder: myinputborder(),
                                        postfixIcon: const Icon(Icons.edit),
                                        hintText: '',
                                        labelText: 'Assembly Weight'),
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
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              controller: ContractorNameController,
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
                                              title: const Text(
                                                  'Select Contractor'),
                                              content: Container(
                                                width: double.maxFinite,
                                                //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      CupertinoSearchTextField(
                                                        controller:
                                                            _searchController,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            GetContractorName(
                                                                value);
                                                            isLoading = true;
                                                            GetContractorName(
                                                                    value)
                                                                .then((data) {
                                                              setState(() {
                                                                ContractorNameData =
                                                                    data;
                                                                log(data.data
                                                                    .toString());
                                                                isLoading =
                                                                    false;
                                                              });
                                                            }).catchError(
                                                                    (error) {
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                                // Handle error if necessary
                                                              });
                                                            });
                                                          });
                                                        },
                                                      ),
                                                      if (isLoading)
                                                        Center(
                                                          child: Lottie.asset(
                                                            'Assets/loading.json',
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      else
                                                        Container(
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                ContractorNameData
                                                                    .data
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              //final item = filteredItems[index];
                                                              return InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    ContractorNameController.text = ContractorNameData
                                                                        .data[
                                                                            index]
                                                                        .selectValue
                                                                        .toString();
                                                                    selectedContractorCode = ContractorNameData
                                                                        .data[
                                                                            index]
                                                                        .selectValueCode
                                                                        .toString();
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
                                                                        fontSize:
                                                                            15,
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
                                  postfixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    size: 30,
                                  ),
                                  hintText: '',
                                  labelText: 'Contractor Name'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              style: const TextStyle(color: Colors.black),
                              controller: welderNameController,
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
                                      return welderNameData != null
                                          ? AlertDialog(
                                              title: const Text(
                                                  'Select Welding Contractor'),
                                              content: Container(
                                                width: double.maxFinite,
                                                //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                                child: SingleChildScrollView(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    children: [
                                                      CupertinoSearchTextField(
                                                        controller:
                                                            _searchController,
                                                        onChanged: (value) {
                                                          setState(() {
                                                            GetContractorName(
                                                                value);
                                                            isLoading = true;
                                                            GetContractorName(
                                                                    value)
                                                                .then((data) {
                                                              setState(() {
                                                                welderNameData =
                                                                    data;
                                                                log(data.data
                                                                    .toString());
                                                                isLoading =
                                                                    false;
                                                              });
                                                            }).catchError(
                                                                    (error) {
                                                              setState(() {
                                                                isLoading =
                                                                    false;
                                                                // Handle error if necessary
                                                              });
                                                            });
                                                          });
                                                        },
                                                      ),
                                                      if (isLoading)
                                                        Center(
                                                          child: Lottie.asset(
                                                            'Assets/loading.json',
                                                            width: 100,
                                                            height: 100,
                                                            fit: BoxFit.fill,
                                                          ),
                                                        )
                                                      else
                                                        Container(
                                                          height: MediaQuery.of(
                                                                  context)
                                                              .size
                                                              .height,
                                                          child:
                                                              ListView.builder(
                                                            itemCount:
                                                                welderNameData
                                                                    .data
                                                                    .length,
                                                            itemBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    int index) {
                                                              //final item = filteredItems[index];
                                                              return InkWell(
                                                                onTap: () {
                                                                  setState(() {
                                                                    welderNameController.text = welderNameData
                                                                        .data[
                                                                            index]
                                                                        .selectValue
                                                                        .toString();
                                                                    selectedWelderrCode = welderNameData
                                                                        .data[
                                                                            index]
                                                                        .selectValueCode
                                                                        .toString();
                                                                    Navigator.pop(
                                                                        context);
                                                                  });
                                                                },
                                                                child: ListTile(
                                                                  title: Text(
                                                                    "${welderNameData.data[index].selectValue.toString()}",
                                                                    style: const TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w500,
                                                                        fontSize:
                                                                            15,
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
                                  postfixIcon: const Icon(
                                    Icons.arrow_drop_down,
                                    size: 30,
                                  ),
                                  hintText: '',
                                  labelText: 'Welding Contractor'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: Inspection_ByController
                                ..text = DoPandingListData.data[0].inspectionBy
                                    .toString(),
                              keyboardType: TextInputType.emailAddress,
                              readOnly: false,
                              style: const TextStyle(color: Colors.black),
                              //initialValue: DoPandingListData.data[0].inspectionBy.toString(),
                              decoration: inputDecoration(
                                  focusedBorder: myfocusborder(),
                                  enabledBorder: myinputborder(),
                                  // postfixIcon: Icon(Icons.edit),
                                  hintText: '',
                                  labelText: 'Inspection By'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 10),
                            TextFormField(
                              controller: RemarkController,
                              keyboardType: TextInputType.emailAddress,
                              readOnly: false,
                              decoration: inputDecoration(
                                  focusedBorder: myfocusborder(),
                                  enabledBorder: myinputborder(),
                                  postfixIcon: const Icon(Icons.edit),
                                  hintText: '',
                                  labelText: 'Remark'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please fill this field';
                                }
                                return null;
                              },
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
                                        TCRequiredValue =
                                            newValue!; // Update the state with selected value
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
                                      labelText: 'TC Required',
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
                          ])
                    : Container(
                        width: MediaQuery.of(context).size.width,
                        child: const Center(child: Text("No Data"))),
          ),
        ),
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: const EdgeInsets.only(
              left: 15.0, right: 15.0, top: 0, bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: InkWell(
                  onTap: () {
                    setState(() {
                      if (widget.status != "Approved" &&
                          widget.status != "Forwarded") {
                        if (double.parse(Qty.toString()) ==
                            double.parse(batchQtyController.text)) {
                          if (TCRequiredValue == "Yes") {
                            if (imageFiles.length > 0 ||
                                descriptions.isNotEmpty) {
                              uploadmultipleimage(imageFiles);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Please Attach Image",
                                textColor: Colors.white,
                                backgroundColor: Colors.red,
                                gravity: ToastGravity.CENTER,
                              );
                            }
                          } else {
                            uploadmultipleimage(imageFiles);
                          }
                        } else {
                          Fluttertoast.showToast(
                            msg: "Summery total should match with batch qty",
                            textColor: Colors.white,
                            backgroundColor: Colors.red,
                            gravity: ToastGravity.CENTER,
                          );
                        }
                      } else {
                        widget.tabController.animateTo(1);
                      }
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
                        'Save & Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'poppins_regular',
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              // SizedBox(width: 10.0), // Space between the buttons
              // Expanded(
              //   child: InkWell(
              //     onTap: () {
              //       setState(() {
              //         // Action for the 'Next' button
              //         widget.tabController.animateTo(1);
              //       });
              //     },
              //     child: Container(
              //       height: 60.0,
              //       decoration: BoxDecoration(
              //         color: kMainColor, // Set a different color for 'Next'
              //         border: Border.all(color: Colors.white, width: 1.0),
              //         borderRadius: BorderRadius.circular(30.0),
              //       ),
              //       child: const Center(
              //         child: Text(
              //           'Next',
              //           style: TextStyle(
              //             color: Colors.white,
              //             fontFamily: 'poppins_regular',
              //             fontSize: 17,
              //             fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }

  Future<void> fetchdata(SearchText) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'URN_No': widget.urn.toString(),
      'CO_Code': coCode,
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCAnalysisMasterList"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCAnalysisMasterList $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        isLoading = false;
        DoPandingListData = PurchaseQcMainData.fromJson(map);
      });
      if (DoPandingListData.settings.success == "1") {
        setState(() {
          isLoading = false;
          sampleQTYController.text =
              DoPandingListData.data[0].sampleQty.toString();
          batchQtyController.text =
              DoPandingListData.data[0].batchQty.toString();
          RemarkController.text = DoPandingListData.data[0].remark.toString();
          AssemblyWaightController.text =
              DoPandingListData.data[0].assemblyWeight.toString();
          drgWaightController.text =
              DoPandingListData.data[0].drgWEight.toString();
          Inspection_ByController.text =
              DoPandingListData.data[0].inspectionBy.toString();
          ContractorNameController.text =
              DoPandingListData.data[0].contractorName.toString();
          welderNameController.text =
              DoPandingListData.data[0].weldingContractor.toString();
          selectedWelderrCode =
              DoPandingListData.data[0].Welding_Contractor.toString() ?? "";
          selectedContractorCode =
              DoPandingListData.data[0].Contractor_Name.toString() ?? "";
          log(DoPandingListData.data[0].tcRequired);
          if (DoPandingListData.data[0].tcRequired != "") {
            TCRequiredValue = DoPandingListData.data[0].tcRequired.toString();
            TCRequiredValue = 'Yes';
          } else {
            TCRequiredValue = 'Yes';
          }
          itemcode = DoPandingListData.data[0].itemCode;
          GetContractorName("");
          GetWelderName("");
          /*  inwardDateController.text=DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].inwardDate);
          // billDateController.text=DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].billDate);
          challanNoController.text=DoPandingListData.data[0].challanNo.toString();
          ewayBillNoController.text=DoPandingListData.data[0].ewayBillNo.toString();
          billNoController.text=DoPandingListData.data[0].billNo.toString();
          if(DoPandingListData.data[0].challanDate.toString()=="1900-01-01 00:00:00.000") {
            challanDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
          }else{
            challanDateController.text=DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].challanDate).toString();
          }
          if(DoPandingListData.data[0].ewayBillDate.toString()=="1900-01-01 00:00:00.000") {
            ewayBillDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
          }else{
            ewayBillDateController.text=DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].ewayBillDate).toString();
          }
          if(DoPandingListData.data[0].billDate.toString() == "1900-01-01 00:00:00.000") {
            billDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
          }else{
            billDateController.text=DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].billDate).toString();
          }
*/
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
    return const OutlineInputBorder(
        //Outline border type for TextFeild
        borderRadius: BorderRadius.all(Radius.circular(20)),
        borderSide: BorderSide(
          color: kBorderColorTextField,
          width: 3,
        ));
  }

  OutlineInputBorder myfocusborder() {
    return const OutlineInputBorder(
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
          labelStyle: const TextStyle(color: Colors.grey),
          enabledBorder: enabledBorder ??
              const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBorderColorTextField, width: 2.0)),
          focusedBorder: focusedBorder ??
              const OutlineInputBorder(
                  borderSide:
                      BorderSide(color: kBorderColorTextField, width: 2.0)),
          border: border ??
              const OutlineInputBorder(
                  borderSide: BorderSide(color: kBorderColorTextField)),
          fillColor: fillColor ?? Colors.white,
          filled: filled ?? true,
          prefixIcon: prefixIcon,
          suffixIcon: postfixIcon,
          hintText: hintText,
          labelText: labelText);
  Future<void> SaveData() async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_CODE': coCode,
      'UR_CODE': urCode,
      'Urn_no': widget.urn,
      'Inward_Date': inwardDateController.text.toString(),
      'Challan_Date': challanDateController.text.toString(),
      'Bill_No': billNoController.text.toString(),
      'Bill_Date': billDateController.text.toString(),
      'Challan_No': challanNoController.text.toString(),
      'Eway_Bill_No': ewayBillNoController.text.toString(),
      'Eway_Bill_Date': ewayBillDateController.text.toString(),
      'DB_CODE': DoPandingListData.data[0].categoryCode.toString()
    };
    log("Api Name: ${clientUrl}purchase/UpdateInwardData $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}purchase/UpdateInwardData"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}purchase/UpdateInwardData $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = SaveInwardMainResponse.fromJson(map);
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
      if (urnResData.settings.success == "1") {
        setState(() {
          widget.tabController.animateTo(1);
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
        if (urnResData.messageType == 'Yes/No') {
          AwesomeDialog(
            btnCancelColor: Colors.black,
            btnOkColor: kMainColor,
            btnOkText: "Yes",
            context: context,
            // dialogType: DialogType.error,
            borderSide: const BorderSide(
              color: kMainColor,
              width: 2,
            ),
            width: double.infinity,
            buttonsBorderRadius: const BorderRadius.all(
              Radius.circular(2),
            ),
            dismissOnTouchOutside: true,
            dismissOnBackKeyPress: false,
            headerAnimationLoop: false,
            animType: AnimType.bottomSlide,
            title: "Warning!!",
            //  dialogType: DialogType.info,
            desc: "${urnResData.message}",
            descTextStyle: const TextStyle(fontSize: 17),
            showCloseIcon: false,
            btnCancelOnPress: () {},
            btnOkOnPress: () {
              setState(() {
                UpdateStatus();
              });
            },
          ).show();
        } else {
          Fluttertoast.showToast(
            msg: "${urnResData.message}",
            textColor: Colors.white,
            backgroundColor: Colors.red,
            gravity: ToastGravity.CENTER,
          );
        }
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

  Future<dynamic> uploadmultipleimage(List images) async {
    log("${clientUrl}QC/UpdateQCProductionSaveData");
    setState(() {
      isLoading = true;
    });
    var request = http.MultipartRequest(
        "POST", Uri.parse("${clientUrl}QC/UpdateQCProductionSaveData"));

    // Add fields
    request.fields['QC_Date'] = DateFormat('MM/dd/yyyy')
        .format(DoPandingListData.data[0].date)
        .toString();
    request.fields['Sample_Qty'] = sampleQTYController.text.toString();
    request.fields['Batch_Qty'] = batchQtyController.text;
    request.fields['CO_CODE'] = coCode;
    request.fields['Urn_no'] = widget.urn;
    request.fields['UR_CODE'] = urCode;
    request.fields['status'] = "Not Approved";
    request.fields['cancelreson'] = "";
    request.fields['entrysrno'] = "";
    request.fields['TC_Required'] = TCRequiredValue.toString();
    request.fields['Remarks'] = RemarkController.text.toString();
    request.fields['Contractor_Name'] = selectedContractorCode.toString();
    request.fields['Welding_Contractor'] = selectedWelderrCode.toString();
    request.fields['Drg_Weight'] = drgWaightController.text.toString();
    request.fields['Assembly_Weight'] = AssemblyWaightController.text.toString();
    request.fields['Inspection_By'] = Inspection_ByController.text.toString();

    // Log all fields
    request.fields.forEach((key, value) {
      log("Field: $key => Value: $value");
    });

    // Add files
    for (int i = 0; i < images.length; i++) {
      var file = http.MultipartFile(
        'files',
        File(images[i].path).readAsBytes().asStream(),
        File(images[i].path).lengthSync(),
        filename: images[i].path.split("/").last,
      );
      request.files.add(file);
      log("File added: ${file.filename}, Path: ${images[i].path}");
    }

    // Log all files
    for (var file in request.files) {
      log('File Array ==> Filename: ${file.filename}');
    }

    try {
      var response = await request.send();
      setState(() {
        isLoading = false;
      });
      var responseString = await response.stream.bytesToString();
      var responseJson = jsonDecode(responseString);
      log("Response JSON: ${responseJson.toString()}");

      if (response.statusCode == 200) {
        if (responseJson['settings']['success'] == '1') {
          setState(() {
            Fluttertoast.showToast(
                msg: responseJson['message']
                    .toString()
                    .toUpperCase(), // Show specific message if available
                backgroundColor: Colors.red,
                textColor: Colors.white,
                gravity: ToastGravity.CENTER);
            widget.tabController.animateTo(1);
          });
        } else {
          if (!mounted) return;
          setState(() {
            Fluttertoast.showToast(
                msg: responseJson['message'] ?? "Upload failed!",
                backgroundColor: Colors.red,
                textColor: Colors.white,
                gravity: ToastGravity.CENTER);
          });
        }
      } else {
        if (!mounted) return;
        Fluttertoast.showToast(
            msg: "Something went wrong!",
            backgroundColor: Colors.red,
            textColor: Colors.white,
            gravity: ToastGravity.CENTER);
      }
    } catch (e) {
      log("Error: $e");
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(
          msg: "An error occurred!",
          backgroundColor: Colors.red,
          textColor: Colors.white,
          gravity: ToastGravity.CENTER);
    }
  }


  Future<void> UpdateStatus() async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_CODE': coCode,
      'UR_CODE': urCode,
      'Urn_No': widget.urn,
      'Status': "Not Approved",
      'Remark': ""
    };
    log("Api Name: ${clientUrl}/purchase/PurchaseInwardUpdateStatus $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/purchase/PurchaseInwardUpdateStatus"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/purchase/PurchaseInwardUpdateStatus $BODYDATA");
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
        setState(() {
          widget.tabController.animateTo(1);
          Fluttertoast.showToast(
            msg: urnResData.message,
            textColor: Colors.white,
            backgroundColor: Colors.green,
            gravity: ToastGravity.BOTTOM,
          );
        });
        // fetchdata("");
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

  Future<InwardLocationResponse> GetContractorName(SearchText) async {
    Map data = {
      "UR_CODE": urCode,
      "Select_Valuecode": "",
      "Searchtext": SearchText,
      "CO_CODE": coCode,
      "It_code": itemcode.toString()
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

  Future<InwardLocationResponse> GetWelderName(SearchText) async {
    Map data = {
      "UR_CODE": urCode,
      "Select_Valuecode": "",
      "Searchtext": SearchText,
      "CO_CODE": coCode,
      "It_code": itemcode.toString()
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
        welderNameData = InwardLocationResponse.fromJson(map);
      });

      if (welderNameData.settings.success == "1") {
        setState(() {
          return welderNameData;
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
    return welderNameData;
  }

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

  onSelectionCancel() {}

  void removeListItem(int index) {
    imageFiles = List.from(imageFiles)..removeAt(index);
  }

  List<String> descriptions = [];
  Future<void> AttachmentList() async {
    var BODYDATA = {
      'CO_CODE': coCode,
      'form_type': "QCA",
      'urn_no': widget.urn,
    };
    log("Api Name: ${clientUrl}QC/QCAttachmentData $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCAttachmentData"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCAttachmentData $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = AttachmentListingDataResponse.fromJson(map);
      if (!mounted) return;

      if (urnResData.settings.success == "1") {
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

  Future<void> fetchitemData() async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'UrnNo': widget.urn.toString(),
      // 'UR_CODE': urCode,
      'Co_Code': coCode,
    };
    final response = await http.post(
      Uri.parse("${clientUrl}/QC/QCSummaryGridGetItem"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/QC/QCSummaryGridGetItem $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);

      if (map['settings']['success'] == "1") {
        setState(() {
          isLoading = false;
        });
        Qty = map['Data'][0]['Qty'];
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
}
