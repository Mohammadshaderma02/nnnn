import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Setting/SettingsScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/NotificationsScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/AcceptedContracts/AcceptedContracts.dart';

class ContractDetails extends StatefulWidget {
  //const ContractDetails({Key? key}) : super(key: key);

  @override
  _ContractDetailsState createState() => _ContractDetailsState();
}

class _ContractDetailsState extends State<ContractDetails> {
  var Info = [
    "32077814",
    "0790969125",
    "08/May/2021 16:24:00",
    "Sub dealer pending"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            //tooltip: 'Menu Icon',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => AcceptedContracts(),
                ),
              );
            },
          ),
          centerTitle:false,
          title: Text(
            "DashBoard_Form.contract_details".tr().toString(),
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
                  leading: Container(
                    width: 170,
                    child: Text(
                      "DashBoard_Form.kit_code".tr().toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff11120e),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  title: Text(
                    "32077814",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xFFedeff3),
                ),
                ListTile(
                  leading: Container(
                    width: 170,
                    child: Text(
                      "DashBoard_Form.kit_code".tr().toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff11120e),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  title: Text(
                    "0796566211",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xFFedeff3),
                ),
                ListTile(
                  leading: Container(
                    width: 170,
                    child: Text(
                      "DashBoard_Form.actovation_date".tr().toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff11120e),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  title: Text(
                    "08/May/2021 16:24:00",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Divider(
                  thickness: 1,
                  color: Color(0xFFedeff3),
                ),
                ListTile(
                  leading: Container(
                    width: 170,
                    child: Text(
                      "DashBoard_Form.status".tr().toString(),
                      style: TextStyle(
                          fontSize: 14,
                          color: Color(0xff11120e),
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  title: Text(
                    "Sub dealer pending",
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.normal),
                  ),
                ),
              ]),
            ),
          ),
        ]));
  }
}
