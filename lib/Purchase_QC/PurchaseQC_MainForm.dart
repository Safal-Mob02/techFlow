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
import '../Response_Files/InwardResponse/SaveInwardMainResponse.dart';
import '../Response_Files/IssueResponse/SaveItemIssue_Response.dart';
import '../Response_Files/IssueResponse/statusUpdate_Response.dart';
import '../Response_Files/PurchaseQC_Response/AttachmentListingDataResponse.dart';
import '../Response_Files/PurchaseQC_Response/Purchase_QC_MainData.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'package:path/path.dart' as path;
import '../Utils/ImageFiles.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';

class PurchaseQC_MainForm extends StatefulWidget {
  final TabController tabController;
  var urn,status;
  PurchaseQC_MainForm(
      {Key? key, required this.tabController, required this.urn,this.status})
      : super(key: key);

  @override
  _PurchaseQC_MainFormState createState() => _PurchaseQC_MainFormState();
}

class _PurchaseQC_MainFormState extends State<PurchaseQC_MainForm> {
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

  String TCRequiredValue = 'No';
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
    todayDate = inputFormat.format(DateTime.now());
    filenameOriginal = "$todayDate";
    return Scaffold(
      backgroundColor: kMainColor,
      resizeToAvoidBottomInset: true,
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
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
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            //  controller: _emailController,
                            initialValue: DoPandingListData.data[0].category,
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
                          SizedBox(
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
                          SizedBox(
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
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            //  controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: true,
                            initialValue: DoPandingListData.data[0].soNo,
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
                          SizedBox(
                            height: 10,
                          ),
                          TextFormField(
                            readOnly: true,
                            initialValue:
                                DoPandingListData.data[0].batchQty.toString(),
                            keyboardType: TextInputType.emailAddress,
                            decoration: inputDecoration(
                                focusedBorder: myfocusborder(),
                                enabledBorder: myinputborder(),
                                //   prefixIcon: Icon(Icons.email_outlined),
                                hintText: '',
                                labelText: 'Batch QTY'),
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
                            controller: sampleQTYController,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: false,
                            decoration: inputDecoration(
                                focusedBorder: myfocusborder(),
                                enabledBorder: myinputborder(),
                                postfixIcon: Icon(Icons.edit),
                                hintText: '',
                                labelText: 'Sample QTY'),
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
                            controller: RemarkController,
                            keyboardType: TextInputType.emailAddress,
                            readOnly: false,
                            decoration: inputDecoration(
                                focusedBorder: myfocusborder(),
                                enabledBorder: myinputborder(),
                                postfixIcon: Icon(Icons.edit),
                                hintText: '',
                                labelText: 'Remark'),
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
                              child: DropdownButtonFormField<String>(
                                value: TCRequiredValue,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    TCRequiredValue = newValue!;
                                  });
                                },
                                items: <String>['Yes', 'No']
                                    .map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                decoration: InputDecoration(
                                  focusedBorder: myfocusborder(),
                                  enabledBorder: myinputborder(),
                                  // suffixIcon: Icon(Icons.edit),
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
                            SizedBox(width: 2,),
                            descriptions.isNotEmpty?
                            Container(
                              height: 65,
                              width: 55,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                  border: Border.all(
                                    color: kBorderColorTextField,
                                    width: 3,
                                  )
                              ),
                              child: IconButton(onPressed: (){
                                showDialog(
                                  context: context,
                                  barrierDismissible: true,
                                  builder: (BuildContext context) {
                                    return StatefulBuilder(
                                        builder: (context, setState) {
                                          return descriptions != null
                                              ? AlertDialog(
                                            title: const Text('Uploaded Attachments'),
                                            content: Container(
                                              width: double.maxFinite,
                                              //  constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height),
                                              child: SingleChildScrollView(
                                                child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                                  mainAxisSize: MainAxisSize.max,
                                                  children: [
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
                                                        descriptions.length,
                                                        itemBuilder:
                                                            (BuildContext context,
                                                            int index) {
                                                          //final item = filteredItems[index];
                                                          return InkWell(
                                                            child: Card(
                                                              color: Colors.greenAccent,
                                                              child: ListTile(

                                                                trailing: Icon(CupertinoIcons.check_mark_circled,color: Colors.white,),
                                                                title: Text(
                                                                  "${descriptions[index]}",
                                                                  style: const TextStyle(
                                                                      fontWeight:
                                                                      FontWeight
                                                                          .w500,
                                                                      fontSize: 15,
                                                                      color: Colors
                                                                          .white),
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
                                            title: Text('No Data Available'),
                                          );
                                          ;
                                        });
                                  },
                                );
                              }, icon: Icon(CupertinoIcons.eye)),
                            ):SizedBox.shrink(),
                            SizedBox(width: 2,),
                            TCRequiredValue=="Yes"?
                            InkWell(
                              onTap: () {
                                permissionServiceCall(context,"FromCamera");
                              },
                              child: Container(
                                  height: 65,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                      border: Border.all(
                                        color: kBorderColorTextField,
                                        width: 3,
                                      )
                                  ),
                                  child: Icon(Icons.image) /*Image.asset(
                            "Assets/Image.png",
                            height: 60,
                            width: 60,
                            fit: BoxFit.fill,
                          )*/),
                            ):SizedBox.shrink(),
                          ],
                        ),
                        if(imageFiles.length>0)
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: ListView.builder(
                            itemCount: imageFiles.length,
                            physics: NeverScrollableScrollPhysics(),
                            itemBuilder: (_, index) {
                              return InkWell(
                                child: Card(
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                 // margin: const EdgeInsets.only(left: 20, top: 20, right: 20),
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10))),
                                  elevation: 5,
                                  child: imageFiles[index] != null
                                      ? Column(children: [
                                    Image.file(
                                        File(imageFiles[index]
                                            .path
                                            .toString()),
                                        fit: BoxFit.fitWidth,
                                        width: MediaQuery.of(context)
                                            .size
                                            .width,
                                        height: 150),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                      MainAxisAlignment.start,
                                      children: [
                                        Flexible(
                                          child: Container(
                                            width:
                                            MediaQuery.of(context)
                                                .size
                                                .width,
                                            padding:
                                            const EdgeInsets.all(
                                                10.0),
                                            child: Text(
                                              imageFiles[index]
                                                  .name
                                                  .toString()
                                                  .length >
                                                  30
                                                  ? '${imageFiles[index].name.toString().substring(0, 25)}...'
                                                  : imageFiles[index]
                                                  .name
                                                  .toString(),
                                              style: const TextStyle(
                                                  fontFamily:
                                                  "poppins_regular",
                                                  fontSize: 12,
                                                  color:
                                                  Color(0xff555555),
                                                  fontWeight:
                                                  FontWeight.bold),
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
                                          child: Padding(
                                            padding:
                                            const EdgeInsets.only(
                                                right: 8.0),
                                            child: Icon(CupertinoIcons.delete),
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
                      child: Center(child: Text("No Data"))),
        ),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10),
        child: InkWell(
          onTap: () {
            setState(() {
              // if(TCRequiredValue=="Yes"){
              //   if(imageFiles.length>0){
              //     uploadmultipleimage(imageFiles);
              //   }else{
              //     Fluttertoast.showToast(
              //       msg: "Please Attach Image",
              //       textColor: Colors.white,
              //       backgroundColor: Colors.red,
              //       gravity: ToastGravity.CENTER,
              //     );
              //   }
              // }else{
              //   uploadmultipleimage(imageFiles);
              // }

              if(widget.status !="Approved"&&widget.status!="Forwarded"){
                if(TCRequiredValue=="Yes"){
                  if(imageFiles.length>0){
                    uploadmultipleimage(imageFiles);
                  }else{
                    Fluttertoast.showToast(
                      msg: "Please Attach Image",
                      textColor: Colors.white,
                      backgroundColor: Colors.red,
                      gravity: ToastGravity.CENTER,
                    );
                  }
                }else{
                  uploadmultipleimage(imageFiles);
                }
              }else{
                widget.tabController.animateTo(1);
              }
              // SaveData();
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
                'Save & Next',
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
    );
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
      var batch_qty =map["Data"][0]["Batch Qty"];


      setState(() {
        isLoading = false;
        DoPandingListData = PurchaseQcMainData.fromJson(map);
      });
      if (DoPandingListData.settings.success == "1") {
        setState(() {
          isLoading = false;
          sampleQTYController.text = DoPandingListData.data[0].sampleQty.toString();
          RemarkController.text = DoPandingListData.data[0].remark.toString();
          log(DoPandingListData.data[0].tcRequired);
          if(DoPandingListData.data[0].tcRequired!=""){
          TCRequiredValue=DoPandingListData.data[0].tcRequired.toString();
          }else{
            TCRequiredValue = 'No';
          }
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
    log("${clientUrl}QC/UpdateQCSaveData");
    setState(() {
      isLoading=true;
    });
    var request = http.MultipartRequest(
        "POST", Uri.parse("${clientUrl}QC/UpdateQCSaveData"));
     request.fields['QC_Date'] = DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].date).toString();
    request.fields['Sample_Qty'] =sampleQTYController.text.toString();
     request.fields['Batch_Qty'] =  DoPandingListData.data[0].batchQty.toString();
     request.fields['CO_CODE'] = coCode;
    request.fields['Urn_no'] = widget.urn;
    request.fields['UR_CODE'] =urCode;
     request.fields['status'] = "Not Approved";
     request.fields['cancelreson'] = "";
     request.fields['entrysrno'] = "";
     request.fields['TC_Required'] = TCRequiredValue.toString();
     request.fields['Remarks'] = RemarkController.text.toString();
    for (int i = 0; i < images.length; i++) {
      request.files.add(http.MultipartFile(
          'files',
          File(images[i].path).readAsBytes().asStream(),
          File(images[i].path).lengthSync(),
          filename: images[i].path.split("/").last));
    }
    for (var element in request.files) {
      log('Image Array ==> ${element.filename}');
    }
    var response = await request.send();
     // Parse the string into a JSON object
    setState(() {
      isLoading=false;
    });
    if (response.statusCode == 200) {
      var responseString = await response.stream.bytesToString();  // Read the response as a string
      var responseJson = jsonDecode(responseString);
      if (responseJson['settings']['success'] == '1') {

        setState(() {
          Fluttertoast.showToast(
              msg: responseJson['message'].toString().toUpperCase(),  // Show specific message if available
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.CENTER);
          widget.tabController.animateTo(1);
        });
      } else {
        if (!mounted) return;
        setState(() {
          Fluttertoast.showToast(
              msg: responseJson['message'] ?? "Upload failed!",  // Show specific message if available
              backgroundColor: Colors.red,
              textColor: Colors.white,
              gravity: ToastGravity.CENTER);
        });
      }

    } else {
      if(!mounted)return;
      setState(() {

      });
      Fluttertoast.showToast(
          msg: "Something wrongg!",
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
      imageQuality: 60,
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
    //Navigator.pop(context);
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
                    Navigator.of(context).pop(); // Close the dialog
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
                    Navigator.of(context).pop(); // Close the dialog
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
      },
    );
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

            descriptions = urnResData.data.map((item) => item.attachment).toList();
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
}