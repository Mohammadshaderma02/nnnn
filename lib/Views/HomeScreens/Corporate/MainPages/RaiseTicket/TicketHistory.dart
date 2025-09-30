import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sales_app/Shared/BaseUrl.dart';

class TicketHistory extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  int index;
  String searchValue;
  String searchCraretia;
  String msisdn;
  String customerNumber;
  List data = [];

  TicketHistory(this.PermessionCorporate, this.role, this.searchID, this.data,
      this.index);
  @override
  _TicketHistoryState createState() => _TicketHistoryState(
      this.PermessionCorporate,
      this.role,
      this.searchID,
      this.data,
      this.index);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();

class _TicketHistoryState extends State<TicketHistory> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  DateTime backButtonPressedTime;
  int index;
  String msisdn;
  String customerNumber;
  List data = [];
  bool checkData = false;
  String messageEn;
  String messageAr;
  String searchCraretia;

  final List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;

  _TicketHistoryState(this.PermessionCorporate, this.role, this.searchID,
      this.data, this.index);

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

  @override
  void initState() {
    print("UnotherizedError");
    print("role role role role role");
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    } else {
      print("PRINT index");
      print(this.index);
      print("PRINT Data");
      print(this.data);
    }
    //disableCapture();
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }
  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        tryAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogERROR(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: Text(
            "alert.cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogOtherERROR(
      BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogUnotherizedERROR(
      BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            UnotherizedError();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogNoData(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF392156),
              title: Text(
                "RaiseTicket.TicketHistory".tr().toString(),
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Navigator.pop(context);
                },
              ), //<Widget>[]
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: role == "Corporate"
                ? ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                    children: [
                      ///////////////////////////////////Second Content//////////////////////////////////////////////////////////

                      SingleChildScrollView(
                        child: Column(
                          children: [
                            Container(
                                color: Colors.white,
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 26, right: 26),
                                // margin: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 5),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "RaiseTicket.TicketNumber"
                                                        .tr()
                                                        .toString(),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text(
                                                    this.data[this.index]
                                                                ['issueID'] ==
                                                            null
                                                        ? "--"
                                                        : this.data[this.index]
                                                                    ['issueID'] ==
                                                                0
                                                            ? "--"
                                                            : this.data[
                                                                    this.index]
                                                                ['issueID'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Container(
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  SizedBox(
                                                    height: 20,
                                                  ),
                                                  Text(
                                                    "RaiseTicket.Status"
                                                        .tr()
                                                        .toString(),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text(
                                                    this.data[this.index]
                                                                ['status'] ==
                                                            null
                                                        ? "--"
                                                        : this.data[this.index]
                                                                    ['status'] ==
                                                                0
                                                            ? "--"
                                                            : this.data[this
                                                                .index]['status'],
                                                    style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 14.0,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),

                                      //////////////////////////////////////////////////////

                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.Refcode".tr().toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['refcode'] == null
                                            ? "--"
                                            : this.data[this.index]['refcode'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['refcode'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      //////////////////////////////////////////////////////

                                      SizedBox(
                                        height: 20,
                                      ), //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.Title".tr().toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['title'] == null
                                            ? "--"
                                            : this.data[this.index]['title'] == 0
                                                ? "--"
                                                : this.data[this.index]['title'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      //////////////////////////////////////////////////////
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.Description".tr().toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['description'] ==
                                                null
                                            ? "--"
                                            : this.data[this.index]
                                                        ['description'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['description'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////

                                      Text(
                                        "RaiseTicket.SubmitDate".tr().toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['submitDate'] ==
                                                null
                                            ? "--"
                                            : this.data[this.index]
                                                        ['submitDate'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['submitDate'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////

                                      Text(
                                        "RaiseTicket.LastUpdateDate"
                                            .tr()
                                            .toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['lastUpdateDate'] ==
                                                null
                                            ? "--"
                                            : this.data[this.index]
                                                        ['lastUpdateDate'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['lastUpdateDate'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////

                                      Text(
                                        "RaiseTicket.Creator".tr().toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['creator'] == null
                                            ? "--"
                                            : this.data[this.index]['creator'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['creator'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),

                                      //////////////////////////////////////////////////////
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.Assignee".tr().toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['assignee'] == null
                                            ? "--"
                                            : this.data[this.index]['assignee'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['assignee'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),

                                      //////////////////////////////////////////////////////
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.Requester".tr().toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['requester'] == null
                                            ? "--"
                                            : this.data[this.index]
                                                        ['requester'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['requester'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),

                                      //////////////////////////////////////////////////////
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.CreatorGroup"
                                            .tr()
                                            .toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['creatorGroup'] ==
                                                null
                                            ? "--"
                                            : this.data[this.index]
                                                        ['creatorGroup'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['creatorGroup'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ), //////////////////////////////////////////////////////

                                      //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.AssigneeGroup"
                                            .tr()
                                            .toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['assigneeGroup'] ==
                                                null
                                            ? "--"
                                            : this.data[this.index]
                                                        ['assigneeGroup'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['assigneeGroup'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      //////////////////////////////////////////////////////
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.LastReassignBy"
                                            .tr()
                                            .toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['lastReassignBy'] ==
                                                null
                                            ? "--"
                                            : this.data[this.index]
                                                        ['lastReassignBy'] ==
                                                    0
                                                ? "--"
                                                : this.data[this.index]
                                                    ['lastReassignBy'],
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 20,
                                      ),
                                      //////////////////////////////////////////////////////
                                      Text(
                                        "RaiseTicket.NoOfNotes".tr().toString(),
                                      ),
                                      SizedBox(height: 1),
                                      Text(
                                        this.data[this.index]['noOfNotes'] == null
                                            ? "--"
                                            : this.data[this.index]
                                                        ['noOfNotes'] ==
                                                    0
                                                ? "--"
                                                : this
                                                    .data[this.index]['noOfNotes']
                                                    .toString(),
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),

                                      SizedBox(
                                        height: 20,
                                      ),
                                    ])),
                          ],
                        ),
                      ),

                      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
                    ],
                  )
                : Center(
                    child: Text(role),
                  ),
          ),
        ));
  }
}
