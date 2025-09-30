import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/FifthStep/IdentificationSelfRecording.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/FourthStep/CheckIdentity.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/FourthStep/ConfirmJordanian.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/FourthStep/ConfirmNonJordanian.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/SecondStep/numberType.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/FirstStep/simType.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/SixthStep/LineDocumented.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';

class EKYC_Main extends StatefulWidget {
  @override
  EKYC_MainState createState() => EKYC_MainState();
}

class EKYC_MainState extends State<EKYC_Main> {
  @override

  void initState() {
    getScreen();
    // TODO: implement initState
    super.initState();
  }

  int _currentStep = 1; // Set the initial step to 1 (first step will be active)

  // Method to get the step text based on the current step
  String getStepText() {
    switch ( globalVars.currentStep) {
      case 1:
        return EasyLocalization.of(context).locale == Locale("en", "US")?"Scan Simcard":"مسح البطاقة";
      case 2:
        return EasyLocalization.of(context).locale == Locale("en", "US")?"Simcard Type":"نوع البطاقة";
      case 3:
        return EasyLocalization.of(context).locale == Locale("en", "US")?"Terms & Conditions":"الشروط والأحكام";
      case 4:
        return EasyLocalization.of(context).locale == Locale("en", "US")?"Check Identity":"التحقق من الهوية";
      case 5:
        return EasyLocalization.of(context).locale == Locale("en", "US")?"Liveness Detection":"كشف الحيوية";
      case 6:
        return EasyLocalization.of(context).locale == Locale("en", "US")?"Line Documentation":"توثيق الخط";

    // Add more cases if needed
      default:
        return "Unknown Step";
    }
  }

  // Variable to control which screen to show
 // int _currentScreenIndex = 0; // 0 -> ScreenOne, 1 -> ScreenTwo, 2 -> ScreenThree


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


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // This removes the back arrow automatically
        title: Row(
          children: [
            Column(
              children: [
                Text('${globalVars.currentStep}',
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 2),
              ],
            ),
            Text('/6',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),
            SizedBox(width: 8),
            Text( getStepText(),
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.normal),
            ),


          ],
        ),
        elevation: 0,
        backgroundColor: ekycColors.primary, // Remove the shadow from the AppBar
      ),
      body: Column(
        children: [
          // Progress indicator
          Container(
            padding: EdgeInsets.all(0), // Optional padding
            decoration: BoxDecoration(
              color:  ekycColors.primary, // Set your desired background color
              borderRadius: BorderRadius.circular(0), // Optional: rounded corners
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(6, (index) {
                bool isActive = index <  globalVars.currentStep; // Mark steps active until the current one
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 2),
                    child: Column(
                      children: [
                        AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          height: 6,
                          color: isActive ? ekycColors.buttonSecondary : ekycColors.secondary,
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),


          Expanded(
            child: IndexedStack(
              index:  globalVars.currentScreenIndex, // Show the screen based on the index
              children: [
                simType(onStepChanged: () {
                  setState(() {}); // This will rebuild EKYC_Main 0
                }),
                numberType(onStepChanged: () {
                  setState(() {}); // This will rebuild EKYC_Main 1
                }),
                Terms_Conditions(onStepChanged: () {
                  setState(() {}); // This will rebuild EKYC_Main 2
                }),
                checkIdentity(onStepChanged: () {
                  setState(() {}); // This will rebuild EKYC_Main 3
                }),
                globalVars.nationality?  ConfirmJordanian(onStepChanged: () {
                  setState(() {}); // This will rebuild EKYC_Main 4
                }):ConfirmNonJordanian(onStepChanged: () {
                  setState(() {}); // This will rebuild EKYC_Main
                }),
                IdentificationSelfRecording(onStepChanged: () {
                  setState(() {}); // This will rebuild EKYC_Main 5
                }),

                LineDocumented(onStepChanged: () {
                  setState(() {}); // This will rebuild EKYC_Main 6
                }),
                // Other screens...
              ],
            ),
          ),
        ],
      ),
    );
  }
}
