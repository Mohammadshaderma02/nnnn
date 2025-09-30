import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/MyStock/Handsets/HandsetDetails.daet.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/MyStock/RechargeCards/RechargeCardsDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/RaiseTicket/TicketHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';

import 'package:sales_app/Shared/BaseUrl.dart';



class Handsets extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  Handsets(this.PermessionCorporate, this.role);
  @override
  _HandsetsState createState() => _HandsetsState(this.PermessionCorporate, this.role);
}
APP_URLS urls = new APP_URLS();

class _HandsetsState extends State<Handsets> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  // String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  String customerName;
  String SubscriberNumber;
  bool FirstContentFlag=false;
  bool checkData =false;
  bool isLoading = true;
  bool emptyfromDate = false;
  bool emptytoDate = false;

  List MenaTracks=[];


  int searchID;
  String searchCraretia;
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool emptymsisdn=false;
  bool errormsisdn=false;
  DateTime backButtonPressedTime;
  TextEditingController MSISDN = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();



  _HandsetsState(this.PermessionCorporate, this.role);


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
    Handsets_API();
    print("__________________________________________________________________");
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    //disableCapture();
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







  Handsets_API ()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Customer360/getHandsetStockPerUser';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    Map body = {
      "handsetType": ""

    };
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);
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
            MenaTracks=result["data"];
            print(MenaTracks.length);
            isLoading=false;
            checkData=true;
          });

        }
        print("GetCustomersCreditNotes");
      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);

        setState(() {

          isLoading=false;

        });
      }




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
    return  WillPopScope(
        onWillPop:onWillPop,
        child:GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Color(0xFFEBECF1),
            appBar: AppBar(
              backgroundColor: Color(0xFF392156),
              title: Text("AccountManager.Handsets".tr().toString(),),
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
                  color: Colors.transparent ,
                  width: double.infinity,
                  // height: MediaQuery.of(context).size.height/3 *1.9,

                  // margin: EdgeInsets.all(12),
                  child: isLoading==true?
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 26, right: 26,top: 60),
                      // margin: EdgeInsets.all(12),
                      margin: EdgeInsets.only(top: 20),
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

                      )):
                  checkData==true?
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child:
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                      itemCount: MenaTracks.length,
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
                                          Text("AccountManager.HandsetName".tr().toString(),),

                                          SizedBox(height: 1),
                                          Text(
                                            MenaTracks[index]['handsetType']!=null|| MenaTracks[index]['handsetType'].length!=0?MenaTracks[index]['handsetType']:'--',

                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 15,
                                          ),
                                          Text("AccountManager.Quantity".tr().toString(),),

                                          SizedBox(height: 1),
                                          Text(MenaTracks[index]['quantity'].toString()!=null?MenaTracks[index]['quantity'].toString():'--',
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


                                  //Spacer(),
                                  Column(
                                      crossAxisAlignment: CrossAxisAlignment.center,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.navigate_next,color: Color(0xFFA1A1A1),),
                                          onPressed: () async{
                                            SharedPreferences prefs = await SharedPreferences.getInstance();

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => HandsetDetails(PermessionCorporate, role,MenaTracks,index),
                                              ),
                                            );
                                          },
                                        ),
                                      ]),


                                ],
                              )

                            ],
                          ),
                        );


                      },
                    ),

                  )  :
                  Container(
                      color: Colors.transparent
                  ),
                ),


              ],
            )

                :Container(),



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
                fontWeight: FontWeight.normal)),),
        TextButton(onPressed: (){
          Navigator.pop(context,false);
        }, child: Text("corpAlert.cancel".tr().toString(),
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF392156),
              fontWeight: FontWeight.normal),),),


      ],)));
