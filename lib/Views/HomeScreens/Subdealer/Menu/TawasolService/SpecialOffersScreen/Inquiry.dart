import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Inquire/Inquire_block.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Inquire/Inquire_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Inquire/Inquire_events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class Inquiry extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  Inquiry({this.Permessions,this.role,this.outDoorUserName});
  @override
  _InquiryState createState() => _InquiryState(this.Permessions,this.role,this.outDoorUserName);
}

class _InquiryState extends State<Inquiry> {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _InquiryState(this.Permessions,this.role,this.outDoorUserName);
  Map data = new Map();
  List<dynamic> UserList =[];
  bool emptymsisdn = false;
  bool errormsisdn = false;
  var response ;
  bool available = false;
  String MobileNumber;
  String KitCode;
  String Price;
  bool errorserialNumber = false;

  InquireBloc inquireBloc;

  TextEditingController msisdn = TextEditingController();


  @override
  void initState() {
    super.initState();
    super.initState();
    inquireBloc = BlocProvider.of<InquireBloc>(context);

  }

  final msg = BlocBuilder<InquireBloc,
      InquireState>(builder: (context, state) {
    if (state is InquireLoadingState) {
      return Center(child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: CircularProgressIndicator(
          valueColor:AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
        ),
      ));
    } else {
      return Container();
    }
  });

  @override
  void dispose() {
    super.dispose();
  }

  Widget MSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.msisdn".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Color(0xFFB10000),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: msisdn,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptymsisdn== true || errormsisdn==true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              )
                  : const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4F2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon:IconButton(
                onPressed: (){
                  setState(() {
                    msisdn.text='';
                    response=0;
                  });
                },
                icon: Icon(
                    Icons.close
                ),
                color: Color(0xFFA4B0C1),
              ),
              hintText: "Menu_Form.(079) 0000 000".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }




  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        msisdn.clear();
      },
    );
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
        tryAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

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
            "Menu_Form.Inquiry".tr().toString(),
          ),
          backgroundColor: Color(0xFF4f2565),
        ),
        backgroundColor: Color(0xFFEBECF1),
        body: ListView(padding: EdgeInsets.only(top: 10), children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      MSISDN(),
                      emptymsisdn == true
                          ? ReusableRequiredText(
                          text: "Menu_Form.serial_numbe_required"
                              .tr()
                              .toString())
                          : Container(),
                      errormsisdn == true
                          ? ReusableRequiredText(
                          text: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? "Your MSISID shoud be 10 digits and start with 079"
                              : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),

                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 20),
          msg,
          Container(
              height: 48,
              width: 420,
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: BlocListener<InquireBloc,
                  InquireState>(
                listener: (context, state) {
                  if (state is InquireErrorState) {
                    setState(() {
                      response=0;
                    });
                    showAlertDialog(context, state.arabicMessage, state.englishMessage);

                  }

                  if (state is InquireSuccessState) {
                   // showAlertDialog(context, state.arabicMessage, state.englishMessage);
                    print("test");
                    print(state.msisdn);

                    setState(() {
                      response=1;

                      MobileNumber = state.msisdn;
                      KitCode = state.kitcode;
                      Price = state.price;
                    });


                  }
                },
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:Color(0xFF4f2565),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (msisdn.text == '') {
                      setState(() {
                        errormsisdn = false;
                        emptymsisdn = true;
                      });
                    }
                    if (msisdn.text != '') {
                      if(msisdn.text.length == 10 ){
                        if( msisdn.text.substring(0, 3) == '079'){
                          setState(() {
                            errormsisdn = false;
                            emptymsisdn=false;
                          });}
                      }else {
                        setState(() {
                          errormsisdn = true;
                          emptymsisdn=false;
                        });
                      }
                    }

                    if (msisdn.text != '' && msisdn.text.length == 10 && msisdn.text.substring(0, 3) == '079') {
                      setState(() {
                        response=0;

                      });
                      inquireBloc.add(InquirePressed(msisdn: msisdn.text));
                    }
                  },

                  child: Text(
                    "Reports.search".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),

          SizedBox(height: 20),
          response==1?

          Container(
            padding:
            EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 15),
            //margin: EdgeInsets.only(top: 20),
            child: Text(
              "TawasolService.Line_Details".tr().toString(),
              style: TextStyle(
                color: Color(0xFF11120e),
                fontSize: 16,
                fontWeight: FontWeight.w600,

              ),
            ),
          ):Container(),
          response==1?Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Container(

                        child: ListView(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            children: [
                              SizedBox(
                                height:30,
                                child: ListTile(
                                  title: Text(
                                    "TawasolService.kit_code".tr().toString()+KitCode,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff11120e),
                                        fontWeight: FontWeight.normal),
                                  ),

                                ),
                              ),
                              SizedBox(
                                height:30,
                                child: ListTile(
                                  title: Text(
                                    "TawasolService.msisdn".tr().toString()+":"+MobileNumber,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff11120e),
                                        fontWeight: FontWeight.normal),
                                  ),

                                ),
                              ),
                              SizedBox(
                                height:30,
                                child: ListTile(
                                  title: Text(
                                    "TawasolService.Price".tr().toString()+":"+Price,
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color(0xff11120e),
                                        fontWeight: FontWeight.normal),
                                  ),

                                ),
                              ),



                              SizedBox(height: 20),


                            ]
                        )

                ),
              ],
            ),
          ):     Container()


        ]),
      ),
    );
  }
}
