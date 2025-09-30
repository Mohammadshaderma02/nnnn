//LineDocumented.dart


import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:http/io_client.dart';
import 'package:http_parser/http_parser.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';

import '../../ChangePackage/changePackage.dart';
import '../../UpgradePackage/EnterMSSIDNumber.dart';
import '../../UpgradePackage/UpgradePackage_Bulk.dart';

class LineDocumented extends StatefulWidget {
  final Function onStepChanged;
  LineDocumented({ this.onStepChanged});
  @override
  _LineDocumentedState createState() => _LineDocumentedState();
}

class _LineDocumentedState extends State<LineDocumented> {
  final bool enableMsisdn = true;
  final String preMSISDN = '';


  @override
  void dispose() {

    super.dispose();
  }


  /*-------------------------------------------------------------------------------------------------------------*/

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



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [


        Scaffold(
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 25, bottom: 25, left: 0, right: 0),
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /*............................................................First Terms............................................................*/

                  Center(
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 25),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          color: Colors.white,
                          width: 2.0,
                        ),
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                      child: Column(

                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(height: 20),
                          Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")?
                            "Your line has been documented successfully.\n you will receive your contract via SMS": "تم توثيق خطك بنجاح.\nستتلقى عقدك عبر الرسائل القصيرة",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.black,
                              letterSpacing: 0,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(left: 5,right: 5,top: 50,bottom: 50),
                            width: 250,
                            height: 250,
                            decoration: BoxDecoration(
                              // You can add decoration if needed
                              border: Border.all(color: Colors.transparent),
                            ),
                            child: Image(
                              image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/documentLine.png'),
                              fit: BoxFit.contain, // This will fit the image within the container
                            ),
                          ),

