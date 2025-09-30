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
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
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





class LogVisitMenu extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  LogVisitMenu(this.PermessionCorporate, this.role);
  @override
  _LogVisitMenuState createState() =>
      _LogVisitMenuState(this.PermessionCorporate, this.role);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _LogVisitMenuState extends State<LogVisitMenu> {
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
  _LogVisitMenuState(this.PermessionCorporate, this.role);


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
   // disableCapture();
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
     /* setState(() {
        NoSearch =true;
      });*/
      print("New User");

    }else{
     /* setState(() {
        NoSearch =false;
      });*/

      print("Not New User");
    }
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
    /************************2023****************/
    Map test = {
      "customerId": customerNumber,
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



//////////////////////////// This Function Contains Two menus ////////////////////////////
  Future<void> _showMoreOptionDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(
              width: MediaQuery.of(context).size.width - 20,
              height: MediaQuery.of(context).size.height -  90,
              padding: EdgeInsets.only(top: 12,bottom: 12,left: 8,right: 8),
              // color: Color(0xFFF3F4F7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFFF3F4F7),
              ),
              child: Column(
                children: [
                  Flexible(
                    child:Container(
                        padding: EdgeInsets.only(top:5,bottom: 5,left: 0,right: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top:8,bottom: 8,left: 0,right: 0),
                          shrinkWrap: true,
                          itemCount: litemsFirst.length,
                          itemBuilder: (BuildContext context, int index) {
                            return  Container(
                                color: Colors.white,
                                child: Column(
                                    children:[
                                      SizedBox(
                                        child:
                                        litemsFirst[index].name=="-"?
                                        Container(
                                          color: Color(0xFFF3F4F7),
                                          height: 10,):
                                        ListTile(
                                          dense: true,
                                          title: Text(
                                            litemsFirst[index].name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF2F2F2F),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          trailing: IconButton(
                                            icon: EasyLocalization.of(context).locale ==
                                                Locale("en", "US")
                                                ? Icon(Icons.keyboard_arrow_right)
                                                : Icon(Icons.keyboard_arrow_left),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);
                                            if(litemsFirst[index].name=="SubscriberView.VPNDetails".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => VPNDetails(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }
                                            if(litemsFirst[index].name=="billShockView.BillShock".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BillShock(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }
                                            if(litemsFirst[index].name=="billingDetailsView.BillingDetails".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BillingDetails(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }
                                            if(litemsFirst[index].name=="adjustmentLogsViews.AdjustmentLOG".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => AdjustmentLogs(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }
                                            if(litemsFirst[index].name=="OnlineChargingValuesViews.OnlineChargingvalues".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => OnlineChargingValues(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }
                                            if(litemsFirst[index].name=="SubscriberView.PresetRisk".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PresetRisk(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }
                                            if(litemsFirst[index].name=="PromotionsView.PromotionsDetails".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Promotions(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }
                                            if(litemsFirst[index].name=="UnbilledView.Unbilled".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Unbilled(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );


                                            }
                                            if(litemsFirst[index].name=="corpMenu.Subscriber_360_View".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Subscriber360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }


                                          },

                                        ),


                                      )
                                      /* index!= UserList.length-1 ?
                                  Divider(
                                    thickness: 1,
                                    color: Color(0xFFedeff3),
                                  ):Container(),*/
                                    ]
                                )
                            );


                          },
                        )),
                  ),

                  SizedBox(height: 10,),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFF0E7074),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],

              ),
            ),

          ),

        );



      },
    );
  }
///////////////////////////////////// End Two menus /////////////////////////////////////
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
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
              title: Text("LogVisit.LogVisitMenu".tr().toString()),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  Navigator.pop(context);
                },
              ), //<Widget>[]

              //IconButton//IconButton
            ),

            backgroundColor: Color(0xFFEBECF1),


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
                          color: Color(0xFF0E7074),
                          borderOnForeground: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              /* ListTile(
                                  title: Text("LogVisit.Log_Visit".tr().toString(),
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                        : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                                  ),
                                  onTap: NoSearch==true?(){
                                  showToast(
                                      EasyLocalization.of(context).locale == Locale("en", "US")
                                          ? "Please make sure to search by any category in home screen and accept the agreement, then you can view log visit"
                                          : "رجى التأكد من البحث حسب أي فئة في الشاشة الرئيسية وقبول الاتفاقية ، ثم يمكنك عرض زيارة السجل",
                                      context: context,
                                      animation: StyledToastAnimation.scale,
                                      fullWidth: true);}
                                      :
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LogVisitMain(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                      ),

                                    );
                                  }
                              ),*/
                              ListTile(
                                  title: Text("LogVisit.Log_Visit".tr().toString(),
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                        : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                                  ),
                                  onTap:   () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LogVisitMain(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                            /*  ListTile(
                                  title: Text("LogVisit.visit_history".tr().toString(),
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

                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LogVisitHistory(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                      ),

                                    );
                                  }
                              ),*/
                               ListTile(
                                  title: Text("LogVisit.visit_history".tr().toString(),
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                        : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                                  ),
                                  onTap:
                                      () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LogVisitHistory(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
