import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Activate/Activate_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Activate/Activate_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Activate/Activate_events.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:shared_preferences/shared_preferences.dart';




class Activate extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  Activate({this.Permessions,this.role,this.outDoorUserName});
  Map data = new Map();
  bool enableMsisdn;
  String  preMSISDN;
  @override
  _ActivateState createState() => _ActivateState(this.Permessions,this.role,this.outDoorUserName);
}

class _ActivateState extends State<Activate> {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _ActivateState(this.Permessions,this.role,this.outDoorUserName);
  bool enableMsisdn;
  String  preMSISDN;

  bool emptymsisdn = false;
  bool emptysimNumber = false;
  bool emptyPUK = false;

  bool errormsisdn = false;
  bool errorsimNumber = false;
  bool errorPUK=false;

  ActivateBloc activateBloc;

  TextEditingController msisdn = TextEditingController();
  TextEditingController simNumber = TextEditingController();
  TextEditingController puk = TextEditingController();

  @override
  void initState() {
    super.initState();
    activateBloc = BlocProvider.of<ActivateBloc>(context);
    if(enableMsisdn==false){
      setState(() {
        msisdn.text=preMSISDN;
      });

    }

  }

  final msg = BlocBuilder<ActivateBloc,
      ActivateState>(builder: (context, state) {
    if (state is ActivateLoadingState) {
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
              hintText: "Menu_Form.(079) 0000 000".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }

  Widget SIMCardNumber () {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.SIM_Card_Number".tr().toString(),
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
            controller: simNumber,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptysimNumber== true || errorsimNumber==true
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
              hintText: "Menu_Form.(8996201100) 0000 00000".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }

  Widget PUK() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.PUK".tr().toString(),
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
            controller: puk,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyPUK== true
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
              hintText: "Menu_Form.Enter_PUK".tr().toString(),
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
        simNumber.clear();
        puk.clear();
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
            "Menu_Form.activate".tr().toString(),
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
                      SIMCardNumber(),
                      emptysimNumber == true
                          ? ReusableRequiredText(
                          text: "Menu_Form.recharge_number_required"
                              .tr()
                              .toString())
                          : Container(),
                      errorsimNumber == true
                          ? ReusableRequiredText(
                          text: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? "Your SIM Card  shoud be start with 8996201100"
                              : "رقم بطاقة SIM يجب أن يبدأ ب 89962011000"): Container(),
                      SizedBox(height: 20),
                      PUK(),
                      emptyPUK == true
                          ? ReusableRequiredText(
                          text: "Menu_Form.recharge_number_required"
                              .tr()
                              .toString())
                          : Container(),

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
              child: BlocListener<ActivateBloc, ActivateState>(
                listener: (context, state) {
                  if (state is ActivateErrorState) {
                    showAlertDialog(
                        context, state.arabicMessage, state.englishMessage);
                  }
                  if (state is ActivateSuccessState) {
                    return showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title:  Text(
                          "TawasolService.activated_successfully".tr().toString(),
                          style: TextStyle(
                              fontSize: 16,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.bold),
                        ),
                        content:  Container(
                          width: double.maxFinite,
                          height: 185,
                          child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                Expanded(
                                    child: ListView(
                                        shrinkWrap: true,
                                        physics: ClampingScrollPhysics(),
                                        children: [
                                          SizedBox(
                                            height:35,
                                            child: ListTile(
                                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                                              title: Text(
                                                "TawasolService.msisdn".tr().toString()+": "+state.msisdn,
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              ),

                                            ),
                                          ),

                                          SizedBox(
                                            height: 35,
                                            child: ListTile(
                                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                                              title: Text(
                                                "TawasolService.kit_code".tr().toString()+" "+state.kitcode,

                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              ),

                                            ),
                                          ),

                                          SizedBox(
                                            height: 35,
                                            child: ListTile(
                                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                                              title: Text(
                                                "TawasolService.password".tr().toString()+": "+state.password,

                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              ),

                                            ),
                                          ),

                                          SizedBox(
                                            height: 38,
                                            child: ListTile(
                                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 3),
                                              title: Text(
                                                "TawasolService.expiryDate".tr().toString()+": "+state.expiryDate,

                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              ),

                                            ),
                                          ),

                                          SizedBox(
                                            height: 35,
                                            child: ListTile(
                                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                                              title: Text(
                                                "TawasolService.iccid".tr().toString()+": "+state.iccid,

                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              ),

                                            ),
                                          ),



                                        ]
                                    )
                                )
                              ]
                          ),
                        ),

                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.of(ctx).pop();
                              showToast(
                                  EasyLocalization.of(context).locale == Locale("en", "US")
                                      ? state.englishMessage
                                      : state.arabicMessage,
                                  context: context,
                                  animation: StyledToastAnimation.scale,
                                  fullWidth: true);

                            },
                            child: Text("TawasolService.OK".tr().toString(),

                              style: TextStyle(
                                color: Color(0xFF4f2565),
                                fontSize: 16,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );

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
                      }else {
                        setState(() {
                          errormsisdn = true;
                          emptymsisdn=false;
                        });
                      }
                    }
                    if (simNumber.text == '') {
                      setState(() {
                        emptysimNumber = true;
                      });
                    }
                    if (simNumber.text != '') {

                        if( simNumber.text.substring(0, 11) == '89962011000'){
                          setState(() {
                            errorsimNumber = false;
                            emptysimNumber=false;
                          });
                        }
                     else{
                        setState(() {
                          errorsimNumber = true;
                          emptysimNumber=false;
                        });
                      }
                    }
                    if (puk.text == '') {
                      setState(() {
                        emptyPUK = true;
                      });
                    }
                    else{
                      setState(() {
                        emptyPUK = false;
                      });
                    }
                    if (msisdn.text != '' && simNumber.text != '' && puk.text != '' &&   simNumber.text.substring(0, 11) == '89962011000' && msisdn.text.length == 10  && msisdn.text.substring(0, 3) == '079' ) {

                      activateBloc.add(
                          ActivatePressed(
                              msisdn: msisdn.text,
                              simNumber: simNumber.text,
                              puk: puk.text));
                    }
                  },

                  child: Text(
                    "Menu_Form.activate".tr().toString(),
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
