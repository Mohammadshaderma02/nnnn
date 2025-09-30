import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recontracting/GenerateContract.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import '../../../../../Shared/BaseUrl.dart';
import '../../../../ReusableComponents/requiredText.dart';

APP_URLS urls = new APP_URLS();

class Recontracting extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
   Recontracting(this.Permessions, this.role, this.outDoorUserName);

  @override
  State<Recontracting> createState() => _RecontractingState(this.Permessions, this.role, this.outDoorUserName);
}

class _RecontractingState extends State<Recontracting> {
  _RecontractingState(this.Permessions, this.role, this.outDoorUserName);

  List<dynamic> Permessions;
  var role;
  var outDoorUserName;

  TextEditingController msisdn = TextEditingController();
  TextEditingController orderId=TextEditingController();
  bool emptyMAISDN = false;
  bool errorMAISDN = false;
  bool emptyOrderID = false;
  bool errorOrderID = false;

  var options_RECONTRACTING = [];
  List<String> Value_en = [];
  List<String> Value_ar = [];
  var selected_key;

  bool checkOptions =false;
  bool checkPackagesList=false;
  bool  emptySelectedOptions =false;
  String recontractingKey;
  String optionId;
  String optionName;

  List EligiblePackages = [];
  bool showInform = false;

  var getRoleType;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      checkOptions=true;
    });
    RecontractingTypeLookup_API();
  }

  Widget orderID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:  EasyLocalization.of(context).locale ==
                Locale("en", "US")?"orderID":"رقم الطلب",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color:Colors.white,
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
            controller: orderId,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.text,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyOrderID== true || errorOrderID==true
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

            },
            onChanged: (text){

            },
          ),
        )
      ],
    );
  }

  Widget MSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "changePackage.enter_msisdn".tr().toString(),
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
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMAISDN== true || errorMAISDN==true
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
                emptyMAISDN=false;
                errorMAISDN=false;
              })
            },
          onChanged: (text){
              if(text.length==0){
                setState(() {
                  showInform=false;
                });
              }
              if(text.length>1){
                setState(() {
                  showInform=true;
                });
              }
          },
          ),
        )
      ],
    );
  }


  RecontractingTypeLookup_API() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      getRoleType=prefs.get('role');
    });
    var apiArea = urls.BASE_URL + '/Lookup/RECONTRACTING';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },

    );

    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);

    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      setState(() {
        checkOptions=false;
        emptyMAISDN=false;
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
            checkOptions=false;
            emptyMAISDN=false;
          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no data available"
                      : "لا توجد بيانات متاحة")));
        }

        if (result["data"] != null ) {
          setState(() {
            options_RECONTRACTING=result['data'];
            emptyMAISDN=false;
            checkOptions=false;
          });
          for (var i = 0; i < result['data'].length; i++) {
            Value_en.add(result['data'][i]['value'].toString());
            Value_ar.add(result['data'][i]['valueAr'].toString());

          }
          print("******start****");
          print(options_RECONTRACTING);
          print(Value_en);
          print(Value_ar);

        }

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          checkOptions=false;
          emptyMAISDN=false;
        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        checkOptions=false;
        emptyMAISDN=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  void getNameSelected(val) {
    for (var i = 0; i < options_RECONTRACTING.length; i++) {
      if (options_RECONTRACTING[i]['key'].contains(val)) {
        setState(() {
         // optionName = options_RECONTRACTING[i]['value'];
        });

      } else {
        continue;
      }
    }

  }

  Widget buildRECONTRACTING() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "reContract.Recontracting_Type".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
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
        SizedBox(height: 15),
        Container(
            padding: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptySelectedOptions == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child:DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  disabledHint:Text(
                    "Test.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  hint: Text(
                    "Test.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  dropdownColor: Colors.white,
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xFF11120e),
                    fontSize: 14,
                  ),
                  value: recontractingKey,
                  onChanged: (  String newValue) {
                    setState(() {
                      recontractingKey = newValue;
                      getNameSelected(newValue);
                    });

                  },
                  items: options_RECONTRACTING.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:valueItem['key'].toString(),
                      child: Text(EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? valueItem['value']
                          : valueItem['valueAr']),
                    );
                  }).toList(),
                ),
              ),
            )),
        emptySelectedOptions == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required".tr().toString())
            : Container(),
      ],
    );
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

  RecontractingEligible_API() async {
    setState(() {
      EligiblePackages=[];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/recontracting/eligible';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn.text,
      "recontractingType":int.parse(recontractingKey)
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
        checkPackagesList=false;

        checkOptions=false;
        emptyMAISDN=false;
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
            checkPackagesList=false;
            checkOptions=false;
            emptyMAISDN=false;
          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no data available"
                      : "لا توجد بيانات متاحة")));
        }

        if (result["data"] != null ) {
          setState(() {
            EligiblePackages=result["data"];
            checkPackagesList=false;
            emptyMAISDN=false;
            checkOptions=false;
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
          checkPackagesList=false;
          checkOptions=false;
          emptyMAISDN=false;
        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        checkPackagesList=false;
        checkOptions=false;
        emptyMAISDN=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  void InformReContracted_API()async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/InformReContracted';
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

    if (statusCode == 401) {}

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));

      }

      return result;
    } else {

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
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
                "reContract.Recontracting".tr().toString(),
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
                    /*..............................OrderId Text Field Part 17-jul-2024....................................*/
                 /*   Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          SizedBox(height: 20),


                          /*..............................inform Button Part 24-6-2024....................................*/
                          showInform==true && Permessions.contains('05.14.01')?
                          SizedBox(height: 20)
                              :
                          Container(),
                          showInform==true && Permessions.contains('05.14.01')?
                          Container(
                              height: 48,
                              width: 300,
                              margin: EdgeInsets.symmetric(horizontal: 20),
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

                                  InformReContracted_API();

                                },

                                child: Text(
                                  "reContract.Inform".tr().toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          )
                              :
                          Container(),
                          /*...............................................................................................*/
                          SizedBox(height: 20),
                          Container(
                              height: 48,
                              width: 300,
                              margin: EdgeInsets.symmetric(horizontal: 20),
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

                                  if(recontractingKey == null){
                                    setState(() {
                                      emptySelectedOptions=true;
                                    });
                                  }
                                  if(recontractingKey != null){
                                    setState(() {
                                      emptySelectedOptions=false;
                                    });
                                  }

                                  if(msisdn.text.length>1 && recontractingKey != null){
                                    RecontractingEligible_API();
                                    setState(() {
                                      checkPackagesList=true;
                                    });
                                  }

                                },

                                child: Text(
                                  "reContract.check".tr().toString()+"haya",
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    ),*/

                    /**************************************************************First Container for Enter MSISDN**********************************************/
                    getRoleType =="DeliveryEShop"?
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [

                          SizedBox(height: 20),
                       orderID(),
                        SizedBox(height: 10,),
                       MSISDN(),
                          emptyMAISDN == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.serial_numbe_required"
                                  .tr()
                                  .toString())
                              : Container(),
                          SizedBox(height: 10),

                          buildRECONTRACTING(),

                          SizedBox(height: 20),

                          Container(
                              height: 48,
                              width: 300,
                              margin: EdgeInsets.symmetric(horizontal: 20),
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

                                  if(getRoleType=="DeliveryEShop" && orderId.text==''){
                                    setState(() {
                                      emptyOrderID=true;
                                    });
                                  }
                                  if(getRoleType=="DeliveryEShop" && orderId.text!=''){
                                    setState(() {
                                      emptyOrderID=false;
                                    });
                                  }
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

                                  if(recontractingKey == null){
                                    setState(() {
                                      emptySelectedOptions=true;
                                    });
                                  }
                                  if(recontractingKey != null){
                                    setState(() {
                                      emptySelectedOptions=false;
                                    });
                                  }

                                  /*this new action created on 22 juL*/
                               /*   if(msisdn.text.length>1 && recontractingKey != null){
                                    RecontractingEligible_API();
                                    setState(() {
                                      checkPackagesList=true;
                                    });
                                  }*/


                                  if(getRoleType=="DeliveryEShop" && orderId.text!='' && msisdn.text.length>1 && recontractingKey != null){
                                    RecontractingEligible_API();
                                    setState(() {
                                      checkPackagesList=true;
                                    });
                                  }
                                  if(getRoleType!="DeliveryEShop" && msisdn.text.length>1 && recontractingKey != null){
                                    RecontractingEligible_API();
                                    setState(() {
                                      checkPackagesList=true;
                                    });
                                  }

                                },

                                child: Text(
                                  "reContract.check".tr().toString(),
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                    :
                   Container(
                     color: Colors.white,
                     padding: EdgeInsets.only(left: 15, right: 15),
                     child: Column(
                       children: [

                         SizedBox(height: 20),
                         orderID(),
                         SizedBox(height: 10,),
                         MSISDN(),
                         emptyMAISDN == true
                             ? ReusableRequiredText(
                             text: "Menu_Form.serial_numbe_required"
                                 .tr()
                                 .toString())
                             : Container(),
                         SizedBox(height: 10),

                         buildRECONTRACTING(),
                         /*..............................inform Button for mada Part 24-6-2024....................................*/


                         showInform==true && Permessions.contains('05.14.01')==true &&Permessions!=null ?
                         SizedBox(height: 20)
                             :
                         Container(),
                         showInform==true && Permessions.contains('05.14.01')==true&&Permessions!=null ?
                         Container(
                             height: 48,
                             width: 300,
                             margin: EdgeInsets.symmetric(horizontal: 20),
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

                                 InformReContracted_API();

                               },

                               child: Text(
                                 "reContract.Inform".tr().toString(),
                                 style: TextStyle(
                                     color: Colors.white,
                                     letterSpacing: 0,
                                     fontSize: 16,
                                     fontWeight: FontWeight.bold),
                               ),
                             )
                         )
                             :
                         Container(),
                         /*...............................................................................................*/
                         SizedBox(height: 20),

                         Container(
                             height: 48,
                             width: 300,
                             margin: EdgeInsets.symmetric(horizontal: 20),
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

                                 if(getRoleType=="DeliveryEShop" && orderId.text==''){
                                   setState(() {
                                     emptyOrderID=true;
                                   });
                                 }
                                 if(getRoleType=="DeliveryEShop" && orderId.text!=''){
                                   setState(() {
                                     emptyOrderID=false;
                                   });
                                 }
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

                                 if(recontractingKey == null){
                                   setState(() {
                                     emptySelectedOptions=true;
                                   });
                                 }
                                 if(recontractingKey != null){
                                   setState(() {
                                     emptySelectedOptions=false;
                                   });
                                 }

                                 /*this new action created on 22 juL*/
                                 /*   if(msisdn.text.length>1 && recontractingKey != null){
                                    RecontractingEligible_API();
                                    setState(() {
                                      checkPackagesList=true;
                                    });
                                  }*/


                                 if(getRoleType=="DeliveryEShop" && orderId.text!='' && msisdn.text.length>1 && recontractingKey != null){
                                   RecontractingEligible_API();
                                   setState(() {
                                     checkPackagesList=true;
                                   });
                                 }
                                 if(getRoleType!="DeliveryEShop" && msisdn.text.length>1 && recontractingKey != null){
                                   RecontractingEligible_API();
                                   setState(() {
                                     checkPackagesList=true;
                                   });
                                 }

                               },

                               child: Text(
                                 "reContract.check".tr().toString(),
                                 style: TextStyle(
                                     color: Colors.white,
                                     letterSpacing: 0,
                                     fontSize: 16,
                                     fontWeight: FontWeight.bold),
                               ),
                             )
                         ),
                         SizedBox(height: 20),
                       ],
                     ),
                   ),
                    /***********************************************************************************************************************************************/
                    SizedBox(height: 15),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.only(bottom: 2),
                        child: ListView.builder(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: EligiblePackages.length,
                          itemBuilder: (context, index) {
                            return Container(

                              color: Colors.white,
                              child: Column(
                                children: [

                                  SizedBox(

                                    height: index != EligiblePackages.length - 1 ? 50 : 55,
                                    child: ListTile(
                                      title: Text(

                                        EasyLocalization.of(context).locale ==
                                            Locale("en", "US")
                                            ? EligiblePackages[index]['value']
                                            : EligiblePackages[index]['valueAr'],
                                        textAlign: TextAlign.left,
                                        textDirection: ui.TextDirection.ltr,
                                        style: TextStyle(

                                          fontSize: 16,
                                          letterSpacing: 0,
                                          color: Color(0xff11120e),
                                          fontWeight: FontWeight.normal,
                                        ),

                                      ),
                                      trailing: TextButton(
                                        child: Text(
                                          "Menu_Form.select".tr().toString(),
                                          style: TextStyle(
                                            color: Color(0xFF0070c9),
                                            letterSpacing: 0,
                                            fontSize: 16,
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  GenerateContract(Permessions, role, outDoorUserName ,msisdn.text,int.parse(recontractingKey),EligiblePackages[index]['key'],EligiblePackages[index]['value'],orderId.text),
                                            ),
                                          );

                                        },
                                      ),
                                    ),
                                  ),
                                  index != EligiblePackages.length - 1
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
                    ),
                  ],
                ),

                // Transparent overlay
               Visibility(
                  visible: checkOptions, // Adjust the condition based on when you want to show the overlay
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
                  visible: checkPackagesList, // Adjust the condition based on when you want to show the overlay
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
