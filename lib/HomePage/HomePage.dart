// ignore_for_file: deprecated_member_use
import 'dart:developer';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';


import '../Inward/InwardListScreen.dart';
import '../Inward/Inward_TabPage.dart';
import '../LoginPages/UserNamePasswordScreen.dart';
import '../Material_Issue/Material_Issue_ListScreen.dart';
import '../Material_receipt/Material_Receipt_EntryList.dart';
import '../ProductionQC/ProductionQC_EntryList.dart';
import '../Purchase_QC/PurchaseQC_EntryList.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';

class HomeScreen extends StatefulWidget {

  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool isChecked = false;
var urCode;
  String? coCode;

  String? username;

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
        .getStringValue("username")
        .then((value) => setState(() {
  username = value;
      log(username.toString());
    }));

    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        confirmationDialog(context);
        return Future.value(false);
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
            'TechFlow',
            maxLines: 2,
            style: kTextStyle.copyWith(color: Colors.white, fontSize: 20.0),
          ),

        ),
        drawer: Drawer(
          child: Container(
            color: Colors.white,
            child: ListView(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child:  Column(
                    children: [
                      Center(
                        child: Column(
                          children: [
                            const SizedBox(
                              height: 10.0,
                            ),
                            const Center(
                              child: SizedBox(
                                height: 120,
                                width: 120,
                                child: CircleAvatar(
                                  backgroundColor: kMainColor,
                                  backgroundImage:
                                       AssetImage('Assets/profile.png'),
                                  // backgroundImage: AssetImage('assets/images/Ktex_Logo.png'),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Text(
                              "User: ${username??""}",
                              style: kTextStyle.copyWith(
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ),
                      const SizedBox(
                        height: 10.0,
                      ),
                      const Divider(
                        height: 3,
                        indent: 1,
                        endIndent: 1,
                        thickness: 4,
                        color: kMainColor,
                      )
                    ],
                  ),
                ),
                ListTile(
                  onTap: () {
                   // const ProfileScreen().launch(context);
                  },
                  title: Text(
                    'Profile',
                    style: kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                  leading: const Icon(
                    Icons.person,
                    color: kGreyTextColor,
                  ), trailing: const Icon(
                  Icons.arrow_forward_ios,
                  color: kGreyTextColor,
                ),
                ),
                ListTile(
                  onTap: () {
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
                      title: "LogOut",
                      autoHide: const Duration(seconds: 5),
                      //  dialogType: DialogType.info,
                      desc: 'Are you sure want to LogOut?',
                      descTextStyle: const TextStyle(fontSize: 17),
                      showCloseIcon: false,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                       PreferenceManager.instance.setBooleanValue("LoginAuth", false);
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const SignIn()));
                      },
                    ).show(); },
                  leading: const Icon(
                    FontAwesomeIcons.signOutAlt,
                    color: kGreyTextColor,
                  ),
                  title: Text(
                    'Logout',
                    style: kTextStyle.copyWith(color: kGreyTextColor),
                  ),
                  trailing: const Icon(
                    Icons.arrow_forward_ios,
                    color: kGreyTextColor,
                  ),
                ),
              ],
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20.0),
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30.0),
                      topRight: Radius.circular(30.0)),
                  color: Colors.white,
                ),
                child:
                ListView(
                  children: [
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => InwardListScreen(),));
                        },
                        child: Container(
                          width:MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: kMainColor,
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(image: AssetImage(
                                  'Assets/Inward.png'),
                                  width: 50,
                                  height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Inward',
                                  style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>  const Material_Issue_ListScreen(),));
                        },
                        child: Container(
                          width:MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: kMainColor,
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(image: AssetImage(
                                  'Assets/Material_issue.png'),
                                  width: 50,
                                  height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Issue',
                                  style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                           setState(() {
                             Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseQC_EntryList(),));
                           });
                        },
                        child: Container(
                          width:MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: kMainColor,
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(image: AssetImage(
                                  'Assets/Inward.png'),
                                  width: 50,
                                  height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Inward Qc',
                                  style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 8,
                    ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => ProductionQC_EntryList(),));
                          // const InquiryForm().launch(context);
                        },
                        child: Container(
                          width:MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: kMainColor,
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(image: AssetImage(
                                  'Assets/qc.png'),
                                  width: 50,
                                  height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Production Qc',
                                  style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    // Material(
                    //   elevation: 2.0,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //       // const InquiryForm().launch(context);
                    //     },
                    //     child: Container(
                    //       width:MediaQuery.of(context).size.width,
                    //       padding: const EdgeInsets.all(10.0),
                    //       decoration: const BoxDecoration(
                    //         border: Border(
                    //           left: BorderSide(
                    //             color: kMainColor,
                    //             width: 3.0,
                    //           ),
                    //         ),
                    //         color: Colors.white,
                    //       ),
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           const Image(image: AssetImage(
                    //               'Assets/grn.png'),
                    //               width: 50,
                    //               height: 50),
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Text(
                    //               'GRN',
                    //               style: kTextStyle.copyWith(
                    //                   color: kTitleColor,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    //
                    // const SizedBox(
                    //   height: 8,
                    // ),
                    Material(
                      elevation: 2.0,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => Material_Receipt_EntryList(),));
                         // const InquiryForm().launch(context);
                        },
                        child: Container(
                          width:MediaQuery.of(context).size.width,
                          padding: const EdgeInsets.all(10.0),
                          decoration: const BoxDecoration(
                            border: Border(
                              left: BorderSide(
                                color: kMainColor,
                                width: 3.0,
                              ),
                            ),
                            color: Colors.white,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const Image(image: AssetImage(
                                  'Assets/Material_receipt.png'),
                                  width: 50,
                                  height: 50),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  'Material Receipt',
                                  style: kTextStyle.copyWith(
                                      color: kTitleColor,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 8,
                    ),

                    // Material(
                    //   elevation: 2.0,
                    //   child: GestureDetector(
                    //     onTap: () {
                    //      // const InquiryForm().launch(context);
                    //     },
                    //     child: Container(
                    //       width:MediaQuery.of(context).size.width,
                    //       padding: const EdgeInsets.all(10.0),
                    //       decoration: const BoxDecoration(
                    //         border: Border(
                    //           left: BorderSide(
                    //             color: kMainColor,
                    //             width: 3.0,
                    //           ),
                    //         ),
                    //         color: Colors.white,
                    //       ),
                    //       child: Row(
                    //         crossAxisAlignment: CrossAxisAlignment.center,
                    //         children: [
                    //           const Image(image: AssetImage(
                    //               'Assets/po.png'),
                    //               width: 50,
                    //               height: 50),
                    //           Padding(
                    //             padding: const EdgeInsets.all(8.0),
                    //             child: Text(
                    //               'Purchase Order',
                    //               style: kTextStyle.copyWith(
                    //                   color: kTitleColor,
                    //                   fontWeight: FontWeight.bold),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    // const SizedBox(
                    //   height: 8,
                    // ),




                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  void confirmationDialog(BuildContext context) async {
    AwesomeDialog(
      btnCancelColor: Colors.black,
      btnOkColor: Colors.red,
      btnOkText: "Yes",
      context: context,
      // dialogType: DialogType.error,
      borderSide:  const BorderSide(
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
      title: "Exit?",
      autoHide: const Duration(seconds: 5),
      //  dialogType: DialogType.info,
      desc: 'Are you sure want to Exit?',
      descTextStyle: const TextStyle(fontSize: 17),
      showCloseIcon: false,
      btnCancelOnPress: () {

      },
      btnOkOnPress: () {
        SystemNavigator.pop();
      },
    ).show();

  }
}
