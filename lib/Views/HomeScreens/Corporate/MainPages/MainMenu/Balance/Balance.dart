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
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/360View.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360Menu/Authorized/AuthorizedContractors.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360Menu/FOCDiscountHistory/FOCDiscountHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360Menu/FreeUnitsHistory/FreeUnitsHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360Menu/GiveawayHistory/GiveawayHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/KurmalekView/Kurmalek.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/MainPromotions/MainPromotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/SubscriberList.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Aging.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/CreditNotes.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Invoices.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/InvoicesList.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Ledger.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/PostDataChecks.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Unbilled.dart';

import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


import 'package:sales_app/Shared/BaseUrl.dart';

import '../../Home/SubscriberServices/subscriberservices.dart';


class Balance extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  String searchCraretia;
  String msisdn;
  String customerNumber;
  List data=[];

  Balance(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _BalanceState createState() =>
      _BalanceState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();


class _BalanceState extends State<Balance> {
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



  String paymentMethod;
  String deposit;
  String creditCardNumber;
  String writeOffAmount;
  String handsetObligation;
  String lastMonthARPU;
  String secondMonthARPU;
  String thirdMonthARPU;
  String totalBalance;
  String reconnectionAmount;






  final List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;

  _BalanceState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);

  //*******************   List Item for First Menu    ****************/
  List litemsFirst = [
   /* ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name:"corpMenu.Promotions".tr().toString()),
    ListContentFirst(name:"corpMenu.Kurmalek".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),*/


    ListContentFirst(name:"Balance.Ledger".tr().toString()),
    ListContentFirst(name:"Balance.InvoicesList".tr().toString()),
    ListContentFirst(name:"Balance.CreditNotes".tr().toString()),
    ListContentFirst(name:"Balance.PostDatedChecks".tr().toString()),
    ListContentFirst(name:"Balance.Unbilled".tr().toString()),
    ListContentFirst(name:"Balance.Invoices".tr().toString()),
    ListContentFirst(name:"Balance.Aging".tr().toString()),

    ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),
    ListContentFirst(name:"corpMenu.Kurmalek".tr().toString()),
    ListContentFirst(name:"corpMenu.Promotions".tr().toString()),
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

      print("PRINT Data");
      print (this.data);


      customerBalanceDetailes_API();
      getCustomerReconnectionAmount_API();

    }

    //disableCapture();
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

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

  customerBalanceDetailes_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": customerNumber,

    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getCustomerBalanceDetails';
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
    //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
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
        if( result["data"]['creditCardDetails']==null ||result["data"]['creditCardDetails'].length==0){
          setState(() {
            creditCardNumber="--";
          });
        }else{
          setState(() {
            creditCardNumber=  result["data"]['creditCardDetails'][0]['creditCardNumber']==null?'--':result["data"]['creditCardDetails'][0]['creditCardNumber'].length==0?'--':result["data"]['creditCardDetails'][0]['creditCardNumber'];

          });
        }

        if( result["data"]['arrayOfARPU']==null ||result["data"]['arrayOfARPU'].length==0){
          setState(() {
            lastMonthARPU="--";
            secondMonthARPU="--";
            thirdMonthARPU="--";

          });
        }else{
          setState(() {
            lastMonthARPU=  result["data"]['arrayOfARPU'][0]['lastMonthARPU']==null?'--':result["data"]['arrayOfARPU'][0]['lastMonthARPU'].length==0?'--':result["data"]['arrayOfARPU'][0]['lastMonthARPU'];
            secondMonthARPU=  result["data"]['arrayOfARPU'][0]['secondMonthARPU']==null?'--':result["data"]['arrayOfARPU'][0]['secondMonthARPU'].length==0?'--':result["data"]['arrayOfARPU'][0]['secondMonthARPU'];
            thirdMonthARPU=  result["data"]['arrayOfARPU'][0]['thirdMonthARPU']==null?'--':result["data"]['arrayOfARPU'][0]['thirdMonthARPU'].length==0?'--':result["data"]['arrayOfARPU'][0]['thirdMonthARPU'];


          });
        }
          paymentMethod=result["data"]['paymentMethod']==null?'--':result["data"]['paymentMethod'].length==0?'--':result["data"]['paymentMethod'];
          writeOffAmount=result["data"]['writeOffAmount']==null?'--':result["data"]['writeOffAmount'].length==0?'--':result["data"]['writeOffAmount'];
          handsetObligation=result["data"]['handsetObligation']==null?'--':result["data"]['handsetObligation'].length==0?'--':result["data"]['handsetObligation'];
          deposit=result["data"]['deposit']==null?'--':result["data"]['deposit'].length==0?'--':result["data"]['deposit'];
         totalBalance=result["data"]['totalBalance']==null?'--':result["data"]['totalBalance'].length==0?'--':result["data"]['totalBalance'];
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
      print(urls.BASE_URL +'/Customer360/getCustomerBalanceDetails');


      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }


  getCustomerReconnectionAmount_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": customerNumber,

    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getCustomerReconnectionAmount';
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
          reconnectionAmount=result["data"]['reconnectionAmount'];

          //isLoading =false;
        });

      }
      else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          //isLoading =false;
        });

      }




      print('Sucses API');
      print(urls.BASE_URL +'/Customer360/getCustomerReconnectionAmount');


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

                                            if(litemsFirst[index].name=="Balance.Ledger".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Ledger(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );

                                            }

                                            if(litemsFirst[index].name=="Balance.InvoicesList".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => InvoicesList(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );

                                            }
                                            if(litemsFirst[index].name=="Balance.CreditNotes".tr().toString()){


                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => CreditNotes(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );

                                            }
                                            if(litemsFirst[index].name=="Balance.PostDatedChecks".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => PostDataChecks(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );

                                            }
                                            if(litemsFirst[index].name=="Balance.Unbilled".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Unbilled(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );

                                            }
                                            if(litemsFirst[index].name=="Balance.Invoices".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Invoices(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );

                                            }
                                            if(litemsFirst[index].name=="Balance.Aging".tr().toString()){

                                             Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Aging(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                                            if(litemsFirst[index].name=="corpMenu.Kurmalek".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Kurmalek(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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

                                            if(litemsFirst[index].name=="corpMenu.Subscriber_360_View".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Subscriber360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
///////////////////////////////////// End Two menus /////////////////////////////////////

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);
    /*  Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Screen360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
        ),
      );*/
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
              title: Text("corpMenu.Balance".tr().toString(),),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  Navigator.pop(context);
                 // Navigator.pop(context);
                 /* Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Screen360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
                    ),
                  );*/
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
                            //////////////////////////////////////////////////////
                            Text( "Balance.PaymentMethod".tr().toString(),),
                            SizedBox(height: 1),
                            Text(paymentMethod,
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
                            Text("Balance.WriteOffAmount".tr().toString(),),
                            SizedBox(height: 1),
                            Text(writeOffAmount,
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
                            Text("Balance.HandsetObligation".tr().toString(),),
                            SizedBox(height: 1),
                            Text(
                             handsetObligation,
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
                            Text("Balance.Deposit".tr().toString(),),
                            SizedBox(height: 1),
                            Text(
                              deposit,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            //////////////////////////////////////////////////////

                            SizedBox(
                              height: 20,
                            ),  //////////////////////////////////////////////////////
                            Text("Balance.TotalBalance".tr().toString(),),
                            SizedBox(height: 1),
                            Text(
                             totalBalance,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            //////////////////////////////////////////////////////

                            SizedBox(
                              height: 20,
                            ),  //////////////////////////////////////////////////////
                            Text("Balance.ReconnectionAmount".tr().toString(),),
                            SizedBox(height: 1),
                            Text(
                              reconnectionAmount==null?'--':reconnectionAmount.length==0?"-":reconnectionAmount,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),
                            //////////////////////////////////////////////////////

                            SizedBox(
                              height: 20,
                            ),  //////////////////////////////////////////////////////
                            Text("Balance.LawyerName".tr().toString(),),
                            SizedBox(height: 1),
                            Text(this.data[0]['lawyerName']==null?'--':this.data[0]['lawyerName'].length==0?"--":this.data[0]['lawyerName'],
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
                      //////////////////////////////////////////////////////
                      /***************************************************/
                     /* Container(
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
                            "Balance.CreditCardDetails".tr().toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.normal,
                                fontSize: 16.0,
                              ),
                            ),])),*/
                      //////////////////////////////////////////////////////
                     /* Container(
                          color: Colors.white,
                          width: double.infinity,
                          padding: EdgeInsets.only(left: 26, right: 26),
                          // margin: EdgeInsets.all(12),
                          // margin: EdgeInsets.only(bottom: 5),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 15),
                                Text("Balance.CardNumber".tr().toString(),),
                                SizedBox(height: 1),
                                Text(
                                 creditCardNumber,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14.0,
                                  ),
                                ),
                                SizedBox(height: 15),
                              ])),*/
                      /****************************************************/
                      //////////////////////////////////////////////////////
                      /***************************************************/
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
                                  "Balance.ARPU".tr().toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    fontSize: 16.0,
                                  ),
                                ),])),
                      //////////////////////////////////////////////////////
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
                            Text( "Balance.SecondMonthARPU".tr().toString(),),
                            SizedBox(height: 1),
                            Text(secondMonthARPU,
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
                            Text("Balance.ThirdMonthARPU".tr().toString(),),
                            SizedBox(height: 1),
                            Text(thirdMonthARPU,
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
                            Text("Balance.LastMonthARPU".tr().toString(),),
                            SizedBox(height: 1),
                            Text(
                              lastMonthARPU,
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
                        height: 20,
                      ),




                     /* SizedBox(
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

                      ),*/
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
