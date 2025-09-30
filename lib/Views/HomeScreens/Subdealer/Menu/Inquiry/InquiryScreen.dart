import 'dart:async';
import 'dart:convert';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;

import '../../../../ReusableComponents/requiredText.dart';
import '../../../Corporate/Multi_Use_Components/RequiredField.dart';



class InquiryScreen extends StatefulWidget {


  final List<dynamic> Permessions;

InquiryScreen(this.Permessions);

  @override
  State<InquiryScreen> createState() => _InquiryScreenState(this.Permessions);
}

APP_URLS urls = new APP_URLS();
class _InquiryScreenState extends State<InquiryScreen> {
  final List<dynamic> Permessions;

  _InquiryScreenState(this.Permessions);

  DateTime backButtonPressedTime;
  bool isLooding = false;
  TextEditingController msisdnLine = TextEditingController();
  bool emptyMSISDNLine = false;
  bool errorMSISDNLine = false;
  bool checkLine = false;
  var packageName;
  var lineStatus;
  var nextRenewalDate;
  var msRenewalDenomination;
  var newKitCode;

  TextEditingController kitcode = TextEditingController();
  bool checkKitCode=false;
  bool emptyKitCode = false;
  bool errorKitCode = false;


  TextEditingController msisdnBills = TextEditingController();
  bool emptyMSISDNBills = false;
  bool errorMSISDNBills = false;
  bool checkBills = false;
  var totalAmount;
  var reconnectionAmount;
  var reconnectionPercentage;



  TextEditingController postpaidInquiry = TextEditingController();
  bool emptyPostpaidInquiry = false;
  bool errorPostpaidInquiry = false;
  bool checkPostpaidInquiry= false;
  var commitmentPeriod;

  var _packageName;
  var terminationSimulation;




  TextEditingController national = TextEditingController();
  bool emptyNational = false;
  bool errorNational = false;
  bool checkNational = false;
  var hdLst_customerNumber;
  var hdLst_amount;
  var woLst_customerNumber;
  var woLst_amount;
  var hoLst_customerNumber;
  var hoLst_amount;



  List nidLst =[];
  List<dynamic> dues = [];



  TextEditingController promoCode = TextEditingController();
  bool emptyPromoCode=false;
  bool checkPromoCode=false;


  TextEditingController Sim = TextEditingController();
  bool empty_Sim=false;
  bool check_Sim=false;

  TextEditingController MSISDN = TextEditingController();
  bool empty_MSISDN=false;
  bool check_MSISDN=false;

  bool reseller = false;
  var options_Reseller = [];
  var selectedReseller;
  bool emptyselectedReseller = false;

  List<String> Reseller_Value = [];
  var selectedReseller_Value = null;
  var selectedReseller_key;




  @override
  void initState() {

    // TODO: implement initState
    super.initState();
  }

