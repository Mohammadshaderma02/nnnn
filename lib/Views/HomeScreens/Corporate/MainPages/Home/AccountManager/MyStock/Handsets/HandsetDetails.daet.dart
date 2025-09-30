import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/RaiseTicket/TicketHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';

import 'package:sales_app/Shared/BaseUrl.dart';



class HandsetDetails extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  int index;
  List Data=[];
  HandsetDetails(this.PermessionCorporate, this.role,this.Data,this.index);
  @override
  _HandsetDetailsState createState() => _HandsetDetailsState(this.PermessionCorporate, this.role,this.Data,this.index);
}
APP_URLS urls = new APP_URLS();

class _HandsetDetailsState extends State<HandsetDetails> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  // String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  int index;
  String role;
  String customerName;
  String SubscriberNumber;
  bool FirstContentFlag=false;
  bool checkData =false;
  bool isLoading = false;
  bool emptyfromDate = false;
  bool emptytoDate = false;
  List Data=[];
  List serials=[];
  DateTime backButtonPressedTime;







  _HandsetDetailsState(this.PermessionCorporate, this.role,this.Data,this.index);


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
    print("role role role role role");
    print(role);
    checkPrefs ();
    print("DATA");
    print(this.Data);
    print("INDEX");
    print(this.index);
    checkLengthOfserials ();
    print("__________________________________________________________________");
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    super.initState();

    //disableCapture();
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
  void checkPrefs ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("customerName")) {
      setState(() {
        customerName=prefs.getString("customerName");
        FirstContentFlag=true;
      });

    }
    if (prefs.containsKey("SubscriberNumber")) {
      setState(() {
        SubscriberNumber=prefs.getString("SubscriberNumber");
        FirstContentFlag=true;
      });
      print("prefs.getString");
      print(prefs.getString("SubscriberNumber"));
    }
  }


  void checkLengthOfserials (){
    if(this.Data[this.index]["serials"]!=null|| this.Data[this.index]["serials"].length!=0){
      setState(() {
        serials=this.Data[this.index]["serials"];
      });
    }

    print("Serials.length");
    print(serials.length);
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
    return  WillPopScope(
        onWillPop: onWillPop,
        child:Scaffold(
          backgroundColor: Color(0xFFEBECF1),
          appBar: AppBar(
            backgroundColor: Color(0xFF392156),
            title: Text("AccountManager.HandsetDetails".tr().toString(),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.pop(context);
              },
            ), //<Widget>[]

          ),
          body:role=="Corporate"?
          ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: 8, left: 0, right: 0),
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
                    SizedBox(
                      height: 20,
                    ),
                    //////////////////////////////////////////////////////
                    Text( "AccountManager.HandsetName".tr().toString(),),
                    SizedBox(height: 1),
                    Text(this.Data[this.index]["handsetType"]!=null|| this.Data[this.index]["handsetType"].length!=0?this.Data[this.index]["handsetType"]:'--',

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
                    Text("AccountManager.Quantity".tr().toString(),),
                    SizedBox(height: 1),
                    Text(this.Data[this.index]["quantity"]!=null?this.Data[this.index]["quantity"].toString():"--",
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


                  ],
                ),
              ),


              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child:
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                  itemCount: serials.length,
                  itemBuilder: (BuildContext context, int index) {
                    //   itemCount :  UserList.length,
                    return  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white
                      ),
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.only(left: 10, right: 10,bottom: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),

                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("AccountManager.SerialsNumber".tr().toString(),),

                                      SizedBox(height: 1),
                                      Text( serials[index]['serialNumber']!=null|| serials[index]['serialNumber'].length!=0?serials[index]['serialNumber']:'--',

                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      Text("AccountManager.AssignDate".tr().toString(),),

                                      SizedBox(height: 1),
                                      Text(serials[index]['assignDate'].toString()!=null?serials[index]['assignDate'].toString():'--',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14.0,
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),


                                      SizedBox(
                                        height: 10,
                                      ),
                                    ],
                                  ),
                                ),
                              ),





                            ],
                          )

                        ],
                      ),
                    );


                  },
                ),

              )


            ],
          )

              :Container(),



        ));
  }
}



