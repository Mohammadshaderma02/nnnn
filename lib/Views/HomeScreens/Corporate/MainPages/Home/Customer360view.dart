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
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360Menu/Authorized/AuthorizedContractors.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360Menu/FOCDiscountHistory/FOCDiscountHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360Menu/FreeUnitsHistory/FreeUnitsHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360Menu/GiveawayHistory/GiveawayHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/KurmalekView/Kurmalek.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/MainPromotions/MainPromotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/AdjustmentLogs.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillingDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/BlineLedger.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/CustomerClientMessages.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/OnlineChargingvalues.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/PresetRisk.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Promotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/SubscriberClientMessages.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/SubscriberList.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Unbilled.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/UpdateCustomer/UpdateCustomer.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Balance.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria.block.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_events.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/VPNDetails.dart';

import 'Subscriber360Menu/BillShock.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'SubscriberServices/subscriberservices.dart';


class Customer360view extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  String searchCraretia;
  String msisdn;
  String customerNumber;
  List data=[];

  Customer360view(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _Customer360viewState createState() =>
      _Customer360viewState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();


class _Customer360viewState extends State<Customer360view> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  DateTime backButtonPressedTime;
  String msisdn;
  String customerNumber;
  List data=[];
  List ClientMessages=[];
  bool checkData=false;
  String messageEn;
  String messageAr;
  String activeDate;
  String searchCraretia;
  bool isLoading=true;
  String billRunDate;
  String currentDeliveryMethod;
  String aramexLatestDeliveryDate;
  String emailLatestDeliveryDate;
  String presetLimitValue;
  double averageProfit;
  double totalBalance;
  var depositValue;
  String marketType;
  String subMarket;
  String  billLanguage;
  final List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  SearchCriteriaBloc searchCriteriaBloc;
  _Customer360viewState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


  //*******************   List Item for First Menu    ****************/
  List litemsFirst = [
    ListContentFirst(name:"corpMenu.UpdateCustomer​".tr().toString()),
    ListContentFirst(name:"corpMenu.AuthorizedContracts".tr().toString()),
    ListContentFirst(name:"corpMenu.FreeUnitsHistory".tr().toString()),
    ListContentFirst(name:"corpMenu.GiveAwayHistory​".tr().toString()),
    ListContentFirst(name:"corpMenu.FOCDiscountHistory".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name:"corpMenu.Promotions".tr().toString()),
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

      print("PRINT Data");
      print(this.data[0]);

      setState(() {
      //  totalBalance=double.parse( this.data[0]['balance']);
        //averageProfit= double.parse( this.data[0]['averageProfitIncludeSubsidy']);
      });

      customerDetailes_API();
      getClientMessages_API();

      print("/**************searchCraretia************/");
      print(this.searchCraretia);
      print("/**************searchCraretia************/");


    }

   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

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


  customerDetailes_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": customerNumber,

    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getCustomerDeliveryMethod';
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
    print(body);
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
          billRunDate=result["data"]["billRunDate"];
          currentDeliveryMethod=result["data"]["currentDeliveryMethod"];
          aramexLatestDeliveryDate= result["data"]["aramexLatestDeliveryDate"];
          emailLatestDeliveryDate=result["data"]["emailLatestDeliveryDate"];
          presetLimitValue=result["data"]["presetLimitValue"];
          depositValue=result["data"]["depositValue"];
          marketType= result["data"]["marketType"];
          subMarket= result["data"]["subMarket"];
          billLanguage= result["data"]["billLanguage"];


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
      print(urls.BASE_URL +'/Customer360/getCustomerDeliveryMethod');


      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }

  getClientMessages_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": this.customerNumber,
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
      UnotherizedError();
      print('401  error ');
      /*showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
      setState(() {
        isLoading =false;
      });*/
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
          messageEn=result["message"];
          messageAr=result["messageAr"];
        });
        /* showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

        setState(() {
          checkData=true;
        });*/
      }else if(result["data"]!=null||result["data"].length!=0){
        setState(() {
          ClientMessages=result["data"];
        });
      }
      else{
        /* showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoading =false;
        });*/

      }



      print('Sucses API');
      print(urls.BASE_URL +'/getClientMessages');


      return result;
    }else{
      //showAlertDialogOtherERROR(context,statusCode, statusCode);

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
                                            if(litemsFirst[index].name=="corpMenu.AuthorizedContracts".tr().toString()){

                                            Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                            builder: (context) => AuthorizedContractors(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),
                                            );

                                            }

                                            if(litemsFirst[index].name=="corpMenu.FreeUnitsHistory".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FreeUnitsHistory(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );

                                            }

                                            if(litemsFirst[index].name=="corpMenu.GiveAwayHistory​".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => GiveawayHistory(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );

                                              /* Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FOCDiscountHistory(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );*/

                                            }
                                            if(litemsFirst[index].name=="corpMenu.FOCDiscountHistory".tr().toString()){



                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FOCDiscountHistory(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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

                                            if(litemsFirst[index].name=="corpMenu.Subscriber_Services".tr().toString()){



                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SubscriberServices(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );

                                            }
                                            if(litemsFirst[index].name=="corpMenu.UpdateCustomer​".tr().toString()){



                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => UpdateCustomer(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
    return BlocListener<SearchCriteriaBloc, SearchCriteriaState>(
        listener: (context, state) {
          if(state is SearchCriteriaErrorState ) {
            showAlertDialogError(context,state.arabicMessage,state.englishMessage);

          }
          if (state is SearchCriteriaSuccessState) {

            setState(() {
              data=state.data;
              msisdn=state.msisdn;
              customerNumber=state.customerNumber;

            });
            print("DATA DATA DATA");
            print(state.data);


          }
        },child:WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF392156),
              title: Text("corpMenu.Customer_360_View".tr().toString()),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Screen360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
                    ),
                  );

                },
              ), //<Widget>[]

              actions: <Widget>[



                new Padding(padding: const EdgeInsets.all(10.0),

                  child: new Container(
                      height: 150.0,
                      width: 30.0,
                      child: new GestureDetector(
                        onTap: () {
                          ClientMessages.length ==0?  showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                              ? messageEn
                              : messageAr,
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true):

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CustomerClientMessages(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                            ),

                          );
                        },

                        child: new Stack(

                          children: <Widget>[
                            new IconButton(icon: new Icon(Icons.email_outlined,
                              color: Colors.white,),
                              onPressed: null,
                            ),
                            ClientMessages.length ==0 ? new Container() :
                            new Positioned(

                                child: new Stack(
                                  children: <Widget>[
                                    new Icon(
                                        Icons.brightness_1,
                                        size: 20.0, color: Color(0xffFB0404)),
                                    new Positioned(
                                        top: 1.0,
                                        right: 1.0,
                                        left: 1.0,
                                        bottom: 1.0,
                                        child: new Center(
                                          child: new Text(
                                            ClientMessages.length.toString(),
                                            style: new TextStyle(
                                                color: Colors.white,
                                                fontSize: 11.0,
                                                fontWeight: FontWeight.w500
                                            ),
                                          ),
                                        )),


                                  ],
                                )),

                          ],
                        ),
                      )
                  )

                  ,),

                IconButton(
                  icon:  Icon(Icons.more_vert,color: Colors.white,),
                  onPressed:(){
                    _showMoreOptionDialog();

                  }  ,
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
                ///////////////////////////////////First Content//////////////////////////////////////////////////////////
                Container(
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
                                this.data[0]['customerName'],
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
                                this.data[0]['msisdn'],
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

                ///////////////////////////////////End First Content//////////////////////////////////////////////////////////

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
                        child: Container(
                            color: Colors.white,
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                            // margin: EdgeInsets.all(12),
                            margin: EdgeInsets.only(bottom: 5),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [

                                  Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                      "SubscriberView.AccountNumber".tr().toString() +
                                          "   ",
                                    ),
                                  ),

                                  Text(
                                    this.customerNumber,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ),

                                  billRunDate!=null? Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                      "Customer360View.billRunDate"
                                          .tr()
                                          .toString(),
                                    ),
                                  ):Container(),

                                  billRunDate!=null?Text(billRunDate.length==0 || billRunDate.length=='' ?'-':billRunDate,

                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ):Container(),



                                  currentDeliveryMethod!=null?  Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                      "Customer360View.currentDeliveryMethod"
                                          .tr()
                                          .toString(),
                                    ),
                                  ):Container(),

                                  currentDeliveryMethod!=null? Text(
                                    currentDeliveryMethod==''||currentDeliveryMethod.length==0?'-':currentDeliveryMethod,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ):Container(),



                                /*  aramexLatestDeliveryDate!=null?
                                  Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                        "Customer360View.aramexLatestDeliveryDate".tr().toString()
                                    ),
                                  ):Container(),*/
                                  /*aramexLatestDeliveryDate!=null?Text(
                                    aramexLatestDeliveryDate==''||aramexLatestDeliveryDate.length==0?'-':aramexLatestDeliveryDate,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ):Container(),*/

                                  emailLatestDeliveryDate!=null?Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                      "Customer360View.emailLatestDeliveryDate"
                                          .tr()
                                          .toString(),
                                    ),
                                  ):Container(),
                                  emailLatestDeliveryDate!=null?Text(
                                    emailLatestDeliveryDate==''||emailLatestDeliveryDate.length==0?'-':emailLatestDeliveryDate,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14.0,
                                    ),
                                  ):Container(),



                                  presetLimitValue!=null?Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                        "Customer360View.presetLimitValue".tr().toString()
                                    ),
                                  ):Container(),
                                  presetLimitValue!=null?Text(presetLimitValue==''||presetLimitValue.length==0?'-':presetLimitValue,

                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ):Container(),

                                  depositValue!=null? Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                        "Customer360View.depositValue".tr().toString()
                                    ),
                                  ):Container(),

                                  depositValue!=null? Text(
                                    depositValue=='' ?'-':depositValue.toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ):Container(),
                                  /**************************************************************************/
                                  /****************************Based on searchCraretia***********************/

                                  searchCraretia == "Mobile Number" || marketType==null?Container(): Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                        "Customer360View.marketType".tr().toString()
                                    ),
                                  ),

                                  searchCraretia == "Mobile Number" ||  marketType==null?Container():Text(
                                    marketType==''||marketType.length==0?'-':marketType,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ),

                                  /**************************************************************************/
                                  /**************************************************************************/
                                  searchCraretia == "Mobile Number" || marketType==null?Container():Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                        "Customer360View.marketType".tr().toString()
                                    ),
                                  ),

                                  searchCraretia == "Mobile Number" || marketType==null?Container():Text(
                                    marketType==''||marketType.length==0?'-':marketType,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ),

                                  billLanguage!=null?  Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                        "Customer360View.billLanguage".tr().toString()
                                    ),
                                  ):Container(),

                                  billLanguage!=null? Text(
                                    billLanguage==''||billLanguage.length==0?'-':billLanguage,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ):Container(),


                                  this.data[0]["averageProfitIncludeSubsidy"]!=null? Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                        "Customer360View.AverageProfit".tr().toString()
                                    ),
                                  ):Container(),
                                  this.data[0]["averageProfitIncludeSubsidy"]!=null?Text(
                                      this.data[0]["averageProfitIncludeSubsidy"]=='' ?'-':this.data[0]["averageProfitIncludeSubsidy"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ):Container(),


                                  this.data[0]["balance"]!=null? Padding(
                                    padding: const EdgeInsets.only(top:20,bottom:1.0),
                                    child: Text(
                                        "Customer360View.TotalBalance".tr().toString()
                                    ),
                                  ):Container(),

                                  this.data[0]["balance"]!=null?Text(
                                   totalBalance==''?'-':this.data[0]["balance"].toString(),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,

                                      fontSize: 14.0,
                                    ),
                                  ):Container(),


                                ]))),

                ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
              ],
            )
                : Center(
              child: Text(role),
            ),

          ),
        )));
  }
}
