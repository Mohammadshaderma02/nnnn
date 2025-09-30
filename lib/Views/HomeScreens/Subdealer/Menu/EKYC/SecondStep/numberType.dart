import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../../Shared/BaseUrl.dart';
import 'dart:ui' as ui;
class numberType extends StatefulWidget {
  final Function onStepChanged;
  numberType({ this.onStepChanged});
  @override
  _numberTypeState createState() => _numberTypeState();
}
APP_URLS urls = new APP_URLS();
class _numberTypeState extends State<numberType> {
  bool simTypeData= false;
  bool simTypeGSM= false;

  int selectedNumber = -1; // Initialize with an invalid index

  String selected = "";
  bool isGSMSelected = true;
  bool isDATASelected = false;
  bool isLoading = false;

  TextEditingController _referanceNumber = TextEditingController();

  List<String> items = [];

  int getScreen() {
    switch ( globalVars.currentStep) {
      case 1:
        setState(() {
          globalVars.currentScreenIndex = 0;
        });
      /*  if(globalVars.currentStep==1 && globalVars.currentScreen==0){
          setState(() {
            globalVars.currentScreenIndex = 0;
          });
        }
        if(globalVars.currentStep==1 && globalVars.currentScreen==1){
          setState(() {
            globalVars.currentScreenIndex = 1;
          });
        }*/

        return 0;
      case 2:
        setState(() {
          globalVars.currentScreenIndex = 1;
        });
        return 0;

      case 3:
        setState(() {
          globalVars.currentScreenIndex = 2;
        });
        return 0;

      case 4:
        setState(() {
          globalVars.currentScreenIndex = 3;
        });
        return 0;
      case 5:
        setState(() {
          globalVars.currentScreenIndex = 5;
        });
        return 0;
      case 6:
        setState(() {
          globalVars.currentScreenIndex = 6;
        });
        return 0;


    // Add more cases if needed
      default:
        return 8;
    }
  }


  Widget buildReferanceNumber() {
    return Directionality(textDirection: ui.TextDirection.ltr,
        child: SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  enabled: true,
                  controller: _referanceNumber,
                  keyboardType: TextInputType.number,
                  inputFormatters: [LengthLimitingTextInputFormatter(10)], // Limit length

                  // ✅ Centers the text inside the input field
                  textAlign: TextAlign.center,

                  style: TextStyle(color: Color(0xff11120e), fontSize: 20),

                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                    ),
                    border: OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF4F2565), width: 1.0),
                    ),

                    // ✅ Adjust padding to center hint text
                    contentPadding: EdgeInsets.symmetric(vertical: 18),

                    hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 20),
                    hintText: EasyLocalization.of(context).locale == Locale("en", "US")
                        ? '07********'
                        : "07********",
                  ),
                  onChanged: (value) {
                    if(value.length==10){
                      setState(() {
                        globalVars.referanceNumber = value;
                        globalVars.referanceNumberPredefined = value;
                      });
                    }
                  },
                ),
              ),
            ],
          ),
        ));
  }


  void getGSMlistNumber()async{

    setState(() {
      isLoading = true; // Show loading overlay
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Prepaid/msisdn/list';
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
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));
      setState(() {
        isLoading = false; // Show loading overlay
      });
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      setState(() {
        isLoading = false; // Show loading overlay
      });
      if( result["status"]==0){
            setState(() {
              items =  List<String>.from(result["data"]);
            });


      }else{

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]),backgroundColor: Colors.red));


      }

      return result;
    }
    if(statusCode == 200 && statusCode != 401){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));
      setState(() {

        isLoading = false; // Show loading overlay
      });

    }
  }


  void getReservedNumber()async{

    setState(() {
      isLoading = true; // Show loading overlay
    });


   SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Prepaid/reserve';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    Map test={
      "marketType": globalVars.marketType,
      "msisdn": globalVars.numberSelected,
      "simCard": globalVars.simCard,
      "referenceNumber": globalVars.referanceNumber
    } ;

    String body = json.encode(test);
    print("Body: $body");
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    print(statusCode);
    print(json.decode(response.body));

    if (statusCode == 401) {
      // print('401  error ');
      // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));
      setState(() {
        isLoading = false; // Show loading overlay
      });
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      setState(() {
        isLoading = false; // Show loading overlay
      });
      if( result["status"]==0){

            setState(() {
              globalVars.reservedNumber = true;
            });
      }else{
        setState(() {
          isLoading = false; // Show loading overlay
          globalVars.reservedNumber = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]),backgroundColor: Colors.red));
      }

      return result;
    }
    if(statusCode == 200 && statusCode != 401){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));
      setState(() {
        globalVars.reservedNumber = false;
        isLoading = false; // Show loading overlay
      });

    }
  }

