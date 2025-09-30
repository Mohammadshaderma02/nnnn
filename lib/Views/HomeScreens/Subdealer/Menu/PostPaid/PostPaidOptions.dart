import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_Packages.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/ConnectionType.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/contract_details.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_Package.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/FTTHpackage.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_block.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


import '../../CustomBottomNavigationBar.dart';
import 'GSM/GSM_Options.dart';

class PostPaidOptions extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  PostPaidOptions({this.Permessions,this.role,this.outDoorUserName});

  @override
  _PostPaidOptionsState createState() => _PostPaidOptionsState(this.Permessions,this.role,this.outDoorUserName);
}

class _PostPaidOptionsState extends State<PostPaidOptions> {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  String marketType;
  _PostPaidOptionsState(this.Permessions,this.role,this.outDoorUserName);
  bool response= false;
  String packagesSelect;

  bool ZAIN_Activat = true;
  bool MADA_Activat = false;
  void initState() {
    super.initState();
  }
  @override

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          centerTitle:false,

          title: Text(
            "Menu_Form.postPaid_sales".tr().toString(),
          ),
          backgroundColor: Color(0xFF4f2565),
        ),
        backgroundColor: Color(0xFFEBECF1),
        body: ListView(padding: EdgeInsets.only(top: 8),
            children: <Widget>[

              Container(
                color: Colors.white,

                child: Center(
                  child: ListView(shrinkWrap: true, children: [
                    Permessions.contains('05.02')==true?
                    SizedBox(

                      child: ListTile(
                        title: Text(
                          "Postpaid.GSM".tr().toString(),
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
                     /* showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "This service not available now "
                              : "هذه الخدمة غير متوفرة الآن",
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);*/
                       setState(() {
                            packagesSelect="GSM";
                          });
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GSMOptions(Permessions:Permessions,role:role,
                                  outDoorUserName:outDoorUserName,
                                  marketType:packagesSelect),
                            ),
                          );

                        },
                      ),
                    ):Container(),
                    Permessions.contains('05.02')==true?Divider(
                      thickness: 1,
                      color: Color(0xFFedeff3),
                    ):Container(),
                    Permessions.contains('05.02.01')==true? SizedBox(

                      child: ListTile(
                        title: Text(
                          "Postpaid.BroadBand".tr().toString(),
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
                          setState(() {
                             packagesSelect="MBB";
                           });
                          Permessions.contains('05.02.01.00')==true?
                          showDialog(
                            context: context,
                            builder: (context) {

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text(EasyLocalization.of(context).locale ==
                                        Locale("en", "US")?"Select user Type":"اختر نوع المستخدم"),
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
                                                  onPressed: () {
                                                    if (MADA_Activat == true) {
                                                    setState(() {
                                                      MADA_Activat = false;
                                                      ZAIN_Activat = true;
                                                    });
                                                  }
                                                  },
                                                  style: ZAIN_Activat == true
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
                                                  icon: ZAIN_Activat == true
                                                      ? Icon(
                                                    Icons.check_circle,
                                                    size: 24.0,
                                                  )
                                                      : Icon(
                                                    Icons.circle_outlined,
                                                    size: 24.0,
                                                  ),
                                                  label: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"ZAIN":"زين",
                                                      style:TextStyle(
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

                                                    if (ZAIN_Activat == true) {
                                                      setState(() {
                                                        MADA_Activat = true;
                                                        ZAIN_Activat = false;
                                                      });
                                                    }


                                                  },
                                                  style: MADA_Activat == true
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
                                                  icon: MADA_Activat == true
                                                      ? Icon(
                                                    Icons.check_circle,
                                                    size: 24.0,
                                                  )
                                                      : Icon(
                                                    Icons.circle_outlined,
                                                    size: 24.0,
                                                  ),
                                                  label: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"MADA":"مدى",
                                                    style:TextStyle(
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
                                          if(ZAIN_Activat==true){
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BroadBandpackage(Permessions:Permessions,role:role,
                                                    outDoorUserName:outDoorUserName,
                                                    marketType:packagesSelect,MADA_Activat:false),
                                              ),
                                            );
                                          }
                                          if(MADA_Activat==true){
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => BroadBandpackage(Permessions:Permessions,role:role,
                                                    outDoorUserName:outDoorUserName,
                                                    marketType:packagesSelect,MADA_Activat:true),
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
                          ):     Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => BroadBandpackage(Permessions:Permessions,role:role,
                                  outDoorUserName:outDoorUserName,
                                  marketType:packagesSelect,MADA_Activat:false),
                            ),
                          );





                          /* showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "This service not available now "
                               : "هذه الخدمة غير متوفرة الآن",
                               context: context,
                              animation: StyledToastAnimation.scale,
                               fullWidth: true);*/
                   },
                      ),
                    ):Container(),
                    Permessions.contains('05.02.02')==true?Divider(
                      thickness: 1,
                      color: Color(0xFFedeff3),
                    ):Container(),
                    Permessions.contains('05.02.02')==true?
                    SizedBox(

                      child: ListTile(
                        title: Text(
                          "Postpaid.FTTH".tr().toString(),
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
                          setState(() {
                            packagesSelect="FTTH";
                          });
                          Permessions.contains('05.02.02.00')==true?
                          showDialog(
                            context: context,
                            builder: (context) {

                              return StatefulBuilder(
                                builder: (context, setState) {
                                  return AlertDialog(
                                    title: Text(EasyLocalization.of(context).locale ==
                                        Locale("en", "US")?"Select user Type":"اختر نوع المستخدم"),
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
                                                  onPressed: () {
                                                    if (MADA_Activat == true) {
                                                      setState(() {
                                                        MADA_Activat = false;
                                                        ZAIN_Activat = true;
                                                      });
                                                    }
                                                  },
                                                  style: ZAIN_Activat == true
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
                                                  icon: ZAIN_Activat == true
                                                      ? Icon(
                                                    Icons.check_circle,
                                                    size: 24.0,
                                                  )
                                                      : Icon(
                                                    Icons.circle_outlined,
                                                    size: 24.0,
                                                  ),
                                                  label: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"ZAIN":"زين",
                                                      style:TextStyle(
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

                                                    if (ZAIN_Activat == true) {
                                                      setState(() {
                                                        MADA_Activat = true;
                                                        ZAIN_Activat = false;
                                                      });
                                                    }


                                                  },
                                                  style: MADA_Activat == true
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
                                                  icon: MADA_Activat == true
                                                      ? Icon(
                                                    Icons.check_circle,
                                                    size: 24.0,
                                                  )
                                                      : Icon(
                                                    Icons.circle_outlined,
                                                    size: 24.0,
                                                  ),
                                                  label: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"MADA":"مدى",
                                                    style:TextStyle(
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
                                          if(ZAIN_Activat==true){
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ConnectionType(Permessions:Permessions,role:role,
                                                      outDoorUserName:outDoorUserName,
                                                      marketType:packagesSelect,MADA_Activat:false)
                                              ),
                                            );
                                          }
                                          if(MADA_Activat==true){
                                            Navigator.pop(context);
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => ConnectionType(
                                                      Permessions:Permessions,
                                                      role:role,
                                                      outDoorUserName:outDoorUserName,
                                                      marketType:packagesSelect,
                                                      MADA_Activat:true
                                                  )
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
                          ):      Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectionType(
                                    Permessions:Permessions,
                                    role:role,
                                    outDoorUserName:outDoorUserName,
                                    marketType:packagesSelect,
                                    MADA_Activat:false
                                )
                            ),
                          );





                         /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FTTHpackage(Permessions:Permessions,role:role,
                                  outDoorUserName:outDoorUserName,
                                  marketType:packagesSelect),
                            ),
                          );*/

                        },
                      ),
                    ):Container(),

                  ]),
                ),

              ),


            ]
        ));

  }
}




//////
/**/