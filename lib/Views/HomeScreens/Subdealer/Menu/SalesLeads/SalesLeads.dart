import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/FTTH/FTTH_Nationality/FTTH_Jordanian.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/FTTH/FTTH_Nationality/FTTH_nonJordanian.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/GSM/GSM_Nationality/GSM_Jordanian.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/GSM/GSM_Nationality/GSM_nonJordanian.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/MBB/MBB_Nationality/MBB_Jordanian.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/MBB/MBB_Nationality/MBB_nonJordanian.dart';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/NewLeads.dart';

import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/blocs/Login/logout_bloc.dart';
import 'package:sales_app/blocs/Login/logout_events.dart';
import 'package:sales_app/blocs/Login/logout_state.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

class SalesLeads extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  SalesLeads(this.Permessions, this.role, this.outDoorUserName);

  @override
  _SalesLeadsState createState() =>
      _SalesLeadsState(this.Permessions, this.role, this.outDoorUserName);
}

APP_URLS urls = new APP_URLS();

class _SalesLeadsState extends State<SalesLeads> {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var iosSecureScreenShotChannel =
      const MethodChannel('secureScreenshotChannel');
  LogoutBloc logoutBloc;
  bool checkLeadsList = true;
  bool leadListEmpty = false;
  bool checkLeadsById = true;
  bool LeadsByIdEmpty = false;
  var status;
  var marketName;

  String customerName;
  List listOfTickets = [];

  DateTime backButtonPressedTime;

  /**********************************************************************************************/
  _SalesLeadsState(this.Permessions, this.role, this.outDoorUserName);
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
    print(role);
    logoutBloc = BlocProvider.of<LogoutBloc>(context);
    print("haya & haya");
    getUserLeads_API();
    //disableCapture();
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

  disableCapture() async {
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }

  /***********************************************************************************************************/
  Future<void> _onLogout(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccessState) {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(builder: (context) => SignInScreen()),
                  ModalRoute.withName('/SignInScreen'),
                );
              }
            },
            child: AlertDialog(
              title: Text("DeliveryEShop.LogoutRegistration".tr().toString()),
              content: Text("DeliveryEShop.Message_one".tr().toString()),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.cancel".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.Logout".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    //Navigator.of(context).pop(true);
                    logoutBloc.add(LogoutButtonPressed());
                  },
                ),
              ],
            ));
      },
    );
  }

  Future<void> _Unauthorized(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccessState) {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(builder: (context) => SignInScreen()),
                  ModalRoute.withName('/SignInScreen'),
                );
              }
            },
            child: AlertDialog(
              title: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'Unauthorized'
                      : 'غير مصرح'),
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'You need to logout and login again'
                      : 'تحتاج إلى تسجيل الخروج وتسجيل الدخول مرة أخرى'),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.Logout".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    //Navigator.of(context).pop(true);
                    logoutBloc.add(LogoutButtonPressed());
                  },
                ),
              ],
            ));
      },
    );
  }

  getUserLeads_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/TeleSalesAPIs/UserLeads';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "userId": "",
      "searchText": "",
      "sortBy": "",
      "isSortDescending": true,
      "pageNumber": 0,
      "pageSize": 0
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
    print("............................TeleSalesAPIs/UserLeads");
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
      _Unauthorized(context);
    }

    if (statusCode == 200) {
      setState(() {
        checkLeadsList = true;
      });

      var result = json.decode(response.body);
      //print(result);

      if (result["status"] != 0 ) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          checkLeadsList = false;
          leadListEmpty = true;
        });
      }


      if (result["data"] != null ) {
        if (result["data"]["totalCount"] == 0) {
          setState(() {
            checkLeadsList = false;
            leadListEmpty = true;
          });
        } else {
          setState(() {
            listOfTickets = result["data"]['pagedResult'];
            checkLeadsList = false;
            leadListEmpty = false;
          });
          print("******start****");
          print(result["data"]['pagedResult'].length);
          print("******end start****");

        }
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        checkLeadsList = false;
        status = statusCode.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
                  Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }

