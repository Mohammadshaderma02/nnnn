import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/CustomBottomNavigationBar.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/ChangePackageEligibilityRq/changePackageEligibilityRq_bloc.dart';
import 'package:sales_app/blocs/ChangePackagePreToPreRq/changePackagePreToPreRq_bloc.dart';
import 'package:sales_app/blocs/ChangePackagePreToPreRq/changePackagePreToPreRq_events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'dart:convert';
import 'package:flutter/services.dart';

class CheckMSISDN_Bulk extends StatefulWidget {
  bool enableMsisdn;
  String ActivePackage;
  List bulkNumbers;
  String pakgeCode;
  String packege;
  int changed_click = 0;
  var role;
  var outDoorUserName;
  List<dynamic> Permessions;

  CheckMSISDN_Bulk(
      this.bulkNumbers,
      this.pakgeCode,
      this.enableMsisdn,
      this.ActivePackage,
      this.packege,
      this.Permessions,
      this.role,
      this.outDoorUserName);

  @override
  State<CheckMSISDN_Bulk> createState() => _CheckMSISDN_BulkState(
      this.bulkNumbers,
      this.pakgeCode,
      this.enableMsisdn,
      this.ActivePackage,
      this.packege,
      this.Permessions,
      this.role,
      this.outDoorUserName);
}

class _CheckMSISDN_BulkState extends State<CheckMSISDN_Bulk> {
  var refresh = 0;
  List bulkNumbers;
  String preMSISDN;
  bool enableMsisdn;
  String mssid;
  String packege;
  int changed_click_First = 0;
  int changed_click_Second = 0;
  int changed_click_Therd = 0;


  bool NoActiveFlag = false;
  String pakgeCode;
  bool disable = false;
  String ActivePackage;
  DateTime backButtonPressedTime;
  var role;
  var outDoorUserName;
  List<dynamic> Permessions;

  int _selectedMSISDN = -1;

  ChangePackageEligibilityRqBloc changePackageEligibilityRqBloc;

  ChangePackagePreToPreRqBloc changePackagePreToPreRqBloc;

