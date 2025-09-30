import 'dart:convert';
import 'dart:ui';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

import 'package:easy_localization/easy_localization.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/ChangePackage/changePackage.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:signature/signature.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


import 'package:url_launcher/url_launcher.dart';

import '../../CustomBottomNavigationBar.dart';
import '../Menu.dart';


class ChangePackage_SignatureContract extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var FilePath;
  var isJordainian;
  var msisdn;
  var packageId;
  var actionTime;
  var confirm;
  var changePackagee;

  ChangePackage_SignatureContract(
      {this.Permessions,
        this.role,
        this.outDoorUserName,
        this.FilePath,
        this.msisdn,
        this.packageId,
        this.actionTime,
        this.confirm,
        this.changePackagee


      });

  @override
  _ChangePackage_SignatureContractState createState() =>
      _ChangePackage_SignatureContractState(
          this.Permessions,
          this.role,
          this.outDoorUserName,
          this.FilePath,
          this.msisdn,
         this.packageId,
          this.actionTime,
          this.confirm,
          this.changePackagee

      );
}



class _ChangePackage_SignatureContractState extends State<ChangePackage_SignatureContract> {
  String amount;
  var packageId;
  var submitted =false;
  var btnDisabled=false;
  var imgBytes;
  var actionTime;
  var confirm;
  var changePackagee;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var FilePath;

  var msisdn;


  dynamic getURL;
  dynamic getAccessToken;
  var process=0;

  DateTime backButtonPressedTime;

  APP_URLS urls = new APP_URLS();

  var isRental;
  var device5GType;
  var serialNumber;
  var itemCode;
  var rentalMsisdn;

  String signatureImageBase64;
  bool isLoading=false;

  _ChangePackage_SignatureContractState(
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.FilePath,
      this.msisdn,
      this.packageId,
      this.actionTime,
      this.confirm,
      this.changePackagee

      );





  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Color(0xFF4f2565),
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();


  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;

