import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sales_app/blocs/Recharge/RechargeDenomination/RechargeType/RechargeType_state.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/RechargeType/RechargeType_bloc.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/RechargeType/RechargeType_events.dart';

import 'package:sales_app/blocs/Recharge/RechargeDenomination/VoucherAmount/VoucherAmount_state.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/VoucherAmount/VoucherAmount_bloc.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/VoucherAmount/VoucherAmount_events.dart';

import 'package:sales_app/blocs/Recharge/RechargeDenomination/SubmitRechargeDenomination/SubmitRechargeDenomination_state.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/SubmitRechargeDenomination/SubmitRechargeDenomination_bloc.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/SubmitRechargeDenomination/SubmitRechargeDenomination_events.dart';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recharge/Recharge.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class RechargeDenomination extends StatefulWidget {
  Map data = new Map();

  final bool enableMsisdn;
  final String  preMSISDN;
  RechargeDenomination(this.enableMsisdn,this.preMSISDN);

  @override
  _RechargeDenominationState createState() => _RechargeDenominationState(this.enableMsisdn,this.preMSISDN);
}

class Item {
  const Item(this.value, this.textEn, this.textAr);
  final String value;
  final String textEn;
  final String textAr;
}

class ItemAmount {
  const ItemAmount(this.key, this.value, this.deductionWallet);
  final String key;
  final String value;
  final String deductionWallet;
}

List<Item> RechargeType = <Item>[];
List<ItemAmount> VoucherAmount = <ItemAmount>[];

class _RechargeDenominationState extends State<RechargeDenomination> {
  Map data = new Map();
   bool enableMsisdn;
   String  preMSISDN;
  _RechargeDenominationState(this.enableMsisdn,this.preMSISDN);
  bool emptymsisdn = false;
  bool errormsisdn = false;
  bool emptyVoucherAmount = false;
  bool checkEmptymsisdn = false;
  bool checkRechargeType = false;
  bool checkVoucherAmount = false;
  bool checkToast = false;

  TextEditingController msisdn = TextEditingController();

  FocusNode msisdnFocusNode;
  String selectedRechargeType;
  String selectedVoucherAmount;

