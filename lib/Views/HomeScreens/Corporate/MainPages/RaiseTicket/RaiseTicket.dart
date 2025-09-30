import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/RaiseTicket/TicketHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';

import 'package:sales_app/Shared/BaseUrl.dart';

class RaiseTicket extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;
  RaiseTicket(this.PermessionCorporate, this.role);
  @override
  _RaiseTicketState createState() =>
      _RaiseTicketState(this.PermessionCorporate, this.role);
}

APP_URLS urls = new APP_URLS();

class _RaiseTicketState extends State<RaiseTicket> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  // String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;
  String customerName;
  String SubscriberNumber;
  bool FirstContentFlag = false;
  bool checkData = false;
  bool isLoading = false;
  bool emptyfromDate = false;
  bool emptytoDate = false;

  List MenaTracks = [];

  int searchID;
  String searchCraretia;
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool emptymsisdn = false;
  bool errormsisdn = false;
  bool openSearch = false;
  TextEditingController MSISDN = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  DateTime backButtonPressedTime;
  _RaiseTicketState(this.PermessionCorporate, this.role);

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
    checkPrefs();
    print("__________________________________________________________________");
    //disableCapture();
    checkIndexPage ();
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
              MenaTracks_API();

              setState(() {
                MenaTracks = [];
              });
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

  Widget buildContactMSISDN() {
    return Expanded(
      child: Container(
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
        height: 50,
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
    );
  }

  MenaTracks_API() async {
    print('caled');
    if (fromDate.text != '' && toDate.text != '' && MSISDN.text != '') {
      setState(() {
        isLoading = true;
      });

      print('called');
      if (fromDate.text != '' && toDate.text != '' && MSISDN.text != '') {
        setState(() {
          isLoading = true;
        });
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL + '/Customer360/viewRequestMenaTracks';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);

        Map body = {
          "clientMSISDN": MSISDN.text,
          "fromCreateDate": from.toIso8601String(),
          "toCreateDate": to.toIso8601String(),
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

          if (result["status"] == 0) {
            if (result["data"] == null || result["data"].length == 0) {
              showAlertDialogNoData(context, "لا توجد بيانات متاحة الآن.",
                  "No data available now .");
            } else {
              setState(() {
                MenaTracks = result["data"];
                print(MenaTracks.length);
                isLoading = false;
                checkData = true;
                openSearch = false;
                emptyfromDate = false;
                emptytoDate = false;
                emptymsisdn = false;
                fromDate.text = '';
                toDate.text = '';
                MSISDN.text = '';
              });
            }
            print("GetCustomersCreditNotes");
            print(
                "***************************************************************");
            print(MenaTracks.length);
            print(
                "***************************************************************");
          } else {
            showAlertDialogERROR(
                context, result["messageAr"], result["message"]);
          }

          return result;
        } else {
          showAlertDialogOtherERROR(context, statusCode, statusCode);
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
      if (MSISDN.text == "") {
        setState(() {
          emptymsisdn = true;
        });
      }

      if (MSISDN.text != "") {
        if (MSISDN.text.length == 10) {
          if (MSISDN.text.substring(0, 3) == '079') {
            setState(() {
              errormsisdn = false;
              emptymsisdn = false;
            });
          } else {
            setState(() {
              errormsisdn = true;
              emptymsisdn = false;
            });
          }
        } else {
          setState(() {
            errormsisdn = true;
            emptymsisdn = false;
          });
        }
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
        setState(() {
          openSearch = false;
          emptyfromDate = false;
          emptytoDate = false;
          emptymsisdn = false;
          MenaTracks = [];
          fromDate.text = '';
          toDate.text = '';
          MSISDN.text = "";
          isLoading = false;
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
              openSearch = false;
              emptyfromDate = false;
              emptytoDate = false;
              emptymsisdn = false;
              MenaTracks = [];
              fromDate.text = '';
              toDate.text = '';
              MSISDN.text = "";
              isLoading = false;
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
          openSearch = false;
          emptyfromDate = false;
          emptytoDate = false;
          emptymsisdn = false;
          MenaTracks = [];
          fromDate.text = '';
          toDate.text = '';
          MSISDN.text = "";
          isLoading = false;
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
              openSearch = false;
              emptyfromDate = false;
              emptytoDate = false;
              emptymsisdn = false;
              MenaTracks = [];
              fromDate.text = '';
              toDate.text = '';
              MSISDN.text = "";
              isLoading = false;
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
        child: openSearch == false
            ? GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
              child: GestureDetector(
                onTap: ()=>FocusScope.of(context).unfocus(),
                child: Scaffold(
                    backgroundColor: Color(0xFFEBECF1),
                    appBar: AppBarSectionCorporate(
                      appBar: AppBar(),
                      title: Text("corpNavBar.Raise_Ticket".tr().toString()),
                      PermessionCorporate: PermessionCorporate,
                      role: role,
                    ),
                    body: role == "Corporate"
                        ? ListView(
                            // shrinkWrap: true,
                            //  physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                            children: <Widget>[
                              ///////////////////////////////////First Content//////////////////////////////////////////////////////////
                              /*  FirstContentFlag == true
                                  ? Container(
                                      color: Colors.white,
                                      width: double.infinity,
                                      // margin: EdgeInsets.all(12),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 18,
                                                bottom: 5,
                                                left: 25,
                                                right: 25),
                                            color: Color(0xff392156),
                                            width: 5,
                                            height: 38,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "SubscriberView.CustomerName"
                                                        .tr()
                                                        .toString(),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text(
                                                    customerName,
                                                    // this.data[0]['customerName'],
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
                                    )
                                  : Container(),

                              FirstContentFlag == true
                                  ? Container(
                                      color: Colors.white,
                                      width: double.infinity,
                                      // margin: EdgeInsets.all(12),
                                      margin: EdgeInsets.only(bottom: 5),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            margin: EdgeInsets.only(
                                                top: 18,
                                                bottom: 5,
                                                left: 25,
                                                right: 25),
                                            color: Color(0xff392156),
                                            width: 5,
                                            height: 38,
                                          ),
                                          SizedBox(width: 8),
                                          Expanded(
                                            child: Container(
                                              margin: EdgeInsets.only(top: 10),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "SubscriberView.SubscriberNumber"
                                                        .tr()
                                                        .toString(),
                                                  ),
                                                  SizedBox(height: 1),
                                                  Text(
                                                    SubscriberNumber,
                                                    //this.data[0]['msisdn'],
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
                                    )
                                  : Container(),*/

                              ///////////////////////////////////End First Content//////////////////////////////////////////////////////////

                              ListView(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                                children: [
                                  isLoading == true
                                      ? Container(
                                          width: double.infinity,
                                          padding: EdgeInsets.only(
                                              left: 26, right: 26, top: 60),
                                          // margin: EdgeInsets.all(12),
                                          margin: EdgeInsets.only(top: 60),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              SizedBox(
                                                child: CircularProgressIndicator(
                                                    color: Color(0xFF392156)),
                                                height: 20.0,
                                                width: 20.0,
                                              ),
                                              SizedBox(width: 24),
                                              Text(
                                                "corporetUser.PleaseWait"
                                                    .tr()
                                                    .toString(),
                                                style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Color(0xFF392156),
                                                    fontSize: 16),
                                              )
                                            ],
                                          ))
                                      : checkData == true
                                          ? Container(
                                              padding: EdgeInsets.only(
                                                  left: 10, right: 10),
                                              child: ListView.builder(
                                                shrinkWrap: true,
                                                physics: ClampingScrollPhysics(),
                                                padding: EdgeInsets.only(
                                                    top: 8, left: 0, right: 0),
                                                itemCount: MenaTracks.length,
                                                itemBuilder: (BuildContext context,
                                                    int index) {
                                                  //   itemCount :  UserList.length,
                                                  return Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                5),
                                                        color: Colors.white),
                                                    margin:
                                                        EdgeInsets.only(bottom: 15),
                                                    padding: EdgeInsets.only(
                                                        left: 10,
                                                        right: 10,
                                                        bottom: 15),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.start,
                                                      children: [
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Expanded(
                                                              child: Container(
                                                                padding:
                                                                    EdgeInsets.only(
                                                                        left: 10,
                                                                        right: 10),
                                                                child: Column(
                                                                  crossAxisAlignment:
                                                                      CrossAxisAlignment
                                                                          .start,
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    SizedBox(
                                                                      height: 10,
                                                                    ),
                                                                    Text(
                                                                      "RaiseTicket.TicketTitle​"
                                                                          .tr()
                                                                          .toString(),
                                                                    ),
                                                                    SizedBox(
                                                                        height: 1),
                                                                    Text(
                                                                      MenaTracks[index]['title'] !=
                                                                                  null ||
                                                                              MenaTracks[index]['title'].length ==
                                                                                  0
                                                                          ? MenaTracks[
                                                                                  index]
                                                                              [
                                                                              'title']
                                                                          : '--',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15,
                                                                    ),
                                                                    Text(
                                                                      "RaiseTicket.TicketNumber"
                                                                          .tr()
                                                                          .toString(),
                                                                    ),
                                                                    SizedBox(
                                                                        height: 1),
                                                                    Text(
                                                                      MenaTracks[index]['issueID'] !=
                                                                                  null ||
                                                                              MenaTracks[index]['issueID'].length ==
                                                                                  0
                                                                          ? MenaTracks[
                                                                                  index]
                                                                              [
                                                                              'issueID']
                                                                          : '--',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15,
                                                                    ),
                                                                    Text(
                                                                      "RaiseTicket.TicketDate​"
                                                                          .tr()
                                                                          .toString(),
                                                                    ),
                                                                    SizedBox(
                                                                        height: 1),
                                                                    Text(
                                                                      MenaTracks[index]['submitDate'] !=
                                                                                  null ||
                                                                              MenaTracks[index]['submitDate'].length ==
                                                                                  0
                                                                          ? MenaTracks[
                                                                                  index]
                                                                              [
                                                                              'submitDate']
                                                                          : '--',
                                                                      style:
                                                                          TextStyle(
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .bold,
                                                                        fontSize:
                                                                            14.0,
                                                                      ),
                                                                    ),
                                                                    SizedBox(
                                                                      height: 15,
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ),

                                                            //Spacer(),
                                                            Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  IconButton(
                                                                    icon: Icon(
                                                                      Icons
                                                                          .navigate_next,
                                                                      color: Color(
                                                                          0xFFA1A1A1),
                                                                    ),
                                                                    onPressed:
                                                                        () async {
                                                                      SharedPreferences
                                                                          prefs =
                                                                          await SharedPreferences
                                                                              .getInstance();

                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => TicketHistory(
                                                                              PermessionCorporate,
                                                                              role,
                                                                              searchID,
                                                                              MenaTracks,
                                                                              index),
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
                                            )
                                          : Container()
                                ],
                              )
                            ],
                          )
                        : Container(),
                    floatingActionButton: FloatingActionButton.extended(
                      onPressed: () {
                        setState(() {
                          openSearch = true;
                        });
                        // Add your onPressed code here!
                      },
                      label: const Text('Search'),
                      icon: const Icon(Icons.search),
                      backgroundColor: Color(0xff0E7074),
                    ),
                    /*  */
                  ),
              ),
            )
            : Scaffold(
                backgroundColor: Color(0xFFEBECF1),
                appBar: AppBarSectionCorporate(
                  appBar: AppBar(),
                  title: Text("corpNavBar.Raise_Ticket".tr().toString()),
                  PermessionCorporate: PermessionCorporate,
                  role: role,
                ),
                body: role == "Corporate"
                    ? ListView(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.only(top: 0, left: 0, right: 0),
                        children: <Widget>[
                          ///////////////////////////////////First Content//////////////////////////////////////////////////////////
                       /*   FirstContentFlag == true
                              ? Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  // margin: EdgeInsets.all(12),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 18,
                                            bottom: 5,
                                            left: 25,
                                            right: 25),
                                        color: Color(0xff392156),
                                        width: 5,
                                        height: 38,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "SubscriberView.CustomerName"
                                                    .tr()
                                                    .toString(),
                                              ),
                                              SizedBox(height: 1),
                                              Text(
                                                customerName,
                                                // this.data[0]['customerName'],
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
                                )
                              : Container(),

                          FirstContentFlag == true
                              ? Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                            top: 18,
                                            bottom: 5,
                                            left: 25,
                                            right: 25),
                                        color: Color(0xff392156),
                                        width: 5,
                                        height: 38,
                                      ),
                                      SizedBox(width: 8),
                                      Expanded(
                                        child: Container(
                                          margin: EdgeInsets.only(top: 10),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "SubscriberView.SubscriberNumber"
                                                    .tr()
                                                    .toString(),
                                              ),
                                              SizedBox(height: 1),
                                              Text(
                                                SubscriberNumber,
                                                //this.data[0]['msisdn'],
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
                                )
                              : Container(),*/

                          ///////////////////////////////////End First Content//////////////////////////////////////////////////////////
                        ],
                      )

/*************************************************************/
                    : Container(),
                bottomNavigationBar: BottomAppBar(
                  child: Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                        color: Color(0xFFEBECF1),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(height: 15),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 10),
                              child: Row(
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      text: "Balance.MSISDN".tr().toString(),
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
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5),
                              child: Row(
                                children: [
                                  buildContactMSISDN(),
                                ],
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 20, right: 20, bottom: 5),
                              child: Row(
                                children: [
                                  emptymsisdn == true
                                      ? RequiredFeild(
                                          text: "Menu_Form.msisdn_required"
                                              .tr()
                                              .toString())
                                      : Container(),
                                  errormsisdn == true
                                      ? RequiredFeild(
                                          text: EasyLocalization.of(context)
                                                      .locale ==
                                                  Locale("en", "US")
                                              ? "Mobile Number shoud be 10 digits" +
                                                  '\n' +
                                                  "start with 079"
                                              : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079")
                                      : Container(),
                                ],
                              ),
                            ),
                            Container(
                              padding:
                                  EdgeInsets.only(left: 20, right: 20, top: 10),
                              child: Row(
                                children: [
                                  Expanded(child: buildFromDate()),
                                  SizedBox(
                                    width: 20,
                                  ),
                                  Expanded(child: buildToDate())
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            buildSearchBtn()
                          ],
                        ),
                      )),
                ),
              ));
  }
}

/*Future<bool> onWillPopDialog(context) => showDialog(
    barrierDismissible: false,
    context: context,
    builder: ((context) => AlertDialog(
          title: Text("corpAlert.msg1".tr().toString(),
              style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF11120E),
                  fontWeight: FontWeight.normal)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: Text("corpAlert.close".tr().toString(),
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF392156),
                      fontWeight: FontWeight.normal)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: Text(
                "corpAlert.cancel".tr().toString(),
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF392156),
                    fontWeight: FontWeight.normal),
              ),
            ),
          ],
        )));*/
/*
* */
