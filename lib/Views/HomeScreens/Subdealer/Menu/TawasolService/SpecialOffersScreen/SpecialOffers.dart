import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/SpecialOffersScreen/Buy/Buy.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/SpecialOffersScreen/Activate.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/SpecialOffersScreen/Inquiry.dart';



class SpecialOffers extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
    SpecialOffers({this.Permessions,this.role,this.outDoorUserName});
  @override
  _SpecialOffersState createState() => _SpecialOffersState(this.Permessions,this.role,this.outDoorUserName);
}

class _SpecialOffersState extends State<SpecialOffers> {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _SpecialOffersState(this.Permessions,this.role,this.outDoorUserName);
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
                Navigator.pop(
                  context,
                );
              },
            ),
            centerTitle:false,
            title: Text(
              "Menu_Form.special_offers".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              padding: EdgeInsets.only(top: 8),
              children: <Widget>[
                Container(
                  color: Colors.white,
                  child: Center(
                    child: ListView(shrinkWrap: true, children: [
                      Permessions.contains('05.04.02.01')==true?ListTile(
                        title: Text(
                          "Menu_Form.buy".tr().toString(),
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

                                builder: (context) =>  Buy(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),

                              ),

                            );

                          }
                      ):Container(),
                      Permessions.contains('05.04.02.01')==true?Divider(
                        thickness: 1,
                        color: Color(0xFFedeff3),
                      ):Container(),
                      Permessions.contains('05.04.02.02')==true?ListTile(
                        title: Text(
                          "Menu_Form.activate".tr().toString(),
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

                                builder: (context) =>  Activate(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),

                              ),

                            );

                          }
                      ):Container(),
                      Permessions.contains('05.04.02.02')==true?Divider(
                        thickness: 1,
                        color: Color(0xFFedeff3),
                      ):Container(),
                      Permessions.contains('05.04.02.03')==true? ListTile(
                        title: Text(
                          "Menu_Form.inquiry".tr().toString(),
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

                                builder: (context) =>  Inquiry(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),

                              ),

                            );

                          }
                      ):Container(),
                    ]),
                  ),
                ),
              ])),
    );
  }
}
