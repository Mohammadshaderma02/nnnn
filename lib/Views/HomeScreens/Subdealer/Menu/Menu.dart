import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/ChangeIndoorOutdoor/ChangeIndoorOutdoor.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/ChangePackage/changePackage.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/DarakLogVisit/darak_log_visit_screen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/EKYC_Main.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/TestScreen.dart';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EVDWallet/EVDWallet.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/IDScannerScreen.dart';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Inquiry/InquiryScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/LivenessDetectionScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PassportScannerScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PatternSimilarity/MSISDNcategory.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/RaiseTicket/RaiseTicket.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recontracting/Recontracting.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/RentalHandsetStamping/RentalHandsetStamping.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Reports/reports.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/SalesLeads.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/StampDevice/StampDevice.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/StockManagement/StockManagement.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/WFMRequestScreen/WFMRequestScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/ZainOffersFeature/zainOffers.dart';

import 'package:sales_app/Views/ReusableComponents/appBar.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/TawasolServices.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recharge/Recharge.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/UpgradePackage/EnterMSSIDNumber.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/CustomerService/CheckOTP.dart';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/PostPaidOptions.dart';

import 'package:dio/dio.dart';




class Menu extends StatefulWidget {
  var Permessions=[];
  var role;
  var outDoorUserName;
  Menu({this.Permessions,this.role,this.outDoorUserName});
  @override
  _MenuState createState() => _MenuState(this.Permessions,this.role,this.outDoorUserName);
}

class _MenuState extends State<Menu> {
  String fileurl = "https://fluttercampus.com/sample.pdf";

  final dio = Dio();
  Response response;
  final bool enableMsisdn = true;
  final String preMSISDN = '';
  var Permessions = [];
  var role;
  var outDoorUserName;
  bool freez = true;
  DateTime backButtonPressedTime;

  final channel = const MethodChannel('NativeChannel');
  static const String _channel = 'test_activity';
  static const platform = const MethodChannel('com.example.flutter/native');
  bool _showNativeView = false;
  _MenuState(this.Permessions, this.role, this.outDoorUserName);

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

  void initState() {
    super.initState();
    getPrefs();
  }