      return true;
    }
    return true;
  }

  /*showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
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
  }*/


  /*showAlertDialogSuccess(BuildContext context, arabicMessage, englishMessage) {
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
  }*/



  changePackagesWithZeroamount_API() async {
    print("changePackagesWithZeroamount_API");
    setState(() {
      changePackagee=true;
      isLoading=true;
    });
    FocusScope.of(context).unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/ChangePackage/postpaid/change';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn,
      "actionTime": actionTime,
      "packageId": packageId,
      "confirm": confirm
    };

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),

    );

    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(json.encode(body));
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      setState(() {
        changePackagee=false;
      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){
        setState(() {
          isLoading=false;
        });

        if (result["data"] == null || result["data"].length == 0) {
          setState(() {

          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no packages available"
                      : "لا توجد حزم متاحة")));
        }

        if (result["data"] != null ) {
          setState(() {
            amount=result["data"]["amount"].toString();
            changePackagee=false;
          });


          _showAlertDialogSucss(context,result["message"],result["messageAr"]);


        }

      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          changePackagee=false;
          isLoading=false;
        });
      }



      print('Sucses API changePackagesWithZeroamount_API');
      return result;
    } else {
      setState(() {
        changePackagee=false;
        isLoading=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  signature_contract() async {
print("signature_contract");
    FocusScope.of(context).unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/ChangePackage/postpaid/change';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn,
      "actionTime": actionTime,
      "packageId": packageId,
      "confirm": confirm,
      "signatureImageBase64": signatureImageBase64
    };

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),

    );

    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(json.encode(body));
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      setState(() {
        changePackagee=false;
        isLoading=false;
      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){

        if (result["data"] == null || result["data"].length == 0) {
          setState(() {
            isLoading=false;
          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no packages available"
                      : "لا توجد حزم متاحة")));
        }

        if (result["data"] != null ) {
          setState(() {
            isLoading=false;
            btnDisabled=false;
            amount=result["data"]["amount"].toString();
            changePackagee=false;
          });


          if(confirm==false && amount !="0"){
            showAlertDialogToConfirmChangePackage(context);
          }
          if(confirm==true && amount !="0"){
            _showAlertDialogSucss(context,result["message"],result["messageAr"]);
          }
          if(confirm==false && amount =="0"){

            changePackagesWithZeroamount_API();
            setState(() {
              confirm=true;
              changePackagee=true;
            });
          }

        }

      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          isLoading=false;
          btnDisabled=false;
          changePackagee=false;
        });
      }
      print('Sucses API signature_contract');
      return result;
    } else {
      setState(() {
        isLoading=false;
        btnDisabled=false;
        changePackagee=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  Future<void> _showAlertDialogErorr(BuildContext context,valuEnglish,valuArabaic) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // AlertDialog widget
        return AlertDialog(
          title:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
              ?"Warning"
              : "تنبيه",style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4f2565),
              fontWeight: FontWeight.bold)),
          content: Text( EasyLocalization.of(context).locale == Locale("en", "US")
              ?valuEnglish
              : valuArabaic),
          actions: <Widget>[
            TextButton(
              onPressed: () {

                setState(() {
                  signatureImageBase64 =null;
                  btnDisabled=false;
                  submitted=false;
                  confirm=false;
                  changePackagee=false;
                });
                // Close the AlertDialog
              //  Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        changePackage(
                            Permessions, role, outDoorUserName),
                  ),
                );
              },
              child: Text("Postpaid.Cancel".tr().toString(),style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4f2565),
                  fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialogSucss(BuildContext context,valuEnglish,valuArabaic) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // AlertDialog widget
        return AlertDialog(

          content: Text( EasyLocalization.of(context).locale == Locale("en", "US")
              ?valuEnglish
              : valuArabaic),
          actions: <Widget>[
            TextButton(
              onPressed: () async{
                print(" close is click ");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
                  ),
                );
               // Navigator.of(context).pop();
              },
              child: Text( EasyLocalization.of(context).locale == Locale("en", "US")
                  ?"Close"
                  : "اغلاق",style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4f2565),
                  fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }


  void showAlertDialogToConfirmChangePackage(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale ==
            Locale("en", "US")
            ?"The amount is " +amount +" "+"JD"
            :  " "+"المبلغ المطلوب هو"+amount+"د.أ" ,
        style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold),),
      actions: [
        // You can add buttons here
        TextButton(
          onPressed: () {
            setState(() {
              submitted=false;
              confirm=false;
              changePackagee=false;
            });
            Navigator.pop(context);
          },
          child: Text("Postpaid.Cancel".tr().toString(),style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4f2565),
              fontWeight: FontWeight.bold),),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              confirm=true;
              changePackagee=true;
              isLoading=true;
            });
            signature_contract();
          },
          child: Text("changePackage.Confirm".tr().toString(),style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4f2565),
              fontWeight: FontWeight.bold),),
        ),
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }









  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //tooltip: 'Menu Icon',
              onPressed: () async{
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        changePackage(
                            Permessions, role, outDoorUserName),
                  ),
                );

            /*   SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        changePackage(
                            Permessions, role, outDoorUserName),
                  ),
                );*/



                // Navigator.pop(context);
              },
            ),
            centerTitle:false,
            title: Text(
              "Postpaid.contract_details".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: Stack(
            children: [
              ListView(
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

                  signatureImageBase64 !=null?
                  Container(
                      height: 48,
                      width: 300,
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        color: btnDisabled==true?Color(0xFF4f2565).withOpacity(0.6)  :Color(0xFF4f2565),
                      ),
                      child: TextButton(
                        onPressed:btnDisabled==true?null: () async {
                          setState(() {
                            isLoading=true;
                            submitted=true;
                            btnDisabled=true;
                          });
                          signature_contract();
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

              ),
              Visibility(
                visible: isLoading, // Adjust the condition based on when you want to show the overlay
                child: Container(
                  color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                  width: double.infinity,
                  height: double.infinity,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF392156),
                    ),
                  ),
                ),
              ),
            ],
          )
      ),
    );

  }
}