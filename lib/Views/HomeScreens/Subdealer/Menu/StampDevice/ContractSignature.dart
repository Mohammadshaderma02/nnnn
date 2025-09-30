import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidSubmit/postpaidSubmit_bloc.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidSubmit/postpaidSubmit_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidSubmit/postpaidSubmit_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


import 'package:sales_app/blocs/PostPaid/GenerateWFMToken/GenerateWFMToken_block.dart';
import 'package:sales_app/blocs/PostPaid/GenerateWFMToken/GenerateWFMToken_events.dart';
import 'package:sales_app/blocs/PostPaid/GenerateWFMToken/GenerateWFMToken_state.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../CustomBottomNavigationBar.dart';
import '../Menu.dart';


class ContractSignature extends StatefulWidget {
  final List<dynamic> Permessions;
  final outDoorUserName;
  final msisdn;
  final serialNumber;
  final selectedResellerkey;
  final localPath;
  final isJordanian;
  final frontIdImageBase64;
  final backIdImageBase64;
  final  passportImageBase64;
  final documentExpiryDate;

  ContractSignature(
      {
        this.Permessions,
        this.outDoorUserName,
        this.msisdn,
        this.serialNumber,
        this.selectedResellerkey,
        this.localPath,
        this.isJordanian,
        this.frontIdImageBase64,
        this.backIdImageBase64,
        this.passportImageBase64,
        this.documentExpiryDate,
      });

  @override
  _ContractSignatureState createState() =>
      _ContractSignatureState(
          this.Permessions,
          this.outDoorUserName,
          this.msisdn,
          this.serialNumber,
          this.selectedResellerkey,
        this.localPath,
        this.isJordanian,
        this.frontIdImageBase64,
        this.backIdImageBase64,
        this.passportImageBase64,
        this.documentExpiryDate,
      );
}



class _ContractSignatureState extends State<ContractSignature> {
  var submitted =false;
  var btnDisabled=false;
  var imgBytes;
  final List<dynamic> Permessions;
  var outDoorUserName;
  var role;
  final String msisdn;
  String signatureImageBase64;
  bool isLooding =false;


  bool generateWFMTokent = false;
  bool showAppointment=false;
  dynamic getURL;
  dynamic getAccessToken;
  var process=0;

  DateTime backButtonPressedTime;

  APP_URLS urls = new APP_URLS();
  var serialNumber;
  var selectedResellerkey;
  var localPath;
  final isJordanian;
  final frontIdImageBase64;
  final backIdImageBase64;
  final  passportImageBase64;
  final documentExpiryDate;
  _ContractSignatureState(
      this.Permessions,
      this.outDoorUserName,
      this.msisdn,
      this.serialNumber,
      this.selectedResellerkey,
      this.localPath,
      this.isJordanian,
      this.frontIdImageBase64,
      this.backIdImageBase64,
      this.passportImageBase64,
      this.documentExpiryDate,
      );


  final msg = BlocBuilder<PostpaidSubmitBloc, PostpaidSubmitState>(builder: (context, state) {
    if (state is PostpaidSubmitLoadingState   ) {
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


  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Color(0xFF4f2565),
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    print("Contract Sinf");
    print(documentExpiryDate);
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      // showAlertDialog(context,"هل انت متاكد من إغلاق التطبيق","Are you sure to close the application?");
      return true;
    }
    return true;
  }

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.cancel".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        Navigator.pop(context);
        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
          ),
        );

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
  showAlertDialogSuccess(BuildContext context, arabicMessage, englishMessage) {
    Widget close = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
          ),
        );
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
        close,

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


  void stampAPI() async{
    setState(() {
      submitted=false;
      btnDisabled=true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Postpaid/device/stamp';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    Map body = {
      "msisdn":msisdn,
      "serialNumber":serialNumber,
      "reSellerID":selectedResellerkey,
      "signatureImageBase64":signatureImageBase64,
      "isJordanian": isJordanian,
      "frontIdImageBase64": frontIdImageBase64,
      "backIdImageBase64": backIdImageBase64,
      "passportImageBase64": passportImageBase64,
      "documentExpiryDate": documentExpiryDate


    };
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(json.encode(body));
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if( result["status"]==0){
        setState(() {
          isLooding =false;
          submitted= false;
          btnDisabled=true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));
        showAlertDialogSuccess(
            context, "اكتملت العملية بنجاح",
            "The operation has been successfully completed");

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));
        showAlertDialog(
            context, result["message"],result["messageAr"]);
        setState(() {
          isLooding =false;
          submitted=false;
          btnDisabled=false;
        });

      }




      return result;
    }else{
      setState(() {
        submitted=false;
        btnDisabled=false;
      });
      //   showAlertDialogOtherERROR(context,statusCode, statusCode);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));
    }
  }





  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
              leading:btnDisabled==true? Container(): IconButton(
                icon: Icon(Icons.arrow_back),
                //tooltip: 'Menu Icon',
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle:false,
              title: Text(
                "Postpaid.contract_details".tr().toString(),
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: ListView(
              children: <Widget>[
                Container(
                    color: Color(0xFFEBECF1),
                    padding: EdgeInsets.only(left: 16, right: 10, top: 16, bottom: 15),
                    child: Text(
                      "Postpaid.draw_signature".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF11120e),
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    )),
                //SIGNATURE CANVAS
                submitted==true?
                Container(
                    color: Color(0xFFEBECF1),
                    child:
                    new Image.memory(imgBytes)):Container(),
                submitted==false?Container(

                  child:
                  Signature(
                    controller: _controller,
                    height:  MediaQuery.of(context).size.height/3  * 1.80,
                    backgroundColor: Colors.white,
                  ),
                ):Container(),
                //OK AND CLEAR BUTTONS
                submitted==false?Container(
                  decoration: const BoxDecoration(color: Colors.white),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.max,
                    children: <Widget>[
                      //SHOW EXPORTED IMAGE IN NEW ROUTE
                      IconButton(
                          icon: const Icon(Icons.check),
                          color: Color(0xFF4f2565),
                          onPressed: () async {
                            if (_controller.isNotEmpty) {
                              var data = await _controller.toPngBytes();
                              print('data');
                              print(data);
                              final imageEncoded = base64.encode(data);
                              setState(() {
                                imgBytes = data;
                                signatureImageBase64=imageEncoded;
                              });



                            }
                          }),
                      //CLEAR CANVAS
                      IconButton(
                        icon: const Icon(Icons.clear),
                        color: Color(0xFF4f2565),
                        onPressed: () {
                          setState(() =>
                              _controller.clear(),

                          );
                          setState(() {
                            signatureImageBase64 =null;
                          });
                        },
                      ),

                    ],
                  ),
                ):Container(),
                SizedBox(height: 20,),
                signatureImageBase64 !=null ?msg:Container(),
                signatureImageBase64 !=null ?
                Container(
                    height: 48,
                    width: 300,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: btnDisabled==true?Color(0xFF4f2565).withOpacity(0.6)  :Color(0xFF4f2565),
                    ),
                    child: TextButton(

                      onPressed: () async {

                        setState(() {
                          submitted=true;
                          btnDisabled=true;

                        });
                        stampAPI();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor:Colors.transparent,
                        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                      ),
                      child: Text(
                        "Postpaid.submit".tr().toString(),
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )
                ):Container(),



              ],

            )
        ),
      ),
    );

  }
}