import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_Jordainian.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_NonJordanina.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/JordainianCustomerInformation.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/FTTHpackage.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_block.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_events.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_state.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../../Shared/BaseUrl.dart';
import '../FTTH/NonJordainianCustomerInformation.dart';

//import '../../CustomBottomNavigationBar.dart';
APP_URLS urls = new APP_URLS();
class BroadBandNationalityList extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  String marketType;
  String packageCode;
  bool isParentEligible;
  bool Packages_5G;
  bool simLockedEligible;
  bool simUnlockedEligible;
  bool isLockedFalge;

  BroadBandNationalityList(
      {this.Permessions,
        this.role,
        this.outDoorUserName,
        this.marketType,
        this.packageCode,
        this.isParentEligible,
        this.Packages_5G,
        this.simLockedEligible,
        this.simUnlockedEligible,
      this.isLockedFalge});

  @override
  _BroadBandNationalityListState createState() =>
      _BroadBandNationalityListState(
          this.Permessions,
          this.role,
          this.outDoorUserName,
          this.marketType,
          this.packageCode,
          this.isParentEligible,
      this.Packages_5G,
          this.simLockedEligible,
          this.simUnlockedEligible,this.isLockedFalge);
}

class _BroadBandNationalityListState extends State<BroadBandNationalityList> {
  bool isRental = true;
  bool switchIsRental = false;
  bool emptySerialNumber = false;
  bool emptyBuildingCode = false;
  bool checkOptions=false;
  bool checkDevice5GType = false;
  bool checkOutdoorItem = false;
  var options_Device_5G = [];
  List<String> Value_en = [];
  List<String> Value_ar = [];
  var selected_key;
  bool emptySelectedOptions = false;
  String DEVICE_5GItemKey;

  var options_OutdoorItemCode = [];
  String OutdoorItemKey;
  List<String> ValueOutdoorItem_en = [];
  List<String> ValueOutdoorItem_ar = [];
  var selectedItem_key;
  bool emptySelectedItemCodeOptions = false;
  String device5GType;
  String rentalMsisdn;
  bool Packages_5G;
  bool simLockedEligible;
  bool simUnlockedEligible;
  bool isLockedFalge;

  final List<dynamic> Permessions;
  String marketType;
  String packageCode;
  bool isParentEligible;


  var role;
  var outDoorUserName;
  bool emptyNationalNo = false;
  bool emptyPassportNo = false;
  bool emptyCommitment = false;
  bool errorNationalNo = false;
  bool errorPassportNo = false;
  bool errorCommitment = false;
  bool isJordanian = false;

  String msisdn = '';
  String userName = '';
  String password = '';

  bool checkNationalDisabled = false;
  bool checkPassportDisabled = false;

  var price;
  var rentalPrice;


  TextEditingController nationalNo = TextEditingController();
  TextEditingController passportNo = TextEditingController();
  TextEditingController SerialNumber = TextEditingController();
  TextEditingController BuildingCode = TextEditingController();
  TextEditingController _commitment = TextEditingController();

  _BroadBandNationalityListState(
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.marketType,
      this.packageCode,
      this.isParentEligible,
      this.Packages_5G,
      this.simLockedEligible,
      this.simUnlockedEligible,
      this.isLockedFalge);
  PostValidateSubscriberBlock postValidateSubscriberBlock;
  String packagesSelect;


