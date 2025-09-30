import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recontracting/GenerateContract.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:ui' as ui;
import '../../../../../Shared/BaseUrl.dart';
import '../../../../ReusableComponents/requiredText.dart';

APP_URLS urls = new APP_URLS();

class RentalHandsetStamping extends StatefulWidget {
  List<dynamic> Permessions;

  RentalHandsetStamping(this.Permessions);

  @override
  State<RentalHandsetStamping> createState() => _RentalHandsetStampingState(this.Permessions);
}

class _RentalHandsetStampingState extends State<RentalHandsetStamping> {
  _RentalHandsetStampingState(this.Permessions);

  List<dynamic> Permessions;

  TextEditingController msisdn = TextEditingController();
  TextEditingController buildingCode = TextEditingController();
  TextEditingController serialNumber = TextEditingController();


  bool emptyMAISDN = false;
  bool emptyBuildingCode = false;
  bool emptySerialNumber = false;

  List<String> Value_en = [];
  List<String> Value_ar = [];

  bool checkValidate =false;
  bool checkStamp=false;

  bool isValidate=false;
  bool isStamp=false;


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
                emptyMAISDN=false;
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
            controller: buildingCode,
            // maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.text,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyBuildingCode== true
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
                emptyBuildingCode=false;

              })
            },

          ),
        )
      ],
    );
  }

  Widget buildSerialNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ?"Serial Number":"الرقم التسلسلي",
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
            controller: serialNumber,
            // maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.text,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptySerialNumber== true
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
                emptySerialNumber=false;

              })
            },

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
                  checkValidate=false;
                  emptyMAISDN=false;
                  emptyBuildingCode= false;
                  emptySerialNumber=false;
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
  ValidateMSISDN_API() async {
    setState(() {
      checkValidate = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/device5G/validate';
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
        isStamp=false;
        isValidate=false;
        checkValidate=false;
        emptyMAISDN=false;
        emptyBuildingCode= false;
        emptySerialNumber=false;
        checkStamp=false;

      });
      print('401  error ');
       UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){
        _showAlertDialogSuccess(context,result["message"],result["messageAr"]);

        setState(() {
          isStamp=true;
          isValidate=true;
          checkValidate=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          emptySerialNumber=false;
          checkStamp=false;

        });


      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          isStamp=false;
          isValidate=false;
          checkValidate=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          msisdn.text='';
          buildingCode.text='';
          serialNumber.text='';
          emptySerialNumber=false;
          checkStamp=false;



        });
      }

      return result;
    } else {
      setState(() {
        isStamp=false;
        isValidate=false;
        checkValidate=false;
        emptyMAISDN=false;
        emptyBuildingCode = false;
        msisdn.text='';
        buildingCode.text='';
        serialNumber.text='';
        emptySerialNumber=false;
        checkStamp=false;


      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  Stamp_API() async {

    setState(() {
      checkStamp= true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/device5G/stamp';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn.text,
      "serialNumber": serialNumber.text,
      "buildingCode": buildingCode.text
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
        isStamp=false;
        isValidate=false;
        checkStamp=false;
        checkValidate=false;
        emptyMAISDN=false;
        emptyBuildingCode= false;
        emptySerialNumber=false;
        checkStamp=false;
      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){
        _showAlertDialogSuccess(context,result["message"],result["messageAr"]);

        setState(() {
          isStamp=false;
          isValidate=false;
          checkStamp=false;
          checkValidate=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          emptySerialNumber=false;
          checkStamp=false;
          msisdn.text='';
          buildingCode.text='';
          serialNumber.text='';

        });


      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          isStamp=false;
          isValidate=false;
          checkStamp=false;
          checkValidate=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          emptySerialNumber=false;
          checkStamp=false;
          msisdn.text='';
          buildingCode.text='';
          serialNumber.text='';



        });
      }

      return result;
    } else {
      setState(() {
        isStamp=false;
        isValidate=false;
        checkStamp=false;
        checkValidate=false;
        emptyMAISDN=false;
        emptyBuildingCode = false;
        emptySerialNumber=false;
        checkStamp=false;
        msisdn.text='';
        buildingCode.text='';
        serialNumber.text='';


      });

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }
  /*.............................................................................................*/



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
                    ? "Rental Handset Stamping":"ختم الجهاز المستأجر",
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
                          MSISDN(),
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
                          isValidate == true? buildSerialNumber():Container(),
                          emptySerialNumber == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.serial_numbe_required"
                                  .tr()
                                  .toString())
                              : Container(),
                          SizedBox(height: 35),
                          /*.............................Button MSISDN filed to Validate.................................*/
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
                                    ValidateMSISDN_API();

                                  }

                                },

                                child: Text(
                                  EasyLocalization
                                      .of(context)
                                      .locale == Locale("en", "US")
                                      ? 'Validate'
                                      : "تحقق",
                                  style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                          ):
                          Container(),

                          /*.............................Button check all fileds to Stamp.................................*/
                          isValidate == true?
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
                                  /*.............................check building code filed.......................................*/
                                  if(buildingCode.text.length<1){
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      emptyBuildingCode=true;

                                    });
                                  }else{
                                    FocusScope.of(context).unfocus();

                                    setState(() {
                                      emptyBuildingCode=false;
                                    });
                                  }

                                  /*.............................check serialNumber filed.......................................*/
                                  if(serialNumber.text.length<1){
                                    FocusScope.of(context).unfocus();
                                    setState(() {
                                      emptySerialNumber=true;

                                    });
                                  }else{
                                    FocusScope.of(context).unfocus();

                                    setState(() {
                                      emptySerialNumber=false;
                                    });
                                  }

                                  /*.............................check MSISDN filed to Validate.................................*/

                                  if(msisdn.text.length>1 && serialNumber.text.length>1 && buildingCode.text.length>1){
                                    Stamp_API();

                                  }

                                },

                                child: Text(
                                  EasyLocalization
                                      .of(context)
                                      .locale == Locale("en", "US")
                                      ? 'Stamp'
                                      : "ختم",
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
                  visible: checkValidate, // Adjust the condition based on when you want to show the overlay
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
                  visible: checkStamp, // Adjust the condition based on when you want to show the overlay
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
