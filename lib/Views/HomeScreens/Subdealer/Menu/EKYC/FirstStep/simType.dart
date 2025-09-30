import 'dart:convert';
import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/ChangePackage/changePackage.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/SecondStep/numberType.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import '../../../../../../Shared/BaseUrl.dart';
import 'package:http/io_client.dart';
import 'package:uuid/uuid.dart';
import 'dart:ui' as ui;

import '../../UpgradePackage/EnterMSSIDNumber.dart';
///api/Prepaid/simcard/{simCard} -> to enter sim physical number
///  //I/flutter (20399): Deep link received: salesapp.jo.zain.com://sanad_callback?errorCode=incorrect_login_credentials&error_code=incorrect_login_credentials&login_attempts=3
class simType extends StatefulWidget {
  final Function onStepChanged;
  simType({ this.onStepChanged});
  @override
  _simTypeState createState() => _simTypeState();
}
APP_URLS urls = new APP_URLS();
class _simTypeState extends State<simType> {
  final bool enableMsisdn = true;
  final String preMSISDN = '';
  final uuid = Uuid();
  String uniqueId = "";
  //bool isEsimSelected = false;
 // bool isPhysicalSimSelected = true;

  TextEditingController _email = TextEditingController();
  TextEditingController simCard = TextEditingController();
  String _dataSimCard = "";
  bool showSuffixIconSuccess= false;
  bool showSuffixIconWrong= false;

  bool isLoading =false;  // ✅ Loading overlay
  String simCardType="";


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

  // Function to handle back navigation
  Future<bool> _onWillPop() async {
    // Execute your custom back logic
    if (globalVars.currentStep > 1) {
      setState(() {
        globalVars.currentStep--;
        widget.onStepChanged();
        getScreen();
      });
      return false; // Prevent default back behavior
    } else {
      return false; // Allow app to exit or go back to previous screen
    }
  }

  bool isValidEmail(String email) {
    final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
    return emailRegex.hasMatch(email.trim());
  }

  Widget buildEmail() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: EasyLocalization.of(context).locale ==
                  Locale("en", "US")
                  ? 'Enter email to receive QR code'
                  : "أدخل البريد الإلكتروني لتلقي رمز الاستجابة",
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' * ',
                  style: TextStyle(
                    color: Colors.white,
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
              enabled: true,
              controller: _email,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Color(0xff11120e)),
              decoration: InputDecoration(
                enabledBorder:  const OutlineInputBorder(
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

                hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _ScanSimCard() async {
    await FlutterBarcodeScanner.scanBarcode(
      "#ff6666", "Cancel", true, ScanMode.BARCODE,
    ).then((value) {
      if (value != "-1" && value.length > 10) {
        String trimmed = value.substring(10);
        setState(() {
          _dataSimCard = trimmed;
          simCard.text = _dataSimCard;
          globalVars.simCard =  simCard.text;
        });

        if (_dataSimCard.length == 10) {
          checkSim();
          setState(() {
            showSuffixIconSuccess = true; // Manually trigger the logic from onChanged

          });// Manually trigger it as well
        }
      } else {
        setState(() {
          _dataSimCard = "";
          simCard.text = "";
          showSuffixIconSuccess = false;
        });
      }
    });
  }

  Widget buildManualSimCard() {

    return Directionality(textDirection: ui.TextDirection.ltr,
        child: SizedBox(
          width: double.infinity, // Ensure full width
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[


              Expanded(
                  flex: 2, // Adjust the space taken by text
                  child:  Container(
                    padding: EdgeInsets.only(top: 10),
                    height: 40,
                    child: Text("8996201100",
                      style: TextStyle(
                        color: Color(0xff11120e),
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),),

                  )
              ),

              Expanded(
                flex: 4, // Make text field take more space
                child: Container(
                  height: 40,
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        showSuffixIconSuccess = false; // Show the icon if the input is 10 characters
                        showSuffixIconWrong=false;
                      });
                      if(value.length==10){
                        checkSim();
                        setState(() {
                          showSuffixIconSuccess = true; // Show the icon if the input is 10 characters
                        });
                      }
                    },
                    enabled: true,
                    controller: simCard,
                    keyboardType: TextInputType.number,
                    //  maxLength: 8, // Limit input to 8 characters
                    inputFormatters: [LengthLimitingTextInputFormatter(11)], // Another way to limit length
                    style: TextStyle(color: Color(0xff11120e,),fontSize: 16,fontWeight: FontWeight.bold),
                    decoration: InputDecoration(
                      contentPadding: EdgeInsets.only(top: 10, left: 16,right: 16), // ✅ Correct way
                      enabledBorder: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                      ),
                      border: const OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF4F2565), width: 1.0),
                      ),
                      // contentPadding: EdgeInsets.all(16),
                      hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),

                      // ✅ Add a suffix icon (e.g., a check icon)  Show only if length == 10
                      suffixIcon:showSuffixIconWrong?Icon(
                        Icons.cancel, // Example icon
                        color: Colors.red,
                      ): showSuffixIconSuccess?Icon(
                        Icons.check_circle, // Example icon
                        color: ekycColors.buttonPrimary,
                      ):null,


                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }

  ////////////////////////////////////APIs Part//////////////////////////////////////////
  void generateEKYC_Token()async{

    setState(() {
      isLoading = true; // Show loading overlay
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Services/generate-ekyc-token';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");


    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(url);
    print(response.statusCode);
    print(statusCode);
    print(data);

    print('body generate-ekyc-token  : [${response.body}]');

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
        startSession(result["data"]["data"]);
        print(result["data"]["data"]);
        setState(() {
          globalVars.ekycTokenID = result["data"]["data"];
        });



        setState(() {
          uniqueId=uuid.v4();
        });


      }else{
       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));



      }

      return result;
    }
    if(statusCode == 200 && statusCode != 401 && statusCode != 404){

     // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));

      setState(() {
        isLoading = false; // Show loading overlay
      });

    }else{
      print("Error: ${response.statusCode} - ${response.body}");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));
      setState(() {
        isLoading = false; // Show loading overlay
      });
    }
  }

  Future<void> startSession(String tokenID) async {
    setState(() {
      isLoading = true; // Show loading overlay
    });
    final String apiUrl = "https://079.jo/wid-zain/api/v2/session/start";

    final Map<String, dynamic> payload = {
      'tokenID': uniqueId,
    };

    final ioc = HttpClient()
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;

    final httpClient = IOClient(ioc);

    try {
      final response = await httpClient.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          "Authorization": "Bearer ${tokenID}"
        },
        body: jsonEncode(payload),
      );

      if (response.statusCode == 200) {

        final jsonResponse = jsonDecode(response.body);
        print("✅ Success: ${jsonResponse['message']['en']}");
        print(jsonResponse);
        globalVars.sessionUid= jsonResponse['data']['sessionUid'];
        globalVars.tokenID = jsonResponse['data']['tokenID'];
        print("globalVars.sessionUid");
        print(globalVars.sessionUid);
        globalVars.tokenUid = jsonResponse['data']['tokenUid'];
      }
      if (response.statusCode == 401) {
        print("⚠️ Error ${response.statusCode}: ${response.body}");
        final jsonResponse = jsonDecode(response.body);
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonResponse['message']['en']:jsonResponse['message']['ar']),backgroundColor: Colors.red));
         print(jsonResponse);
        setState(() {
          isLoading = false; // Show loading overlay
        });
        showPermissionDialog(context);
      }
      else {
        print ("response.statusCode");
        print(response.statusCode);
        setState(() {
          isLoading = false; // Show loading overlay
        });
       /* final jsonResponse = jsonDecode(response.body);
       // ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonResponse['message']['en']:jsonResponse['message']['ar']),backgroundColor: Colors.red));
        showPermissionDialog(context);
        print("⚠️ Error hazaimeh${response.statusCode}: ${response.body}");
        setState(() {
          isLoading = false; // Show loading overlay
        });*/
      }
    } catch (e) {
      setState(() {
        isLoading = false; // Show loading overlay
      });
      print("❌ Exception: $e");
    } finally {
      httpClient.close();
    }
  }

  void checkSim()async{

    setState(() {
      isLoading = true; // Show loading overlay
      globalVars.simCard="8996201100"+simCard.text;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
      var finalSimCard = "8996201100"+simCard.text;
      globalVars.simCard = finalSimCard;

    var apiArea = urls.BASE_URL+'/Prepaid/simcard/${finalSimCard}';
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
          simCardType =result["data"]["simCardType"];
        });
        if(result["data"]["simCardType"] == "NotCompleted"){
          showNotCompletedDialog(context);
          setState(() {
            simCardType = "";
            _dataSimCard = "";
            showSuffixIconWrong=false;
            showSuffixIconSuccess=false;
            simCard.text= "";
            globalVars.simCard="";
            globalVars.numberSelected="";

            globalVars.lineType="";
            globalVars.activeSimTypeNextStep=false;
            globalVars.activeESimTypeNextStep=false;
            globalVars.eKycUid=result["data"]["eKycUid"]!= null? result["data"]["eKycUid"].toString().trim():"";
          });
        }
        if(result["data"]["simCardType"] == "Unknown"){
          showUnknownDialog(context);
          setState(() {
            simCardType = "";
            _dataSimCard = "";
            showSuffixIconWrong=false;
            showSuffixIconSuccess=false;
            simCard.text= "";
            globalVars.simCard="";
            globalVars.activeSimTypeNextStep=false;
            globalVars.activeESimTypeNextStep=false;
            globalVars.numberSelected="";

            globalVars.lineType="";
            globalVars.eKycUid=result["data"]["eKycUid"]!= null? result["data"]["eKycUid"].toString().trim():"";

          });
        }
        if(result["data"]["simCardType"] == "Normal"){
          setState(() {
            globalVars.activeSimTypeNextStep=true;
            globalVars.activeESimTypeNextStep=false;
            globalVars.numberSelected="";

            globalVars.lineType="";
            globalVars.eKycUid=result["data"]["eKycUid"]!= null? result["data"]["eKycUid"].toString().trim():"";


          });

        }
        if(result["data"]["simCardType"] == "Predefined"){
          if(result['data']['msisdn'] != null && result['data']['msisdn'].toString().trim().isNotEmpty){
            if(result['data']['requireReferenceNumber']==true){
              _handleShowDialog(); // Show the dialog to enter reference number
             setState(() {
               globalVars.numberSelected = result['data']['msisdn']!=null?result['data']['msisdn'].toString().trim():"";
               globalVars.marketType="GSM";
               globalVars.lineType=result['data']['lineType']!=null?result['data']['lineType'].toString().trim():"";
               globalVars.eKycUid=result["data"]["eKycUid"]!= null? result["data"]["eKycUid"].toString().trim():"";

             });
            }
            if(result['data']['requireReferenceNumber']==false){
              setState(() {
                globalVars.numberSelected = result['data']['msisdn']!=null?result['data']['msisdn'].toString().trim():"";
                globalVars.marketType="GSM";
                globalVars.lineType=result['data']['lineType']!=null?result['data']['lineType'].toString().trim():"";
                globalVars.eKycUid=result["data"]["eKycUid"]!= null? result["data"]["eKycUid"].toString().trim():"";

                globalVars.goToTermCondition = true;
                globalVars.currentStep += 2;
                print(globalVars.currentStep);
                widget.onStepChanged(); // notify parent (optional)
                getScreen();// load next step's UI
              });
            }

          }
         /* if(result['data']['msisdn'] != null && result['data']['msisdn'].toString().trim().isEmpty){
            if(result['data']['requireReferenceNumber']==true){
              _handleShowDialog(); // Show the dialog to enter reference number
            }
            if(result['data']['requireReferenceNumber']==false){
              setState(() {
                globalVars.goToTermCondition = true;
                globalVars.currentStep += 2;
                print(globalVars.currentStep);
                widget.onStepChanged(); // notify parent (optional)
                getScreen();// load next step's UI
              });
            }

          }*/


        }


      }else{

         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]),backgroundColor: Colors.red));

        setState(() {
          simCardType="";
          _dataSimCard = "";
          showSuffixIconWrong=true;
        });

      }

      return result;
    }
    else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),backgroundColor: Colors.red));
      setState(() {
        simCardType="";
        _dataSimCard = "";
        showSuffixIconWrong=true;
        isLoading = false; // Show loading overlay
      });
    }
  }

  //////////////////////////////////////Dialog Parts////////////////////////////////////
  void showPermissionDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Centered Icon
              Image(
                  image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/unknown.png'),
                  width: 60,
                  height: 60),

              const SizedBox(height: 20),

              // Text
              Text(
                EasyLocalization.of(context).locale == Locale("en", "US")?"Permission denied":"تم رفض الإذن",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog

                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ekycColors.buttonPrimary, // Button background color
                    foregroundColor: Colors.white, // Text (and icon) color
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    EasyLocalization.of(context)?.locale == const Locale("en", "US")
                        ? "Close"
                        : "اغلاق",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showNotCompletedDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Centered Icon
              Image(
                  image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/changePackage.png'),
                  width: 60,
                  height: 60),

              const SizedBox(height: 20),

              // Text
               Text(
              EasyLocalization.of(context).locale == Locale("en", "US")?"Please go to change package screen":"يرجى الانتقال إلى شاشة تغيير الحزمة",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EnterMSSIDNumber(globalVars.permessionsChangePackage, globalVars.roleChangePackage, globalVars.outDoorUserNameChangePackage,enableMsisdn, preMSISDN),
                      ),
                    );
                   /* Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            changePackage(globalVars.permessionsChangePackage, globalVars.roleChangePackage, globalVars.outDoorUserNameChangePackage),
                      ),
                    );*/
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ekycColors.buttonPrimary, // Button background color
                    foregroundColor: Colors.white, // Text (and icon) color
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    EasyLocalization.of(context)?.locale == const Locale("en", "US")
                        ? "Change package"
                        : "تغيير الحزمة",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void showUnknownDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismiss on tap outside
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: const EdgeInsets.all(20),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Centered Icon
              Image(
                  image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/unknown.png'),
                  width: 60,
                  height: 60),

              const SizedBox(height: 20),

              // Text
              Text(
                EasyLocalization.of(context).locale == Locale("en", "US")?"You can not continue with the E-KYC process.":"لا تستطيع الاستمرار بعملية التوثيق الإلكتروني",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 20),

              // Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ekycColors.buttonPrimary, // Button background color
                    foregroundColor: Colors.white, // Text (and icon) color
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    EasyLocalization.of(context)?.locale == const Locale("en", "US")
                        ? "Close"
                        : "اغلاق",
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String> showPredefinedDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    String errorText;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),

                  Text(
                    EasyLocalization.of(context).locale == const Locale("en", "US")
                        ? "Reference Number"
                        : "الرقم المرجعي",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 10),

                  TextField(
                    controller: reasonController,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: EasyLocalization.of(context).locale == const Locale("en", "US")
                          ? "Enter reference Number"
                          : "ادخل الرقم المرجعي",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: errorText,
                    ),
                    style: const TextStyle(fontSize: 12),
                  ),

                  const SizedBox(height: 20),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        if (reasonController.text.trim().isEmpty) {
                          setState(() {
                            errorText = EasyLocalization.of(context).locale == const Locale("en", "US")
                                ? "Please enter a reference Number"
                                : "يرجى إدخال رقم مرجعي";
                          });
                        } else {
                          globalVars.referanceNumberPredefined = reasonController.text.trim();
                          Navigator.of(context).pop("next");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ekycColors.buttonPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        EasyLocalization.of(context).locale == const Locale("en", "US")
                            ? "Next"
                            : "التالي",
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Close button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop("reset"); // Return "reset"
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ekycColors.textTertiary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        EasyLocalization.of(context).locale == const Locale("en", "US")
                            ? "Close"
                            : "اغلاق",
                        style: TextStyle(color: ekycColors.textFourth),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<String> showEsimDialog(BuildContext context) {
    TextEditingController reasonController = TextEditingController();
    String errorText;

    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              contentPadding: const EdgeInsets.all(20),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    EasyLocalization.of(context).locale == const Locale("en", "US")
                        ? "Please note that the eSim price will be 2 JD"
                        : "يرجى ملاحظة أن سعر بطاقة eSim سيكون 2 دينار",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),



                  const SizedBox(height: 20),

                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {

                        Navigator.of(context).pop("next");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ekycColors.buttonPrimary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        EasyLocalization.of(context).locale == const Locale("en", "US")
                            ? "Confirmed"
                            : "تأكيد",
                      ),
                    ),
                  ),
                  const SizedBox(height:5),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {

                        setState(() {
                          globalVars.isEsimSelected = false;
                          globalVars.isPhysicalSimSelected = true;
                          simCard.text= "";
                          globalVars.simCard="";
                          _dataSimCard="";
                          showSuffixIconSuccess=false;
                          showSuffixIconWrong=false;
                        });
                        Navigator.of(context).pop("cancel");
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ekycColors.textTertiary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: Text(
                        EasyLocalization.of(context).locale == const Locale("en", "US")
                            ? "Cancel"
                            : "إلغاء",
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),


                ],
              ),
            );
          },
        );
      },
    );
  }

  void _handleShowDialog() async {
    final result = await showPredefinedDialog(context);

    if (result == "reset") {
      setState(() {
        simCardType = "";
        _dataSimCard = "";
        showSuffixIconWrong = false;
        showSuffixIconSuccess = false;
        simCard.text = "";
        globalVars.activeSimTypeNextStep = false;
        globalVars.activeESimTypeNextStep=false;
        globalVars.goToTermCondition = false;
        globalVars.marketType="";
      });
    } else if (result == "next") {
      setState(() {
        globalVars.activeESimTypeNextStep=false;
        globalVars.goToTermCondition = true;
        print("Next step triggered");
        print(globalVars.currentStep);
        globalVars.currentStep += 2;
        print(globalVars.currentStep);
        print("Next step triggered");
        widget.onStepChanged(); // notify parent (optional)
        getScreen();


        // load next step's UI
      });
    }
  }

  void _handleResultEsimShowDialog() async {
    final result = await showEsimDialog(context);

    if (result == "cancel") {
      setState(() {
        globalVars.isEsimSelected = false;
        globalVars.isPhysicalSimSelected  = true;
        simCardType = "";
        _dataSimCard = "";
        showSuffixIconWrong = false;
        showSuffixIconSuccess = false;
        simCard.text = "";
        globalVars.activeSimTypeNextStep = false;
        globalVars.activeESimTypeNextStep=false;
        globalVars.goToTermCondition = false;
        globalVars.enterEmail=false;
      });
    } else if (result == "next") {
      setState(() {
        globalVars.enterEmail=true;
        globalVars.activeESimTypeNextStep=true;

        // load next step's UI
      });
    }
  }


  initState() {
    super.initState();
    generateEKYC_Token();
    globalVars.isEsimSelected = false;
    globalVars.isPhysicalSimSelected = true;
    globalVars.userEmail="";
    globalVars.isEsim= false;
    globalVars.enterEmail=false;// Call the function to generate EKYC token
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child:Stack(
          children: [
            Scaffold(
              backgroundColor: Color(0xFFEBECF1),
              body: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 25, bottom: 0, left: 0, right: 0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      /*............................................................First Terms............................................................*/

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                        child: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Select SIM Type":"حدد نوع البطاقة",
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
                                          primary: globalVars.isEsimSelected ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                          onPrimary: globalVars.isEsimSelected ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                          side: BorderSide(
                                            color: globalVars.isEsimSelected ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                            width: 1, // Border width ekycColors.backgroundBorder
                                          ),
                                          minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                        ),
                                        onPressed:  () {
                                          setState(() {
                                            globalVars.isEsimSelected = true;
                                            globalVars.isPhysicalSimSelected  = false;
                                            simCard.text= "";
                                            globalVars.simCard="";
                                            _dataSimCard="";
                                            showSuffixIconSuccess=false;
                                            showSuffixIconWrong=false;
                                          });
                                          _handleResultEsimShowDialog();
                                        },
                                        child: Text("eSIM"),
                                      ),
                                    ),
                                    SizedBox(width: 10), // Space between buttons
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: globalVars.isPhysicalSimSelected  ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                          onPrimary: globalVars.isPhysicalSimSelected  ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                          side: BorderSide(
                                            color: globalVars.isPhysicalSimSelected  ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                            width: 1, // Border width ekycColors.backgroundBorder
                                          ),
                                          minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                        ),
                                        onPressed:  () {
                                          setState(() {
                                            globalVars.isPhysicalSimSelected  = true;
                                            globalVars.isEsimSelected = false;
                                            simCard.text= "";
                                            globalVars.simCard="";
                                            _dataSimCard="";
                                            showSuffixIconSuccess=false;
                                            showSuffixIconWrong=false;
                                            globalVars.isEsim=false;
                                          });
                                        },
                                        child: Text("Physical SIM"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              //
                              SizedBox(height: 20),
                              globalVars.isEsimSelected && globalVars.enterEmail?buildEmail():Container(),
                              SizedBox(height: 20),
                              globalVars.isPhysicalSimSelected ? Center(
                                child: Text(EasyLocalization.of(context).locale == Locale("en", "US")?
                                  "Please Scan the barcode on Your Esim Package or enter the sim number in the field below"
                                  :
                                  "يرجى مسح الرمز الشريطي الموجود على باقة ESIM الخاصة بك أو إدخال رقم الشريحة في الحقل أدناه",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                                ),
                              ):Container(),
                              SizedBox(height: 20),
                              globalVars.isPhysicalSimSelected ?  SizedBox(
                                width: double.infinity, // Ensures full width
                                child: Row(
                                  children: [
                                    Expanded(
                                      child:  Image(
                                          image: AssetImage(
                                              'lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/sampleBarCode.png'),
                                          width: double.infinity,
                                          height: 80),
                                    ),
                                  ],
                                ),
                              ):Container(),
                              SizedBox(height: 20),
                              globalVars.isPhysicalSimSelected ?
                              SizedBox(
                                width: double.infinity, // Ensures full width
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0, // Remove the shadow
                                          primary: ekycColors.primary, // Change the button color here
                                        ),
                                        onPressed: () {
                                          _ScanSimCard();
                                        },
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text(EasyLocalization.of(context).locale == Locale("en", "US")?'Scan Code':"مسح الشريط", style: TextStyle(color: Colors.white)),
                                            SizedBox(width: 10), // Space between icon and text
                                            Image(
                                                image: AssetImage(
                                                    'lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/barcode_scanner.png'),
                                                width: 20,
                                                height: 20),

                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ):Container(),


                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),

                      SizedBox(height: 5),
                      globalVars.isPhysicalSimSelected ?  Container(
                        height: 50,
                        width: 420,
                        margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                        decoration: BoxDecoration(),
                        child: Row(children: <Widget>[
                          Expanded(
                            child: new Container(
                                margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                          Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")?"OR":"أو",
                          ),
                          Expanded(
                            child: new Container(
                                margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                                child: Divider(
                                  color: Colors.black,
                                  height: 36,
                                )),
                          ),
                        ]),
                      ):Container(),


/*.........................................................Enter Manual Code............................................................*/
                      SizedBox(height: 5),
                      globalVars.isPhysicalSimSelected ? Center(
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
                              Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Enter Simcard number here":"أدخل رقم البطاقة هنا",
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 10),
                              buildManualSimCard(),

                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ):Container(),
                      SizedBox(height: 15),

