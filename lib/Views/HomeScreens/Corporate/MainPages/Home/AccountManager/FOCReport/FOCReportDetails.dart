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


class FOCReportDetails extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  int index;
  String searchValue;
  String searchCraretia;
  String msisdn;
  String customerNumber;
  List data=[];

  FOCReportDetails(this.PermessionCorporate, this.role,this.data,this.index);
  @override
  _FOCReportDetailsState createState() =>
      _FOCReportDetailsState(this.PermessionCorporate, this.role,this.data,this.index);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();


class _FOCReportDetailsState extends State<FOCReportDetails> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  DateTime backButtonPressedTime;
  String msisdn;
  String customerNumber;
  List data=[];
  int index;
  bool checkData=false;
  String messageEn;
  String messageAr;
  String searchCraretia;
  bool isLoading=true;


  String currentBalance;
  String currentAging;
  String aging30Days;
  String aging60Days;
  String aging90Days;
  String agingAbove120;
  String unbilledAirtime;
  String unpostedPayments;

  var TotalOne;
  var SumOne;

  var TotalTwo;
  var SumTwo;

  final List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;

  _FOCReportDetailsState(this.PermessionCorporate, this.role,this.data,this.index);




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
    }else{

      print("PRINT Data");
      print(this.data);




    }
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    //disableCapture();
    super.initState();
  }

  @override
  void dispose() {

    // this method to the user can take screenshots of your application
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
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
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF392156),
            title: Text("AccountManager.FOCReportDetails".tr().toString(),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async{
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
                          SizedBox(
                            height: 20,
                          ),
                          //////////////////////////////////////////////////////
                          Text( "AccountManager.customerID".tr().toString(),),
                          SizedBox(height: 1),
                          Text(this.data[this.index]["customerID"]==null?"--":this.data[this.index]["customerID"].length==0?"--": this.data[this.index]["customerID"],
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
                          Text("AccountManager.msisdn".tr().toString(),),
                          SizedBox(height: 1),
                          Text(this.data[this.index]["msisdn"]==null?"--":this.data[this.index]["msisdn"].length==0?"--":this.data[this.index]["msisdn"],
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
                          Text("AccountManager.originalPrice".tr().toString(),),
                          SizedBox(height: 1),
                          Text(
                            this.data[this.index]["originalPrice"]==null?"--":this.data[this.index]["originalPrice"].length==0?"--":this.data[this.index]["originalPrice"],
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
                          Text("AccountManager.serial".tr().toString(),),
                          SizedBox(height: 1),
                          Text(
                            this.data[this.index]["serial"]==null?"--":this.data[this.index]["serial"].length==0?"--":this.data[this.index]["serial"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          //////////////////////////////////////////////////////

                          SizedBox(
                            height: 20,
                          ),  //////////////////////////////////////////////////////
                          Text("AccountManager.itemDescription".tr().toString(),),
                          SizedBox(height: 1),
                          Text(
                            this.data[this.index]["itemDescription"]==null?"--":this.data[this.index]["itemDescription"].length==0?"--":this.data[this.index]["itemDescription"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          //////////////////////////////////////////////////////

                          SizedBox(
                            height: 20,
                          ),  //////////////////////////////////////////////////////
                          Text("AccountManager.focDate".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["focDate"]==null?"--":this.data[this.index]["focDate"].length==0?"--":this.data[this.index]["focDate"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          //////////////////////////////////////////////////////

                         //////////////////////////////////////////////////////
                          Text("AccountManager.focDiscountAmount".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["focDiscountAmount"]==null?"--":this.data[this.index]["focDiscountAmount"].length==0?"--":this.data[this.index]["focDiscountAmount"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////

                           //////////////////////////////////////////////////////
                          Text("AccountManager.requestID".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["requestID"]==null?"--":this.data[this.index]["requestID"].length==0?"--":this.data[this.index]["requestID"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////

                           //////////////////////////////////////////////////////
                          Text("AccountManager.paidAmount".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["paidAmount"]==null?"--":this.data[this.index]["paidAmount"].length==0?"--":this.data[this.index]["paidAmount"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////
  //////////////////////////////////////////////////////
                          Text("AccountManager.presentedByID".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["presentedByID"]==null?"--": this.data[this.index]["presentedByID"].length==0?"--": this.data[this.index]["presentedByID"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////

                          //////////////////////////////////////////////////////
                          Text("AccountManager.presentedByName".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["presentedByName"]==null?"--":this.data[this.index]["presentedByName"].length==0?"--":this.data[this.index]["presentedByName"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////
 //////////////////////////////////////////////////////
                          Text("AccountManager.presentedTo".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["presentedTo"]==null?"--":this.data[this.index]["presentedTo"].length==0?"--":this.data[this.index]["presentedTo"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////
  //////////////////////////////////////////////////////
                          Text("AccountManager.receivedBy".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["receivedBy"]==null?"--":this.data[this.index]["receivedBy"].length==0?"--":this.data[this.index]["receivedBy"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////

                          //////////////////////////////////////////////////////
                          Text("AccountManager.subscriberName".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["subscriberName"]==null?"--":this.data[this.index]["subscriberName"].length==0?"--":this.data[this.index]["subscriberName"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////

                          //////////////////////////////////////////////////////
                          Text("AccountManager.discountType".tr().toString(),),
                          SizedBox(height: 1),
                          Text(  this.data[this.index]["discountType"]==null?"--": this.data[this.index]["discountType"].length==0?"--": this.data[this.index]["discountType"],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0,
                            ),
                          ),   SizedBox(
                            height: 20,
                          ),   //////////////////////////////////////////////////////

                          //////////////////////////////////////////////////////
                          /////////////////////////////////////////////////////


                        ],
                      ),
                    ),
                    //////////////////////////////////////////////////////

                    /***************************************************/

                    /*********************************************************/
                    /////////////////////////////////////////////////////////
                    SizedBox(
                      height: 10,
                    ),


                  ],

          )
              : Center(
            child: Text(role),
          ),

        ));
  }
}
