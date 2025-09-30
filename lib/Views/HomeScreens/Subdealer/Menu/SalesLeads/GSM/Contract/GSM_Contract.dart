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

import '../../../../CustomBottomNavigationBar.dart';
import '../../../Menu.dart';


class GSM_Contract extends StatefulWidget {
  var ID;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  final String FilePath;
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
  final isClaimed;

  dynamic getURL;
  dynamic getAccessToken;
  final onBehalfUser;
  final resellerID;
  final countryId;
  final homeInternetSpecialPromo;



  bool generateWFMTokent = false;

  GSM_Contract(
      {this.ID,this.Permessions,
        this.role,this.outDoorUserName,
        this.FilePath,
        this.msisdn,
        this.isJordainian,
        this.nationalNumber,
        this.userName,
        this.password,
        this.marketType,
        this.packageCode,
        this.referenceNumber,
        this.referenceNumber2,
        this.isMigrate,
        this.mbbMsisdn,
        this.buildingCode,
        this.frontImg,this.backImg,this.locationImg,
        this.passportNumber,
        this.firstName,
        this.secondName,
        this.thirdName,
        this.lastName,
        this.birthdate,this.passprotImg , this.extraFreeMonths,this.extraExtender,
        this.simCard,this.contractImageBase64,this.note,this.militaryID ,this.scheduledDate,this.isClaimed,this.onBehalfUser,this.resellerID,
        this.countryId,this.homeInternetSpecialPromo

      });
//orderID, authCode, last4Digits, receiptImageBase64,
  @override
  _GSM_ContractState createState() =>
      _GSM_ContractState(
        this.ID,
          this.Permessions,
          this.role,
          this.outDoorUserName,
          this.FilePath,
          this.msisdn,
          this.isJordainian,
          this.nationalNumber,
          this.userName,
          this.password,
          this.marketType,
          this.packageCode,
          this.referenceNumber,
          this.referenceNumber2,
          this.isMigrate,
          this.mbbMsisdn,
          this.buildingCode,
          this.frontImg,this.backImg,this.locationImg,

          this.passportNumber,
          this.firstName,
          this.secondName,
          this.thirdName,
          this.lastName,
          this.birthdate,this.passprotImg
          , this.extraFreeMonths,this.extraExtender,
          this.simCard,this.contractImageBase64,this.note, this.militaryID,this.scheduledDate,this.isClaimed,this.onBehalfUser,this.resellerID,this.countryId,this.homeInternetSpecialPromo
      );
}



class _GSM_ContractState extends State<GSM_Contract> {
  var submitted =false;
  var btnDisabled=false;
  var imgBytes;
  var ID;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  final String FilePath;
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
  final isClaimed;
  final onBehalfUser;
  final resellerID;
  final countryId;
  final homeInternetSpecialPromo;
  String signatureImageBase64;
  bool generateWFMTokent = false;
  bool showAppointment=false;
  dynamic getURL;
  dynamic getAccessToken;
  var process=0;
  PostpaidSubmitBloc postpaidSubmitBloc;
  GenerateWFMTokenBlock generateWFMTokenBlock;
  DateTime backButtonPressedTime;

  APP_URLS urls = new APP_URLS();



