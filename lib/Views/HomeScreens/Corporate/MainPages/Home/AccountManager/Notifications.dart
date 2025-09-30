import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

// class NotificationsScreen extends StatefulWidget {
//   //const NotificationsScreen({Key? key}) : super(key: key);
//   @override
//   _NotificationsScreenState createState() => _NotificationsScreenState();
// }



class Notifications extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;

  Notifications(this.PermessionCorporate, this.role);
  @override
  _NotificationsState createState() => _NotificationsState(this.PermessionCorporate, this.role);
}

APP_URLS urls = new APP_URLS();


class _NotificationsState extends State<Notifications> {
  bool serchByEmptyFlag = false;
  String customerID;
  bool FirstContentFlag=false;
  // String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  var  outDoorUserName;

  List NotificationsList=[];
  String messageEn;
  String messageAr;
  bool checkData=false;

  bool isLoading = true;

  _NotificationsState(this.PermessionCorporate, this.role);

  @override
  void initState() {
    print("role role role role role");
    print(role);


    getNotificationsList();
    //disableCapture();
    super.initState();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }
  UnotherizedError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_logged_in', false);
    prefs.setBool('biomitric_is_logged_in', false);
    prefs.setBool('TokenError', true);
    prefs.remove("accessToken");
    ////prefs.remove("userName");
    prefs.remove('counter');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }

  getNotificationsList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/Notifications/list/2';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 404) {
      NotificationsList=[];
      print("I'm here");

    }
    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
      setState(() {
        isLoading =false;
      });
    }
    if (statusCode == 200) {

      print("yes");
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if(result["data"]==null||result["data"].length==0){

        showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");
        setState(() {
          isLoading =false;
        });

      }else if(result["data"]!=null||result["data"].length!=0){
        setState(() {
          NotificationsList=result["data"];
        });
        setState(() {
          isLoading =false;
        });
      }
      else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoading =false;
        });

      }



      print('Sucses API');


      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);
      setState(() {
        isLoading =false;
      });
    }





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
        setState(() {
          isLoading =false;
        });
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
            setState(() {
              isLoading =false;
            });
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


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            //tooltip: 'Menu Icon',
            onPressed: () {
              Navigator.pop(
                context,

              );
            },
          ),
          title: Text(
            "Notifications_Form.notifications".tr().toString(),
          ),
          backgroundColor: Color(0xFF392156),
        ),
        backgroundColor: Color(0xFFEBECF1),
        body:      isLoading==true?    Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 26, right: 26,top: 60),
            // margin: EdgeInsets.all(12),
            margin: EdgeInsets.only(top: 60),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: CircularProgressIndicator(color: Color(0xFF392156) ),
                  height: 20.0,
                  width: 20.0,
                ),
                SizedBox(width: 24),
                Text("corporetUser.PleaseWait".tr().toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, color:Color(0xFF392156),fontSize: 16 ),)],

            )): ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: 8),
            children: <Widget>[

              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount : NotificationsList.length,
                  itemBuilder:(context,index){
                    return Container(
                      child: Column(
                          children:[
                            Card (
                              elevation:0,
                              child:
                              ListTile(
                                title: Text(
                                  NotificationsList[index]['title'],
                                  style: TextStyle(
                                      fontSize: 18,
                                      color: Color(0xff11120e),
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                                subtitle: Container(
                                  padding: EdgeInsets.only(top: 10),
                                  child: Text(
                                    NotificationsList[index]['summary'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff11120e),
                                        fontWeight: FontWeight.normal)

                                    ,
                                    textAlign: TextAlign.right,
                                  ),
                                ),
                              ),),
                          ]
                      ),


                    );}
              )
            ]))
    ;
  }
}