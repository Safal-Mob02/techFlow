// import 'package:country_code_picker/country_code_picker.dart';
// ignore_for_file: library_private_types_in_public_api

import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

import '../HomePage/HomePage.dart';
import '../Response_Files/Username_Password_response.dart';
import '../Utils/constants.dart';
import '../Utils/global_buttons.dart';
import '../Utils/sharedpreeferences_utils.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final TextEditingController userName = TextEditingController();
  final TextEditingController passwordName = TextEditingController();
  bool isChecked = false;
  final _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  String userid = '';
  String urnId = '';
  String urnPsw = '';

  String? clientUrl;

  String? user;

  String? pswd;

  bool _passwordVisible = false;

  Future<void> _LogIn() async {
    // _formKey.currentState!.save();
    if (isLoading) {
      return;
    }
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });
    try {
      var data = {
        'Username': user.toString(),
        'Password': pswd.toString(),
      };
      final response = await http.post(
        Uri.parse("https://erp.techflow.net/API/MobileApp/TechFlow/Login"),
        body: data,
      );
      log("Api Name: https://erp.techflow.net/API/MobileApp/TechFlow/Login $data");
      log("Response Status Code: ${response.statusCode}");
      log("Response Body: ${response.body}");
      if (response.statusCode == 200) {
        
        var jsonData = json.decode(response.body);
        var map = Map<String, dynamic>.from(jsonData);
        var loginResponse = LoginUserPasswordResponse.fromJson(map);

        if (loginResponse.settings.success == "1") {
          if (!mounted) return;
          setState(() {
            isLoading = false;
          });
          // PreferenceManager.instance.setStringValue("urCode", loginResponse.data[0].urCode.toString());
          // PreferenceManager.instance.setStringValue("UserName", loginResponse.data[0].username.toString());

          setState(() {
            PreferenceManager.instance.setBooleanValue("LoginAuth", true);
            // PreferenceManager.instance.setStringValue("clientUrl", "https://erp.techflow.net/API/MobileAppTestTests/");
            PreferenceManager.instance.setStringValue(
                "urCode", loginResponse.data[0].urCode.toString());
            PreferenceManager.instance.setStringValue(
                "coCode", loginResponse.data[0].coCode.toString());
            PreferenceManager.instance.setStringValue(
                "username", loginResponse.data[0].username.toString());
            PreferenceManager.instance.setStringValue(
                "clientUrl", "https://erp.techflow.net/API/MobileApp/");
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const HomeScreen()));
            Fluttertoast.showToast(
              msg: loginResponse.settings.message,
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
          // Show an error toast message
          Fluttertoast.showToast(
            msg: "Login failed. ${loginResponse.settings.message}",
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
    } catch (error) {
      print("Error: $error");

      Fluttertoast.showToast(
        msg: "An error occurred, please try again.",
        textColor: Colors.white,
        backgroundColor: Colors.red,
        gravity: ToastGravity.CENTER,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
  }
  /*@override
  void initState() {
    // TODO: implement initState
    super.initState();
    PreferenceManager preferenceManager = PreferenceManager.instance;
    setState(() {
      preferenceManager
          .getStringValue("clientUrl")
          .then((value) => setState(() {
        clientUrl = value;
      }));
    });
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: kMainColor,
      appBar: AppBar(
        backgroundColor: kMainColor,
        //leading:
        // IconButton(onPressed: () {}, icon: const Icon(Icons.arrow_back)),
        elevation: 0.0,
        // iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Sign In',
          style: kTextStyle.copyWith(
              color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: SizedBox(
              height: 120,
              width: 120,
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Image(
                      fit: BoxFit.fill, image: AssetImage('Assets/logo.png')),
                ),
                // backgroundImage: AssetImage('assets/images/Ktex_Logo.png'),
              ),
            ),
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Container(
                    padding: const EdgeInsets.all(20.0),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight: Radius.circular(30.0)),
                      color: Colors.white,
                    ),
                    child: isLoading
                        ? Center(
                            child: Lottie.asset(
                              'Assets/loading.json',
                              width: 100,
                              height: 100,
                              fit: BoxFit.fill,
                            ),
                          )
                        : Form(
                            key: _formKey,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: TextFormField(
                                      controller: userName,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                          border: outlineInputBorder(),
                                          filled: true,
                                          labelText: "UserName",
                                          contentPadding:
                                              const EdgeInsets.only(left: 30.0),
                                          hintText: "Enter valid User Name"),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        user = value.toString();
                                        if (value == null || value.isEmpty)
                                        // ||
                                        // RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        //     .hasMatch(value))
                                        {
                                          return 'Please enter UserName';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  //padding: const EdgeInsets.only(left:15.0,right: 15.0,top:0,bottom: 0),
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  child: Padding(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: TextFormField(
                                      controller: passwordName,
                                      obscureText: !_passwordVisible,
                                      textAlign: TextAlign.left,
                                      decoration: InputDecoration(
                                          suffixIcon: IconButton(
                                            icon: Icon(
                                              // Based on passwordVisible state choose the icon
                                              _passwordVisible
                                                  ? Icons.visibility
                                                  : Icons.visibility_off,
                                              color: Theme.of(context)
                                                  .primaryColorDark,
                                            ),
                                            onPressed: () {
                                              // Update the state i.e. toogle the state of passwordVisible variable
                                              setState(() {
                                                _passwordVisible =
                                                    !_passwordVisible;
                                              });
                                            },
                                          ),
                                          border: outlineInputBorder(),
                                          filled: true,
                                          labelText: "Password",
                                          contentPadding:
                                              const EdgeInsets.only(left: 30.0),
                                          hintText: "Enter valid Password"),
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        pswd = value.toString();
                                        if (value == null || value.isEmpty)
                                        // ||
                                        // RegExp(r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$')
                                        //     .hasMatch(value))
                                        {
                                          return 'Please enter password';
                                        }
                                        return null;
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  height: 15,
                                ),
                                ButtonGlobal(
                                  buttontext: 'Login',
                                  buttonDecoration: kButtonDecoration.copyWith(
                                      color: kMainColor),
                                  onPressed: () {
                                    // Navigator.push(context,MaterialPageRoute(builder: (context) => HomeScreen(),));
                                    if (_formKey.currentState!.validate()) {
                                      _LogIn();
                                    } else {
                                      Fluttertoast.showToast(
                                        msg: "Please Fill Credentials!",
                                        textColor: Colors.white,
                                        backgroundColor: Colors.red,
                                        gravity: ToastGravity.BOTTOM,
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ))),
          ),
        ],
      ),
    );
  }
}
