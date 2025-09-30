import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/AdjustmentLogs.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillShock.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillingDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/BlineLedger.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/OnlineChargingvalues.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/PresetRisk.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Promotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Unbilled.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Balance.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../360View.dart';
import '../KurmalekView/Kurmalek.dart';
import '../MainPromotions/MainPromotions.dart';
import '../SubscriberServices/subscriberservices.dart';
import 'LogvisitHistoryDetails.dart';

class LogVisitHistory extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;

  List data = [];

  LogVisitHistory(
      this.PermessionCorporate,
      this.role,
      this.searchID,
      this.searchValue,
      this.customerNumber,
      this.msisdn,
      this.data,
      this.searchCraretia);
  @override
  _LogVisitHistoryState createState() => _LogVisitHistoryState(
      this.PermessionCorporate,
      this.role,
      this.searchID,
      this.searchValue,
      this.customerNumber,
      this.msisdn,
      this.data,
      this.searchCraretia);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();

class Item {
  const Item(this.key, this.code, this.value, this.valueAr);
  final key;
  final code;
  final String value;
  final String valueAr;
}

class _LogVisitHistoryState extends State<LogVisitHistory> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  DateTime backButtonPressedTime;
  ScrollController scrollController = ScrollController();
  int page = 1;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data = [];
  bool isLoading1 = false;
  bool isInitLoading = true;
  bool isLoading = false;
  bool allLoaded = false;
  bool isLazyLoading = true;
  bool filterByEmptyFlag = false;
  String selectedFiltervalue = '1';
  String selectedPackageValue;
  String selectedPStatusValue;
  ///////////////////////variable from API//////////////////////////////////////
  bool checkData = false;
  String shortCode;
  String status;
  String networkId;
  String level;

  String customerId = "3003757";
  var SUBSCRIBER_PAKAGES = [];
  var STATUS = [];
  var FilterData = [];
  var SUBSCRIBER_LIST = [];
  var DataSubscriberList = [];

  bool msisdnEmptyFlag = false;
  bool msisdnErrorFlag = false;
  bool isPackagingLoading = false;
  bool isStatusLoading = false;
  var totalRecords;
  var totalPages = 0;

  bool emptymsisdn = false;
  bool errormsisdn = false;
  bool emptyStatus = false;
  bool emptyPackage = false;

  String SubscriberNumber = '';
  String customerName = '';
  bool FirstContentFlag = false;

  ///////////////////////End variable from API/////////////////////////////////
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool emptyfromDate = false;
  bool emptytoDate = false;

  var VisitHistoryData = [];
  bool newUser=false;

  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController MSISDN = TextEditingController();

  _LogVisitHistoryState(
      this.PermessionCorporate,
      this.role,
      this.searchID,
      this.searchValue,
      this.customerNumber,
      this.msisdn,
      this.data,
      this.searchCraretia);

  //*******************   List Item for First Menu    ****************/
  List litemsFirst = [
    ListContentFirst(name: "corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name: "corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name: "corpMenu.Promotions".tr().toString()),
    ListContentFirst(name: "corpMenu.Kurmalek".tr().toString()),
    ListContentFirst(name: "corpMenu.Balance".tr().toString()),
    ListContentFirst(name: "corpMenu.Subscriber_Services".tr().toString()),
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
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    print("UnotherizedError");
    print(FilterData.length);
    print("role role role role role");
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    } else {
      // getPackagesListUnderCustomer_API ();
    }

    checkPrefs();

    //disableCapture();
    super.initState();
  }

  @override
  void dispose() {
   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    scrollController.dispose();
    super.dispose();
  }

  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }



  void checkPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.containsKey("customerName"));
    print(prefs.get("customerID"));

    if(prefs.containsKey("newUser")){
      setState(() {
        newUser=true;

      });
      print("111111 111111 111111 111111 111111");

    }else{
      setState(() {
        newUser=false;

      });

      print("000000000000    0000000    000000   000000");
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

  VisitHistory_API() async {
    print('caled');
    if (fromDate.text != '' && toDate.text != '') {
      setState(() {
        isLoading = true;
      });
      print('called');
      if (fromDate.text != '' && toDate.text != '') {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL + '/Customer360/getDynamicsVisitsHistory';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);
        Map body = {
          "customerId":newUser==true?"": customerNumber,
          "fromDate": from.toIso8601String(),
          "toDate": to.toIso8601String()
        };
        final response = await http.post(
          url,
          headers: {
            "content-type": "application/json",
            "Authorization": prefs.getString("accessToken")
          },
          body: json.encode(body),
        );

        int statusCode = response.statusCode;
        var data = response.request;
        print(statusCode);
        print(data);
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
            isLoading = false;
          });
          if (result["status"] == 0) {

              setState(() {
                VisitHistoryData = result["data"];

                isLoading = false;
                checkData = true;
              });
            }
           else {
            setState(() {
              VisitHistoryData =[];

            });
            showAlertDialogERROR(
                context, result["messageAr"], result["message"]);
          }

          return result;
        } else {
          showAlertDialogOtherERROR(
              context, statusCode.toString(), statusCode.toString());
        }
      }
    } else {
      if (fromDate.text == '') {
        setState(() {
          emptyfromDate = true;
        });
      }
      if (toDate.text == '') {
        setState(() {
          emptytoDate = true;
        });
      }
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

  showAlertDialogUnotherizedERROR(
      BuildContext context, arabicMessage, englishMessage) {
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

  showAlertDialogOtherERROR(
      BuildContext context, arabicMessage, englishMessage) {
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
          width: MediaQuery.of(context).size.width / 2,
          child: TextField(
            controller: fromDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Color(0xFF656565),
            ),
            decoration: new InputDecoration(
              enabledBorder: emptyfromDate == true
                  ? const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(
                          color: Color(0xFFB10000), width: 1.0),
                    )
                  : const OutlineInputBorder(
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
                        firstDate: DateTime(
                          DateTime.now().year - 25,
                        ),
                        lastDate: DateTime(
                          DateTime.now().year + 25,
                        ),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF392156), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Color(0xFF656565), // body text color
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
                text: "Reports.this_feild_is_required".tr().toString())
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
          width: MediaQuery.of(context).size.width / 2,
          child: TextField(
            controller: toDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Color(0xFF656565),
            ),
            decoration: new InputDecoration(
              enabledBorder: emptytoDate == true
                  ? const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(
                          color: Color(0xFFB10000), width: 1.0),
                    )
                  : const OutlineInputBorder(
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
                              firstDate: DateTime(
                                DateTime.now().year - 25,
                              ),
                              lastDate: DateTime(
                                DateTime.now().year + 25,
                              ),
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
        emptyfromDate
            ? RequiredFeild(
                text: "Reports.this_feild_is_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberList.msisdn".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Color(0xFFB10000),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptymsisdn == true || errormsisdn == true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptymsisdn || errormsisdn
                    ? Color(0xFFb10000)
                    : Color(0xFFD1D7E0),
                width: 1,
              )),
          height: 58,
          child: TextField(
            controller: MSISDN,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptymsisdn == true
            ? RequiredFeild(text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
        errormsisdn == true
            ? RequiredFeild(
                text: EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Mobile Number shoud be 10 digits" +
                        '\n' +
                        "start with 079"
                    : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079")
            : Container(),
      ],
    );
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
              VisitHistory_API();
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
              title: Text("LogVisit.visit_history".tr().toString()),
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

            body: role == "Corporate"
                ? new SingleChildScrollView(
                  child: Column(

                      children: [
                        ///////////////////////////////////First Content//////////////////////////////////////////////////////////
                        FirstContentFlag==true &&newUser==false?
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
                                        customerName,
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
                        ):Container(),
                        FirstContentFlag==true &&newUser==false?
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
                                        SubscriberNumber.toString(),
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
                        ):Container(),


                        ///////////////////////////////// End First Content///////////////////////////////////////////////////////
                        isLoading ==true?Container(
                            width: double.infinity,
                            padding: EdgeInsets.only(left: 26, right: 26,top: 30),
                            // margin: EdgeInsets.all(12),
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
                        ListView.builder(
                            padding: EdgeInsets.only(left: 16,right: 16,top: 10),
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: VisitHistoryData.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                decoration: BoxDecoration(

                                    borderRadius:
                                    BorderRadius.circular(
                                        5)
                                    ,color: Colors.white
                                )

                                ,
                                margin: EdgeInsets.only(
                                    bottom: 15),
                                padding: EdgeInsets.only(
                                    left: 0,
                                    right: 0,
                                    bottom: 15),
                                // margin: EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    ListTile(
                                      leading: Container(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                           Flexible(child:  Text(
                                             "LogVisit.subject"
                                                 .tr()
                                                 .toString(),
                                           ),),
                                            SizedBox(height: 1),
                                            Flexible(child:   Text(
                                              VisitHistoryData[index]['subject']!=null?VisitHistoryData[index]['subject']:'-',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),)
                                          
                                          ],
                                        ),
                                      ),
                                    ),

                                    ListTile(
                                      leading: Container(
                                      child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                      SizedBox(
                                      height: 5,
                                      ),
                                        Flexible(
                                          child:  Text(
                                            "LogVisit.account_manager_name"
                                                .tr()
                                                .toString(),
                                          ) ,
                                        ),

                                      SizedBox(height: 1),
                                        Flexible(child:      Text(
                                          VisitHistoryData[index]['accountManagerName']!=null?VisitHistoryData[index]['accountManagerName']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),),

                              ],
                              ),
                              ),
                                      trailing:
                                         Container(
                                          child:IconButton(
                                            icon: Icon(Icons.navigate_next,color: Color(0xFFA1A1A1),),
                                            onPressed: () async{
                                              // SharedPreferences prefs = await SharedPreferences.getInstance();

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => LogVisitHistoryDetails(PermessionCorporate, role, searchID, searchValue, customerNumber, msisdn, data, searchCraretia,VisitHistoryData[index],index),
                                                ),
                                              );

                                            },
                                          ),
                                        ),

                                    ),

                                    ListTile(
                                      leading:  Container(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                          Flexible(child:   Text(
                                            "LogVisit.EntryDate"
                                                .tr()
                                                .toString(),
                                          ),),
                                            SizedBox(height: 1),
                                         Flexible(child:    Text(
                                           VisitHistoryData[index]['entryDate']!=null?VisitHistoryData[index]['entryDate'].toString().substring(0,VisitHistoryData[index]['entryDate'].indexOf(' ')):'-',
                                           style: TextStyle(
                                             fontWeight: FontWeight.bold,
                                             fontSize: 14.0,
                                           ),
                                         ),)
                                          ],
                                        ),
                                      ),
                                    ),

                                    ListTile(
                                      leading:  Container(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 5,
                                            ),
                                            Flexible(child:   Text(
                                              "LogVisit.EntryDate"
                                                  .tr()
                                                  .toString(),
                                            ),),
                                            SizedBox(height: 1),
                                            Flexible(child:    Text(
                                              VisitHistoryData[index]['visitDescription']!=null?VisitHistoryData[index]['visitDescription']:'-',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),)
                                          ],
                                        ),
                                      ),
                                    )




                                  ],
                                ),
                              );}
                        ): Container()



                      ],
                    ),
                )
                : Center(
                    child: Text(role),
                  ),
            bottomNavigationBar:
            BottomAppBar(
              child: Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    color: Color(0xFFEBECF1),

                  ),
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
        ));
  }
}
