import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/AdjustmentLogs.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillShock.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillingDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/BlineLedger.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/OnlineChargingvalues.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/PresetRisk.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Promotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/VPNDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';


class CustomerClientMessages extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  CustomerClientMessages(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _CustomerClientMessagesState createState() =>
      _CustomerClientMessagesState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

APP_URLS urls = new APP_URLS();

class _CustomerClientMessagesState extends State<CustomerClientMessages> {
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
  List ClientMessages=[];
  String messageEn;
  String messageAr;
  bool isLoading = true;
  ///////////////////////variable from API//////////////////////////////////////
  bool checkData=false;
  String customerUnbillidAirTime;
  String subscriberUnbillidAirTime;
  String unbillidCustomerHSPATopupView;
  String unbilledSubscriberHSPATopUpView;
  String unbilledFeaturesAmount;
  String blineCreditBalance;
  String dataBalance;

  ///////////////////////End variable from API/////////////////////////////////

  TextEditingController tawasol_number = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();
  _CustomerClientMessagesState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);





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

      getClientMessages_API();
    }

    //disableCapture();
    super.initState();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }





  getClientMessages_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": customerNumber,
      "msisdn": "",
      "clientTypeId": "1"
    };



    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getClientMessages';
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
      ClientMessages=[];
      print("I'm here");

    }
    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
      //showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
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
        setState(() {
          ClientMessages=[];
          messageEn=result["data"]["message"];
          messageAr=result["data"]["messageAr"];
        });
         showAlertDialogNoData(context,messageAr, messageEn);

        setState(() {
          checkData=true;
        });
      }else if(result["data"]!=null||result["data"].length!=0){
        setState(() {
          ClientMessages=result["data"];
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
      print("Customer360view"+"  "+urls.BASE_URL +'/getClientMessages');


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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Customer360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF392156),
            title: Text("corpMenu.ClientMessages".tr().toString()),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Customer360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                  ),

                );
                /*  Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EnterMSSIDNumber(enableMsisdn,preMSISDN),
                ),
              );*/
              },
            ), //<Widget>[]


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
          body: role == "Corporate"
              ? ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: 8, left: 0, right: 0),
            children: [
              isLoading==true?    Container(
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

                  )): checkData==true?Container():
              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child:
                ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                  itemCount: ClientMessages.length,
                  itemBuilder: (BuildContext context, int index) {
                    //   itemCount :  UserList.length,
                    return  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.white
                      ),
                      margin: EdgeInsets.only(bottom: 15),
                      padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                   // crossAxisAlignment: CrossAxisAlignment.start,
                                   // mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Customer360View.priority".tr().toString(),),

                                      SizedBox(width: 1),
                                      Text(
                                        ClientMessages[index]['priority'] ??'-',
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
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Container(
                                  child: Row(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                    MainAxisAlignment.start,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Text("Customer360View.subject".tr().toString(),),

                                      SizedBox(width: 1),
                                      Text(
                                        ClientMessages[index]['subject'] ??'-',
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


                          ////////////////////////////////////////////////

                          Divider(),


                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                        height: 10,
                                      ),
                                      Text("Customer360View.messageDescription".tr().toString(),),

                                      SizedBox(height: 1),
                                      Text(
                                        ClientMessages[index]['messageDescription'] ??'-',
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
                          SizedBox(
                            height: 5,
                          ),
                          Divider(),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                        height: 5,
                                      ),
                                      Text("Customer360View.createdbyname".tr().toString(),),

                                      SizedBox(height: 1),
                                      Text(
                                        ClientMessages[index]['createdbyname'] ??'-',
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



                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                                        height: 8,
                                      ),
                                      Text("Customer360View.creationDate".tr().toString(),),

                                      SizedBox(height: 1),
                                      Text(
                                        ClientMessages[index]['creationDate'] ??'-',
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
                          )
                          ,
                          SizedBox(
                            height: 5,
                          ),
                        ],
                      ),
                    );


                  },
                ),

              )

              ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
            ],
          )
              : Center(
            child: Text(role),
          ),

        ));
  }
}
