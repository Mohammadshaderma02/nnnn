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

class ChangeIndoorOutdoor extends StatefulWidget {
  List<dynamic> Permessions;

  ChangeIndoorOutdoor(this.Permessions);

  @override
  State<ChangeIndoorOutdoor> createState() => _ChangeIndoorOutdoorState(this.Permessions);
}

class _ChangeIndoorOutdoorState extends State<ChangeIndoorOutdoor> {
  _ChangeIndoorOutdoorState(this.Permessions);

  List<dynamic> Permessions;

  TextEditingController msisdn = TextEditingController();
  TextEditingController buildingCode = TextEditingController();


  bool emptyMAISDN = false;
  bool errorMAISDN = false;

  bool emptyBuildingCode = false;


  var options_OUTDOOR_5G = [];
  List<String> Value_en = [];
  List<String> Value_ar = [];
  var selected_key;

  bool checkOptions =false;
  bool checkLookupList=false;
  bool  emptySelectedOptions =false;
  String OutdoorItemKey;
  String optionId;
  String optionName;




  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      checkOptions=true;
    });
    LookupOUTDOOR_5G_API();
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

  LookupOUTDOOR_5G_API() async {

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
        checkOptions=false;
        emptyMAISDN=false;
        emptyBuildingCode=false;
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
            emptyBuildingCode=false;
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
            options_OUTDOOR_5G=result['data'];
            emptyMAISDN=false;
            checkOptions=false;
            emptyBuildingCode = false;
          });
          for (var i = 0; i < result['data'].length; i++) {
            Value_en.add(result['data'][i]['value'].toString());
            Value_ar.add(result['data'][i]['valueAr'].toString());

          }
          print("******start****");
          print(options_OUTDOOR_5G);
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
          emptyBuildingCode =false;
        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        checkOptions=false;
        emptyMAISDN=false;
        emptyBuildingCode = false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  void getNameSelected(val) {
    for (var i = 0; i < options_OUTDOOR_5G.length; i++) {
      if (options_OUTDOOR_5G[i]['key'].contains(val)) {
        setState(() {
          // optionName = options_OUTDOOR_5G[i]['value'];
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
                  value: OutdoorItemKey,
                  onChanged: (  String newValue) {
                    setState(() {
                      OutdoorItemKey = newValue;
                      getNameSelected(newValue);
                    });

                  },
                  items: options_OUTDOOR_5G.map((valueItem) {
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

  Future<void> _showAlertDialogSuccess(BuildContext context,valuEnglish,valuArabaic) async {
    return showDialog<void>(
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
                  checkLookupList=false;
                  checkOptions=false;
                  emptyMAISDN=false;
                  emptyBuildingCode= false;
                  msisdn.text='';
                  buildingCode.text='';
                  OutdoorItemKey = null;
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

  changingIndoorOutdoor_API() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/device5G/indoorToOutdoor';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn.text,
      "itemCode": OutdoorItemKey,
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
        checkLookupList=false;
        checkOptions=false;
        emptyMAISDN=false;
        emptyBuildingCode= false;
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
          checkLookupList=false;
          checkOptions=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          msisdn.text='';
          buildingCode.text='';
          OutdoorItemKey = null;
        });


      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          checkLookupList=false;
          checkOptions=false;
          emptyMAISDN=false;
          emptyBuildingCode= false;
          msisdn.text='';
          buildingCode.text='';
          OutdoorItemKey = null;


        });
      }

      return result;
    } else {
      setState(() {
        checkLookupList=false;
        checkOptions=false;
        emptyMAISDN=false;
        emptyBuildingCode = false;
        msisdn.text='';
        buildingCode.text='';
        OutdoorItemKey = null;

      });

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
                EasyLocalization.of(context).locale ==
                    Locale("en", "US")
                    ? "Changing Indoor to Outdoor":"التغيير الداخل إلى الخارج",
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
                          buildBuildingCode(),
                          emptyBuildingCode == true
                              ? ReusableRequiredText(
                              text: "Menu_Form.serial_numbe_required"
                                  .tr()
                                  .toString())
                              : Container(),
                          SizedBox(height: 20),
                          buildOutdoorItemCode(),
                          SizedBox(height: 35),
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
                                  /*.............................check Outdoor Item filed......................................*/

                                  if(OutdoorItemKey == null){
                                    setState(() {
                                      emptySelectedOptions=true;
                                    });
                                  }
                                  if(OutdoorItemKey != null){
                                    setState(() {
                                      emptySelectedOptions=false;
                                    });
                                  }
                                  /*.............................check all filed to Submit.................................*/

                                  if(msisdn.text.length>1 && buildingCode.text.length > 1 && OutdoorItemKey != null){
                                    changingIndoorOutdoor_API();
                                    setState(() {
                                      checkLookupList=true;
                                    });
                                  }

                                },

                                child: Text(
                                    EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? "Change":"تغيير",
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
                  visible: checkLookupList, // Adjust the condition based on when you want to show the overlay
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
