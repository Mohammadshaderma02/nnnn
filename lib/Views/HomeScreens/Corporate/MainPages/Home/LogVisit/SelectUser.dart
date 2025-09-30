import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/LogVisit/LogVisitMenu.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/MainPromotions/SubsidyPromotion.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/MainPromotions/TransferHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/AdjustmentLogs.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillShock.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillingDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/SubscriberMonetTransferRequest.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/SubscriberRechargesDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/OnlineChargingvalues.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/PresetRisk.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Promotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Unbilled.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/VPNDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/SubscriberServices/ChangeSIM.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/SubscriberServices/UpdateSubscriber.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'LogVisitHistory.dart';
import 'LogVisitMain.dart';





class SelectUser extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  SelectUser(this.PermessionCorporate, this.role);
  @override
  _SelectUserState createState() =>
      _SelectUserState(this.PermessionCorporate, this.role);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _SelectUserState extends State<SelectUser> {
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
  bool isLoading = true;
  ///////////////////////variable from API//////////////////////////////////////
  bool checkData=false;
  String totalPointsCount;

  String dataOfEnrollment;
  String pointsCount;

  String SubscriberNumber='';
  String customerName='';
  bool FirstContentFlag=false;
  bool NoSearch=true;


  ///////////////////////End variable from API/////////////////////////////////

  TextEditingController tawasol_number = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();
  _SelectUserState(this.PermessionCorporate, this.role);


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
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{

    }
    checkPrefs();
    checkIndexPage ();
    //disableCapture();
    super.initState();
  }
  void checkIndexPage () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('SavePageIndex');
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }

  void checkPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey("newUser")){
      await prefs.remove('newUser');
      //await pref.clear();
    }


    if(prefs.containsKey("customerID")==false){
      setState(() {
        NoSearch =true;
        prefs.setString('newUser','yes');

      });


    }else{
      setState(() {
        NoSearch =false;
        prefs.setString('newUser','No');

      });
    }
    if (prefs.containsKey("customerID")) {
      setState(() {
        customerNumber = prefs.getString("customerID");
        FirstContentFlag = true;
      });
    }
    if (prefs.containsKey("customerID")) {
      setState(() {
        customerNumber = prefs.getString("customerID");
        FirstContentFlag = true;
      });
    }
    if (prefs.containsKey("customerName")) {
      setState(() {
        customerName = prefs.getString("customerName");
        FirstContentFlag = true;
      });
    }
    if (prefs.containsKey("SubscriberNumber")) {
      setState(() {
        SubscriberNumber = prefs.getString("SubscriberNumber");
        FirstContentFlag = true;
      });
      print("prefs.getString");
      print(prefs.getString("SubscriberNumber"));
    }
  }


  CustomerEligibleLines_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": "3003757",
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getCustomerEligibleLinesForSubsidy';
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

    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
      //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
      setState(() {
        isLoading =false;
      });

    }
    if (statusCode == 200) {

      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('-------------------------------');
      print(result["data"]);
      if(result["data"]==null){
        showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

        setState(() {
          checkData=true;
        });
      }
      if( result["status"]==0){
        setState(() {
          dataOfEnrollment=result["data"]['dataOfEnrollment'];
          pointsCount=result["data"]['pointsCount'];
          totalPointsCount=result["data"]['totalPointsCount'];

          isLoading =false;
        });

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoading =false;
        });

      }


      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL +'/Customer360/CustomerEligibleLines');

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
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBarSectionCorporate(
              appBar: AppBar(),
              title: Text("LogVisit.LogVisitUsers".tr().toString()),
              PermessionCorporate: PermessionCorporate,
              role: role,
            ),

            backgroundColor: Color(0xffEBECF1),


            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: 8, left: 0, right: 0),
              children: [
                ///////////////////////////////////Second Content//////////////////////////////////////////////////////////

                SingleChildScrollView(
                  child: Column(
                    children: [

                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child:  Card(
                          color:  NoSearch==true? Color(0xFF0E7074).withOpacity(0.3) : Color(0xFF0E7074),
                          borderOnForeground: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[


                              ListTile(
                                  title: Text("LogVisit.Existuser".tr().toString(),
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                        : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                                  ),
                                  onTap:
                                      NoSearch==true?(){
                                      showToast(
                                          EasyLocalization.of(context).locale == Locale("en", "US")
                                              ? "Please make sure to search by any category in home screen and accept the agreement, then you can view visit history"
                                              : "يرجى التأكد من البحث حسب أي فئة في الشاشة الرئيسية وقبول الاتفاقية ، ثم يمكنك عرض سجل الزيارة",
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);}
                                          :

                                      () async{
                                        SharedPreferences prefs = await SharedPreferences.getInstance();
                                        await prefs.remove('newUser');
                                       // prefs.setString('newUser','No');
                                    Navigator.push(

                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LogVisitMenu(PermessionCorporate, role),
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
                          color:  Color(0xFF0E7074),
                          borderOnForeground: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  title: Text("LogVisit.NewUser".tr().toString(),
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                        : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                                  ),
                                  onTap: () async{
                                    SharedPreferences prefs = await SharedPreferences.getInstance();
                                    prefs.setString('newUser','yes');
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LogVisitMenu(PermessionCorporate, role),
                                      ),

                                    );
                                  }
                              ),


                            ],
                          ),
                        ),

                      ),

                    ],
                  ),
                ),
              ],
            )
        ),
      ),

      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////




    );
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