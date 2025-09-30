import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/Esime.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/LineDocumentation_Bulk.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/LineDocumentation.dart';

import '../../CustomBottomNavigationBar.dart';

class PrePaidSales extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  PrePaidSales({this.Permessions, this.role, this.outDoorUserName});
  @override
  _PrePaidSalesState createState() =>
      _PrePaidSalesState(this.Permessions, this.role, this.outDoorUserName);
}

class _PrePaidSalesState extends State<PrePaidSales> {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  bool Single_Activat = true;
  bool Bulk_Activat = false;

  bool Generic=false;
  bool Generic_Prepaid=true;

  _PrePaidSalesState(this.Permessions, this.role, this.outDoorUserName);
  @override


  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //tooltip: 'Menu Icon',
              onPressed: () {
                Navigator.pop(
                  context,
                );

                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CustomBottomNavigationBar(),
                  ),
                );*/
              },
            ),
            centerTitle: false,
            title: Text(
              "Menu_Form.prePaid_sales".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
            Permessions.contains('05.01.01') == true?
            Container(
              color: Colors.white,
              height: 60,
              child: Center(
                child: ListView(shrinkWrap: true, children: [
                  Permessions.contains('05.01.01') == true
                      ? ListTile(
                          title: Text(
                            "Menu_Form.line_documentation".tr().toString(),
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
                          onTap: () => {

                     Permessions.contains('05.01.01.02') == true?
                            showDialog(
                              context: context,
                              builder: (context) {

                                return StatefulBuilder(
                                  builder: (context, setState) {
                                    return AlertDialog(
                                      title: Text("Menu_Form.Activation_Type".tr().toString(),),
                                      content:  Container(
                                        alignment: Alignment.topLeft,
                                        height: 110,
                                        child: Column(
                                          children: [

                                            Expanded(
                                              child: Align(
                                                alignment: EasyLocalization.of(context).locale == Locale("en", "US")?
                                                Alignment.centerLeft:Alignment.centerRight,
                                                child: Container(
                                                  color: Colors.white,
                                                  child:        ElevatedButton.icon(
                                                    // <-- ElevatedButton
                                                    onPressed: () {  if (Bulk_Activat == true) {
                                                      setState(() {
                                                        Bulk_Activat = false;
                                                        Single_Activat = true;
                                                      });
                                                    }
                                                    },
                                                    style: Single_Activat == true
                                                        ? ElevatedButton.styleFrom(
                                                      primary: Colors.white,
                                                      onPrimary: Color(0xFF4f2565),

                                                      shadowColor: Colors.transparent,
                                                    )
                                                        : ElevatedButton.styleFrom(
                                                      primary: Colors.white,
                                                      onPrimary: Colors.black87,

                                                      shadowColor: Colors.transparent,
                                                    ),
                                                    icon: Single_Activat == true
                                                        ? Icon(
                                                      Icons.check_circle,
                                                      size: 24.0,
                                                    )
                                                        : Icon(
                                                      Icons.circle_outlined,
                                                      size: 24.0,
                                                    ),
                                                    label: Text("Menu_Form.Single_Activation".tr().toString(),style:TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.normal)),
                                                  ),
                                                ),
                                              ),
                                            ),

                                            Expanded(
                                              child: Align(
                                                alignment:EasyLocalization.of(context).locale == Locale("en", "US")?
                                                Alignment.centerLeft:Alignment.centerRight,
                                                child: Container(
                                                  color: Colors.white,
                                                  child:
                                                  ElevatedButton.icon(
                                                    // <-- ElevatedButton
                                                    onPressed: () {

                                                      if (Single_Activat == true) {
                                                        setState(() {
                                                          Bulk_Activat = true;
                                                          Single_Activat = false;
                                                        });
                                                      }


                                                    },
                                                    style: Bulk_Activat == true
                                                        ? ElevatedButton.styleFrom(
                                                      primary: Colors.white,
                                                      onPrimary: Color(0xFF4f2565),

                                                      shadowColor: Colors.transparent,
                                                    )
                                                        : ElevatedButton.styleFrom(
                                                      primary: Colors.white,
                                                      onPrimary: Colors.black87,

                                                      shadowColor: Colors.transparent,
                                                    ),
                                                    icon: Bulk_Activat == true
                                                        ? Icon(
                                                      Icons.check_circle,
                                                      size: 24.0,
                                                    )
                                                        : Icon(
                                                      Icons.circle_outlined,
                                                      size: 24.0,
                                                    ),
                                                    label: Text("Menu_Form.Bulk_Activation".tr().toString(),style:TextStyle(
                                                        fontSize: 16,
                                                        color: Colors.black87,
                                                        fontWeight: FontWeight.normal) ,),
                                                  ),
                                                ),
                                              ),
                                            ),


                                          ],
                                        ),
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Postpaid.Cancel".tr().toString(),style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF4f2565),
                                              fontWeight: FontWeight.bold),),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                          if(Single_Activat==true){
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LineDocumentation(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName, Bulk_Activat:Bulk_Activat),
                                              ),
                                            );
                                          }
                                          if(Bulk_Activat==true){
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => LineDocumentation_Bulk(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName, Bulk_Activat:Bulk_Activat),
                                              ),
                                            );
                                          }
                                          },
                                          child: Text("Postpaid.Next".tr().toString(),style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xFF4f2565),
                                              fontWeight: FontWeight.bold),),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                            ):Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LineDocumentation(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName,Bulk_Activat:Bulk_Activat),
                              ),
                            ),

                         /* Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => LineDocumentation(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName,Bulk_Activat:Bulk_Activat),
                              ),
                            ),*/
                            /* Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => LineDocumentation(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
                        ),
                      );*/
                          },
                        )
                      : Container(),
                ]),
              ),
            ):Container(),
            Permessions.contains('05.01.02') == true && Permessions.contains('05.01.01') == true? Container(child: Divider(),color: Colors.white,):Container(),

            Permessions.contains('05.01.02') == true?  Container(
              color: Colors.white,
              height: 60,
              child: Center(
                child: ListView(shrinkWrap: true, children: [
                  Permessions.contains('05.01.02') == true
                      ? ListTile(
                    title: Text(
                      EasyLocalization
                          .of(context)
                          .locale ==
                          Locale("en", "US")
                          ?"E-SIM ":"E-SIM ",
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
                    onTap: () => {
                    Navigator.push(
                    context,
                    MaterialPageRoute(
                    builder: (context) =>
                    Esime(Permessions: Permessions,
                    role: role,
                    outDoorUserName: outDoorUserName),
                    ),
                    )
                    /*  showDialog(
                        context: context,
                        builder: (context) {

                          return StatefulBuilder(
                            builder: (context, setState) {
                              return AlertDialog(
                                title: Text(EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ?"Select Package":"اختر الحزمة"),
                                content:  Container(
                                  alignment: Alignment.topLeft,
                                  height: 110,
                                  child: Column(
                                    children: [

                                      Expanded(
                                        child: Align(
                                          alignment:EasyLocalization.of(context).locale == Locale("en", "US")?
                                          Alignment.centerLeft:Alignment.centerRight,
                                          child: Container(
                                            color: Colors.white,
                                            child:        ElevatedButton.icon(
                                              // <-- ElevatedButton
                                              onPressed: () {  if (Generic == true) {
                                                setState(() {
                                                  Generic = false;
                                                  Generic_Prepaid = true;
                                                });
                                              }
                                              },
                                              style: Generic_Prepaid== true
                                                  ? ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                                onPrimary: Color(0xFF4f2565),

                                                shadowColor: Colors.transparent,
                                              )
                                                  : ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                                onPrimary: Colors.black87,

                                                shadowColor: Colors.transparent,
                                              ),
                                              icon: Generic_Prepaid == true
                                                  ? Icon(
                                                Icons.check_circle,
                                                size: 24.0,
                                              )
                                                  : Icon(
                                                Icons.circle_outlined,
                                                size: 24.0,
                                              ),
                                              label: Text("Generic Prepaid BB",style:TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.normal)),
                                            ),
                                          ),
                                        ),
                                      ),

                                      Expanded(
                                        child: Align(
                                          alignment:EasyLocalization.of(context).locale == Locale("en", "US")?
                                          Alignment.centerLeft:Alignment.centerRight,
                                          child: Container(
                                            color: Colors.white,
                                            child:
                                            ElevatedButton.icon(
                                              // <-- ElevatedButton
                                              onPressed: () {

                                                if (Generic_Prepaid == true) {
                                                  setState(() {
                                                    Generic = true;
                                                    Generic_Prepaid  = false;
                                                  });
                                                }


                                              },
                                              style: Generic == true
                                                  ? ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                                onPrimary: Color(0xFF4f2565),

                                                shadowColor: Colors.transparent,
                                              )
                                                  : ElevatedButton.styleFrom(
                                                primary: Colors.white,
                                                onPrimary: Colors.black87,

                                                shadowColor: Colors.transparent,
                                              ),
                                              icon: Generic == true
                                                  ? Icon(
                                                Icons.check_circle,
                                                size: 24.0,
                                              )
                                                  : Icon(
                                                Icons.circle_outlined,
                                                size: 24.0,
                                              ),
                                              label: Text("Generic0JD",style:TextStyle(
                                                  fontSize: 16,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.normal) ,),
                                            ),
                                          ),
                                        ),
                                      ),


                                    ],
                                  ),
                                ),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context),
                                    child: Text("Postpaid.Cancel".tr().toString(),style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF4f2565),
                                        fontWeight: FontWeight.bold),),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      if(Generic_Prepaid ==true){
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LineDocumentation(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName, Bulk_Activat:Bulk_Activat),
                                          ),
                                        );
                                      }
                                      if(Generic==true){
                                        Navigator.pop(context);
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => LineDocumentation_Bulk(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName, Bulk_Activat:Bulk_Activat),
                                          ),
                                        );
                                      }
                                    },
                                    child: Text("Postpaid.Next".tr().toString(),style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xFF4f2565),
                                        fontWeight: FontWeight.bold),),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )*/
                    },
                  )
                      : Container(),
                ]),
              ),
            ):Container(),
          ])),
    );
  }
}
