import 'dart:io';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/UpdateLine.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/UpgradePackage/ActiveAndEligiblePackages.dart';
import 'package:sales_app/blocs/CheckMSISDNAssignedSDLR/CheckMSISDNAssignedSDLR_bloc.dart';
import 'package:sales_app/blocs/CheckMSISDNAssignedSDLR/CheckMSISDNAssignedSDLR_state.dart';
import 'package:sales_app/blocs/CheckMSISDNAssignedSDLR/CheckMSISDNAssignedSDLR_events.dart';

import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_events.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_state.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';
import 'package:sales_app/blocs/GetCurrentPackage/getCurrentPackage_bloc.dart';
import 'package:sales_app/blocs/GetCurrentPackage/getCurrentPackage_events.dart';
import 'package:sales_app/blocs/GetCurrentPackage/getCurrentPackage_state.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../CustomBottomNavigationBar.dart';

class EnterMSSIDNumber extends StatefulWidget {
  bool enableMsisdn;
  String  preMSISDN;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;

  EnterMSSIDNumber(this.Permessions,this.role,this.outDoorUserName,this.enableMsisdn,this.preMSISDN);

  @override
  _EnterMSSIDNumberState createState() => _EnterMSSIDNumberState(this.Permessions,this.role,this.outDoorUserName,this.enableMsisdn,this.preMSISDN);
}

class _EnterMSSIDNumberState extends State<EnterMSSIDNumber> {
  bool enableMsisdn;
  bool isLoaading= false;
  String  preMSISDN;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  APP_URLS urls = new APP_URLS();
  _EnterMSSIDNumberState(this.Permessions,this.role,this.outDoorUserName,this.enableMsisdn,this.preMSISDN);
  bool emptymsisdn = false;
  bool errormsisdn = false;
  String arabicName='';
  String englishName='';
  bool showCircular = false;

  GetCurrentPackageBloc getCurrentPackageBloc;
  CheckMSISDNAssignedSDLRBloc checkMSISDNAssignedSDLRBloc;
  VerifyOTPSCheckMSISDNBloc verifyOTPSCheckMSISDNBloc;
  SendOTPSCheckMSISDNBloc sendOTPSCheckMSISDNBloc;
  FocusNode msisdnFocusNode;

