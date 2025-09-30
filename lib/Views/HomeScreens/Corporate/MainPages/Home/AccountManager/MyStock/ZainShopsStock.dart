import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

//import '/../360View.dart';

class ZainShopsStock extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;

  int searchID;
  String searchValue;

  List data = [];
  ZainShopsStock(this.PermessionCorporate, this.role);
  @override
  _ZainShopsStockState createState() =>
      _ZainShopsStockState(this.PermessionCorporate, this.role);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();

class _ZainShopsStockState extends State<ZainShopsStock> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  DateTime backButtonPressedTime;

  final List<dynamic> PermessionCorporate;
  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;

  List data = [];
  bool checkData = false;


  bool isLoading = false;



  List WarehouseStockList = [];


  bool emptyDiviceName = false;
  bool emptyDiviceType = false;
  TextEditingController DiviceType = TextEditingController();
  TextEditingController DiviceName = TextEditingController();


  List ZainShopsLookup = [];
  var selectedShopName;
  bool emptyShopName = false;

  _ZainShopsStockState(this.PermessionCorporate, this.role);

  final items = [
    "Balance.BillingPayments".tr().toString(),
    "Balance.OnlinePayments".tr().toString(),
    "Balance.CustomerInvoices".tr().toString(),
    "Balance.AllTransactions".tr().toString()
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
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }
    getZainShopsLookup_API();
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

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

  Widget buildDiviceType() {
    return Expanded(
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: emptyDiviceType == true
                ? Color(0xFFB10000).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: emptyDiviceType
                  ? Color(0xFFb10000)
                  : Color(0xFFD1D7E0),
              width: 1,
            )),
        height: 50,
        child: TextField(
          controller: DiviceType,
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
  Widget buildDiviceName() {
    return Expanded(
      child: Container(
        // margin: EdgeInsets.symmetric(horizontal: 30),
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
            color: emptyDiviceName == true
                ? Color(0xFFB10000).withOpacity(0.1)
                : Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: emptyDiviceName
                  ? Color(0xFFb10000)
                  : Color(0xFFD1D7E0),
              width: 1,
            )),
        height: 50,
        child: TextField(
          controller: DiviceName,
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
              getZainShopsList_API();
              /*********haya hazaimeh***********/
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



  Widget buildShopName() {
    return Expanded(
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyShopName == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: ZainShopsLookup.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["code"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["value"])
                          : Text(valueItem["valueAr"]),
                    );
                  }).toList(),
                  value: selectedShopName,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedShopName = newValue;
                    });
                  },
                ),
              ),
            )));
  }

  getZainShopsLookup_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lookup/GETSHOPS';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
    );
    int statusCode = response.statusCode;
    print('TOKEN');
    print(prefs.getString("accessToken"));

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
      //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {
      var result = json.decode(response.body);

      if (result["status"] == 0) {
        if (result["data"] == null || result["data"].length == 0) {
          showAlertDialogNoData(
              context, "لا توجد بيانات متاحة الآن.", "No data available now .");
        } else {
          print('emplo');
          print(result["data"]);
          setState(() {
            ZainShopsLookup = result["data"];
          });
        }
      } else {
        showAlertDialogERROR(context, result["messageAr"], result["message"]);
      }

      return result;
    } else {
      showAlertDialogOtherERROR(context, statusCode, statusCode);
    }
  }

  getZainShopsList_API() async {
    print('caled');
    if (selectedShopName !=null ) {

      // if (selectedShopName !=null && DiviceName.text != '' && DiviceType.text != '') {
      setState(() {
        isLoading = true;
      });
      print('called');
      if (selectedShopName !=null ) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL + '/Customer360/getWarehouseStock';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);
        Map body = {

          "poolID": selectedShopName,
          "deviceType": DiviceType.text,
          "deviceName": DiviceName.text
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

          setState(() {
            isLoading = false;
          });
          if (result["status"] == 0) {
            if (result["data"] == null || result["data"].length == 0) {
              showAlertDialogNoData(context, "لا توجد بيانات متاحة الآن.",
                  "No data available now .");
            } else {
              setState(() {
                WarehouseStockList = result["data"];
                isLoading = false;
                checkData = true;
                emptyShopName = false;

              });
            }
            print("getWarehouseStock");
          } else {
            showAlertDialogERROR(
                context, result["messageAr"], result["message"]);
            setState(() {
              emptyShopName = false;

            });
            /**********************************/
          }

          print(urls.BASE_URL + '/Customer360/getWarehouseStock' + " ");

          return result;
        } else {
          showAlertDialogOtherERROR(context, statusCode, statusCode);
        }
      }
    } else {

      /*  if (DiviceType.text == "") {
        setState(() {
          emptyDiviceType = true;
        });
      }
      if (DiviceName.text == "") {
        setState(() {
          emptyDiviceName = true;
        });
      }*/
      if(selectedShopName ==null ){
        setState(() {
          emptyShopName = true;
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
        setState(() {
          checkData = false;
          WarehouseStockList = [];
          emptyShopName = false;

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
              checkData = false;
              WarehouseStockList = [];
              emptyShopName = false;

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
        setState(() {
          checkData = false;
          WarehouseStockList = [];
          emptyShopName = false;

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
              WarehouseStockList = [];
              emptyShopName = false;

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

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);

      /* Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Customer360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,"Customer Number"),
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
            title: Text("AccountManager.ZainShops".tr().toString()),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.pop(context);
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Customer360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,"Customer Number"),
                  ),
                );*/
              },
            ),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: role == "Corporate"
              ? ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: 8, left: 0, right: 0),
            children: [
              Container(
                color: Colors.transparent,
                width: double.infinity,
                height: MediaQuery.of(context).size.height / 3 * 1.9,

                // margin: EdgeInsets.all(12),
                child: isLoading == true
                    ? Container(
                    width: double.infinity,
                    padding:
                    EdgeInsets.only(left: 26, right: 26, top: 30),
                    // margin: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 20),
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
                        Text(
                          "corporetUser.PleaseWait".tr().toString(),
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF392156),
                              fontSize: 16),
                        )
                      ],
                    ))
                    : checkData == true
                    ? Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child: ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(
                        top: 8, left: 0, right: 0),
                    itemCount: WarehouseStockList.length,
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
                            left: 24, right: 24, bottom: 20),
                        // margin: EdgeInsets.all(12),

                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          children: [
                            ////

                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "AccountManager.DeviceType".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          WarehouseStockList[index]['deviceType'] != null || WarehouseStockList[index]['deviceType'].length == 0 ? WarehouseStockList[index]['deviceType'] : '-',
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),

                              ],
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [

                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 1, right: 1),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("AccountManager.DeviceName".tr().toString()),
                                        SizedBox(height: 1),
                                        Text(
                                          WarehouseStockList[index]['deviceName'] != null || WarehouseStockList[index]['deviceName'].length == 0 ? WarehouseStockList[index]['deviceName'] : '-',
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
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
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Container(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "AccountManager.Quantity".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          WarehouseStockList[index]['quantity'] != null || WarehouseStockList[index]['quantity'].length == 0 ? WarehouseStockList[index]['quantity'] : '-',
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
                                //Spacer(),

                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 1, right: 1),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "AccountManager.RetailPrice".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(WarehouseStockList[index]['retailPrice'] != null || WarehouseStockList[index]['retailPrice'].length == 0 ? WarehouseStockList[index]['retailPrice'] : '-',
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
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
                              mainAxisAlignment:
                              MainAxisAlignment.start,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [

                                Expanded(
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        left: 1, right: 1),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment
                                          .start,
                                      mainAxisAlignment:
                                      MainAxisAlignment
                                          .center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("AccountManager.ShopName".tr().toString()),
                                        SizedBox(height: 1),
                                        Text(
                                          WarehouseStockList[index]['shopName'] != null || WarehouseStockList[index]['shopName'].length == 0 ? WarehouseStockList[index]['shopName'] : '-',
                                          style: TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
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
                              height: 5,
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                )
                    : Container(color: Colors.transparent),
              ),

              ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
            ],
          )
              : Center(
            child: Text(role),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
              color: Color(0xFFEBECF1),
              child: SingleChildScrollView(
                child: Column(
                  children: [
/////////////*****************************For Device Type***********************////////////////////
                    SizedBox(
                      height:12,
                    ),
                    Container(

                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "AccountManager.DeviceType".tr().toString(),
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
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                      child: Row(
                        children: [
                          buildDiviceType(),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                      child: Row(
                        children: [
                          emptyDiviceType == true
                              ? RequiredFeild(
                              text: "Menu_Form.msisdn_required".tr().toString())
                              : Container(),
                        ],
                      ),
                    ),
/**************************************************************************************************************/
/////////////*****************************For Device Name***********************////////////////////

                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "AccountManager.DeviceName".tr().toString(),
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
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                      child: Row(
                        children: [
                          buildDiviceName(),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                      child: Row(
                        children: [
                          emptyDiviceName == true
                              ? RequiredFeild(
                              text: "Menu_Form.msisdn_required".tr().toString())
                              : Container(),
                        ],
                      ),
                    ),
                    /**************************************************************************************************************/
                    /////////////*****************************For Select shop Name***********************////////////////////

                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 10),
                      child: Row(
                        children: [
                          RichText(
                            text: TextSpan(
                              text: "AccountManager.ShopName".tr().toString(),
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
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                      child: Row(
                        children: [
                          buildShopName(),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 20, right: 20, bottom: 5),
                      child: Row(
                        children: [
                          emptyShopName == true
                              ? RequiredFeild(
                              text: "Menu_Form.msisdn_required".tr().toString())
                              : Container(),
                        ],
                      ),
                    ),
                    /**************************************************************************************************************/

                    buildSearchBtn()
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
