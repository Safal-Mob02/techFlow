import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';


class Tools {
  BuildContext context;

  Tools(this.context);

  String capitalizeOnlyFirstLater(String string) {
    if (string.trim().isEmpty) return "";
    return "${string[0].toUpperCase()}${string.substring(1)}";
  }

  void ShowDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
      content: Row(children: [
        const CircularProgressIndicator(
          backgroundColor: Colors.red,
        ),
        Container(
            margin: const EdgeInsets.only(left: 10),
            child: const Text("Loading...")),
      ]),
    );

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void showProgressDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        backgroundColor: Colors.transparent,
        content: Row(mainAxisSize: MainAxisSize.min, children: [
          Center(
              child: Container(
            margin: const EdgeInsets.all(50),
            child: Lottie.asset(
              'Assets/loading.json',
              width: 100,
              height: 100,
              fit: BoxFit.fill,
            ),
          ))
        ]));

    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void stopLoading() {
    Navigator.of(context).pop();
  }

  bool isValidMobileNo(String value) {
    String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isValidMobileNumber(String value) {
    String pattern = r'^(?:[+0][1-9])?[0-9]{10,12}$';

    RegExp regExp = RegExp(pattern);
    return regExp.hasMatch(value);
  }

  bool isValidEmail(String email) {
    String p =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }

  bool isValidDomain(String email) {
    String p =
        r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?";
    RegExp regExp = RegExp(p);
    return regExp.hasMatch(email);
  }

  String getBase64FormateFile(String path) {
    File file = File(path);
    print('File is = ' + file.toString());
    List<int> fileInByte = file.readAsBytesSync();
    String fileInBase64 = base64Encode(fileInByte);
    return fileInBase64;
  }
}
