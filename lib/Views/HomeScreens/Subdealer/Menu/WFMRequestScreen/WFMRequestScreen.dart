import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recontracting/GenerateContract.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'dart:ui' as ui;
import '../../../../../Shared/BaseUrl.dart';
import '../../../../ReusableComponents/requiredText.dart';

import 'package:sales_app/blocs/PostPaid/GenerateWFMToken/GenerateWFMToken_block.dart';
import 'package:sales_app/blocs/PostPaid/GenerateWFMToken/GenerateWFMToken_events.dart';
import 'package:sales_app/blocs/PostPaid/GenerateWFMToken/GenerateWFMToken_state.dart';

APP_URLS urls = new APP_URLS();

class WFMRequestScreen extends StatefulWidget {
  List<dynamic> Permessions;

  WFMRequestScreen(this.Permessions);

  @override
  State<WFMRequestScreen> createState() => _WFMRequestScreenState(this.Permessions);
}

class _WFMRequestScreenState extends State<WFMRequestScreen> {
  _WFMRequestScreenState(this.Permessions);

  List<dynamic> Permessions;

  TextEditingController msisdn = TextEditingController();
  TextEditingController buildingCode = TextEditingController();
  TextEditingController itemCode = TextEditingController();


  bool emptyMAISDN = false;
  bool emptyBuildingCode = false;
  bool emptyItemCode = false;

  List<String> Value_en = [];
  List<String> Value_ar = [];

  bool sentWFM_request =false;
  bool check5G_MSISDN=false;

  bool isValidate=false;
  bool isSentRequest=false;
  bool showAppointment = false;

