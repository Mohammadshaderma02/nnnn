import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_state.dart';
import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_events.dart';


import 'package:sales_app/blocs/CustomerService/VerifyOTP/VerifyOTP_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTP/VerifyOTP_state.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTP/VerifyOTP_events.dart';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/CustomerService/Service.dart';

import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';



class CheckOTP extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  CheckOTP({this.Permessions,this.role,this.outDoorUserName});
  @override
  _PosNetOfferState createState() => _PosNetOfferState(this.Permessions,this.role,this.outDoorUserName);
}

class _PosNetOfferState extends State<CheckOTP> {
  String numberService;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _PosNetOfferState(this.Permessions,this.role,this.outDoorUserName);
  bool emptyMAISDN = false;
  bool showCircular = false;
  var response ;
  bool errorMAISDN = false;
  String ActivePackageArabic ;
  String ActivePackageEnglish ;

  bool NoActiveFlag =false;
  List<dynamic> data ;
  var lengthOfData;

  TextEditingController msisdn = TextEditingController();
  TextEditingController otp = TextEditingController();

  SendOTPBloc sendOTPBloc;
  VerifyOTPBloc verifyOTPBloc;


  @override
  void initState() {
    super.initState();
    super.initState();

    sendOTPBloc = BlocProvider.of<SendOTPBloc>(context);
    verifyOTPBloc = BlocProvider.of<VerifyOTPBloc>(context);


  }
  final msg = BlocBuilder<SendOTPBloc, SendOTPState>(builder: (context, state) {
    if (state is SendOTPLoadingState) {

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


  final msgTwo = BlocBuilder<VerifyOTPBloc, VerifyOTPState>(builder: (context, state) {
    if (state is VerifyOTPLoadingState ) {
      return Center(child: Container(
        padding: EdgeInsets.only(bottom: 0,top: 20),
        child: Container(
          child: CircularProgressIndicator(
            valueColor:AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
          ),
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
            controller: msisdn,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMAISDN== true || errorMAISDN==true
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
              hintText: "Menu_Form.(079) 0000 000".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }


  showAlertDialogVerify(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
       // Navigator.of(context).pop();
        Navigator.pop(context, true);
       // Navigator.pop(context, true);
        otp.clear();
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
       // Navigator.of(context).pop();
        Navigator.pop(context, true);
        msisdn.clear();
        otp.clear();

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
    return BlocListener<SendOTPBloc, SendOTPState>(
        listener: (context, state) {
          if (state is SendOTPErrorState) {
            showAlertDialog(context, state.arabicMessage, state.englishMessage);
          }
          if (state is SendOTPSuccessState) {
            showToast(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? state.englishMessage
                    : state.arabicMessage,
                context: context,
                animation: StyledToastAnimation.scale,
                fullWidth: true);
                return showDialog(

                  barrierDismissible: false,
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text("CustomerService.verify_code".tr().toString(),
                      style: TextStyle(
                        color: Color(0xff11120e),
                        fontSize: 16,
                      ),
                    ),
                    content: Container(
                      width: double.maxFinite,
                      height:  showCircular ? 170 :110,
                      child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            Expanded(
                                child: ListView(
                                  // shrinkWrap: false,
                                    physics: const NeverScrollableScrollPhysics(),
                                    children: [

                                      SizedBox(
                                        width: double.maxFinite,
                                        height: 50,
                                        child: ListTile(
                                          contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                                          title: Text("CustomerService.enter_OTP".tr().toString(),
                                            style: TextStyle(
                                              color: Color(0xff11120e),
                                              fontSize: 16,


                                            ),
                                          ),

                                        ),
                                      ),
                                      SizedBox(
                                        height: 50,
                                        child: ListTile(
                                          contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 4),
                                          title:
                                          TextField(
                                            controller: otp,
                                            keyboardType: TextInputType.phone,
                                            decoration:InputDecoration(
                                              enabledBorder: const OutlineInputBorder(
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
                                              hintText: "CustomerService.verify_hint".tr().toString(),
                                              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),

                                            ),
                                          ),


                                        ),
                                      ),

                                      msgTwo
                                    ]
                                )
                            )
                          ]
                      ),
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          msisdn.clear();
                         // Navigator.of(context).pop();
                          Navigator.pop(context, true);

                        },
                        child:  Text("CustomerService.Cancel".tr().toString(),
                          style: TextStyle(
                            color: Color(0xFF4f2565),
                            fontSize: 16,
                          ),
                        ),

                      ),
                      BlocListener<VerifyOTPBloc, VerifyOTPState>(
                        listener: (context,state){
                          if(state is VerifyOTPLoadingState){
                            setState(() {
                              showCircular=true;
                            });
                          }
                          if (state is VerifyOTPErrorState) {
                            setState(() {
                              showCircular=false;
                            });
                            showAlertDialogVerify(context, state.arabicMessage, state.englishMessage);


                           // Navigator.of(context).pop();
                          }
                          if (state is VerifyOTPSuccessState) {
                            print("haya");
                            setState(() {
                              showCircular=false;
                            });
                            //Navigator.of(context).pop();
                           Navigator.pop(context, true);
                            Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Service(numberService)));
                           }
                        },
                        child:TextButton(
                          onPressed: () {
                           // Navigator.of(ctx).pop();
                            verifyOTPBloc.add(VerifyOTPPressed(msisdn:msisdn.text, otp: otp.text));
                            //Navigator.of(ctx).pop();
                            setState(() {
                              response=1;});
                          },
                          child:  Text("CustomerService.verify".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF4f2565),
                              fontSize: 16,
                            ),
                          ),

                        ),
                      ),

                    ],
                  ),
                );
              }
            },
        child:  GestureDetector(
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
                "CustomerService.Customer_Service".tr().toString(),
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
                          emptyMAISDN == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.serial_numbe_required"
                                  .tr()
                                  .toString())
                              : Container(),
                          errorMAISDN == true
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

                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:Color(0xFF4f2565),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (msisdn.text == '') {
                      setState(() {
                        errorMAISDN = false;
                        emptyMAISDN = true;
                      });
                    }
                    if (msisdn.text != '') {
                      if(msisdn.text.length == 10 ){
                        if( msisdn.text.substring(0, 3) == '079'){
                          setState(() {
                            errorMAISDN = false;
                            emptyMAISDN=false;
                          });}
                      }else {
                        setState(() {
                          errorMAISDN = true;
                          emptyMAISDN=false;
                        });
                      }
                    }

                    if (msisdn.text != '' && msisdn.text.length == 10 && msisdn.text.substring(0, 3) == '079') {
                      otp.clear();
                      setState(() {
                        numberService=msisdn.text;});

                      print(numberService);
                      sendOTPBloc.add(
                          SendOTPPressed(msisdn:msisdn.text));

                    }
                  },

                  child: Text(
                    "CustomerService.check".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              SizedBox(height: 20),
            ]),
          ),
        )
    );
  }}











