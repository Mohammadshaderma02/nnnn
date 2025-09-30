import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/Recharge/DirectRecharge/DirectRecharge_bloc.dart';
import 'package:sales_app/blocs/Recharge/DirectRecharge/DirectRecharge_state.dart';
import 'package:sales_app/blocs/Recharge/DirectRecharge/DirectRecharge_events.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
class DirectRecharge extends StatefulWidget {
  bool enableMsisdn;
  String  preMSISDN;
  DirectRecharge(this.enableMsisdn,this.preMSISDN);
  @override
  _DirectRechargeState createState() => _DirectRechargeState(this.enableMsisdn,this.preMSISDN);
}

class _DirectRechargeState extends State<DirectRecharge> {
  bool enableMsisdn;
  String  preMSISDN;
  _DirectRechargeState(this.enableMsisdn,this.preMSISDN);
  bool emptymsisdn = false;
  bool emptyRechargeNumbers = false;
  bool errormsisdn = false;
  bool errorRechargeNumbers=false;

  DirectRechargeBloc directrechargeBloc;

  TextEditingController msisdn = TextEditingController();
  TextEditingController rechargenumbers = TextEditingController();

  @override
  void initState() {
    super.initState();
    directrechargeBloc = BlocProvider.of<DirectRechargeBloc>(context);
    if(enableMsisdn==false){
      setState(() {
        msisdn.text=preMSISDN;
      });

    }

  }

  final msg = BlocBuilder<DirectRechargeBloc,
      DirectRechargeState>(builder: (context, state) {
    if (state is DirectRechargeLoadingState) {
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
          child:  enableMsisdn== true?TextField(
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: msisdn,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptymsisdn || errormsisdn == true
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

          ):
          TextField(
            enabled: false,
            maxLength: 10,
            controller: msisdn,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e),
            ),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),

              hintText: "Menu_Form.(079) 0000 000".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          )
          ,
        ),
      ],
    );
  }

  Widget rechargeNumbers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.recharge_number".tr().toString(),
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
            controller: rechargenumbers,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyRechargeNumbers== true || errorRechargeNumbers==true
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
              hintText: "Menu_Form.enter_recharge_number".tr().toString(),
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
        rechargenumbers.clear();
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
            "Menu_Form.direct_recharge".tr().toString(),
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
                          text: "Menu_Form.msisdn_required".tr().toString())
                          : Container(),
                      errormsisdn == true
                          ? ReusableRequiredText(
                          text: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? "Your MSISID shoud be 10 digits and start with 079"
                              : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),
                      SizedBox(height: 20),
                      rechargeNumbers(),
                      emptyRechargeNumbers == true
                          ? ReusableRequiredText(
                          text: "Menu_Form.recharge_number_required"
                              .tr()
                              .toString())
                          : Container(),
                      errorRechargeNumbers == true
                          ? ReusableRequiredText(
                          text: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? "Your Recharge Numbers shoud be 14 digits "
                              : "رقم الشحن يجب أن يتكون من 14 رقمًا"): Container(),
                      SizedBox(height: 20),
                      SizedBox(height: 25),
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
              child: BlocListener<DirectRechargeBloc,
                  DirectRechargeState>(
                listener: (context, state) {
                  if (state is DirectRechargeErrorState) {
                    showAlertDialog(
                        context, state.arabicMessage, state.englishMessage);
                  }

                  if (state is DirectRechargeSuccessState) {
                    showToast(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? state.englishMessage
                            : state.arabicMessage,
                        context: context,
                        animation: StyledToastAnimation.scale,
                        fullWidth: true);

                    Navigator.pop(context);
                  }
                },
                child: TextButton(

                  style: TextButton.styleFrom(
                    backgroundColor:Color(0xFF4f2565),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  onPressed: () {

                    FocusScope.of(context).unfocus();
                    print(msisdn.text.length);
                    if (msisdn.text == '') {
                      setState(() {
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
                        else {
                          setState(() {
                            errormsisdn = true;
                            emptymsisdn=false;
                          });
                        }
                      }else{
                        setState(() {
                          errormsisdn = true;
                          emptymsisdn=false;
                        });
                      }
                    }
                    if (rechargenumbers.text == '') {
                      setState(() {
                        emptyRechargeNumbers = true;
                      });
                    }
                    if (rechargenumbers.text != '') {
                      if(rechargenumbers.text.length == 14 ){
                        setState(() {
                          errorRechargeNumbers = false;
                          emptyRechargeNumbers=false;
                        });
                      }else{
                        setState(() {
                          errorRechargeNumbers = true;
                          emptyRechargeNumbers=false;
                        });
                      }
                    }
                  if (msisdn.text != '' && rechargenumbers.text != '' && msisdn.text.length == 10 && msisdn.text.substring(0, 3) == '079' &&rechargenumbers.text.length==14) {
                      directrechargeBloc.add(
                          DirectRechargePressed(
                              msisdn: msisdn.text,
                              hrn: rechargenumbers.text));
                    }
                  },

                  child: Text(
                    "Menu_Form.submit".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
          )),

          SizedBox(height: 20),

        ]),
      ),
    );
  }
}