  APP_URLS urls = new APP_URLS();
  _CheckMSISDN_BulkState(
      this.bulkNumbers,
      this.pakgeCode,
      this.enableMsisdn,
      this.ActivePackage,
      this.packege,
      this.Permessions,
      this.role,
      this.outDoorUserName);
  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Warning"
            : "تحذير",
      ),
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
            Navigator.pop(context, true);
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        )
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

  Future<bool> _onPop() async {
    return false;
  }

  @override
  Widget build(BuildContext context) {
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

    void ChangePackage_First(msisdn) async {
      print(msisdn);
       SharedPreferences prefs = await SharedPreferences.getInstance();
      var otp = prefs.getString('UpgradePackageOtp');
      Map<String, dynamic> body = {
        "msisdn": msisdn,
        "newPackageCode": pakgeCode,
        "isPOSOffer": false,
        'otp': otp
      };
      //        "newPackageCode": widget.pakgeCode,
      var res =
          await http.post(Uri.parse(urls.BASE_URL + "/ChangePackage/change"),
              headers: {
                "Content-Type": "application/json",
                "Authorization": prefs.getString("accessToken"),
              },
              body: jsonEncode(body));

      final data = json.decode(res.body);
      print(data);
      int statusCode = res.statusCode;
      if (statusCode == 200) {
        var result = json.decode(res.body);
        if (result['status'] == 0) {
          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? result['message']
                  : result['messageAr'],
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);
          setState(() {
            changed_click_First = 2;
          });
        } else {
          showAlertDialogError(context, result['messageAr'], result['message']);
          setState(() {
            changed_click_First = 3;
          });
        }
      }
    }

    void ChangePackage_Second(msisdn) async {
      print(msisdn);
       SharedPreferences prefs = await SharedPreferences.getInstance();
      var otp = prefs.getString('UpgradePackageOtp');
      Map<String, dynamic> body = {
        "msisdn": msisdn,
        "newPackageCode": pakgeCode,
        "isPOSOffer": false,
        'otp': otp
      };
      //        "newPackageCode": widget.pakgeCode,
      var res =
          await http.post(Uri.parse(urls.BASE_URL + "/ChangePackage/change"),
              headers: {
                "Content-Type": "application/json",
                "Authorization": prefs.getString("accessToken"),
              },
              body: jsonEncode(body));

      final data = json.decode(res.body);
      print(data);
      int statusCode = res.statusCode;
      if (statusCode == 200) {
        var result = json.decode(res.body);
        if (result['status'] == 0) {
          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? result['message']
                  : result['messageAr'],
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);
          setState(() {
            changed_click_Second = 2;
          });
        } else {
          showAlertDialogError(context, result['messageAr'], result['message']);
          setState(() {
            changed_click_Second = 3;
          });
        }
      }
    }

    void ChangePackage_Therd(msisdn) async {
      print(msisdn);
       SharedPreferences prefs = await SharedPreferences.getInstance();
      var otp = prefs.getString('UpgradePackageOtp');
      Map<String, dynamic> body = {
        "msisdn": msisdn,
        "newPackageCode": pakgeCode,
        "isPOSOffer": false,
        'otp': otp
      };
      //        "newPackageCode": widget.pakgeCode,
      var res =
          await http.post(Uri.parse(urls.BASE_URL + "/ChangePackage/change"),
              headers: {
                "Content-Type": "application/json",
                "Authorization": prefs.getString("accessToken"),
              },
              body: jsonEncode(body));

      final data = json.decode(res.body);
      print(data);
      int statusCode = res.statusCode;
      if (statusCode == 200) {
        var result = json.decode(res.body);
        if (result['status'] == 0) {
          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? result['message']
                  : result['messageAr'],
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);
          setState(() {
            changed_click_Therd = 2;
          });
        } else {
          showAlertDialogError(context, result['messageAr'], result['message']);
          setState(() {
            changed_click_Therd = 3;
          });
        }
      }
    }





    return WillPopScope(
        onWillPop: _onPop,
        child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              centerTitle: false,
              title: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "List of Numbers"
                      : "قائمة الأرقام"),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: ListView(
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 8),
                children: [
                  Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 10, top: 8, bottom: 10),
                    //margin: EdgeInsets.only(top: 20),
                    child: Text(
                      "Menu_Form.Active_Pakeges".tr().toString(),
                      style: TextStyle(
                        color: Color(0xFF11120e),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      height: 55,
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          ActivePackage,
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 10, top: 8, bottom: 10),
                    //margin: EdgeInsets.only(top: 20),
                    child: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Package Selected"
                          : "الحزمة المحددة",
                      style: TextStyle(
                        color: Color(0xFF11120e),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    child: SizedBox(
                      height: 55,
                      child: ListTile(
                        tileColor: Colors.white,
                        title: Text(
                          packege,
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    padding: EdgeInsets.only(
                        left: 16, right: 10, top: 8, bottom: 10),
                    //margin: EdgeInsets.only(top: 20),
                    child: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Numbers"
                          : "الأرقام",
                      style: TextStyle(
                        color: Color(0xFF11120e),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),

/*****************************************************************************************************************************************/
                  bulkNumbers.asMap().containsKey(0)
                      ? Container(
                          color: Colors.white,
                          child: ListTile(
                              trailing: TextButton(
                                child: changed_click_First == 0
                                    ? Text(
                                        EasyLocalization.of(context).locale ==
                                                Locale("en", "US")
                                            ? "CHANGED"
                                            : "تعديل",
                                        style: TextStyle(
                                            color: Color(0xFF0070c9),
                                            fontSize: 15))
                                    : changed_click_First == 1
                                        ? SizedBox(
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF4f2565)),
                                            )),
                                            height: 20.0,
                                            width: 20.0,
                                          )
                                        : changed_click_First == 2
                                            ? Text(
                                                EasyLocalization.of(context)
                                                            .locale ==
                                                        Locale("en", "US")
                                                    ? "SUCCESS"
                                                    : "نجح",
                                                style: TextStyle(
                                                    color: Color(0xff239B56),
                                                    fontSize: 15))
                                            : changed_click_First == 3
                                                ? Text(
                                                    EasyLocalization.of(context)
                                                                .locale ==
                                                            Locale("en", "US")
                                                        ? "FAILED"
                                                        : "فشل",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffD22B2B),
                                                        fontSize: 15))
                                                : null,
                                onPressed:changed_click_First== 2?null:() {
                                  setState(() {
                                    changed_click_First = 1;
                                  });
                                  ChangePackage_First(
                                      bulkNumbers[0]['msisdn'].toString());
                                },
                              ),
                              title: Text(
                                  "${bulkNumbers[0]['msisdn'].toString()}")),
                        )
                      : Container(),
                  bulkNumbers.asMap().containsKey(2)
                      ? Container(
                          color: Colors.white,
                          child: Divider(),
                        )
                      : Container(),
/*****************************************************************************************************************************************/
                  bulkNumbers.asMap().containsKey(1)
                      ? Container(
                          color: Colors.white,
                          child: ListTile(
                              trailing: TextButton(
                                child: changed_click_Second == 0
                                    ? Text(
                                        EasyLocalization.of(context).locale ==
                                                Locale("en", "US")
                                            ? "CHANGED"
                                            : "تعديل",
                                        style: TextStyle(
                                            color: Color(0xFF0070c9),
                                            fontSize: 15))
                                    : changed_click_Second == 1
                                        ? SizedBox(
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF4f2565)),
                                            )),
                                            height: 20.0,
                                            width: 20.0,
                                          )
                                        : changed_click_Second == 2
                                            ? Text(
                                                EasyLocalization.of(context)
                                                            .locale ==
                                                        Locale("en", "US")
                                                    ? "SUCCESS"
                                                    : "نجح",
                                                style: TextStyle(
                                                    color: Color(0xff239B56),
                                                    fontSize: 15))
                                            : changed_click_Second == 3
                                                ? Text(
                                                    EasyLocalization.of(context)
                                                                .locale ==
                                                            Locale("en", "US")
                                                        ? "FAILED"
                                                        : "فشل",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffD22B2B),
                                                        fontSize: 15))
                                                : null,
                                onPressed: changed_click_Second== 2?null:() {
                                  setState(() {
                                    changed_click_Second = 1;
                                  });
                                  ChangePackage_Second(
                                      bulkNumbers[1]['msisdn'].toString());
                                },
                              ),
                              title: Text(
                                  "${bulkNumbers[1]['msisdn'].toString()}")),
                        )
                      : Container(),
                  bulkNumbers.asMap().containsKey(2)
                      ? Container(
                          color: Colors.white,
                          child: Divider(),
                        )
                      : Container(),
