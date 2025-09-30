import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/SelectNationlaity.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';



import 'JordanNationality.dart';
import 'UpdateLine.dart';
class LineDocumentation extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  bool  Bulk_Activat;
  LineDocumentation({this.Permessions,this.role,this.outDoorUserName,this.Bulk_Activat});

  @override
  _LineDocumentationState createState() => _LineDocumentationState(this.Permessions,this.role,this.outDoorUserName,this.Bulk_Activat);
}


class _LineDocumentationState extends State<LineDocumentation> {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _LineDocumentationState(this.Permessions,this.role,this.outDoorUserName,this.Bulk_Activat);
  int selectedLanguage = 2;
  bool emptymsisdn = false;
  bool emptyKitCode = false;
  bool errormsisdn = false;

  bool emptyICCID = false;
  bool errorICCID = false;
  String testing ="1";

  TextEditingController msisdn = TextEditingController();
  TextEditingController kitCode = TextEditingController();
  TextEditingController ICCID = TextEditingController();

  ValidateKitCodeRqBloc validateKitCodeRqBloc;

  String _dataKitCode="";

  /********************************New for Bulk*****************************/
  List bulkNumbers;
  bool Bulk_Activat;
  /***********************************************************************/
  bool disableContinue=false;
  @override
  void initState() {
    super.initState();
    validateKitCodeRqBloc = BlocProvider.of<ValidateKitCodeRqBloc>(context);
    print("**********************************************Bulk Activation****************************************************");
    print(Bulk_Activat);
    print("**********************************************Bulk Activation****************************************************");

  }

  @override
  void dispose() {
    super.dispose();
  }

  void clearMSISDN (){
    setState(() {
      msisdn.text='';
    });
  }

  void clearKITCODE (){
    setState(() {
      kitCode.text='';
    });
  }

