import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Reports/salesReports.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/NotificationsScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Setting/SettingsScreen.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/logoutButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/TawasolServices.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recharge/Recharge.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/UpgradePackage/EnterMSSIDNumber.dart';



class Reports extends StatefulWidget {
  List<dynamic>Permessions;
  var role;
  var outDoorUserName;
  Reports({this.Permessions,this.role,this.outDoorUserName});

  @override
  _Reports createState() => _Reports(this.Permessions,this.role,this.outDoorUserName);
}

class _Reports extends State<Reports> {
  List<dynamic>Permessions;
  var role;
  var outDoorUserName;
  _Reports(this.Permessions,this.role,this.outDoorUserName);
  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
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

            exit(0);
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
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
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),

      child: Scaffold(
          appBar:AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //tooltip: 'Menu Icon',
              onPressed: () {
                Navigator.pop(
                  context,
                );
              },
            ),
            centerTitle:false,
            title: Text(
              "Reports.reports".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          // bottomNavigationBar: CustomBottomNavigationBar(),
          body: ListView(
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
                          Permessions.contains('05.07.01')? SizedBox(
                            height: 60,
                            child: ListTile(
                              title: Text(
                                "Reports.sales_reports".tr().toString(),
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xff11120e),
                                    fontWeight: FontWeight.normal),
                              ),
                              trailing: IconButton(
                                icon: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? Icon(Icons.keyboard_arrow_right)
                                    : Icon(Icons.keyboard_arrow_left),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SalesReports(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
                                  ),
                                );
                              },
                            ),
                          ):Container(),
                        ]),
                  ),
                ),
              ]),
        ),
    );
  }
}
