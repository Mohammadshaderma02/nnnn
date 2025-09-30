import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/Recharge/CheckVoucher/CheckVoucher_bloc.dart';
import 'package:sales_app/blocs/Recharge/CheckVoucher/CheckVoucher_states.dart';
import 'package:sales_app/blocs/Recharge/CheckVoucher/CheckVoucher_events.dart';

class Checkvoucher extends StatefulWidget {
  @override
  _CheckvoucherState createState() => _CheckvoucherState();
}

class _CheckvoucherState extends State<Checkvoucher> {

  bool emptyserialNumber = false;
  bool errorserialNumber = false;

  CheckVoucherBloc checkvoucherBloc;

  TextEditingController serialNumber = TextEditingController();


  @override
  void initState() {
    super.initState();
    super.initState();
    checkvoucherBloc = BlocProvider.of<CheckVoucherBloc>(context);

  }
  final msg = BlocBuilder<CheckVoucherBloc,
      CheckVoucherState>(builder: (context, state) {
    if (state is CheckVoucherLoadingState) {
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



  Widget checkVoucherNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.serial_number".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ), children: <TextSpan>[
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
            controller: serialNumber,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyserialNumber  == true
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
              hintText: "Menu_Form.Enter_serial_number".tr().toString(),
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
        serialNumber.clear();
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
            "Menu_Form.check_voucher".tr().toString(),
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
                      checkVoucherNumber(),
                      emptyserialNumber == true
                          ? ReusableRequiredText(
                          text: "Menu_Form.serial_numbe_required"
                              .tr()
                              .toString())
                          : Container(),
                      errorserialNumber == true
                          ? ReusableRequiredText(
                          text: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? "Your Serial Number shoud be 12 digits "
                              : "الرقم المتسلسل يجب أن يتكون من 12 رقمًا"): Container(),

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
              child: BlocListener<CheckVoucherBloc,
                  CheckVoucherState>(
                listener: (context, state) {
                  if (state is CheckVoucherErrorState) {
                    showAlertDialog(
                        context, state.arabicMessage, state.englishMessage);
                  }

                  if (state is CheckVoucherSuccessState) {
                    showAlertDialog(
                        context, state.arabicMessage, state.englishMessage);
                  }
                },
                child: TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor:Color(0xFF4f2565),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    if (serialNumber.text == '') {
                      setState(() {
                        emptyserialNumber = true;
                      });
                    }
                    if (serialNumber.text != '') {
                      setState(() {
                        emptyserialNumber = false;
                      });
                      if(serialNumber.text.length != 12 ){
                        setState(() {
                          errorserialNumber = true;
                        });
                      }
                      if(serialNumber.text.length == 12 ){
                        setState(() {
                          errorserialNumber = false;
                        });
                      }
                    }

                    if (serialNumber.text != '' && serialNumber.text.length == 12) {
                   checkvoucherBloc.add(CheckVoucherPressed(serialNumber: serialNumber.text,
                   ));
                    }
                  },

                  child: Text(
                    "Menu_Form.check".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              )),

        ]),
      ),
    );
  }
}
