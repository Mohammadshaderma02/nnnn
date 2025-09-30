import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/LineDocumentation.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/NonJordanianNationality.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recharge/Recharge.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/UpgradePackage/EnterMSSIDNumber.dart';

import '../../CustomBottomNavigationBar.dart';
import 'JordanNationality.dart';
import 'PrePaidSales.dart';

class UpdateLine extends StatefulWidget {
  String msisdn;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  UpdateLine(this.Permessions,this.role,this.outDoorUserName, this.msisdn);
  @override
  _UpdateLineState createState() => _UpdateLineState(this.Permessions,this.role,this.outDoorUserName,this.msisdn);
}

class _UpdateLineState extends State<UpdateLine> {
  String msisdn;
  bool enableMsisdn =false;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  DateTime backButtonPressedTime;
  _UpdateLineState(this.Permessions,this.role,this.outDoorUserName,this.msisdn);
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
     // showAlertDialog(context,"هل انت متاكد من إغلاق التطبيق","Are you sure to close the application?");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CustomBottomNavigationBar(Permessions: Permessions,role:role,outDoorUserName: outDoorUserName,),
        ),
      );
      return true;
    }
    return true;
  }
/*  showAlertDialog(BuildContext context,arabicMessage,englishMessage) {
    Widget tryAgainButton = FlatButton(
      child: Text("alert.tryAgain".tr().toString() ,
        style: TextStyle(
          color: Color(0xFF4f2565),
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
        TextButton(
          onPressed: ()  {
            //   logoutBloc.add(LogoutButtonPressed(
            //   ));
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
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }*/
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),

        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                //tooltip: 'Menu Icon',
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CustomBottomNavigationBar(Permessions: Permessions,role:role,outDoorUserName: outDoorUserName,),
                    ),
                  );
                //  Navigator.of(context).pop();


                },
              ),
              title: Text(
                "UpdateLine.update_line".tr().toString()+"inside prepaid",
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
              Container(
                color: Colors.white,
                child: Center(
                  child: ListView(shrinkWrap: true, children: [
                    ListTile(
                      title: Text(
                        "UpdateLine.recharge_line".tr().toString(),
                        style: TextStyle(
                            fontSize: 14,
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
                            builder: (context) => Recharge(Permessions,role,outDoorUserName,enableMsisdn,msisdn),
                          ),
                        );
                      },
                    ),
                    Divider(
                      thickness: 1,
                      color: Color(0xFFedeff3),
                    ),
                    ListTile(
                      title: Text(
                        "UpdateLine.change_line_package".tr().toString(),
                        style: TextStyle(
                            fontSize: 14,
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
                            builder: (context) => EnterMSSIDNumber(Permessions,role,outDoorUserName,enableMsisdn,msisdn),
                          ),
                        );
                      },
                    ),
                  ]),
                ),

              ),
              SizedBox(height: 20,),
              Container(
                child: GestureDetector(
                  onTap:() {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CustomBottomNavigationBar(Permessions: Permessions,role:role,outDoorUserName: outDoorUserName,),
                      ),
                    );
                  },
                  child: Center(
                    child: Text("UpdateLine.finish_back".tr().toString(),
                    style: TextStyle(
                        fontSize: 14,
                        color:Color(0xFF4f2565),
                        fontWeight: FontWeight.bold)),
                  ),
                ),
              )
            ])),
      ),
    );
  }
}
