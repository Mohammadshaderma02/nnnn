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
import '../../../../../ReusableComponents/requiredText.dart';
import '../../../CustomBottomNavigationBar.dart';


class EVD_Wallet extends StatefulWidget {
  final List<dynamic> Permessions;
  var msisdn;
  var kitCode;
  var paymentMethod;
  EVD_Wallet({this.Permessions,this.msisdn,this.kitCode,this.paymentMethod});

  @override
  _EVD_WalletState createState() => _EVD_WalletState(this.Permessions,this.msisdn,this.kitCode,this.paymentMethod);
}

class _EVD_WalletState extends State<EVD_Wallet> {
  APP_URLS urls = new APP_URLS();
  final List<dynamic> Permessions;
  var msisdn;
  var kitCode;
  var paymentMethod;
  _EVD_WalletState(this.Permessions,this.msisdn,this.kitCode,this.paymentMethod);
  bool response= false;
  List  edv_Wallets=[];
  bool checkWalletsList=false;
  bool emptyMerchantId = false;
  bool emptyTerminalId = false;

  String get_operationReference;
  bool emptyOTP = false;
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
    print("......getListOfWallests_API");

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


//this is to get otp that sent to number
  void extendValidityOTP_API(token) async {
    print("/extend-validity/initalize");
    setState(() {
      isLoading=true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lines/extend-validity/initalize';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    var  boody={
      "msisdn": this.msisdn,
      "kitCode": this.kitCode,
      "paymentMethod": "2",
      "token": token
    };
    print(boody);

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body:jsonEncode({
        "msisdn": this.msisdn,
        "kitCode": this.kitCode,
        "paymentMethod": "2",
        "token": token
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
      if (result["data"] == null) {}
      if (result["status"] == 0) {
        setState(() {
          get_operationReference =result["data"]["operationReference"];
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
                      Extend_Validity();

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

        });
      }

      return result;
    } else {
      showErroreAlertDialog(context,statusCode.toString(),statusCode.toString());
      setState(() {
        isLoading=false;
      });
    }
  }






  Extend_Validity ()async{

    setState(() {
      isLoading=true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "msisdn": this.msisdn,
      "kitCode": this.kitCode,
      "paymentMethod": "2",
      "operationReference": get_operationReference,
      "otp": otp.text
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Lines/extend-validity';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if(statusCode==401 ){
      print('401  error ');

      setState(() {
         isLoading =false;
      });

    }
    if (statusCode == 200) {
      setState(() {
        isLoading=false;
      });
      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('-------------------------------');
      print(result["data"]);

      if( result["status"]==0){

        showToast(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? result['message']
                : result['messageAr'],
            context: context,
            animation: StyledToastAnimation.scale,
            fullWidth: true);
        Navigator.pop(
          context,
        );
      }else{

        setState(() {
          isLoading=false;
        });
        showErroreAlertDialog(context,result["messageAr"], result["message"]);

      }

      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL +'/Lines/extend-validity');

      return result;
    }else{
      setState(() {
        isLoading=false;
      });
      showErroreAlertDialog(context,statusCode, statusCode);

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
                : "EVD محفظة",
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
                     // padding: EdgeInsets.only(top: 8),
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 0),
                          child: Column(
                            children: <Widget>[
                              SizedBox(height: 10),
                              Container(
                                padding: EdgeInsets.only(bottom: 8),
                                child: ListView.builder(
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  itemCount: edv_Wallets.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      color: Colors.white,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: index != edv_Wallets.length - 1 ? 95 : 100,
                                            child: ListTile(
                                              title: Text(
                                                EasyLocalization.of(context).locale == Locale("en", "US")
                                                    ? 'EVD Number '+index.toString()
                                                    : "رقم EVD" +" "+index.toString(),
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
                                                      Text(EasyLocalization.of(context).locale == Locale("en", "US")
                                                          ? 'Merchant ID '
                                                          : " رقم التاجر" ,),
                                                      SizedBox(width: 10,),
                                                      Text(edv_Wallets[index]["merchantId"])
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Text(EasyLocalization.of(context).locale == Locale("en", "US")
                                                          ? 'Terminal ID  '
                                                          : " رقم التاجر" ,),
                                                      SizedBox(width: 10,),
                                                      Text(edv_Wallets[index]["terminalId"])
                                                    ],
                                                  ),
                                                  SizedBox(height: 5,),
                                                  Row(
                                                    children: [
                                                      Text(EasyLocalization.of(context).locale == Locale("en", "US")
                                                          ? 'Add Date '
                                                          : " تاريخ الاضافة" ,),
                                                      SizedBox(width: 10,),
                                                      Text(edv_Wallets[index]["addDate"])

                                                    ],
                                                  ),
                                                  SizedBox(height: 20,)
                                                ],
                                              ),
                                              trailing: IconButton(
                                                icon: EasyLocalization.of(context).locale == Locale("en", "US")
                                                    ? Icon(Icons.keyboard_arrow_right)
                                                    : Icon(Icons.keyboard_arrow_left),
                                              ),
                                              onTap: () {
                                                print("yes");
                                                extendValidityOTP_API(edv_Wallets[index]["token"]);

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