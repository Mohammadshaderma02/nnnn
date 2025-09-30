import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/RaiseTicket/SubmitTicket.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/RaiseTicket/TicketHistory.dart';


class RaiseTicket extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  RaiseTicket({this.Permessions,this.role,this.outDoorUserName});
  @override
  _RaiseTicketState createState() => _RaiseTicketState(this.Permessions,this.role,this.outDoorUserName);
}

class _RaiseTicketState extends State<RaiseTicket> {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _RaiseTicketState(this.Permessions,this.role,this.outDoorUserName);
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
            "Menu_Form.raise_ticket".tr().toString(),
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
                        Permessions.contains('05.06.01')?SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              "Test.submit_ticket".tr().toString(),
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
                                  builder: (context) => SubmitTicket(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
                                ),
                              );
                            },
                          ),
                        ):Container(),
                        Permessions.contains('05.06.01')?Divider(
                          thickness: 1,
                          color: Color(0xFFedeff3),
                        ):Container(),
                        Permessions.contains('05.06.02')?SizedBox(
                          height: 60,
                          child: ListTile(
                            title: Text(
                              "Test.ticket_history".tr().toString(),
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
                                  builder: (context) => TicketHistory(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
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