  RechargeTypeBloc rechargetypeBloc;
  VoucherAmountBloc voucheramountBloc;
  SubmitRechargeDenominationBloc submitrechargedenominationBloc;
  @override
  void initState() {
    super.initState();
    submitrechargedenominationBloc = BlocProvider.of<SubmitRechargeDenominationBloc>(context);

    msisdnFocusNode = FocusNode();
    if(enableMsisdn==false){
      setState(() {
        msisdn.text=preMSISDN;
      });
      rechargetypeBloc = BlocProvider.of<RechargeTypeBloc>(context);
      rechargetypeBloc.add(RechargeTypeFetchEvent());
    }
  }
  final msg = BlocBuilder<SubmitRechargeDenominationBloc,
      SubmitRechargeDenominationState>(
      builder: (context, state) {
    if (state is SubmitRechargeDenominationLoadingState  ) {
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
    msisdnFocusNode.dispose();
  }

  String value = "";
  List<String> haya = [];
  Widget buildMSISDN() {
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
          height: 58,
          child: Container(
            child: enableMsisdn==true? TextField(
              maxLength: 10,
              buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
              controller: msisdn,
              onChanged: (val) {
                if(val.length==10){
                  rechargetypeBloc.add(RechargeTypeFetchEvent());

                }},
              keyboardType: TextInputType.phone,
              style: TextStyle(
                color: Color(0xff11120e),
              ),
              decoration: InputDecoration(
                enabledBorder: checkEmptymsisdn == true||errormsisdn==true
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
              maxLength: 10,
              buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
              enabled: false,
              controller: msisdn,
              focusNode: msisdnFocusNode,
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

                hintText: "Menu_Form.enter_msisdn".tr().toString(),
                hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
              ),
            )
            ,
          ),
        ),
      ],
    );
  }
  Widget buildrechargeType() {
    rechargetypeBloc = BlocProvider.of<RechargeTypeBloc>(context);
   // rechargetypeBloc.add(RechargeTypeFetchEvent());
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "Menu_Form.recharge_type".tr().toString(),
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
          BlocBuilder<RechargeTypeBloc, RechargeTypeState>(
              builder: (context, state) {
                RechargeType = [];
               if (state is RechargeTypeLoadingState ||
                state is RechargeTypeInitState ||
                state is RechargeTypeSuccessState || state is RechargeTypeErrorState) {
              if (state is RechargeTypeSuccessState) {
                  for (var obj in state.data) {
                    RechargeType.add(Item(obj['key'], obj['value'].toString(),
                        obj['valueAr'].toString()));
                  emptyVoucherAmount = true;
                }
              }}
              return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      //color: Color(0xFFB10000), red color
                      color:checkRechargeType == true
                          ? Color(0xFFB10000)
                          : Color(0xFFD1D7E0),
                    ),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: ButtonTheme(
                      alignedDropdown: true,
                      child: DropdownButton<String>(
                        hint: Text(
                          "Personal_Info_Edit.select_an_option".tr().toString(),
                          style: TextStyle(
                            color: Color(0xFFA4B0C1),
                            fontSize: 14,
                          ),
                        ),
                        disabledHint: Text(
                          "Menu_Form.enter_msisdn".tr().toString(),
                          style: TextStyle(
                            color: Color(0xFFA4B0C1),
                            fontSize: 14,
                          ),
                        ),
                        dropdownColor: Colors.white,
                        icon: Icon(Icons.keyboard_arrow_down_rounded),
                        iconSize: 30,
                        iconEnabledColor: Colors.grey,
                        underline: SizedBox(),
                        isExpanded: true,
                        style: TextStyle(
                          color: Color(0xff11120e),
                          fontSize: 14,
                        ),
                        items: RechargeType.map((valueItem) {
                          return DropdownMenuItem<String>(
                            value: valueItem.value,
                            child: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                ? Text(valueItem.textEn)
                                : Text(valueItem.textAr),
                          );
                        }).toList(),
                        value: selectedRechargeType,
                        onChanged: (String newValue) {
                          setState(() {
                            selectedRechargeType = newValue;
                            voucheramountBloc .add(VoucherAmountFetchEvent(msisdn.text, selectedRechargeType));
                          });
                        },
                      ),
                    ),
                  ));
            },
          ),
          SizedBox(height: 10),
        ]);
  }
  Widget buildvoucherAmount() {
    voucheramountBloc = BlocProvider.of<VoucherAmountBloc>(context);
   // voucheramountBloc .add(VoucherAmountFetchEvent(msisdn.text, selectedRechargeType));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.voucher_amount".tr().toString(),
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
        BlocBuilder<VoucherAmountBloc, VoucherAmountState>(

            builder: (context, state) {
              VoucherAmount = [];
          if (state is VoucherAmountLoadingState ||
              state is VoucherAmountInitState ||
              state is VoucherAmountSuccessState || state is VoucherAmountErrorState) {
            if (state is VoucherAmountSuccessState) {
                for (var obj in state.data) {
                VoucherAmount.add(ItemAmount(
                   obj['deductionAmount'] , obj['deductionAmount'].toString(),
                    obj['deductionWallet'].toString())
                );
                }
                }
            }
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: checkVoucherAmount == true
                        ? Color(0xFFB10000)
                        : Color(0xFFD1D7E0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      hint: Text(
                        "Personal_Info_Edit.select_an_option".tr().toString(),
                        style: TextStyle(
                          color: Color(0xFFA4B0C1),
                          fontSize: 14,
                        ),
                      ),
                      disabledHint: Text(
                        "Menu_Form.select_recharge_type".tr().toString(),
                        style: TextStyle(
                          color: Color(0xFFA4B0C1),
                          fontSize: 14,
                        ),
                      ),
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      iconSize: 30,
                      iconEnabledColor: Colors.grey,
                      underline: SizedBox(),
                      isExpanded: true,
                      style: TextStyle(
                        color: Color(0xff11120e),
                        fontSize: 14,
                      ),
                      items: VoucherAmount.map((valueItemm) {
                        return DropdownMenuItem<String>(
                          value: valueItemm.value +","+ valueItemm.deductionWallet,
                          child: Text(valueItemm.value)
                        );
                      }).toList(),
                      value: selectedVoucherAmount,
                      onChanged: (String newValue) {
                        setState(() {
                          selectedVoucherAmount = newValue;

                        });
                      },
                    ),
                  ),
                ));
          }
        ),
        SizedBox(height: 10),
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
        setState(() {
          selectedRechargeType =null;
          selectedVoucherAmount =null;
        });
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
    return BlocListener<SubmitRechargeDenominationBloc,
        SubmitRechargeDenominationState>(
      listener: (context, state) {

        if (state is SubmitRechargeDenominationErrorState) {
          showAlertDialog(
              context, state.arabicMessage, state.englishMessage);
        }
        if (state is SubmitRechargeDenominationSuccessState) {
          Navigator.pop(context);
          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? state.englishMessage
                  : state.arabicMessage,
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);
        }

      },
      child: GestureDetector(
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
              "Menu_Form.recharge_denomination".tr().toString(),
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
                        buildMSISDN(),
                        checkEmptymsisdn == true
                            ? ReusableRequiredText(
                                text: "Basic_Info_Edit.this_feild_is_required"
                                    .tr()
                                    .toString())
                            : Container(),
                        errormsisdn == true
                            ? ReusableRequiredText(
                                text: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                    ? "Your MSISID shoud be 10 digit and start with 079"
                                    : "رقم الهاتف يجب أن يتكون من 10 خانات ويبدأ ب 079")
                            : Container(),
                        SizedBox(height: 20),
                        buildrechargeType(),
                        checkRechargeType == true
                            ? ReusableRequiredText(
                                text: "Basic_Info_Edit.this_feild_is_required"
                                    .tr()
                                    .toString())
                            : Container(),
                        SizedBox(height: 20),
                        buildvoucherAmount(),
                        checkVoucherAmount == true
                            ? ReusableRequiredText(
                                text: "Basic_Info_Edit.this_feild_is_required"
                                    .tr()
                                    .toString())
                            : Container(),
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
                          checkEmptymsisdn = true;
                        });
                      }
                      if (msisdn.text != '') {
                        setState(() {
                          checkEmptymsisdn = false;
                        });
                        if (msisdn.text.length != 10 ||
                            msisdn.text.substring(0, 3) != '079') {
                          setState(() {
                            errormsisdn = true;
                          });
                        }else{
                          setState(() {
                            errormsisdn = false;
                          });
                        }


                      }
                      if (selectedRechargeType == null) {
                        setState(() {
                          checkRechargeType = true;
                        });
                      }
                      if (selectedRechargeType != null) {
                        setState(() {
                          checkRechargeType = false;
                        });
                      }

                      if (selectedVoucherAmount == null) {
                        setState(() {
                          checkVoucherAmount = true;
                        });
                      }
                      if (selectedVoucherAmount != null) {
                        setState(() {
                          checkVoucherAmount = false;
                        });
                      }

                      if (msisdn.text != '' &&
                          selectedRechargeType != null &&
                          selectedVoucherAmount != null) {
                        var array=selectedVoucherAmount.split(",");
                        var amount=array[0];
                        submitrechargedenominationBloc.add(
                            SubmitRechargeDenominationPressed(
                                bPartyMSISDN: msisdn.text,
                                rechargeAmount: amount,
                                voucherType: selectedRechargeType));
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
                ),
            SizedBox(height: 20),

          ]),
        ),
      ),
    );
  }
}