@override
  void initState() {

  getGSMlistNumber();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 25, bottom: 90, left: 0, right: 0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*............................................................First Terms............................................................*/

                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                    child: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")? "Select SIM Type":"اختر نوع البطاقة",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 0,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 15),

                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity, // Ensures full width
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: isGSMSelected ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                      onPrimary: isGSMSelected ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                      side: BorderSide(
                                        color: isGSMSelected ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                        width: 1, // Border width ekycColors.backgroundBorder
                                      ),
                                      minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                    ),
                                    onPressed:  () {
                                      setState(() {
                                        isGSMSelected = true;
                                        isDATASelected = false;
                                        globalVars.referanceNumber = "";
                                        _referanceNumber.text= "";
                                        globalVars.marketType = "GSM";
                                        globalVars.reservedNumber = false;
                                        globalVars.numberSelected = "";
                                        globalVars.selectedItemIndex = -1;
                                        globalVars.referanceNumberPredefined = "";
                                      });
                                    },
                                    child: Text("GSM"),
                                  ),
                                ),
                                SizedBox(width: 10), // Space between buttons
                                Expanded(
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      elevation: 0,
                                      primary: isDATASelected ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                      onPrimary: isDATASelected ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                      side: BorderSide(
                                        color: isDATASelected ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                        width: 1, // Border width ekycColors.backgroundBorder
                                      ),
                                      minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                    ),
                                    onPressed:  () {
                                      setState(() {

                                        isDATASelected = true;
                                        isGSMSelected = false;
                                        _referanceNumber.text= "";
                                        globalVars.referanceNumber = "";
                                        globalVars.numberSelected = "";
                                        globalVars.marketType = "DATA";
                                        globalVars.selectedItemIndex = -1;
                                        globalVars.reservedNumber = false;
                                        globalVars.referanceNumberPredefined = "";

                                      });
                                    },
                                    child: Text("DATA"),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 40),
                          isGSMSelected?
                          Center(

                            child: Text(
                              EasyLocalization.of(context).locale == Locale("en", "US")?"Please choose your preferred number from the list below":"الرجاء اختيار رقمك المفضل من القائمة أدناه",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                            ),
                          ):Container(),
                          isDATASelected?
                          Center(
                            child: Text(
                              EasyLocalization.of(context).locale == Locale("en", "US")? "Please insert Reference Number":"الرجاء إدخال رقم مرجعي",
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                            ),
                          ):Container(),
                          SizedBox(height: 20),
                          isDATASelected?buildReferanceNumber():Container(),

                          isGSMSelected? Container(
                            padding: EdgeInsets.symmetric(horizontal: 18),
                            height: 400,
                            child: ListView.builder(
                              itemCount: items.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      globalVars.reservedNumber = false;
                                      globalVars.selectedItemIndex = index;
                                      globalVars.numberSelected =items[index];
                                    });
                                    print("Selected Item: ${items[index]}");
                                  },
                                  child: Container(
                                    height: 40, // Explicit height
                                    margin: EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                                    decoration: BoxDecoration(
                                      color: globalVars.selectedItemIndex == index
                                          ? ekycColors.buttonPrimary // Selected color
                                          : Colors.white, // Default color
                                      border: Border(
                                        bottom: BorderSide(width: 0.5, color: ekycColors.buttonBorder),
                                      ),
                                    ),
                                    alignment: Alignment.center, // Ensures content is centered
                                    child: Text(
                                      items[index],
                                      style: TextStyle(
                                        color: globalVars.selectedItemIndex == index ? Colors.white : Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ):Container(),


                          SizedBox(height: 50),
                        ],
                      ),
                    ),
                  ),

                  SizedBox(height: 5),



                ],
              ),
            ],
          ),
          /*............................................................Next-Back Buttons............................................................*/
          // ✅ Fixed Next - Back Buttons at the Bottom
          bottomNavigationBar: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
            child: Row(
              children: [
                // Back Button
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: ekycColors.buttonPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        if (globalVars.currentStep > 1) {
                          globalVars.currentStep--;
                          widget.onStepChanged();
                          globalVars.selectedItemIndex = -1;
                          globalVars.reservedNumber = false;
                          globalVars.numberSelected="";
                          globalVars.referanceNumber="";
                          globalVars.referanceNumberPredefined = "";
                          globalVars.enterEmail=false;
                          globalVars.activeESimTypeNextStep = false;
                          globalVars.isEsimSelected = false;
                          globalVars.isPhysicalSimSelected = true;
                          globalVars.userEmail="";
                          globalVars.isEsim= false;

                          globalVars.lineType="";

                        } else {

                        }
                        widget.onStepChanged();
                        getScreen();
                        print("Back Step: ${globalVars.currentStep}");
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.arrow_back_ios, color: Colors.white, size: 15),
                        SizedBox(width: 8),
                        Text(EasyLocalization.of(context).locale == Locale("en", "US")?'Back':"رجوع", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16), // Space between buttons

                // Next Button
                globalVars.reservedNumber?
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: ekycColors.buttonPrimary,
                    ),
                    onPressed: () {


                      setState(() {
                        if ( globalVars.currentStep < 6) { // Ensure the last step is 5
                          globalVars.currentStep++;
                          widget.onStepChanged(); // Notify the parent widget to update value
                        }
                        getScreen();

                        print("Next Step: ${globalVars.currentStep}");
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text( EasyLocalization.of(context).locale == Locale("en", "US")?'Next':"التالي", style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 15),
                      ],
                    ),
                  ),
                )
                    :
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: ekycColors.buttonPrimary,
                    ),
                    onPressed: () {
                      setState(() {
                        if(isGSMSelected && globalVars.selectedItemIndex == -1){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Please select a number": "الرجاء اختيار رقم"),backgroundColor: Colors.red));
                          return;
                        }
                        if(isGSMSelected && globalVars.selectedItemIndex != -1){
                          getReservedNumber();
                          return;
                        }

                        if(isDATASelected && globalVars.referanceNumber.isEmpty){
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Please enter reference number": "الرجاء إدخال رقم المرجع"),backgroundColor: Colors.red));
                          return;
                        }
                        if(isDATASelected && globalVars.referanceNumber.isNotEmpty){
                          getReservedNumber();
                          return;
                        }
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: 8),
                        Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Reserve": "حجز الرقم", style: TextStyle(color: Colors.white)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Positioned.fill(
            child: Container(
              color: Colors.black.withOpacity(0.5),
              child: Center(
                child: CircularProgressIndicator(
                  color: ekycColors.buttonSecondary,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
