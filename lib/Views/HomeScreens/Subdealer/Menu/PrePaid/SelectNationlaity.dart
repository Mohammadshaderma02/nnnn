import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/LineDocumentation.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/NonJordanianNationality.dart';

import 'JordanNationality.dart';

class SelectNationality extends StatefulWidget {
  String msisdn;
  String kitCode;
  String ICCID;
  bool displayReference ;
  bool isShahamah ;
  bool showJordanian;
  bool showNonJordanian;
  /****************New for Bulk********************/
  List bulkNumbers;
  bool Bulk_Activat;
  /***********************************************/
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;

  SelectNationality(this.Permessions,this.role,this.outDoorUserName,this.msisdn,this.kitCode,this.ICCID,this.isShahamah,this.displayReference,this.showJordanian,
      this.showNonJordanian,
      this.bulkNumbers,this.Bulk_Activat);
  @override
  _SelectNationalityState createState() => _SelectNationalityState(this.Permessions,this.role,this.outDoorUserName,
      this.msisdn,this.kitCode,this.ICCID,this.isShahamah,this.displayReference,this.showJordanian,this.showNonJordanian,
      this.bulkNumbers,
      this.Bulk_Activat);

}

class _SelectNationalityState extends State<SelectNationality> {
  String msisdn;
  String kitCode;
  bool displayReference;
  bool isShahamah ;
  String ICCID;

  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  bool showJordanian;
  bool showNonJordanian;
  /****************New for Bulk********************/
  List bulkNumbers;
  bool Bulk_Activat;
  /***********************************************/


  _SelectNationalityState(this.Permessions,this.role,this.outDoorUserName,this.msisdn,this.kitCode,this.ICCID,this.isShahamah,this.displayReference,
      this.showJordanian,this.showNonJordanian, this.bulkNumbers,
      this.Bulk_Activat);
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
              "Select_Nationality.select_nationality".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
            Container(
              color: Colors.white,
              child: Center(
                child: ListView(shrinkWrap: true, children: [
                  showJordanian == true? Permessions.contains('05.01.01.01.01')==true?ListTile(
                    title: Text(
                      "Select_Nationality.jordanian".tr().toString(),
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
                          builder: (context) => JordanianNotionality(Permessions,role,outDoorUserName,msisdn,kitCode,ICCID,isShahamah,displayReference,
                              bulkNumbers,
                              Bulk_Activat),
                        ),
                      );
                    },
                  ):Container():Container(),
                  isShahamah==false ?Permessions.contains('05.01.01.01.01')==true?Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ):Container():Container(),
                  showNonJordanian == true ?isShahamah==false?Permessions.contains('05.01.01.01.02')==true? ListTile(
                    title: Text(
                      "Select_Nationality.non_jordanian".tr().toString(),
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
                          builder: (context) => NonJordanianNotionality(Permessions,
                              role,
                              outDoorUserName,
                              msisdn,
                              kitCode,
                              ICCID,
                              displayReference,
                              bulkNumbers,
                              Bulk_Activat),
                        ),
                      );
                    },
                  ):Container():Container():Container(),

                ]),
              ),
            ),
          ])),
    );
  }
}