/*****************************************************************************************************************************************/
                  bulkNumbers.asMap().containsKey(2)
                      ? Container(
                          color: Colors.white,
                          child: ListTile(
                              trailing: TextButton(
                                child: changed_click_Therd == 0
                                    ? Text(
                                        EasyLocalization.of(context).locale ==
                                                Locale("en", "US")
                                            ? "CHANGED"
                                            : "تعديل",
                                        style: TextStyle(
                                            color: Color(0xFF0070c9),
                                            fontSize: 15))
                                    : changed_click_Therd == 1
                                        ? SizedBox(
                                            child: Center(
                                                child:
                                                    CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Color(0xFF4f2565)),
                                            )),
                                            height: 20.0,
                                            width: 20.0,
                                          )
                                        : changed_click_Therd == 2
                                            ? Text(
                                                EasyLocalization.of(context)
                                                            .locale ==
                                                        Locale("en", "US")
                                                    ? "SUCCESS"
                                                    : "نجح",
                                                style: TextStyle(
                                                    color: Color(0xff239B56),
                                                    fontSize: 15))
                                            : changed_click_Therd == 3
                                                ? Text(
                                                    EasyLocalization.of(context)
                                                                .locale ==
                                                            Locale("en", "US")
                                                        ? "FAILED"
                                                        : "فشل",
                                                    style: TextStyle(
                                                        color:
                                                            Color(0xffD22B2B),
                                                        fontSize: 15))
                                                : null,
                                onPressed: changed_click_Therd== 2?null:() {
                                  setState(() {
                                    changed_click_Therd = 1;
                                  });
                                  ChangePackage_Therd(
                                      bulkNumbers[2]['msisdn'].toString());
                                },
                              ),
                              title: Text(
                                  "${bulkNumbers[2]['msisdn'].toString()}")),
                        )
                      : Container(),
/*****************************************************************************************************************************************/

                  /* ListView.separated(

                shrinkWrap: true,
                itemCount: widget.bulkNumbers.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    color: Colors.white,
                    child: ListTile(
                        trailing: TextButton(
                          child:  changed_click == 0
                              ? Text(
                              EasyLocalization.of(context).locale ==
                                  Locale("en", "US")
                                  ? "CHANGED"
                                  : "تعديل",
                              style:
                              TextStyle(color: Color(0xFF0070c9), fontSize: 15))
                              :changed_click == 1
                              ? SizedBox(
                            child: Center(
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF4f2565)),
                                )),
                            height: 20.0,
                            width: 20.0,
                          )
                              :  changed_click == 2
                              ? Text(
                              EasyLocalization.of(context).locale ==
                                  Locale("en", "US")
                                  ? "SUCCESS"
                                  : "نجح",
                              style: TextStyle(
                                  color: Color(0xff239B56), fontSize: 15))
                              : changed_click == 3
                              ? Text(
                              EasyLocalization.of(context).locale ==
                                  Locale("en", "US")
                                  ? "FAILED"
                                  : "فشل",
                              style: TextStyle(
                                  color: Color(0xffD22B2B),
                                  fontSize: 15))
                              : null,
                          onPressed: () {
                            setState(() {
                              changed_click = 1;
                              _selectedMSISDN=index;
                            });
                            ChangePackage(bulkNumbers[index]['msisdn'].toString());
                           // ChangePackage(widget.bulkNumbers[index]['msisdn'].toString());

                          },
                        ),
                        title:
                        Text("${bulkNumbers[index]['msisdn'].toString()}")),
                     // Text("${widget.bulkNumbers[index]['msisdn'].toString()}")),

                  );
                },
              separatorBuilder: (context, index) {
                return Container(
                  color: Colors.white,
                  child: Divider(),
                );
              },
                ),*/
                ]),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: 8, left: 0, right: 0),
              children: [
                /////////////////////////////////// Content of Next and add Buttons//////////////////////////////////////////////////////////

                SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CustomBottomNavigationBar(
                                  Permessions: Permessions,
                                  role: role,
                                  outDoorUserName: outDoorUserName,
                                ),
                              ),
                            );
                          },
                          child: Center(
                            child: Text(
                                "UpdateLine.finish_back".tr().toString(),
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Color(0xFF4f2565),
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            )));
  }
}