  _GSM_ContractState(
      this.ID,
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.FilePath,
      this.msisdn,
      this.isJordainian,
      this.nationalNumber,
      this.userName,
      this.password,
      this.marketType,
      this.packageCode,
      this.referenceNumber,
      this.referenceNumber2,
      this.isMigrate,
      this.mbbMsisdn,
      this.buildingCode,
      this.frontImg,this.backImg,this.locationImg,
      this.passportNumber,
      this.firstName,
      this.secondName,
      this.thirdName,
      this.lastName,
      this.birthdate,this.passprotImg
      , this.extraFreeMonths,this.extraExtender,
      this.simCard,this.contractImageBase64,this.note,this.militaryID, this.scheduledDate,this.isClaimed,this.onBehalfUser,this.resellerID,this.countryId,this.homeInternetSpecialPromo
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
    postpaidSubmitBloc= BlocProvider.of<PostpaidSubmitBloc>(context);
    generateWFMTokenBlock = BlocProvider.of<GenerateWFMTokenBlock>(context);
    print('simCard');
    print(simCard);
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
  showAlertDialogSuccess(BuildContext context, arabicMessage, englishMessage,String url) {
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
    Widget install = TextButton(
      child: Text(
        "Postpaid.GoAppoitments".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),

      onPressed: ()  {
        setState(() {
          generateWFMTokent=true;
          generateWFMTokenBlock.add(GetGenerateWFMTokenMSISDN(msisdn: msisdn));

        });
        print(msisdn);
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
  updateLeadsStatus_API() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/TeleSalesAPIs/UpdateLeadsStatus';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "id": this.ID,
      "newStatusId":  110,
      "newStatusReason": "DeliverySuccessful"
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
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      //UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if(result['status'] ==0){

        successfulActivation_API();
        /*  Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
          ),
        );*/

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result["data"]["message"]
                : result["data"]["message"])));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result['message']
                : result['messageAr'])));


      }


      return result;
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }

  successfulActivation_API() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/TeleSalesAPIs/UpdateLeadsStatus';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "id": this.ID,
      "newStatusId":  120,
      "newStatusReason": "SuccessfulActivation"
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
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      //UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if(result['status'] ==0){
        /*  Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
          ),
        );*/

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result["data"]["message"]
                : result["data"]["message"])));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result['message']
                : result['messageAr'])));


      }


      return result;
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return  BlocListener<PostpaidSubmitBloc,PostpaidSubmitState>(
      listener: (context, state) async {
        if (state is PostpaidSubmitErrorState) {
          showAlertDialog(
              context, state.arabicMessage, state.englishMessage);
          setState(() {
            submitted=false;
            btnDisabled=false;
          });
        }

        if (state is PostpaidSubmitSuccessState) {

          print("state.showAppointment");
          print(state.showAppointment);
          setState(() {
            submitted= false;
            btnDisabled=true;
            showAppointment= state.showAppointment;
          });
          updateLeadsStatus_API();
          showAlertDialogSuccess(
              context, " اكتملت العملية بنجاح ، سيتم إرسال نسخة من العقد إلى الرقم المرجعي الخاص بك",
              "The operation has been successfully completed, a copy of the contract will sent to your reference number",state.contractUrl);
        }

        if(state is PostpaidSubmitLoadingState ){
          setState(() {
            submitted=false;
            btnDisabled=true;
          });
        }

      },
      child: WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
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
                                print('sign ${ imageEncoded}');
                                print('lo ${locationImg}');

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

                        onPressed:  () async {
                          print('hellllllllllo');
                          print('sign ${signatureImageBase64}');
                          print('lo ${locationImg}');
                          postpaidSubmitBloc.add(PostpaidSubmitButtonPressed(
                              marketType: marketType,
                              isJordanian: isJordainian,
                              nationalNo: nationalNumber,
                              passportNo: passportNumber,
                              firstName: firstName,
                              secondName: secondName,
                              thirdName:thirdName,
                              lastName: lastName,
                              birthDate:birthdate,
                              msisdn:msisdn,
                              buildingCode:buildingCode,
                              migrateMBB : isMigrate,
                              mbbMsisdn:mbbMsisdn,
                              packageCode:packageCode,
                              username:userName,
                              password:password,
                              referenceNumber:referenceNumber,
                              referenceNumber2: referenceNumber2,
                              frontIdImageBase64:frontImg,
                              backIdImageBase64:backImg,
                              passportImageBase64:passprotImg,
                              signatureImageBase64: signatureImageBase64,
                              locationScreenshotImageBase64:locationImg,
                              extraFreeMonths: extraFreeMonths,
                              extraExtender:extraExtender,
                              simCard: simCard,
                              contractImageBase64:contractImageBase64,
                              isClaimed:isClaimed,
                              note: note,
                              militaryID:militaryID,
                              scheduledDate:scheduledDate,
                              onBehalfUser:onBehalfUser,
                              resellerID:resellerID,
                              countryId:countryId,
                              homeInternetSpecialPromo:homeInternetSpecialPromo

                          ));
                          setState(() {
                            submitted=true;
                            btnDisabled=true;

                          });
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
      ),
    );

  }
}