import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/CompletedOrders.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:sales_app/Views/ReusableComponents/appBar.dart';
import 'package:sales_app/blocs/Login/logout_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:dio/dio.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/Settings/Settings_Screen.dart';

import '../../../blocs/Login/logout_bloc.dart';
import '../../../blocs/Login/logout_events.dart';
import '../../LoginScreens/SignInScreen.dart';
import '../Subdealer/Menu/Recontracting/Recontracting.dart';

class Eshope_Menu extends StatefulWidget {
  var PermessionDeliveryEShop=[];
  var role;
  var outDoorUserName;
  Eshope_Menu({this.PermessionDeliveryEShop,this.role,this.outDoorUserName});
  @override
  _Eshope_MenuState createState() => _Eshope_MenuState(this.PermessionDeliveryEShop,this.role,this.outDoorUserName);
}

class _Eshope_MenuState extends State<Eshope_Menu> {


  final dio = Dio();
  Response response;
  final bool enableMsisdn = true;
  final String preMSISDN = '';
  var PermessionDeliveryEShop = [];
  var role;
  var outDoorUserName;
  bool freez = true;
  DateTime backButtonPressedTime;
  LogoutBloc logoutBloc;

  bool _showNativeView = false;
  _Eshope_MenuState(this.PermessionDeliveryEShop, this.role, this.outDoorUserName);

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
    print("PermessionDeliveryEShop");
    print(this.PermessionDeliveryEShop);

    logoutBloc = BlocProvider.of<LogoutBloc>(context);

    super.initState();
    getPrefs();
  }

  getPrefs() async {


    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      PermessionDeliveryEShop=  prefs.getStringList('PermessionDeliveryEShop');
    });
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

  }

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
        appBar: AppBar(

          centerTitle: false,
          title: Text( "Menu_Form.menu".tr().toString()),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.settings),
              tooltip: 'Settings',
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Settings_Screen(),
                  ),
                );
                /* ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('This is a snackbar')));*/
              },
            ),
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Go to the next page',
              onPressed: () => _onLogout(context),
            ),
          ],
          //<Widget>[]
          backgroundColor: Color(0xFF392156),
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
/*..............................................................Package Part...............................................................*/

                        SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              "DeliveryEShop.Orders_List".tr().toString(),
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
                                MaterialPageRoute(builder: (context) => OrdersScreen()),
                              );
                            },
                          ),
                        ),

                        PermessionDeliveryEShop.contains('12.00.01') == true?
                        Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ):Container(),

/*.........................................................Recontracting Part...............................................................*/

                        PermessionDeliveryEShop.contains('12.00.01') == true?
                        SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")?"Recontracting":"إعادة التعاقد",
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
                                      Recontracting(PermessionDeliveryEShop, role, outDoorUserName),
                                ),
                              );
                            },
                          ),
                        )
                        :Container(),


/*.....................................................Completed orders Part...............................................................*/

                        PermessionDeliveryEShop.contains('12.00.01') == true?
                        Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ):Container(),

                        PermessionDeliveryEShop.contains('12.00.02') == true?
                        SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")?"Completed orders":"الطلبات المكتملة",
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
                                      CompletedOrders(),
                                ),
                              );
                            },
                          ),
                        )
                            :Container(),


                      ]),
                ),
              ),
            ]) : Container(),
      ),
    );
  }

}