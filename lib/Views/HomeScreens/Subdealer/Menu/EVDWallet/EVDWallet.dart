//EVD_Wallet.dart

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/contract_details.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_Package.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/FTTHpackage.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_block.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';


import '../../../../../../Shared/BaseUrl.dart';
import '../../../../ReusableComponents/requiredText.dart';
import '../../CustomBottomNavigationBar.dart';


class EVDWallet extends StatefulWidget {

  EVDWallet();

  @override
  _EVDWalletState createState() => _EVDWalletState();
}

class _EVDWalletState extends State<EVDWallet> {
  APP_URLS urls = new APP_URLS();

  _EVDWalletState();
  bool response= false;
  List  edv_Wallets=[];
  bool checkWalletsList=false;
  bool emptyMerchantId = false;
  bool emptyTerminalId = false;
  bool emptyOTP = false;
  var operationReference;

  bool isLoading=false;

  TextEditingController merchantId = TextEditingController();
  TextEditingController terminalId = TextEditingController();
  TextEditingController otp = TextEditingController();



  @override
  void initState() {
    getListOfWallests_API();
    super.initState();
  }


  void getListOfWallests_API() async{

    setState(() {
      merchantId.text='';
      terminalId.text='';
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/EVDWallets/active';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(access);

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },

    );
    int statusCode = response.statusCode;
    var data = response.request;
    print(data);
    print(statusCode);

    if (statusCode == 401) {
      print('401  error ');

    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);
      print(result);


      if (result["status"] == 0) {
        if(result["data"].length ==0){
          setState(() {
            checkWalletsList=true;
          });

        }
        if(result["data"].length !=0){
          setState(() {
            checkWalletsList=false;
            edv_Wallets = result["data"];
          });
        }

        print("/********************************************************************/");

        print(edv_Wallets);
        print("/********************************************************************/");

      } else {
        //  showErroreAlertDialog(context, result["messageAr"], result["message"]);
        setState(() {

        });
      }

      return result;
    }
    else {
      setState(() {

      });
      // showErroreAlertDialog(context,statusCode, statusCode);

    }

  }

  Widget enter_merchantId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Merchant ID",
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
            controller: merchantId,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMerchantId== true
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
              hintText: "xxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }

  Widget enter_terminalId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Terminal ID",
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
            controller: terminalId,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyTerminalId== true
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
              hintText: "xxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),

          ),
        )
      ],
    );
  }


  void addNewWallet_API() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/EVDWallets/add';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    var  boody={
      "merchantId": merchantId.text,
      "terminalId": terminalId.text
    };

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body:jsonEncode({
        "merchantId": merchantId.text,
        "terminalId": terminalId.text
      }),
    );
    print(boody);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      //showErroreAlertDialog(context,"401","401");
      setState(() {
        isLoading=false;
      });

    }
    if (statusCode == 200) {
      setState(() {
        isLoading=false;
      });
      var result = json.decode(response.body);
      print(result["data"]);

      if (result["status"] == 0) {

        setState(() {
          operationReference=result["data"];
              });


        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return StatefulBuilder(
              builder: (context, setState) {
                Widget SubmitButton = TextButton(
                  child: Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? 'SUBMIT'
                        : 'ارسال',
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async{
                    if (otp.text =="") {
                      setState(() {
                        emptyOTP = true;
                        isLoading=false;
                      });
                    }

                    if (otp.text !="") {

                      setState(() {
                        isLoading = true;
                        emptyOTP = false;

                      });
                      Navigator.of(context).pop();
                      confirnAddNewWallet_API();

                    }
                  },
                );
                Widget cancelButton = TextButton(
                  child: Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? 'CANCEL'
                        : 'إلغاء',
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      fontSize: 16,
                    ),
                  ),
                  onPressed: () async{
                    setState(() {
                      otp.text='';
                      isLoading=false;
                    });
                    Navigator.of(context).pop();
                    // msisdn.clear();
                    // kitCode.clear();
                  },
                );

                return AlertDialog(
                  title: Text(
                    "CustomerService.verify_code".tr().toString(),
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: otp,
                              keyboardType: TextInputType.phone,
                              decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                                ),
                                border: const OutlineInputBorder(),
                                focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(color: Color(0xFF4F2565), width: 1.0),
                                ),
                                contentPadding: EdgeInsets.all(16),
                                hintText: "CustomerService.verify_hint".tr().toString(),
                                hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                              ),
                            ),
                          ),



                        ],
                      ),

                      SizedBox(height: 20),
                      if (emptyOTP)
                        Row(
                          children: [

                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? 'Please enter otp that sent'
                                  : "الرجاء ادخال رمز التحقق المرسل",
                              style: TextStyle(color: Colors.red, fontSize: 14),
                            ),
                          ],
                        ),

                    ],
                  ),
                  actions: [cancelButton, SubmitButton],
                );
              },
            );
          },
        );




      } else {

        showErroreAlertDialog(context,result["messageAr"],result["message"]);
        setState(() {
          merchantId.text='';
          terminalId.text='';
        });
      }

      return result;
    } else {
      showErroreAlertDialog(context,statusCode.toString(),statusCode.toString());
      setState(() {
        merchantId.text='';
        terminalId.text='';
        isLoading=false;
      });
    }
  }

  void confirnAddNewWallet_API() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/EVDWallets/confirmAdd';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    var  boody={
      "merchantId": merchantId.text,
      "terminalId": terminalId.text,
      "operationReference": operationReference,
      "otp":otp.text
    };

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body:jsonEncode({
        "merchantId": merchantId.text,
        "terminalId": terminalId.text,
        "operationReference": operationReference,
        "otp": otp.text
      }),
    );
    print(boody);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      //showErroreAlertDialog(context,"401","401");
      setState(() {
        isLoading=false;
      });

    }
    if (statusCode == 200) {
      setState(() {
        isLoading=false;
      });
      var result = json.decode(response.body);
      print(result["data"]);

      if (result["status"] == 0) {



        getListOfWallests_API();


      } else {
        showErroreAlertDialog(context,result["messageAr"],result["message"]);
        setState(() {
          merchantId.text='';
          terminalId.text='';
        });
      }

      return result;
    } else {
      showErroreAlertDialog(context,statusCode.toString(),statusCode.toString());
      setState(() {
        merchantId.text='';
        terminalId.text='';
        isLoading=false;
      });
    }
  }

  void deleteWallet_API(token) async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/EVDWallets/remove/${token}';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");


    final response = await http.delete(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      }
    );

    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      //showErroreAlertDialog(context,"401","401");
      setState(() {
        isLoading=false;
      });

    }
    if (statusCode == 200) {
      setState(() {
        isLoading=false;
      });
      var result = json.decode(response.body);
      print(result["data"]);

      if (result["status"] == 0) {

        getListOfWallests_API();

      } else {
        showErroreAlertDialog(context,result["messageAr"],result["message"]);
        setState(() {
          merchantId.text='';
          terminalId.text='';
        });
      }

      return result;
    } else {
      showErroreAlertDialog(context,statusCode.toString(),statusCode.toString());
      setState(() {
        merchantId.text='';
        terminalId.text='';
        isLoading=false;
      });
    }
  }

  showErroreAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(

        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Cancel'
            : "الغاء",
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {

        Navigator.pop(
          context,
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



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          centerTitle: false,
          title: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'EVD Wallet'
                : "محفظة EVD",
          ),
          backgroundColor: Color(0xFF4f2565),
        ),
        backgroundColor: Color(0xFFEBECF1),
        body: Stack(
          children: [
            // Main Content
            GestureDetector(
              onTap: () => FocusScope.of(context).unfocus(),
              child: Column(
                children: [
                  checkWalletsList == true
                      ? Expanded(
                    child: Center(
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'No wallets found for this MSISDN'
                            : "لم يتم العثور على محافظ لهذا MSISDN",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                  )
                      : Expanded(
                    child: ListView(
                     // padding: EdgeInsets.only(top: 5),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 5),
                              Container(
                                padding: EdgeInsets.only(bottom: 8),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: edv_Wallets.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      height: 120,
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(height: 10,),
                                          SizedBox(
                                            height: index != edv_Wallets.length - 1 ? 90 : 90,
                                            child: ListTile(
                                              title: Text('EVD Number '+index.toString(),
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xFF4f2565),
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                                subtitle:Column(
                                                  children: [
                                                    SizedBox(height: 10,),
                                                    Row(
                                                      children: [
                                                        Text('Merchant ID '),
                                                        SizedBox(width: 10,),
                                                        Text(edv_Wallets[index]["merchantId"])
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Text('Terminal ID  '),
                                                        SizedBox(width: 10,),
                                                        Text(edv_Wallets[index]["terminalId"])
                                                      ],
                                                    ),
                                                    SizedBox(height: 5,),
                                                    Row(
                                                      children: [
                                                        Text('Add Date '),
                                                        SizedBox(width: 10,),
                                                        Text(edv_Wallets[index]["addDate"])

                                                      ],
                                                    ),
                                                  //  SizedBox(height: 100,)
                                                  ],
                                                ),
                                              trailing: Container(
                                                margin: EdgeInsets.only(top: 20),
                                                height: 40,
                                                width: 100,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius: BorderRadius.circular(12),
                                                  border: Border.all(
                                                    color: Colors.red[800], // Border color
                                                    width: 1,
                                                  ),
                                                ),
                                                child: Center(
                                                  child: Text(
                                                    EasyLocalization.of(context).locale == Locale("en", "US")
                                                        ? 'Delete'
                                                        : "حذف",
                                                    style: TextStyle(color: Colors.red[800], fontSize: 12),
                                                  ),
                                                ),
                                              ),/*IconButton(
                                                icon: Icon(Icons.delete_outline, color: Colors.red[800],),
                                                 ),*/
                                              onTap: () {
                                                deleteWallet_API(edv_Wallets[index]["token"]);
                                                setState(() {});
                                              },
                                            ),
                                          ),
                                          index != edv_Wallets.length - 1
                                              ? Divider(
                                            thickness: 1,
                                            color: Color(0xFFedeff3),
                                          )
                                              : Container(),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bottom fixed container
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15),
                    child: Column(
                      children: <Widget>[
                        SizedBox(height: 25),
                        enter_merchantId(),
                        emptyMerchantId
                            ? ReusableRequiredText(
                            text: EasyLocalization.of(context).locale == Locale("en", "US")
                                ? 'This field is required'
                                : "هذا الحقل مطلوب")
                            : Container(),
                        SizedBox(height: 20),
                        enter_terminalId(),
                        emptyTerminalId
                            ? ReusableRequiredText(
                            text: EasyLocalization.of(context).locale == Locale("en", "US")
                                ? 'This field is required'
                                : "هذا الحقل مطلوب")
                            : Container(),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (terminalId.text == "") {
                              setState(() {
                                emptyTerminalId = true;
                              });
                            }
                            if (merchantId.text == "") {
                              setState(() {
                                emptyMerchantId = true;
                              });
                            }
                            if (terminalId.text.isNotEmpty && merchantId.text.isNotEmpty) {
                              addNewWallet_API();
                              setState(() {
                                isLoading = true;
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4f2565),
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                          child: Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? 'Add New EVD Wallets'
                                : "اضافة محفظة جديده",
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        SizedBox(height: 15),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            // Overlay Layer
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF4f2565),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

}