/*********************************************************************************************************/
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.paused) {
      SystemChannels.platform.invokeMethod('SystemNavigator.pop');
    }
  }
  Future<bool> onWillPop() async {
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
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Color(0xFFEBECF1),
            appBar: AppBar(
              backgroundColor: Color(0xFF4f2565),
              title: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'Sales Leads'
                    : "المبيعات",
              ),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  Navigator.pop(context);
                },
              ), //<Widget>[]
            ),
            body: status == '401'
                ? Center(
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.view_list,
                        color: Colors.black54,
                        size: 90,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                          ? 'No Order List status is ' + ' ' + "401"
                          : "401" + " " + "لا توجد قائمة طلبات الحالة")
                    ],
                  ))
                : checkLeadsList == true
                    ? Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF392156),
                          backgroundColor: Colors.transparent,
                        ),
                      )
                    : leadListEmpty == true
                        ? Center(
                            child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Icon(
                                Icons.view_list,
                                color: Colors.black54,
                                size: 90,
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              Text(EasyLocalization.of(context).locale ==
                                      Locale("en", "US")
                                  ? 'No Order List'
                                  : "لا توجد قائمة طلبات")
                            ],
                          ))
                        : ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            padding: EdgeInsets.only(
                                top: 0, bottom: 2, left: 0, right: 0),
                            children: <Widget>[
                                Container(
                                  padding: EdgeInsets.only(left: 10, right: 10),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    padding: EdgeInsets.only(
                                        top: 8, left: 0, right: 0),
                                    itemCount: listOfTickets.length,
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      //   itemCount :  UserList.length,
                                      return Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                            color: Colors.white),
                                        margin: EdgeInsets.only(bottom: 15),
                                        padding: EdgeInsets.only(
                                            left: 10, right: 10, bottom: 2),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: [
                                                Expanded(
                                                  child: Container(
                                                    padding: EdgeInsets.only(
                                                        left: 10, right: 10),
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
                                                          "SalesLeads.leadNumber"
                                                              .tr()
                                                              .toString(),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text(
                                                          listOfTickets[index][
                                                                          "leadNumber"]
                                                                      .toString() ==
                                                                  null
                                                              ? "--"
                                                              : listOfTickets[
                                                                          index]
                                                                      [
                                                                      "leadNumber"]
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          "SalesLeads.Customername"
                                                              .tr()
                                                              .toString(),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text(
                                                          listOfTickets[index][
                                                                      "customerName"] ==
                                                                  null
                                                              ? "--"
                                                              : listOfTickets[
                                                                          index]
                                                                      [
                                                                      "customerName"]
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          "SalesLeads.Market"
                                                              .tr()
                                                              .toString(),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text(
                                                          listOfTickets[index][
                                                                      "marketType"] ==
                                                                  null
                                                              ? "--"
                                                              : listOfTickets[
                                                                          index]
                                                                      [
                                                                      "marketType"]
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          "SalesLeads.Status"
                                                              .tr()
                                                              .toString(),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text(
                                                          listOfTickets[index][
                                                                      "statusNameEn"] ==
                                                                  null
                                                              ? "--"
                                                              : listOfTickets[
                                                                          index]
                                                                      [
                                                                      "statusNameEn"]
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 15,
                                                        ),
                                                        Text(
                                                          "SalesLeads.Time"
                                                              .tr()
                                                              .toString(),
                                                        ),
                                                        SizedBox(height: 1),
                                                        Text(
                                                          listOfTickets[index][
                                                                      "leadDateString"] ==
                                                                  null
                                                              ? "--"
                                                              : listOfTickets[
                                                                          index]
                                                                      [
                                                                      "leadDateString"]
                                                                  .toString(),
                                                          style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 14.0,
                                                          ),
                                                        ),
                                                        SizedBox(
                                                          height: 5,
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
                                                          Icons.navigate_next,
                                                          color:
                                                              Color(0xFFA1A1A1),
                                                        ),
                                                        onPressed: () async {
                                                          SharedPreferences
                                                              prefs =
                                                              await SharedPreferences
                                                                  .getInstance();

                                                          /*..............................................MBB ROUTE..............................................*/
                                                          if (listOfTickets[index]["marketType"] == "MBB") {
                                                           ( listOfTickets[index]["isJordanian"] == true ||  listOfTickets[index]["isJordanian"] == "true" ) ?
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => MBB_Jordanian(
                                                                        this.Permessions,
                                                                        this.role,
                                                                        this.outDoorUserName,
                                                                        this.listOfTickets[index]["id"].toString(),
                                                                        this.listOfTickets[index]["ticketNumber"].toString(),
                                                                        this.listOfTickets[index]["packageName"].toString(),
                                                                        this.listOfTickets[index]["packageCode"].toString(),
                                                                        this.listOfTickets[index]["marketType"].toString(),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Navigator.push(context, MaterialPageRoute(builder: (context) => MBB_nonJordanian(
                                                                          this.Permessions,
                                                                          this.role,
                                                                          this.outDoorUserName,
                                                                          this.listOfTickets[index]["id"].toString(),
                                                                          this.listOfTickets[index]["ticketNumber"].toString(),
                                                                          this.listOfTickets[index]["packageName"].toString(),
                                                                          this.listOfTickets[index]["packageCode"].toString(),
                                                                          this.listOfTickets[index]["marketType"].toString(),
                                                                          this.listOfTickets[index]["customerName"].toString()),
                                                                    ),
                                                                  );
                                                          }

                                                          /*..............................................FTTH ROUTE..............................................*/
                                                          if (listOfTickets[index]["marketType"] == "FTTH") {
                                                           ( listOfTickets[index]["isJordanian"] == true ||  listOfTickets[index]["isJordanian"] == "true") ?
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => FTTH_Jordanian(
                                                                        this.Permessions,
                                                                        this.role,
                                                                        this.outDoorUserName,
                                                                        this.listOfTickets[index]["id"].toString(),
                                                                        this.listOfTickets[index]["ticketNumber"].toString(),
                                                                        this.listOfTickets[index]["packageName"].toString(),
                                                                        this.listOfTickets[index]["packageCode"].toString(),
                                                                        this.listOfTickets[index]["marketType"].toString(),
                                                                      ),
                                                                    ),
                                                                  )
                                                                : Navigator.push(context, MaterialPageRoute(builder: (context) => FTTH_nonJordanian(
                                                                          this.Permessions,
                                                                          this.role,
                                                                          this.outDoorUserName,
                                                                          this.listOfTickets[index]["id"].toString(),
                                                                          this.listOfTickets[index]["ticketNumber"].toString(),
                                                                          this.listOfTickets[index]["packageName"].toString(),
                                                                          this.listOfTickets[index]["packageCode"].toString(),
                                                                          this.listOfTickets[index]["marketType"].toString(),
                                                                          this.listOfTickets[index]["customerName"].toString()),
                                                                    ),
                                                                  );
                                                          }

                                                          /*..............................................GSM ROUTE..............................................*/
                                                          if (listOfTickets[index]["marketType"] == "GSM" && listOfTickets[index]['campaignName'] == "Pre to Post (GSM)") {
                                                            (listOfTickets[index]["isJordanian"] == true || listOfTickets[index]["isJordanian"] == "true") ?
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => GSM_Jordanian(
                                                                          this.Permessions,
                                                                          this.role,
                                                                          this.outDoorUserName,
                                                                          this.listOfTickets[index]["id"].toString(),
                                                                          this.listOfTickets[index]["ticketNumber"].toString(),
                                                                          this.listOfTickets[index]["packageName"].toString(),
                                                                          this.listOfTickets[index]["packageCode"].toString(),
                                                                          this.listOfTickets[index]["marketType"].toString(),
                                                                          this.listOfTickets[index]['campaignName'].toString()),
                                                                    ),
                                                                  )
                                                                : Navigator.push(context, MaterialPageRoute(builder: (context) => GSM_nonJordanian(
                                                                          this.Permessions,
                                                                          this.role,
                                                                          this.outDoorUserName,
                                                                          this.listOfTickets[index]["id"].toString(),
                                                                          this.listOfTickets[index]["ticketNumber"].toString(),
                                                                          this.listOfTickets[index]["packageName"].toString(),
                                                                          this.listOfTickets[index]["packageCode"].toString(),
                                                                          this.listOfTickets[index]["marketType"].toString(),
                                                                          this.listOfTickets[index]["customerName"].toString(),
                                                                          this.listOfTickets[index]['campaignName'].toString()),
                                                                    ),
                                                                  );
                                                          }

                                                          if (listOfTickets[index]["marketType"] == "GSM" && listOfTickets[index]['campaignName'] != "Pre to Post (GSM)") {
                                                           ( listOfTickets[index]["isJordanian"] == true || listOfTickets[index]["isJordanian"] == "true")?
                                                            Navigator.push(context, MaterialPageRoute(builder: (context) => GSM_Jordanian(
                                                                          this.Permessions,
                                                                          this.role,
                                                                          this.outDoorUserName,
                                                                          this.listOfTickets[index]["id"].toString(),
                                                                          this.listOfTickets[index]["ticketNumber"].toString(),
                                                                          this.listOfTickets[index]["packageName"].toString(),
                                                                          this.listOfTickets[index]["packageCode"].toString(),
                                                                          this.listOfTickets[index]["marketType"].toString(),
                                                                          this.listOfTickets[index]['campaignName'].toString()),
                                                                    ),
                                                                  )
                                                                : Navigator.push(context, MaterialPageRoute(builder: (context) => GSM_nonJordanian(
                                                                          this.Permessions,
                                                                          this.role,
                                                                          this.outDoorUserName,
                                                                          this.listOfTickets[index]["id"].toString(),
                                                                          this.listOfTickets[index]["ticketNumber"].toString(),
                                                                          this.listOfTickets[index]["packageName"].toString(),
                                                                          this.listOfTickets[index]["packageCode"].toString(),
                                                                          this.listOfTickets[index]["marketType"].toString(),
                                                                          this.listOfTickets[index]["customerName"].toString(),
                                                                          this.listOfTickets[index]['campaignName'].toString()),
                                                                    ),
                                                                  );
                                                          }
                                                        },
                                                      ),
                                                    ]),
                                              ],
                                            ),
                                            SizedBox(
                                              height: 10,
                                            ),


                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ]),
          ),
        ));
  }
}