  /******************************************************Check KitCod *******************************************************/
  Widget enterKitCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(

          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            enabled: checkKitCode==true?false:true,
            controller: kitcode,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyKitCode == true || errorKitCode ==true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){
              setState(() {
                errorNational=false;
                emptyNational=false;
                errorMSISDNBills=false;
                emptyMSISDNBills=false;

                 // msisdnBills.text='';
                // national.text='';
              });
            },
            onChanged: (KitCode){


              if (KitCode.length != 0) {
                setState(() {
                  emptyKitCode=false;
                  errorKitCode=true;

                });


              }  if (KitCode.length != 10) {
                setState(() {
                  emptyKitCode=false;
                  errorKitCode=true;

                });


              }
              else {
                setState(() {
                  emptyKitCode=false;
                  errorKitCode=false;
                });
              }
            },
          ),
        ),


      ],
    );
  }

  Widget buildCheckKitCodeBtn() {
    return Column(
        children :[
          checkKitCode==true ?
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFFd4d0d6)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:  Color(0xFF4f2565)))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),):
          ElevatedButton(
            onPressed: () {
              setState(() {
                checkKitCode=true;
              });
              if(kitcode.text =='' ){
                setState(() {
                  emptyKitCode=true;
                  errorKitCode=false;
                  checkKitCode=false;

                });
              }
              else if(kitcode.text.length !=10 ){
                setState(() {
                  errorKitCode=true;
                  emptyKitCode=false;
                  checkKitCode=false;


                });
              }


              if(kitcode.text!='' && kitcode.text.length == 10 ){
                InquiryKitCode();
                setState(() {
                  checkKitCode=true;

                });
              }

            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFF4f2565)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),
          ),]
    );
  }

  void InquiryKitCode()async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Customer360/Prepaid/subscriber/${kitcode.text}';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
     // print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));
      setState(() {
        checkKitCode =false;
      });
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if( result["status"]==0){
        setState(() {
          checkKitCode =false;
        });
        if(result["data"]==null||result["data"].length==0){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString()),backgroundColor: Colors.red));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.Success".tr().toString()),backgroundColor: Colors.green));

          setState(() {

            newKitCode=result["data"]["kitcode"]==null?"-":result["data"]["kitcode"];

          });

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) =>

                  AlertDialog(
                    title: Text("InquiryScreen.InquiryResult".tr().toString(),style: TextStyle(
                      color: Color(0xff11120e),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                        SizedBox(height: 10,),
                        Row(children: [
                          Text(EasyLocalization.of(context).locale == Locale("en", "US")?"KitCode":"رقم العبوة"),
                          SizedBox(width: 5,),
                          Text(newKitCode,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),

                      ],
                    ),
                    actions: <Widget>[

                      TextButton(
                        onPressed: ()  {
                          Navigator.pop(
                            context,
                          );
                          setState(() {
                            kitcode.text='';
                          });
                        },
                        child:Text(
                          "alert.close".tr().toString(),
                          style: TextStyle(
                            color: Color(0xFF4f2565),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ));
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));

        setState(() {
          checkKitCode =false;
        });

      }

      return result;
    }
    if(statusCode == 200 && statusCode != 401){

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));

      setState(() {
        checkKitCode =false;
      });

    }
  }



  /****************************************Check line and MS renewal date****************************************************/
  Widget enterMSISDNLine() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(

          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            enabled: checkLine==true?false:true,
            controller: msisdnLine,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyMSISDNLine == true || errorMSISDNLine ==true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){
              setState(() {
                errorNational=false;
                emptyNational=false;
                errorMSISDNBills=false;
                emptyMSISDNBills=false;
                errorKitCode=false;
                emptyKitCode=false;

              //  msisdnBills.text='';
               // national.text='';
              });
            },
            onChanged: (msisdnLine){


              if (msisdnLine.length != 0) {
                setState(() {
                  emptyMSISDNLine=false;
                  errorMSISDNLine=true;

                });


              }  if (msisdnLine.length != 10) {
                setState(() {
                  emptyMSISDNLine=false;
                  errorMSISDNLine=true;

                });


              }
              else {
                setState(() {
                  emptyMSISDNLine=false;
                  errorMSISDNLine=false;
                });
              }
            },
          ),
        ),


      ],
    );
  }

  Widget buildCheckLineBtn() {
    return Column(
        children :[
          checkLine==true ?
          ElevatedButton(
              onPressed: null,
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all( Color(0xFFd4d0d6)),
              padding: MaterialStateProperty.all(
                  EdgeInsets.symmetric(vertical:16, horizontal: 25)),
              textStyle:
              MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:  Color(0xFF4f2565)))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),):
          ElevatedButton(
            onPressed: () {
              setState(() {
                checkLine=true;
              });
              if(msisdnLine.text =='' ){
                setState(() {
                  emptyMSISDNLine=true;
                  errorMSISDNLine=false;
                  checkLine=false;

                });
              }
              else if(msisdnLine.text.length !=10 ){
                setState(() {
                  errorMSISDNLine=true;
                  emptyMSISDNLine=false;
                  checkLine=false;


                });
              }

             /* if(msisdnLine.text!=''){
                if (msisdnLine.text.length == 10) {
                  if (msisdnLine.text.substring(0, 3) == '079') {
                    setState(() {
                      errorMSISDNLine = false;
                      emptyMSISDNLine = false;
                      checkLine==false;

                    });
                  } else {
                    setState(() {
                      errorMSISDNLine = true;
                      emptyMSISDNLine = false;
                      checkLine==false;

                    });
                  }
                }
              }*/
//              if(msisdnLine.text!='' && msisdnLine.text.length == 10 && msisdnLine.text.substring(0, 3) == '079'){
              if(msisdnLine.text!='' && msisdnLine.text.length == 10 ){
                InquiryLine();
                setState(() {
                  checkLine=true;

                });
              }

            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFF4f2565)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),
          ),]
    );
  }

  void InquiryLine()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Customer360/Prepaid/subscriber/${msisdnLine.text}';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if( result["status"]==0){
        setState(() {
          checkLine =false;
        });
        if(result["data"]==null||result["data"].length==0){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString()),backgroundColor: Colors.red));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.Success".tr().toString()),backgroundColor: Colors.green));

          setState(() {
             packageName=EasyLocalization.of(context).locale == Locale("en", "US")?result["data"]["packageName"]:result["data"]["packageNameAr"];
             msRenewalDenomination=result["data"]["ms"]==null?"-":result["data"]["ms"];
             lineStatus=result["data"]["lineStatus"]==null?"-":result["data"]["lineStatus"];
             nextRenewalDate=result["data"]["nextRenewalDate"]==null?"-":result["data"]["nextRenewalDate"];
             newKitCode=result["data"]["kitcode"]==null?"-":result["data"]["kitcode"];

          });

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) =>

                  AlertDialog(
                    title: Text("InquiryScreen.InquiryResult".tr().toString(),style: TextStyle(
                        color: Color(0xff11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Text("InquiryScreen.PackageName".tr().toString())
                        ],),
                        Row(children: [
                          Text(packageName,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                        SizedBox(height: 10,),
                        Row(children: [
                          Text(EasyLocalization.of(context).locale == Locale("en", "US")?"MS Renewal Denomination":"تجديد فئة MS")
                        ],),
                        Row(children: [
                          Text(msRenewalDenomination,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                        SizedBox(height: 10,),
                        Row(children: [
                          Text("InquiryScreen.LineStatus".tr().toString())
                        ],),
                        Row(children: [
                          Text(lineStatus,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                        SizedBox(height: 10,),
                        Row(children: [
                          Text("InquiryScreen.NextRenewalDate".tr().toString(),)
                        ],),
                        Row(children: [
                          Text(nextRenewalDate,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                        SizedBox(height: 10,),
                        Row(children: [
                          Text(EasyLocalization.of(context).locale == Locale("en", "US")?"KitCode":"رقم العبوة")
                        ],),
                        Row(children: [
                          Text(newKitCode,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                      ],
                    ),
                    actions: <Widget>[

                      TextButton(
                        onPressed: ()  {
                          Navigator.pop(
                            context,
                          );
                          setState(() {
                            msisdnLine.text='';
                          });
                        },
                        child:Text(
                          "alert.close".tr().toString(),
                          style: TextStyle(
                            color: Color(0xFF4f2565),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ));
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));

        setState(() {
          checkLine =false;
        });

      }

      return result;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));

      setState(() {
        checkLine =false;
      });
    }
  }

  /*************************************************************************************************************************/

  /****************************************Check Postpaid Inquiry**************************************************************/
  Widget enterPostpaidInquiry() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(

          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            enabled: checkPostpaidInquiry==true?false:true,
            controller: postpaidInquiry,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyPostpaidInquiry == true || errorPostpaidInquiry ==true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){
              setState(() {
                errorNational=false;
                emptyNational=false;
                errorMSISDNLine=false;
                emptyMSISDNLine=false;
                errorKitCode=false;
                emptyKitCode=false;

                // msisdnLine.text='';
                // national.text='';
              });
            },
            onChanged: (PostpaidInquiry){
              setState(() {
                emptyPostpaidInquiry=false;
                errorPostpaidInquiry=false;
              });

            /*  if (PostpaidInquiry.length != 0) {
                setState(() {
                  emptyPostpaidInquiry=false;
                  errorPostpaidInquiry=true;

                });


              }  if (PostpaidInquiry.length != 10) {
                setState(() {
                  emptyPostpaidInquiry=false;
                  errorPostpaidInquiry=true;

                });


              }
              else {
                setState(() {
                  emptyPostpaidInquiry=false;
                  errorPostpaidInquiry=false;
                });
              }*/
            },
          ),
        ),


      ],
    );
  }

  Widget buildCheckPostpaidInquiryBtn() {
    return Column(
        children :[
          checkPostpaidInquiry==true ?
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFFd4d0d6)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:  Color(0xFF4f2565)))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),):
          ElevatedButton(
            onPressed: () {
              setState(() {
                checkPostpaidInquiry=true;
              });
              if(postpaidInquiry.text =='' ){
                setState(() {
                  emptyPostpaidInquiry=true;
                  errorPostpaidInquiry=false;
                  checkPostpaidInquiry=false;


                });
              }
              /*  else if(msisdnBills.text.length !=10 ){
                setState(() {
                  errorMSISDNBills=true;
                  emptyMSISDNBills=false;
                  checkBills=false;


                });
              }*/

              /*  if(msisdnBills.text!=''){
                if (msisdnBills.text.length == 10) {
                  if (msisdnBills.text.substring(0, 3) == '079') {
                    setState(() {
                      errorMSISDNBills = false;
                      emptyMSISDNBills = false;
                      checkBills=false;

                    });
                  } else {
                    setState(() {
                      errorMSISDNBills = true;
                      emptyMSISDNBills = false;
                      checkBills=false;

                    });
                  }
                }
              }*/
//              if(msisdnBills.text!='' && msisdnBills.text.length == 10 && msisdnBills.text.substring(0, 3) == '079'){
              if(postpaidInquiry.text!='' ){
                PostpaidInquiry();
                setState(() {
                  checkPostpaidInquiry=true ;

                });
              }

            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFF4f2565)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),
          ),]
    );
  }

  void PostpaidInquiry()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

   // var apiArea = urls.BASE_URL+'/Customer360/subscriberSubsidyDetails';
    var apiArea = urls.BASE_URL+'/Dashboard/GetPostPaidInquiryDetails/${postpaidInquiry.text}';

    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if( result["status"]==0){
        setState(() {
          checkBills =false;
        });
        if(result["data"]==null||result["data"].length==0){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString())));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.Success".tr().toString()),backgroundColor: Colors.green));

          setState(() {
            commitmentPeriod=result["data"]["commitmentPeriod"]==null?'-':result["data"]["commitmentPeriod"];
            _packageName=result["data"]["pakageName"]==null?"-":result["data"]["pakageName"];
            terminationSimulation=result["data"]["terminationSimulation"]==null?"-":result["data"]["terminationSimulation"];

          });

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) =>

                  AlertDialog(
                    title: Text("InquiryScreen.InquiryResult".tr().toString(),style: TextStyle(
                      color: Color(0xff11120e),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Text(EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'Commitment Period'
                              : "فترة الالتزام",)
                        ],),
                        Row(children: [
                          Text(commitmentPeriod,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                        SizedBox(height: 10,),
                        Row(children: [
                          Text(EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'Package Name'
                              : "اسم الحزمة",)
                        ],),
                        Row(children: [
                          Text(_packageName,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                        SizedBox(height: 10,),
                        Row(children: [
                          Text(EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'Termination Simulation'
                              : "محاكاة الإنهاء",)
                        ],),
                        Row(children: [
                          Text(terminationSimulation,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                      ],
                    ),
                    actions: <Widget>[

                      TextButton(
                        onPressed: ()  {
                          Navigator.pop(
                            context,
                          );
                          setState(() {
                            checkPostpaidInquiry =false;
                            postpaidInquiry.text='';
                          });
                        },
                        child:Text(
                          "alert.close".tr().toString(),
                          style: TextStyle(
                            color: Color(0xFF4f2565),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ));
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));

        setState(() {
          checkPostpaidInquiry =false;
        });

      }

      return result;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));

      setState(() {
        checkPostpaidInquiry =false;
      });
    }
  }



  /*************************************************************************************************************************/

  /****************************************Check Bills inquiry**************************************************************/
  Widget enterMSISDNBills() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(

          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            enabled: checkBills==true?false:true,
            controller: msisdnBills,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyMSISDNBills == true || errorMSISDNBills ==true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
              onTap: (){
                setState(() {
                  errorNational=false;
                  emptyNational=false;
                  errorMSISDNLine=false;
                  emptyMSISDNLine=false;
                  errorKitCode=false;
                  emptyKitCode=false;

                 // msisdnLine.text='';
                 // national.text='';
                });
              },
            onChanged: (msisdnBills){


              if (msisdnBills.length != 0) {
                setState(() {
                  emptyMSISDNBills=false;
                  errorMSISDNBills=true;

                });


              }  if (msisdnBills.length != 10) {
                setState(() {
                  emptyMSISDNBills=false;
                  errorMSISDNBills=true;

                });


              }
              else {
                setState(() {
                  emptyMSISDNBills=false;
                  errorMSISDNBills=false;
                });
              }
            },
          ),
        ),


      ],
    );
  }

  Widget buildCheckBillsBtn() {
    return Column(
        children :[
          checkBills==true ?
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFFd4d0d6)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:  Color(0xFF4f2565)))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),):
          ElevatedButton(
            onPressed: () {
              setState(() {
                checkBills=true;
              });
              if(msisdnBills.text =='' ){
                setState(() {
                  emptyMSISDNBills=true;
                  errorMSISDNBills=false;
                  checkBills=false;


                });
              }
          /*  else if(msisdnBills.text.length !=10 ){
                setState(() {
                  errorMSISDNBills=true;
                  emptyMSISDNBills=false;
                  checkBills=false;


                });
              }*/

              /*  if(msisdnBills.text!=''){
                if (msisdnBills.text.length == 10) {
                  if (msisdnBills.text.substring(0, 3) == '079') {
                    setState(() {
                      errorMSISDNBills = false;
                      emptyMSISDNBills = false;
                      checkBills=false;

                    });
                  } else {
                    setState(() {
                      errorMSISDNBills = true;
                      emptyMSISDNBills = false;
                      checkBills=false;

                    });
                  }
                }
              }*/
//              if(msisdnBills.text!='' && msisdnBills.text.length == 10 && msisdnBills.text.substring(0, 3) == '079'){
              if(msisdnBills.text!='' ){
                InquiryBills();
                setState(() {
                  checkBills=true ;

                });
              }

            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFF4f2565)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),
          ),]
    );
  }

  void InquiryBills()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Customer360/CustomerReconnectionAmount/${msisdnBills.text}';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if( result["status"]==0){
        setState(() {
          checkBills =false;
        });
        if(result["data"]==null||result["data"].length==0){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString())));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.Success".tr().toString()),backgroundColor: Colors.green));

          setState(() {
            totalAmount=result["data"]["totalAmount"];
            reconnectionAmount=result["data"]["reconnectionAmount"];
            reconnectionPercentage=result["data"]["reconnectionPercentage"];

          });

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) =>

                  AlertDialog(
                    title: Text("InquiryScreen.InquiryResult".tr().toString(),style: TextStyle(
                      color: Color(0xff11120e),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(children: [
                          Text("InquiryScreen.totalAmount".tr().toString())
                        ],),
                        Row(children: [
                          Text(totalAmount,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                        SizedBox(height: 10,),
                        Row(children: [
                          Text("InquiryScreen.reconnectionAmount".tr().toString())
                        ],),
                        Row(children: [
                          Text(reconnectionAmount,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                        SizedBox(height: 10,),
                        Row(children: [
                          Text("InquiryScreen.reconnectionPercentage".tr().toString(),)
                        ],),
                        Row(children: [
                          Text(reconnectionPercentage,style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),),
                        ],),
                      ],
                    ),
                    actions: <Widget>[

                      TextButton(
                        onPressed: ()  {
                          Navigator.pop(
                            context,
                          );
                          setState(() {
                            msisdnBills.text='';
                          });
                        },
                        child:Text(
                          "alert.close".tr().toString(),
                          style: TextStyle(
                            color: Color(0xFF4f2565),
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                    ],
                  ));
        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));

        setState(() {
          checkBills =false;
        });

      }

      return result;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));

      setState(() {
        checkBills =false;
      });
    }
  }
  /*************************************************************************************************************************/

  /****************************************Check National number check****************************************************/
  Widget enterNational() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(

          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            enabled: checkNational==true?false:true,
            controller: national,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyNational == true || errorNational ==true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){
              setState(() {
                errorMSISDNLine=false;
                emptyMSISDNLine=false;
                errorMSISDNBills=false;
                emptyMSISDNBills=false;
                errorKitCode=false;
                emptyKitCode=false;

               // msisdnBills.text='';
               // msisdnLine.text='';
              });
            },
            onChanged: (national){

              if (national.length == 0) {
                setState(() {
                  emptyNational=true;
                  errorNational=false;

                });


              }  if (national.length != 10) {
                setState(() {
                  emptyNational=false;
                  errorNational=true;

                });


              }
              else {
                setState(() {
                  emptyNational=false;
                  errorNational=false;
                });
              }
            },
          ),
        ),


      ],
    );
  }

  Widget buildCheckNationalBtn() {
    return Column(
        children :[
          checkNational==true ?
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFFd4d0d6)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:  Color(0xFF4f2565)))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),):
          ElevatedButton(
            onPressed: () {
              setState(() {
                checkNational=true;
              });
              if(national.text =='' ){
                setState(() {
                  emptyNational=true;
                  errorNational=false;
                  checkNational=false;


                });
              }
              else if(national.text.length !=10 ){
                print("haya hazaimeh");
                print(national.text.length);
                setState(() {
                  errorNational=true;
                  emptyNational=false;
                  checkNational=false;

                });
              }


              if(national.text!='' && national.text.length == 10 ){
                InquiryNational();
                setState(() {
                  checkNational=true;
                });
              }

            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFF4f2565)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Check'
                : "استفسار"),
          ),]
    );
  }

  void InquiryNational()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Customer360/CheckWriteOff/${national.text}';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
          backgroundColor: Colors.red));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if( result["status"]==0){
        setState(() {
          checkNational =false;
        });
        if(result["data"]==null){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString()),backgroundColor: Colors.red));
        }else{
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.Success".tr().toString()),backgroundColor: Colors.green));



          if(result["data"]["hdLst"] == null || result["data"]["woLst"] == null|| result["data"]["hoLst"] == null || result["data"]["nidLst"]== null){
            showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) =>

                    AlertDialog(
                      title: Text("InquiryScreen.InquiryResult".tr().toString(),style: TextStyle(
                        color: Color(0xff11120e),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [

                          SizedBox(height: 10,),
                          Row(children: [
                            Text(EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "No data found to view"
                                : "لم يتم العثور على بيانات لعرضها",)
                          ],),

                          SizedBox(height: 10,),


                        ],
                      ),
                      actions: <Widget>[

                        TextButton(
                          onPressed: ()  {
                            Navigator.pop(
                              context,
                            );
                            setState(() {
                              national.text='';
                            });
                          },
                          child:Text(
                            "alert.close".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF4f2565),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),

                      ],
                    ));

          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString()), backgroundColor: Colors.red));
          }
          if(result["data"]["hdLst"] != null || result["data"]["woLst"] != null|| result["data"]["hoLst"] != null || result["data"]["nidLst"]!= null){
            setState(() {
              hdLst_customerNumber=result["data"]["hdLst"].length != 0?result["data"]["hdLst"][0]["customerNumber"]:'--';
              hdLst_amount=result["data"]["hdLst"].length !=0?result["data"]["hdLst"][0]["amount"].toString():'0.0';
              woLst_customerNumber=result["data"]["woLst"].length != 0?result["data"]["woLst"][0]["customerNumber"]:'--';
              woLst_amount=result["data"]["woLst"].length !=0 ?result["data"]["woLst"][0]["amount"].toString():'0.0';
              hoLst_customerNumber=result["data"]["hoLst"].length != 0?result["data"]["hoLst"][0]["customerNumber"]:'--';
              hoLst_amount=result["data"]["hoLst"].length !=0 ?result["data"]["hoLst"][0]["amount"].toString():'0.0';
              nidLst=result["data"]["nidLst"].length !=0 ?result["data"]["nidLst"]:[];

            });
            if (result["data"]["nidLst"].isNotEmpty) {
              setState(() {
                dues.clear(); // Clear previous data

                for (var nid in result["data"]["nidLst"]) {
                  for (var due in nid["dues"]) {
                    dues.add(due); // Add each due item to the list
                  }
                }
              });

              print("Dues: $dues");
            }




          /*  showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                  "InquiryScreen.InquiryResult".tr().toString(),
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: 900), // Set a max height
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 30,
                              width:140,
                              color: Color(0xFF4f2565),
                              child:Text("HD/List",
                                textAlign: TextAlign.center ,
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                              )
                              ,
                            ),
                            SizedBox(height: 10,),
                            Row(children: [
                              Text("InquiryScreen.customerNumber".tr().toString())
                            ],),
                            Row(children: [
                              Text(hdLst_customerNumber,style: TextStyle(
                                color: Color(0xff11120e),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],),
                            SizedBox(height: 10,),
                            Row(children: [
                              Text("InquiryScreen.amount".tr().toString())
                            ],),
                            Row(children: [

                              Text(EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? hdLst_amount+" JD"
                                  :   hdLst_amount+" "+"د.أ",style: TextStyle(
                                color: Color(0xff11120e),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],),

                            SizedBox(height: 10,),

                            Container(
                              padding: EdgeInsets.all(5),
                              height: 30,
                              width:140,
                              color: Color(0xFF4f2565),
                              child:Text("WO/List",
                                textAlign: TextAlign.center ,
                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                              )
                              ,
                            ),
                            SizedBox(height: 10,),
                            Row(children: [
                              Text("InquiryScreen.customerNumber".tr().toString())
                            ],),
                            Row(children: [
                              Text(woLst_customerNumber,style: TextStyle(
                                color: Color(0xff11120e),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],),
                            SizedBox(height: 10,),
                            Row(children: [
                              Text("InquiryScreen.amount".tr().toString(),)
                            ],),
                            Row(children: [
                              Text( EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? woLst_amount+" JD"
                                  :   woLst_amount+" "+"د.أ",style: TextStyle(
                                color: Color(0xff11120e),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],),

                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 30,
                              width:140,
                              color: Color(0xFF4f2565),
                              child:Text("HO/List",
                                textAlign: TextAlign.center ,

                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                              )
                              ,
                            ),
                            SizedBox(height: 10,),
                            Row(children: [
                              Text("InquiryScreen.customerNumber".tr().toString())
                            ],),
                            Row(children: [
                              Text(hoLst_customerNumber,style: TextStyle(
                                color: Color(0xff11120e),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],),
                            SizedBox(height: 10,),
                            Row(children: [
                              Text("InquiryScreen.amount".tr().toString(),)
                            ],),
                            Row(children: [

                              Text( EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? hoLst_amount+" JD"
                                  :   hoLst_amount+" "+"د.أ",style: TextStyle(
                                color: Color(0xff11120e),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),),
                            ],),


                            SizedBox(height: 10,),
                            Container(
                              padding: EdgeInsets.all(5),
                              height: 30,
                              width:140,
                              color: Color(0xFF4f2565),
                              child:Text("Lawyer List",
                                textAlign: TextAlign.center ,

                                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),
                              )
                              ,
                            ),
                            SizedBox(height: 10,),


                            dues.isNotEmpty
                                ? Container(
                              constraints: BoxConstraints(maxHeight: 300), // Set a max height for the ListView
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(), // Disable scrolling for the ListView
                                itemCount: dues.length,
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      Text(dues[index]["customeR_ID"].toString()),
                                      Text(dues[index]["nationaL_NUMBER"].toString()),
                                      Text(dues[index]["aL_DUES"].toString()),
                                    ],
                                  );
                                },
                              ),
                            )
                                : Text("No data returned", style: TextStyle(fontSize: 14, color: Colors.red)),



                          ],
                        ),
                      ],
                    ),
                  ),
                ),


                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        national.text = '';
                      });
                    },
                    child: Text(
                      "alert.close".tr().toString(),
                      style: TextStyle(
                        color: Color(0xFF4f2565),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );*/
            showDialog(
              barrierDismissible: false,
              context: context,
              builder: (_) => AlertDialog(
                title: Text(
                  "InquiryScreen.InquiryResult".tr().toString(),
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                content: SizedBox(
                  width: double.maxFinite, // Ensures the dialog takes the necessary width
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min, // Prevent infinite height
                      children: [
                        _buildSectionHeader("HD/List"),
                        _buildRow("InquiryScreen.customerNumber", hdLst_customerNumber),
                        _buildRow(
                          "InquiryScreen.amount",
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "$hdLst_amount JD"
                              : "$hdLst_amount د.أ",
                        ),

                        _buildSectionHeader("WO/List"),
                        _buildRow("InquiryScreen.customerNumber", woLst_customerNumber),
                        _buildRow(
                          "InquiryScreen.amount",
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "$woLst_amount JD"
                              : "$woLst_amount د.أ",
                        ),

                        _buildSectionHeader("HO/List"),
                        _buildRow("InquiryScreen.customerNumber", hoLst_customerNumber),
                        _buildRow(
                          "InquiryScreen.amount",
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "$hoLst_amount JD"
                              : "$hoLst_amount د.أ",
                        ),

                        _buildSectionHeader("Lawyer List"),

                        // Lawyer List Data with a fixed max height
                        dues.isNotEmpty
                            ? ConstrainedBox(
                          constraints: BoxConstraints(
                            maxHeight: 300, // Limits the height to avoid layout errors
                          ),
                          child: SingleChildScrollView(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: AlwaysScrollableScrollPhysics(), // Allow scrolling
                              itemCount: dues.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    Row(children: [
                                      Text( EasyLocalization.of(context).locale == Locale("en", "US")?"Customer ID :  ":"رقم العميل :", textAlign: TextAlign.start,),
                                      Text(dues[index]["customeR_ID"].toString(), textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,),),
                                    ],),
                                    Row(children: [
                                      Text(EasyLocalization.of(context).locale == Locale("en", "US")?"National Number :  ":"الرقم الوطني :", textAlign: TextAlign.start,),
                                      Text(dues[index]["nationaL_NUMBER"].toString(),textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,),),
                                    ],),
                                    Row(children: [
                                      Text(EasyLocalization.of(context).locale == Locale("en", "US")?"DUES :  ":"المستحقات : ", textAlign: TextAlign.start,),
                                      Text(dues[index]["aL_DUES"].toString(),textAlign: TextAlign.start,style: TextStyle(fontWeight: FontWeight.bold,),),
                                    ],),

                                    Divider(),
                                  ],
                                );
                              },
                            ),
                          )
                        )
                            : Text(
                          "No data returned",
                          style: TextStyle(fontSize: 14, color: Colors.red),
                        ),
                      ],
                    ),
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      setState(() {
                        national.text = '';
                      });
                    },
                    child: Text(
                      "alert.close".tr().toString(),
                      style: TextStyle(
                        color: Color(0xFF4f2565),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            );




          }



        }
      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]),
                backgroundColor: Colors.red));

        setState(() {
          checkNational =false;
        });

      }

      return result;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
              backgroundColor: Colors.red));

      setState(() {
        checkNational =false;
      });
    }
  }




