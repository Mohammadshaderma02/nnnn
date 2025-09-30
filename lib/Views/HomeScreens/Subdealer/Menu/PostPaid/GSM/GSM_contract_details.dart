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
import 'package:shared_preferences/shared_preferences.dart';

import 'GSM_JordainianCustomerInformation.dart';
import 'GSM_NonJordainianCustomerInformation.dart';

class ContractDetails extends StatefulWidget {
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
  final documentExpiryDate;
  final countryId;

  ContractDetails(
  {  this.Permessions, this.role,this.outDoorUserName, this.FileEPath,
    this.isJordainian,this.marketType,this.packageCode,
    this.msisdn,this.nationalNumber,
    this.passportNumber,this.userName,this.password,
    this.firstName,this.secondName,this.thirdName,this.lastName,this.birthdate,
    this.referenceNumber,this.referenceNumber2,
    this.isMigrate,this.mbbMsisdn,this.frontImg,this.backImg,
    this.passprotImg,this.locationImg, this.buildingCode
    , this.extraFreeMonths,this.extraExtender,this.simCard,
    this.contractImageBase64,
    this.note,
    this.militaryID,
    this.scheduledDate,
    this.isClaimed,
    this.onBehalfUser,
    this.resellerID,
    this.documentExpiryDate,
    this.countryId

  }
      );

  @override
  _ContractDetailsState createState() => _ContractDetailsState(
      this.Permessions,this.role,this.outDoorUserName,  this.FileEPath,
      this.isJordainian,this.marketType,this.packageCode,
      this.msisdn,this.nationalNumber,
      this.passportNumber,this.userName,this.password,
      this.firstName,this.secondName, this.thirdName,this.lastName,this.birthdate,
      this.referenceNumber,this.referenceNumber2,
      this.isMigrate,this.mbbMsisdn,this.frontImg,this.backImg,
      this.passprotImg,this.locationImg,this.buildingCode,
      this.extraFreeMonths,this.extraExtender,this.simCard,
      this.contractImageBase64,
      this.note,this.militaryID,this.scheduledDate,this.isClaimed,
      this.onBehalfUser,
       this.resellerID,
      this.documentExpiryDate,
    this.countryId


      );
}

class _ContractDetailsState extends State<ContractDetails> {
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
  final documentExpiryDate;
  final countryId;

  _ContractDetailsState( this.Permessions,this.role,this.outDoorUserName,  this.FileEPath,
      this.isJordainian,this.marketType,this.packageCode,
      this.msisdn,this.nationalNumber,
      this.passportNumber,this.userName,this.password,
      this.firstName,this.secondName,this.thirdName,this.lastName,this.birthdate,
      this.referenceNumber,this.referenceNumber2,
      this.isMigrate,this.mbbMsisdn,this.frontImg,this.backImg,
      this.passprotImg,this.locationImg,this.buildingCode,
      this.extraFreeMonths,this.extraExtender,this.simCard,
      this.contractImageBase64,this.note,this.militaryID,
      this.scheduledDate,
      this.isClaimed,
      this.onBehalfUser,
      this.resellerID,
      this.documentExpiryDate,
      this.countryId
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
// Add a flag to control PDF view rendering
  bool _shouldRenderPDF = false;
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
    localPath = FileEPath;
    /*setState(() {
      localPath = FileEPath;
    });*/
    // Delay PDF rendering slightly to ensure the view is properly set up
    Future.delayed(Duration(milliseconds: 300), () {
      if (mounted) {
        setState(() {
          _shouldRenderPDF = true;
        });
      }
    });

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
                  builder: (context) => Contract(Permessions: Permessions,role:role,outDoorUserName:outDoorUserName,FilePath: FileEPath,
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
                      documentExpiryDate:documentExpiryDate,
                      countryId:countryId



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

// Simple check if file exists
  Future<bool> checkFileExists(String path) async {
    try {
      File file = File(path);
      return await file.exists();
    } catch (e) {
      print("Error checking file: $e");
      return false;
    }
  }

  @override
  void dispose() {
    // No need to dispose the controller since PDFViewController doesn't have dispose
    // Just reset our state properly
    super.dispose();
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
              localPath != null &&  _shouldRenderPDF?
              Expanded(
               child: PDFView(
                 key: ValueKey("pdf_view_${DateTime.now().millisecondsSinceEpoch}"),

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



