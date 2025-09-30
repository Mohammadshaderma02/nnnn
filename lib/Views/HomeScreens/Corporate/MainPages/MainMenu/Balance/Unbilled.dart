

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


class Unbilled extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  String searchCraretia;
  String msisdn;
  String customerNumber;
  List data=[];

  Unbilled(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _UnbilledState createState() =>
      _UnbilledState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();


class _UnbilledState extends State<Unbilled> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  DateTime backButtonPressedTime;
  String msisdn;
  String customerNumber;
  List data=[];
  bool checkData=false;
  String messageEn;
  String messageAr;
  String searchCraretia;
  bool isLoading=true;


  String customerUnbillidAirTime;
  String unbillidCustomerHSPATopupView;
  String unbilledFeaturesAmount;


  final List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;

  _UnbilledState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);




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


      getUnbilledAmounts_API();


    }
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

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

  getUnbilledAmounts_API()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map test = {
      "msisdn": msisdn,
      "customerNumber": customerNumber

    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getUnbilledAmounts';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 404) {

      print("I'm here");

    }
    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
     // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
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
          checkData=true;
        });
      }if( result["status"]==0){

        setState(() {
          customerUnbillidAirTime=result["data"]['customerUnbillidAirTime']==null?'--':result["data"]['customerUnbillidAirTime'].length==0?'--':result["data"]['customerUnbillidAirTime'];
          unbillidCustomerHSPATopupView=result["data"]['unbillidCustomerHSPATopupView']==null?'--':result["data"]['unbillidCustomerHSPATopupView'].length==0?'--':result["data"]['unbillidCustomerHSPATopupView'];
          unbilledFeaturesAmount=result["data"]['unbilledFeaturesAmount']==null?'--':result["data"]['unbilledFeaturesAmount'].length==0?'--':result["data"]['unbilledFeaturesAmount'];

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
      print(urls.BASE_URL +'/Customer360/getUnbilledAmounts');


      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }






  showAlertDialogError(BuildContext context,arabicMessage,englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text("alert.tryAgain".tr().toString() ,
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
      content: Text(EasyLocalization.of(context).locale == Locale("en", "US") ? englishMessage : arabicMessage,
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
              title: Text("Balance.Unbilled".tr().toString(),),
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
                isLoading==true?   Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 26, right: 26,top: 30),
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

                    )): checkData==true?Container():
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                          color: Colors.transparent,
                          width: double.infinity,
                          height: 40,
                          padding: EdgeInsets.only(left: 26, right: 26),
                          // margin: EdgeInsets.all(12),
                          // margin: EdgeInsets.only(bottom: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Balance.Customer".tr().toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                  ),
                                ),])),
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
                            Text( "Balance.Unbilled".tr().toString(),),
                            SizedBox(height: 1),
                            Text(customerUnbillidAirTime,
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
                            Text("Balance.unbilledHSPATopup".tr().toString(),),
                            SizedBox(height: 1),
                            Text(unbillidCustomerHSPATopupView,
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
                      //////////////////////////////////////////////////////

                      /***************************************************/

                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 26, right: 26),
                        // margin: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 5,top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            //////////////////////////////////////////////////////
                            Text( "Balance.unbilledFeaturesAmount".tr().toString(),),
                            SizedBox(height: 1),
                            Text(unbilledFeaturesAmount,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            //////////////////////////////////////////////////////

                            SizedBox(
                              height: 20,
                            ),





                          ],
                        ),
                      ),
                      /*********************************************************/
                      /////////////////////////////////////////////////////////
                      SizedBox(
                        height: 10,
                      ),


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
