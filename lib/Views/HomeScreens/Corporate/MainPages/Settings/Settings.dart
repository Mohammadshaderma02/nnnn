import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Settings/ChangePassword.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/Login/logout_bloc.dart';
import 'package:sales_app/blocs/Login/logout_events.dart';
import 'package:sales_app/blocs/Login/logout_state.dart';

class Settings extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;

  Settings(this.PermessionCorporate, this.role);
  @override
  _SettingsState createState() =>
      _SettingsState(this.PermessionCorporate, this.role);
}

class _SettingsState extends State<Settings> {
  // String PermessionCorporate;
  var iosSecureScreenShotChannel =
      const MethodChannel('secureScreenshotChannel');

  final List<dynamic> PermessionCorporate;
  String role;

  LogoutBloc logoutBloc;
  int selectedLanguage = -1;
  bool shouldShow = false;

  _SettingsState(this.PermessionCorporate, this.role);

  UnotherizedError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_logged_in', false);
    prefs.setBool('biomitric_is_logged_in', false);
    prefs.setBool('TokenError', true);
    prefs.remove("accessToken");

    //prefs.remove("userName");
    prefs.remove('counter');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  void removd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedSearchCriteria2save");
  }

  void getSharedPrefernece() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getInt('lang');
    });

    print(prefs.getInt('lang'));
  }

  @override
  void initState() {
    getSharedPrefernece();
    removd();
    print(role);
    logoutBloc = BlocProvider.of<LogoutBloc>(context);
    print("haya haya haya haya haya");
    print(selectedLanguage);
    checkIndexPage();
   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    super.initState();
  }

  @override
  void dispose() {
    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    // TODO: implement dispose
    super.dispose();
  }

  void checkIndexPage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('SavePageIndex');
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LogoutBloc, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(builder: (context) => SignInScreen()),
              ModalRoute.withName('/SignInScreen'),
            );
          }
        },
        child: WillPopScope(
            onWillPop: () async {
              final pop = await onWillPopDialog(context);
              return pop ?? true;
              //return true;
            },
            child: Scaffold(
              backgroundColor: Color(0xffEBECF1),
              appBar: AppBarSectionCorporate(
                appBar: AppBar(),
                title: Text("corpNavBar.Settings".tr().toString()),
                PermessionCorporate: PermessionCorporate,
                role: role,
              ),
              body: shouldShow == true
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            backgroundColor: Colors.grey,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Color(0xff392156), //<-- SEE HERE
                            ),
                          ),
                          SizedBox(
                            height: 8,
                          ),
                          Text("corpAlert.PleaseWait".tr().toString(),
                              style: TextStyle(
                                color: Color(0xFF392156),
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'OpenSans',
                              ))
                        ],
                      ),
                    )
                  : Column(children: [
                      Container(
                        child: SizedBox(height: 8.0),
                      ),
                      ListView(
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            top: 0, bottom: 0, left: 0, right: 0),
                        children: <Widget>[
                          /* Container(
                    color: Colors.transparent,
                    margin: EdgeInsets.only(
                        top: 18, bottom: 18, left: 20, right: 20),
                    child: Text(
                      "corpNavBar.Settings".tr().toString(),
                      style: TextStyle(
                        color: Color(0xFF939393),
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ),*/
                          Container(
                            //margin:  EdgeInsets.only(top:8),
                            color: Colors.white,
                            child: Column(
                              children: [
                                Container(
                                  child: SizedBox(width: 2.0),
                                ),
                                Container(
                                  child: SizedBox(height: 12.0),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 0.0, horizontal: 15.0),
                                  dense: true,
                                  leading: Icon(Icons.lock,
                                      color: Color(0xFF778CA2), size: 30),
                                  title: Text(
                                    "corpMenu.Change_Password".tr().toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF2F2F2F),
                                        fontWeight: FontWeight.normal),
                                  ),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                            Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right)
                                        : Icon(Icons.keyboard_arrow_left),
                                  ),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChangePassword(
                                            PermessionCorporate, role),
                                      ),
                                    );
                                  },
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Color(0xFFedeff3),
                                ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 5, bottom: 5, left: 16, right: 16),
                                  child: Row(children: [
                                    Icon(
                                      Icons.language,
                                      color: Color(0xFF778CA2),
                                      size: 30,
                                    ),
                                    SizedBox(width: 25.0),
                                    Text(
                                      "corpMenu.Language".tr().toString(),
                                      style: TextStyle(
                                        color: Color(0xFF2F2F2F),
                                        fontSize: 14,
                                        fontWeight: FontWeight.normal,
                                      ),
                                    ),
                                    EasyLocalization.of(context).locale ==
                                            Locale("en", "US")
                                        ? Container(
                                            width: 80,
                                            height: 40,
                                            margin: EdgeInsets.only(left: 70),

                                            decoration: BoxDecoration(
                                              color: Color(0xff392156),

                                              border: Border.all(
                                                  color:
                                                      const Color(0xff392156),
                                                  width: 1.0,
                                                  style: BorderStyle
                                                      .solid), //Border.all
                                              /*** The BorderRadius widget  is here ***/
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(0),
                                                bottomLeft: Radius.circular(30),
                                                bottomRight: Radius.circular(0),
                                              ), //BorderRadius.all
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                InkWell(
                                                  child: Text(
                                                    "English",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    context.setLocale(
                                                        Locale('en', 'US'));
                                                    prefs.setInt('lang', 1);
                                                    setState(() {
                                                      selectedLanguage = 1;
                                                      shouldShow = true;
                                                    });
                                                    Timer timer = Timer(
                                                        Duration(seconds: 1),
                                                        () {
                                                      setState(() {
                                                        shouldShow = false;
                                                      });
                                                    });
                                                  },
                                                ),
                                              ],
                                            ), //BoxDecoration
                                          )
                                        : Container(
                                            width: 80,
                                            height: 40,
                                            margin: EdgeInsets.only(right: 108),

                                            decoration: BoxDecoration(
                                              color: Color(0xff392156),
                                              /*  image: const DecorationImage(
                                image: NetworkImage(
                                    'https://media.geeksforgeeks.org/wp-content/cdn-uploads/logo.png'),
                              ),*/
                                              border: Border.all(
                                                  color:
                                                      const Color(0xff392156),
                                                  width: 1.0,
                                                  style: BorderStyle
                                                      .solid), //Border.all
                                              /*** The BorderRadius widget  is here ***/
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(30),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(30),
                                              ), //BorderRadius.all
                                            ),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.check,
                                                  color: Colors.white,
                                                  size: 20,
                                                ),
                                                SizedBox(
                                                  width: 3,
                                                ),
                                                InkWell(
                                                  child: Text(
                                                    "العربية",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.normal,
                                                    ),
                                                  ),
                                                  onTap: () async {
                                                    SharedPreferences prefs =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    context.setLocale(
                                                        Locale('ar', 'AR'));
                                                    prefs.setInt('lang', 2);
                                                    setState(() {
                                                      selectedLanguage = 2;
                                                      shouldShow = true;
                                                    });
                                                    Timer timer = Timer(
                                                        Duration(seconds: 1),
                                                        () {
                                                      setState(() {
                                                        shouldShow = false;
                                                      });
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),

                                            //BoxDecoration
                                          ),
                                    EasyLocalization.of(context).locale ==
                                            Locale("en", "US")
                                        ? Container(
                                            width: 80,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              /*  image: const DecorationImage(
                                image: NetworkImage(
                                    'https://media.geeksforgeeks.org/wp-content/cdn-uploads/logo.png'),
                              ),*/
                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFD6D6D6),
                                                  width: 1.0,
                                                  style: BorderStyle
                                                      .solid), //Border.all
                                              /*** The BorderRadius widget  is here ***/
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(0),
                                                topRight: Radius.circular(30),
                                                bottomLeft: Radius.circular(0),
                                                bottomRight:
                                                    Radius.circular(30),
                                              ), //BorderRadius.all
                                            ),
                                            child: Center(
                                              child: InkWell(
                                                child: Text(
                                                  "العربية",
                                                  style: TextStyle(
                                                    color: Color(0xFF1C1B1F),
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  context.setLocale(
                                                      Locale('ar', 'AR'));
                                                  prefs.setInt('lang', 2);
                                                  setState(() {
                                                    selectedLanguage = 2;
                                                    shouldShow = true;
                                                  });
                                                  Timer timer = Timer(
                                                      Duration(seconds: 1), () {
                                                    setState(() {
                                                      shouldShow = false;
                                                    });
                                                  });
                                                },
                                              ),
                                            ), //BoxDecoration
                                          )
                                        : Container(
                                            width: 80,
                                            height: 40,

                                            decoration: BoxDecoration(
                                              // color: Color(0xff392156),

                                              border: Border.all(
                                                  color:
                                                      const Color(0xFFD6D6D6),
                                                  width: 1.0,
                                                  style: BorderStyle
                                                      .solid), //Border.all
                                              /*** The BorderRadius widget  is here ***/
                                              borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(30),
                                                topRight: Radius.circular(0),
                                                bottomLeft: Radius.circular(30),
                                                bottomRight: Radius.circular(0),
                                              ), //BorderRadius.all
                                            ),
                                            child: Center(
                                              child: InkWell(
                                                child: Text(
                                                  "English",
                                                  style: TextStyle(
                                                    color: Color(0xFF1C1B1F),
                                                    fontSize: 13,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                  ),
                                                ),
                                                onTap: () async {
                                                  SharedPreferences prefs =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  context.setLocale(
                                                      Locale('en', 'US'));
                                                  prefs.setInt('lang', 1);
                                                  setState(() {
                                                    selectedLanguage = 1;
                                                    shouldShow = true;
                                                  });
                                                  Timer timer = Timer(
                                                      Duration(seconds: 1), () {
                                                    setState(() {
                                                      shouldShow = false;
                                                    });
                                                  });
                                                },
                                              ),
                                            ), //BoxDecoration
                                          ),
                                  ]),
                                ),
                                Divider(
                                  thickness: 1,
                                  color: Color(0xFFedeff3),
                                ),
                                ListTile(
                                  contentPadding: EdgeInsets.symmetric(
                                      vertical: 1.0, horizontal: 15.0),
                                  dense: true,
                                  leading: Icon(Icons.logout_outlined,
                                      color: Color(0xFF778CA2), size: 30),
                                  title: Text(
                                    "alert.LogoutRegistration".tr().toString(),
                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xFF2F2F2F),
                                        fontWeight: FontWeight.normal),
                                  ),
                                  onTap: () {
                                    showDialog(
                                        context: context,
                                        builder: (_) => AlertDialog(
                                              content: Text(
                                                "alert.content_logout_alart"
                                                    .tr()
                                                    .toString(),
                                                style: TextStyle(
                                                  color: Color(0xFF11120e),
                                                  fontSize: 16,
                                                ),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () {
                                                    Navigator.pop(
                                                        context, true);
                                                  },
                                                  child: Text(
                                                    "alert.cancel"
                                                        .tr()
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Color(0xFF392156),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () {
                                                    logoutBloc.add(
                                                        LogoutButtonPressed());
                                                  },
                                                  child: Text(
                                                    "alert.logout"
                                                        .tr()
                                                        .toString(),
                                                    style: TextStyle(
                                                      color: Color(0xFF392156),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ));
                                  },
                                ),
                                Container(
                                  child: SizedBox(height: 10.0),
                                ),
                              ],
                            ),
                          ),
                          /*  Container(
                      width: 180,
                      height: 50,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, bottom: 20, top: 20),



                   child:   ElevatedButton(
                     style: ButtonStyle(
                       backgroundColor: MaterialStatePropertyAll<Color>(
                           Color(0xff0E7074)),
                       shape: MaterialStateProperty.all(
                         RoundedRectangleBorder(
                           borderRadius: BorderRadius.circular(30.0),
                           side: BorderSide(
                               width: 1, color: Color(0xff0E7074)),
                         ),
                       ),
                     ),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) =>
                                  AlertDialog(
                                    content: Text(
                                      "alert.content_logout_alart".tr().toString(),
                                      style: TextStyle(
                                        color: Color(0xFF11120e),
                                        fontSize: 16,
                                      ),
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context, true);
                                        },
                                        child: Text(
                                          "alert.cancel".tr().toString(),
                                          style: TextStyle(
                                            color: Color(0xFF392156),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: ()  {
                                          logoutBloc.add(LogoutButtonPressed(
                                          ));
                                        },
                                        child: Text(
                                          "alert.logout".tr().toString(),
                                          style: TextStyle(
                                            color: Color(0xFF392156),
                                            fontSize: 14,
                                          ),
                                        ),
                                      ),

                                    ],
                                  ));
                        },
                        child: EasyLocalization.of(context).locale ==
                            Locale("en", "US")?Row(
                          mainAxisSize: MainAxisSize.min,
                          children:  [

                            Text("alert.logout".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(width: 10,),
                            //Text('Elevated Button'),
                            Icon(Icons.logout_outlined)
                          ],
                        ):Row(
                          mainAxisSize: MainAxisSize.min,
                          children:  [
                            Icon(Icons.logout_outlined),
                            SizedBox(width: 10,),
                            Text("alert.logout".tr().toString(),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.normal,
                              ),
                            ),

                            //Text('Elevated Button'),

                          ],
                        ),
                      ),
         ),*/
                        ],
                      ),
                    ]),
            )));
  }
}

Future<bool> onWillPopDialog(context) => showDialog(
    barrierDismissible: false,
    context: context,
    builder: ((context) => AlertDialog(
          title: Text("corpAlert.msg1".tr().toString(),
              style: TextStyle(
                fontSize: 16,
                color: Color(0xFF11120E),
              )),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("corpAlert.close".tr().toString(),
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF392156),
                  )),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                "corpAlert.cancel".tr().toString(),
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF392156),
                ),
              ),
            ),
          ],
        )));