// Section Header Function
  Widget _buildSectionHeader(String title) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(5),
          height: 30,
          width: 140,
          color: Color(0xFF4f2565),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

// Row Function for Key-Value Pairs
  Widget _buildRow(String key, String value) {
    return Column(
      children: [
        Row(children: [Text(key.tr().toString())]),
        Row(
          children: [
            Text(
              value,
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        SizedBox(height: 10),
      ],
    );
  }


  /*************************************************************************************************************************/


  /****************************************Check National number check****************************************************/
  Widget enterJeeranPromoCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(

          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            enabled: checkPromoCode==true?false:true,
            controller: promoCode,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
                enabledBorder: emptyPromoCode == true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){

            },
            onChanged: (national){
              setState(() {
                emptyPromoCode=false;
              });

            },
          ),
        ),


      ],
    );
  }

  Widget buildJeeranPromoCodeBtn() {
    return Column(
        children :[
          checkPromoCode==true ?
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFFd4d0d6)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:  Color(0xFF4f2565)))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Resend'
                : "  ارسال  "),):
          ElevatedButton(
            onPressed: () {
              setState(() {
/*............................................Disable other buttons...........................................*/
                check_MSISDN=true;
                check_Sim=true;
                checkNational=true;
                checkBills=true;
                checkLine=true;
/*...........................................................................................................*/
                checkPromoCode=true;
              });
              if(promoCode.text =='' ){
                setState(() {
/*............................................Enable other buttons...........................................*/
                  check_MSISDN=false;
                  check_Sim=false;
                  checkNational=false;
                  checkBills=false;
                  checkLine=false;
/*...........................................................................................................*/
                  emptyPromoCode=true;
                  checkPromoCode=false;
                });
              }



              if(promoCode.text!='' ){
                ResendJeeranPromoCode();
                setState(() {
                  checkPromoCode=true;
                  emptyPromoCode=false;

                });
              }

            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFF4f2565)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Resend'
                : "  ارسال  "),
          ),]
    );
  }

  void ResendJeeranPromoCode()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Postpaid/ResendJeeranPromoCode/${promoCode.text}';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
            backgroundColor: Colors.red,
            // Change background color
          ));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      if( result["status"]==0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]), backgroundColor: Colors.green));

        setState(() {
 /*............................................Enable other buttons...........................................*/
          check_MSISDN=false;
          check_Sim=false;
          checkNational=false;
          checkBills=false;
          checkLine=false;
/*...........................................................................................................*/

          checkPromoCode=false;
          emptyPromoCode=false;

        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]),
          backgroundColor: Colors.red,));
        setState(() {
/*............................................Enable other buttons...........................................*/
          check_MSISDN=false;
          check_Sim=false;
          checkNational=false;
          checkBills=false;
          checkLine=false;
/*...........................................................................................................*/
          checkPromoCode=false;
          emptyPromoCode=false;

        });
      }
      return result;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
            backgroundColor: Colors.red,));
    }
    setState(() {
/*............................................Enable other buttons...........................................*/
      check_MSISDN=false;
      check_Sim=false;
      checkNational=false;
      checkBills=false;
      checkLine=false;
/*...........................................................................................................*/
      checkPromoCode=false;
      emptyPromoCode=false;

    });
  }
  /********************************************************************************************************************/


  /****************************************Sim Number Search****************************************************/
  Widget enterSimNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(
          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            enabled: check_Sim==true?false:true,
            controller: Sim,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: empty_Sim == true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){

            },
            onChanged: (national){
              setState(() {
                empty_Sim=false;

              });

            },
          ),
        ),


      ],
    );
  }

  Widget buildSimNumberBtn() {
    return Column(
        children :[
          check_Sim==true ?
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFFd4d0d6)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:  Color(0xFF4f2565)))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Search'
                : "   بحث   "),):
          ElevatedButton(
            onPressed: () {
              setState(() {
/*............................................Disable other buttons...........................................*/
                check_MSISDN=true;
                checkPromoCode=true;
                checkNational=true;
                checkBills=true;
                checkLine=true;
/*...........................................................................................................*/

                check_Sim=true;
              });
              if(Sim.text =='' ){
                setState(() {
 /*............................................Enable other buttons...........................................*/
                  check_MSISDN=false;
                  checkPromoCode=false;
                  checkNational=false;
                  checkBills=false;
                  checkLine=false;
/*...........................................................................................................*/
                  empty_Sim=true;
                  check_Sim=false;
                });
              }



              if(Sim.text!='' ){
                SearchSimNumber();
                setState(() {
                  check_Sim=true;
                  empty_Sim=false;

                });
              }

            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFF4f2565)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Search'
                : "   بحث   "),
          ),]
    );
  }

  void SearchSimNumber()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Customer360/GetActivationDate';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    Map body = {
      "msisdn":"",
      "sim":  Sim.text
    };

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);


    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
            backgroundColor: Colors.red,
            // Change background color
          ));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      if( result["status"]==0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]), backgroundColor: Colors.green));
        showAlertDialogSim(context,result["data"]["msisdn"],result["data"]["activationDate"]);
        setState(() {
 /*............................................Enable other buttons...........................................*/
          check_MSISDN=false;
          checkPromoCode=false;
          checkNational=false;
          checkBills=false;
          checkLine=false;
/*...........................................................................................................*/
          check_Sim=false;
          empty_Sim=false;

        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]),
          backgroundColor: Colors.red,));
        setState(() {
          /*............................................Enable other buttons...........................................*/
          check_MSISDN=false;
          checkPromoCode=false;
          checkNational=false;
          checkBills=false;
          checkLine=false;
/*...........................................................................................................*/


          check_Sim=false;
          empty_Sim=false;

        });
      }
      return result;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
            backgroundColor: Colors.red,));
    }
    setState(() {
/*............................................Enable other buttons...........................................*/
      check_MSISDN=false;
      checkPromoCode=false;
      checkNational=false;
      checkBills=false;
      checkLine=false;
/*...........................................................................................................*/
      check_Sim=false;
      empty_Sim=false;

    });
  }

  showAlertDialogSim(BuildContext context, msisdn, activationDate) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        setState(() {
          Sim.text = '';
        });

        Navigator.of(context).pop();
      },
    );

    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Details"
            : "التفاصيل",
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5, // Adjust the value as needed
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "MSISDN"
                    : "رقم الخط",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                msisdn,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              ),
              SizedBox(height: 10,),
              Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Activation Date"
                    : "تاريخ التفعيل",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                activationDate,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        tryAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  /***********************************************************************************************************/

  /****************************************Sim Number Search****************************************************/
  Widget enterMSISDNNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(
          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            enabled: check_MSISDN==true?false:true,
            controller: MSISDN,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: empty_MSISDN == true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){

            },
            onChanged: (national){
              setState(() {
                empty_MSISDN=false;

              });

            },
          ),
        ),


      ],
    );
  }

  Widget buildMSISDNNumberBtn() {
    return Column(
        children :[
          check_MSISDN==true ?
          ElevatedButton(
            onPressed: null,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFFd4d0d6)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold,color:  Color(0xFF4f2565)))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Search'
                : "   بحث   "),):
          ElevatedButton(
            onPressed: () {
              setState(() {
/*............................................Disable other buttons...........................................*/
                check_Sim=true;
                checkPromoCode=true;
                checkNational=true;
                checkBills=true;
                checkLine=true;
/*...........................................................................................................*/
                check_MSISDN=true;
              });
              if(MSISDN.text =='' ){
                setState(() {
/*............................................Enable other buttons...........................................*/
                  check_Sim=false;
                  checkPromoCode=false;
                  checkNational=false;
                  checkBills=false;
                  checkLine=false;
/*...........................................................................................................*/
                  empty_MSISDN=true;
                  check_MSISDN=false;
                });
              }

              if(MSISDN.text!='' ){
                SearchMSISDNNumber();
                setState(() {
                  check_MSISDN=true;
                  empty_MSISDN=false;

                });
              }

            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all( Color(0xFF4f2565)),
                padding: MaterialStateProperty.all(
                    EdgeInsets.symmetric(vertical:16, horizontal: 25)),
                textStyle:
                MaterialStateProperty.all(const TextStyle(fontSize: 12,fontWeight: FontWeight.bold))),
            child:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Search'
                : "   بحث   "),
          ),]
    );
  }

  void SearchMSISDNNumber()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Customer360/GetActivationDate';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    Map body = {
      "msisdn":MSISDN.text,
      "sim":  ""
    };
   print(body);
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);


    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
            backgroundColor: Colors.red,
            // Change background color
          ));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      if( result["status"]==0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]), backgroundColor: Colors.green));
        showAlertDialogMSISDN(context,result["data"]["activationDate"]);

        setState(() {
          check_Sim=false;
          checkPromoCode=false;
          checkNational=false;
          checkBills=false;
          checkLine=false;

          check_MSISDN=false;
          empty_MSISDN=false;

        });
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]),
          backgroundColor: Colors.red,));
        setState(() {
          check_Sim=false;
          checkPromoCode=false;
          checkNational=false;
          checkBills=false;
          checkLine=false;

          check_MSISDN=false;
          empty_MSISDN=false;

        });
      }
      return result;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
            backgroundColor: Colors.red,));
    }
    setState(() {
 /*............................................Enable other buttons...........................................*/
      check_Sim=false;
      checkPromoCode=false;
      checkNational=false;
      checkBills=false;
      checkLine=false;
/*...........................................................................................................*/

      check_MSISDN=false;
      empty_MSISDN=false;

    });
  }

  showAlertDialogMSISDN(BuildContext context,activationDate) {
    Widget tryAgainButton = TextButton(
      child: Text("alert.close".tr().toString() ,
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
        setState(() {
          MSISDN.text='';
        });
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(EasyLocalization.of(context).locale == Locale("en", "US") ? "Details" : "التفاصيل",
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      content: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5, // Adjust the value as needed
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Activation Date"
                    : "تاريخ التفعيل",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                activationDate,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
      actions: [
        tryAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  /***********************************************************************************************************/

  /******** for back button on mobile tap ******/
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
    return WillPopScope(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () async {
                    Navigator.pop(context);

                  },
                ),
                centerTitle: false,
                title: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'Inquiry'
                      : "استفسار",
                ),
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding:
                  EdgeInsets.only(top: 20, bottom: 20, left: 32, right: 32),
                  children: <Widget>[
                    /***************LOGO**************************/
                    Center(
                      child: Image(
                          image: AssetImage('assets/images/SearchIcon.png'),
                          width: 175,
                          height: 175),
                    ),
                    SizedBox(height: 35,),

                    /**************************************************************/
                    /**************************Second Option***********************/
                    Center(child: Row(children: [    RichText(
                      text: TextSpan(
                        text: EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Postpaid Inquiry'
                            : "الاستعلام عن الدفع الآجل",
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
                      SizedBox(height: 5),],),),

                    Center(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: enterPostpaidInquiry(),
                        ),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: buildCheckPostpaidInquiryBtn(),
                        ),
                      ],
                    ),),

                    Center(child: Column(children: [
                      emptyPostpaidInquiry==true ? RequiredFeild(
                          text:  "Basic_Info_Edit.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      /*   errorMSISDNBills==true ? RequiredFeild(

                          text: EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Mobile Number shoud be 10 digits'
                              : "رقم الهاتف يجب أن يتكون من 10 أرقام")
                          : Container(),*/
                    ],),),

                    SizedBox(height: 10,),

                    /**************************KitCode Option***********************/
                    Center(child:
                    Row(children: [

                      RichText(
                        text: TextSpan(
                          text: EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Check KitCode for MSISDN'
                              : "رقم العبوة للخط",
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
                      SizedBox(height: 5),],),),

                    Center(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: enterKitCode(),
                        ),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: buildCheckKitCodeBtn(),
                        ),
                      ],
                    ),),

                    Center(child: Column(children: [
                      emptyKitCode==true ? RequiredFeild(
                          text:  "Basic_Info_Edit.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      errorKitCode==true ? RequiredFeild(

                          text: EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Mobile Number shoud be 10 digits'
                              : "رقم الهاتف يجب أن يتكون من 10 أرقام")
                          : Container(),
                    ],),),
                    /**************************************************************/
                    SizedBox(height: 15,),
                    /**************************************************************/
                    /**************************First Option***********************/
                    Center(child:
                    Row(children: [

                      RichText(
                      text: TextSpan(
                        text: EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Check line and MS renewal date'
                            : "تعرفة الخط و موعد تجديد الاشتراك",
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
                      SizedBox(height: 5),],),),

                    Center(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: enterMSISDNLine(),
                        ),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: buildCheckLineBtn(),
                        ),
                      ],
                    ),),

                    Center(child: Column(children: [
                      emptyMSISDNLine==true ? RequiredFeild(
                          text:  "Basic_Info_Edit.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      errorMSISDNLine==true ? RequiredFeild(

                          text: EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Mobile Number shoud be 10 digits'
                              : "رقم الهاتف يجب أن يتكون من 10 أرقام")
                          : Container(),
                    ],),),
                    /**************************************************************/
                    SizedBox(height: 15,),
                    /**************************************************************/
                    /**************************Second Option***********************/
                    Center(child: Row(children: [    RichText(
                      text: TextSpan(
                        text: EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Bills inquiry'
                            : "استفسار عن الفواتير",
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
                      SizedBox(height: 5),],),),

                    Center(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: enterMSISDNBills(),
                        ),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: buildCheckBillsBtn(),
                        ),
                      ],
                    ),),

                    Center(child: Column(children: [
                      emptyMSISDNBills==true ? RequiredFeild(
                          text:  "Basic_Info_Edit.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                   /*   errorMSISDNBills==true ? RequiredFeild(

                          text: EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Mobile Number shoud be 10 digits'
                              : "رقم الهاتف يجب أن يتكون من 10 أرقام")
                          : Container(),*/
                    ],),),
                    /**************************************************************/
                    SizedBox(height: 15,),
                    /**************************************************************/
                    /**************************Therd Option***********************/
                    Center(child: Row(children: [    RichText(
                      text: TextSpan(
                        text: EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'National number check'
                            : "تشييك على الرقم الوطني",
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
                      SizedBox(height: 5),],),),
                    Center(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: enterNational(),
                        ),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: buildCheckNationalBtn(),
                        ),
                      ],
                    ),),

                    Center(child: Column(children: [
                      emptyNational==true ? RequiredFeild(
                          text:  "Basic_Info_Edit.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                      errorNational==true ? RequiredFeild(

                          text: EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'National Number shoud be 10 digits'
                              : "الرقم الوطني  يجب أن يتكون من 10 أرقام ")
                          : Container(),
                    ],),),
                    SizedBox(height: 15,),
                    /**************************************************************/
                    /**************************Jerana Option***********************/
                    Center(child: Row(children: [    RichText(
                      text: TextSpan(
                        text: EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Jeeran Promo Code'
                            : "الرمز الترويجي لجيران",
                        style: TextStyle(
                          color: Color(0xff11120e),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' * ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                      SizedBox(height: 5),],),),
                    Center(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: enterJeeranPromoCode(),
                        ),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: buildJeeranPromoCodeBtn(),
                        ),
                      ],
                    ),),
                    Center(child: Column(children: [
                      emptyPromoCode==true ? RequiredFeild(
                          text:  "Basic_Info_Edit.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                    ],),),
                    SizedBox(height: 15),
                    /*********************SimNumber Option******************/
                    Permessions.contains('05.11.01')== true? Center(child: Row(children: [    RichText(
                      text: TextSpan(
                        text: EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Sim Number'
                            : "رقم الشريحة",
                        style: TextStyle(
                          color: Color(0xff11120e),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' * ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                      SizedBox(height: 5),],),):Container(),
                    Permessions.contains('05.11.01')== true?Center(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: enterSimNumber(),
                        ),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: buildSimNumberBtn(),
                        ),
                      ],
                    ),):Container(),
                    Permessions.contains('05.11.01')== true?Center(child: Column(children: [
                      empty_Sim==true ? RequiredFeild(
                          text:  "Basic_Info_Edit.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                    ],),):Container(),
                    Permessions.contains('05.11.01')== true?SizedBox(height: 15):Container(),
                    /*********************MSISDN Option******************/
                    Permessions.contains('05.11.02')== true?Center(child: Row(children: [    RichText(
                      text: TextSpan(
                        text: EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'MSISDN Number'
                            : "رقم الخط",
                        style: TextStyle(
                          color: Color(0xff11120e),
                          fontSize: 14,
                          fontWeight: FontWeight.normal,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: ' * ',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                      SizedBox(height: 5),],),):Container(),
                    Permessions.contains('05.11.02')== true?Center(child:   Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[

                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 2,
                          child: enterMSISDNNumber(),
                        ),
                        Expanded(
                          // optional flex property if flex is 1 because the default flex is 1
                          flex: 1,
                          child: buildMSISDNNumberBtn(),
                        ),
                      ],
                    ),):Container(),
                    Permessions.contains('05.11.02')== true?Center(child: Column(children: [
                      empty_MSISDN==true ? RequiredFeild(
                          text:  "Basic_Info_Edit.this_feild_is_required"
                              .tr()
                              .toString())
                          : Container(),
                    ],),):Container(),
                    Permessions.contains('05.11.02')== true?SizedBox(height: 15):Container(),
                  ],
                ),
              )),
        ),
        onWillPop: onWillPop);
  }
}
