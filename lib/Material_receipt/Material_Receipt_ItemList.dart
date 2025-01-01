// ignore_for_file: deprecated_member_use

import 'dart:convert';
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:lottie/lottie.dart';

import '../HomePage/HomePage.dart';
import '../Response_Files/IssueResponse/Isssue_additem_SRNO_Response.dart';
import '../Response_Files/IssueResponse/Issue_ItemListing_Response.dart';
import '../Response_Files/IssueResponse/ItemDelete_Response.dart';
import '../Response_Files/IssueResponse/SaveItemIssue_Response.dart';
import '../Response_Files/IssueResponse/SelectCategoryIssue_Response.dart';
import '../Response_Files/IssueResponse/docNo_Response.dart';
import '../Response_Files/Material_Receipt_Response/MaterialReceipt_ItemData_Response.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'package:http/http.dart' as http;
import 'Material_Receipt_EntryList.dart';
import 'Material_Recepit_ItemDetails_Form.dart';
import 'ScannerForReceipt.dart';

class MaterialIssue_TabPage extends StatefulWidget {
  @override
  State<MaterialIssue_TabPage> createState() => _MaterialIssue_TabPageState();
}

class _MaterialIssue_TabPageState extends State<MaterialIssue_TabPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: kMainColor,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kMainColor,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Material_Receipt_EntryList(),
                    ));
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Material Issue',
            maxLines: 2,
            style: kTextStyle.copyWith(color: Colors.white, fontSize: 20.0),
          ),
          // actions:  [
          //   // Image(
          //   //   image: AssetImage('assets/images/notificationicon.png'),
          //   // ),
          // ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.transparent,
            tabs: [
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.home,
                      color: _tabController.index == 0
                          ? Colors.orange
                          : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Main Details',
                      style: TextStyle(
                        color: _tabController.index == 0
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
              Tab(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.list,
                      color: _tabController.index == 1
                          ? Colors.orange
                          : Colors.grey,
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Item Details',
                      style: TextStyle(
                        color: _tabController.index == 1
                            ? Colors.orange
                            : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            Material_Issue_MainForm(tabController: _tabController),
            //Material_Receipt_ItemList(tabController: _tabController),
          ],
        ),
      ),
    );
  }
}

class Material_Issue_MainForm extends StatefulWidget {
  final TabController tabController;
  Material_Issue_MainForm({Key? key, required this.tabController})
      : super(key: key);

  @override
  _Material_Issue_MainFormState createState() =>
      _Material_Issue_MainFormState();
}

class _Material_Issue_MainFormState extends State<Material_Issue_MainForm> {
  bool isChecked = false;

