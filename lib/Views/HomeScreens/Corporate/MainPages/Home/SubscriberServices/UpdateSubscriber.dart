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
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/SubscriberServices/BillShock.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/SubscriberServices/IVRLanguage.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/SubscriberServices/UpdateUserInfo.dart';

import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../Multi_Use_Components/RequiredField.dart';
import '../MainPromotions/CustomerEligibleLines.dart';
import '../MainPromotions/LineActiveSubsidy.dart';
import 'IVRPassword.dart';
import 'InternationalPresetRisk.dart';





class UpdateSubscriber extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  UpdateSubscriber(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _UpdateSubscriberState createState() =>
      _UpdateSubscriberState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _UpdateSubscriberState extends State<UpdateSubscriber> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  DateTime backButtonPressedTime;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  bool isLoading = false;





  _UpdateSubscriberState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


  //*******************   List Item for First Menu    ****************/
  List litemsFirst = [
    ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),
    ListContentFirst(name:"corpMenu.Kurmalek".tr().toString()),
    ListContentFirst(name:"corpMenu.Balance".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),

  ];
  //*******************   End List Item for First Menu    ****************/


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
    print(data);
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{

    }

   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    //disableCapture();
    super.initState();
  }

  @override
  void dispose() {

    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
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
  showAlertDialogUnotherizedERROR(BuildContext context, arabicMessage, englishMessage) {
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
  showAlertDialogOtherERROR(BuildContext context, arabicMessage, englishMessage) {
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Subscriber360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
        ),

      );
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
            title: Text("SubscriberServices.update_subscriber".tr().toString(),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async{
                Navigator.pop(context);
              },
            ), //<Widget>[]

            /* actions: <Widget>[
                IconButton(
                  icon:  Icon(Icons.more_vert,color: Colors.white,),
                  onPressed: ( _showMoreOptionDialog) ,
                ), //IconButton//IconButton
              ],*/
          ),
          backgroundColor: Color(0xFFEBECF1),
          /* appBar: AppBarSectionCorporate(
              appBar: AppBar(),
              title: Text("DashBoard_Form.home".tr().toString()),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ), //IconButton//IconButton
              ],
              PermessionCorporate: PermessionCorporate,
              role: role,
              outDoorUserName: outDoorUserName,
            ),*/
          body: Container(
            color: Colors.white,
            child: role == "Corporate"
                ? Column(



                 children: [
                ///////////////////////////////////Second Content//////////////////////////////////////////////////////////

                Container(
                  color: Colors.white,
                  width: double.infinity,
                  // margin: EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 18, bottom: 5, left: 25, right: 25),
                        color: Color(0xff392156),
                        width: 5,
                        height: 38,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "SubscriberView.CustomerName"
                                    .tr()
                                    .toString(),
                              ),
                              SizedBox(height: 1),
                              Text(
                                data[0]['customerName'],
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
                ),

                Container(
                  color: Colors.white,
                  width: double.infinity,
                  // margin: EdgeInsets.all(12),
                  margin: EdgeInsets.only(bottom: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(
                            top: 18, bottom: 5, left: 25, right: 25),
                        color: Color(0xff392156),
                        width: 5,
                        height: 38,
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "SubscriberView.SubscriberNumber"
                                    .tr()
                                    .toString(),
                              ),
                              SizedBox(height: 1),
                              Text(
                                data[0]['msisdn'],
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
                ),
                 Spacer(),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child:  Card(
                    color: Color(0xFF0E7074),
                    borderOnForeground: true,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        ListTile(
                            title: Text("SubscriberServices.update_user_info".tr().toString(),
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
                                  builder: (context) => UpdateUserInfo(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                            title: Text("SubscriberServices.ivr_language".tr().toString(),
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
                                  builder: (context) => IVRLanguage(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                            title: Text("SubscriberServices.ivr_password".tr().toString(),
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
                                  builder: (context) => IVRPassword(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                            title: Text("SubscriberServices.international_preset_risk".tr().toString(),
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
                                  builder: (context) => InterNationalPresetRisk(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                             title: Text("SubscriberServices.bill_shock".tr().toString(),
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
                                   builder: (context) => SubscriberServicesBillShock(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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


              ],
            ):Container(),
          ),

        ),
      ),

      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////




    );
  }
}