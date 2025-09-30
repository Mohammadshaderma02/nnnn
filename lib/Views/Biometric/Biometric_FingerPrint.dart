import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'package:sales_app/Animation/FadeAnimation.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/Eshope_Menu.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/headerSection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/CustomBottomNavigationBar.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

import '../HomeScreens/Corporate/MainPages/newAccountsDocumentsChecking.dart';

class BiometricFingerPrint extends StatefulWidget {
  @override
  _BiometricFingerPrint createState() => _BiometricFingerPrint();
}

class _BiometricFingerPrint extends State<BiometricFingerPrint> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics;
  String autherized = "Not autherized";

  //checking bimetrics
  //this function will check the sensors and will tell us
  // if we can use them or not
  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _canCheckBiometrics = canCheckBiometric;
    });
  }

  //this function will get all the available biometrics inside our device
  //it will return a list of objects, but for our example it will only
  //return the fingerprint biometric
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometric;
    try {
      availableBiometric = await auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }

  void setBiometricLogedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('biomitric_is_logged_in', true);
  }

  Future<void> _authenticate() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool authenticated = false;
    try {
      authenticated = await auth.authenticate(
          localizedReason: "Scan your finger print to authenticate",
         );
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    if (mounted) {
      prefs.setBool('is_logged_in', false);
      prefs.setBool('biomitric_is_logged_in', false);
      prefs.setBool('TokenError', false);
      //prefs.remove("accessToken");
      //////prefs.remove("userName");
      //prefs.remove('counter');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    }
    setState(() {
      autherized =
          authenticated ? "Autherized success" : "Failed to authenticate";
      print(autherized);
      if (authenticated) {
        setBiometricLogedIn();
        if (prefs.get('role') == "Corporate") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CorpNavigationBar(
                PermessionCorporate: prefs.getStringList('Permessions'),
                role: prefs.get('role'),

              ),
            ),
          );
        } else if(prefs.get('role') == "DeliveryEShop") {
          Navigator.pushReplacement(
            context,
          /*  MaterialPageRoute(
              builder: (context) => OrdersScreen(),
            ),*/
            MaterialPageRoute(builder: (context) => Eshope_Menu()),
          );

        } else if(prefs.get('role') == "Reseller") {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => NewAccountDocumnetChecking(
                 prefs.getStringList('PermessionReseller'),
               prefs.get('role'),

              ),
            ),
          );

        }else{
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => CustomBottomNavigationBar(
                Permessions: prefs.getStringList('Permessions'),
                role: prefs.get('role'),
                outDoorUserName: prefs.get('outDoorUserName'),
              ),
            ),
          );
        }
      }
    });
  }

  @override
  void initState() {
    _checkBiometric();
    _getAvailableBiometrics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF008388), Color(0xFF4f2565)],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 40, //*
            ),
            HeaderSection(
              text: "Login_Form.language".tr().toString(),
            ),
            SizedBox(
              height: 40,
            ),
            Image(
                image: AssetImage('assets/images/Authenticate.png'),
                width: 184,
                height: 184),
            SizedBox(
              height: 20,
            ),
            Container(
              padding: EdgeInsets.all(25),
              child:   Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "FingerPrint_Form.authenticate_fingerprint"
                          .tr()
                          .toString()
                          .tr()
                          .toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(
                          top: 20, bottom: 30, left: 20, right: 20),
                      width: 250.0,
                      child: Text(
                        "FingerPrint_Form.message1".tr().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Container(
                      height: 48,
                      width: 400,
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Colors.white),
                      child: TextButton(
                        onPressed: _authenticate,
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.white,
                          shape: const BeveledRectangleBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(24))),
                        ),
                        child: Text(
                          "FingerPrint_Form.authenticate".tr().toString(),
                          style: TextStyle(
                              color: Color(0xFF4f2565),
                              letterSpacing: 0,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GestureDetector(
                          onTap: () async {
                            SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                            if (prefs.get('role') == "Corporate") {
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => CorpNavigationBar(
                                    PermessionCorporate:
                                    prefs.getStringList('Permessions'),
                                    role: prefs.get('role'),

                                  ),
                                ),
                              );
                            } else if(prefs.get('role')=="DeliveryEShop") {
                              Navigator.pushReplacement(
                                context,
                              /*  MaterialPageRoute(
                                  builder: (context) => OrdersScreen(),
                                ),*/
                                MaterialPageRoute(builder: (context) => Eshope_Menu()),
                              );
                            }else{
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CustomBottomNavigationBar(
                                        Permessions:
                                        prefs.getStringList('Permessions'),
                                        role: prefs.get('role'),
                                        outDoorUserName:
                                        prefs.get('outDoorUserName'),
                                      ),
                                ),
                              );
                            }
                          },
                          child: new Text(
                            "FingerPrint_Form.skip".tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}

/*AlertDialog(
              title: const Text('Fingerprint'),
              content: SingleChildScrollView(
                child: ListBody(
                  children: const <Widget>[
                    Text('Fingerprint is not set up on ypur device.'),
                    Text('Go to -Settings > Security- to add your'),
                    Text('fingerprint.'),
                  ],
                ),
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text(
                    'Cancel',
                    style: TextStyle(
                      color: Color(0xff4f2565),
                    ),
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );*/