  void clearICCID (){
    setState(() {
      ICCID.text='';
      testing = "1";
      errorICCID = false;
    });
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
            onTap: () {},
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptymsisdn == true || errormsisdn ==true?
              const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
              ):
              const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              )
              ,
              border: const OutlineInputBorder(),

              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: clearMSISDN,
                icon: Icon(
                    Icons.close
                ),
                color: Color(0xFFA4B0C1),
              ),
              hintText: "Menu_Form.enter_msisdn".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget KitCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.kit_code".tr().toString(),
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
            controller: kitCode,
            keyboardType: TextInputType.phone,
            //readOnly: true,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyKitCode == true ?
              const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
              ):
              const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              )
              ,
              border: const OutlineInputBorder(),

              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),

              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                mainAxisSize: MainAxisSize.min, // added line
                children: <Widget>[
                  IconButton(
                    onPressed: clearKITCODE,
                    icon: Icon(
                        Icons.close
                    ),
                    color: Color(0xFFA4B0C1),
                  ),

                ],
              ),
              hintText: "Menu_Form.enter_kit_code".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }

  Widget _ICCID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Menu_Form.ICCID".tr().toString(),
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
            controller: ICCID,
            maxLength: 20,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            onTap: () {},
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyICCID == true || errorICCID ==true?
              const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
              ):
              const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              )
              ,
              border: const OutlineInputBorder(),

              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: clearICCID,
                icon: Icon(
                    Icons.close
                ),
                color: Color(0xFFA4B0C1),
              ),
              hintText: "Menu_Form.Enter_ICCID".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }



  final msg = BlocBuilder<ValidateKitCodeRqBloc, ValidateKitCodeRqState>(builder: (context, state) {
    if (state is ValidateKitCodeRqLoadingState   ) {
      return Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
            ),
          ));
    } else {
      return Container();
    }
  });
  final msgScan = BlocBuilder<ValidateKitCodeRqBloc, ValidateKitCodeRqState>(builder: (context, state) {
    if (state is ValidateKitCodeRqScanLoadingState) {
      return Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
            ),
          ));
    } else {
      return Container();
    }
  });

  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        setState(() {
          disableContinue=false;
        });
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              disableContinue=false;
              errorICCID = false;
              errormsisdn=false;
            });
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
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
  showAlertDialogScanError(BuildContext context, arabicMessageScan, englishMessageScan) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessageScan
            : arabicMessageScan,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            setState(() {
              errorICCID = false;
              errormsisdn=false;
            });
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
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
  @override
  Widget build(BuildContext context) {
    _ScanKitCode() async{
      await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE).then((value)=>setState(()=>_dataKitCode=value));
      print("haya");
      print(_dataKitCode);
      setState(() {
        ICCID.text = _dataKitCode;
      });
      print("ICCID.text");
      print(ICCID.text.length);
      setState(() {
        testing = "2";
      });
    }
    return BlocListener<ValidateKitCodeRqBloc, ValidateKitCodeRqState>(
      listener: (context, state) {
        if (state is ValidateKitCodeRqErrorState) {
          setState(() {
            disableContinue=false;
          });
          showAlertDialogError(
              context, state.arabicMessage, state.englishMessage);
        }
        if (state is ValidateKitCodeRqErrorScanState) {
          setState(() {
            disableContinue=false;
          });
          showAlertDialogScanError(
              context, state.arabicMessageScan, state.englishMessageScan);
        }
        if(state  is ValidateKitCodeRqTokenErrorState){
          UnotherizedError();
        }
        if (state is ValidateKitCodeRqSuccessState) {
          setState(() {
            disableContinue=false;
          });
          print("ICCID.text");
          print(ICCID.text);
          print("msisdn");
          print(msisdn.text);
          print("kitCode.text");
          print(kitCode.text);

          Permessions.contains('05.01.01.01')?
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectNationality(Permessions,role,outDoorUserName,msisdn.text,kitCode.text,ICCID.text,state.isShahamah,state.displayReference,state.showJordanian,state.showNonJordanian,bulkNumbers,Bulk_Activat),
            ),
          ):null;
        }
        if (state is ValidateKitCodeRqSuccessScanState) {
          print("ICCID.text");
          print(ICCID.text.length);
          print("msisdnScan");
          print(state.msisdn);
          print("kitCode.text");
          print(kitCode.text);

          Permessions.contains('05.01.01.01')?
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SelectNationality(Permessions,role,outDoorUserName,state.msisdn,kitCode.text,ICCID.text,state.isShahamah,state.displayReference,state.showJordanian,state.showNonJordanian,bulkNumbers,Bulk_Activat),
            ),
          ):null;
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
                Navigator.pop(context);
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => PrePaidSales(),
                // ),
                //);

              },
            ),
            centerTitle:false,
            title: Text(
              "Menu_Form.line_documentation".tr().toString(),
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
                    child: Column(
                      children: <Widget>[
                        Image(
                            image: AssetImage('assets/images/barcode-scan.png'),
                            width: 160,
                            height: 160),

                        TextButton(
                          child: Text(
                            "Menu_Form.ScanBarcode".tr().toString(),
                            style: TextStyle(
                                color: Colors.black,
                                letterSpacing: 0,
                                fontSize: 21,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        testing == "1" ?
                        TextButton(
                          child: Text(
                            "Menu_Form.PleaseScanBarcodeOnChargeCard".tr().toString(),
                            textAlign: TextAlign.center,

                          ),
                        ):Container(),

                      ],
                    ),
                  ),

                  testing == "1" ?
                  SizedBox(height: 10):Container(),
                  testing == "1" ? Container(
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

                      onPressed:()=> _ScanKitCode(),

                      child: Text(
                        "Menu_Form.StartScan".tr().toString(),
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ):Container(),
                  testing == "1" ?SizedBox(height: 10):Container(),
                ],
              ),
            ),

            testing != "1" ? Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.centerLeft,
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 10),
                        _ICCID(),
                        emptyICCID  == true
                            ? ReusableRequiredText(
                            text: "Menu_Form.msisdn_required".tr().toString())
                            : Container(),
                        errorICCID==true ?ReusableRequiredText(
                            text:  EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "Your ICCID shoud be 20 digit"
                                : "رقم ICCID يجب أن يتكون من 20 خانات")
                            : Container(),
                        SizedBox(height: 20),
                        msgScan,
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
                              print(ICCID.text.length);
                              if (ICCID.text == '') {
                                setState(() {
                                  emptyICCID = true;
                                });
                              }
                              if (ICCID.text != '') {
                                if(ICCID.text.length == 20 ){
                                  errorICCID = false;
                                  // emptyICCID=false;

                                }else{
                                  setState(() {
                                    errorICCID = true;
                                    // emptyICCID=false;
                                  });
                                }
                              }
                              if (ICCID.text != '' && ICCID.text.length == 20 ) {

                                validateKitCodeRqBloc.add(ValidateKitCodeRqScanButtonPressed(msisdn:'',kitCode:'',iccid:ICCID.text));
                                /* Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UpdateLine('msisdn.text'),
                        ),
                      );*/
                                /*  Navigator.pushReplacement(
                         context,
                         MaterialPageRoute(
                           builder: (context) => JordanianNotionality(Permessions,role,outDoorUserName,'','',true,true),
                         ),
                       );*/

                              }

                            },

                            child: Text(
                              "Menu_Form.continue".tr().toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                ],
              ),

            ):Container(),

            /***************************************************************Manual Part***********************************************************/
            Container(
              height: 55,
              width: 420,
              margin: const EdgeInsets.only(left: 20.0, right: 20.0),
              decoration: BoxDecoration(),
              child:   Row(children: <Widget>[
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
                Text("Menu_Form.OR".tr().toString(),),
                Expanded(
                  child: new Container(
                      margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                      child: Divider(
                        color: Colors.black,
                        height: 36,
                      )),
                ),
              ]),),

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
                        emptymsisdn  == true
                            ? ReusableRequiredText(
                            text: "Menu_Form.msisdn_required".tr().toString())
                            : Container(),
                        errormsisdn==true ?ReusableRequiredText(
                            text:  EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "Your MSISID shoud be 10 digit and start with 079"
                                : "رقم الهاتف يجب أن يتكون من 10 خانات ويبدأ ب 079")
                            : Container(),
                        SizedBox(height: 20),
                        KitCode(),
                        emptyKitCode == true
                            ? ReusableRequiredText(
                            text: "Menu_Form.kit_required".tr().toString())
                            : Container(),
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
                            onPressed: disableContinue==true?null:() {
                              /**************************************************************/


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
                              if (kitCode.text == '') {
                                setState(() {
                                  emptyKitCode = true;
                                });
                              }
                              if (kitCode.text != '') {
                                emptyKitCode = false;


                              }

                              if (msisdn.text != '' && kitCode.text != '' && msisdn.text.length == 10 && msisdn.text.substring(0, 3) == '079') {
                                setState(() {
                                  disableContinue=true;
                                });
                                validateKitCodeRqBloc.add(
                                    ValidateKitCodeRqButtonPressed(msisdn: msisdn.text,
                                        kitCode: kitCode.text,
                                        iccid: ''));
                              }


                              /**************************************************************/




                            },

                            child: Text(
                              "Menu_Form.continue".tr().toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 10),

                ],
              ),

            ),


            SizedBox(height: 10),




          ]),
        ),
      ),
    );
  }
}