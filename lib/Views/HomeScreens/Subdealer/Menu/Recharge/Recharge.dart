import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recharge/DirectRecharge.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recharge/RechargeDenomination.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recharge/Checkvoucher.dart';


class Recharge extends StatefulWidget {
  final bool enableMsisdn;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  final String  preMSISDN;
  Recharge(this.Permessions,this.role,this.outDoorUserName,this.enableMsisdn,this.preMSISDN);
  @override
  _RechargeState createState() => _RechargeState(this.Permessions,this.role,this.outDoorUserName,this.enableMsisdn,this.preMSISDN);
}

class _RechargeState extends State<Recharge> {
  final bool enableMsisdn;
  final String  preMSISDN;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _RechargeState(this.Permessions,this.role,this.outDoorUserName,this.enableMsisdn,this.preMSISDN);
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
              "Menu_Form.recharge".tr().toString(),
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
                      Permessions.contains('05.05.01')?SizedBox(
                        height: 50,
                        child: ListTile(
                          title: Text(
                            "Menu_Form.recharge_denomination".tr().toString(),
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
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RechargeDenomination(enableMsisdn,preMSISDN),
                              ),
                            );
                          },
                        ),
                      ):Container(),
                      Permessions.contains('05.05.01')?Divider(
                        thickness: 1,
                        color: Color(0xFFedeff3),
                      ):Container(),
                      Permessions.contains('05.05.02')?SizedBox(
                        height: 50,
                        child: ListTile(
                          title: Text(
                            "Menu_Form.direct_recharge".tr().toString(),
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
                                builder: (context) => DirectRecharge(enableMsisdn,preMSISDN),
                              ),
                            );
                          },
                        ),
                      ):Container(),
                      Permessions.contains('05.05.02')?Divider(
                        thickness: 1,
                        color: Color(0xFFedeff3),
                      ):Container(),
                      Permessions.contains('05.05.03')?SizedBox(
                        height: 55,
                        child: ListTile(
                          title: Text(
                            "Menu_Form.check_voucher".tr().toString(),
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
                          onTap: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Checkvoucher(),
                              ),
                            );
                          },
                        ),
                      ):Container(),
                    ]),
                  ),
                ),
              ])),
    );
  }
}
