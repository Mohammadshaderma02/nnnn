import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_Contract.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/GSM/Contract/GSM_Contract.dart';
import 'package:shared_preferences/shared_preferences.dart';

//import 'GSM_JordainianCustomerInformation.dart';
//import 'GSM_NonJordainianCustomerInformation.dart';

class GSM_ContractDetails extends StatefulWidget {
  var ID;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  final String FileEPath;
  final bool isJordainian;
  final String msisdn;
  final String nationalNumber;
  final String packageCode;
  final userName;
  final referenceNumber;
  final referenceNumber2;
  final isMigrate;
  final mbbMsisdn;
  final buildingCode;
  final frontImg;
  final backImg;
  final locationImg;

  final password;
  final marketType;

  final passportNumber;
  final firstName;
  final secondName;
  final thirdName;
  final lastName;
  final birthdate;
  final passprotImg;
  final  extraFreeMonths;
  final  extraExtender;

  final simCard;
  final contractImageBase64;
  final note;
  final militaryID;
  final scheduledDate;
  final  isClaimed;
  final onBehalfUser;
  final resellerID;
  final countryId;
  final homeInternetSpecialPromo;

  GSM_ContractDetails(
      {  this.ID,this.Permessions, this.role,this.outDoorUserName, this.FileEPath,
        this.isJordainian,this.marketType,this.packageCode,
        this.msisdn,this.nationalNumber,
        this.passportNumber,this.userName,this.password,
        this.firstName,this.secondName,this.thirdName,this.lastName,this.birthdate,
        this.referenceNumber,this.referenceNumber2,
        this.isMigrate,this.mbbMsisdn,this.frontImg,this.backImg,
        this.passprotImg,this.locationImg, this.buildingCode
        , this.extraFreeMonths,this.extraExtender,this.simCard,
        this.contractImageBase64,this.note, this.militaryID,this.scheduledDate,this.isClaimed,this.onBehalfUser,this.resellerID,this.countryId,this.homeInternetSpecialPromo
      }
      );

  @override
  _GSM_ContractDetailsState createState() => _GSM_ContractDetailsState(
    this.ID,
      this.Permessions,this.role,this.outDoorUserName,  this.FileEPath,
      this.isJordainian,this.marketType,this.packageCode,
      this.msisdn,this.nationalNumber,
      this.passportNumber,this.userName,this.password,
      this.firstName,this.secondName, this.thirdName,this.lastName,this.birthdate,
      this.referenceNumber,this.referenceNumber2,
      this.isMigrate,this.mbbMsisdn,this.frontImg,this.backImg,
      this.passprotImg,this.locationImg,this.buildingCode,
      this.extraFreeMonths,this.extraExtender,this.simCard,
      this.contractImageBase64,this.note,this.militaryID,this.scheduledDate,this.isClaimed,this.onBehalfUser,this.resellerID,this.countryId,this.homeInternetSpecialPromo

  );
}

class _GSM_ContractDetailsState extends State<GSM_ContractDetails> {
  var ID;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  final String FileEPath;
  final bool isJordainian;
  final String msisdn;
  final String nationalNumber;
  final String packageCode;
  final userName;
  final referenceNumber;
  final referenceNumber2;
  final isMigrate;
  final mbbMsisdn;
  final buildingCode;
  final frontImg;
  final backImg;
  final locationImg;

  final password;
  final marketType;

  final passportNumber;
  final firstName;
  final secondName;
  final thirdName;
  final lastName;
  final birthdate;
  final passprotImg;

  final  extraFreeMonths;
  final  extraExtender;

  final simCard;
  final contractImageBase64;
  final note;
  final militaryID;
  final scheduledDate;
  final  isClaimed;
  final onBehalfUser;
  final resellerID;
  final countryId;
  final homeInternetSpecialPromo;

  _GSM_ContractDetailsState( this.ID,this.Permessions,this.role,this.outDoorUserName,  this.FileEPath,
      this.isJordainian,this.marketType,this.packageCode,
      this.msisdn,this.nationalNumber,
      this.passportNumber,this.userName,this.password,
      this.firstName,this.secondName,this.thirdName,this.lastName,this.birthdate,
      this.referenceNumber,this.referenceNumber2,
      this.isMigrate,this.mbbMsisdn,this.frontImg,this.backImg,
      this.passprotImg,this.locationImg,this.buildingCode,
      this.extraFreeMonths,this.extraExtender,this.simCard,
      this.contractImageBase64,this.note,this.militaryID,this.scheduledDate,this.isClaimed,this.onBehalfUser,this.resellerID, this.countryId,
      this.homeInternetSpecialPromo
      );

  APP_URLS urls = new APP_URLS();
  bool _isLoading = true;
  String localPath;
  bool isAgree = false;

  int pages = 0;
  int currentPage = 0;
  bool isReady = false;
  String errorMessage = '';
  final Completer<PDFViewController> _controller =
  Completer<PDFViewController>();


  // Load from assets

  //final GlobalKey<SfPdfViewerState> _pdfViewerKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    print(msisdn);
    print(nationalNumber);
    print(packageCode);
    print(marketType);

    print(userName);
    print(password);
    print('FileEPath');
    print('here');
    print(simCard);
    print(FileEPath);

    setState(() {
      localPath = FileEPath;
    });
    /* ApiServiceProvider.loadPDF().then((value) {
      setState(() {
        localPath = value;
      });
    });*/
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
                  builder: (context) => GSM_Contract( ID:ID,Permessions: Permessions,role:role,outDoorUserName:outDoorUserName,FilePath: FileEPath,
                    isJordainian:isJordainian,marketType:marketType,
                    packageCode:packageCode,msisdn: msisdn, nationalNumber:nationalNumber,
                    passportNumber: passportNumber, userName:userName,password:password,firstName: firstName,
                    secondName: secondName, thirdName: thirdName, lastName: lastName,birthdate: birthdate,
                    referenceNumber:referenceNumber,
                    referenceNumber2:referenceNumber2,isMigrate:isMigrate,mbbMsisdn:mbbMsisdn,
                    frontImg:frontImg, backImg:backImg,passprotImg: passprotImg,
                    locationImg:locationImg ,buildingCode:buildingCode,
                    extraFreeMonths:extraFreeMonths,extraExtender:extraExtender,
                    simCard: simCard,
                    contractImageBase64:contractImageBase64,
                    note:note,
                    militaryID:militaryID,
                    scheduledDate:scheduledDate,
                    isClaimed:isClaimed,
                    onBehalfUser:onBehalfUser,
                    resellerID:resellerID,
                    countryId:countryId,
                      homeInternetSpecialPromo:homeInternetSpecialPromo



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

                  : Center(
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
              /*Text(pages.toString()+'/'+currentPage.toString()),*/
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
          )),
    );
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
