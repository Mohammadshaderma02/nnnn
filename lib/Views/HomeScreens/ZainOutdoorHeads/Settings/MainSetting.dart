import 'package:flutter/cupertino.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Views/HomeScreens/ZainOutdoorHeads/Settings/Change_Lang.dart';
import 'package:sales_app/Views/HomeScreens/ZainOutdoorHeads/Settings/Change_Pass.dart';
import 'package:sales_app/Views/HomeScreens/ZainOutdoorHeads/ZainOutdoorHeads_Dashboard.dart';



class MainSetting extends StatefulWidget {
  var PermessionZainOutdoorHeads=[];
  var role;
  var outDoorUserName;
  MainSetting({this.PermessionZainOutdoorHeads,this.role,this.outDoorUserName});

  //const MainSettings({Key? key}) : super(key: key);

  @override
  State<MainSetting> createState() => _MainSettingsState(this.PermessionZainOutdoorHeads,this.role,this.outDoorUserName);
}

class _MainSettingsState extends State<MainSetting> {
  var PermessionZainOutdoorHeads=[];
  var role;
  var outDoorUserName;
  _MainSettingsState(this.PermessionZainOutdoorHeads, this.role, this.outDoorUserName);

  DateTime backButtonPressedTime;
  /******** for back button on mobile tap ******/
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard(PermessionZainOutdoorHeads:this.PermessionZainOutdoorHeads,role:this.role,outDoorUserName:this.outDoorUserName)),
      );


      return true;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: GestureDetector(
      onTap:()=>FocusScope.of(context).unfocus() ,
      child:  Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //tooltip: 'Menu Icon',
              onPressed: () async{
             //   Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard(PermessionZainOutdoorHeads:this.PermessionZainOutdoorHeads,role:this.role,outDoorUserName:this.outDoorUserName)),
                );
                },

            ),
            centerTitle:false,
            title: Text(
              "Settings_Form.settings".tr().toString(),
            ),
            backgroundColor: Color(0xFF392156),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(padding: EdgeInsets.only(top: 0), children: <Widget>[
            Container(
              color: Colors.white,
              child: Center(
                child: ListView(shrinkWrap: true, children: [

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
                            builder: (context) => Change_Lang(PermessionZainOutdoorHeads:this.PermessionZainOutdoorHeads,role:this.role,outDoorUserName:this.outDoorUserName),
                          ),
                        );
                      },
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  SizedBox(
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
                            builder: (context) => Change_Pass(PermessionZainOutdoorHeads:this.PermessionZainOutdoorHeads,role:this.role,outDoorUserName:this.outDoorUserName),
                          ),
                        );
                      },
                    ),
                  )


                ]),
              ),
            ),
          ])),
    ), onWillPop: onWillPop);
  }
}
