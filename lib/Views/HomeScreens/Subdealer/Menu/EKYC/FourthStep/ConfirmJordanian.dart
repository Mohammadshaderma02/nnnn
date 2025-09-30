
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:dio/dio.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';

class ConfirmJordanian extends StatefulWidget {
  final Function onStepChanged;
  ConfirmJordanian({ this.onStepChanged});

  @override
  State<ConfirmJordanian> createState() => _ConfirmJordanianState();
}

class _ConfirmJordanianState extends State<ConfirmJordanian> {
  DateTime backButtonPressedTime;

String firstName="";
String middleName="";
  String lastName="";
  String fullName = "";

  bool firstSwitch=false;
  bool secondSwitch=false;

  bool _showNativeView = false;

  void changeFirstSwitched(value) async {
    setState(() {
      firstSwitch = !firstSwitch;
    });
  }

  void changeSecondSwitched(value) async {
    setState(() {
      secondSwitch = !secondSwitch;
    });
  }
  int getScreen() {
    switch ( globalVars.currentStep) {
      case 1:
        setState(() {
          globalVars.currentScreenIndex = 0;
        });

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
        if(globalVars.currentStep==4 && globalVars.currentScreen==4){
          setState(() {
            globalVars.currentScreenIndex = 3;
          });
        }
        if(globalVars.currentStep==4 && globalVars.currentScreen==3){
          setState(() {
            globalVars.currentScreenIndex = 4;
          });
        }
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

          backgroundColor: Color(0xFFEBECF1),
          body:  ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 25, bottom: 0, left: 0, right: 0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                 Container(
                    margin: EdgeInsets.symmetric(horizontal: 10), // Add padding here
                    child:  Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10), // Add padding here
                        child: Center(
                          child:Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")? "Please check and confirm your ID scan information": "الرجاء التحقق من معلومات مسح الهوية وتأكيدها",
                            textAlign: TextAlign.center,
                            // textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,


                            ),
                          ),
                        )
                    ),
                 ),
                  SizedBox(height: 20),

                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),// Set height as per your requirement
                      decoration: BoxDecoration(
                        color: Colors.white, // Background color
                        border: Border.all(
                          color: Colors.white, // Border color
                          width: 2.0, // Border width
                        ),
                        borderRadius: BorderRadius.circular(5.0), // Border radius
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center, // Align text to the start (left)
                        children: [
                          SizedBox(height: 10),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  EasyLocalization.of(context).locale == Locale("en", "US")?  "Full Name (Arabic)": "الاسم بالكامل (بالعربية)",
                                  style: TextStyle(fontSize: 12,
                                      color: Color(0xFF5E5E5E),
                                      fontWeight: FontWeight.normal),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  globalVars.fullNameAr,
                                  style: TextStyle(fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  EasyLocalization.of(context).locale == Locale("en", "US")? "Full Name (English)": "الاسم بالكامل (بالإنجليزية)",
                                  style: TextStyle(fontSize: 12,
                                      color: Color(0xFF5E5E5E),
                                      fontWeight: FontWeight.normal),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  globalVars.fullNameEn,
                                  style: TextStyle(fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                              children:[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")? "National Number": "رقم الهوية",
                                    style: TextStyle(fontSize: 12,
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.normal),
                                    softWrap: true,
                                  ),
                                ),
                                Expanded(
                                  flex:1,
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")? "Gender": "الجنس",
                                    style: TextStyle(fontSize: 12,
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.normal),
                                    softWrap: true,
                                  ),)
                              ]
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  globalVars.natinalityNumber,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              SizedBox(width: 10), // spacing between the texts
                              Expanded(
                                flex: 1,
                                child: Text(
                                  globalVars.gender,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                              children:[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")?"ID no": "رقم الهوية",
                                    style: TextStyle(fontSize: 12,
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.normal),
                                    softWrap: true,
                                  ),
                                ),
                                Expanded(
                                  flex:1,
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")? "Birth Date": "تاريخ الميلاد",
                                    style: TextStyle(fontSize: 12,
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.normal),
                                    softWrap: true,
                                  ),)
                              ]
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  globalVars.cardNumber,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              SizedBox(width: 10), // spacing between the texts
                              Expanded(
                                flex: 1,
                                child: Text(
                                  globalVars.birthdate,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween, // added line
                              children:[
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")? "Blood Group": "فصيلة الدم",
                                    style: TextStyle(fontSize: 12,
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.normal),
                                    softWrap: true,
                                  ),
                                ),
                                Expanded(
                                  flex:1,
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")? "Registration Number": "رقم التسجيل",
                                    style: TextStyle(fontSize: 12,
                                        color: Color(0xFF5E5E5E),
                                        fontWeight: FontWeight.normal),
                                    softWrap: true,
                                  ),)
                              ]
                          ),
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  globalVars.bloodGroup,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                              SizedBox(width: 10), // spacing between the texts
                              Expanded(
                                flex: 1,
                                child: Text(
                                  globalVars.registrationNumber,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  EasyLocalization.of(context).locale == Locale("en", "US")? "Expiry Date":"تاريخ الانتهاء",
                                  style: TextStyle(fontSize: 12,
                                      color: Color(0xFF5E5E5E),
                                      fontWeight: FontWeight.normal),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Flexible(
                                child: Text(
                                  globalVars.expirayDate,
                                  style: TextStyle(fontSize: 12,
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold),
                                  softWrap: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          Image(
                            width: 250,
                            height: 250,

                            image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/IDFrame.png'),

                            fit: BoxFit.contain, // This will fit the image within the container
                          ),
                          SizedBox(height: 5),

                        ],
                      ),
                      // Other child widgets can be added here if needed
                    ),

                  ),

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
                        globalVars.nationality=true;
                        globalVars.currentScreen=4;
                        globalVars.currentStep=4;
                        widget.onStepChanged(); // Notify the parent widget to update value
                        globalVars.isValidIdentification=false;
                        globalVars.capturedPaths.clear();
                        globalVars.capturedBase64.clear();

                        globalVars.isValidPassportIdentification=false;
                        globalVars.capturedPathsMRZ="";
                        globalVars.capturedBase64MRZ="";
                        globalVars.sanadValidation = false;
                        globalVars.tackID = false;
                        globalVars.tackJordanPassport=false;


                        globalVars.tackTemporary = false;
                        globalVars.tackForeign=false;
                        globalVars.capturedPathsTemporary="";
                        globalVars.capturedBase64Temporary="";
                        globalVars.capturedPathsForeign="";
                        globalVars.capturedBase64Foreign="";
                        globalVars.isValidTemporaryIdentification = false;
                        globalVars.isValidForeignIdentification = false;
                        globalVars.isValidLivness=false;
                        globalVars.videoPathUploaded="";
                        globalVars.merchantID="";
                        globalVars.terminalID="";
                        globalVars.otp_ekyc="";


                        getScreen();
                        print("Back Step: ${globalVars.currentStep}");
                      });

                     /* Disable on 27 March 2025 setState(() {
                        if (globalVars.currentStep > 1) {
                          globalVars.currentStep--;
                          widget.onStepChanged();

                        } else {

                        }
                        widget.onStepChanged();
                        getScreen();
                        print("Back Step: ${globalVars.currentStep}");
                      });*/
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
                        Text(EasyLocalization.of(context).locale == Locale("en", "US")?'Next':"التالي", style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      onWillPop: onWillPop,
    );
  }
}
