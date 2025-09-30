import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/SelectNationlaity.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

class LineDocumentation_Bulk extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  bool Bulk_Activat;
  LineDocumentation_Bulk({this.Permessions, this.role, this.outDoorUserName,this.Bulk_Activat});

  @override
  _LineDocumentation_BulkState createState() => _LineDocumentation_BulkState(
      this.Permessions, this.role, this.outDoorUserName,this.Bulk_Activat);
}

class _LineDocumentation_BulkState extends State<LineDocumentation_Bulk> {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  bool Bulk_Activat;
  _LineDocumentation_BulkState(
      this.Permessions, this.role, this.outDoorUserName,this.Bulk_Activat);
  int selectedLanguage = 2;
  bool emptymsisdn = false;
  bool emptyKitCode = false;
  bool errormsisdn = false;

  bool emptyICCID = false;
  bool errorICCID = false;
  String testing = "1";

  TextEditingController msisdn = TextEditingController();
  TextEditingController kitCode = TextEditingController();
  TextEditingController ICCID = TextEditingController();

  ValidateKitCodeRqBloc validateKitCodeRqBloc;

  String _dataKitCode = "";

  /*****************************************New Part for Bulk Activation********************************/
  bool Check_Number_Activation_Flag = false;
  bool add_Bulk = false;
  int Number_Activation = 0;
  var First_KitCode = {};
  var Second_KitCode = {};
  var Third_KitCode = {};
  String iccid_duplicate = '';
  String General_MSISDN_duplicate_checkMaual = '';
  String General_MSISDN_duplicate_chekScan = '';

  String iccid_duplicate_EnterScan = '';
  String MSISDN_duplicate_EnterManual = '';




  String msisdn_duplicate='';
  List<Bulk> bulk = [];
  bool isShahamah =false;
  bool displayReference =false;
  bool showJordanian=false;
  bool showNonJordanian =false;
  String state_msisdn;
  bool Check_Scan=false;

  List bulkNumbers=[];
  List newList=[];
  bool disableContinue=false;
  /****************************************************************************************************/

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

  void clearMSISDN() {
    setState(() {
      msisdn.text = '';
    });
  }

  void clearKITCODE() {
    setState(() {
      kitCode.text = '';
    });
  }