/*............................................................Next-Back Buttons............................................................*/

                      /* Padding(
                padding: const EdgeInsets.only(left: 16, right: 16, bottom: 30),
                child: Row(
                  children: [
                    // First button (Back)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0, // Remove the shadow
                          primary: ekycColors.buttonPrimary, // Change the button color here
                        ),
                        onPressed: () {
                          setState(() {
                            if ( globalVars.currentStep > 1) {
                              globalVars.currentStep--;
                              widget.onStepChanged(); // Notify the parent widget

                            } else {
                              // If at step 1, go back to the previous screen
                              Navigator.pop(context);
                            }
                            getScreen();
                            print("Back Step: " +  globalVars.currentStep.toString());
                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_back_ios, color: Colors.white,size: 15,), // Icon before text
                            SizedBox(width: 8), // Space between icon and text
                            Text('Back', style: TextStyle(color: Colors.white)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 16), // Space between buttons

                    // Second button (Next)
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0, // Remove the shadow
                          primary: ekycColors.buttonPrimary, // Change the button color here
                        ),
                        onPressed: () {
                          setState(() {
                            if ( globalVars.currentStep < 6) { // Ensure the last step is 6
                              globalVars.currentStep++;
                              widget.onStepChanged(); // Notify the parent widget to update value
                            }
                            print("Next Step: " +  globalVars.currentStep.toString());

                          });
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('Next', style: TextStyle(color: Colors.white)),
                            SizedBox(width: 8), // Space between icon and text
                            Icon(Icons.arrow_forward_ios_rounded, color: Colors.white,size: 15,), // Icon before text
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
              ),*/
                    ],
                  ),


                ],
              ),
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
                        onPressed: ()async{
                          setState(() {
                            if (globalVars.currentStep > 1) {
                              globalVars.currentStep--;
                              widget.onStepChanged();
                              globalVars.sessionUid= "";
                              globalVars.simCard="";
                              globalVars.numberSelected="";
                              globalVars.isEsimSelected = false;
                              globalVars.isPhysicalSimSelected = true;
                              globalVars.enterEmail=false;
                              globalVars.userEmail="";
                              globalVars.sanadValidation=false;
                              // globalVars.currentScreen=0;
                            } else {
                              Navigator.pop(context);
                              //globalVars.currentScreen=0;
                            }
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
                    globalVars.activeSimTypeNextStep && globalVars.isPhysicalSimSelected ?
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
                    ):
                    globalVars.activeESimTypeNextStep && globalVars.isEsimSelected?
                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          primary: ekycColors.buttonPrimary,
                        ),
                        onPressed: () {

                          if (_email.text.isEmpty) {

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Email is required":"الرجاء ادخال بريد"),backgroundColor: Colors.red));

                          } else if (!isValidEmail(_email.text)) {

                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Please enter a valid email address":"الرجاء ادخال بريد صحيح"),backgroundColor: Colors.red));

                          } else {
                            // Email is valid – proceed
                            setState(() {
                              globalVars.userEmail=_email.text;
                              globalVars.sanadValidation=false;
                              globalVars.isEsim=true;
                              if ( globalVars.currentStep < 6) { // Ensure the last step is 5
                                globalVars.currentStep++;
                                widget.onStepChanged(); // Notify the parent widget to update value
                              }
                              getScreen();

                              print("Next Step: ${globalVars.currentStep}");
                            });
                          }

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
                    ):

                    Expanded(child: Text("-",style: TextStyle(color: Colors.white),)),
                  ],
                ),
              ),
            ),
            // ✅ Loading overlay
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
        ), onWillPop: _onWillPop);
  }
}
