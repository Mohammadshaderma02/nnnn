import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_Package.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/JordanNationality.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/LineDocumentation.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/NonJordanianNationality.dart';

import 'PRETOPOSTCheckValidation.dart';


class GSMOptions extends StatefulWidget {
  final List<dynamic> Permessions;
  String marketType;
  var role;
  var outDoorUserName;
  String packageCode;

  GSMOptions({this.Permessions,this.marketType,this.role,this.outDoorUserName});
  @override
  _GSMOptionsState createState() => _GSMOptionsState(this.Permessions,this.marketType,this.role,this.outDoorUserName);

}

class _GSMOptionsState extends State<GSMOptions> {
  final List<dynamic> Permessions;
  String marketType;
  var role;
  var outDoorUserName;
  String packageCode;
  _GSMOptionsState(this.Permessions,this.marketType,this.role,this.outDoorUserName);
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),

      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //tooltip: 'Menu Icon',
              onPressed: () {
                Navigator.pop(context);
                /* Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LineDocumentation(),
                  ),
                );*/
              },
            ),
            centerTitle:false,
            title: Text(
              "Postpaid.GSM_Options".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
            Container(
              color: Colors.white,
              child: Center(
                child: ListView(shrinkWrap: true, children: [
                  Permessions.contains('05.02.03.02')==true ? ListTile(
                    title: Text(
                      "Postpaid.new_line".tr().toString(),
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
                          builder: (context) =>

                              GSMPackage(Permessions:Permessions,role:role,
                              outDoorUserName:outDoorUserName,
                              marketType:'GSM'),
                        ),
                      );
                    },
                  ):Container(),
                 Permessions.contains('05.02.03.02')== true  ?
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ):Container(),
                  Permessions.contains('05.02.03.03')==true? ListTile(
                    title: Text(
                      "Postpaid.pre_to_post".tr().toString(),
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
                          builder: (context) =>

                              PRETOPOSTCheckValidation(Permessions:Permessions,role:role,
                                  outDoorUserName:outDoorUserName,
                                  marketType:'PRETOPOST')

                        ),
                      );
                    },
                  ):Container(),
                ]),
              ),
            ),
          ])),
    );
  }
}