                          SizedBox(height: 15),
                          Container(
                            height: 48,
                            width: 320,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:  ekycColors.buttonPrimary,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Centering the content horizontally
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: ekycColors.buttonPrimary,
                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                  ),
                                  onPressed:() async{

                                    setState(() {

                                      globalVars.currentStep = 1;
                                      globalVars.currentScreen=0;
                                      globalVars.currentScreenIndex=0;
                                      globalVars. indexSteper=1;

                                      globalVars.capturedPaths.clear();
                                      globalVars.capturedBase64.clear();
                                      globalVars.isValidIdentification = false;

                                      globalVars.capturedPathsMRZ="";
                                      globalVars.capturedBase64MRZ="";
                                      globalVars.isValidPassportIdentification = false;

                                      globalVars.capturedPathsTemporary="";
                                      globalVars.capturedBase64Temporary="";
                                      globalVars.isValidTemporaryIdentification = false;

                                      globalVars.capturedPathsForeign="";
                                      globalVars.capturedBase64Foreign="";
                                      globalVars.isValidForeignIdentification = false;
                                      globalVars.tackID  = false;
                                      globalVars.tackJordanPassport = false;
                                      globalVars.tackForeign=false;
                                      globalVars.tackTemporary=false;
                                      globalVars.tackForeign=false;
                                      globalVars.tackTemporary=false;
                                      globalVars.showPersonalNumber=false;

                                      globalVars.selectedItemIndex = -1;
                                      globalVars.reservedNumber = false;
                                      globalVars.numberSelected="";
                                      globalVars.referanceNumber = "";
                                      globalVars.termCondition1 =false;
                                      globalVars.termCondition2 =false;
                                      globalVars.sanadValidation = false;
                                      globalVars.isEsimSelected = false;
                                      globalVars.activeESimTypeNextStep = false;
                                      globalVars.isPhysicalSimSelected = true;
                                      globalVars.enterEmail = false;
                                    });
                                    Navigator.pop(context);
                                    //UpdatePackage_Bulk
                                  /*  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            changePackage(globalVars.permessionsChangePackage, globalVars.roleChangePackage, globalVars.outDoorUserNameChangePackage),
                                      ),
                                    );*/
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            EnterMSSIDNumber(globalVars.permessionsChangePackage, globalVars.roleChangePackage, globalVars.outDoorUserNameChangePackage,enableMsisdn, preMSISDN),
                                      ),
                                    );
                                  },
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")? "Choose your package": "اختر باقتك",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        /*  Container(
                            height: 48,
                            width: 420,
                            margin: EdgeInsets.symmetric(horizontal: 30),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color:  ekycColors.buttonPrimary,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center, // Centering the content horizontally
                              children: [
                                TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: ekycColors.buttonPrimary,
                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                  ),
                                  onPressed:() async{
                                    if (globalVars.currentStep > 1) {
                                      globalVars.currentStep -= 6;
                                      widget.onStepChanged();
                                      // globalVars.currentScreen=0;
                                    }


                                    setState(() {

                                        globalVars.currentStep = 1;
                                        globalVars.currentScreen=0;
                                        globalVars.currentScreenIndex=0;
                                        globalVars. indexSteper=1;

                                        globalVars.capturedPaths.clear();
                                        globalVars.capturedBase64.clear();
                                        globalVars.isValidIdentification = false;

                                        globalVars.capturedPathsMRZ="";
                                        globalVars.capturedBase64MRZ="";
                                        globalVars.isValidPassportIdentification = false;

                                        globalVars.capturedPathsTemporary="";
                                        globalVars.capturedBase64Temporary="";
                                        globalVars.isValidTemporaryIdentification = false;

                                        globalVars.capturedPathsForeign="";
                                        globalVars.capturedBase64Foreign="";
                                        globalVars.isValidForeignIdentification = false;
                                        globalVars.tackID  = false;
                                        globalVars.tackJordanPassport = false;
                                        globalVars.tackForeign=false;
                                        globalVars.tackTemporary=false;
                                        globalVars.tackForeign=false;
                                        globalVars.tackTemporary=false;
                                        globalVars.showPersonalNumber=false;

                                        globalVars.selectedItemIndex = -1;
                                        globalVars.reservedNumber = false;
                                        globalVars.numberSelected="";
                                        globalVars.referanceNumber = "";
                                        globalVars.termCondition1 =false;
                                        globalVars.termCondition2 =false;
                                        globalVars.sanadValidation = false;
                                      });
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")? "Close": "اغلاق",
                                    style: TextStyle(
                                      color: Colors.white,
                                      letterSpacing: 0,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),*/




                        ],
                      ),
                    ),
                  ),







                ],
              ),
            ],
          ),
          /*............................................................Next-Back Buttons............................................................*/
          // ✅ Fixed Next - Back Buttons at the Bottom
        /*  bottomNavigationBar: Padding(
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
                        Text('Back', style: TextStyle(color: Colors.white)),
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
                        print("***********************Befor****************************");
                        print("***************************************************");
                        print("******************Current Step*********************");
                        print(globalVars.currentStep);
                        print("****************Current Screen Index***************");
                        print(globalVars.currentScreenIndex);
                        print("******************Current Screen*******************");
                        print(globalVars.currentScreen);
                        print("***************************************************");
                        print("***************************************************");
                        if ( globalVars.currentStep < 6) { // Ensure the last step is 5
                          globalVars.currentStep++;
                          widget.onStepChanged(); // Notify the parent widget to update value
                        }
                        getScreen();
                        print("***********************After****************************");
                        print("***************************************************");
                        print("******************Current Step*********************");
                        print(globalVars.currentStep);
                        print("****************Current Screen Index***************");
                        print(globalVars.currentScreenIndex);
                        print("******************Current Screen*******************");
                        print(globalVars.currentScreen);
                        print("***************************************************");
                        print("***************************************************");
                        print("Next Step: ${globalVars.currentStep}");
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Next', style: TextStyle(color: Colors.white)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded, color: Colors.white, size: 15),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),*/
        ),


      ],
    );
  }
}








































