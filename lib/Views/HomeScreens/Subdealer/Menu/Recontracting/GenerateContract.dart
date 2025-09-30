import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recontracting/CustomerInformation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_pdfview/flutter_pdfview.dart';
import '../../../../../Shared/BaseUrl.dart';
import '../../../../ReusableComponents/requiredText.dart';

APP_URLS urls = new APP_URLS();

class GenerateContract extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var msisdn;
  var recontractingKey;
  var optionId;
  var optionName;
  var orderId;
   GenerateContract( this.Permessions, this.role, this.outDoorUserName,this.msisdn,this.recontractingKey,this.optionId,this.optionName,this.orderId);

  @override
  State<GenerateContract> createState() => _GenerateContractState(this.Permessions, this.role, this.outDoorUserName,this.msisdn,this.recontractingKey,this.optionId,this.optionName,this.orderId);
}

class _GenerateContractState extends State<GenerateContract> {
  _GenerateContractState(this.Permessions, this.role, this.outDoorUserName,this.msisdn,this.recontractingKey,this.optionId,this.optionName,this.orderId);
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var msisdn;
  var recontractingKey;
  var optionId;
  var optionName;
  var orderId;

  String localPath;
  bool isAgree = false;

  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  bool getContract=false;

  final Completer<PDFViewController> _controller = Completer<PDFViewController>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    GenerateContract_API();

  }
  Future<void> _showAlertDialogErorr(BuildContext context,valuEnglish,valuArabaic) async {
    return showDialog<void>(
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
                // Close the AlertDialog
                Navigator.of(context).pop();
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

  GenerateContract_API() async {
    setState(() {
      getContract =true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/recontracting/generate';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn,
      "recontractingType":recontractingKey,
      "optionId": optionId,
      "optionName": optionName
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

    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      setState(() {
        getContract =false;
       // checkPackagesList=false;

       // checkOptions=false;
      //  emptyMAISDN=false;
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
            getContract =false;
          //  checkPackagesList=false;

           // checkOptions=false;
          //  emptyMAISDN=false;
          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no data available"
                      : "لا توجد بيانات متاحة")));
        }

        if (result["data"] != null ) {

          var dir = await getApplicationDocumentsDirectory();
          File file = new File("${dir.path}/data.pdf");
          Uint8List decodedbybase64 = base64Decode(result["data"]["contractBase64"]);
          print(decodedbybase64);
          file.writeAsBytesSync(decodedbybase64, flush: true);

          setState(() {
            localPath=file.path;
            getContract =false;

          });

          print("******start****");


        }

      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          getContract =false;

        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        getContract =false;

      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  Widget buildIsAgree() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: isAgree,
            onChanged: (value) {
              changeSwitchedAgree(value);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      CustomerInformation(
                        Permessions,
                        role,
                        outDoorUserName,
                        msisdn,
                        recontractingKey,
                        optionId,
                        optionName,
                          orderId

                  ),
                ),
              );
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF4f2565),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "Postpaid.i_agree".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  void changeSwitchedAgree(value) async {
    setState(() {
      isAgree = !isAgree;
    });
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
                "DashBoard_Form.Edit_contract_details".tr().toString(),
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body:Container(
              color: Colors.white,
              child: Column(children: <Widget>[
                localPath != null ?
                Expanded(
                  child: PDFView(
                    filePath: localPath,
                    enableSwipe: true,
                    swipeHorizontal: false,
                    autoSpacing: true,
                    pageFling: true,
                    pageSnap: true,
                    defaultPage: currentPage,
                    fitPolicy: FitPolicy.BOTH,
                    preventLinkNavigation:
                    false, // if set to true the link is handled in flutter
                    onRender: (_pages) {
                      setState(() {
                        pages = _pages;
                        isReady = true;
                      });
                    },
                    onError: (error) {
                      setState(() {
                        errorMessage = error.toString();
                      });
                      print(error.toString());
                    },
                    onPageError: (page, error) {
                      setState(() {
                        errorMessage = '$page: ${error.toString()}';
                      });
                      print('$page: ${error.toString()}');
                    },
                    onViewCreated: (PDFViewController pdfViewController) {
                      _controller.complete(pdfViewController);
                    },
                    onLinkHandler: (String uri) {
                      print('goto uri: $uri');
                    },
                    onPageChanged: (int page, int total) {
                      print('page change: $page/$total');
                      setState(() {
                        currentPage = page;
                      });
                    },
                  ),


                )

                    : Container(),
                getContract==true?  Center(
                    child: Container(
                      padding: EdgeInsets.only(top: 10),
                      child: Center(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xFF4f2565)),
                              ),
                              SizedBox(
                                height: 20,
                              ),
                              Text(
                                "DashBoard_Form.loading".tr().toString(),
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              )
                            ]),
                      ),
                    )):Container(),

                localPath != null
                    ? Container(
                  height: 60,
                  padding: EdgeInsets.only(right: 15, left: 15, top: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                  ),
                  child: Column(
                    children: [
                      buildIsAgree(),
                    ],
                  ),
                )
                    : Container(),

                SizedBox(height: 50),
              ]),
            )


        ));
  }
}
