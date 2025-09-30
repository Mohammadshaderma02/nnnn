import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:group_list_view/group_list_view.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/CustomBottomNavigationBar.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/AcceptedContracts/ContractDetails.dart';

class AcceptedContracts extends StatefulWidget {
  @override
  _AcceptedContractsState createState() => _AcceptedContractsState();
}

class _AcceptedContractsState extends State<AcceptedContracts> {
  var sub_delar = ["Sub dealer"];
  var number = ["32077814"];
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
                  builder: (context) => CustomBottomNavigationBar(),
                ),
              );
            },
          ),
          centerTitle:false,
          title: Text(
            "DashBoard_Form.accepted_contracts".tr().toString(),
          ),
          backgroundColor: Color(0xFF4f2565),
        ),
        backgroundColor: Color(0xFFEBECF1),
        body: ListView.separated(
          padding: EdgeInsets.only(top: 8),
          itemCount: sub_delar.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
              color: Colors.white,
              child: Center(
                child: ListView(shrinkWrap: true, children: [
                  ListTile(
                    leading: Container(
                      width: 160,
                      child: Text(
                        sub_delar[index],
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    title: Text(
                      number[index],
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xff11120e),
                      ),
                    ),
                    trailing: IconButton(
                        icon: EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                            ? Icon(Icons.keyboard_arrow_right)
                            : Icon(Icons.keyboard_arrow_left),
                   ),
                    onTap:     () {
                      Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                      builder: (context) => ContractDetails(),
                      ),
                      );
                      },
                  )
                ]),
              ),
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        ));
  }
}
