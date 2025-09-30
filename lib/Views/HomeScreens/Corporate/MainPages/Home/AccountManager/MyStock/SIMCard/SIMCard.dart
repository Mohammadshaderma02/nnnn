import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/MyStock/RechargeCards/RechargeCardsDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/MyStock/SIMCard/SIMCardDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/RaiseTicket/TicketHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';

import 'package:sales_app/Shared/BaseUrl.dart';



class SIMCard extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  SIMCard(this.PermessionCorporate, this.role);
  @override
  _SIMCardState createState() => _SIMCardState(this.PermessionCorporate, this.role);
}
APP_URLS urls = new APP_URLS();

class _SIMCardState extends State<SIMCard> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  // String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  String customerName;
  String SubscriberNumber;
  bool FirstContentFlag=false;






  int searchID;
  String searchCraretia;






  /************************************************************************************************/
  bool isLoading =true;
  bool isloadingSearch=true;
  bool checkData =false;
  bool checkDataSerach=false;
  bool emptySerial=false;
  bool errorSerial=false;
  List SimStock=[];
  List SearchSimStock=[];
  List simTypeSerialsList=[];
  List SearchsimTypeSerialsList=[];
  String simType;
  String quantity;
  TextEditingController Serial = TextEditingController();
  DateTime backButtonPressedTime;

  bool flagSearch=false;
  /**********************************************************************************************/










  _SIMCardState(this.PermessionCorporate, this.role);


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


    getSimStockPerUser_API();
    print("__________________________________________________________________");
    //disableCapture();
   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

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

  /***********************************************************************************************************/
  getSimStockPerUser_API ()async{


    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Customer360/getSimStockPerUser';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "serialNumber":""
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



      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{

          setState(() {


            SimStock=result["data"];
            simTypeSerialsList=result["data"][0]["simTypeSerials"];
            isLoading=false;
            checkData=false;
          });

        }
        print("**********************************************************");
        print(simTypeSerialsList.length);
        print(simTypeSerialsList);
        print("**********************************************************");

        print("getSimStockPerUser");
      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);


      }


      print("To get all of stok"+urls.BASE_URL + '/Customer360/getSimStockPerUser'+" ");

      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);


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
        setState(() {
          checkData=false;
          SimStock=[];
          simTypeSerialsList=[];

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
              checkData=false;
              SimStock=[];
              simTypeSerialsList=[];

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
          checkData=false;
          SimStock=[];
          simTypeSerialsList=[];
          isLoading=false;

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
              SimStock=[];
              simTypeSerialsList=[];

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
  /**********************************************************************************************************/



  /***************************************Search Part********************************************************/
  Widget buildSerialsNumber(){
    return
      Expanded(child:  Container(
        // margin: EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: emptySerial==true || errorSerial==true
                ? Color(0xFFB10000).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: emptySerial || errorSerial? Color(0xFFb10000) : Color(0xFFD1D7E0),
              width:  1,
            )),
        height: 50,
        child: TextField(
          controller: Serial,
          keyboardType: TextInputType.text,
          style: TextStyle(color: Color(0xFF11120E)),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.all(16),
            // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
            hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
          ),
        ),
      ),)

    ;
  }

  Widget buildSearchBtn() {

    return Padding(
      padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 16.0,bottom: 8),
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
              searchSimStockPerUser_API ();
              setState(() {
                flagSearch=true;
              });

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search,color: Colors.white,),
                SizedBox(width: 10,),
                Text(
                  "adjustmentLogsViews.search".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
        ),
      ),
    );
  }

  searchSimStockPerUser_API ()async{
    if( Serial.text !='') {
      setState(() {
        isloadingSearch=true;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var apiArea = urls.BASE_URL+'/Customer360/getSimStockPerUser';
      final Uri url = Uri.parse(apiArea);
      prefs.getString("accessToken");
      final access = prefs.getString("accessToken");
      print(url);
      Map body = {
        "serialNumber":Serial.text
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
          isloadingSearch=false;

        });
        if( result["status"]==0){
          if(result["data"]==null||result["data"].length==0){
            showAlertDialogNoDataSearch(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


          }else{

            setState(() {
              SearchSimStock=result["data"];
              SearchsimTypeSerialsList=result["data"][0]["simTypeSerials"];
             // SimStock=[];
              isloadingSearch=false;
              checkDataSerach=false;
            });

          }
          print("getSimStockPerUser");
        }else{
          showAlertDialogERRORSearch(context,result["messageAr"], result["message"]);


        }


        print(urls.BASE_URL + '/Customer360/getSimStockPerUser'+" ");

        return result;
      }else{
        showAlertDialogOtherERRORSearch(context,statusCode, statusCode);


      }
    }else{
      if (Serial.text == "") {
        setState(() {
          emptySerial = true;
        });

      }}

  }


  showAlertDialogERRORSearch(BuildContext context, arabicMessage, englishMessage) {
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
          checkDataSerach=false;
          SearchSimStock=[];
          SearchsimTypeSerialsList=[];
          Serial.text="";
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
              checkDataSerach=false;
              SearchSimStock=[];
              SearchsimTypeSerialsList=[];
              Serial.text="";
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
  showAlertDialogUnotherizedERRORSearch(BuildContext context, arabicMessage, englishMessage) {
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
  showAlertDialogOtherERRORSearch(BuildContext context, arabicMessage, englishMessage) {
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
  showAlertDialogNoDataSearch(BuildContext context, arabicMessage, englishMessage) {
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
            setState(() {
              SearchSimStock=[];
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
  /*********************************************************************************************************/
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
        child:GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Color(0xFFEBECF1),
            appBar: AppBar(
              backgroundColor: Color(0xFF392156),
              title: Text("AccountManager.SIMStocks".tr().toString(),),
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

                padding: EdgeInsets.only(top:0,bottom: 2,left: 0,right:0),
                children: <Widget>[
                 // flagSearch
                  SimStock.length==0? Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 26, right: 26,top: 80),
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

                      )): flagSearch==false?
                  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child:
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                      itemCount: SimStock.length,
                      itemBuilder: (BuildContext context, int index) {
                        //   itemCount :  UserList.length,
                        return  Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white
                          ),
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.only(left: 10, right: 10,bottom: 2),
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
                                          Text( "AccountManager.SIMType".tr().toString(),),
                                          SizedBox(height: 1),
                                          Text(SimStock[index]["simType"]==null?"--":SimStock[index]["simType"].length==0?"--":SimStock[index]["simType"],
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
                                          Text(SimStock[index]["quantity"]==null?"--":SimStock[index]["quantity"].toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
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
                                                builder: (context) => SIMCardDetails(PermessionCorporate, role,SimStock,index),
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

                  ):Container(),


                  /*************************************************/
                  SearchSimStock.length==0 && flagSearch==true?
                  Container(
                      width: double.infinity,
                      padding: EdgeInsets.only(left: 26, right: 26,top: 80),
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

                      )):  flagSearch==true?  Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child:
                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                      itemCount: SearchsimTypeSerialsList.length,
                      itemBuilder: (BuildContext context, int index) {
                        //   itemCount :  UserList.length,
                        return  Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white
                          ),
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.only(left: 10, right: 10,bottom: 2),
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
                                          Text( "AccountManager.SIMType".tr().toString(),),
                                          SizedBox(height: 1),
                                          Text(SearchSimStock[index]["simType"]==null?"--":SearchSimStock[index]["simType"].length==0?"--":SearchSimStock[index]["simType"],
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
                                          Text(SearchSimStock[index]["quantity"]==null?"--":SearchSimStock[index]["quantity"].toString(),
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                          SizedBox(
                                            height: 5,
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
                                                builder: (context) => SIMCardDetails(PermessionCorporate, role,SearchSimStock,index),
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

                  ):Container(),
                ])
          :Container(),


            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
                color: Color(0xFFEBECF1),
                child: SingleChildScrollView(
                  child: Column(
                    children: [

                      SizedBox(
                        height:12,
                      ),





                      Container(
                        padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                        child: Row(
                          children: [
                            RichText(
                              text: TextSpan(
                                text:
                                "AccountManager.SerialsNumber".tr().toString(),
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
                        padding: EdgeInsets.only(left: 20,right: 20,bottom: 5),

                        child:
                        Row(children: [
                          buildSerialsNumber(),

                        ],),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20,right: 20),
                        child:
                        Row(children: [
                          emptySerial  == true
                              ? RequiredFeild(
                              text: "Menu_Form.msisdn_required".tr().toString())
                              : Container(),

                        ],),
                      ),

                      /**************************************************************************************************************/

                      buildSearchBtn()
                    ],
                  ),
                )),





































       /*   bottomNavigationBar: BottomAppBar(
              child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color(0xFFEBECF1),

                  ),
                  child: SingleChildScrollView(
                    child:Column(
                      children: [
                        SizedBox(height: 8),
                        Container(
                          padding: EdgeInsets.only(left: 20,right: 20,bottom: 10,top: 10),

                          child:
                          Row(children: [
                            RichText(
                              text: TextSpan(
                                text:
                                "AccountManager.SerialsNumber".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                          ],),
                        ),

                        Container(
                          padding: EdgeInsets.only(left: 20,right: 20,bottom: 5),

                          child:
                          Row(children: [
                            buildSerialsNumber(),

                          ],),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20,right: 20),
                          child:
                          Row(children: [
                            emptySerial  == true
                                ? RequiredFeild(
                                text: "Menu_Form.msisdn_required".tr().toString())
                                : Container(),

                          ],),
                        ),
                        SizedBox(height: 8,),
                    buildSearchBtn()
                      ],
                    ),
                  )
              ),
            ),*/



          ),
        ));
  }
}



