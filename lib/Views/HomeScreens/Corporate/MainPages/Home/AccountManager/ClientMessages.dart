import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
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
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';


class ClientMessages extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];

  ClientMessages(this.PermessionCorporate, this.role);
  @override
  _ClientMessagesState createState() =>
      _ClientMessagesState(this.PermessionCorporate, this.role);
}

APP_URLS urls = new APP_URLS();

class _ClientMessagesState extends State<ClientMessages> {
  DateTime backButtonPressedTime;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  var SubscriberRechargesDetailsData=[];
  List MessageLookup=[];
  var selectedType;
  bool emptyTypeName =false;



  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List ClientMessages=[];
  String messageEn;
  String messageAr;
  List data=[];
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
  int falgSearch=0;

  ///////////////////////End variable from API/////////////////////////////////

  TextEditingController tawasol_number = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();
  _ClientMessagesState(this.PermessionCorporate, this.role);





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
      getClientLookup_API ();
    }

    //disableCapture();
    super.initState();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }


  getClientLookup_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("//////////////***********************/////////////////////");
    print(prefs.getString("SubscriberNumber"));
    print("//////////////***********************/////////////////////");

    var apiArea = urls.BASE_URL + '/Lookup/GETCLIENTTYPE';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
    );
    int statusCode = response.statusCode;
    print('TOKEN');
    print(prefs.getString("accessToken"));

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {
      var result = json.decode(response.body);

      if (result["status"] == 0) {
        if (result["data"] == null || result["data"].length == 0) {
          //showAlertDialogNoData(context, "لا توجد بيانات متاحة الآن.", "No data available now .");
        } else {
          print('emplo');
          print(result["data"]);
          setState(() {
            MessageLookup = result["data"];
          });
        }
      } else {
        // showAlertDialogERROR(context, result["messageAr"], result["message"]);
      }

      return result;
    } else {
      //showAlertDialogOtherERROR(context, statusCode, statusCode);
    }
  }

  getClientMessages_API ()async{
    if (selectedType !=null ) {
      setState(() {
        isLoading = true;
      });
      print('called');
      if (selectedType !=null ) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Map test = {
          "customerId": prefs.getString("customerID"),
          "msisdn": prefs.getString("SubscriberNumber"),
          "clientTypeId": selectedType
        };

        String body = json.encode(test);
        var apiArea = urls.BASE_URL + '/Customer360/getClientMessages';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(body);
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
          showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
          setState(() {
            isLoading =false;
          });
        }


        if (statusCode == 200) {
          var result = json.decode(response.body);
          print('heelo');
          print(result);
          print('heelo');


          setState(() {
            isLoading=false;

          });
          if( result["status"]==0){
            if(result["data"]==null||result["data"].length==0){
              //showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

            }else{

              setState(() {
                ClientMessages=result["data"];
                isLoading=false;
                checkData=true;
                falgSearch=2;
              });

            }
            print("getClientMessages");
          }else{
            showAlertDialogERROR(context,result["messageAr"], result["message"]);

            setState(() {

              isLoading=false;
              falgSearch=0;

            });
          }




          return result;
        }else{
          showAlertDialogOtherERROR(context,statusCode, statusCode);


        }

      }}else{
      if(selectedType ==null ){
        setState(() {
          emptyTypeName = true;
        });
      }
    }

  }




  Widget buildMessageType() {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyTypeName == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: MessageLookup.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["code"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["value"])
                          : Text(valueItem["value"]),
                    );
                  }).toList(),
                  value: selectedType,
                  onChanged:MessageLookup.length==0?null: (String newValue) {
                    setState(() {
                      selectedType = newValue;
                    });
                  },
                ),
              ),
            )));
  }

  Widget buildSearchBtn() {
    return Padding(
      padding:
      const EdgeInsets.only(left: 16.0, right: 16.0, top: 16.0, bottom: 8),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: () {
              getClientMessages_API();
              setState(() {
                falgSearch=1;
              });
              /*********haya hazaimeh***********/
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.search,
                  color: Colors.white,
                ),
                SizedBox(
                  width: 10,
                ),
                Text(
                  "adjustmentLogsViews.search".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )),
      ),
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
        setState(() {
          ClientMessages=[];
          falgSearch=0;
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
            Navigator.pop(context, 'OK');
            setState(() {
              ClientMessages=[];
              falgSearch=0;

            });
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
          ClientMessages=[];
          falgSearch=0;

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
              ClientMessages=[];
              falgSearch=0;

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
            title: Text("corpMenu.ClientMessages".tr().toString()),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
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

              Container(
                padding: EdgeInsets.only(left: 10, right: 10),
                child:falgSearch==0?Container():
                falgSearch==1?Container(
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

                    )):falgSearch==2? ListView.builder(
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
                                        ClientMessages[index]['priority']==null?'-': ClientMessages[index]['priority'].length==0?"--": ClientMessages[index]['priority'],
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
                                        ClientMessages[index]['subject']==null ?'--':ClientMessages[index]['subject'].length==0?"--":ClientMessages[index]['subject'],
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
                                        ClientMessages[index]['messageDescription']==null?'-':ClientMessages[index]['messageDescription'].length==0?"--":ClientMessages[index]['messageDescription'],
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
                                        ClientMessages[index]['createdbyname']==null ?'--': ClientMessages[index]['createdbyname'].length==0?"--": ClientMessages[index]['createdbyname'],
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

                                      Text("Customer360View.creationDate".tr().toString(),),

                                      SizedBox(height: 1),
                                      Text(
                                        ClientMessages[index]['creationDate']==null ?'-': ClientMessages[index]['creationDate'].length==0?"--": ClientMessages[index]['creationDate'],
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
                ):Container(),

              )

              ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
            ],
          )
              : Center(
            child: Text(role),
          ),

          bottomNavigationBar: BottomAppBar(
            child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Color(0xFFEBECF1),

                ),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(
                        height: 8,
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "AccountManager.ClientType".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                        child: Row(
                          children: [
                            buildMessageType(),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                        child: Row(
                          children: [
                            emptyTypeName == true
                                ? RequiredFeild(
                                text: "Menu_Form.msisdn_required".tr().toString())
                                : Container(),
                          ],
                        ),
                      ),
                      /**************************************************************************************************************/

                      buildSearchBtn()
                    ],
                  ),
                )
            ),
          ),


        ));
  }
}