  getPrefs() async {

    setState(() {
      globalVars.permessionsChangePackage=this.Permessions;
      globalVars.roleChangePackage=this.role;
      globalVars.outDoorUserNameChangePackage=this.outDoorUserName;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.get('subdealerFreeze'));
    if (prefs.get('subdealerFreeze') == '0') {
      setState(() {
        freez = false;
      });
    } else {
      setState(() {
        freez = true;
      });
    }

    print('menu');
    print(Permessions);
  }

  Future<void> callNativeMethod() async {
    try {
      await channel.invokeMethod('NativeChannel');
      print( await channel.invokeMethod('NativeChannel'));

    } catch (e) {
      print('Error calling native method: $e');
    }
  }

/*For IOS Part EKYC*/
  Future<void>  _getNewActivity() async {
    print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
    setState(() {
      _showNativeView = true;
    });
    try {
      await platform.invokeMethod('startNewActivity');
      print("PlatformsUCSShhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");

    } on PlatformException catch (e) {
      print("PlatformExceptionhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");

      print(e.message);
    }
  }

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
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
            Navigator.pop(context, true);
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
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: Scaffold(
        appBar: appBarSection(
          appBar: AppBar(),
          title: Text(
            "Menu_Form.menu".tr().toString(),
          ),
          Permessions: Permessions,
          role: role,
          outDoorUserName: outDoorUserName,
        ),
        backgroundColor: Color(0xFFEBECF1),
        // bottomNavigationBar: CustomBottomNavigationBar(),
        body: freez == false ?
        ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 8),
            children: <Widget>[
              Container(
                color: Colors.white,
                child: Center(
                  child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      children: [
                        Permessions.contains('05.01') == true ? SizedBox(
                          height: 50,
                          child: ListTile(
                            title: Text(
                              "Menu_Form.prePaid_sales".tr().toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PrePaidSales(Permessions: Permessions,
                                          role: role,
                                          outDoorUserName: outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.01') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        Permessions.contains('05.02') == true ? SizedBox(
                          height: 50,
                          child: ListTile(
                            title: Text(
                              "Menu_Form.postPaid_sales".tr().toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      PostPaidOptions(Permessions: Permessions,
                                          role: role,
                                          outDoorUserName: outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.02') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        Permessions.contains('05.03') == true ? SizedBox(
                          height: 50,
                          child: ListTile(
                            title: Text(
                              "Menu_Form.customer_services".tr().toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CheckOTP(Permessions: Permessions,
                                          role: role,
                                          outDoorUserName: outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.03') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        Permessions.contains('05.04') == true ? SizedBox(
                          height: 50,
                          child: ListTile(
                            title: Text(
                              "Menu_Form.tawasol_services".tr().toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      TawasolServices(Permessions: Permessions,
                                          role: role,
                                          outDoorUserName: outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.04') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        Permessions.contains('05.05') == true ? SizedBox(
                          height: 50,
                          child: ListTile(
                            title: Text(
                              "Menu_Form.recharge".tr().toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Recharge(
                                          Permessions, role, outDoorUserName,
                                          enableMsisdn, preMSISDN),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.05') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        Permessions.contains('05.06') == true ? SizedBox(
                          height: 50,
                          child: ListTile(
                            title: Text(
                              "Menu_Form.raise_ticket".tr().toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RaiseTicket(Permessions: Permessions,
                                          role: role,
                                          outDoorUserName: outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.06') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        Permessions.contains('05.07') == true ? SizedBox(
                          height: 55,
                          child: ListTile(
                            title: Text(
                              "Menu_Form.reports".tr().toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Reports(Permessions: Permessions,
                                          role: role,
                                          outDoorUserName: outDoorUserName),
                                ),
                              );
                            },
                          ),

                        ) : Container(),
                        Permessions.contains('05.07') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        Permessions.contains('05.08') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              "Menu_Form.upgrade_Package".tr().toString(),
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EnterMSSIDNumber(
                                          Permessions, role, outDoorUserName,
                                          enableMsisdn, preMSISDN),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.08') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        /*********************************************************************New 3-8-2023********************************************************************/


                        Permessions.contains('05.09') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              "Pattern & Similarity",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MSISDN_Category(),
                                ),
                              );
                            },
                          ),
                        ) : Container(),

                        Permessions.contains('05.09') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        /*********************************************************************New 8-8-2023********************************************************************/

                        Permessions.contains('05.10') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'Stamp Device'
                                  : "ختم الجهاز",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => StampDevice(Permessions,outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),

                        Permessions.contains('05.10') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),

                        /*********************************************************************New 11-9-2023********************************************************************/

                        Permessions.contains('05.11') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'Inquiry'
                                  : "استفسار",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => InquiryScreen(Permessions),
                                ),
                              );
                            },
                          ),
                        ) : Container(),

                        Permessions.contains('05.11') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),

                        /*********************************************************************New Sales Leads********************************************************************/

                        Permessions.contains('05.12') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'Sales Leads'
                                  : "المبيعات",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      SalesLeads(
                                          Permessions, role, outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.12') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        /************************************************************************New 5-2-2024********************************************************************/
                        /*********************************************************************New Change Package********************************************************************/

                        Permessions.contains('05.13') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'Change Package'
                                  : "تغيير الحزمة",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      changePackage(Permessions, role, outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                         Permessions.contains('05.13') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),


                        /*********************************************************************New Recontract********************************************************************/
                        Permessions.contains('05.14') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'Recontracting'
                                  : "إعادة التعاقد",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Recontracting(
                                          Permessions, role, outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.14') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),


                        /************************************************************************New 13-2-2024********************************************************************/
                        /*********************************************************************New Change Indoor to Outdoor********************************************************************/
                        Permessions.contains('05.15') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'Change Indoor to Outdoor'
                                  : "التغيير من الداخل إلى الخارج",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      ChangeIndoorOutdoor(
                                          Permessions),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.15') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),


                        /************************************************************************New 13-2-2024********************************************************************/
                        /*********************************************************************New RentalHandsetStamping********************************************************************/
                        Permessions.contains('05.16') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'Rental Handset Stamping'
                                  : "ختم الجهاز المستأجر",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      RentalHandsetStamping(Permessions),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.16') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),


                        /*********************************************************************New 21-10-2024********************************************************************/
                        /*****************************************************************New WFM Request Screen******************************************************************/
                        Permessions.contains('05.17') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'WFM Request Screen'
                                  : "WFM Request Screen",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                  WFMRequestScreen(Permessions),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.17') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        /*********************************************************************New 14-11-2024********************************************************************/
                        /*****************************************************************New EVD Wallet Screen******************************************************************/
                        Permessions.contains('05.18') == true ? SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'EVD Wallet'
                                  : "EVD Wallet",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EVDWallet(),
                                ),
                              );
                            },
                          ),
                        ) : Container(),
                        Permessions.contains('05.18') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),

                        /*********************************************************************New 14-2-2025********************************************************************/
                        /*****************************************************************Stock Managment Screen******************************************************************/
                        Permessions.contains('05.19') == true ?   SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? "New Serials"
                                  : "المتسلسلات الجديدة",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      StockManagement(),
                                ),
                              );
                            },
                          ),
                        ): Container(),
                        Permessions.contains('05.19') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),


                        Permessions.contains('05.21') == true ? SizedBox(
                                      height: 60,
                                      child: ListTile(
                                        title: Text(
                                          EasyLocalization.of(context).locale ==
                                                  Locale("en", "US")
                                              ? 'Offer Details'
                                              : "تفاصيل العروض",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff11120e),
                                              fontWeight: FontWeight.normal),
                                        ),
                                        trailing: IconButton(
                                          icon: EasyLocalization.of(context)
                                                      .locale ==
                                                  Locale("en", "US")
                                              ? Icon(Icons.keyboard_arrow_right)
                                              : Icon(Icons.keyboard_arrow_left),
                                        ),
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  ZainOffersScreen(Permessions),
                                            ),
                                          );
                                        },
                                      ),
                                    ) : Container(),
                        Permessions.contains('05.21') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),
                        SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? "Darak Log visit"
                                  : "سجل زيارة دارك",

                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      DarakLogVisitScreen(),
                                ),
                              );
                            },
                          ),
                        ),

                      Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) ,
                        SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? "EKYC sales"
                                  : "التوثيق الإلكتروني",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EKYC_Main(),
                                ),
                              );
                            },
                          ),
                        ),
                      /*  SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? "Passport Scanner"
                                  : "Passport Scanner",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      LivenessScreen(),
                                ),
                              );
                            },
                          ),
                        ),*/























                      /*  SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? "E-Documentation"
                                  : "التوثيق الإلكتروني",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EKYC_Main(),
                                ),
                              );
                            },
                          ),
                        ),*/
                              /*  SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "USf")
                                  ? "IDScannerScreen"
                                  : "IDScannerScreen",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      IDScannerScreen(),
                                ),
                              );
                            },
                          ),
                        ),
                        Permessions.contains('05.19') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),


                        SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? "E-Documentation"
                                  : "التوثيق الإلكتروني",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal),
                            ),
                            trailing: IconButton(
                              icon: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Icon(Icons.keyboard_arrow_right)
                                  : Icon(Icons.keyboard_arrow_left),
                            ),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      EKYC_Main(),
                                ),
                              );
                            },
                          ),
                        ),*/




                       /* Permessions.contains('05.19') == true ? Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ) : Container(),*/







                      ]),
                ),
              ),
            ]) : Container(),
      ),
    );
  }

}