  void initState() {
    super.initState();
    setState(() {
      checkDevice5GType=true;

    });
    LookupDevice5GType_API();
    print(widget.marketType);
    print(widget.packageCode);
    print("this.isParentEligible");
    print(widget.isParentEligible);
    postValidateSubscriberBlock =
        BlocProvider.of<PostValidateSubscriberBlock>(context);
  }
/*.......................................for Device5G Type List..................................... */
  LookupDevice5GType_API() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lookup/DEVICE_5G_TYPE';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
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
        checkDevice5GType=false;

      });
      print('401  error ');
       UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){

        if (result["data"] == null || result["data"].length == 0) {
          setState(() {
            checkDevice5GType=false;

          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no data available"
                      : "لا توجد بيانات متاحة")));
        }

        if (result["data"] != null ) {
          LookupOutdoorItemCode_API();
          setState(() {
            options_Device_5G=result['data'];
            checkDevice5GType=false;
            checkOutdoorItem=true;

          });
          for (var i = 0; i < result['data'].length; i++) {
            Value_en.add(result['data'][i]['value'].toString());
            Value_ar.add(result['data'][i]['valueAr'].toString());

          }
          print("******start****");
          print(options_Device_5G);
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
          checkDevice5GType=false;
        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        checkDevice5GType=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  void getNameSelected(val) {
    print(val);
    for (var i = 0; i < options_Device_5G.length; i++) {
      if (options_Device_5G[i]['key']==(val)) {
        setState(() {
          device5GType = options_Device_5G[i]['value'];
        });

      } else {
        continue;
      }
    }
    print(".......................device5GType.................");
    print(device5GType);

  }

  Widget buildDevice5GType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(

          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ?"Device 5G Type":"5G نوع الجهاز",
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
                  value: DEVICE_5GItemKey,
                  onChanged: (  String newValue) {
                    setState(() {
                      DEVICE_5GItemKey = newValue;
                      getNameSelected(newValue);
                      OutdoorItemKey=null;
                    });
                  print("...DEVICE_5GItemKey....");
                    print(DEVICE_5GItemKey);
                    print("...DEVICE_5GItemKey....");

                    setState(() {
                      _commitment.text =EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? "24 months"
                          : "٢٤ شهر";
                    });
                  /*disable on 3-2-2025 if(DEVICE_5GItemKey == '1' || DEVICE_5GItemKey=="3"){
                      setState(() {
                        _commitment.text =EasyLocalization.of(context).locale ==
                            Locale("en", "US")
                            ? "24 months"
                            : "٢٤ شهر";
                      });
                    }

                    if(DEVICE_5GItemKey == '2' ){
                      setState(() {
                        _commitment.text =EasyLocalization.of(context).locale ==
                            Locale("en", "US")
                            ? "36 months"
                            : "٣٦ شهر";
                      });
                    }*/

                  },
                  items: options_Device_5G.map((valueItem) {
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
/*...................................................................................................*/

/*.........................................for IsRental Switch........................................ */
  void changeSwitchIsRental(value) async {
    print(isRental);
    print(switchIsRental);
    setState(() {
      switchIsRental = !switchIsRental;
      isRental=!switchIsRental;
    });
    if(isRental==false){
      SerialNumber.text = '';
      BuildingCode.text = '';
      DEVICE_5GItemKey=null;
      OutdoorItemKey=null;
    }
    print("...........................................");
    print(isRental);
    print(switchIsRental);
  }

  Widget buildSwitchIsRental() {
    return Container(
      height: 20,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,

        children: <Widget>[
          Switch(
            value: switchIsRental,
            onChanged: (value) {
              changeSwitchIsRental(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF4f2565),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? "Rental"
                : "تأجير",
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.normal,
              fontSize: 15
            ),
          )
        ],
      ),
    );
  }
/*...................................................................................................*/
/*............................................Serial Number..........................................*/
  Widget _SerialNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.serialDevice_number".tr().toString(),
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
            controller: SerialNumber,
            maxLength: 20,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            onTap: () {},
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder:
              emptySerialNumber == true
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: clearSerialNumber,
                icon: Icon(Icons.close),
                color: Color(0xFFA4B0C1),
              ),
              hintText: "Postpaid.enter_serialDevice_number".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  void clearSerialNumber() {
    setState(() {
      SerialNumber.text = '';
      emptySerialNumber = false;
    });
  }
/*..................................................................................................*/
/*............................................Building Code..........................................*/
  Widget _BuildingCoding() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SalesLeads.BuildingCode".tr().toString(),
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
            controller: BuildingCode,
            //maxLength: 20,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            onTap: () {},
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder:
              emptyBuildingCode == true
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: clearBuildingCoding,
                icon: Icon(Icons.close),
                color: Color(0xFFA4B0C1),
              ),
              hintText: EasyLocalization.of(context).locale == Locale("en", "US") ?"Enter building code":"ادخل رمز البناء",
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  void clearBuildingCoding() {
    setState(() {
      BuildingCode.text = '';
      emptyBuildingCode = false;
    });
  }
/*.....................................for Outdoor Item Code List...................................*/
/*..................................................................................................*/
  LookupOutdoorItemCode_API() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lookup/OUTDOOR_5G';
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
        checkOutdoorItem=false;
      });
      print('401  error ');
       UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){

        if (result["data"] == null || result["data"].length == 0) {
          setState(() {
            checkOutdoorItem=false;
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
            options_OutdoorItemCode=result['data'];
            checkOutdoorItem=false;

          });
          for (var i = 0; i < result['data'].length; i++) {
            ValueOutdoorItem_en.add(result['data'][i]['value'].toString());
            ValueOutdoorItem_ar.add(result['data'][i]['valueAr'].toString());

          }
          print("******start****");
          print(options_OutdoorItemCode);
          print(ValueOutdoorItem_en);
          print(ValueOutdoorItem_ar);

        }

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          checkOutdoorItem=false;
          emptyBuildingCode =false;
        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        checkOutdoorItem=false;

        emptyBuildingCode = false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  void getNameItemSelected(val) {
    for (var i = 0; i < options_OutdoorItemCode.length; i++) {
      if (options_OutdoorItemCode[i]['key'].contains(val)) {
        setState(() {
          // optionName = options_OutdoorItemCode[i]['value'];
        });

      } else {
        continue;
      }
    }

  }

  Widget buildOutdoorItemCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(

          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ?"Outdoor Item Code":"رمز العنصر الخارجي",
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
                color: emptySelectedItemCodeOptions == true
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
                  value: OutdoorItemKey,
                  onChanged: (  String newValue) {
                    setState(() {
                      OutdoorItemKey = newValue;
                      getNameItemSelected(newValue);
                    });
                    print(OutdoorItemKey);

                  },
                  items: options_OutdoorItemCode.map((valueItem) {
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
        emptySelectedItemCodeOptions == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required".tr().toString())
            : Container(),
      ],
    );
  }
/*..................................................................................................*/

  void clearNationalNo() {
    setState(() {
      nationalNo.text = '';
    });
  }

  void clearPassportNo() {
    setState(() {
      passportNo.text = '';
    });
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

  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
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

  showAlertDialogSucssesJordanian(BuildContext context, arabicMessage,
      englishMessage, msisdn, Username, Password, Price, rentalMsisdn, rentalPrice, commitment) {
    AlertDialog alert = AlertDialog(
      title: Text("Postpaid.OperationSuccess".tr().toString()),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+msisdn
                  : "رقم الخط"+" : "+" "+msisdn,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),


            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Price"+" : "+" "+Price.toString()+" JD"
                  : "السعر"+" : "+" "+Price.toString()+" د.أ ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            rentalMsisdn.toString()!=null?
            Text(
              this.Packages_5G==true && rentalMsisdn !=null?   EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Rental Msisdn"+" : "+" "+rentalMsisdn.toString()
                  : "رقم التأجير"+" : "+" "+rentalMsisdn.toString():"",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):Container(),

            rentalPrice.toString()!=null?
            Text(
                this.Packages_5G==true && rentalPrice !='0'?   EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Rental Price "+" : "+" "+rentalPrice.toString()+" JD"
                  : "سعر التأجير"+" : "+" "+rentalPrice.toString()+" د.أ ":"",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):Container(),

            commitment.toString()!=null?
            Text(
              this.Packages_5G==true && commitment!=null?    EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Commitment"+" : "+" "+commitment.toString()
                  : "مدة الالتزام"+" : "+" "+commitment.toString():"",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):Container(),

          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            clearNationalNo();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(
            "Postpaid.Cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
            // Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BroadBandJordainian(
                    role: role,
                    outDoorUserName: outDoorUserName,
                    Permessions: Permessions,
                    msisdn: msisdn,
                    nationalNumber: nationalNo.text,
                    passportNumber: null,
                    userName: userName,
                    password: password,
                    marketType: marketType,
                    packageCode: packageCode,
                    isParentEligible: isParentEligible,
                    price:price,
                    isRental:switchIsRental,
                    device5GType:switchIsRental== false?"0":device5GType,
                    buildingCode:BuildingCode.text,
                    serialNumber:SerialNumber.text,
                    itemCode:OutdoorItemKey,
                    rentalMsisdn:rentalMsisdn,
                    Packages_5G:Packages_5G,
                    rentalPrice:rentalPrice,
                    simLockedEligible:simLockedEligible,
                    simUnlockedEligible:simUnlockedEligible
                   ),
              ),
            );
          },
          child: Text(
            "Postpaid.Next".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(child: alert);
      },
    );
  }

  showAlertDialogSucssesNoneJordanian(BuildContext context, arabicMessage,
      englishMessage, msisdn, Username, Password, Price, rentalMsisdn, rentalPrice, commitment) {
    AlertDialog alert = AlertDialog(
      title: Text("Postpaid.OperationSuccess".tr().toString()),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+msisdn
                  : "رقم الخط"+" : "+" "+msisdn,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Price"+" : "+" "+Price.toString()+" JD "
                  : "السعر"+" : "+" "+Price.toString()+" د.أ ",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),


            rentalMsisdn.toString()!=null?
            Text(
              this.Packages_5G==true && rentalMsisdn !=null?     EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Rental Msisdn"+" : "+" "+rentalMsisdn.toString()
                  : "رقم التأجير"+" : "+" "+rentalMsisdn.toString():"",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):Container(),

            rentalPrice.toString()!=null?
            Text(
              this.Packages_5G==true && rentalPrice !='0'?   EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Rental Price"+" : "+" "+rentalPrice.toString()+" JD "
                  : "سعر التأجير"+" : "+" "+rentalPrice.toString()+" د.أ ":"",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):Container(),

            commitment.toString()!=null?
            Text(
              this.Packages_5G==true && commitment!=null?   EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Commitment"+" : "+" "+commitment.toString()
                  : "مدة الالتزام"+" : "+" "+commitment.toString():"",
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):Container(),


          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            clearPassportNo();
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(
            "Postpaid.Cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);
print("..........switchIsRental/BroadBandNonJordainian............");
print(switchIsRental);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BroadBandNonJordainian(
                    role: role,
                    outDoorUserName: outDoorUserName,
                    Permessions: Permessions,
                    msisdn: msisdn,
                    nationalNumber: null,
                    passportNumber: passportNo.text,
                    userName: userName,
                    password: password,
                    marketType: marketType,
                    packageCode: packageCode,
                    isParentEligible: isParentEligible,
                    price:price,
                    isRental:switchIsRental,
                    device5GType:switchIsRental== false?"0":device5GType,
                    buildingCode:BuildingCode.text,
                    serialNumber:SerialNumber.text,
                    itemCode:OutdoorItemKey,
                    rentalMsisdn:rentalMsisdn,
                    Packages_5G:Packages_5G,
                    rentalPrice:rentalPrice,
                    simLockedEligible:simLockedEligible,
                    simUnlockedEligible:simUnlockedEligible

                   ),
              ),
            );
          },
          child: Text(
            "Postpaid.Next".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return Container(child: alert);
      },
    );
  }

  final msg =
  BlocBuilder<PostValidateSubscriberBlock, PostValidateSubscriberState>(
      builder: (context, state) {
        if (state is PostValidateSubscriberLoadingState) {
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
  final msgTwo =
  BlocBuilder<PostValidateSubscriberBlock, PostValidateSubscriberState>(
      builder: (context, state) {
        if (state is PostValidateSubscriberLoadingState) {
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
  Widget nationalNumber() {
    return BlocListener<PostValidateSubscriberBlock,
        PostValidateSubscriberState>(
        listener: (context, state) {
          if (state is PostValidateSubscriberErrorState) {
            setState(() {
              checkNationalDisabled = false;
            });
            showAlertDialogError(
                context, state.arabicMessage, state.englishMessage);
          }
          if (state is PostValidateSubscriberLoadingState) {
            setState(() {
              checkNationalDisabled = true;
            });
          }
          if (state is PostValidateSubscriberTokenErrorState) {
            UnotherizedError();
            setState(() {
              checkNationalDisabled = false;
            });
          }
          if (state is PostValidateSubscriberSuccessState) {
            setState(() {
              checkNationalDisabled = false;
            });
            setState(() {
              msisdn= state.msisdn;
              userName = state.Username;
              password = state.Password;
              rentalMsisdn=state.rentalMsisdn;
              if(state.Price== 0){
                price= 0.0;
              }else{
                price=state.Price;
              }
              rentalPrice=state.rentalPrice;

            });
            showAlertDialogSucssesJordanian(
                context,
                state.arabicMessage,
                state.englishMessage,
                state.msisdn,
                state.Username,
                state.Password,
                state.Price,
                state.rentalMsisdn,
                state.rentalPrice,
                state.commitment);
            FocusScope.of(context).unfocus();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Postpaid.nationalNo".tr().toString(),
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
                controller: nationalNo,
                maxLength: 10,
                buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Color(0xff11120e)),
                decoration: InputDecoration(
                  enabledBorder:
                  emptyNationalNo == true || errorNationalNo == true
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
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                  ),
                  contentPadding: EdgeInsets.all(16),
                  suffixIcon: IconButton(
                    onPressed: clearNationalNo,
                    icon: Icon(Icons.close),
                    color: Color(0xFFA4B0C1),
                  ),
                  hintText: "Postpaid.enter_nationalNo".tr().toString(),
                  hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                ),
              ),
            ),
            emptyNationalNo == true
                ? ReusableRequiredText(
                text: "Postpaid.nationalNo_required".tr().toString())
                : Container(),
            errorNationalNo == true
                ? ReusableRequiredText(
                text: EasyLocalization.of(context).locale ==
                    Locale("en", "US")
                    ? "Your National Number shoud be 10 digit "
                    : "يجب أن يتكون رقمك الوطني من 10 أرقام")
                : Container(),
            SizedBox(height: 10),
            //checkNationalDisabled == true ? msg : Container(),
            SizedBox(height: 10),
            /*...........................For Device5GType List............................*/
            isRental==false?
            buildDevice5GType():Container(),
            isRental==false?
            SizedBox(height: 20):Container(),
            /*...........................For Commitment Feild............................*/
            DEVICE_5GItemKey != null ? enterCommitment():Container(),
            DEVICE_5GItemKey != null?
            SizedBox(height: 20):Container(),
            /*...........................For BuildingCoding field............................*/
            isRental==false && DEVICE_5GItemKey!=null?
            _BuildingCoding():Container(),
            isRental==false && DEVICE_5GItemKey!=null?
            SizedBox(height: 20):Container(),
            /*...........................For SerialNumber Field............................*/
            (DEVICE_5GItemKey == '1'||DEVICE_5GItemKey=='3') ?_SerialNumber():Container(),
            (DEVICE_5GItemKey == '1'||DEVICE_5GItemKey=='3')?SizedBox(height: 20):Container(),
            /*.........................For OutdoorItemCode List............................*/
            (DEVICE_5GItemKey == '2')?
            buildOutdoorItemCode():Container(),
            (DEVICE_5GItemKey == '2')?
            SizedBox(height: 20):Container(),
            /*...........................For Switch Rental Button.........................*/
            marketType=="HOME5G" ?buildSwitchIsRental():Container(),
            SizedBox(height: 25),
            /*...............................For Check Button............................*/
            Container(
              height: 48,
              width: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: TextButton(
                onPressed: checkNationalDisabled
                    ? null
                    : () {
                  if (nationalNo.text == '') {
                    setState(() {
                      emptyNationalNo = true;
                    });
                  }
                  if (nationalNo.text != '') {
                    setState(() {
                      emptyNationalNo = false;
                    });
                  }

                  if (nationalNo.text != ''&& marketType!="HOME5G") {
                    if (nationalNo.text.length != 10) {
                      setState(() {
                        errorNationalNo = true;
                      });
                    } else {
                      postValidateSubscriberBlock.add(PostValidateSubscriberPressed(
                          marketType: marketType,
                          isJordanian: isJordanian,
                          nationalNo: nationalNo.text,
                          passportNo: passportNo.text,
                          packageCode: packageCode,
                          msisdn: null,
                          isRental:switchIsRental,
                          device5GType:switchIsRental== false?"0":device5GType,
                          buildingCode:BuildingCode.text,
                          serialNumber:SerialNumber.text,
                          itemCode:OutdoorItemKey,
                          isLocked:isLockedFalge

                      ));
                    }
                  }
                  /*..................................Check Rental Field................................*/
                  if(nationalNo.text != '' && marketType=="HOME5G" && switchIsRental== false){
                    if (nationalNo.text.length != 10) {
                      setState(() {
                        errorNationalNo = true;
                      });
                    } else {
                      postValidateSubscriberBlock.add(PostValidateSubscriberPressed(
                        marketType: marketType,
                        isJordanian: isJordanian,
                        nationalNo: nationalNo.text,
                        passportNo: passportNo.text,
                        packageCode: packageCode,
                        msisdn: null,
                          isRental:switchIsRental,
                          device5GType:switchIsRental== false?"0":device5GType,
                          buildingCode:BuildingCode.text,
                          serialNumber:SerialNumber.text,
                          itemCode:OutdoorItemKey,
                          isLocked:isLockedFalge

                      ));
                    }

                  }

                  if(marketType=="HOME5G" && switchIsRental== true){

                    if(DEVICE_5GItemKey==null){
                      setState(() {
                        emptySelectedOptions=true;
                      });
                    }

                    if(DEVICE_5GItemKey!=null && (DEVICE_5GItemKey=='1' || DEVICE_5GItemKey=='3' )){
                      if(SerialNumber.text == ''){
                        setState(() {
                          emptySerialNumber=true;
                        });
                      }
                      if(BuildingCode.text == ''){
                        setState(() {
                          emptyBuildingCode=true;
                        });
                      }

                    }

                    if(DEVICE_5GItemKey!=null && (DEVICE_5GItemKey=='2')){
                      if(OutdoorItemKey==null){
                        setState(() {
                          emptySelectedItemCodeOptions=true;
                        });

                      }
                      if(BuildingCode.text == ''){
                        setState(() {
                          emptyBuildingCode=true;
                        });
                      }

                    }

                    if (nationalNo.text != '' && DEVICE_5GItemKey!=null && BuildingCode.text != '') {

                      postValidateSubscriberBlock
                          .add(PostValidateSubscriberPressed(
                          marketType: marketType,
                          isJordanian: isJordanian,
                          nationalNo: nationalNo.text,
                          passportNo: passportNo.text,
                          packageCode: packageCode,
                          msisdn: null,
                          isRental:switchIsRental,
                          device5GType:switchIsRental== false?"0":device5GType,
                          buildingCode:BuildingCode.text,
                          serialNumber:SerialNumber.text,
                          itemCode:OutdoorItemKey,
                          isLocked: isLockedFalge
                      ));
                    }

                  }
                  /*...................................................................................*/
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                child: Text(
                  "Postpaid.check".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ));
  }

  Widget passportNumber() {
    return BlocListener<PostValidateSubscriberBlock,
        PostValidateSubscriberState>(
        listener: (context, state) {
          if (state is PostValidateSubscriberLoadingState) {
            setState(() {
              checkPassportDisabled = true;
            });
          }
          if (state is PostValidateSubscriberErrorState) {
            setState(() {
              checkPassportDisabled = false;
            });
            showAlertDialogError(
                context, state.arabicMessage, state.englishMessage);
          }
          if (state is PostValidateSubscriberTokenErrorState) {
            UnotherizedError();
            setState(() {
              checkPassportDisabled = false;
            });
          }
          if (state is PostValidateSubscriberSuccessState) {
            setState(() {
              checkPassportDisabled = false;
            });
            setState(() {
              msisdn = state.msisdn;
              userName = state.Username;
              password = state.Password;
              rentalMsisdn=state.rentalMsisdn;

              if(state.Price== 0){
                price= 0.0;
              }else{
                price=state.Price;
              }
            });
            showAlertDialogSucssesNoneJordanian(
                context,
                state.arabicMessage,
                state.englishMessage,
                state.msisdn,
                state.Username,
                state.Password,
                state.Price,
                state.rentalMsisdn,
                state.rentalPrice,
                state.commitment);
            FocusScope.of(context).unfocus();
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Postpaid.passportNo".tr().toString(),
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
                controller: passportNo,
                maxLength: 10,
                buildCounter: (BuildContext context,
                    {int currentLength, int maxLength, bool isFocused}) =>
                null,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.name,
                style: TextStyle(color: Color(0xff11120e)),
                decoration: InputDecoration(
                  enabledBorder:
                  emptyPassportNo == true || errorPassportNo == true
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
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                  ),
                  contentPadding: EdgeInsets.all(16),
                  suffixIcon: IconButton(
                    onPressed: clearPassportNo,
                    icon: Icon(Icons.close),
                    color: Color(0xFFA4B0C1),
                  ),
                  hintText: "Postpaid.enter_passportNo".tr().toString(),
                  hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                ),
              ),
            ),
            emptyPassportNo == true
                ? ReusableRequiredText(
                text: "Postpaid.passportNo_required".tr().toString())
                : Container(),
            SizedBox(height: 10),
           // checkPassportDisabled == true ? msgTwo : Container(),
            SizedBox(height: 10),
            /*...........................For Device5GType List............................*/
            isRental==false?
            buildDevice5GType():Container(),
            isRental==false?
            SizedBox(height: 20):Container(),
            /*...........................For Commitment Feild............................*/
            DEVICE_5GItemKey != null ? enterCommitment():Container(),
            DEVICE_5GItemKey != null?
            SizedBox(height: 20):Container(),
            /*...........................For BuildingCoding field............................*/
            isRental==false && DEVICE_5GItemKey!=null?
            _BuildingCoding():Container(),
            isRental==false && DEVICE_5GItemKey!=null?
            SizedBox(height: 20):Container(),
            /*...........................For SerialNumber Field............................*/
            (DEVICE_5GItemKey == '1'||DEVICE_5GItemKey=='3') ?_SerialNumber():Container(),
            (DEVICE_5GItemKey == '1'||DEVICE_5GItemKey=='3')?SizedBox(height: 20):Container(),
            /*.........................For OutdoorItemCode List............................*/
            (DEVICE_5GItemKey == '2')?
            buildOutdoorItemCode():Container(),
            (DEVICE_5GItemKey == '2')?
            SizedBox(height: 20):Container(),
            /*...........................For Switch Rental Button..........................*/
            marketType=="HOME5G" ? buildSwitchIsRental():Container(),
            SizedBox(height: 25),
            /*...............................For Check Button............................*/
            Container(
              height: 48,
              width: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: TextButton(
                onPressed: checkPassportDisabled
                    ? null
                    : () {
                  if (passportNo.text == '') {
                    setState(() {
                      emptyPassportNo = true;
                    });
                  }
                  if (passportNo.text != '') {
                    setState(() {
                      emptyPassportNo = false;
                    });
                  }

                  if (passportNo.text != '' && marketType!="HOME5G") {
                    postValidateSubscriberBlock
                        .add(PostValidateSubscriberPressed(
                        marketType: marketType,
                        isJordanian: isJordanian,
                        nationalNo: nationalNo.text,
                        passportNo: passportNo.text,
                        packageCode: packageCode,
                        msisdn: null,
                        isRental:switchIsRental,
                        device5GType:switchIsRental== false?"0":device5GType,
                        buildingCode:BuildingCode.text,
                        serialNumber:SerialNumber.text,
                        itemCode:OutdoorItemKey,
                        isLocked: isLockedFalge

                    ));
                  }
                  /*..................................Check Rental Field................................*/
                  if(passportNo.text != ''  && marketType=="HOME5G" &&  switchIsRental== false){
                    postValidateSubscriberBlock
                        .add(PostValidateSubscriberPressed(
                        marketType: marketType,
                        isJordanian: isJordanian,
                        nationalNo: nationalNo.text,
                        passportNo: passportNo.text,
                        packageCode: packageCode,
                        msisdn: null,
                        isRental:switchIsRental,
                        device5GType:switchIsRental== false?"0":device5GType,
                        buildingCode:BuildingCode.text,
                        serialNumber:SerialNumber.text,
                        isLocked: isLockedFalge));

                  }

                  if(marketType=="HOME5G"){
                    if(DEVICE_5GItemKey==null){
                      setState(() {
                        emptySelectedOptions=true;
                      });
                    }

                    if(DEVICE_5GItemKey!=null && (DEVICE_5GItemKey=='1' || DEVICE_5GItemKey=='3' )){
                      if(SerialNumber.text == ''){
                        setState(() {
                          emptySerialNumber=true;
                        });
                      }
                      if(BuildingCode.text == ''){
                        setState(() {
                          emptyBuildingCode=true;
                        });
                      }

                    }

                    if(DEVICE_5GItemKey!=null && (DEVICE_5GItemKey=='2')){
                      if(OutdoorItemKey==null){
                        setState(() {
                          emptySelectedItemCodeOptions=true;
                        });

                      }
                      if(BuildingCode.text == ''){
                            setState(() {
                              emptyBuildingCode=true;
                            });
                      }

                    }

                    if (passportNo.text != '' && DEVICE_5GItemKey!=null && BuildingCode.text != '') {
                      postValidateSubscriberBlock
                          .add(PostValidateSubscriberPressed(
                          marketType: marketType,
                          isJordanian: isJordanian,
                          nationalNo: nationalNo.text,
                          passportNo: passportNo.text,
                          packageCode: packageCode,
                          msisdn: null,
                          isRental:switchIsRental,
                          device5GType:switchIsRental== false?"0":device5GType,
                          buildingCode:BuildingCode.text,
                          serialNumber:SerialNumber.text,
                          itemCode:OutdoorItemKey,
                          isLocked: isLockedFalge
                      ));
                    }

                  }
                  /*...................................................................................*/



                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                child: Text(
                  "Postpaid.check".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ));
  }


    Widget enterCommitment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Commitment'
                : "مدة الالتزام",
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
        SizedBox(height: 5),
        Container(
          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            enabled: false,
            // maxLength: 10,
            controller: _commitment,
            keyboardType: TextInputType.phone,
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
        ),

      ],
    );
  }





  List<Item> _data = generateItems(2);
  Widget _buildListPanel() {
    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded) {
        if (isExpanded == false) {
          for (final item in _data) {
            if (_data[index] != item) {
              setState(() {
                item.isExpanded = true;
              });

            }
            setState(() {
              item.isExpanded = false;
            });
          }
        }
        setState(() {
          _data[index].isExpanded = !isExpanded;
          print(_data[index].headerValue);
          SerialNumber.text = '';
          BuildingCode.text = '';
          DEVICE_5GItemKey=null;
          OutdoorItemKey=null;
          emptySerialNumber=false;
          emptyBuildingCode=false;
          emptySelectedOptions=false;
          emptySelectedItemCodeOptions=false;


          if(switchIsRental==false){
            switchIsRental = !switchIsRental;
            isRental=!switchIsRental;
          }
          if(switchIsRental==true){
            switchIsRental = !switchIsRental;
            isRental=!switchIsRental;
          }
        });

        _data[index].headerValue == 'Jordanian' ||
            _data[index].headerValue == 'أردني'
            ? setState(() {
          isJordanian = true;

          print(isJordanian);

        })
            : setState(() {
          isJordanian = false;
          print(isJordanian);

        });
      },
      children: _data.map<ExpansionPanel>((Item item) {
        return isJordanian == true
            ? ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  item.headerValue,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff11120e),
                      fontWeight: FontWeight.normal),
                ),
              );
            },
            body: ListTile(
              title: nationalNumber(),
              //subtitle: Text('To delete this panel '),
              /* trailing: Icon(Icons.delete),
              onTap: (){
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              },*/
            ),
            isExpanded: item.isExpanded)
            : ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded) {
              return ListTile(
                title: Text(
                  item.headerValue,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff11120e),
                      fontWeight: FontWeight.normal),
                ),
              );
            },
            body: ListTile(
              title: passportNumber(),
              //subtitle: Text('To delete this panel '),
              /* trailing: Icon(Icons.delete),
              onTap: (){
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              },*/
            ),
            isExpanded: item.isExpanded);
      }).toList(),
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
            centerTitle: false,
            title: Text(
              "Select_Nationality.select_nationality".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body:Stack(
              children: [
                ListView(
                  padding: EdgeInsets.only(top: 10),
                  children: <Widget>[
                    _buildListPanel(),
                  ],
                ),

               /*....................Transparent overlay for get Lookup Device 5G Type API.....................*/
                Visibility(
                  visible: checkDevice5GType, // Adjust the condition based on when you want to show the overlay
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

                /*........................Transparent overlay for get Lookup OutdoorItem API....................*/
                Visibility(
                  visible: checkOutdoorItem, // Adjust the condition based on when you want to show the overlay
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
                /*........................Transparent overlay for get checkNationalDisabled API....................*/
                Visibility(
                  visible: checkNationalDisabled, // Adjust the condition based on when you want to show the overlay
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
                /*........................Transparent overlay for get checkPassportDisabled API....................*/
                Visibility(
                  visible: checkPassportDisabled, // Adjust the condition based on when you want to show the overlay
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

              ])),
    );
  }
}

class Item {
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({this.expandedValue, this.headerValue, this.isExpanded = false});
}

List<Item> generateItems(int numberOfItem) {
  return List.generate(numberOfItem, (index) {
    return Item(
      headerValue: index == 0
          ? "Select_Nationality.jordanian".tr().toString()
          : "Select_Nationality.non_jordanian".tr().toString(),
      // expandedValue: 'this is item number $index'
    );
  });
}