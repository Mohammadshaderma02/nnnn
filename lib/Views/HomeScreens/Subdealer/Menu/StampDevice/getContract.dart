import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_Contract.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_Contract.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/StampDevice/ContractSignature.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

class getContract extends StatefulWidget {
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

  getContract(
      {  this.Permessions,
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

      }
      );

  @override
  _getContractState createState() => _getContractState(
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
      this.documentExpiryDate

  );
}

class _getContractState extends State<getContract> {
  DateTime backButtonPressedTime;

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


  _getContractState(
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
      this.documentExpiryDate
      );

  APP_URLS urls = new APP_URLS();
  bool _isLoading = true;

  File fileContract;
  bool isAgree = false;
  bool isAgreeRental=false;

  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  bool isLoading=false;
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();


  // Load from assets

  //final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();

    print(documentExpiryDate);


  }
/*........................................Switch Button for Contract File.......................................*/
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
                  builder: (context) => ContractSignature(
                      Permessions: Permessions,
                      outDoorUserName:outDoorUserName,
                      msisdn:msisdn,
                      serialNumber:serialNumber,
                      selectedResellerkey:selectedResellerkey,
                      localPath:localPath,
                      isJordanian: isJordanian,
                      frontIdImageBase64: frontIdImageBase64,
                      backIdImageBase64: backIdImageBase64,
                      passportImageBase64: passportImageBase64,
                      documentExpiryDate: documentExpiryDate

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
/*.............................................................................................................*/



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



  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);

      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),

      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
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
          body: Container(
            color: Colors.white,
            child:
            Column(children: <Widget>[
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
                  :
              Center(
                  child: Container(
                    padding: EdgeInsets.only(top: 10),
                    child:  isLoading==true? Center(
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
                    ): Center(
                      child:  Column(
                        children: [
                          SizedBox(
                            height: 100,
                          ),
                          Text(

                            "No data found",
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          )
                        ],
                      )
                    ),
                  )),

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
      ),
    ), onWillPop: onWillPop);
  }
}


class ApiServiceProvider {
  static final String BASE_URL = "https://www.kindacode.com/wp-content/uploads/2021/07/test.pdf";

  static Future<String> loadPDF() async {
    var response = await http.get(Uri.parse(BASE_URL));
    var dir = await getApplicationDocumentsDirectory();
    File file = new File("${dir.path}/data.pdf");
    file.writeAsBytesSync(response.bodyBytes, flush: true);
    return file.path;
  }
}
