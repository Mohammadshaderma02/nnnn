import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPS/SendOTPS_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPS/SendOTPS_events.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPS/SendOTPS_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import 'package:sales_app/blocs/CustomerService/GetEligibleServices/GetEligibleServices_bloc.dart';
import 'package:sales_app/blocs/CustomerService/GetEligibleServices/GetEligibleServices_events.dart';
import 'package:sales_app/blocs/CustomerService/GetEligibleServices/GetEligibleServices_state.dart';

import 'package:sales_app/blocs/CustomerService/AddRemoveService/AddRemoveService_bloc.dart';
import 'package:sales_app/blocs/CustomerService/AddRemoveService/AddRemoveService_state.dart';
import 'package:sales_app/blocs/CustomerService/AddRemoveService/AddRemoveService_events.dart';

import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_state.dart';
import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_events.dart';

import 'package:sales_app/blocs/CustomerService/VerifyOTPS/VerifyOTPS_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPS/VerifyOTPS_state.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPS/VerifyOTPS_events.dart';

import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';

class Service extends StatefulWidget {
  final String numberService;
  const Service(this.numberService);
  @override
  _BuyState createState() => _BuyState();
}

class _BuyState extends State<Service> {
  TextEditingController otp = TextEditingController();
  GetEligibleServicesBloc getEligibleServicesBloc;
  AddRemoveServiceBloc addRemoveServiceBloc;
  SendOTPSBloc sendOTPSBloc;
  VerifyOTPSBloc verifyOTPSBloc;
  List<dynamic> NumberTypeList = [];
  String numberService;
  String serviceId;
  bool showCircular = false;
  int actionType;
  String StringaActionType;
  int servicePrice;
  int servicePriceAmmount;
  String StringaservicePrice;
  var response ;
  String msgA;
  String msgE;


  @override
  void initState() {
    super.initState();
    getEligibleServicesBloc = BlocProvider.of<GetEligibleServicesBloc>(context);
    getEligibleServicesBloc.add(GetEligibleServicesFetchEvent(msisdn: widget.numberService));

    addRemoveServiceBloc = BlocProvider.of<AddRemoveServiceBloc>(context);
    sendOTPSBloc = BlocProvider.of<SendOTPSBloc>(context);
    verifyOTPSBloc = BlocProvider.of<VerifyOTPSBloc>(context);
  }