  @override
  void initState() {
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
      body: Container(
        height: MediaQuery.of(context).size.height,
        padding: EdgeInsets.all(20.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
          color: Colors.white,
        ),
        child: SingleChildScrollView(
          child: Column(
            //mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  //  controller: _emailController,
                  initialValue: "Internal",
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),

                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Issue Type'),
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
                  initialValue: "Issue",
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
                  readOnly: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      postfixIcon: Icon(
                        Icons.date_range,
                        size: 30,
                      ),
                      hintText: '',
                      labelText: '20-03-2024'),
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
                  initialValue: "Production",
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Issue to department'),
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
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Billing Address'),
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
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
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
                Container(
                  // width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color:
                      kBorderColorTextField, // Define this color elsewhere in your code
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: CheckboxListTile(
                    title: Text("Auto Generate"),
                    value: isChecked,
                    activeColor: kMainColor,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, // Aligns the checkbox to the leading edge
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  // width: 300,
                  height: 60,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color:
                      kBorderColorTextField, // Define this color elsewhere in your code
                      width: 3.0,
                    ),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: CheckboxListTile(
                    title: Text("Manual E-way bill Generate"),
                    value: isChecked,
                    activeColor: kMainColor,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue ?? false;
                      });
                    },
                    controlAffinity: ListTileControlAffinity
                        .leading, // Aligns the checkbox to the leading edge
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                TextFormField(
                  //  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: inputDecoration(
                      focusedBorder: myfocusborder(),
                      enabledBorder: myinputborder(),
                      //   prefixIcon: Icon(Icons.email_outlined),
                      hintText: '',
                      labelText: 'Pin to pin distance(KMS)'),
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
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 15.0, right: 15.0, top: 0, bottom: 10),
        child: InkWell(
          onTap: () {
            setState(() {
              widget.tabController.animateTo(1);
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

class Material_Receipt_ItemList extends StatefulWidget {
  String Urn,status;
  var CategoryCode, categoryName, docNo, barcoderes;
  Material_Receipt_ItemList(
      {Key? key,
        required this.Urn,
        required this.status,
        this.CategoryCode,
        this.categoryName,
        this.docNo,
        this.barcoderes})
      : super(key: key);
  @override
  State<Material_Receipt_ItemList> createState() => _Material_Receipt_ItemListState();
}

class _Material_Receipt_ItemListState extends State<Material_Receipt_ItemList> {
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
      if(widget.barcoderes!=null ){
        GridDataAdd("");
      }else{
        fetchdata("");
      }

      /*GetLocation("");
      CategoryController.text = widget.categoryName ?? "";
      CategoryCode = widget.CategoryCode.toString();
      docNo = widget.docNo ?? "";*/
    }));
    log(widget.Urn);

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
                builder: (context) => const Material_Receipt_EntryList()));
      },
      child: Scaffold(
        backgroundColor: kMainColor,
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: kMainColor,
          leading: IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Material_Receipt_EntryList(),
                    ));
              },
              icon: Icon(Icons.arrow_back)),
          elevation: 0.0,
          titleSpacing: 0.0,
          iconTheme: IconThemeData(color: Colors.white),
          title: Text(
            'Material Receipt',
            maxLines: 2,
            style: kTextStyle.copyWith(color: Colors.white, fontSize: 20.0),
          ),
        ),
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
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Urn: ${widget.Urn}"),
                    ),
                    Expanded(
                        child: Divider(
                          color: Colors.black,
                        )),
                  ]),
                ),
               /*
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CupertinoSearchTextField(
                      //controller: controller,
                      onChanged: (value) {
                        fetchdata(value.toString());
                      },
                      onSubmitted: (value) {},
                      autocorrect: true,
                    )),*/
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
                                    if(widget.barcoderes!=null || widget.barcoderes!=""){
                                      GridDataAdd("");
                                    }else{
                                      fetchdata("");
                                    }
                                    _delete(
                                        context,
                                        DoPandingListData
                                            .data[index].index);
                                  });
                                  // final bool res = await showDialog(
                                  //     context: context,
                                  //     builder: (BuildContext context) {
                                  //       return Container();
                                  //     });
                                  // return res;
                                } else {
                                  if(widget.barcoderes!=null){
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Material_Recepit_ItemDetails_Form(
                                                    FormData:
                                                    DoPandingListData.data[
                                                    index],
                                                    Urn: widget.Urn,
                                                    CategoryCode:
                                                    CategoryCode,
                                                    categoryName:
                                                    CategoryController
                                                        .text
                                                        .toString(),
                                                    docNo: docNo,status:widget.status,barCodeRes:widget.barcoderes)));
                                  }else{
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Material_Recepit_ItemDetails_Form(
                                                    FormData:
                                                    DoPandingListData.data[
                                                    index],
                                                    Urn: widget.Urn,
                                                    CategoryCode:
                                                    CategoryCode,
                                                    categoryName:
                                                    CategoryController
                                                        .text
                                                        .toString(),
                                                    docNo: docNo,status:widget.status)));
                                  }

                                  if(widget.barcoderes!=null || widget.barcoderes!=""

                                  ){
                                    GridDataAdd("");
                                  }else{
                                    fetchdata("");
                                  }
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
                                            color:/*double.parse(DoPandingListData.data[index].stock??"0.0")<=0?Colors.red:*/ kMainColor,
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
                                                    child: Column(
                                                      children: [
                                                        Padding(
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
                                                        ),
                                                      ],
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
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .all(5.0),
                                                    child: Text(
                                                      DoPandingListData
                                                          .data[
                                                      index]
                                                          .soNo.toString() ??
                                                          "---",
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                      style: TextStyle(
                                                          fontWeight:
                                                          FontWeight
                                                              .bold,
                                                          color: Colors
                                                              .green,
                                                          fontSize:
                                                          14),
                                                    ),
                                                  ),
                                                ),
                                                ///////////
                                              ],
                                            ),
                                            Row(
                                              // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                              children: [

                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets
                                                        .all(5.0),
                                                    child: RichText(
                                                      text: TextSpan(
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                            "Item: ",
                                                            style:
                                                            TextStyle(
                                                              fontWeight:
                                                              FontWeight.bold,
                                                              color: Colors
                                                                  .green,
                                                              fontSize:
                                                              14,
                                                            ),
                                                          ),
                                                          TextSpan(
                                                            text: DoPandingListData
                                                                .data[index]
                                                                .itemName ??
                                                                "---",
                                                            style:
                                                            TextStyle(
                                                              fontWeight:
                                                              FontWeight.w500,
                                                              color: Colors
                                                                  .black,
                                                              fontSize:
                                                              14,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      overflow:
                                                      TextOverflow
                                                          .ellipsis,
                                                    ),
                                                  ),
                                                ),
                                                ///////////
                                              ],
                                            ),
                                            Row(
                                              crossAxisAlignment:
                                              CrossAxisAlignment
                                                  .center,
                                              //    mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                                                              "Process",
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
                                                              .process ??
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
                                                              "Quantity",
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
                                                            0),
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
                                              ],
                                            ),
                                            Row(
                                              //crossAxisAlignment: CrossAxisAlignment.center,
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
                                                              "Unit",
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
                                                              .unit ??
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
                                                              "Location",
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
                                                              .location ??
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
                                              //crossAxisAlignment: CrossAxisAlignment.center,
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
                                                              "Stock",
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
                                                              .stock ??
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
                                                              "remarks",
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
                                                              .remarks ??
                                                              "---",
                                                          overflow:
                                                          TextOverflow
                                                              .ellipsis,
                                                          style: TextStyle(
                                                              fontWeight:
                                                              FontWeight
                                                                  .w400,
                                                              color: /*double.parse(DoPandingListData.data[index].stock??"0")<=0?Colors.red:*/Colors
                                                                  .black,
                                                              fontSize:
                                                              13),
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
                        : Text("No Data"))
              ],
            )),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => ScannerForReceipt(menuName: widget.Urn,)));
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
        bottomNavigationBar: Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 5.0, right: 15.0, top: 0, bottom: 10),
          child: InkWell(
            onTap: () {
              setState(() {
                log(CategoryCode.toString());
                // if (CategoryCode != "null"&& CategoryCode != "" && CategoryCode != null) {
                  bool hasInsufficientStock = false;
                  for (int i = 0; i < DoPandingListData.data.length; i++) {
                    var tempstock;
                    if(DoPandingListData.data[i].stock!=""){
                      tempstock=DoPandingListData.data[i].stock;
                    } else{
                      tempstock='0.0';
                    }
                    // if (double.parse(
                    //     tempstock) <=
                    //     0) {
                    //   hasInsufficientStock = true;
                    //   AwesomeDialog(
                    //     btnCancelColor: Colors.black,
                    //     btnOkColor: kMainColor,
                    //     btnOkText: "Yes",
                    //     context: context,
                    //     borderSide: const BorderSide(
                    //       color: kMainColor,
                    //       width: 2,
                    //     ),
                    //     width: double.infinity,
                    //     buttonsBorderRadius: const BorderRadius.all(
                    //       Radius.circular(2),
                    //     ),
                    //     dismissOnTouchOutside: true,
                    //     dismissOnBackKeyPress: false,
                    //     headerAnimationLoop: false,
                    //     animType: AnimType.bottomSlide,
                    //     title: "Warning!!",
                    //     desc:
                    //     "You don't have enough stock in SRNO ${DoPandingListData.data[i].soNo} ,\n ITEM: ${DoPandingListData.data[i].itemName}",
                    //     descTextStyle: const TextStyle(fontSize: 17),
                    //     showCloseIcon: false,
                    //     btnCancelOnPress: () {},
                    //     btnOkOnPress: () {},
                    //   ).show();
                    //   break; // Exit the loop since we've found an item with insufficient stock
                    // }

                  }
// If no insufficient stock found, call SaveData
                UpdateMaterialReceiptData();


                    //SaveData();


                // } else {
                //   Fluttertoast.showToast(
                //     msg: "Please Select Category",
                //     textColor: Colors.white,
                //     backgroundColor: Colors.red,
                //     gravity: ToastGravity.CENTER,
                //   );
                // }
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

  Future<SelectCategoryIssueResponse> GetLocation(SearchText) async {
    Map data = {
      "UR_CODE": urCode,
      "Select_Valuecode": "",
      "Searchtext": SearchText,
      "CO_CODE": coCode,
    };
    setState(() {
      isLoading = true;
    });
    final response = await http.post(
      Uri.parse("${clientUrl}TechFlow/SelectionIssueCategory"),
      body: data,
    );
    log("${clientUrl}TechFlow/SelectionIssueCategory$data");
    log(response.body.toString());
    setState(() {
      isLoading = false;
    });
    var jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        LocationResponseData = SelectCategoryIssueResponse.fromJson(map);
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

  // Future<void> SaveData() async {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   var BODYDATA = {
  //     "Receipt_Type":"",
  //     "Category":"RECEIPT",
  //     "Receipt_Date":"RECEIPT",
  //     "Receipt_From":"RECEIPT",
  //     "Eway_Bill_No":"RECEIPT",
  //     "Eway_Bill_Date":"RECEIPT",
  //     'CO_CODE': coCode,
  //     'Urn_no': widget.Urn,
  //     'UR_CODE': urCode,
  //     'DOC_NO': docNo.toString(),
  //     'DB_CODE': CategoryCode.toString(),
  //     'Party': CategoryCode.toString(),
  //   };
  //   log("Api Name: ${clientUrl}/TechFlow/UpdateMaterialReceiptData $BODYDATA");
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
  //               builder: (context) => Material_Receipt_EntryList(),
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

  Future<void> SaveData(Generate) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_Code': coCode,
      'UR_CODE': urCode,
      'Urn_No': widget.Urn,
      'Status': "Not Approved",
      'Remark': "",
      'EntrySRno': "",
    };
    log("Api Name: ${clientUrl}/MaterialReceipt/MaterialReceiptUpdateStatus $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/MaterialReceipt/MaterialReceiptUpdateStatus"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/MaterialReceipt/MaterialReceiptUpdateStatus $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = SaveItemIssueResponse.fromJson(map);

      if (urnResData.settings.success == "1") {
          if(Generate!=""){
            GenerateNextProcess();
          }
          setState(() {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Material_Receipt_EntryList(),
                ));
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
            btnOkOnPress: () {},
          ).show();
        });
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
  Future<void> UpdateMaterialReceiptData() async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_CODE': coCode,
      'Urn_no': widget.Urn,
      'UR_CODE': urCode,
    };
    log("Api Name: ${clientUrl}/MaterialReceipt/UpdateMaterialReceiptData $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/MaterialReceipt/UpdateMaterialReceiptData"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/MaterialReceipt/UpdateMaterialReceiptData $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = SaveItemIssueResponse.fromJson(map);

      if (urnResData.settings.success == "1") {

        SaveData("");

      } else {
        setState(() {

          //SaveData("");
          AwesomeDialog(
            btnCancelColor: Colors.black,
            btnOkColor: kMainColor,
            btnOkText: "Yes",
            btnCancelText: "No",
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
            desc: urnResData.message,
            descTextStyle: const TextStyle(fontSize: 17),
            showCloseIcon: false,
            btnCancelOnPress: () {
              //UpdateMaterialReceiptData("");
              SaveData("");
            },
            btnOkOnPress: () {
              //UpdateMaterialReceiptData("Generate");
              SaveData("Generate");
            },
          ).show();
        });

      }
    } else {

    }
  }

  Future<void> GenerateNextProcess() async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'Co_Code': coCode,
      'UR_CODE': urCode,
      'URN_No': widget.Urn,
    };
    log("Api Name: ${clientUrl}/MaterialReceipt/AutoProductionOrder $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}/MaterialReceipt/AutoProductionOrder"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}/MaterialReceipt/AutoProductionOrder $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (!mounted) return;
    setState(() {
      isLoading = false;
    });
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      var map = Map<String, dynamic>.from(jsonData);
      var urnResData = SaveItemIssueResponse.fromJson(map);

      if (urnResData.settings.success == "1") {
        setState(() {
          //SaveData("");
          Fluttertoast.showToast(
            msg: urnResData.message,
            textColor: Colors.white,
            backgroundColor: Colors.green,
            gravity: ToastGravity.BOTTOM,
          );
        });
      } else {

      }
    } else {

    }
  }

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
      'urn_no': widget.Urn,
      'Sr_No': srNo,
    };
    log("Api Name: ${clientUrl}MaterialReceipt/MaterialReceiptGridDataDelete $BODYDATA");
    final response = await http.post(
      Uri.parse("${clientUrl}MaterialReceipt/MaterialReceiptGridDataDelete"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}MaterialReceipt/MaterialReceiptGridDataDelete $BODYDATA");
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
        if(widget.barcoderes!=null || widget.barcoderes!=""){
          GridDataAdd("");
        }else{
          fetchdata("");
        }
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
      'UrnNo': widget.Urn.toString(),
      'UR_CODE': urCode,
      'Co_Code':coCode
    };
    final response = await http.post(
      Uri.parse("${clientUrl}MaterialReceipt/MaterialReceiptGridDataDetails"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}MaterialReceipt/MaterialReceiptGridDataDetails $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        isLoading = false;
        DoPandingListData = MaterialReceiptItemDataResponse.fromJson(map);

        /* bool hasInsufficientStock = false;
// First loop to check for any insufficient stock
        for (int i = 0; i < DoPandingListData.data.length; i++) {
          var tempstock;
          if(DoPandingListData.data[i].stock!=""){
            tempstock=DoPandingListData.data[i].stock;
          } else{
            tempstock='0.0';
          }
          if (double.parse(tempstock) <= 0) {
            hasInsufficientStock = true;
            AwesomeDialog(
              btnCancelColor: Colors.black,
              btnOkColor: kMainColor,
              btnOkText: "Yes",
              context: context,
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
              desc:
              "You don't have enough stock in SRNO ${DoPandingListData.data[i].srNo} ,\n ITEM: ${DoPandingListData.data[i].itemName}",
              descTextStyle: const TextStyle(fontSize: 17),
              showCloseIcon: false,
              btnCancelOnPress: () {},
              btnOkOnPress: () {},
            ).show();
            break; // Exit the loop since we've found an item with insufficient stock
          }

        }
// If no insufficient stock found, call SaveData
        if (!hasInsufficientStock) {
          SaveData();
        }*/

      });
      if (DoPandingListData.settings.success == "1") {
        setState(() {
          isLoading = false;
          // DoPandingListData.data.sort((a, b) {
          //   int stockA = int.tryParse(a["Stock"]) ?? 0;
          //   int stockB = int.tryParse(b["Stock"]) ?? 0;
          //   return stockA.compareTo(stockB);
          // });
          // log(DoPandingListData);
        });
      } else {
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

  Future<void> GridDataAdd(SearchText) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'URN_No': widget.Urn.toString(),
      'UR_CODE': urCode,
      'CO_CODE':coCode,
      'URN_SR_No':widget.barcoderes,
    };
    final response = await http.post(
      Uri.parse("${clientUrl}MaterialReceipt/MaterialReceiptGridDataAdd"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}MaterialReceipt/MaterialReceiptGridDataAdd $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      setState(() {
        isLoading = false;
        DoPandingListData = MaterialReceiptItemDataResponse.fromJson(map);

        /* bool hasInsufficientStock = false;
// First loop to check for any insufficient stock
        for (int i = 0; i < DoPandingListData.data.length; i++) {
          var tempstock;
          if(DoPandingListData.data[i].stock!=""){
            tempstock=DoPandingListData.data[i].stock;
          } else{
            tempstock='0.0';
          }
          if (double.parse(tempstock) <= 0) {
            hasInsufficientStock = true;
            AwesomeDialog(
              btnCancelColor: Colors.black,
              btnOkColor: kMainColor,
              btnOkText: "Yes",
              context: context,
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
              desc:
              "You don't have enough stock in SRNO ${DoPandingListData.data[i].srNo} ,\n ITEM: ${DoPandingListData.data[i].itemName}",
              descTextStyle: const TextStyle(fontSize: 17),
              showCloseIcon: false,
              btnCancelOnPress: () {},
              btnOkOnPress: () {},
            ).show();
            break; // Exit the loop since we've found an item with insufficient stock
          }

        }
// If no insufficient stock found, call SaveData
        if (!hasInsufficientStock) {
          SaveData();
        }*/

      });
      if (DoPandingListData.settings.success == "1") {
        setState(() {
          isLoading = false;
          // DoPandingListData.data.sort((a, b) {
          //   int stockA = int.tryParse(a["Stock"]) ?? 0;
          //   int stockB = int.tryParse(b["Stock"]) ?? 0;
          //   return stockA.compareTo(stockB);
          // });
          // log(DoPandingListData);
        });
      } else {
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

  Future<void> GetURN(BarcodeRes) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'DB_CODE': "${BarcodeRes}",
      'UR_CODE': urCode,
      'URN_No': widget.Urn,
      'CO_CODE': coCode,
    };
    final response = await http.post(
      Uri.parse("${clientUrl}TechFlow/SelectionIssueCategoryDocNo"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}TechFlow/SelectionIssueCategoryDocNo $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      var DoPandingListData = DocNoResponse.fromJson(map);
      if (DoPandingListData.settings.success == "1") {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        setState(() {
          docNo = DoPandingListData.data[0].docNo.toString();
          if (docNo!.isNotEmpty) {
            Navigator.pop(context);
          }
        });
      } else {
        if (!mounted) return;
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
