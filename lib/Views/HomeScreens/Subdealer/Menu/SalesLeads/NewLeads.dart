import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/blocs/Login/logout_bloc.dart';
import 'package:sales_app/blocs/Login/logout_events.dart';
import 'package:sales_app/blocs/Login/logout_state.dart';

import '../../../../../Shared/BaseUrl.dart';

class NewLeads extends StatefulWidget {
  var ticketID;
  NewLeads(this.ticketID);
  @override
  State<NewLeads> createState() => _NewLeadsState(this.ticketID);
}

APP_URLS urls = new APP_URLS();

class _NewLeadsState extends State<NewLeads> {
  var ticketID;
  DateTime backButtonPressedTime;
  var iosSecureScreenShotChannel =
      const MethodChannel('secureScreenshotChannel');
  LogoutBloc logoutBloc;
  bool checkLeadsList = true;
  bool leadListEmpty = false;
  List listOfTickets = [];
  var status;
  String role;
  String customerName;


  _NewLeadsState(this.ticketID);

  @override
  void initState() {
    logoutBloc = BlocProvider.of<LogoutBloc>(context);
    getLeadsById_API();
    //disableCapture();
    // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    super.initState();
  }

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

  Future<void> _onLogout(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
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
            child: AlertDialog(
              title: Text("DeliveryEShop.LogoutRegistration".tr().toString()),
              content: Text("DeliveryEShop.Message_one".tr().toString()),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.cancel".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.Logout".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    //Navigator.of(context).pop(true);
                    logoutBloc.add(LogoutButtonPressed());
                  },
                ),
              ],
            ));
      },
    );
  }

  Future<void> _Unauthorized(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
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
            child: AlertDialog(
              title: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'Unauthorized'
                      : 'غير مصرح'),
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'You need to logout and login again'
                      : 'تحتاج إلى تسجيل الخروج وتسجيل الدخول مرة أخرى'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.Logout".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    //Navigator.of(context).pop(true);
                    logoutBloc.add(LogoutButtonPressed());
                  },
                ),
              ],
            ));
      },
    );
  }

  getLeadsById_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/TeleSalesAPIs/GetLeadsById';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "id": 20,

    };
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),
    );

    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(json.encode(body));
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
    }

    if (statusCode == 200) {
      setState(() {
        checkLeadsList = true;
      });

      var result = json.decode(response.body);
      print(result);

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no orders available"
                    : "لا توجد أوامر متاحة")));
        setState(() {
          checkLeadsList = false;
          leadListEmpty = true;
        });
      } else {
        setState(() {
          listOfTickets = result["data"]['pagedResult'];
          checkLeadsList = false;
          leadListEmpty = false;
        });
      }
      print('Sucses API');
      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                    Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
        _Unauthorized(context);
      }

      setState(() {
        checkLeadsList = false;
        status = statusCode.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
                  Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }

  /******** for back button on mobile tap ******/
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);

      return true;
    }
    return true;
  }

  Widget build(BuildContext context) {
    return WillPopScope(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  //tooltip: 'Menu Icon',

                  onPressed: () async {
                    Navigator.pop(context);
                  },
                ),
                centerTitle: false,
                title: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'New Leads haya'
                      : "New Leads",
                ),
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body: SingleChildScrollView(
                  child: Column(children: <Widget>[
                Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(left: 15, right: 15, top: 8),
                    padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                    child: Column(children: <Widget>[
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.Market".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "Market",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.NationalID_PassportNumber"
                                      .tr()
                                      .toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "NationalID_PassportNumber",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.BuildingCode".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "BuildingCode",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.Package".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "Package",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.MigrationCheckNumber"
                                      .tr()
                                      .toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "MigrationCheckNumber",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.Reseller".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "Reseller",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.OnBehalfAR".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "OnBehalfAR",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.Ref1".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "Ref1",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.TicketNumber".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "TicketNumber",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.Status".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "Status",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ])),
                SizedBox(
                  height: 15,
                ),
                Container(
                  color: Colors.white,
                  margin: EdgeInsets.only(left: 15, right: 15, top: 8),
                  padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                  child: Column(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Text(
                                  "SalesLeads.ChangeStatus".tr().toString(),
                                ),
                              ],
                            ),
                            SizedBox(height: 1),
                            Row(
                              children: [
                                Text(
                                  //SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
                                  "ChangeStatus",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 48,
                              width: 420,
                              margin: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Color(0xFF4f2565),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: Color(0xFF4f2565),
                                  shape: const BeveledRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(24))),
                                ),
                                onPressed: () {
                                  FocusScope.of(context).unfocus();
                                },
                                child: Text(
                                  "SalesLeads.Change".tr().toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  height: 48,
                  width: 320,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Color(0xFF4f2565),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF4f2565),
                      shape: const BeveledRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(24))),
                    ),
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                    },
                    child: Text(
                      "SalesLeads.ProceedtoActivation".tr().toString(),
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ]))),
        ),
        onWillPop: onWillPop);
  }
}
