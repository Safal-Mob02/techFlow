// ignore_for_file: use_build_context_synchronously

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../utils/sharedpreeferences_utils.dart';
import '../HomePage/HomePage.dart';
import 'UserNamePasswordScreen.dart';

// ignore_for_file: library_private_types_in_public_api
class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    userValidate().whenComplete(() async {
      startTime();
    });
  }
  Future userValidate() async{
    PreferenceManager.instance
        .getBooleanValue("LoginAuth")
        .then((value) => setState(() {
      isLoggedIn = value;
    }));
  }

  startTime() {
    Timer.periodic(const Duration(milliseconds: 200), (timer) {
      if (!mounted) return;
      setState(() {
        if (_progress == 1) {
          timer.cancel();
          navigationPage();
        } else {
          _progress += 0.2;
        }
      });
    });
  }

  void navigationPage() {
    isLoggedIn
        ?  Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>  HomeScreen()))
        :  Navigator.pushReplacement(context,
        MaterialPageRoute(builder: (context) =>  SignIn()));
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height / 3,
            ),
            const Image(
              height: 200,
              width: 200,
              image: AssetImage('Assets/logo.png'),
            ),
            const Spacer(),
            Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: Text(
                  'Version 1.0.0',
                  style: GoogleFonts.manrope(
                      color: Colors.black,
                      fontWeight: FontWeight.normal,
                      fontSize: 15.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
