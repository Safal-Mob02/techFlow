// ignore_for_file: camel_case_types, no_logic_in_create_state, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, unnecessary_null_comparison, avoid_print, non_constant_identifier_names, must_be_immutable, file_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:http/http.dart'as http;
import 'package:lottie/lottie.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:techflowmobileapp/Utils/Tools.dart';

import '../Material_Issue/Material_Issue_ItemList.dart';
import '../ProductionQC/Producion_QC_Form_TAB_Page.dart';
import '../ProductionQC/ProductionQC_EntryList.dart';
import '../Response_Files/IssueResponse/add_To_pending_URN_Response.dart';
import '../Response_Files/PurchaseQC_Response/AddToPendingQCResponse.dart';
import '../Utils/constants.dart';
import '../Utils/sharedpreeferences_utils.dart';
import 'PurchaseQC_EntryList.dart';
import 'Purchase_QC_Form_TAB_Page.dart';



class ScannerForPurchaseQC extends StatefulWidget {
  var menuName;
  ScannerForPurchaseQC({Key? key,this.menuName}) : super(key: key);

  @override
  State<ScannerForPurchaseQC> createState() => _ScannerForPurchaseQCState();

}

class _ScannerForPurchaseQCState extends State<ScannerForPurchaseQC> {
  Barcode? result;
  late Tools tools;
  QRViewController? controller;
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  var response1;
  bool isLoading=false;
  String clientUrl='';
  final key= GlobalKey<FormState>();
  TextEditingController Reason =TextEditingController();
  TextEditingController toWhom =TextEditingController();
  TextEditingController visitorName =TextEditingController();
  TextEditingController visitorFrom =TextEditingController();
  String empID='';
  var formkey = GlobalKey<FormState>();
  String customerId='';
  String urnNO='';
  String entryExit='';

  String? urCode;

  var DoPandingListData;

