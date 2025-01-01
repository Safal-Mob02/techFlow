import 'dart:convert';
import 'dart:developer';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../Response_Files/InwardResponse/Inward_MainFormDetails_Response.dart';
import '../Response_Files/InwardResponse/SaveInwardMainResponse.dart';
import '../Response_Files/IssueResponse/SaveItemIssue_Response.dart';
import '../Response_Files/IssueResponse/statusUpdate_Response.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'InwardListScreen.dart';
class Inward_MainForm extends StatefulWidget {
  final TabController tabController;
  var urn,status;
  Inward_MainForm({Key? key, required this.tabController, required this.urn,this.status})
      : super(key: key);

  @override
  _Inward_MainFormState createState() =>
      _Inward_MainFormState();
}

class _Inward_MainFormState extends State<Inward_MainForm> {
  bool isChecked = false;

  bool isLoading=false;

  final ScrollController _scrollController = ScrollController();

  TextEditingController inwardDateController=TextEditingController();
  TextEditingController challanDateController=TextEditingController();
  TextEditingController challanNoController=TextEditingController();
  TextEditingController billNoController=TextEditingController();
  TextEditingController billDateController=TextEditingController();
  TextEditingController ewayBillNoController=TextEditingController();
  TextEditingController ewayBillDateController=TextEditingController();
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
                Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        //  controller: _emailController,
                        initialValue: DoPandingListData
                            .data[0].inwardNo,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            //   prefixIcon: Icon(Icons.email_outlined),
                            hintText: '',
                            labelText: 'Inward No'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        //  controller: _emailController,
                        initialValue: DoPandingListData
                            .data[0].preparedBy,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            //   prefixIcon: Icon(Icons.email_outlined),
                            hintText: '',
                            labelText: 'Prepared by'),
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
                      child: TextFormField(
                        //  controller: _emailController,
                        initialValue: DoPandingListData
                            .data[0].category,
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
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: inwardDateController,
                        readOnly: true,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              inwardDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        keyboardType: TextInputType.emailAddress,
                       // initialValue: DoPandingListData.data[0].inwardDate.toString(),
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            postfixIcon: Icon(
                              Icons.date_range,
                              size: 30,
                            ),
                            // hintText: '20-03-2024',
                            labelText: 'Inward Date'),
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
                  //  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: true,
                  initialValue:  DoPandingListData
                      .data[0].supplier,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'supplier'),
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
                   controller: billNoController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: false,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Bill No'),
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
                  controller: challanNoController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: false,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Challan No'),
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
                  initialValue: DoPandingListData
                      .data[0].gstNo,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Gst'),
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
                        controller: challanDateController,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              challanDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
                        // initialValue: DoPandingListData.data[0].inwardDate.toString(),
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            postfixIcon: Icon(
                              Icons.date_range,
                              size: 30,
                            ),
                            // hintText: '20-03-2024',
                            labelText: 'Challan Date'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please fill this field';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: TextFormField(
                        controller: billDateController,
                        readOnly: true,
                        keyboardType: TextInputType.emailAddress,
                        // initialValue: DoPandingListData.data[0].inwardDate.toString(),
                        decoration: inputDecoration(
                            focusedBorder: myfocusborder(),
                            enabledBorder: myinputborder(),
                            postfixIcon: Icon(
                              Icons.date_range,
                              size: 30,
                            ),

                            // hintText: '20-03-2024',
                            labelText: 'Bill Date'),
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2000),
                            lastDate: DateTime(2101),
                          );
                          if (pickedDate != null) {
                            setState(() {
                              billDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                            });
                          }
                        },
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
                    controller: ewayBillNoController,
                  keyboardType: TextInputType.emailAddress,
                  readOnly: false,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'E-way Bill No'),
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
                  controller: ewayBillDateController,
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        ewayBillDateController.text = DateFormat('yyyy-MM-dd').format(pickedDate);
                      });
                    }
                  },
                  // initialValue: DoPandingListData.data[0].inwardDate.toString(),
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      postfixIcon: Icon(
                        Icons.date_range,
                        size: 30,
                      ),
                      // hintText: '20-03-2024',
                      labelText: 'E-way Bill Date'),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill this field';
                    }
                    return null;
                  },
                ),
              ]):Container(
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
              log(widget.status.toString());
              if(widget.status !="Approved"&&widget.status!="Forwarded"){
                SaveData();
              }else{
                widget.tabController.animateTo(1);
              }

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
      'UrnNo': widget.urn.toString(),
      'UR_CODE': urCode,
      'Co_Code': coCode,
    };
    final response = await http.post(
      Uri.parse("${clientUrl}purchase/PurchaseInwardMasterData"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}purchase/PurchaseInwardMasterData $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        isLoading = false;
        DoPandingListData = InwardMainFormDetailsResponse.fromJson(map);
      });
      if (DoPandingListData.settings.success == "1") {
        setState(() {
          isLoading = false;
          //inwardDateController.text=DoPandingListData.data[0].inwardDate;
          inwardDateController.text=DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].inwardDate);

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
              //ewayBillDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
            }else{
              ewayBillDateController.text=DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].ewayBillDate).toString();
            }
            if(DoPandingListData.data[0].billDate.toString() == "1900-01-01 00:00:00.000") {
              billDateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
            }else{
              billDateController.text=DateFormat('yyyy-MM-dd').format(DoPandingListData.data[0].billDate).toString();
            }

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
    var BODYDATA={
      'CO_CODE': coCode,
      'UR_CODE':urCode,
      'Urn_no': widget.urn,
      'Inward_Date':inwardDateController.text.toString(),
      'Challan_Date':challanDateController.text.toString(),
      'Bill_No':billNoController.text.toString(),
      'Bill_Date':billDateController.text.toString(),
      'Challan_No':challanNoController.text.toString(),
      'Eway_Bill_No':ewayBillNoController.text.toString(),
      'Eway_Bill_Date':ewayBillDateController.text.toString(),
      'DB_CODE':DoPandingListData.data[0].categoryCode.toString()
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
          setState(() {
            UpdateStatus().then((value) =>  widget.tabController.animateTo(1));
          });
         
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
        if(urnResData.messageType=='Yes/No') {
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
        }else{
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
}