  void clearICCID() {
    setState(() {
      ICCID.text = '';
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
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            onTap: () {},
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptymsisdn == true || errormsisdn == true
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: clearMSISDN,
                icon: Icon(Icons.close),
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
              enabledBorder: emptyKitCode == true
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                mainAxisSize: MainAxisSize.min, // added line
                children: <Widget>[
                  IconButton(
                    onPressed: clearKITCODE,
                    icon: Icon(Icons.close),
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
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            onTap: () {},
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyICCID == true || errorICCID == true
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: clearICCID,
                icon: Icon(Icons.close),
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



  final msg = BlocBuilder<ValidateKitCodeRqBloc, ValidateKitCodeRqState>(
      builder: (context, state) {
        if (state is ValidateKitCodeRqLoadingState) {
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
  final msgScan = BlocBuilder<ValidateKitCodeRqBloc, ValidateKitCodeRqState>(
      builder: (context, state) {
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
              errormsisdn = false;
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

  showAlertDialogScanError(
      BuildContext context, arabicMessageScan, englishMessageScan) {
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
              disableContinue=false;
              errorICCID = false;
              errormsisdn = false;
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
    _ScanKitCode() async {
      await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.BARCODE)
          .then((value) => setState(() => _dataKitCode = value));

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
            disableContinue=false;
          });
          showAlertDialogError(
              context, state.arabicMessage, state.englishMessage);
        }
        if (state is ValidateKitCodeRqErrorScanState) {
          setState(() {
            disableContinue=false;
            disableContinue=false;
          });
          showAlertDialogScanError(
              context, state.arabicMessageScan, state.englishMessageScan);
        }
        if (state is ValidateKitCodeRqTokenErrorState) {
          setState(() {
            disableContinue=false;
            disableContinue=false;
          });
          UnotherizedError();
        }
        if (state is ValidateKitCodeRqSuccessState) {
          setState(() {
            disableContinue=false;
            disableContinue=false;
          });
          print("ValidateKitCodeRqSuccessState");
          print("ICCID.text");
          print(ICCID.text);
          print("msisdn");
          print(msisdn.text);
          print("kitCode.text");
          print(kitCode.text);
          setState(() {
            isShahamah=  state.isShahamah;
            displayReference= state.displayReference;
            showJordanian=  state.showJordanian;
            showNonJordanian=state.showNonJordanian;
            add_Bulk = false;
          });

          if(Number_Activation==0  ){
            if(General_MSISDN_duplicate_checkMaual != msisdn.text){
              setState(() {
                MSISDN_duplicate_EnterManual=msisdn.text;


                bulk.add(Bulk(
                    msisdn: msisdn.text,
                    kitCode:  kitCode.text,
                    iccid: ICCID.text));
                First_KitCode = {
                  "msisdn": msisdn.text,
                  "kitCode":  kitCode.text,
                  "iccid": ICCID.text
                };
                General_MSISDN_duplicate_chekScan=msisdn.text;

                Number_Activation =
                    Number_Activation + 1;
                msisdn_duplicate =
                    msisdn.text;
              });
            }else{
              Fluttertoast.showToast(
                  msg:
                  EasyLocalization.of(context).locale ==
                      Locale("en", "US")
                      ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                  toastLength:
                  Toast.LENGTH_SHORT,
                  gravity:
                  ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor:
                  Colors.black54,
                  textColor: Colors.white);
            }

          }else if(Number_Activation==1 ){
            if(General_MSISDN_duplicate_checkMaual != msisdn.text){
              setState(() {
                MSISDN_duplicate_EnterManual=msisdn.text;


                bulk.add(Bulk(
                    msisdn: msisdn.text,
                    kitCode: kitCode.text,
                    iccid: ICCID.text));
                Second_KitCode = {
                  "msisdn": msisdn.text,
                  "kitCode": kitCode.text,
                  "iccid": ICCID.text
                };
                Number_Activation =
                    Number_Activation + 1;
                msisdn_duplicate =
                    msisdn.text;
              });
              print(First_KitCode);
              print(Second_KitCode);
              print(Third_KitCode);
            }else{
              Fluttertoast.showToast(
                  msg:
                  EasyLocalization.of(context).locale ==
                      Locale("en", "US")
                      ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                  toastLength:
                  Toast.LENGTH_SHORT,
                  gravity:
                  ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor:
                  Colors.black54,
                  textColor: Colors.white);
            }

          }else if(Number_Activation==2){
            if(General_MSISDN_duplicate_checkMaual != msisdn.text){
              setState(() {
                MSISDN_duplicate_EnterManual=msisdn.text;


                bulk.add(Bulk(
                    msisdn: msisdn.text,
                    kitCode: kitCode.text,
                    iccid: ICCID.text));
                Third_KitCode = {
                  "msisdn":msisdn.text,
                  "kitCode": kitCode.text,
                  "iccid": ICCID.text
                };
                Number_Activation =
                    Number_Activation + 1;
                msisdn_duplicate =
                    msisdn.text;
              });
            }else{
              Fluttertoast.showToast(
                  msg:
                  EasyLocalization.of(context).locale ==
                      Locale("en", "US")
                      ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                  toastLength:
                  Toast.LENGTH_SHORT,
                  gravity:
                  ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor:
                  Colors.black54,
                  textColor: Colors.white);
            }

          }


          /*  Permessions.contains('05.01.01.01')
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectNationality(
                        Permessions,
                        role,
                        outDoorUserName,
                        msisdn.text,
                        kitCode.text,
                        ICCID.text,
                        state.isShahamah,
                        state.displayReference,
                        state.showJordanian,
                        state.showNonJordanian),
                  ),
                )
              : null;*/
        }
        if (state is ValidateKitCodeRqSuccessScanState) {
          setState(() {
            disableContinue=false;
            disableContinue=false;
          });
          print("ValidateKitCodeRqSuccessScanState");
          print("ICCID.text");
          print(ICCID.text.length);
          print("msisdnScan");
          print(state.msisdn);
          print("kitCode.text");
          print(kitCode.text);
          setState(() {

            General_MSISDN_duplicate_checkMaual=state.msisdn;
            state_msisdn=state.msisdn;
            isShahamah=  state.isShahamah;
            displayReference= state.displayReference;
            showJordanian=  state.showJordanian;
            showNonJordanian=state.showNonJordanian;
            add_Bulk = false;
          });
          if(Number_Activation==0 ){
            print("General_MSISDN_duplicate_chekScan");
            print(General_MSISDN_duplicate_chekScan);

            print("state.msisdn");
            print(state.msisdn);

            if(General_MSISDN_duplicate_chekScan != state.msisdn) {
              setState(() {
                iccid_duplicate_EnterScan=ICCID.text;
                MSISDN_duplicate_EnterManual=state.msisdn;


                bulk.add(Bulk(
                    msisdn: state.msisdn,
                    kitCode: kitCode.text,
                    iccid: ICCID.text));
                First_KitCode = {
                  "msisdn": state.msisdn,
                  "kitCode": kitCode.text,
                  "iccid": ICCID.text
                };
                Number_Activation =
                    Number_Activation + 1;
                iccid_duplicate =
                    ICCID.text;
              });
            }else{
              Fluttertoast.showToast(
                  msg:
                  EasyLocalization.of(context).locale ==
                      Locale("en", "US")
                      ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                  toastLength:
                  Toast.LENGTH_SHORT,
                  gravity:
                  ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor:
                  Colors.black54,
                  textColor: Colors.white);
            }







            for (Bulk product in bulk) {
              print("lllll");
              // print all data members using product.<data-member>

              print(product.msisdn);



            }

          }else if(Number_Activation==1 ){
            if(General_MSISDN_duplicate_chekScan != state.msisdn && MSISDN_duplicate_EnterManual !=state.msisdn) {
              setState(() {
                iccid_duplicate_EnterScan=ICCID.text;
                MSISDN_duplicate_EnterManual=state.msisdn;


                bulk.add(Bulk(
                    msisdn: state.msisdn,
                    kitCode: kitCode.text,
                    iccid: ICCID.text));
                Second_KitCode = {
                  "msisdn": state.msisdn,
                  "kitCode": kitCode.text,
                  "iccid": ICCID.text
                };
                Number_Activation =
                    Number_Activation + 1;
                iccid_duplicate =
                    ICCID.text;
              });
              print(First_KitCode);
              print(Second_KitCode);
              print(Third_KitCode);

            }else{
              Fluttertoast.showToast(
                  msg:
                  EasyLocalization.of(context).locale ==
                      Locale("en", "US")
                      ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                  toastLength:
                  Toast.LENGTH_SHORT,
                  gravity:
                  ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor:
                  Colors.black54,
                  textColor: Colors.white);
            }

          }else if(Number_Activation==2){
            if(General_MSISDN_duplicate_chekScan != state.msisdn && MSISDN_duplicate_EnterManual !=state.msisdn) {
              setState(() {
                iccid_duplicate_EnterScan=ICCID.text;
                MSISDN_duplicate_EnterManual=state.msisdn;


                bulk.add(Bulk(
                    msisdn: state.msisdn,
                    kitCode: kitCode.text,
                    iccid: ICCID.text));
                Third_KitCode = {
                  "msisdn": state.msisdn,
                  "kitCode": kitCode.text,
                  "iccid": ICCID.text
                };
                Number_Activation =
                    Number_Activation + 1;
                iccid_duplicate =
                    ICCID.text;
              });
            }else{
              Fluttertoast.showToast(
                  msg:
                  EasyLocalization.of(context).locale ==
                      Locale("en", "US")
                      ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                  toastLength:
                  Toast.LENGTH_SHORT,
                  gravity:
                  ToastGravity.BOTTOM,
                  timeInSecForIosWeb: 1,
                  backgroundColor:
                  Colors.black54,
                  textColor: Colors.white);
            }

          }

          /* Permessions.contains('05.01.01.01')
              ?setState(() {
            add_Bulk = false;
          })*/ /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectNationality(
                        Permessions,
                        role,
                        outDoorUserName,
                        state.msisdn,
                        kitCode.text,
                        ICCID.text,
                        state.isShahamah,
                        state.displayReference,
                        state.showJordanian,
                        state.showNonJordanian),
                  ),
                )
              : null;*/
        }
      },
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
              leading:add_Bulk == false? IconButton(
                icon: Icon(Icons.arrow_back),
                //tooltip: 'Menu Icon',
                onPressed: () {
                  Navigator.pop(context);
                },
              ):IconButton(
                icon: Icon(Icons.arrow_back),
                //tooltip: 'Menu Icon',
                onPressed: () {
                  setState(() {
                    add_Bulk=false;
                  });
                },
              ),
              centerTitle: false,
              title: Text(
                "Menu_Form.line_documentation".tr().toString(),
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: ListView(padding: EdgeInsets.only(top: 0), children: <Widget>[
              Container(
                  color: Colors.white,
                  width: double.infinity,
                  //alignment: Alignment.bottomLeft,
                  // padding: EdgeInsets.only(left: 15, right: 15,top: 15),
                  child: Column(children: <Widget>[
                    add_Bulk == false
                        ? Container(
                      padding:
                      EdgeInsets.only(left: 15, right: 15, top: 15, bottom: 20),

                      child: Column(
                        children: [
                          Container(
                            padding:
                            EdgeInsets.only(bottom: 20),

                            alignment: EasyLocalization.of(context).locale == Locale("en", "US")?Alignment.topLeft:Alignment.topRight,
                            child: Text( "Menu_Form.Bulk_Activation".tr().toString(),

                              style: TextStyle(
                                color: Color(0xFF4f2565),
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Container(
                            alignment: EasyLocalization.of(context).locale == Locale("en", "US")?Alignment.topLeft:Alignment.topRight,
                            child: Text(EasyLocalization.of(context).locale == Locale("en", "US")?
                            "Tap to insert ICCID or MSISDN & Kitcode to get started . You can Activate three at time.":"انقر لإدخال ICCID أو رقم الخط و رقم العبوة  للبدء. يمكنك تفعيل ثلاثة خطوط  في وقت واحد.", style: TextStyle(
                              color: Colors.black54,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),),
                          )
                        ],
                      ),
                    )
                        : Container(),
                    add_Bulk == false
                        ? ListTile(
                      title: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")?
                        "Number of Bulk Activation " +
                            " " +
                            Number_Activation.toString(): "عدد الخطوط المفعلة  "+ Number_Activation.toString(),
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF4f2565),
                            fontWeight: FontWeight.normal),
                      ),
                      /* trailing: IconButton(
                            icon: Icon(
                                    Icons.add_circle,
                                    color: Color(0xFF4f2565),
                                  ),
                            onPressed: () {
                           /*   print("First_KitCode.length");
                              print(First_KitCode.length);
                              print("Second_KitCode.length");
                              print(Second_KitCode.length);
                              print("Third_KitCode.length");

                              print(Third_KitCode.length);



                              print(Number_Activation);
                              setState(() {
                                 emptymsisdn = false;
                                emptyKitCode = false;
                                errormsisdn = false;
                                add_Bulk = true;
                                ICCID.text = '';
                                msisdn.text='';
                                kitCode.text='';
                                testing = "1";
                                errorICCID = false;
                              });

                              if(Number_Activation==3){
                                setState(() {
                                  add_Bulk=false;
                                });

                                Fluttertoast.showToast(
                                    msg:
                                    EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ?"Sorry, The maximum number of Bulk Activation is 3":"عذرًا، الحد الأقصى لاستخدام عملية التفعيل الجماعي هو ثلاثة",
                                    toastLength:
                                    Toast.LENGTH_SHORT,
                                    gravity:
                                    ToastGravity.BOTTOM,
                                    timeInSecForIosWeb: 1,
                                    backgroundColor:
                                    Colors.black54,
                                    textColor: Colors.white);

                              }*/
                            },
                          ),*/
                    )
                        : Container(),
                  ])),
              add_Bulk == false? SizedBox(height: 20):Container(),
              add_Bulk == false
                  ? Column(
                children: bulk.map((info) {
                  return Container(

                    width: double.infinity,
                    child: Card(
                      child: ListTile(
                        subtitle:Container(
                          margin: EdgeInsets.only(top: 10,bottom: 10),
                          child: Column(
                            children: [
                              Container(
                                child: Row(
                                  children: [
                                    Text("ICCID : ",style: TextStyle(
                                      color: Color(0xFF4f2565),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                    Text(info.iccid,style: TextStyle(
                                      color: Color(0xFF4f2565),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Text("Menu_Form.msisdn".tr().toString()+" : ",style: TextStyle(
                                      color: Color(0xFF4f2565),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    )),
                                    info.msisdn.length==0?  Text(state_msisdn,style: TextStyle(
                                      color: Color(0xFF4f2565),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    )):
                                    Text(info.msisdn,style: TextStyle(
                                      color: Color(0xFF4f2565),
                                      fontSize: 14,
                                      fontWeight: FontWeight.normal,
                                    ))
                                  ],
                                ),
                              ),
                              Container(
                                child: Row(
                                  children: [
                                    Text("Menu_Form.kit_code".tr().toString()+" : ",style: TextStyle(
                                      color: Color(0xFF4f2565),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                    ),),
                                    Text(info.kitCode,
                                        style: TextStyle(
                                          color: Color(0xFF4f2565),
                                          fontSize: 14,
                                          fontWeight: FontWeight.normal,
                                        ))
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                        trailing:
                        IconButton(
                          icon: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? Icon(
                            Icons.delete_outline,
                            color: Colors.blue,
                          )
                              : Icon(
                            Icons.delete_outline,
                            color: Colors.blue,
                          ),

                          onPressed: () {
                            //delete action for this button
                            bulk.removeWhere((element) {
                              return element.msisdn == info.msisdn;
                            }); //go through the loop and match content to delete from list

                            if(First_KitCode["msisdn"]==info.msisdn){
                              setState(() {
                                First_KitCode={};
                              });


                            }
                            if(Second_KitCode["msisdn"]==info.msisdn){
                              setState(() {
                                Second_KitCode={};
                              });

                            }
                            if(Third_KitCode["msisdn"]==info.msisdn){
                              setState(() {
                                Third_KitCode={};
                              });
                            }
                            setState(() {
                              Number_Activation=Number_Activation-1;
                            });

                            print(First_KitCode);
                            print(Second_KitCode);
                            print(Third_KitCode);
                            print(msisdn_duplicate);
                            print(iccid_duplicate);
                          },

                        ),

                      ),
                    ),
                  );
                }).toList(),
              )
                  : Container(),
              /*    Number_Activation >= 1  && add_Bulk == false?
            Container(
              height: 48,
              width: 420,
              margin:
              EdgeInsets.symmetric(horizontal: 10,vertical: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: TextButton(
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(
                          Radius.circular(24))),
                ),
                onPressed: () => {

              setState(() {
                msisdn_duplicate='';
               iccid_duplicate='';
              }),
                  if (First_KitCode.length != 0){
                    print("............First_KitCode.................."),
                    print(First_KitCode.length),
                    print(".............................."),
                    setState(() {
                      newList.add(First_KitCode);
                    }),

                  } ,
                  if(Second_KitCode.length != 0){
                    print("............Second_KitCode.................."),
                    print(Second_KitCode.length),
                    print(".............................."),
                    setState(() {
                      newList.add(Second_KitCode);
                    }),


                  },
                  if(Third_KitCode.length !=0){
                    print("...........Third_KitCode..................."),
                    print(Second_KitCode.length),
                    print(".............................."),
                    newList.add(Third_KitCode),
                    setState(() {
                      newList.add(Third_KitCode);

                    })

                  },

                  print("..............bulkNumbers................"),
                  print(newList),

                  if(newList.length != 0){
                    setState(() {
                      bulkNumbers = newList.toSet().toList();
                    })

                  }else{
                  setState(() {
                    bulkNumbers=newList;
            })
                  },
                  print(bulkNumbers),
                  print(".............................."),

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SelectNationality(
                          Permessions,
                          role,
                          outDoorUserName,
                          state_msisdn,
                          kitCode.text,
                          ICCID.text,
                          isShahamah,
                        displayReference,
                         showJordanian,
                         showNonJordanian,
                          bulkNumbers,Bulk_Activat),
                    ),
                  )
                },
                child: Text(
                  "Postpaid.Next".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
                :Container(),*/
              add_Bulk == true
                  ? Column(
                children: [
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Image(
                                  image: AssetImage(
                                      'assets/images/barcode-scan.png'),
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
                              testing == "1"
                                  ? TextButton(
                                child: Text(
                                  "Menu_Form.PleaseScanBarcodeOnChargeCard"
                                      .tr()
                                      .toString(),
                                  textAlign: TextAlign.center,
                                ),
                              )
                                  : Container(),
                            ],
                          ),
                        ),
                        testing == "1" ? SizedBox(height: 10) : Container(),
                        testing == "1"
                            ? Container(
                          height: 48,
                          width: 420,
                          margin:
                          EdgeInsets.symmetric(horizontal: 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFF4f2565),
                          ),
                          child: TextButton(
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF4f2565),
                              shape: const BeveledRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                      Radius.circular(24))),
                            ),
                            onPressed: () => _ScanKitCode(),
                            child: Text(
                              "Menu_Form.StartScan".tr().toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        )
                            : Container(),
                        testing == "1" ? SizedBox(height: 10) : Container(),
                      ],
                    ),
                  ),
                  testing != "1"
                      ? Container(
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
                              emptyICCID == true
                                  ? ReusableRequiredText(
                                  text:
                                  "Menu_Form.msisdn_required"
                                      .tr()
                                      .toString())
                                  : Container(),
                              errorICCID == true
                                  ? ReusableRequiredText(
                                  text: EasyLocalization.of(
                                      context)
                                      .locale ==
                                      Locale("en", "US")
                                      ? "Your ICCID shoud be 20 digit"
                                      : "رقم ICCID يجب أن يتكون من 20 خانات")
                                  : Container(),
                              SizedBox(height: 20),
                              msgScan,
                              Container(
                                height: 48,
                                width: 420,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius:
                                  BorderRadius.circular(50),
                                  color: Color(0xFF4f2565),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:
                                    Color(0xFF4f2565),
                                    shape:
                                    const BeveledRectangleBorder(
                                        borderRadius:
                                        BorderRadius.all(
                                            Radius.circular(
                                                24))),
                                  ),
                                  onPressed: disableContinue==true?null: () {
                                    FocusScope.of(context).unfocus();
                                    print(ICCID.text.length);
                                    if (ICCID.text == '') {
                                      setState(() {
                                        emptyICCID = true;
                                      });
                                    }
                                    if (ICCID.text != '') {
                                      if (ICCID.text.length == 20) {
                                        errorICCID = false;
                                        // emptyICCID=false;
                                      } else {
                                        setState(() {
                                          errorICCID = true;
                                          // emptyICCID=false;
                                        });
                                      }
                                    }
                                    if (ICCID.text != '' && ICCID.text.length == 20) {
                                      /****************************************************add item to object************************/
                                      if (Number_Activation == 0 ) {
                                        print("Number_Activation");
                                        print(Number_Activation);
                                        if( iccid_duplicate_EnterScan != ICCID.text ){

                                          setState(() {
                                            disableContinue=true;
                                          });
                                          validateKitCodeRqBloc.add(
                                              ValidateKitCodeRqScanButtonPressed(
                                                  msisdn: '',
                                                  kitCode: '',
                                                  iccid: ICCID.text));
                                        }else{
                                          print("pppp");
                                          print(General_MSISDN_duplicate_chekScan);
                                          print(msisdn_duplicate);
                                          Fluttertoast.showToast(
                                              msg:
                                              EasyLocalization.of(context).locale ==
                                                  Locale("en", "US")
                                                  ?"You insert this ICCID , please add another one .":"قمت بإدخال ICCID هذا ، يرجى إضافة واحد آخر.",
                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.black54,
                                              textColor: Colors.white);
                                        }



                                      }

                                      else  if (Number_Activation == 1 ) {
                                        print("Number_Activation");
                                        print(Number_Activation);

                                        if( iccid_duplicate_EnterScan != ICCID.text){
                                          setState(() {
                                            disableContinue=true;
                                          });
                                          validateKitCodeRqBloc.add(
                                              ValidateKitCodeRqScanButtonPressed(
                                                  msisdn: '',
                                                  kitCode: '',
                                                  iccid: ICCID.text));
                                        }else{
                                          print(";;;");
                                          print(General_MSISDN_duplicate_chekScan);
                                          print(iccid_duplicate);
                                          Fluttertoast.showToast(
                                              msg:
                                              EasyLocalization.of(context).locale ==
                                                  Locale("en", "US")
                                                  ?"You insert this ICCID , please add another one .":"قمت بإدخال ICCID هذا ، يرجى إضافة واحد آخر.",

                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.black54,
                                              textColor: Colors.white);
                                        }
                                      }
                                      else if (Number_Activation == 2) {

                                        if( iccid_duplicate_EnterScan != ICCID.text){
                                          setState(() {
                                            disableContinue=true;
                                          });
                                          validateKitCodeRqBloc.add(
                                              ValidateKitCodeRqScanButtonPressed(
                                                  msisdn: '',
                                                  kitCode: '',
                                                  iccid: ICCID.text));
                                        }else{
                                          Fluttertoast.showToast(
                                              msg:
                                              EasyLocalization.of(context).locale ==
                                                  Locale("en", "US")
                                                  ?"You insert this ICCID , please add another one .":"قمت بإدخال ICCID هذا ، يرجى إضافة واحد آخر.",

                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.black54,
                                              textColor: Colors.white);
                                        }
                                      }

                                      print(First_KitCode);
                                      print(Second_KitCode);
                                      print(Third_KitCode);


                                    }
                                  },
                                  child: Text(
                                    "Menu_Form.continue"
                                        .tr()
                                        .toString(),
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
                  )
                      : Container(),

                  /***************************************************************Manual Part***********************************************************/
                  Container(
                    height: 55,
                    width: 420,
                    margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                    decoration: BoxDecoration(),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(
                                left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Text(
                        "Menu_Form.OR".tr().toString(),
                      ),
                      Expanded(
                        child: new Container(
                            margin: const EdgeInsets.only(
                                left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),
                  ),
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
                                  text: "Menu_Form.msisdn_required"
                                      .tr()
                                      .toString())
                                  : Container(),
                              errormsisdn == true
                                  ? ReusableRequiredText(
                                  text: EasyLocalization.of(context)
                                      .locale ==
                                      Locale("en", "US")
                                      ? "Your MSISID shoud be 10 digit and start with 079"
                                      : "رقم الهاتف يجب أن يتكون من 10 خانات ويبدأ ب 079")
                                  : Container(),
                              SizedBox(height: 20),
                              KitCode(),
                              emptyKitCode == true
                                  ? ReusableRequiredText(
                                  text: "Menu_Form.kit_required"
                                      .tr()
                                      .toString())
                                  : Container(),
                              SizedBox(height: 20),
                              msg,
                              Container(
                                height: 48,
                                width: 420,
                                margin:
                                EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xFF4f2565),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFF4f2565),
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
                                  ),
                                  onPressed: disableContinue==true?null: () {
                                    /**************************************************************/

                                    FocusScope.of(context).unfocus();
                                    print(msisdn.text.length);
                                    if (msisdn.text == '') {
                                      setState(() {
                                        emptymsisdn = true;
                                      });
                                    }
                                    if (msisdn.text != '') {
                                      if (msisdn.text.length == 10) {
                                        if (msisdn.text.substring(0, 3) ==
                                            '079') {
                                          setState(() {
                                            errormsisdn = false;
                                            emptymsisdn = false;
                                          });
                                        } else {
                                          setState(() {
                                            errormsisdn = true;
                                            emptymsisdn = false;
                                          });
                                        }
                                      } else {
                                        setState(() {
                                          errormsisdn = true;
                                          emptymsisdn = false;
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

                                    if (msisdn.text != '' &&
                                        kitCode.text != '' &&
                                        msisdn.text.length == 10 &&
                                        msisdn.text.substring(0, 3) ==
                                            '079') {


                                      /****************************************************add item to object************************/
                                      if (Number_Activation == 0 ) {
                                        print("Number_Activation");
                                        print(Number_Activation);
                                        if( MSISDN_duplicate_EnterManual != msisdn.text){
                                          setState(() {
                                            disableContinue=true;
                                          });
                                          validateKitCodeRqBloc.add(
                                              ValidateKitCodeRqButtonPressed(

                                                  msisdn: msisdn.text,
                                                  kitCode: kitCode.text,
                                                  iccid: ''));
                                        }else{
                                          Fluttertoast.showToast(
                                              msg:
                                              EasyLocalization.of(context).locale ==
                                                  Locale("en", "US")
                                                  ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.black54,
                                              textColor: Colors.white);
                                        }



                                      }

                                      else  if (Number_Activation == 1 ) {
                                        print("Number_Activation");
                                        print(Number_Activation);
                                        if( MSISDN_duplicate_EnterManual != msisdn.text){
                                          setState(() {
                                            disableContinue=true;
                                          });
                                          validateKitCodeRqBloc.add(
                                              ValidateKitCodeRqButtonPressed(
                                                  msisdn: msisdn.text,
                                                  kitCode: kitCode.text,
                                                  iccid: ''));
                                        }else{
                                          Fluttertoast.showToast(
                                              msg:
                                              EasyLocalization.of(context).locale ==
                                                  Locale("en", "US")
                                                  ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.black54,
                                              textColor: Colors.white);
                                        }
                                      }
                                      else if (Number_Activation == 2) {
                                        if(MSISDN_duplicate_EnterManual != msisdn.text){
                                          setState(() {
                                            disableContinue=true;
                                          });
                                          validateKitCodeRqBloc.add(
                                              ValidateKitCodeRqButtonPressed(
                                                  msisdn: msisdn.text,
                                                  kitCode: kitCode.text,
                                                  iccid: ''));
                                        }else{
                                          Fluttertoast.showToast(
                                              msg:
                                              EasyLocalization.of(context).locale ==
                                                  Locale("en", "US")
                                                  ?"You insert this MSISDN , please add another one .":"قمت بإدخال رقم الخط هذا ، الرجاء إضافة رقم أخر",

                                              toastLength:
                                              Toast.LENGTH_SHORT,
                                              gravity:
                                              ToastGravity.BOTTOM,
                                              timeInSecForIosWeb: 1,
                                              backgroundColor:
                                              Colors.black54,
                                              textColor: Colors.white);
                                        }
                                      }
                                      /*setState(() {
                                                  add_Bulk = false;
                                                });*/
                                      print(First_KitCode);
                                      print(Second_KitCode);
                                      print(Third_KitCode);



                                      /* validateKitCodeRqBloc.add(
                                              ValidateKitCodeRqButtonPressed(
                                                  msisdn: msisdn.text,
                                                  kitCode: kitCode.text,
                                                  iccid: ''));*/
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
                ],
              )
                  : Container(),
              SizedBox(height: 10),
            ]),

            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: 8, left: 0, right: 0),
              children: [
                /////////////////////////////////// Content of Next and add Buttons//////////////////////////////////////////////////////////

                SingleChildScrollView(
                  child: Column(
                    children: [


                      add_Bulk == false?  SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child:  Card(
                          color: Color(0xFF4f2565),
                          borderOnForeground: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  title: Text("Postpaid.Add_new_line".tr().toString(),
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                        : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                                  ),
                                  onTap: () {
                                    print("First_KitCode.length");
                                    print(First_KitCode.length);
                                    print("Second_KitCode.length");
                                    print(Second_KitCode.length);
                                    print("Third_KitCode.length");

                                    print(Third_KitCode.length);



                                    print(Number_Activation);
                                    setState(() {
                                      emptymsisdn = false;
                                      emptyKitCode = false;
                                      errormsisdn = false;
                                      add_Bulk = true;
                                      ICCID.text = '';
                                      msisdn.text='';
                                      kitCode.text='';
                                      testing = "1";
                                      errorICCID = false;
                                    });

                                    if(Number_Activation==3){
                                      setState(() {
                                        add_Bulk=false;
                                      });

                                      Fluttertoast.showToast(
                                          msg:
                                          EasyLocalization.of(context).locale ==
                                              Locale("en", "US")
                                              ?"Sorry, The maximum number of Bulk Activation is 3":"عذرًا، الحد الأقصى لاستخدام عملية التفعيل الجماعي هو ثلاثة",
                                          toastLength:
                                          Toast.LENGTH_SHORT,
                                          gravity:
                                          ToastGravity.BOTTOM,
                                          timeInSecForIosWeb: 1,
                                          backgroundColor:
                                          Colors.black54,
                                          textColor: Colors.white);

                                    }

                                  }
                              ),

                            ],
                          ),
                        ),

                      ):Container(),
                      Number_Activation >= 1  && add_Bulk == false? SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child:  Card(
                          color: Color(0xFF4f2565),
                          borderOnForeground: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  title: Text("Postpaid.Line_Documentation_Proceed".tr().toString(),
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                        : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                                  ),
                                  onTap: () {

                                    setState(() {
                                      msisdn_duplicate='';
                                      iccid_duplicate='';
                                    });
                                    if (First_KitCode.length != 0){
                                      print("............First_KitCode..................");
                                      print(First_KitCode.length);
                                      print("..............................");
                                      setState(() {
                                        newList.add(First_KitCode);
                                      });

                                    } ;
                                    if(Second_KitCode.length != 0){
                                      print("............Second_KitCode..................");
                                      print(Second_KitCode.length);
                                      print("..............................");
                                      setState(() {
                                        newList.add(Second_KitCode);
                                      });


                                    };
                                    if(Third_KitCode.length !=0){
                                      print("...........Third_KitCode...................");
                                      print(Second_KitCode.length);
                                      print("..............................");
                                      newList.add(Third_KitCode);
                                      setState(() {
                                        newList.add(Third_KitCode);

                                      });

                                    };

                                    print("..............bulkNumbers................");
                                    print(newList);

                                    if(newList.length != 0){
                                      setState(() {
                                        bulkNumbers = newList.toSet().toList();
                                      });

                                    }else{
                                      setState(() {
                                        bulkNumbers=newList;
                                      });
                                    };
                                    print(bulkNumbers);
                                    print("..............................");

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SelectNationality(
                                            Permessions,
                                            role,
                                            outDoorUserName,
                                            state_msisdn,
                                            kitCode.text,
                                            ICCID.text,
                                            isShahamah,
                                            displayReference,
                                            showJordanian,
                                            showNonJordanian,
                                            bulkNumbers,Bulk_Activat),
                                      ),
                                    );
                                  }
                              ),

                            ],
                          ),
                        ),

                      ):Container(),



                      /*    Number_Activation >= 2  && add_Bulk == false? SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        child:  Card(
                          color: Color(0xFF4f2565),
                          borderOnForeground: true,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              ListTile(
                                  title: Text("Menu_Form.upgrade_packages".tr().toString(),
                                      style: TextStyle(color: Colors.white)),
                                  trailing: IconButton(
                                    icon: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Icon(Icons.keyboard_arrow_right,color: Colors.white,)
                                        : Icon(Icons.keyboard_arrow_left,color: Colors.white,),
                                  ),
                                  onTap: () {

                                  }
                              ),

                            ],
                          ),
                        ),

                      ):Container(),*/

                    ],
                  ),
                ),
              ],
            )


        ),
      ),
    );
  }
}

class Bulk {
  String msisdn, kitCode, iccid;
  Bulk({this.msisdn, this.kitCode, this.iccid});
}
