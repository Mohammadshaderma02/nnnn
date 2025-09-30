//ChangePackage_ContractDetails.dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/ChangePackage/ChangePackage_SignatureContract.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/ChangePackage/changePackage.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_Contract.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_Contract.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:typed_data';

class ChangePackage_ContractDetails extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var FileEPath;
  var msisdn;
  var packageId;
  var actionTime;
  var confirm;
  var changePackagee;


  ChangePackage_ContractDetails(
      {  this.Permessions,
        this.role,
        this.outDoorUserName,
        this.FileEPath,
        this.msisdn,
        this.packageId,
        this.actionTime,
        this.confirm,
        this.changePackagee

      }
      );

  @override
  _ChangePackage_ContractDetailsState createState() => _ChangePackage_ContractDetailsState(
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.FileEPath,
       this.msisdn,
     this.packageId,
      this.actionTime,
      this.confirm,
      this.changePackagee

  );
}

class _ChangePackage_ContractDetailsState extends State<ChangePackage_ContractDetails> {
  DateTime backButtonPressedTime;

  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var FileEPath;
  var  msisdn;
  var packageId;
  var actionTime;
  var confirm;
  var changePackagee;



  _ChangePackage_ContractDetailsState(
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.FileEPath,
      this.msisdn,
      this.packageId,
      this.actionTime,
      this.confirm,
      this.changePackagee
      );

  APP_URLS urls = new APP_URLS();
  bool _isLoading = true;
  String localPath;
  File fileContract;
  bool isAgree = false;
  bool isAgreeRental=false;

  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  final Completer<PDFViewController> _controller = Completer<PDFViewController>();



  @override
  void initState() {
    super.initState();
    showContract();


  }

  void showContract()async{
    /*...................................For Contract File...................................*/
    var dir = await getApplicationDocumentsDirectory();
    fileContract = new File("${dir.path}/data.pdf");
    Uint8List decodedbytes1 = base64Decode(this.FileEPath);
    fileContract.writeAsBytesSync(decodedbytes1, flush: true);

    setState(() {
      localPath = fileContract.path;
    });
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
                  builder: (context) => ChangePackage_SignatureContract(
                      Permessions: Permessions,
                      role:role,
                      outDoorUserName:outDoorUserName,
                      FilePath: localPath,
                      msisdn: msisdn,
                      packageId:packageId,
                      actionTime:actionTime,
                      confirm:confirm,
                      changePackagee:changePackagee


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
    return  GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),

      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              //tooltip: 'Menu Icon',
              onPressed: () async{
               // Navigator.pop(context);
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        changePackage(
                            Permessions, role, outDoorUserName),
                  ),
                );

              },
            ),
            centerTitle:false,
            title: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Change Package Contract"
                    : "عقد تغيير الحزمة"
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
    );
  }
}