  TextEditingController msisdn = TextEditingController();
  TextEditingController otp = TextEditingController();
  @override
  void initState() {
    super.initState();
    getCurrentPackageBloc = BlocProvider.of<GetCurrentPackageBloc>(context);
    checkMSISDNAssignedSDLRBloc = BlocProvider.of<CheckMSISDNAssignedSDLRBloc>(context);
    verifyOTPSCheckMSISDNBloc = BlocProvider.of<VerifyOTPSCheckMSISDNBloc>(context);
    sendOTPSCheckMSISDNBloc = BlocProvider.of<SendOTPSCheckMSISDNBloc>(context);
    msisdnFocusNode = FocusNode();
    if(enableMsisdn==false){
      msisdn.text=preMSISDN;
    }
  }
  @override
  void dispose() {
    super.dispose();
    msisdnFocusNode.dispose();
  }
  CheckMSISDN() async {
    setState(() {
      isLoaading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/Tawasol/sdlr/is-assigned/${msisdn.text}';
    print(url);
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;

    print(statusCode);
    if(statusCode==200 ){
      setState(() {
        isLoaading=false;
      });
      var result = json.decode(response.body);
      print(result);
      if(result['status']==0){
        prefs.setString('UpgradePackageOtp', '0');
       // getCurrentPackageBloc.add(GetCurrentPackageButtonPressed(msisdn.text));
        getCurrentPackege();
      }
      else{

        SendOtp();
       // sendOTPSCheckMSISDNBloc.add(SendOTPSCheckMSISDNPressed(msisdn: msisdn.text));
      }

    }

  }
  getCurrentPackege () async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var otp = prefs.getString('UpgradePackageOtp');
    var url = urls.BASE_URL+'/ChangePackage/current/${msisdn.text}/${otp}';
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    if(statusCode==200 ){
      var result = json.decode(response.body);
      if (result["status"] == 0 && result["data"]['packageID']!='0') {
        setState(() {
          arabicName =result["data"]["englishDescription"];
          englishName=result["data"]["englishDescription"];
        });
        Navigator.of(context).push(MaterialPageRoute(
            builder:(context)=>ActiveAndEligiblePackages(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["data"]["englishDescription"]
                    : result["data"]["englishDescription"],
                msisdn.text,enableMsisdn)));
        setState(() {
          isLoaading=false;

        });
      }

      else if(result["status"] == 0 && result["data"]['packageID']=='0'){

        Navigator.of(context).push(MaterialPageRoute(
            builder:(context)=>ActiveAndEligiblePackages(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'No active packege found'
                    : 'لا يوجد حزم نشطة',msisdn.text,enableMsisdn)));
        setState(() {
          isLoaading=false;
        });
      }
    }
    else if(statusCode==401){
      setState(() {
        isLoaading=false;
      });
      UnotherizedError();
    }
    else {
      setState(() {
        isLoaading=false;
      });
      showAlertDialog(context, 'حدث خطأ ما. أعد المحاولة من فضلك', 'Something went wrong please try again');
    }
  }

  SendOtp() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(urls.BASE_URL+"/OTP/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode( {"msisdn": msisdn.text}), );

    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200 ) {
      var result = json.decode(res.body);
      if(result['status']==0){
        showDialog(
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
              BlocListener<VerifyOTPSCheckMSISDNBloc, VerifyOTPSCheckMSISDNState>(
                listener: (context,state){
                  if(state is VerifyOTPSCheckMSISDNLoadingState){
                    setState(() {
                      showCircular=true;
                    });
                  }
                  if (state is VerifyOTPSCheckMSISDNErrorState) {
                    setState(() {
                      showCircular=false;
                    });
                    setState(() {
                      otp.text='';
                    });
                    showAlertDialogVerify(context, state.arabicMessage, state.englishMessage);
                    // Navigator.of(context).pop();
                  }
                  if (state is VerifyOTPSCheckMSISDNSuccessState) {
                    setState(() {
                      showCircular=false;
                    });
                    //Navigator.of(context).pop();
                    setState(() {
                      otp.text='';
                    });
                    Navigator.pop(context, true);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ActiveAndEligiblePackages(
                    //         EasyLocalization.of(context).locale == Locale("en", "US")
                    //             ? arabicName
                    //             : englishName,msisdn.text,enableMsisdn),
                    //   ),
                    // );
                    //  getCurrentPackageBloc.add(GetCurrentPackageButtonPressed(msisdn.text));
                    getCurrentPackege();
                    // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Service(numberService)));
                  }
                },
                child:TextButton(
                  onPressed: () {
                    // Navigator.of(ctx).pop();
                    verifyOTPSCheckMSISDNBloc.add(VerifyOTPSCheckMSISDNPressed(msisdn:msisdn.text, otp: otp.text));
                    //Navigator.of(ctx).pop();

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
    }
  }
  UnotherizedError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_logged_in', false);
    prefs.setBool('biomitric_is_logged_in', false);
    prefs.setBool('TokenError', true);
    prefs.remove("accessToken");
    //prefs.remove("userName");
    prefs.remove('counter');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }
  Widget MSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        SizedBox(height: 10),
        Container(
          alignment: Alignment.center,
          height: 58,
          child : enableMsisdn==true? TextField(
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: msisdn,
            focusNode: msisdnFocusNode,

            onTap: () {

              setState(() {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(msisdnFocusNode);
              });
            },
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e),
            ),
            decoration: InputDecoration(
              enabledBorder: emptymsisdn  == true || errormsisdn == true
                  ? const OutlineInputBorder(
                borderSide: const BorderSide(
                  color: Color(0xFFB10000), width: 1.0,),
              )
                  : const OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0),
                    width: 1.0),

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
          )
              :
          TextField(
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            enabled: false,
            controller: msisdn,
            focusNode: msisdnFocusNode,
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(msisdnFocusNode);
              });
            },
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
              fillColor: Color(0xFFF3F4F7),
              filled: true,
              contentPadding: EdgeInsets.all(16),
              suffixIcon:IconButton(
                onPressed: (){
                  setState(() {
                    msisdn.text='';
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
          )
          ,
        ),
      ],
    );
  }
  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
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
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
            Navigator.pop(context, true);
          },
          child: Text(
            "alert.tryAgain".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  final msgTwo = BlocBuilder<VerifyOTPSCheckMSISDNBloc, VerifyOTPSCheckMSISDNState>(builder: (context, state) {
    if (state is VerifyOTPSCheckMSISDNLoadingState ) {
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
      // barrierDismissible: false,
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
                  onPressed: () {
                    // enableMsisdn==true? Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => CustomBottomNavigationBar(),
                    //   ),
                    // ):
                    // Navigator.pushReplacement(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => UpdateLine(msisdn.text),
                    //   ),
                    // );
                     Navigator.pop(context);

                  },
                ),
                centerTitle:false,
                title: Text(
                  "Menu_Form.upgrade_Package".tr().toString(),
                ),
                backgroundColor: Color(0xFF4f2565),
              ),
              // backgroundColor: Color(0xFFf3f4f7),
              body: ListView(padding: EdgeInsets.only(top: 10), children: <Widget>[
                Container(
                  // color: Color(0xFFf3f4f7),
                  child: Image(
                      image: AssetImage('assets/images/group-2.png'),
                      width: 184,
                      height: 184),),
                SizedBox(
                  height: 10,
                ),
                Container(
                    height: 48,
                    width: 420,
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    decoration: BoxDecoration(),

                    child: TextButton(
                      child: Text(
                        "Menu_Form.Enter_MSSID_Number".tr().toString(),
                        style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0,
                            fontSize: 21,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
                Container(
                    height: 55,
                    width: 420,
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(),
                    child: TextButton(
                      child: Text(
                        "Menu_Form.Decleration".tr().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(

                          color: Colors.grey,
                          letterSpacing: 0,
                          fontSize: 16,
                        ),
                      ),
                    )),
                Container(
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
                                text:  EasyLocalization.of(context).locale == Locale("en", "US")
                                    ? "Your MSISID shoud be 10 digit and start with 079"
                                    : "رقم الهاتف يجب أن يتكون من 10 خانات ويبدأ ب 079")
                                : Container(),
                            SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 5),
                Container(
                  height: 48,
                  width: 420,
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF4f2565),
                  ),
                  child: TextButton(

                    onPressed: () {
                      if (msisdn.text == '') {
                        setState(() {
                          emptymsisdn = true;
                        });
                      }
                      if(msisdn.text!= ''){
                        setState(() {
                          emptymsisdn = false;
                        });
                        if(msisdn.text.length!=10  || msisdn.text.substring(0,3)!='079'
                        ){
                          setState(() {
                            errormsisdn = true;
                          });
                        }else{
                          // getCurrentPackageBloc.add(GetCurrentPackageButtonPressed(msisdn.text));
                          print('called');
                          CheckMSISDN();
                         // checkMSISDNAssignedSDLRBloc.add(CheckMSISDNAssignedSDLRPressed(msisdn:msisdn.text));
                     }
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:Color(0xFF4f2565),
                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                    ),
                    child: Text(
                      "Menu_Form.Continue".tr().toString(),
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                 isLoaading==true?Container(
                  child: Center(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 10),
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
                        ),
                      ))
                ):Container()

              ]),
            ),
    );






  }
}
