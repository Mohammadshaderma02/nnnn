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
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../../../../../../ReusableComponents/requiredText.dart';
import '../AdjustmentLogs.dart';
import '../BillShock.dart';
import '../BillingDetails.dart';
import '../OnlineChargingvalues.dart';
import '../PresetRisk.dart';
import '../Promotions.dart';
import '../Unbilled.dart';
import '../VPNDetails.dart';
import 'BlineLedger.dart';




class SubscriberMoneyTransferRequest extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  SubscriberMoneyTransferRequest(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _SubscriberMoneyTransferRequestState createState() =>
      _SubscriberMoneyTransferRequestState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _SubscriberMoneyTransferRequestState extends State<SubscriberMoneyTransferRequest> {
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
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool showData =false;
  bool isLoading=false;
  bool checkData=false;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  bool emptyfromDate = false;
  bool emptytoDate = false;
  _SubscriberMoneyTransferRequestState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);

  var SubscriberMoneyTransferRequestData=[];
  List litemsFirst = [
    ListContentFirst(name:"SubscriberView.VPNDetails".tr().toString()),
    ListContentFirst(name:"billShockView.BillShock".tr().toString()),
    ListContentFirst(name:"billingDetailsView.BillingDetails".tr().toString()),
    ListContentFirst(name:"adjustmentLogsViews.AdjustmentLOG".tr().toString()),
    ListContentFirst(name:"OnlineChargingValuesViews.OnlineChargingvalues".tr().toString()),
    ListContentFirst(name:"SubscriberView.PresetRisk".tr().toString()),
    ListContentFirst(name:"PromotionsView.Promotions".tr().toString()),
    ListContentFirst(name:"UnbilledView.Unbilled".tr().toString()),
    ListContentFirst(name:"-"),
    ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),
    ListContentFirst(name:"corpMenu.Promotions".tr().toString()),
    ListContentFirst(name:"corpMenu.Kurmalek".tr().toString()),
    ListContentFirst(name:"corpMenu.Balance".tr().toString()),
  ];


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
    // subscriberMoneyTransferRequestBloc = BlocProvider.of<SubscriberMoneyTransferRequestBloc>(context);


    if (PermessionCorporate == null) {
      UnotherizedError();
    }

    //disableCapture();
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
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

              subscriberMoneyTransferRequest_API();
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

  Widget buildFromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "adjustmentLogsViews.from".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),

          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,

          width:MediaQuery.of(context).size.width/2,
          child: TextField(
            controller: fromDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color:     Color(0xFF656565), ),
            decoration: new InputDecoration(
              enabledBorder: emptyfromDate == true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              ): const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),

              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/calendar_month.png"),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year-25,),
                        lastDate:DateTime(DateTime.now().year+25,),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF392156), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface:     Color(0xFF656565), // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary:
                                  Color(0xFF392156), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((fromData) => {

                          setState(() {
                        from = fromData;
                        fromDate.text =
                        "${fromData.day.toString().padLeft(2, '0')}/${fromData.month.toString().padLeft(2, '0')}/${fromData.year.toString()}";
                      }
                      ),
                    });
                    }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        emptyfromDate
            ? RequiredFeild(
            text: "Reports.this_feild_is_required"
                .tr()
                .toString())
            : Container(),
      ],
    );
  }

  Widget buildToDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "adjustmentLogsViews.to".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),

          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,

          width:MediaQuery.of(context).size.width/2,
          child: TextField(
            controller: toDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color:     Color(0xFF656565), ),
            decoration: new InputDecoration(
              enabledBorder:emptytoDate == true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              ): const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),

              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/calendar_month.png"),
                    onPressed: fromDate == ''
                        ? null
                        : () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year-25,),
                        lastDate:DateTime(DateTime.now().year+25,),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF392156), // header background color
                                onPrimary:
                                Colors.white, // header text color
                                onSurface:
                                Color(0xFF656565), // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Color(
                                      0xFF392156), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((toData) => {
                          setState(() {
                        to = toData;
                        toDate.text =
                        "${toData.day.toString().padLeft(2, '0')}/${toData.month.toString().padLeft(2, '0')}/${toData.year.toString()}";
                      }),
                    });
                    }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        emptytoDate
            ? RequiredFeild(
            text: "Reports.this_feild_is_required"
                .tr()
                .toString())
            : Container(),
      ],
    );
  }

  subscriberMoneyTransferRequest_API ()async {

    setState(() {
      isLoading=true;
    });
    print('called');
    if (fromDate.text != '' && toDate.text != '') {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var apiArea = urls.BASE_URL +
          '/Customer360/getSubscriberMoneyTransferRequests';
      final Uri url = Uri.parse(apiArea);
      prefs.getString("accessToken");
      final access = prefs.getString("accessToken");
      print(url);
      Map body = {
        "msisdn": msisdn,
        "fromDate": from.toIso8601String(),
        "toDate": to.toIso8601String()
      };
      final response = await http.post(url, headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      }, body: json.encode(body),);

      int statusCode = response.statusCode;
      var data = response.request;
      print(statusCode);
      print(data);
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
            showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


          }else{

            setState(() {
              SubscriberMoneyTransferRequestData=result["data"];
              isLoading=false;
              checkData=true;
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
    else{
      if(fromDate.text == ''){
        setState(() {
          emptyfromDate=true;
        });
      }
      if(toDate.text == ''){
        setState(() {
          emptytoDate=true;
        });
      }
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
        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
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

  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text("alert.tryAgain".tr().toString(),
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
      content: Text(EasyLocalization
          .of(context)
          .locale == Locale("en", "US") ? englishMessage : arabicMessage,
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


/////////////////////// End Two menus /////////////////////////////////////


  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlineLedger(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
            title: Text(
                "BlineLedger.SubscriberMoneyTransferRequests".tr().toString()),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async{
                Navigator.pop(context);
              },
            ),
            /*actions: <Widget>[
              IconButton(
                icon: Icon(Icons.more_vert, color: Colors.white,),
                onPressed: (_showMoreOptionDialog),
              ), //IconButton//IconButton
            ], *///<Widget>[]


          ),
          backgroundColor: Color(0xFFEBECF1),

          body: role == "Corporate"
              ? Column(

            children: [


              Expanded(

                child: ListView(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                  children: [
                    isLoading==  true ?
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 26, right: 26, top: 60),
                        // margin: EdgeInsets.all(12),
                        margin: EdgeInsets.only(top: 60),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF392156)),
                              height: 20.0,
                              width: 20.0,
                            ),
                            SizedBox(width: 24),
                            Text("corporetUser.PleaseWait".tr().toString(),
                              style: TextStyle(fontWeight: FontWeight.bold,
                                  color: Color(0xFF392156),
                                  fontSize: 16),)
                          ],

                        )) :
                    Container(
                      padding: EdgeInsets.only(left: 10, right: 10),
                      height: MediaQuery.of(context).size.height/3 *1.8,
                      child:
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                        itemCount: SubscriberMoneyTransferRequestData.length,
                        itemBuilder: (BuildContext context, int index) {
                          //   itemCount :  UserList.length,
                          return Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white
                            ),
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.only(
                                left: 26, right: 26, bottom: 20),
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
                                            Text("BlineLedger.bParty"
                                                .tr()
                                                .toString(),),
                                            SizedBox(height: 1),
                                            Text(
                                              SubscriberMoneyTransferRequestData[index]['bParty']??'-',
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
                                        margin: EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("BlineLedger.requestDate"
                                                .tr()
                                                .toString(),),

                                            SizedBox(height: 1),
                                            Text(
                                              SubscriberMoneyTransferRequestData[index]['requestDate']??'-'
                                              ,style: TextStyle(
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
                                              height: 20,
                                            ),
                                            Text("BlineLedger.requestSMSText"
                                                .tr()
                                                .toString(),),

                                            SizedBox(height: 1),
                                            Text(
                                              SubscriberMoneyTransferRequestData[index]['requestSMSText']??'-',
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
                                        margin: EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("BlineLedger.requestStatus"
                                                .tr()
                                                .toString(),),

                                            SizedBox(height: 1),
                                            Text(
                                              SubscriberMoneyTransferRequestData[index]['requestStatus']??'-',
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
                                              height: 20,
                                            ),
                                            Text("BlineLedger.requestNotes"
                                                .tr()
                                                .toString(),),

                                            SizedBox(height: 1),
                                            Text(
                                              SubscriberMoneyTransferRequestData[index]['requestNotes']??'-',
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
                                        margin: EdgeInsets.only(
                                            left: 5, right: 5),
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 20,
                                            ),
                                            Text("BlineLedger.transferAmount"
                                                .tr()
                                                .toString(),),

                                            SizedBox(height: 1),
                                            Text(
                                              SubscriberMoneyTransferRequestData[index]['transferAmount']??'-',
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
                ,
              ),



              ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
            ],
          )
              : Center(
            child: Text(role),
          ),

          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(

// padding: EdgeInsets.only(bottom: 0),
              child: SingleChildScrollView(
                child:Column(
                  children: [

                    Container(
                      padding: EdgeInsets.only(left: 20,right: 20,top: 10),

                      child:
                      Row(children: [
                        Expanded(child: buildFromDate()),
                        SizedBox(width: 20,),
                        Expanded(child: buildToDate())
                      ],),
                    ),

                    SizedBox(height: 8,),
                    buildSearchBtn()
                  ],
                ),
              )
          ),
        ),
      ),
    );
  }

}