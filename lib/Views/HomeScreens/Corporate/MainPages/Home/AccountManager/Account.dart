
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
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/ClientMessages.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/FOCReport/FOCReport.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/MyStock/MyStock.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../Subdealer/NotificationsScreen.dart';
import 'Notifications.dart';




class Account extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;

  Account(this.PermessionCorporate, this.role);
  @override
  _AccountState createState() => _AccountState(this.PermessionCorporate, this.role);
}

class _AccountState extends State<Account> {


// Declare your method channel varibale here
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');
  bool serchByEmptyFlag = false;
  String customerID;
  bool FirstContentFlag=false;
  // String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  var  outDoorUserName;

  TextEditingController tawasol_number = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();
  DateTime backButtonPressedTime;

  _AccountState(this.PermessionCorporate, this.role);
   bool NoSearch=true;

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


  void disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }
  @override
  void initState() {
    print("role role role role role");
    print(role);
    checkPrefs();
    checkIndexPage ();
    //disableCapture();

    // this method to user can't take screenshots of your application
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    super.initState();
  }

  @override
  void dispose() {

    // this method to the user can take screenshots of your application
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    // TODO: implement dispose
    super.dispose();
  }



  void checkIndexPage () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('SavePageIndex');
  }

  void checkPrefs ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();



    if(prefs.containsKey("customerID")==false){
      setState(() {
        NoSearch =true;
      });


    }else{
      setState(() {
        NoSearch =false;
      });
    }
    if (prefs.containsKey("customerID")) {
      setState(() {
        customerID=prefs.getString("customerID");
        FirstContentFlag=true;
      });
      print("prefs.getString");
      print(prefs.getString("customerID"));
    }
  }
  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {

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
            //   logoutBloc.add(LogoutButtonPressed(
            //   ));
            exit(0);
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        ),
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


  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      showAlertDialog(context, "هل انت متاكد من إغلاق التطبيق",
          "Are you sure to close the application?");
      return true;
    }
    return true;
  }



  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: onWillPop
        ,child:GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
      backgroundColor: Color(0xFFEBECF1),
      appBar: AppBarSectionCorporate(appBar : AppBar(),
          title: Text(
              "corpNavBar.Account".tr().toString()
          ),

          PermessionCorporate: PermessionCorporate,
          role: role,

      ),
      body:role=="Corporate"?Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top:0,bottom: 20,left: 32,right: 32),
            children: <Widget>[
              Center(

              ),

            ],
          ),
      )  :Container(),


      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton:
      Container(

            color: Color(0xFFEBECF1),
            child: SingleChildScrollView(
              child:Column(
                children: [
                  SizedBox(height: 5),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child:  Card(
                      color: Color(0xFF0E7074),
                      borderOnForeground: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                              title: Text("Notifications_Form.notifications".tr().toString(),
                                  style: TextStyle(color: Colors.white)),
                              trailing: IconButton(
                                icon: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                    : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                              ),
                              onTap: () {
                                 Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Notifications(PermessionCorporate, role),
                                  ),

                                );

                              }
                          ),

                        ],
                      ),
                    ),

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child:  Card(
                      color: Color(0xFF0E7074),
                      borderOnForeground: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                              title: Text("AccountManager.MyStock".tr().toString(),
                                  style: TextStyle(color: Colors.white)),
                              trailing: IconButton(
                                icon: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                    : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MyStock(PermessionCorporate, role),
                                  ),

                                );

                              }
                          ),

                        ],
                      ),
                    ),

                  ),

                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child:  Card(
                      color: FirstContentFlag==true? Color(0xFF0E7074):Color(0xFF0E7074).withOpacity(0.3),
                      borderOnForeground: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                              title: Text("AccountManager.FOCReport".tr().toString(),
                                  style: TextStyle(color: Colors.white)),
                              trailing: IconButton(
                                icon: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                    : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                              ),
                              onTap: () {
                                FirstContentFlag==true?
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => FOCReport(PermessionCorporate, role),
                                  ),

                                ):  showToast(
                                    EasyLocalization.of(context).locale == Locale("en", "US")
                                        ? "Please make sure to search by any category in home screen and accept the agreement, then you can view FOC report"
                                        : "رجى التأكد من البحث حسب أي فئة في الشاشة الرئيسية وقبول الاتفاقية ، ثم يمكنك عرض تقرير FOC",
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                          ),

                        ],
                      ),
                    ),

                  ),
                  SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: MediaQuery.of(context).size.width - 40,
                    child:  Card(
                      color:FirstContentFlag==true? Color(0xFF0E7074):Color(0xFF0E7074).withOpacity(0.3),
                      borderOnForeground: true,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          ListTile(
                              title: Text("corpMenu.ClientMessages".tr().toString(),
                                  style: TextStyle(color: Colors.white)),
                              trailing: IconButton(
                                icon: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                    : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                              ),
                              onTap: () {
                                FirstContentFlag==true?
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ClientMessages(PermessionCorporate, role),
                                  ),

                                ):  showToast(
                                    EasyLocalization.of(context).locale == Locale("en", "US")
                                        ? "Please make sure to search by any category in home screen and accept the agreement, then you can view client messages"
                                        : "رجى التأكد من البحث حسب أي فئة في الشاشة الرئيسية وقبول الاتفاقية ، ثم يمكنك عرض رسائل العميل",
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                          ),

                        ],
                      ),
                    ),

                  ),

                ],
              ),
            )
      ),
    ),
        ));
  }
}

Future<bool> onWillPopDialog(context) => showDialog(
    barrierDismissible: false,
    context: context,
    builder: ((context) => AlertDialog(
      title:Text("corpAlert.msg1".tr().toString(),
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF11120E),
              fontWeight: FontWeight.normal)),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context,true);

        }, child: Text("corpAlert.close".tr().toString(),
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF392156),
            )),),
        TextButton(onPressed: (){
          Navigator.pop(context,false);
        }, child: Text("corpAlert.cancel".tr().toString(),
          style: TextStyle(
            fontSize: 16,
            color: Color(0xFF392156),
          ),),),


      ],)));