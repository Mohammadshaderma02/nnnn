import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../360View.dart';
import '../Subscriber360view.dart';
import 'AdjustmentLogs.dart';
import 'BillShock.dart';
import 'Bline/BlineLedger.dart';
import 'OnlineChargingvalues.dart';
import 'PresetRisk.dart';
import 'Promotions.dart';
import 'SubscriberList.dart';
import 'Unbilled.dart';
import 'VPNDetails.dart';


class BillingDetails extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  BillingDetails(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _BillingDetailsState createState() =>
      _BillingDetailsState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _BillingDetailsState extends State<BillingDetails> {
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
  bool isLoading =false;
  _BillingDetailsState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);

  var BillingData=[];
  List litemsFirst = [
    ListContentFirst(name:"SubscriberView.VPNDetails".tr().toString()),
    ListContentFirst(name:"billShockView.BillShock".tr().toString()),
    ListContentFirst(name:"adjustmentLogsViews.AdjustmentLOG".tr().toString()),
    ListContentFirst(name:"OnlineChargingValuesViews.OnlineChargingvalues".tr().toString()),
    ListContentFirst(name:"SubscriberView.PresetRisk".tr().toString()),
    ListContentFirst(name:"PromotionsView.PromotionsDetails".tr().toString()),
    ListContentFirst(name:"Bline Ledger"),
    ListContentFirst(name:"UnbilledView.Unbilled".tr().toString()),
    ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),
    ListContentFirst(name:"corpMenu.Promotions".tr().toString()),
    ListContentFirst(name:"corpMenu.Kurmalek".tr().toString()),
    ListContentFirst(name:"corpMenu.Balance".tr().toString()),];


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
      billingDetials_API();
    }

    //disableCapture();
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }


  billingDetials_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isLoading=true;
    });
    var apiArea = urls.BASE_URL + '/Customer360/Billing/services/'+this.msisdn;
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);
      print(result);
      Map<String, dynamic> map = json.decode(response.body);
      List<dynamic> data = map["data"];

      setState(() {
        isLoading=false;

      });
      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{


          setState(() {
            BillingData=data;
            isLoading=false;

          });



        }

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);

      }




      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }

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
           // exit(0);
            Navigator.pop(context);
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

              padding: EdgeInsets.only(top: 12,bottom: 12,left:8,right: 8),
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
                            //   itemCount :  UserList.length,
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
                                            if(litemsFirst[index].name=="Bline Ledger"){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => BlineLedger(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                                                  builder: (context) => Screen360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                        ),
                      )),
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


  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
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
                title: Text("billingDetailsView.BillingDetails".tr().toString()),
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Subscriber360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                      ),

                    );
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
              body: role == "Corporate"
                  ? ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                    children: [
                  ///////////////////////////////////First Content//////////////////////////////////////////////////////////
                 /* Container(
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
                                  "Text",
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
                                  "0795726155",
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
                  ),*/

                  ///////////////////////////////////End First Content//////////////////////////////////////////////////////////

                  ///////////////////////////////////Second Content//////////////////////////////////////////////////////////

                      isLoading==true?Container(
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

                          )):
                      Container(
                    padding: EdgeInsets.only(left: 10, right: 10),
                    child:

                    ListView.builder(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                      itemCount: BillingData.length,
                      itemBuilder: (BuildContext context, int index) {
                        //   itemCount :  UserList.length,
                        return  Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              color: Colors.white
                          ),
                          margin: EdgeInsets.only(bottom: 15),
                          padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                          // margin: EdgeInsets.all(12),

                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

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
                                            height: 20,
                                          ),
                                          Text(
                                            "billingDetailsView.description"
                                                .tr()
                                                .toString(),
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            BillingData[index]['description']!=null?BillingData[index]['description']:'-',
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
                                height: 10,
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
                                            height: 20,
                                          ),
                                          Text(
                                            "billingDetailsView.billCode"
                                                .tr()
                                                .toString(),
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            BillingData[index]['billCode']!=null?BillingData[index]['billCode']:'-',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  SizedBox(width: 10),
                                  //Spacer(),

                                  Expanded(
                                    child: Container(
                                      margin: EdgeInsets.only(left: 5, right: 5),
                                      child: Column(
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                          Text(
                                            "billingDetailsView.unbilledValue"
                                                .tr()
                                                .toString(),
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            BillingData[index]['unbilledValue']!=null?BillingData[index]['unbilledValue']:'-',
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
                                height: 10,
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
                                            height: 20,
                                          ),
                                          Text(
                                            "billingDetailsView.billingRate"
                                                .tr()
                                                .toString(),
                                          ),
                                          SizedBox(height: 1),
                                          Text(
                                            BillingData[index]['billingRate']!=null?BillingData[index]['billingRate']:'-',
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


          ),
        ));
  }
}