  var coCode;


  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller!.pauseCamera();
    }
    controller!.resumeCamera();
  }
  @override
  void initState() {
    log(urnNO);
    PreferenceManager preferenceManager = PreferenceManager.instance;
    setState(() {
      preferenceManager.getStringValue("urCode").then((value) => setState(() {
        urCode = value;
      }));
      preferenceManager
          .getStringValue("clientUrl")
          .then((value) => setState(() {
        clientUrl = value;

      }));
      PreferenceManager.instance
          .getStringValue("coCode")
          .then((value) => setState(() {
        coCode = value;
        log(coCode.toString());
      }));
    });
    // TODO: implement initState
    super.initState();
    tools = Tools(context);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: kMainColor,
      body: Stack(
        children: [
          isLoading
              ? Center(
              child: Container(
                child: Lottie.asset(
                  'Assets/loading.json',
                  width: 100,
                  height: 100,
                  fit: BoxFit.fill,
                ),
              ))
              :_buildQrView(context), // QR scanner view
          Positioned(
            bottom: 20, // Adjust this value to position the Row vertically
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                _buildControlButton(
                  onPressed: () async {
                    await controller?.toggleFlash();
                    setState(() {});
                  },
                  icon: Icon(
                    controller?.getFlashStatus() == true ? Icons.flash_off : Icons.flash_on,
                    color: kMainColor,
                  ),
                  label: 'Flash',
                ),
                _buildControlButton(
                  onPressed: () async {
                    await controller?.flipCamera();
                    setState(() {});
                  },
                  icon: controller?.getCameraInfo() != null
                      ? const Image(
                    image: AssetImage('Assets/rotate.png'),
                    color: kMainColor,
                    height: 25,
                    width: 25,
                  )
                      : const Text('loading'),
                  label: 'Rotate',
                ),
                _buildControlButton(
                  onPressed: () async {
                    await controller?.pauseCamera();
                  },
                  icon: const Icon(Icons.pause, color: kMainColor),
                  label: 'Pause',
                ),
                _buildControlButton(
                  onPressed: () async {
                    await controller?.resumeCamera();
                  },
                  icon: const Icon(Icons.play_circle, color: kMainColor),
                  label: 'Start',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildControlButton({
    required VoidCallback onPressed,
    required Widget icon,
    required String label,
  }) {
    return Flexible(
      child: Container(
        margin: const EdgeInsets.all(8),
        child: Column(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all(CircleBorder(side: BorderSide(style: BorderStyle.solid, color: kMainColor))),
                backgroundColor: MaterialStateProperty.all(Colors.white),
              ),
              onPressed: onPressed,
              child: icon,
            ),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w400,color: Colors.white)),
          ],
        ),
      ),
    );
  }
  Widget _buildQrView(BuildContext context) {
    var scanArea = (MediaQuery.of(context).size.width < 400 ||
        MediaQuery.of(context).size.height < 400)
        ? 150.0
        : 300.0;
    return QRView(
      key: qrKey,
      onQRViewCreated: _onQRViewCreated,
      overlay: QrScannerOverlayShape(
          borderColor: kMainColor,
          borderRadius: 10,
          borderLength: 30,
          borderWidth: 10,
          cutOutSize: scanArea),
      onPermissionSet: (ctrl, p) => _onPermissionSet(context, ctrl, p),
    );
  }

  void _onPermissionSet(BuildContext context, QRViewController ctrl, bool p) {
    log('${DateTime.now().toIso8601String()}_onPermissionSet $p');
    if (!p) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('no Permission')),
      );
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
  void _onQRViewCreated(QRViewController controller) {
    setState(() {
      this.controller = controller;
    });
    controller.scannedDataStream.listen((scanData) {
      result = scanData;
      log(result!.code.toString());
      var barcodeResponse =result!.code.toString();
      setState(() {
        if(barcodeResponse!=""){
          controller!.stopCamera();
          log("Barcode Response::::>>>  "+barcodeResponse);
          setState(() {
            // if(widget.menuName=="PurchaseQC"){
            //
            //   GetURN_FOR_PurchaceQC(barcodeResponse);
            // }else{
            //   GetURN_FOR_ProductionQC(barcodeResponse);
            // }

            if(widget.menuName=="PurchaseQC"){

              QCInwardQRCheck(barcodeResponse);
            }else{
              GetURN_FOR_ProductionQC(barcodeResponse);
            }

            // if (barcodeResponse.startsWith('P')) {
            //   setState(() {
            //     GetURN_FOR_PurchaceQC(barcodeResponse);
            //   });
            //
            // } else if (barcodeResponse.startsWith('S')) {
            //   setState(() {
            //     GetURN_FORS(barcodeResponse);
            //   });
            //
            // }
          });


          // setState(() {
          //  // log(serialNumber.toString(),width.toString(),length.toString(),colour.toString(),qty.toString());
          //   String? serialNumber = extractRollNumber(barcodeResponse);
          //   String? width = Width(barcodeResponse);
          //   String? length = Length(barcodeResponse);
          //   String? colour = Colour(barcodeResponse);
          //   String? qty = Qty(barcodeResponse);
          //  // Scann(serialNumber.toString(),width.toString(),length.toString(),colour.toString(),qty.toString());
          // });
        }
      });
    });
  }
  String extractRollNumber(String input) {
    // Define the pattern to find the Roll No
    RegExp regex = RegExp(r'Roll No :(\w+)');

    // Use firstMatch to find the first occurrence of the pattern
    Match? match = regex.firstMatch(input);

    if (match != null) {
      // Extract the roll number from the matched group
      String rollNumber = match.group(1)!;
      return rollNumber;
    } else {
      // Return an empty string or handle the case where Roll No is not found
      return "";
    }
  }
  String Width(String input) {
    // Define the pattern to find the Roll No
    RegExp regex = RegExp(r'Width :(\w+)');

    // Use firstMatch to find the first occurrence of the pattern
    Match? match = regex.firstMatch(input);

    if (match != null) {
      // Extract the roll number from the matched group
      String Width = match.group(1)!;
      return Width;
    } else {
      // Return an empty string or handle the case where Roll No is not found
      return "";
    }
  }
  String Colour(String input) {
    // Define the pattern to find the Roll No
    RegExp regex = RegExp(r'Colour :(\w+)');

    // Use firstMatch to find the first occurrence of the pattern
    Match? match = regex.firstMatch(input);

    if (match != null) {
      // Extract the roll number from the matched group
      String Colour = match.group(1)!;
      return Colour;
    } else {
      // Return an empty string or handle the case where Roll No is not found
      return "";
    }
  }
  String Qty(String input) {
    // Define the pattern to find the Roll No
    RegExp regex = RegExp(r'Qty. :(\w+)');

    // Use firstMatch to find the first occurrence of the pattern
    Match? match = regex.firstMatch(input);

    if (match != null) {
      // Extract the roll number from the matched group
      String Qty = match.group(1)!;
      return Qty;
    } else {
      // Return an empty string or handle the case where Roll No is not found
      return "";
    }
  }
  String Length(String input) {
    // Define the pattern to find the Roll No
    RegExp regex = RegExp(r'Length. :(\w+)');

    // Use firstMatch to find the first occurrence of the pattern
    Match? match = regex.firstMatch(input);

    if (match != null) {
      // Extract the roll number from the matched group
      String Length = match.group(1)!;
      return Length;
    } else {
      // Return an empty string or handle the case where Roll No is not found
      return "";
    }
  }
  Future<void> GetURN_FOR_PurchaceQC(BarcodeRes) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'urn_no': "${BarcodeRes}",
      'user_id': urCode,
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCToAnalysis"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCToAnalysis $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      var DoPandingListData = AddToPendingQcResponse.fromJson(map);
      if (DoPandingListData.settings.success == "1") {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        setState(() {
          String Urn =DoPandingListData.data[0].urnNo.toString();
          log(Urn);
          controller!.stopCamera();
          if(Urn.isNotEmpty){
            Navigator.push(context, MaterialPageRoute(builder: (context) => Purchase_QC_Form_TAB_Page(Urn: Urn,)));
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        Fluttertoast.showToast(
          msg: DoPandingListData.settings.message??"NO Data Available",
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
  Future<void> GetURN_FOR_ProductionQC(BarcodeRes) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'urn_no': "${BarcodeRes}",
      'user_id': urCode,
      'Co_Code':coCode
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCToProduction"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCToProduction $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      if (jsonData['settings']['success']=="0"){

        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text(jsonData['settings']["message"] ?? "Invalid Data"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {


                    Navigator.push(context, MaterialPageRoute(builder: (context) => PurchaseQC_EntryList(),));// Close the dialog
                  },
                ),
              ],
            );
          },
        );
        // Fluttertoast.showToast(
        //   msg: jsonData['settings']["message"]??"NO Data Available",
        //   textColor: Colors.white,
        //   backgroundColor: Colors.red,
        //   gravity: ToastGravity.CENTER,
        // );
      }
      var DoPandingListData = AddToPendingQcResponse.fromJson(map);
      if (DoPandingListData.settings.success == "1") {
        if (!mounted) return;
        setState(() {
          isLoading = false;
        });
        setState(() {
          String Urn =DoPandingListData.data[0].urnNo.toString();
          log(Urn);
          controller!.stopCamera();

          if(Urn.isNotEmpty){

            Navigator.push(context, MaterialPageRoute(builder: (context) => Producion_QC_Form_TAB_Page(Urn: Urn,)));
          }
        });
      } else {
        setState(() {
          isLoading = false;
        });
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Message"),
              content: Text(DoPandingListData.settings.message ?? "Invalid Data"),
              actions: [
                TextButton(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => ProductionQC_EntryList(),));// Close the dialog
                  },
                ),
              ],
            );
          },
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

  Future<void> QCInwardQRCheck(BarcodeRes) async {
    setState(() {
      isLoading = true;
    });
    var BODYDATA = {
      'CO_CODE':coCode,
      'UR_CODE': urCode,
      'recordlength': "",
      'Searchtext': "",
      'startrecordno': "0",
      'RefNo': "${BarcodeRes}",
    };
    final response = await http.post(
      Uri.parse("${clientUrl}QC/QCInwardQRCheck"),
      body: BODYDATA,
    );
    log("Api Name: ${clientUrl}QC/QCInwardQRCheck $BODYDATA");
    log("Response Status Code: ${response.statusCode}");
    log("Response Body: ${response.body}");
    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      log(jsonData.toString());
      var map = Map<String, dynamic>.from(jsonData);
      //var DoPandingListData = AddToPendingQcResponse.fromJson(map);
      if ( map["settings"]["success"] == "1") {
        // if (!mounted) return;
        // setState(() {
        //   isLoading = false;
        // });
        // setState(() {
        //   String Urn =DoPandingListData.data[0].urnNo.toString();
        //   log(Urn);
        //   controller!.stopCamera();
        //   if(Urn.isNotEmpty){
        //     Navigator.push(context, MaterialPageRoute(builder: (context) => Purchase_QC_Form_TAB_Page(Urn: Urn,)));
        //   }
        // });

        GetURN_FOR_PurchaceQC(BarcodeRes);

      } else {
        setState(() {
          isLoading = false;
        });
        //Navigator.pop(context);
        //Navigator.pop(context);
        Fluttertoast.showToast(
          msg: map["settings"]["message"]??"QR is not available",
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