  GenerateWFMTokenBlock generateWFMTokenBlock;
  bool generateWFMTokent = false;
  dynamic getURL;
  dynamic getAccessToken;



  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  UnotherizedError() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_logged_in', false);
    prefs.setBool('biomitric_is_logged_in', false);
    prefs.setBool('TokenError', true);
    prefs.remove("accessToken");
    //prefs.remove("userName");
    prefs.remove('counter');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );
  }


  Widget MSISDN_5G() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ?"5G MSISDN":" رقم "+"5G",
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
            controller: msisdn,
            // maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMAISDN== true
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
              contentPadding: EdgeInsets.all(8),
              hintText: "xxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: ()=>{
              setState(() {
                isValidate=false;
                emptyMAISDN=false;
                sentWFM_request =false;
                isSentRequest =false;
                itemCode.text="";
                buildingCode.text="";
              })
            },

          ),
        )
      ],
    );
  }

  Widget buildBuildingCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ?"Building Code":"رمز البناء",
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
            enabled: false,
            controller: buildingCode,
            // maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.text,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:  Color(0xFFD1D7E0),
              enabledBorder:   OutlineInputBorder(
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

  Widget buildItemCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ?"Item Code":"رمز العنصر",
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
            enabled: false,
            controller: itemCode,
            // maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.text,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:  Color(0xFFD1D7E0),
              enabledBorder:   OutlineInputBorder(
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



/*..............................................Dialogs..........................................*/
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

  Future<void> _showAlertDialogSuccess(BuildContext context,valuEnglish,valuArabaic) async {
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
              onPressed: () {
                // Close the AlertDialog
                Navigator.of(context).pop();
                setState(() {
                  sentWFM_request=false;
                  emptyMAISDN=false;
                  emptyBuildingCode= false;
                  emptyItemCode=false;
                });
              },
              child: Text(EasyLocalization.of(context).locale == Locale("en", "US")
                  ?"Close"
                  : "إغلاق",style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4f2565),
                  fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }
  /*..............................................................................................*/

  /*..............................................API's..........................................*/
  submitWFM_request_API() async {
    setState(() {
      sentWFM_request = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/device5G/requestOutdoor';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn.text,
      "itemCode": itemCode.text,
      "buildingCode":buildingCode.text


    };
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),

    );

    print(".............Haya Body ........");
    print(body);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);

    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      setState(() {

        isValidate=false;
        sentWFM_request=false;
        emptyMAISDN=false;
        emptyBuildingCode= false;
        emptyItemCode=false;
        check5G_MSISDN=false;

      });
      print('401  error ');
      UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){


        if( result["data"] !=null){
          setState(() {
            isValidate=true;
            isSentRequest=true;

            showAppointment=result["data"]["showAppointment"];
          });

          if(showAppointment ==true){
            showAlertDialogAppoitment(
                context, " اكتملت العملية بنجاح ،الذهاب لحجز المواعيد",
                "The operation has been successfully completed,Go to appointment");
          }

          if(showAppointment ==false){
            _showAlertDialogSuccess(context,"you can't make appointment","لا تستطيع حجز مواعيد");

          }




        }
        if( result["data"] ==null){
          setState(() {
            isSentRequest=false;
            isValidate=false;
            buildingCode.text="";
            itemCode.text="";
            getURL="";
            showAppointment=false;
          });
          _showAlertDialogSuccess(context,"you can't make appointment","لا تستطيع حجز مواعيد");
        }


      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          isSentRequest=false;
          isValidate=false;
          sentWFM_request=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          msisdn.text='';
          buildingCode.text='';
          itemCode.text='';
          emptyItemCode=false;
          check5G_MSISDN=false;

        });
      }

      return result;
    } else {
      setState(() {

        isValidate=false;
        sentWFM_request=false;
        emptyMAISDN=false;
        emptyBuildingCode = false;
        msisdn.text='';
        buildingCode.text='';
        itemCode.text='';
        emptyItemCode=false;
        check5G_MSISDN=false;

      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  redirectWFM_request_API() async {
    setState(() {
      sentWFM_request = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/ftth/appointment';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": "0799059570",
    };
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),

    );

    print(".............Haya Body ........");
    print(body);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);

    print(response);
    print('body: [${response.body}]');
    var result = json.decode(response.body);

    if (statusCode == 401) {
      setState(() {

        isValidate=false;
        sentWFM_request=false;
        emptyMAISDN=false;
        emptyBuildingCode= false;
        emptyItemCode=false;
        check5G_MSISDN=false;

      });
      print('401  error ');
      UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){


        if( result["data"] !=null){


          setState(() {
            isValidate=true;
            isSentRequest=true;
            getURL=result["data"]["url"] ;
            getAccessToken=result["data"]["accessToken"] ;

          });


          String url = getURL+'?accessToken=' +getAccessToken;
          print('url ${url}');

          var urllaunchable = await canLaunch(url); //canLaunch is from url_launcher package
          if(urllaunchable){
            await launch(url); //launch is from url_launcher package to launch URL
          }else{
            print("URL can't be launched.");
          }


        }
        if( result["data"] ==null){
          setState(() {
            isSentRequest=false;
            isValidate=false;
            buildingCode.text="";
            itemCode.text="";
            getURL="";
            showAppointment=false;
          });
          _showAlertDialogSuccess(context,"No data to show","لا يوجد معلومات لعرضها");
        }


      }
      else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          isSentRequest=false;
          isValidate=false;
          sentWFM_request=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          msisdn.text='';
          buildingCode.text='';
          itemCode.text='';
          emptyItemCode=false;
          check5G_MSISDN=false;

        });
      }

      return result;
    } else {
      setState(() {

        isValidate=false;
        sentWFM_request=false;
        emptyMAISDN=false;
        emptyBuildingCode = false;
        msisdn.text='';
        buildingCode.text='';
        itemCode.text='';
        emptyItemCode=false;
        check5G_MSISDN=false;

      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  check_5G_MSISDN_API() async {

    setState(() {
      check5G_MSISDN= true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/device5G/validateOutdoor';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn.text,
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

        isValidate=false;
        check5G_MSISDN=false;
        sentWFM_request=false;
        emptyMAISDN=false;
        emptyBuildingCode= false;
        emptyItemCode=false;

      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){

        setState(() {
          check5G_MSISDN=false;
          sentWFM_request=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          emptyItemCode=false;
        });
        if( result["data"] !=null){
          setState(() {
            isValidate=true;
            isSentRequest=true;
            buildingCode.text=result["data"]["buildingCode"];
            itemCode.text=result["data"]["itemCode"];
          });
        }
        if( result["data"] ==null){
          setState(() {
            isSentRequest=false;
            isValidate=false;
            buildingCode.text="";
            itemCode.text="";
          });
          _showAlertDialogSuccess(context,"No data found for this MSISDN","لا يوجد معلومات لعرضها لهذا الرقم");
        }


      }
      else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);

       /* ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));*/
        setState(() {
          isSentRequest=false;
          isValidate=false;
          check5G_MSISDN=false;
          sentWFM_request=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          emptyItemCode=false;
          msisdn.text='';
          buildingCode.text='';
          itemCode.text='';

        });
      }

      return result;
    } else {
      setState(() {
        isSentRequest=false;
        isValidate=false;
        check5G_MSISDN=false;
        sentWFM_request=false;
        emptyMAISDN=false;
        emptyBuildingCode = false;
        emptyItemCode=false;
        msisdn.text='';
        buildingCode.text='';
        itemCode.text='';


      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }
  /*.............................................................................................*/


  showAlertDialogAppoitment(BuildContext context, arabicMessage, englishMessage) {
    Widget close = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        Navigator.pop(
          context,
        );

      },
    );
    Widget install = TextButton(
      child: Text(
        "Postpaid.GoAppoitments".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),

      onPressed: ()  async{
        redirectWFM_request_API();
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
        install,
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



  showAlertDialogGenerateWFM(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.cancel".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
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
                EasyLocalization.of(context).locale ==
                    Locale("en", "US")
                    ? "WFM Request Screen":"ختم الجهاز المستأجر",
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body:Stack(
              children: [
                // Your existing Column
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    /*************************************First Container for Enter MSISDN-BuildOutdoorItemCode-BuildBuildingCode************************************/
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          MSISDN_5G(),
                          emptyMAISDN == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.serial_numbe_required"
                                  .tr()
                                  .toString())
                              : Container(),
                          SizedBox(height: 10),
                          isValidate == true?
                          buildBuildingCode():Container(),
                          emptyBuildingCode == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.serial_numbe_required"
                                  .tr()
                                  .toString())
                              : Container(),
                          SizedBox(height: 10),
                          isValidate == true? buildItemCode():Container(),
                          emptyItemCode == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.serial_numbe_required"
                                  .tr()
                                  .toString())
                              : Container(),
                          SizedBox(height: 35),
                          /*.............................Button 5G MSISDN filed to Validate.................................*/
                          isValidate == false?
                          Container(
                              height: 48,
                              width: 510,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFF4f2565),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:Color(0xFF4f2565),
                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                ),
                                onPressed: () async {
                                  /*.................................check MSISDN filed........................................*/
                                  if(msisdn.text.length<1){
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      emptyMAISDN=true;

                                    });
                                  }else{
                                    FocusScope.of(context).unfocus();

                                    setState(() {
                                      emptyMAISDN=false;
                                    });
                                  }

                                  /*.............................check MSISDN filed to Validate.................................*/

                                  if(msisdn.text.length>1){
                                    check_5G_MSISDN_API();

                                  }

                                },

                                child: Text(
                                  EasyLocalization
                                      .of(context)
                                      .locale == Locale("en", "US")
                                      ? 'MSISDN Validate'
                                      : "التحقق من الرقم",
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          ):
                          Container(),
                          /*.............................Button sent sent WFM request.................................*/
                        isSentRequest == true?
                          Container(
                              height: 48,
                              width: 510,
                              margin: EdgeInsets.symmetric(horizontal: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(50),
                                color: Color(0xFF4f2565),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor:Color(0xFF4f2565),
                                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                ),
                                onPressed: () async {

                                  submitWFM_request_API();
                                },

                                child: Text(
                                  EasyLocalization
                                      .of(context)
                                      .locale == Locale("en", "US")
                                      ? 'Submit WFM request'
                                      : "إرسال طلب WFM",
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          ):
                          Container(),

                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    /***********************************************************************************************************************************************/
                    SizedBox(height: 15),

                  ],
                ),

                // Transparent overlay to check MSISDN validate
                Visibility(
                  visible: sentWFM_request, // Adjust the condition based on when you want to show the overlay
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

                Visibility(
                  visible: check5G_MSISDN, // Adjust the condition based on when you want to show the overlay
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


        ));
  }
}
