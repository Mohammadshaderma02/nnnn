import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';

import '../CustomBottomNavigationBar.dart';
import 'changeLanguage.dart';
import 'changePassword.dart';
import 'BarCode.dart';


class SettingsScreen extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  SettingsScreen({this.Permessions,this.role,this.outDoorUserName});
  @override
  _SettingsScreenState createState() => _SettingsScreenState(this.Permessions,this.role,this.outDoorUserName);
}

class _SettingsScreenState extends State<SettingsScreen> {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _SettingsScreenState(this.Permessions,this.role,this.outDoorUserName);

  void initState() {
    super.initState();
    print('seettings');
   print(Permessions);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            //tooltip: 'Menu Icon',
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle:false,
          title: Text(
            "Settings_Form.settings".tr().toString(),
          ),
          backgroundColor: Color(0xFF4f2565),
        ),
        backgroundColor: Color(0xFFEBECF1),
        body: ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
          Container(
            color: Colors.white,
            child: Center(
              child: ListView(shrinkWrap: true, children: [
                Permessions.contains('03.01')==true?
                SizedBox(
                  height: 50,
                  child: ListTile(
                    title: Text(
                      "Settings_Form.change_language".tr().toString(),
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
                    onTap:  () {
                          Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                          builder: (context) => ChangeLanguage(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
                          ),
                          );
                          },
                  ),
                ):Container(),
                Permessions.contains('03.01')==true?Divider(
                  thickness: 1,
                  color: Color(0xFFedeff3),
                ):Container(),
                Permessions.contains('03.02')==true?SizedBox(
                  height: 50,
                  child: ListTile(
                    title: Text(
                      "Settings_Form.change_password".tr().toString(),
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChangePassword(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
                        ),
                      );
                    },
                  ),
                ):Container(),

               /* Permessions.contains('03.02')==true?SizedBox(
                  height: 50,
                  child: ListTile(
                    title: Text(
                      "Barcode",
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
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => BarCode(Permessions:Permessions),
                        ),
                      );
                    },
                  ),
                ):Container(),*/
              ]),
            ),
          ),
        ]));
  }
}
