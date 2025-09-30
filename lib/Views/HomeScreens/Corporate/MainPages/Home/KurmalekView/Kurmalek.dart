import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/360View.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/KurmalekView/KurmalekPointsDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/KurmalekView/KurmalekRedemptionHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/MainPromotions/MainPromotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/AdjustmentLogs.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillShock.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillingDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/SubscriberMonetTransferRequest.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/SubscriberRechargesDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/OnlineChargingvalues.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/PresetRisk.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Promotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/SubscriberList.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Unbilled.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/VPNDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Balance.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../SubscriberServices/subscriberservices.dart';




class Kurmalek extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  Kurmalek(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _KurmalekState createState() =>
      _KurmalekState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _KurmalekState extends State<Kurmalek> {
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

  ///////////////////////End variable from API/////////////////////////////////

  TextEditingController tawasol_number = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();
  _KurmalekState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


  //*******************   List Item for First Menu    ****************/
  List litemsFirst = [
    ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),
    ListContentFirst(name:"corpMenu.Promotions".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),
    ListContentFirst(name:"corpMenu.Balance".tr().toString()),
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
      Unbilled_API ();
    }

    //disableCapture();
    super.initState();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }



  Unbilled_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": customerNumber,
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getKurmalakCustomerInfo';
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
  //    showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
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
      /*if(result["data"]==null || result["data"].length==0){
        showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

        setState(() {
          checkData=true;
        });
      }*/
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
      print(urls.BASE_URL +'/Customer360/getUnbilledAmounts');

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

              padding: EdgeInsets.only(top: 12,bottom: 12,left: 8,right: 8),
              // color: Color(0xFFF3F4F7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFFF3F4F7),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
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

                                            if(litemsFirst[index].name=="SubscriberList.Subscriber_List".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SubscriberList(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );


                                            }
                                            if(litemsFirst[index].name=="corpMenu.Customer_360_View".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Customer360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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


                                            if(litemsFirst[index].name=="corpMenu.Balance".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Balance(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );

                                            }


                                            if(litemsFirst[index].name=="corpMenu.Promotions".tr().toString()){
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MainPromotions(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );

                                            }

                                            if(litemsFirst[index].name=="corpMenu.Subscriber_Services".tr().toString()){



                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SubscriberServices(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
          builder: (context) => Screen360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
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
              title: Text("corpMenu.Kurmalek".tr().toString(),),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  //Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Screen360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
                    ),
                  );
                },
              ), //<Widget>[]

              actions: <Widget>[
                IconButton(
                  icon:  Icon(Icons.more_vert,color: Colors.white,),
                  onPressed: ( _showMoreOptionDialog) ,
                ), //IconButton//IconButton
              ],
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
                            Text( "Kurmalek.dateofenrollment".tr().toString(),),
                            SizedBox(height: 1),
                            Text(
                              dataOfEnrollment==null?"--":  dataOfEnrollment.length==0?"-":dataOfEnrollment,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            Text("Kurmalek.TotalPoints".tr().toString(),),
                            SizedBox(height: 1),
                            Text(
                              pointsCount==null?"--" : pointsCount.length==0?"--":pointsCount,

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),

                              Text("Kurmalek.TotalKurmalekPoints".tr().toString(),),
                            SizedBox(height: 1),

                            Text(
                              totalPointsCount==null?"--" : totalPointsCount.length==0?"--":totalPointsCount,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),



                            SizedBox(
                              height: 20,
                            ),

                          ],
                        ),
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

            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton:
            Container(

                color: Color(0xFFEBECF1),
                child: SingleChildScrollView(
                  child:Column(
                    children: [
                      //


                      SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child:  Card(
                          color: Color(0xFF0E7074),
                          borderOnForeground: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  title: Text("Kurmalek.KurmalekPointDetails".tr().toString(),
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
                                        builder: (context) => KurmalekPointsDetails(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                                  title: Text("Kurmalek.RedemptionHistory".tr().toString(),
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
                                        builder: (context) => KurmalekRedemptionHistory(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                )
            ),
          ),
        ));
  }
}