  final msg = BlocBuilder<GetEligibleServicesBloc, GetEligibleServicesState>(
      builder: (context, state) {
    if (state is GetEligibleServicesLoadingState) {
      return Center(
          child: Container(
        padding: EdgeInsets.only(bottom: 10),
           child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
        ),
      ));
    } else {
      return Container();
    }
  });

  final msgTwo = BlocBuilder<AddRemoveServiceBloc, AddRemoveServiceState>(
      builder: (context, state) {
    if (state is AddRemoveServiceLoadingState) {
      return Center(
          child: Container(
        padding: EdgeInsets.only(bottom: 0,top: 20),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
        ),
      ));
    } else {
      return Container();
    }
  });

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

  showAlertDialogVerifyTwo(BuildContext context, arabicMessage, englishMessage) {
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

  showAlertDialogAddRemoveService(
      BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        otp.clear();
        Navigator.of(context).pop();
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
    return BlocListener<SendOTPSBloc, SendOTPSState>(
        listener: (context, state) {
          if (state is SendOTPSErrorState) {
            showAlertDialog(context, state.arabicMessage, state.englishMessage);
          }
          if (state is SendOTPSSuccessState) {
            showToast(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? state.englishMessage
                    : state.arabicMessage,
                context: context,
                animation: StyledToastAnimation.scale,
                fullWidth: true);
            return showDialog(
              context: context,
              barrierDismissible: false,
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
                                  //SizedBox(height: 10),
                                  SizedBox(
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
                      Navigator.of(context).pop();
                    },
                    child: Text(
                      "CustomerService.Cancel".tr().toString(),
                      style: TextStyle(
                        color: Color(0xFF4f2565),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  BlocListener<VerifyOTPSBloc, VerifyOTPSState>(
                    listener: (context, state) {
                      if(state is VerifyOTPSLoadingState){
                        setState(() {
                          showCircular=true;
                        });
                      }
                      if (state is VerifyOTPSErrorState) {
                        setState(() {
                          showCircular=false;
                        });

                        showAlertDialogVerifyTwo(
                            context, state.arabicMessage, state.englishMessage);
                      }
                      if (state is VerifyOTPSSuccessState) {
                        setState(() {
                          showCircular=false;
                        });
                        Navigator.of(context).pop();
                        addRemoveServiceBloc.add(AddRemoveServicePressed(
                            msisdn: widget.numberService,
                            serviceId: serviceId,
                            actionType: StringaActionType));
                      }
                    },
                    child: TextButton(
                      onPressed: () {
                        verifyOTPSBloc.add(VerifyOTPSPressed(
                            msisdn: widget.numberService, otp: otp.text));

                      },
                      child: Text(
                        "CustomerService.verify".tr().toString(),
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
                  "CustomerService.Services".tr().toString(),
                ),
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body: ListView(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 8),
                  children: <Widget>[
                    BlocBuilder<GetEligibleServicesBloc,
                        GetEligibleServicesState>(builder: (context, state) {
                      if (state is GetEligibleServicesErrorState) {
                        return Container(
                          height:50,
                          color: Colors.white,
                          padding:
                          EdgeInsets.only(left: 15, right: 10, top: 15, bottom: 8),
                          //margin: EdgeInsets.only(top: 20),
                          child: Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ?state.englishMessage
                                : state.arabicMessage,
                            style: TextStyle(
                              color: Colors.black,
                              fontSize: 16,
                            ),
                          ),
                        );


                      }

                      // ignore: missing_return
                      if (state is GetEligibleServicesLoadingState) {
                        return Center(
                            child: Container(
                          padding: EdgeInsets.only(bottom: 10),
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
                          ),
                        ));
                      } else if (state is GetEligibleServicesInitState) {
                        return Container();
                      } else if (state is GetEligibleServicesSuccessState) {
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: state.data.length,
                            itemBuilder: (context, index) {
                              return Container(
                                color: Colors.white,
                                child: Column(children: [
                                  SizedBox(
                                    height: 60,
                                    child: ListTile(

                                      title: Text(
                                        EasyLocalization.of(context).locale ==
                                                Locale("en", "US")
                                            ? state.data[index]
                                                ['englishDescription']
                                            : state.data[index]
                                                ['arabicDescription'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff11120e),
                                            fontWeight: FontWeight.normal),
                                      ),
                                      trailing: GestureDetector(
                                          child: BlocListener<
                                              AddRemoveServiceBloc,
                                              AddRemoveServiceState>(
                                        listener: (context, state) {
                                          if (state
                                              is AddRemoveServiceErrorState) {
                                            print("TESTING");
                                            showAlertDialogAddRemoveService(
                                                context,
                                                state.arabicMessage,
                                                state.englishMessage);
                                          }

                                          if (state
                                              is AddRemoveServiceSuccessState) {
                                            showToast(
                                                EasyLocalization.of(context)
                                                            .locale ==
                                                        Locale("en", "US")
                                                    ? state.englishMessage
                                                    : state.arabicMessage,
                                                context: context,
                                                animation:
                                                    StyledToastAnimation.scale,
                                                fullWidth: true);
                                          }
                                        },
                                            child: Container(
                                              child: GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  numberService =
                                                      widget.numberService;
                                                });
                                              print(numberService);

                                              setState(() {
                                                serviceId = state.data[index]
                                                    ['serviceId'];
                                              });
                                              print(serviceId);

                                              setState(() {
                                                actionType = state.data[index]
                                                    ['actionType'];
                                                servicePrice=state.data[index]
                                                ['servicePrice'];
                                              });

                                              print(actionType);
                                              print(servicePrice);

                                              setState(() {
                                                StringaActionType =
                                                    actionType.toString();
                                                StringaservicePrice=servicePrice.toString();
                                              });
                                              print(StringaActionType);
                                              print(StringaservicePrice);



                                              actionType == 1
                                                  ? showDialog(
                                                      context: context,
                                                      builder: (context) =>
                                                          AlertDialog(
                                                            content:  Text(
                                                              EasyLocalization.of(context).locale == Locale("en", "US")
                                                                  ? 'Are you sure you want to ' +state.data[index]
                                                              ['englishDescription'] + ' for ' + numberService +(StringaservicePrice == '0' ?(''):(' Service Price '+StringaservicePrice+" J.D")) +' ?'
                                                                  :"هل أنت متأكد من  " +state.data[index]
                                                              ['arabicDescription']+ ' للرقم ' + numberService + (StringaservicePrice == '0' ?(''):(' سعر الخدمة '+StringaservicePrice+" أ.د"))+' ؟',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(context)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "CustomerService.Cancel"
                                                                  .tr()
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF4f2565),
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                            TextButton(
                                                              onPressed: () {
                                                                Navigator.of(context) .pop();
                                                                sendOTPSBloc.add(
                                                                    SendOTPSPressed(
                                                                        msisdn: widget
                                                                            .numberService));
                                                              },
                                                              child: Text(
                                                                "CustomerService.OK"
                                                                    .tr()
                                                                    .toString(),
                                                                style: TextStyle(
                                                                  color: Color(
                                                                      0xFF4f2565),
                                                                  fontSize: 16,
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                    )
                                                  : showDialog(
                                                      context: context,
                                                      builder: (ctx) =>
                                                          AlertDialog(
                                                        content:  Text(
                                                          EasyLocalization.of(context).locale == Locale("en", "US")
                                                              ? 'Are you sure you want to ' +state.data[index]
                                                          ['englishDescription'] + ' for ' + numberService + ' ?'
                                                              :"هل أنت متأكد من  " +state.data[index]
                                                          ['arabicDescription']+ ' ل ' + numberService + ' ؟',
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        actions: <Widget>[
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();
                                                            },
                                                            child: Text(
                                                              "CustomerService.Cancel"
                                                                  .tr()
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF4f2565),
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                          TextButton(
                                                            onPressed: () {
                                                              Navigator.of(ctx)
                                                                  .pop();

                                                              sendOTPSBloc.add(
                                                                  SendOTPSPressed(
                                                                      msisdn: widget
                                                                          .numberService));
                                                            },
                                                            child: Text(
                                                              "CustomerService.OK"
                                                                  .tr()
                                                                  .toString(),
                                                              style: TextStyle(
                                                                color: Color(
                                                                    0xFF4f2565),
                                                                fontSize: 16,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                            },
                                            child: new Text(
                                              "TawasolService.Select"
                                                  .tr()
                                                  .toString(),
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  color: Color(0xff0070c9),
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                        ),
                                      )),
                                    ),
                                  ),
                                    index!= state.data.length-1 ?
                                    Divider(
                                      thickness: 1,
                                      color: Color(0xFFedeff3),
                                    ):Container(),

                                ]),
                              );
                            });
                      } else {}
                      return Container();
                    }),




                  ])),
        ));
  }
}

