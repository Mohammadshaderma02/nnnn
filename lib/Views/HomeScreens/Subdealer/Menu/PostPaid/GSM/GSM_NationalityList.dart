
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math' as math;
import 'package:http/io_client.dart';
import 'package:image/image.dart' as img;
import 'package:path/path.dart' as p;

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/EKYC_Colors/ekyc_colors.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/FourthStep/CheckIdentity.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_JordainianCustomerInformation.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/SearchDropDown.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/PostPaid/GSM_MSISDN_LIST/PostpaidGSMMSISDNList_block.dart';
import 'package:sales_app/blocs/PostPaid/GSM_MSISDN_LIST/PostpaidGSMMSISDNList_events.dart';
import 'package:sales_app/blocs/PostPaid/GSM_MSISDN_LIST/PostpaidGSMMSISDNList_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/FTTHpackage.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_block.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_events.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:textfield_search/textfield_search.dart';
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

import '../../../../../../Shared/BaseUrl.dart';
import 'GSM_NonJordainianCustomerInformation.dart';
import 'package:http/http.dart' as http;
//import '../../CustomBottomNavigationBar.dart';

class NationalityList extends StatefulWidget {
  var isARMY;
  var role;
  var   outDoorUserName;
  String marketType;
  String packageCode;
  final List<dynamic> Permessions;
  NationalityList({this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode,this.isARMY});

  @override
  _NationalityListState createState() =>
      _NationalityListState(this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode,this.isARMY);
}

class _NationalityListState extends State<NationalityList> {
  // ✅ CRITICAL: Static variable to track processed initial URI across all instances
  // This ensures the initial URI is only processed once per app session
  static String _lastProcessedInitialUri = '';
  
  var isARMY;
  final List<dynamic> Permessions;
  String marketType;
  String packageCode;
  var role;
  var   outDoorUserName;
  bool emptyNationalNo = false;
  bool emptyPassportNo = false;
  bool errorNationalNo = false;

  bool errorPassportNo = false;
  bool isJordanian = false;
  bool emptyMSISDN=false;
  bool emptyMSISDNNumber=false;
  bool errorMSISDNNumber=false;
  var price;


  bool sendOTP=true;
  bool showSimCard =true;

  List<String> MSISDN = <String>[];
  String msisdn;
  String userName='';
  String password='';

  bool checkNationalDisabled=false;
  bool checkPassportDisabled=false;

  TextEditingController nationalNo = TextEditingController();
  TextEditingController passportNo = TextEditingController();
  TextEditingController msisdnNumber= TextEditingController();
  TextEditingController msisdnList = TextEditingController();
  _NationalityListState(this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode,this.isARMY);
  PostValidateSubscriberBlock postValidateSubscriberBlock;
  GetPostPaidGSMMSISDNListBloc getPostPaidGSMMSISDNListBloc;


  bool isTextJordianian = false;
  bool isTextNoNJordianian = false;

  String packagesSelect;
  List<Item> _data = generateItems(0);

  /////////////////////////////////////////////////////// New 2 May 2023///////////////////////////////////////////////////////////////
  bool MSISDN_Normal = true;
  bool MSISDN_Level = false;
  APP_URLS urls = new APP_URLS();

  List<String> Pool_Value = <String>[];
  var MSISDN_Pool = [];
  var New_MSISDN_Pool = [];
  var mobile_list = [];

  var selectedPool_key;
  String building;
  var selectedBEHALF_Value=null;
  bool emptyBuilding=false;

  String Level_Select;
  String msisdnNormal;
  String msisdnLevel;
  bool DarakRole=false;
  bool  resetMSISDN=false;
  bool isArmy;
  bool showCommitmentList;
  bool isloading=false;

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////Shaderma EKYC////////////////////////////////////////
  // Add these state variables at the top of _NationalityListState:
  bool _bothSidesCaptured = false;
  bool showScanToggle = false;
  bool _loadImageFrontID = false;
  bool _loadImageBackID = false;
  bool _loadImageJordanianPassport = false;
  bool _LoadImageForeignPassport = false;
  bool _LoadImageTemporaryPassport = false;
  bool sanadVerificationFailed = false;
  Timer _autoCloseTimer;
  String ekycTokenID = '';
  String sessionUid = '';
  String tokenUid = '';
  bool isEkycInitialized = false;
  
  // ✅ New state variables for Next button logic
  String _lastValidatedNationalNo = ''; // Stores the last validated national number
  bool _documentProcessingSuccess = false; // Tracks if document processing completed successfully
  bool _isCallingFromNextButton = false; // Tracks if API call is from Next button (vs Check button)
  final RegExp _mrzFirstLinePattern = RegExp(r'P<[A-Z]{3}[A-Z<]{39}');
  // Second line of MRZ is typically 44 characters with numbers and letters
  final RegExp _mrzSecondLinePattern = RegExp(r'[A-Z0-9<]{44}');
  // Passport number pattern in MRZ (typically 9 characters)
  final RegExp _passportNumberPattern = RegExp(r'[A-Z0-9]{9}');
  // Name pattern in standard format
  final RegExp _namePatternMRZ = RegExp(r'[A-Z]+/[A-Z]+|[A-Z]+, [A-Z]+');
  // Date patterns (various formats)
  final RegExp _datePatternMRZ = RegExp(r'\d{2}[A-Z]{3}\d{4}|\d{2}/\d{2}/\d{4}|\d{2}\.\d{2}\.\d{4}');
  // Headers for extraction
  final RegExp _expiryDatePattern = RegExp(r'Date of expiry|Expiry|Valid until|Date of expiration');
  final RegExp _nationalityPattern = RegExp(r'Nationality|Nation');
  final List<String> _stepsMRZ = [
    "Position passport's MRZ (machine readable zone) in the frame",
    "Hold still while scanning...",
    "Processing passport data..."
  ];

  final List<String> _tipsMRZ = [
    "Ensure the entire passport is visible",
    "Make sure the MRZ (bottom two lines) is clearly visible",
    "Avoid reflections and shadows on the passport",
    "Hold the camera steady for better results"
  ];
  String IDFront='';
  String IDBack='';
  String JordanianPassport='';
  String ForeignPassport='';
  String TemporaryPassport='';
  int _tipIndexMRZ = 0;
  
  // 🎯 Barcode state variables (for foreign passport)
  TextEditingController barcodeController = TextEditingController();
  String barcodeImage = ''; // Base64 image of barcode
  bool showBarcodeField = false; // Show barcode field after foreign passport upload
  bool isBarcodeManual = true; // Toggle between manual entry and image upload
  bool emptyBarcode = false; // Validation flag
  bool errorBarcodeFormat = false; // Validation: must start with 8 or 1, 10 digits
  String barcodeErrorMessage = ''; // Error message for barcode validation
  bool barcodeUploaded = false; // Track if barcode is uploaded/entered
  String submittedBarcodeValue = ''; // Store barcode value to send with Next button
  File capturedBarcodeImage; // Captured barcode image file
  CameraController _controllerBarcode; // Camera controller for barcode scanning
  bool _isCameraInitializedBarcode = false; // Track if barcode camera is initialized
  bool _isProcessingBarcode = false; // Track if barcode is being processed
  Timer _barcodeFrameProcessor; // Timer for processing frames to detect barcode
  String _detectedBarcodeValue = ''; // Store detected barcode value
  int _barcodeDetectionAttempts = 0; // Track detection attempts
// Sanad variables
  String redirectUrl;
  StreamSubscription _sub;
  BuildContext _dialogContext;
  String sanad_code;
  String sanad_state;

// Camera controllers
  CameraController _controller;
  CameraController _controllerMRZ;
  CameraController _controllerTemporary;
  CameraController _controllerForeign;
  final List<String> _tipsForeign = [
    "Ensure the entire passport is visible",
    "Make sure the MRZ (bottom two lines) is clearly visible",
    "Avoid reflections and shadows on the passport",
    "Hold the camera steady for better results"
  ];
  final List<String> _stepsTemporary = [
    "Position passport's MRZ (machine readable zone) in the frame",
    "Hold still while scanning...",
    "Processing passport data..."
  ];
  // Define validation patterns for passport MRZ (Machine Readable Zone)
  // First line of MRZ is typically 44 characters starting with P<
  final RegExp _mrzFirstLinePatternForeign = RegExp(r'P<[A-Z]{3}[A-Z<]{39}');
  // Second line of MRZ is typically 44 characters with numbers and letters
  final RegExp _mrzSecondLinePatternForeign = RegExp(r'[A-Z0-9<]{44}');
  // Passport number pattern in MRZ (typically 9 characters)
  final RegExp _passportNumberPatternForeign = RegExp(r'[A-Z0-9]{9}');
  // Name pattern in standard format
  final RegExp _namePatternForeign = RegExp(r'[A-Z]+/[A-Z]+|[A-Z]+, [A-Z]+');
  // Date patterns (various formats)
  final RegExp _datePatternForeign = RegExp(r'\d{2}[A-Z]{3}\d{4}|\d{2}/\d{2}/\d{4}|\d{2}\.\d{2}\.\d{4}');
  // Headers for extraction
  final RegExp _expiryDatePatternForeign = RegExp(r'Date of expiry|Expiry|Valid until|Date of expiration');
  final RegExp _nationalityPatternForeign = RegExp(r'Nationality|Nation');

  final List<String> _stepsForeign = [
    "Position passport's MRZ (machine readable zone) in the frame",
    "Hold still while scanning...",
    "Processing passport data..."
  ];
  final List<String> _tipsTemporary = [
    "Ensure the entire passport is visible",
    "Make sure the MRZ (bottom two lines) is clearly visible",
    "Avoid reflections and shadows on the passport",
    "Hold the camera steady for better results"
  ];
// Camera states
  bool _isCameraInitialized = false;
  bool _isCameraInitializedMRZ = false;
  bool _isCameraInitializedTemporary = false;
  bool _isCameraInitializedForeign = false;
  final RegExp _mrzFirstLinePatternTemporary = RegExp(r'P<[A-Z]{3}[A-Z<]{39}');
  // Second line of MRZ is typically 44 characters with numbers and letters
  final RegExp _mrzSecondLinePatternTemporary = RegExp(r'[A-Z0-9<]{44}');
  // Passport number pattern in MRZ (typically 9 characters)
  final RegExp _passportNumberPatternTemporary = RegExp(r'[A-Z0-9]{9}');
  // Name pattern in standard format
  final RegExp _namePatternTemporary = RegExp(r'[A-Z]+/[A-Z]+|[A-Z]+, [A-Z]+');
  // Date patterns (various formats)
  final RegExp _datePatternTemporary = RegExp(r'\d{2}[A-Z]{3}\d{4}|\d{2}/\d{2}/\d{4}|\d{2}\.\d{2}\.\d{4}');
  // Headers for extraction
  final RegExp _expiryDatePatternTemporary = RegExp(r'Date of expiry|Expiry|Valid until|Date of expiration');
  final RegExp _nationalityPatternTemporary = RegExp(r'Nationality|Nation');



  int _tipIndexTemporary = 0;
// Processing states
  bool _isProcessing = false;
  bool _isProcessingMRZ = false;
  bool _isProcessingTemporary = false;
  bool _isProcessingForeign = false;

// Text recognizers
  final TextRecognizer _textRecognizer = TextRecognizer();
  final TextRecognizer _textRecognizerMRZ = TextRecognizer();
  final TextRecognizer _textRecognizerTemporary = TextRecognizer();
  final TextRecognizer _textRecognizerForeign = TextRecognizer();

// Image data
  List<String> _capturedPaths = [];
  List<String> _capturedBase64 = [];
  String _capturedImagePath = "";
  String _capturedImagePathTemporary = "";
  String _capturedImagePathForeign = "";
  File frontImage;
  File backImage;
  File passportImage;

// Step tracking
  int _currentStep = 0;
  int _currentStepMRZ = 0;
  int _currentStepTemporary = 0;
  int _currentStepForeign = 0;

// Border colors
  Color _borderColor = Colors.white;
  Color _borderColorMRZ = Colors.white;
  Color _borderColorTemporary = Colors.white;
  Color _borderColorForeign = Colors.white;

// Timers
  Timer _frameProcessor;
  Timer _frameProcessorMRZ;
  Timer _frameProcessorTemporary;
  Timer _frameProcessorForeign;
  Timer _borderColorTimer;
  Timer _borderColorTimerMRZ;
  Timer _borderColorTimerTemporary;
  Timer _borderColorTimerForeign;
  Timer _stepTimeout;
  Timer _countdownTimer;
  Timer _tipRotationTimer;
  Timer _wrongSideWarningTimer;

// Timeout & quality
  int _timeoutDuration = 60;
  int _remainingTime = 60;
  double _lastBlurScore = 0.0;
  String _qualityMessage = "";
  bool _isImageQualityGood = false;

// Validation patterns (copy all RegExp patterns from CheckIdentity)

// Steps & tips
  final List<String> _steps = [
    "Place the FRONT side of the ID in the frame",
    "Hold still...",
    "Now place the BACK side of the ID in the frame",
    "Hold still..."
  ];

  final List<String> _tips = [
    "Use a plain background",
    "Avoid glares and reflections",
    "Keep the ID within the frame",
    "Make sure the photo is clear"
  ];

  int _tipIndex = 0;
  int _tipIndexForeign = 0;

// Side tracking
  bool _frontSideCaptured = false;
  bool _isShowingWrongSideWarning = false;

// Info storage
  Map<String, String> _idInfo = {};
  Map<String, String> _passportInfo = {};
  Map<String, String> _passportInfoTemporary = {};
  Map<String, String> _passportInfoForeign = {};
  void _initDeepLinkListener() async {
    try {
      final initialUri = null;
      final uriString = initialUri?.toString() ?? '';
      
      // ✅ CRITICAL: Only process initial URI if it's different from the last one processed
      // This prevents reprocessing the same deep link when navigating back to screen
      if (initialUri != null && mounted && uriString != _lastProcessedInitialUri) {
        print('📱 Processing initial URI: $initialUri');
        _handleDeepLink(initialUri);
        
        // Store this URI as processed (static variable persists across instances)
        _lastProcessedInitialUri = uriString;
        print('✅ Initial URI processed and stored: $_lastProcessedInitialUri');
      } else if (uriString == _lastProcessedInitialUri && uriString.isNotEmpty) {
        print('⏭️  Skipping initial URI - already processed in previous screen instance');
        print('    Previous: $_lastProcessedInitialUri');
        print('    Current: $uriString');
      } else {
        print('ℹ️  No initial URI to process');
      }
    } on PlatformException {
      print('Failed to receive initial uri.');
    } on FormatException catch (err) {
      print('Malformed initial uri: $err');
    }

    _sub = uriLinkStream.listen((Uri uri) {
      if (uri != null && mounted) {
        print('📱 Processing stream URI: $uri');
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('Deeplink error: $err');
    });
  }
  Widget buildFronID_Image(){
    return SizedBox(
        child: Column(
          children: [
            SizedBox(height: 35,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")?  "Capture your ID front side":"التقط صورة للجهة الأمامية من الهوية",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: ekycColors.textPrimary,
                  letterSpacing: 0,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10,),
            _loadImageFrontID == true?
            Center(
              child: GestureDetector(
                onTap: () async {
                  FocusScope.of(context).unfocus();
                  showDialog(
                      context: context,
                      builder: (_) => Center(
                        // Aligns the container to center
                          child: Container(
                            //color: Colors.deepOrange.withOpacity(0.5),
                            child: PhotoView(
                              enableRotation: true,
                              backgroundDecoration:
                              BoxDecoration(),
                              imageProvider:MemoryImage(base64Decode(IDFront)),
                            ),
                            // A simplified version of dialog.
                            width: 300.0,
                            height: 350.0,
                          )));
                },
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child: Container(
                        width: 342,
                        height: 200,
                        decoration: BoxDecoration(
                            color: Colors.black,
                            image: DecorationImage(
                              colorFilter: new ColorFilter.mode(
                                  Colors.black.withOpacity(0.5),
                                  BlendMode.dstATop),
                              // image: FileImage(imageFrontID),
                              image: MemoryImage(base64Decode(IDFront)),
                              fit: BoxFit.cover,
                            )),
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child: Container(
                        width: 342,
                        height: 200,
                        color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                      ),
                    ),
                    /*Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.remove_red_eye,
                          color: Colors.white,
                          size: 30,

                        ),
                        SizedBox(height: 15,),
                        Text(
                          'Preview Photo',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),

                      ],
                    ),*/
                  ],
                ),
              ),
            )
                :
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle tap event to open camera
                  //   pickImageCameraFrontID();
                  //  getOcrResult();
                },

              child: (_loadImageFrontID == false && globalVars.capturedBase64.isNotEmpty && globalVars.capturedBase64.length > 0) ?
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 342,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.dstATop
                          ),
                          image: MemoryImage(base64Decode(globalVars.capturedBase64[0])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 342,
                      height: 200,
                      color: Color(0xFF505050).withOpacity(0.1),
                    ),
                  ),
                ],
              )
                  :
              Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child: Image(
                        image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/jordanianFrontID.png'),
                        fit: BoxFit.cover,
                        width: 342,
                        height: 200,
                      ),
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child: Container(
                        width: 342,
                        height: 200,
                        // color: Color(0xFF505050).withOpacity(0.6), // Adjust opacity as needed
                      ),
                    ),
                    /*  Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image(
                          image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/camera_video.png'),
                          fit: BoxFit.fill,
                          width: 40,
                          height: 40,
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 40), // Add padding here
                          child: Text(
                            'Click here to capture a photo copy of your ID Front Side',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.0,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                        ),


                      ],
                    ),*/
                  ],
                ),
              ),
            ),


          ],
        )


    );
  }
  Widget buildTemporaryPassport_Image(){
    return SizedBox(
      child:  Column(
        children: [
          SizedBox(height: 25,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")? "Capture your Passport": "التقط صورة لجواز سفرك المؤقت",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ekycColors.textPrimary,
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10,),
          _LoadImageTemporaryPassport == true?
          Center(
            child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                showDialog(
                    context: context,
                    builder: (_) => Center(
                      // Aligns the container to center
                        child: Container(
                          //color: Colors.deepOrange.withOpacity(0.5),
                          child: PhotoView(
                            enableRotation: true,
                            backgroundDecoration:
                            BoxDecoration(),
                            imageProvider:MemoryImage(base64Decode(TemporaryPassport)),
                          ),
                          // A simplified version of dialog.
                          width: 300.0,
                          height: 350.0,
                        )));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.dstATop),
                            //  image: FileImage(imageBackID),
                            image: MemoryImage(base64Decode(TemporaryPassport)),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                    ),
                  ),
                  /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 30,

                      ),
                      SizedBox(height: 15,),
                      Text(
                        'Preview Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                    ],
                  ),*/
                ],
              ),
            ),
          )
              :
          Center(
            child: GestureDetector(
              onTap: () {
                // Handle tap event to open camera
                //  pickImageCameraBackID();

              },
              child: globalVars.capturedBase64Temporary.isNotEmpty?
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child:Image.file(
                        File(globalVars.capturedPathsTemporary),
                        width: 342,
                        height: 200,
                        fit: BoxFit.cover,
                      )
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      // color: Color(0xFF505050).withOpacity(0.6), // Adjust opacity as needed
                    ),
                  ),

                ],
              )
                  :
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Image(
                      image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/temporaryPassport.png'),
                      fit: BoxFit.cover,
                      width: 342,
                      height: 200,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      // color: Color(0xFF505050).withOpacity(0.0), // Adjust opacity as needed
                    ),
                  ),
                  /*  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/camera_video.png'),
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40), // Add padding here
                        child: Text(
                          'Click here to capture a photo copy of your Passport',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),

                    ],
                  ),*/
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget buildBackID_Image(){
    return SizedBox(
      child:  Column(
        children: [
          SizedBox(height: 25,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")? "Capture your ID back side": "التقط صورة خلفية الهوية",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ekycColors.textPrimary,
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10,),
          _loadImageBackID == true?
          Center(
            child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                showDialog(
                    context: context,
                    builder: (_) => Center(
                      // Aligns the container to center
                        child: Container(
                          //color: Colors.deepOrange.withOpacity(0.5),
                          child: PhotoView(
                            enableRotation: true,
                            backgroundDecoration:
                            BoxDecoration(),
                            imageProvider:MemoryImage(base64Decode(IDBack)),
                          ),
                          // A simplified version of dialog.
                          width: 300.0,
                          height: 350.0,
                        )));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.dstATop),
                            //  image: FileImage(imageBackID),
                            image: MemoryImage(base64Decode(IDBack)),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                    ),
                  ),
                  /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 30,

                      ),
                      SizedBox(height: 15,),
                      Text(
                        'Preview Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                    ],
                  ),*/
                ],
              ),
            ),
          )
              :
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle tap event to open camera
                  //  pickImageCameraBackID();

                },

              child: (_loadImageBackID == false && globalVars.capturedBase64.isNotEmpty && globalVars.capturedBase64.length > 1) ?
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 342,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.dstATop
                          ),
                          image: MemoryImage(base64Decode(globalVars.capturedBase64[1])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 342,
                      height: 200,
                      color: Color(0xFF505050).withOpacity(0.1),
                    ),
                  ),
                ],
              )
                  : Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Image(
                      image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/jordanianBackID.png'),
                      fit: BoxFit.cover,
                      width: 342,
                      height: 200,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      // color: Color(0xFF505050).withOpacity(0.0), // Adjust opacity as needed
                    ),
                  ),
                  /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/camera_video.png'),
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40), // Add padding here
                        child: Text(
                          'Click here to capture a photo copy of your ID Back Side',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),

                    ],
                  ),*/
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

    Widget buildJordanianPassport_Image(){
    return SizedBox(
      child:  Column(
        children: [
          SizedBox(height: 25,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")?  "Capture your Passport": "التقط صورة لجواز سفرك",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ekycColors.textPrimary,
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10,),
          _loadImageJordanianPassport == true?
          Center(
            child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                showDialog(
                    context: context,
                    builder: (_) => Center(
                      // Aligns the container to center
                        child: Container(
                          //color: Colors.deepOrange.withOpacity(0.5),
                          child: PhotoView(
                            enableRotation: true,
                            backgroundDecoration:
                            BoxDecoration(),
                            imageProvider:MemoryImage(base64Decode(JordanianPassport)),
                          ),
                          // A simplified version of dialog.
                          width: 300.0,
                          height: 350.0,
                        )));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.dstATop),
                            //  image: FileImage(imageBackID),
                            image: MemoryImage(base64Decode(JordanianPassport)),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                    ),
                  ),
                  /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 30,

                      ),
                      SizedBox(height: 15,),
                     Text(
                        'Preview Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                    ],
                  ),*/
                ],
              ),
            ),
          )
              :
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle tap event to open camera
                  //  pickImageCameraBackID();


                },
              child: (_loadImageJordanianPassport == false && globalVars.capturedBase64MRZ.isNotEmpty)?
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 342,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.dstATop
                          ),
                          image: MemoryImage(base64Decode(globalVars.capturedBase64MRZ)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 342,
                      height: 200,
                      color: Color(0xFF505050).withOpacity(0.1),
                    ),
                  ),
                ],
              )
                  :Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Image(
                      image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/jordanianPassport.png'),
                      fit: BoxFit.cover,
                      width: 342,
                      height: 200,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      // color: Color(0xFF505050).withOpacity(0.0), // Adjust opacity as needed
                    ),
                  ),
                  /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/camera_video.png'),
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40), // Add padding here
                        child: Text(
                          'Click here to capture a photo copy of your Passport',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),

                    ],
                  ),*/
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget buildForeignPassport_Image(){
    return SizedBox(
      child:  Column(
        children: [

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")? "Capture your Passport":"التقط صورة لجواز سفرك",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ekycColors.textPrimary,
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10,),
          _LoadImageForeignPassport == true?
          Center(
            child: GestureDetector(
              onTap: () async {
                FocusScope.of(context).unfocus();
                showDialog(
                    context: context,
                    builder: (_) => Center(
                      // Aligns the container to center
                        child: Container(
                          //color: Colors.deepOrange.withOpacity(0.5),
                          child: PhotoView(
                            enableRotation: true,
                            backgroundDecoration:
                            BoxDecoration(),
                            imageProvider:MemoryImage(base64Decode(ForeignPassport)),
                          ),
                          // A simplified version of dialog.
                          width: 300.0,
                          height: 350.0,
                        )));
              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.black,
                          image: DecorationImage(
                            colorFilter: new ColorFilter.mode(
                                Colors.black.withOpacity(0.5),
                                BlendMode.dstATop),
                            //  image: FileImage(imageBackID),
                            image: MemoryImage(base64Decode(ForeignPassport)),
                            fit: BoxFit.cover,
                          )),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                    ),
                  ),
                  /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.remove_red_eye,
                        color: Colors.white,
                        size: 30,

                      ),
                      SizedBox(height: 15,),
                      Text(
                        'Preview Photo',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.0,
                          fontWeight: FontWeight.normal,
                        ),
                      ),

                    ],
                  ),*/
                ],
              ),
            ),
          )
              :
            Center(
              child: GestureDetector(
                onTap: () {
                  // Handle tap event to open camera
                  //  pickImageCameraBackID();

                },
              child: (_LoadImageForeignPassport == false && globalVars.capturedBase64Foreign.isNotEmpty)?
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 342,
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.black,
                        image: DecorationImage(
                          colorFilter: ColorFilter.mode(
                            Colors.black.withOpacity(0.5),
                            BlendMode.dstATop
                          ),
                          image: MemoryImage(base64Decode(globalVars.capturedBase64Foreign)),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 342,
                      height: 200,
                      color: Color(0xFF505050).withOpacity(0.1),
                    ),
                  ),
                ],
              )
                  :Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Image(
                      image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/jordanianPassport.png'),
                      fit: BoxFit.cover,
                      width: 342,
                      height: 200,
                    ),
                  ),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Container(
                      width: 342,
                      height: 200,
                      // color: Color(0xFF505050).withOpacity(0.0), // Adjust opacity as needed
                    ),
                  ),
                  /* Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/camera_video.png'),
                        fit: BoxFit.fill,
                        width: 40,
                        height: 40,
                      ),
                      SizedBox(height: 10,),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 40), // Add padding here
                        child: Text(
                          'Click here to capture a photo copy of your Passport',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.0,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),

                    ],
                  ),*/
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Future<void> _trySanadVerification() async {
    setState(() {
      isloading = true;
      checkNationalDisabled = true;
      sanadVerificationFailed = false;
    });

    try {
      if (!isEkycInitialized) {
        await generateEkycToken();
      }

      if (!isEkycInitialized) {
        setState(() {
          globalVars.sanadValidation = true; // ✅ Show toggle
          isloading = false;
          checkNationalDisabled = false;
        });
        return;
      }

      final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/digitalId/${nationalNo.text}";
      final client = createHttpClient();

      try {
        final response = await client.get(
          Uri.parse(apiUrl),
          headers: {
            "content-type": "application/json",
            "Authorization": "Bearer ${globalVars.ekycTokenID}",
          },
        );

        if (response.statusCode == 200) {
          final result = json.decode(response.body);

          if (result["data"] != null && result["data"]["verified"] == true) {
            // ✅ Sanad verification successful
            print("✅ Sanad verification successful - calling PostValidateSubscriber API");
            
            redirectUrl = result["data"]["redirectUrl"];
            final Uri sanadUrl = Uri.parse(redirectUrl);

            setState(() {
              isloading = false;
              checkNationalDisabled = false;
            });

            // Launch Sanad URL
            if (await canLaunchUrl(sanadUrl)) {
              await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
              
              // ✅ After Sanad completes, call PostValidateSubscriber API
              // Wait a moment for the external process
              await Future.delayed(Duration(seconds: 2));
              
              // Set loading state
              setState(() {
                isloading = true;
                checkNationalDisabled = true;
              });
              
              // Call PostValidateSubscriber API to get username, password, price

              
              // The dialog will be shown in the BLoC listener when API succeeds
            }
          } else {
            setState(() {
              globalVars.sanadValidation = true; // ✅ Show toggle
              isloading = false;
              checkNationalDisabled = false;
            });
          }
        }
      } finally {
        client.close();
      }
    } catch (e) {
      setState(() {
        globalVars.sanadValidation = true; // ✅ Show toggle on error
        isloading = false;
        checkNationalDisabled = false;
      });
    }
  }
    // Future<void> _trySanadVerification() async {
  //   setState(() {
  //     isloading = true;
  //     checkNationalDisabled = true;
  //   });
  //
  //   try {
  //     // Check if eKYC is initialized
  //     if (!isEkycInitialized) {
  //       await generateEkycToken();
  //     }
  //
  //     if (!isEkycInitialized) {
  //       _showCameraFallback();
  //       return;
  //     }
  //
  //     // Try Sanad API
  //     final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/digitalId/${nationalNo.text}";
  //     final client = createHttpClient();
  //
  //     try {
  //       final response = await client.get(
  //         Uri.parse(apiUrl),
  //         headers: {
  //           "content-type": "application/json",
  //           "Authorization": "Bearer ${globalVars.ekycTokenID}",
  //         },
  //       );
  //
  //       print("Sanad Check Response: ${response.body}");
  //
  //       if (response.statusCode == 200) {
  //         final result = json.decode(response.body);
  //
  //         if (result["data"]["verified"] == true) {
  //           // ✅ Sanad verification successful
  //           redirectUrl = result["data"]["redirectUrl"];
  //           final Uri sanadUrl = Uri.parse(redirectUrl);
  //
  //           setState(() {
  //             isloading = false;
  //             checkNationalDisabled = false;
  //           });
  //
  //           if (await canLaunchUrl(sanadUrl)) {
  //             await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
  //             // Deep link handler will continue the flow
  //           } else {
  //             throw Exception("Could not launch Sanad URL");
  //           }
  //         } else {
  //           // ❌ Sanad not verified
  //           setState(() {
  //             globalVars.sanadValidation = false;
  //           });
  //           _showCameraFallback();
  //         }
  //       } else {
  //         throw Exception("Sanad API failed");
  //       }
  //     } finally {
  //       client.close();
  //     }
  //   } catch (e) {
  //     print("Sanad verification error: $e");
  //     _showCameraFallback();
  //   }
  // }

  void _showCameraFallback() {
    setState(() {
      isloading = false;
      checkNationalDisabled = false;
    });

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Verification Method"
                : "طريقة التحقق",
          ),
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Sanad verification is not available. Would you like to scan your ID instead?"
                : "التحقق عبر سند غير متاح. هل تريد مسح بطاقتك الشخصية بدلاً من ذلك?",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US") ? "Cancel" : "إلغاء",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeCamera(); // Open ID scanner
              },
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US") ? "Scan ID" : "مسح الهوية",
              ),
            ),
          ],
        );
      },
    );
  }


  void _showPassportScanOptions() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Select Passport Type"
                : "اختر نوع جواز السفر",
          ),
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Please select the type of passport you want to scan:"
                : "الرجاء تحديد نوع جواز السفر الذي تريد مسحه:",
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US") ? "Cancel" : "إلغاء",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeCameraMRZ(); // Jordanian Passport
              },
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Jordanian Passport"
                    : "جواز سفر أردني",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _initializeCameraForeign(); // Foreign Passport
              },
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Foreign Passport"
                    : "جواز سفر أجنبي",
              ),
            ),
          ],
        );
      },
    );
  }
  
  // ✅ Barcode scanner for passport number
  Future<void> _scanPassportBarcode() async {
    try {
      final value = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE,
      );

      if (value != "-1" && value.isNotEmpty) {
        setState(() {
          passportNo.text = value;
          emptyPassportNo = false;
        });
        print("✅ Scanned Passport Number: $value");
      } else {
        print("Scan cancelled or invalid value: $value");
      }
    } catch (e) {
      print("Error during passport barcode scanning: $e");
    }
  }
  
  void _handleDeepLink(Uri uri) {
    print("-----------------queryParameters---------------------------");
    print(uri.queryParameters);
    print("--------------------queryParameters------------------------");

    final status = uri.queryParameters['status'];
    final error = uri.queryParameters['error'];
    final errorCode = uri.queryParameters['error_code'];
    final getCode = uri.queryParameters['code'];

    setState(() {
      sanad_code = uri.queryParameters['code'];
      sanad_state = uri.queryParameters['state'];
    });

    if (!mounted) return;

    if (_dialogContext != null) {
      try {
        if (Navigator.of(_dialogContext, rootNavigator: false).canPop()) {
          Navigator.of(_dialogContext).pop();
        }
      } catch (e) {
        print('Error closing dialog: $e');
      } finally {
        _dialogContext = null;
      }
    }

    if (!mounted) return;

    // ✅ Handle Sanad errors - show scan toggle instead of dialog
    if (errorCode == 'incorrect_login_credentials' ||
        errorCode == 'unauthorized_client' ||
        error == 'incorrect_login_credentials' ||
        ['cancelled', 'canceled', 'timeout', 'expired', 'failed', 'failure'].contains(status)) {

      print("Sanad error detected: $errorCode or status: $status");

      setState(() {
        globalVars.sanadValidation = true;
        sanadVerificationFailed = true;
        showScanToggle = true; // ✅ Show the scan toggle
        checkNationalDisabled = false;
        isloading = false;
      });

      // Show a snackbar notification instead of dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Sanad verification failed. Please scan your ID instead."
                : "فشل التحقق عبر سند. يرجى مسح بطاقتك الشخصية بدلاً من ذلك.",
          ),
          backgroundColor: Colors.orange,
          duration: Duration(seconds: 4),
        ),
      );
      return;
    }

    // ✅ Handle successful authorization code
    if (getCode != null && getCode.isNotEmpty) {
      print("Received authorization code: $getCode");
      setState(() {
        sanadVerificationFailed = false;
        showScanToggle = false;
      });
      sanadAuthorization_API();

      return;
    }

    // ✅ Handle success status
    if (status == 'success') {
      print("Sanad process succeeded: $status");
      postValidateSubscriberBlock.add(PostValidateSubscriberPressed(
          marketType: marketType,
          isJordanian: true,
          nationalNo: nationalNo.text,
          passportNo: "",
          packageCode: packageCode,
          msisdn: marketType == "GSM" ? (msisdn ?? msisdnNumber.text) : msisdnNumber.text,
          isRental: false,
          device5GType: "0",
          buildingCode: "null",
          serialNumber: "",
          itemCode: "null"
      ));
      setState(() {
        globalVars.sanadValidation = true;
        sanadVerificationFailed = false;
        showScanToggle = false;
      });
      return;
    }
  }
   // void _handleDeepLink(Uri uri) {
  //   print("-----------------queryParameters---------------------------");
  //   print(uri.queryParameters);
  //   print("--------------------queryParameters------------------------");
  //
  //   final status = uri.queryParameters['status'];
  //   final error = uri.queryParameters['error'];
  //   final errorCode = uri.queryParameters['error_code'];
  //   final getCode = uri.queryParameters['code'];
  //
  //   setState(() {
  //     sanad_code = uri.queryParameters['code'];
  //     sanad_state = uri.queryParameters['state'];
  //   });
  //
  //   if (!mounted) return;
  //
  //   if (_dialogContext != null) {
  //     try {
  //       if (Navigator.of(_dialogContext, rootNavigator: false).canPop()) {
  //         Navigator.of(_dialogContext).pop();
  //       }
  //     } catch (e) {
  //       print('Error closing dialog: $e');
  //     } finally {
  //       _dialogContext = null;
  //     }
  //   }
  //
  //   if (!mounted) return;
  //
  //   // ✅ Handle Sanad errors - show camera scan option
  //   if (errorCode == 'incorrect_login_credentials' ||
  //       errorCode == 'unauthorized_client' ||
  //       error == 'incorrect_login_credentials') {
  //     print("Sanad error detected: $errorCode");
  //     setState(() {
  //       globalVars.sanadValidation = false;
  //     });
  //
  //     // Show camera fallback option
  //     _showSanadErrorDialog(errorCode);
  //     return;
  //   }
  //
  //   // ✅ Handle successful authorization code
  //   if (getCode != null && getCode.isNotEmpty) {
  //     print("Received authorization code: $getCode");
  //     sanadAuthorization_API();
  //     return;
  //   }
  //
  //   // ✅ Handle success status
  //   if (status == 'success') {
  //     print("Sanad process succeeded: $status");
  //     setState(() {
  //       globalVars.sanadValidation = true;
  //     });
  //     Navigator.pushReplacement(
  //       context,
  //       MaterialPageRoute(builder: (_) => checkIdentity()),
  //     );
  //     return;
  //   }
  //
  //   // ✅ Handle common failure statuses
  //   if (['cancelled', 'canceled', 'timeout', 'expired', 'failed', 'failure'].contains(status)) {
  //     print("Sanad process was cancelled or failed: $status");
  //     setState(() {
  //       globalVars.sanadValidation = false;
  //     });
  //
  //     // Show camera fallback option
  //     _showSanadErrorDialog(status);
  //     return;
  //   }
  // }

  void _showSanadErrorDialog(String errorType) {
    String errorMessage;
    String errorTitle;

    if (errorType == 'incorrect_login_credentials') {
      errorTitle = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Incorrect Credentials"
          : "بيانات خاطئة";
      errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "The login credentials provided are incorrect. You can scan your ID instead."
          : "بيانات تسجيل الدخول المقدمة غير صحيحة. يمكنك مسح بطاقتك الشخصية بدلاً من ذلك.";
    } else if (errorType == 'unauthorized_client') {
      errorTitle = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Unauthorized"
          : "غير مصرح";
      errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Unauthorized client. You can scan your ID instead."
          : "عميل غير مصرح له. يمكنك مسح بطاقتك الشخصية بدلاً من ذلك.";
    } else if (['cancelled', 'canceled'].contains(errorType)) {
      errorTitle = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Verification Cancelled"
          : "تم إلغاء التحقق";
      errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Sanad verification was cancelled. You can scan your ID instead."
          : "تم إلغاء التحقق عبر سند. يمكنك مسح بطاقتك الشخصية بدلاً من ذلك.";
    } else if (['timeout', 'expired'].contains(errorType)) {
      errorTitle = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Session Expired"
          : "انتهت الجلسة";
      errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Sanad verification session expired. You can scan your ID instead."
          : "انتهت صلاحية جلسة التحقق عبر سند. يمكنك مسح بطاقتك الشخصية بدلاً من ذلك.";
    } else {
      errorTitle = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Verification Failed"
          : "فشل التحقق";
      errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Sanad verification failed. You can scan your ID instead."
          : "فشل التحقق عبر سند. يمكنك مسح بطاقتك الشخصية بدلاً من ذلك.";
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(errorTitle),
          content: Text(errorMessage),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // User can try entering data again
              },
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Cancel"
                    : "إلغاء",
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                // Open camera for ID scanning
                _initializeCamera();
              },
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Scan ID"
                    : "مسح الهوية",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4f2565),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    // Cancel all timers
    _frameProcessor?.cancel();
    _frameProcessorMRZ?.cancel();
    _frameProcessorTemporary?.cancel();
    _frameProcessorForeign?.cancel();
    _borderColorTimer?.cancel();
    _borderColorTimerMRZ?.cancel();
    _borderColorTimerTemporary?.cancel();
    _borderColorTimerForeign?.cancel();
    _stepTimeout?.cancel();
    _countdownTimer?.cancel();
    _tipRotationTimer?.cancel();
    _wrongSideWarningTimer?.cancel();

    // Dispose controllers
    _controller?.dispose();
    _controllerMRZ?.dispose();
    _controllerTemporary?.dispose();
    _controllerForeign?.dispose();

    // Close recognizers
    _textRecognizer.close();
    _textRecognizerMRZ.close();
    _textRecognizerTemporary.close();
    _textRecognizerForeign.close();

    _sub?.cancel();

    super.dispose();
  }
  Widget _buildOverlayFrameTemporary() {
    return Container(
      color: Colors.black.withOpacity(0.0),
      child: CustomPaint(
        painter: ScannerOverlayPainterTemporary(borderColorTemporary: _borderColorTemporary),
      ),
    );
  }

  Widget _buildStepTextTemporary() {
    return Positioned(
      bottom: 110,
      left: 16,
      right: 16,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _currentStepTemporary < _stepsTemporary.length ? _stepsTemporary[_currentStepTemporary] : "Processing...",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTipTextTemporary() {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Text(
          _tipsTemporary[_tipIndexTemporary],
          key: ValueKey<int>(_tipIndexTemporary),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  Widget _buildOverlayFrameForeign() {
    return Container(
      color: Colors.black.withOpacity(0.0),
      child: CustomPaint(
        painter: ScannerOverlayPainterForeign(borderColorForeign: _borderColorForeign),
      ),
    );
  }

  Widget _buildStepTextForeign() {
    return Positioned(
      bottom: 110,
      left: 16,
      right: 16,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _currentStepForeign < _stepsForeign.length ? _stepsForeign[_currentStepForeign] : "Processing...",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTipTextForeign() {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Text(
          _tipsForeign[_tipIndexForeign],
          key: ValueKey<int>(_tipIndexForeign),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  void sanad_API() async {
    setState(() {
      isloading = true;
    });
    final apiUrl = "https://dsc.jo.zain.com/eKYC/api/lines/sanad/digitalId/${nationalNo}/${globalVars.sessionUid}";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "content-type": "application/json",
        "X-API-KEY": "7c4a509c-a205-4cbc-9061-c95415f3deb8"
      },
    );

    print("API Response: ${response.body}");
    print("API Response: ${nationalNo}");
    if (response.statusCode == 200) {
      setState(() {
        isloading=false;
      });
      final result = json.decode(response.body);
      if(result["status"]==0){
        if (result["data"]["verified"] == true) {
          redirectUrl = result["data"]["redirectUrl"];
          final Uri sanadUrl = Uri.parse(
              redirectUrl
          );
          print(redirectUrl);

          if (await canLaunchUrl(sanadUrl)) {
            await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
          } else {
            print('Could not launch Sanad URL');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Could not launch Sanad URL":"تعذر تشغيل رابط سند"),backgroundColor: Colors.red));

          }
        }
        if (result["data"]["verified"] == false)
        {
          setState(() {
            globalVars.sanadValidation = true;
            // _sanadNationalNumber.text="";
          });

        }
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"]),backgroundColor: Colors.red));

      }

    } else {
      print('API call failed with status: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?response.statusCode.toString():response.statusCode.toString()),backgroundColor: Colors.red));

      setState(() {
        isloading=false;
      });
    }
  }
// Create HTTP client that skips certificate verification (you already have this)
  http.Client createHttpClient() {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      return true;
    };
    return IOClient(httpClient);
  }

// Generate eKYC token
  Future<void> generateEkycToken() async {
    print("Starting eKYC token generation...");

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apiUrl = urls.BASE_URL + '/Services/generate-ekyc-token';
    final client = createHttpClient();

    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken") ?? "",
        },
      );

      print("eKYC Token Response Status: ${response.statusCode}");
      print("eKYC Token Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result["status"] == 0 && result["data"] != null) {
          final tokenID = result["data"]["data"];

          if (tokenID != null && tokenID.isNotEmpty) {
            setState(() {
              ekycTokenID = tokenID;
              globalVars.ekycTokenID = tokenID;
            });

            print("✅ eKYC Token generated: $ekycTokenID");

            // ✅ Now start session
            await startSession();
          } else {
            throw Exception("Token ID is null or empty");
          }
        } else {
          throw Exception("Failed to generate eKYC token: ${result['message']}");
        }
      } else {
        throw Exception("API returned status code: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error generating eKYC token: $e');

      setState(() {
        isEkycInitialized = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Failed to initialize eKYC system: $e"
                    : "فشل في تهيئة نظام التحقق الإلكتروني: $e"
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      client.close();
    }
  }
// Start eKYC session
  Future<void> startSession() async {
    if (ekycTokenID == null || ekycTokenID.isEmpty) {
      print("❌ Cannot start session: eKYC token not available");
      setState(() {
        isEkycInitialized = false;
      });
      return;
    }

    print("Starting eKYC session with token: $ekycTokenID");

    final apiUrl = "https://079.jo/wid-zain/api/v2/session/start";
    final client = createHttpClient();

    final tokenID = Uuid().v4();;

    Map body = {
      "tokenID": tokenID
    };

    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer $ekycTokenID",
        },
        body: json.encode(body),
      );

      print("Session Start Response Status: ${response.statusCode}");
      print("Session Start Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);
        if (result["data"] != null) {
          setState(() {
            sessionUid = result["data"]["sessionUid"];
            tokenUid = result["data"]["tokenUid"];
            isEkycInitialized = true; // ✅ Mark as initialized

            globalVars.sessionUid = sessionUid;
            globalVars.ekycTokenID = ekycTokenID;
          });

          print("✅ Session started successfully!");
          print("Session UID: $sessionUid");
          print("Token UID: $tokenUid");
        } else {
          throw Exception("No data in session start response");
        }
      } else {
        throw Exception("Session start failed with status: ${response.statusCode}");
      }
    } catch (e) {
      print('❌ Error starting session: $e');

      setState(() {
        isEkycInitialized = false;
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Failed to start verification session: $e"
                    : "فشل في بدء جلسة التحقق: $e"
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      client.close();
    }
  }


  void sanadAuthorization_API() async {
    setState(() {
      isloading = true;
    });
    final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/authorize";
    Map body={
      "code": sanad_code,
      "ekycUid": globalVars.sessionUid,
      "state": sanad_state,
      "redirectUrl":redirectUrl,
      "nationalId": nationalNo.text,
      "document": {
        "type" :  "identity_card" ,
        "passportType" :"jordanian"
      }
    };
    print(body);
    // Use the custom HTTP client
    final client = createHttpClient();

    try {
      final response = await client.post(
        Uri.parse(apiUrl),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer ${globalVars.ekycTokenID}",
        },
        body: json.encode(body),
      );

      print(apiUrl);
      print("API Response: ${response.body}");


      if (response.statusCode == 200) {
        setState(() {
          isloading = false;
        });
        //I/flutter (30181): API Response: {data: {fullName: محمد محمود محمد شادرما, nationalNo: 2000264514, birthDate: 2001-03-30T00:00:00, gender: Male, cardNumber: LMG80224, cardDateOfExp: 2032-05-17T00:00:00}, message: {en: The Operation has been Successfully Completed, ar: تمت العملية بنجاح}, success: true, timestamp: 2025-07-02T23:14:15.725Z}
//I/flutter (26370): API Response: {"code":"cdd02bb7-7cb0-4264-8856-6f568f882a25","errorName":"AppException","message":{"ar":"غير مسموح بتغيير حالة الملف","en":"Change status of dossier forbidden"},"method":"POST","path":"/wid-zain/api/v1/session/28327f83-692b-48cf-b5a6-6cce2d28b4a1/sanad/authorize","timestamp":"2025-07-02T23:09:10.244Z","success":false}
        final result = json.decode(response.body);
        print("API Response: ${result}");
        print("API Response: ${result['data']['nationalNo']}");

        if(result["success"] == true && result['message']['en'] == "The Operation has been Successfully Completed"){
          if(result['data']!= null ){
            if(result['data']['nationalNo'] != nationalNo.text){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"The National Number does not match the one in Sanad":"رقم الهوية الوطنية لا يتطابق مع الموجود في سند"),backgroundColor: Colors.red));
            }else{
              globalVars.SanadPassed=true;
              postValidateSubscriberBlock.add(PostValidateSubscriberPressed(
                  marketType: marketType,
                  isJordanian: true,
                  nationalNo: nationalNo.text,
                  passportNo: "",
                  packageCode: packageCode,
                  msisdn: marketType == "GSM" ? (msisdn ?? msisdnNumber.text) : msisdnNumber.text,
                  isRental: false,
                  device5GType: "0",
                  buildingCode: "null",
                  serialNumber: "",
                  itemCode: "null"
              ));
              globalVars.fullNameAr= result['data']['fullName'];
              globalVars.natinalityNumber= result['data']['nationalNo'];
              globalVars.birthdate= result['data']['birthDate'].split("T").first;
              globalVars.expirayDate= result['data']['cardDateOfExp'].split("T").first;

              // creation_API();
            }
          }

        }
        if(result["success"] == false ){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]["en"]: result["message"]["ar"]),backgroundColor: Colors.red));
        }


      } else {
        print('API call failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.statusCode.toString()),
                backgroundColor: Colors.red
            )
        );
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Network error occurred'),
              backgroundColor: Colors.red
          )
      );
    } finally {
      // Don't forget to close the client
      client.close();
    }
  }

  void creation_API() async {

    String fullName = globalVars.fullNameAr ?? '';
    List<String> nameParts = fullName.split(' ');

// Accessing parts
    String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    String middleName = nameParts.length > 1 ? nameParts[1] : '';
    String lastName = nameParts.length > 2 ? nameParts[2] : '';

// Print results
    print("First Name: $firstName");
    print("Middle Name: $middleName");
    print("Last Name: $lastName");
    setState(() {
      isloading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/submit';
    final Uri url = Uri.parse(apiArea);

    var body = {
      "msisdn": globalVars.numberSelected,
      "isJordanian": true,
      "nationalNo": globalVars.natinalityNumber,
      "passportNo": "",
      "packageCode":"",
      "firstName": lastName,
      "secondName": middleName,
      "thirdName": "",
      "lastName":  firstName,
      "birthDate": globalVars.birthdate,
      "eshopOrderId": "",
      "authCode": "",
      "last4Digits": "",
      "email": globalVars.userEmail,
      "isEsim": globalVars.isEsim,
      "simCard": globalVars.simCard,
      "frontIdImageBase64": "",
      "backIdImageBase64": "",
      "passportImageBase64": "",
      "backPassportImageBase64": "",
      "signatureImageBase64": "",
      "receiptImageBase64": "",
      "documentExpiryDate": "",
      "operationReference": "",
      "otp": "",
      "referenceNumber":globalVars.referanceNumberPredefined,
      "ekycUID":globalVars.sessionUid
    };
    print(body);



    try {
      final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body),
      );


      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        setState(() {
          isloading = false;
        });
        var result = json.decode(response.body);
        print(result["data"]);
        if (result["status"] == 0 && result['message'] == "The Operation has been Successfully Completed") {
          setState(() {


            globalVars.currentStep += 2;
            print(globalVars.currentStep);
       ;

            print("Next Step: ${globalVars.currentStep}");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"],),backgroundColor: Colors.red));


        }

      } else {

        setState(() {
          isloading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?response.statusCode.toString(): response.statusCode.toString(),),backgroundColor: Colors.red));

      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print("Error during API call: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.",),backgroundColor: Colors.red));



    }

  }


  void sanadCheck_API() async {
    setState(() {
      isloading = true;
    });

    final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/digitalId/${nationalNo}";

    // Use the custom HTTP client
    final client = createHttpClient();

    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer ${globalVars.ekycTokenID}",
        },
      );

      print(apiUrl);
      print("API Response: ${response.body}");
      print("API Response: ${nationalNo.text}");

      if (response.statusCode == 200) {
        setState(() {
          isloading = false;
        });

        final result = json.decode(response.body);
        if (result["data"]["verified"] == true) {
          redirectUrl = result["data"]["redirectUrl"];
          final Uri sanadUrl = Uri.parse(redirectUrl);
          print(redirectUrl);

          if (await canLaunchUrl(sanadUrl)) {
            await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
          } else {
            print('Could not launch Sanad URL');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(EasyLocalization.of(context).locale == Locale("en", "US")
                        ? "Could not launch Sanad URL"
                        : "تعذر تشغيل رابط سند"),
                    backgroundColor: Colors.red
                )
            );
          }
        }

        if (result["data"]["verified"] == false) {
          setState(() {
            globalVars.sanadValidation = true;
            // _sanadNationalNumber.text = "";
          });
        }
      } else {
        print('API call failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.statusCode.toString()),
                backgroundColor: Colors.red
            )
        );
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Network error occurred'),
              backgroundColor: Colors.red
          )
      );
    } finally {
      // Don't forget to close the client
      client.close();
    }
  }

  void sanadPersonalNumberCheck_API() async {
    setState(() {
      isloading = true;
    });

    final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/digitalId/${nationalNo}";

    // Use the custom HTTP client
    final client = createHttpClient();

    try {
      final response = await client.get(
        Uri.parse(apiUrl),
        headers: {
          "content-type": "application/json",
          "Authorization": "Bearer ${globalVars.ekycTokenID}",
        },
      );

      print(apiUrl);
      print("API Response: ${response.body}");
      print("API Response: ${nationalNo}");

      if (response.statusCode == 200) {
        setState(() {
          isloading = false;
        });

        final result = json.decode(response.body);
        if (result["data"]["verified"] == true) {
          redirectUrl = result["data"]["redirectUrl"];
          final Uri sanadUrl = Uri.parse(redirectUrl);
          print(redirectUrl);

          if (await canLaunchUrl(sanadUrl)) {
            await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
          } else {
            print('Could not launch Sanad URL');
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(EasyLocalization.of(context).locale == Locale("en", "US")
                        ? "Could not launch Sanad URL"
                        : "تعذر تشغيل رابط سند"),
                    backgroundColor: Colors.red
                )
            );
          }
        }

        if (result["data"]["verified"] == false) {
          SnackBar(
              content: Text(EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "You do not have a valid personal number in the system. Please contact customer service."
                  : "لا يوجد لديك رقم شخصي صالح في النظام. يرجى الاتصال بخدمة العملاء."),
              backgroundColor: Colors.red
          );

        }
        globalVars.isValidForeignIdentification = true; // Set this to true if the check is successful
      } else {
        print('API call failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(response.statusCode.toString()),
                backgroundColor: Colors.red
            )
        );
        setState(() {
          isloading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isloading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('Network error occurred'),
              backgroundColor: Colors.red
          )
      );
    } finally {
      // Don't forget to close the client
      client.close();
    }
  }
  void _resetScannerState() {
    _bothSidesCaptured = false;
    _currentStep = 0;
    _frontSideCaptured = false;
    _isShowingWrongSideWarning = false;
    _isProcessing = false;
    _borderColor = Colors.white;
    _lastBlurScore = 0.0;
    _qualityMessage = "";
    _isImageQualityGood = false;
    _remainingTime = _timeoutDuration;
    _tipIndex = 0;

    // Clear captured data
    _capturedPaths.clear();
    _capturedBase64.clear();

    globalVars.capturedPaths.clear();
    globalVars.capturedBase64.clear();

    _idInfo.clear();

    // Cancel any active timers
    _frameProcessor?.cancel();
    _borderColorTimer?.cancel();
    _stepTimeout?.cancel();
    _countdownTimer?.cancel();
    _wrongSideWarningTimer?.cancel();

    print("Scanner state reset successfully");
  }

  // NEW: Method to restart scanning process
  void _restartScanning() {
    _resetScannerState();
    _startFrameProcessing();
    _startStepTimeout();
    setState(() {}); // Trigger UI update
  }

  Future<void> _initializeCamera() async {
    print("Attempting to initialize ID camera...");

    // ✅ CRITICAL: Ensure eKYC is initialized first
    if (!isEkycInitialized) {
      print("eKYC not initialized, attempting to initialize...");
      setState(() {
        isloading = true;
      });

      await generateEkycToken();

      setState(() {
        isloading = false;
      });
    }

    // ✅ Check if initialization was successful
    if (!isEkycInitialized) {
      print("ERROR: eKYC initialization failed!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "eKYC system not ready. Please try again."
                : "نظام التحقق الإلكتروني غير جاهز. يرجى المحاولة مرة أخرى.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return; // ✅ Exit if not initialized
    }

    print("eKYC initialized successfully, starting camera...");

    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controller = CameraController(backCamera, ResolutionPreset.high);
      await _controller.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitialized = true;
      });

      print("Camera initialized successfully!");

      // ✅ Start processing and timers
      _startFrameProcessing();
      _startTipRotation();
      _startStepTimeout();

    } catch (e) {
      print("ERROR initializing camera: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Failed to access camera. Please check permissions."
                : "فشل في الوصول إلى الكاميرا. يرجى التحقق من الأذونات.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Update the _startTipRotation method to store the timer reference
  void _startTipRotation() {
    _tipRotationTimer = Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
    });
  }

  // Add this method to stop camera and cleanup
  Future<void> _stopCameraAndCleanup() async {
    print("Stopping camera and cleaning up resources...");

    // Cancel all timers
    _frameProcessor?.cancel();
    _borderColorTimer?.cancel();
    _stepTimeout?.cancel();
    _countdownTimer?.cancel();
    _tipRotationTimer?.cancel();

    // Stop camera controller
    if (_controller != null && _controller.value.isInitialized) {
      await _controller.dispose();
      _controller = null;

    }

    // Close text recognizer
    //19 jun  await _textRecognizer.close();

    // Update UI state
    if (mounted) {
      setState(() {
        _isCameraInitialized = false;
      });


    }

    print("Camera and resources cleaned up successfully");
  }


  // Add method to restart camera and timers
  Future<void> _restartCameraAndTimers() async {
    print("Restarting camera and timers...");

    // Reset state variables
    _currentStep = 0;
    _isProcessing = false;
    _capturedPaths.clear();
    _capturedBase64.clear();
    globalVars.capturedPaths.clear();
    globalVars.capturedBase64.clear();
    _idInfo.clear();
    _borderColor = Colors.white;
    _remainingTime = _timeoutDuration;
    _tipIndex = 0;


    print("Restarting camera ...");

    // Reset state variables

    _currentStepMRZ = 0;
    _currentStepTemporary = 0;
    _currentStepForeign=0;


    _isProcessingMRZ = false;
    _isProcessingTemporary = false;
    _isProcessingForeign=false;


    globalVars.capturedPathsMRZ="";
    globalVars.capturedBase64MRZ="";
    globalVars.capturedPathsTemporary="";
    globalVars.capturedBase64Temporary="";
    globalVars.capturedPathsForeign="";
    globalVars.capturedBase64Foreign="";

    _capturedImagePath="";
    _capturedImagePathTemporary="";
    _capturedImagePathForeign="";


    _borderColorMRZ = Colors.white;
    _borderColorTemporary = Colors.white;
    _borderColorForeign = Colors.white;



    _tipIndexMRZ = 0;
    _tipIndexTemporary = 0;
    _tipIndexForeign = 0;


    _passportInfo.clear();
    _passportInfoTemporary.clear();
    _passportInfoForeign.clear();

    // Reinitialize camera
    await _initializeCamera();

    // Restart timers
    _startTipRotation();
    _startStepTimeout();

    print("Camera and timers restarted successfully");
  }

  // Timeout Feature Implementation
  void _startStepTimeout() {
    _remainingTime = _timeoutDuration;
    _stepTimeout?.cancel();
    _countdownTimer?.cancel();

    // Start countdown timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _remainingTime--;
      });

      if (_remainingTime <= 0) {
        _handleStepTimeout();
      }
    });
  }

  void _handleStepTimeout() {
    _countdownTimer?.cancel();
    _stepTimeout?.cancel();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Timeout"),
          content: Text(
              "We couldn't detect the ID after ${_timeoutDuration} seconds. "
                  "Would you like to try again or skip this step?"
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _retryCurrentStep();
              },
              child: Text("Try Again"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _skipCurrentStep();
              },
              child: Text("Skip Step"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.of(context).pop(); // Exit scanner
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartScanning(); // NEW: Option to restart completely
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }

  void _retryCurrentStep() {
    // Reset some state but keep the current step
    _isProcessing = false;
    _isShowingWrongSideWarning = false;
    _borderColor = Colors.white;

    // Cancel existing timers
    _borderColorTimer?.cancel();
    _wrongSideWarningTimer?.cancel();

    // Restart timeout
    _startStepTimeout();

    // Ensure frame processing is running
    if (_frameProcessor?.isActive != true) {
      _startFrameProcessing();
    }
  }

  void _skipCurrentStep() {
    // Skip to next step (you might want to handle this differently)
    setState(() {
      _currentStep += 2; // Skip current and "hold still" step
    });

    if (_currentStep >= _steps.length) {
      _frameProcessor?.cancel();
      _navigateToResultScreen();

    } else {
      _startStepTimeout();
    }
  }

  void _startFrameProcessing() {
    _frameProcessor = Timer.periodic(Duration(milliseconds: 2500), (_) {
      _processFrame();
    });
  }

  // Image Quality Check (Blur Detection)
  Future<double> _calculateBlurScore(String imagePath) async {
    try {
      final File imageFile = File(imagePath);
      final Uint8List imageBytes = await imageFile.readAsBytes();
      final img.Image image = img.decodeImage(imageBytes);

      if (image == null) return 0.0;

      // Convert to grayscale for better blur detection
      final img.Image grayscale = img.grayscale(image);

      // Calculate Laplacian variance for blur detection
      double variance = _calculateLaplacianVariance(grayscale);

      return variance;
    } catch (e) {
      print("Error calculating blur score: $e");
      return 0.0;
    }
  }

  double _calculateLaplacianVariance(img.Image image) {
    // Laplacian kernel for edge detection
    final List<List<int>> kernel = [
      [0, -1, 0],
      [-1, 4, -1],
      [0, -1, 0]
    ];

    List<double> laplacianValues = [];

    // Apply Laplacian filter
    for (int y = 1; y < image.height - 1; y++) {
      for (int x = 1; x < image.width - 1; x++) {
        double sum = 0.0;

        for (int ky = 0; ky < 3; ky++) {
          for (int kx = 0; kx < 3; kx++) {
            final pixel = image.getPixel(x + kx - 1, y + ky - 1);
            final intensity = img.getLuminance(pixel);
            sum += intensity * kernel[ky][kx];
          }
        }

        laplacianValues.add(sum);
      }
    }

    // Calculate variance
    if (laplacianValues.isEmpty) return 0.0;

    double mean = laplacianValues.reduce((a, b) => a + b) / laplacianValues.length;
    double variance = laplacianValues
        .map((value) => math.pow(value - mean, 2))
        .reduce((a, b) => a + b) / laplacianValues.length;

    return variance;
  }

  bool _isImageQualityAcceptable(double blurScore) {
    // Threshold for acceptable image quality
    // Higher values indicate sharper images
    const double blurThreshold = 100.0; // Adjust based on testing
    return blurScore > blurThreshold;
  }

  String _getQualityMessage(double blurScore) {
    if (blurScore > 200) {
      return "Excellent quality";
    } else if (blurScore > 100) {
      return "Good quality";
    } else if (blurScore > 50) {
      return "Fair quality - try to reduce blur";
    } else {
      return "Poor quality - image too blurry";
    }
  }

  void _showSuccessfulValidation() {
    _borderColorTimer?.cancel();
    setState(() {
      _borderColor = Colors.green;
    });

    _borderColorTimer = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColor = Colors.white;
        });
      }
    });
  }

  void _showQualityWarning() {
    _borderColorTimer?.cancel();
    setState(() {
      _borderColor = Colors.orange;
    });

    _borderColorTimer = Timer(Duration(milliseconds: 1000), () {
      if (mounted) {
        setState(() {
          _borderColor = Colors.white;
        });
      }
    });
  }

  Future<void> _processFrame() async {
    if (_controller == null ||
        !_controller.value.isInitialized ||
        _controller.value.isTakingPicture ||
        _isProcessing) {
      return;
    }

    _isProcessing = true;
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = p.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await _controller.takePicture(filePath);
      final File imageFile = File(filePath);

      if (!imageFile.existsSync()) {
        print("Image file doesn't exist at: $filePath");
        return;
      }

      // Check image quality first
      final double blurScore = await _calculateBlurScore(filePath);
      final bool isQualityGood = _isImageQualityAcceptable(blurScore);

      setState(() {
        _lastBlurScore = blurScore;
        _qualityMessage = _getQualityMessage(blurScore);
        _isImageQualityGood = isQualityGood;
      });

      if (!isQualityGood) {
        _showQualityWarning();
        print("Image quality too poor: $blurScore");
        setState(() {
          _isProcessing = false;
        });
        return;
      }
      // Convert image file to Base64
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final inputImage = InputImage.fromFilePath(filePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      bool isValidId = false;
      bool isCorrectSide = false;

      // MAIN LOGIC: Check if we're on the correct step and side
      if (_currentStep == 0) {
        // We're expecting FRONT side
        bool isFrontSide = _validateFrontSide(recognizedText.text);
        bool isBackSide = _validateBackSide(recognizedText.text);

        if (isFrontSide && !isBackSide) {
          // Correct: This is the front side
          isValidId = true;
          isCorrectSide = true;
          _frontSideCaptured = true;
        } else if (isBackSide) {
          // Wrong: User is showing back side when we need front
          _showWrongSideWarning("Please show the FRONT side of your ID first");
          isCorrectSide = false;
        }

      } else if (_currentStep == 2) {
        // We're expecting BACK side
        if (!_frontSideCaptured) {
          // Safety check: shouldn't reach here without front side
          _showWrongSideWarning("Front side must be captured first");
          isCorrectSide = false;
        } else {
          bool isBackSide = _validateBackSide(recognizedText.text);
          bool isFrontSide = _validateFrontSide(recognizedText.text);

          if (isBackSide && !isFrontSide) {
            // Correct: This is the back side
            isValidId = true;
            isCorrectSide = true;
          } else if (isFrontSide) {
            // Wrong: User is showing front side again when we need back
            _showWrongSideWarning("Please show the BACK side of your ID now");
            isCorrectSide = false;
          }
        }
      }

      // Only proceed if we have the correct side
      if (isValidId && isCorrectSide) {
        _capturedPaths.add(filePath);
        _capturedBase64.add(base64String);
        frontImage = File(_capturedPaths.first);
        backImage = File(_capturedPaths.last);

        globalVars.capturedPaths.add(filePath);
        globalVars.capturedBase64.add(base64String);

        globalVars.isValidIdentification=true;

        _showSuccessfulValidation();

        // Cancel timeout since we successfully captured
        _countdownTimer?.cancel();
        _stepTimeout?.cancel();

        if (mounted) {
          setState(() {
            _currentStep += 2; // skip "hold still" steps
            _isProcessing = false;
          });
        }
// Check if we've completed both sides
        if (_currentStep >= _steps.length) {
          /* _frameProcessor?.cancel();
          _navigateToResultScreen();
           _bothSidesCaptured = true;
          setState(() => _isCameraInitialized = false);*/
          
          // Ensure UI updates to show captured images
          if (mounted) {
            setState(() {
              print("✅ ID Capture complete - UI refreshed with captured data");
            });
          }
          
          await _stopCameraAndCleanup();


          uploadFrontID_API(frontImage);



        } else {
          _startStepTimeout();
        }
      }
    } catch (e) {
      print("Processing error: $e");
    } finally {
      _isProcessing = false;
    }
  }



  bool _validateFrontSide(String text) {
    print("Validating front side text: $text");

    // Convert text to lowercase for case-insensitive matching
    String lowerText = text.toLowerCase();

    // STRICT front side indicators - must have multiple clear indicators
    bool hasArabicText = RegExp(r'(الهوية|الاردنية|jordan|المملكة|الهاشمية)', caseSensitive: false).hasMatch(text);

    // More strict name detection - look for actual name patterns
    bool hasName = _extractAndStore(text, RegExp(r'[\u0600-\u06FF]{2,}\s+[\u0600-\u06FF]{2,}'), 'nameArabic') ||
        _extractAndStore(text, RegExp(r'[A-Z][a-z]{2,}\s+[A-Z][a-z]{2,}'), 'nameEnglish');

    // Date of birth should be in specific format
    bool hasDateOfBirth = _extractAndStore(text, RegExp(r'\d{2}/\d{2}/\d{4}'), 'dateOfBirth') ||
        _extractAndStore(text, RegExp(r'\d{4}/\d{2}/\d{2}'), 'dateOfBirth');

    // Gender indicators
    bool hasGender = lowerText.contains('male') || lowerText.contains('female') ||
        RegExp(r'\b[MF]\b').hasMatch(text) ||
        text.contains('ذكر') || text.contains('انثى');

    // Place of birth or nationality
    bool hasPlaceOrNationality = lowerText.contains('jordan') || lowerText.contains('amman') ||
        text.contains('الاردن') || text.contains('عمان');

    // STRICT negative indicators - these should NOT be present on front side
    bool hasNoMRZ = !text.contains('<<<') && !RegExp(r'[A-Z]{3}\d{9}[A-Z]\d{7}[MF]\d{6}').hasMatch(text);
    bool hasNoLongNumbers = !RegExp(r'\d{10,}').hasMatch(text); // No long ID numbers on front
    bool hasNoExpiryText = !lowerText.contains('expiry') && !text.contains('انتهاء');
    bool hasNoJORCode = !text.contains('JOR') || !RegExp(r'JOR\d{9}').hasMatch(text);

    // Count positive indicators
    List<bool> positiveIndicators = [
      hasArabicText,
      hasName,
      hasDateOfBirth,
      hasGender,
      hasPlaceOrNationality
    ];

    // Count negative indicators (things that should NOT be on front)
    List<bool> negativeIndicators = [
      hasNoMRZ,
      hasNoLongNumbers,
      hasNoExpiryText,
      hasNoJORCode
    ];

    int positiveMatches = positiveIndicators.where((match) => match).length;
    int negativeMatches = negativeIndicators.where((match) => match).length;

    print("Front side validation:");
    print("- Has Arabic text: $hasArabicText");
    print("- Has name: $hasName");
    print("- Has date of birth: $hasDateOfBirth");
    print("- Has gender: $hasGender");
    print("- Has place/nationality: $hasPlaceOrNationality");
    print("- No MRZ: $hasNoMRZ");
    print("- No long numbers: $hasNoLongNumbers");
    print("- No expiry text: $hasNoExpiryText");
    print("- No JOR code: $hasNoJORCode");
    print("- Positive matches: $positiveMatches/5");
    print("- Negative matches: $negativeMatches/4");

    // STRICT VALIDATION: Need at least 3 positive indicators AND all 4 negative indicators
    bool isValidFront = positiveMatches >= 3 && negativeMatches >= 3;

    print("Is valid front side: $isValidFront");
    return isValidFront;
  }


  bool _validateBackSide(String text) {
    print("Validating back side text: $text");

    String lowerText = text.toLowerCase();

    // Back side specific indicators
    bool hasNationalId = _extractAndStore(text, RegExp(r'\d{10}'), 'nationalId');
    bool hasMrzCode = text.contains('JOR') && text.contains('<<<');
    bool hasExpiryDate = _extractAndStore(text, RegExp(r'(expiry|انتهاء).{0,20}\d{2}/\d{2}/\d{4}', caseSensitive: false), 'expiry');
    bool hasIdNumber = (lowerText.contains('id') && lowerText.contains('no')) ||
        (text.contains('رقم') && text.contains('الهوية'));

    // Machine readable zone pattern
    bool hasMRZPattern = RegExp(r'[A-Z]{3}\d{9}[A-Z]\d{7}[MF]\d{6}').hasMatch(text.replaceAll(' ', ''));

    // Strong indicators this is NOT the front side
    bool hasNoPersonalDetails = !RegExp(r'[\u0600-\u06FF]{3,}\s+[\u0600-\u06FF]{3,}').hasMatch(text) &&
        !RegExp(r'[A-Z][a-z]{3,}\s+[A-Z][a-z]{3,}').hasMatch(text);

    List<bool> backIndicators = [
      hasNationalId,
      hasMrzCode,
      hasExpiryDate,
      hasIdNumber,
      hasMRZPattern
    ];

    int positiveMatches = backIndicators.where((match) => match).length;

    print("Back side validation:");
    print("- Has national ID: $hasNationalId");
    print("- Has MRZ code: $hasMrzCode");
    print("- Has expiry date: $hasExpiryDate");
    print("- Has ID number text: $hasIdNumber");
    print("- Has MRZ pattern: $hasMRZPattern");
    print("- No personal details: $hasNoPersonalDetails");
    print("- Positive matches: $positiveMatches/5");

    // Need at least 3 positive indicators for back side
    bool isValidBack = positiveMatches >= 3;

    print("Is valid back side: $isValidBack");
    return isValidBack;
  }

// NEW: Show completion message and close camera
  void _showCompletionAndClose() {
    // Stop all processing immediately
    _frameProcessor?.cancel();
    _countdownTimer?.cancel();
    _stepTimeout?.cancel();
    _borderColorTimer?.cancel();
    _wrongSideWarningTimer?.cancel();



    // Auto-close after 2 seconds
    _autoCloseTimer = Timer(Duration(seconds: 2), () {
      if (mounted) {
        _closeCameraAndExit();
      }
    });
  }
  // NEW: Close camera and exit scanner
  void _closeCameraAndExit() {
    // Dispose camera resources
    _frameProcessor?.cancel();
    _countdownTimer?.cancel();
    _stepTimeout?.cancel();
    _borderColorTimer?.cancel();
    _wrongSideWarningTimer?.cancel();
    _autoCloseTimer?.cancel();


  }
// New method to show wrong side warning
  void _showWrongSideWarning(String message) {
    _wrongSideWarningTimer?.cancel();

    setState(() {
      _isShowingWrongSideWarning = true;
    });

    // Show red border
    _borderColorTimer?.cancel();
    setState(() {
      _borderColor = Colors.red;
    });

    // Show snackbar with message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );

    // Reset warning state after 3 seconds
    _wrongSideWarningTimer = Timer(Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _isShowingWrongSideWarning = false;
          _borderColor = Colors.white;
        });
      }
    });
  }

  // Add a widget to show current side requirement
  Widget _buildSideIndicator() {
    String currentSide = "";
    Color indicatorColor = Colors.blue;

    if (_currentStep == 0) {
      currentSide = "FRONT SIDE";
      indicatorColor = _frontSideCaptured ? Colors.green : Colors.blue;
    } else if (_currentStep == 2) {
      currentSide = "BACK SIDE";
      indicatorColor = Colors.orange;
    }

    if (currentSide.isEmpty) return SizedBox.shrink();

    return Positioned(
      top: 120,
      left: 16,
      right: 16,
      child: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: indicatorColor.withOpacity(0.9),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "Scan $currentSide",
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  bool _extractAndStore(String text, RegExp pattern, String key) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      String extractedValue = match.group(0) ?? '';
      _idInfo[key] = extractedValue.trim();
      print("Extracted $key: $extractedValue");
      return true;
    }
    return false;
  }
  // Additional helper method to improve text cleaning
  String _cleanExtractedText(String text) {
    return text
        .replaceAll(RegExp(r'[^\w\s\u0600-\u06FF/:]'), '') // Keep Arabic, Latin, numbers, spaces, slashes, colons
        .replaceAll(RegExp(r'\s+'), ' ') // Multiple spaces to single space
        .trim();
  }


  // Update your navigation method
  void _navigateToResultScreen() {
    // Stop all processing
    _frameProcessor?.cancel();
    _countdownTimer?.cancel();
    _stepTimeout?.cancel();

  }

  // Add a manual restart button to your UI
  Widget _buildRestartButton() {
    return Positioned(
      top: 40,
      right: 16,
      child: GestureDetector(  // ✅ Use GestureDetector instead
        onTap: () {
          _showRestartConfirmation();
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(12),  // Add padding for touch target
          child: Icon(
            Icons.refresh,
            color: Colors.white,
            size: 24,
          ),
        ),
      ),
    );
  }
  void _showRestartConfirmation() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Restart Scanning"),
          content: Text("Are you sure you want to restart the ID scanning process?"),
          actions: [
            TextButton(
              onPressed: () async{
                await  _stopCameraAndCleanup();

                // Navigator.of(context).pop();
              },
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                _restartScanning();
              },
              child: Text("Restart"),
            ),
          ],
        );
      },
    );
  }
  Widget _buildOverlayFrame() {
    return Container(
      color: Colors.black.withOpacity(0.0),
      child: CustomPaint(
        painter: ScannerOverlayPainter(borderColor: _borderColor),
      ),
    );
  }

  Widget _buildStepText() {
    return Positioned(
      bottom: 110,
      left: 16,
      right: 16,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.0),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _steps[_currentStep % _steps.length],
            style: TextStyle(color: Colors.white, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTipText() {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Text(
          _tips[_tipIndex],
          key: ValueKey<int>(_tipIndex),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  // New widget to show timeout countdown
  Widget _buildTimeoutCounter() {
    return Positioned(
      top: 80,
      right: 16,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _remainingTime <= 10 ? Colors.red.withOpacity(0.8) : Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          "${_remainingTime}s",
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  // New widget to show image quality status
  Widget _buildQualityIndicator() {
    return Positioned(
      top: 80,
      left: 16,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: _isImageQualityGood
              ? Colors.green.withOpacity(0.8)
              : Colors.orange.withOpacity(0.8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              _isImageQualityGood ? Icons.check_circle : Icons.warning,
              color: Colors.white,
              size: 16,
            ),
            SizedBox(width: 4),
            Text(
              _qualityMessage,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<void> _restartCameraPassport() async {
    print("Restarting camera ...");

    // Reset state variables
    _currentStep = 0;
    _currentStepMRZ = 0;
    _currentStepTemporary = 0;
    _currentStepForeign=0;
    _isProcessing = false;
    _isProcessingMRZ = false;
    _isProcessingTemporary = false;
    _capturedPaths.clear();
    _capturedBase64.clear();
    globalVars.capturedPaths.clear();
    globalVars.capturedBase64.clear();
    globalVars.capturedPathsMRZ="";
    globalVars.capturedBase64MRZ="";

    globalVars.capturedPathsTemporary="";
    globalVars.capturedBase64Temporary="";

    globalVars.capturedPathsForeign="";
    globalVars.capturedBase64Foreign="";

    _capturedImagePath="";
    _capturedImagePathTemporary="";
    _capturedImagePathForeign="";

    _idInfo.clear();
    _passportInfoTemporary.clear();
    _passportInfo.clear();
    _passportInfoForeign.clear();

    _borderColor = Colors.white;
    _borderColorMRZ = Colors.white;
    _borderColorTemporary = Colors.white;
    _borderColorForeign = Colors.white;

    _remainingTime = _timeoutDuration;

    _tipIndex = 0;
    _tipIndexMRZ = 0;
    _tipIndexTemporary = 0;
    _tipIndexForeign = 0;
    // Reinitialize camera
    await _initializeCameraMRZ();

    // Restart timers
    _startTipRotationMRZ();


    print("Camera  restarted successfully");
  }

  Future<void> _initializeCameraMRZ() async {
    print("Attempting to initialize Passport MRZ camera...");

    // ✅ Ensure eKYC is initialized
    if (!isEkycInitialized) {
      print("eKYC not initialized, attempting to initialize...");
      setState(() {
        isloading = true;
      });

      await generateEkycToken();

      setState(() {
        isloading = false;
      });
    }

    if (!isEkycInitialized) {
      print("ERROR: eKYC initialization failed!");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "eKYC system not ready. Please try again."
                : "نظام التحقق الإلكتروني غير جاهز. يرجى المحاولة مرة أخرى.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controllerMRZ = CameraController(backCamera, ResolutionPreset.high);
      await _controllerMRZ.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitializedMRZ = true;
      });

      print("MRZ Passport camera initialized successfully!");

      _startFrameProcessingMRZ();
      _startTipRotationMRZ();

    } catch (e) {
      print("ERROR initializing MRZ camera: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Failed to access camera. Please check permissions."
                : "فشل في الوصول إلى الكاميرا. يرجى التحقق من الأذونات.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _startTipRotationMRZ() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _tipIndexMRZ = (_tipIndexMRZ + 1) % _tipsMRZ.length);
    });
  }

  void _startFrameProcessingMRZ() {
    _frameProcessorMRZ = Timer.periodic(Duration(milliseconds: 1500), (_) {
      _processFrameMRZ();
    });
  }

  // Method to show successful validation with green border
  void _showSuccessfulValidationMRZ() {
    // Cancel any existing timer
    _borderColorTimerMRZ?.cancel();

    setState(() {
      _borderColorMRZ = Colors.green;
    });

    // Set timer to change border back to white after 1.5 seconds
    _borderColorTimerMRZ = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColorMRZ = Colors.white;
        });
      }
    });
  }

  // Show failed validation with red border
  void _showFailedValidationMRZ() {
    _borderColorTimerMRZ?.cancel();

    setState(() {
      _borderColorMRZ = Colors.red;
    });

    _borderColorTimerMRZ = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColorMRZ = Colors.white;
        });
      }
    });
  }

  Future<void> _processFrameMRZ() async {
    if (_controllerMRZ == null ||
        !_controllerMRZ.value.isInitialized ||
        _isProcessingMRZ) {
      return;
    }

    _isProcessingMRZ = true;
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = p.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await _controllerMRZ.takePicture(filePath);

      final File imageFile = File(filePath);

      if (!imageFile.existsSync()) {
        print("Image file doesn't exist at: $filePath");
        return;
      }
// Convert image file to Base64
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final inputImage = InputImage.fromFilePath(filePath);
      final recognizedText = await _textRecognizerMRZ.processImage(inputImage);

      bool isValidPassport = _validatePassportMRZ(recognizedText.text);

      if (isValidPassport) {
        _capturedImagePath = filePath;
        passportImage = File(_capturedImagePath);
        globalVars.capturedPathsMRZ=filePath;
        globalVars.capturedBase64MRZ=base64String;

        globalVars.isValidPassportIdentification=true;

        // Stop taking more pictures immediately
        _frameProcessorMRZ?.cancel();

        // Show green border for successful validation
        _showSuccessfulValidationMRZ();

        if (mounted) {
          setState(() {
            _currentStepMRZ = _stepsMRZ.length - 1; // Move to final step
          });
        }

        // Navigate to results after a short delay to show the green border
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            // Ensure UI updates to show captured images
            setState(() {
              print("✅ Jordanian Passport Capture complete - UI refreshed with captured data");
            });
            _stopCameraAndCleanupMRZ();
            // _navigateToResultScreenMRZ();
            uploadPassportFile_API(passportImage);
          }
        });
      } else {
        // Show red border for failed validation
        _showFailedValidationMRZ();
      }
    } catch (e) {
      print("Processing error: $e");
    } finally {
      _isProcessingMRZ = false;
    }
  }
  Future<void> _stopCameraAndCleanupMRZ() async {
    print("Stopping camera and cleaning up resources...");

    // Cancel all timers
    _frameProcessorMRZ?.cancel();
    _borderColorTimerMRZ?.cancel();



    // Stop camera controller
    if (_controllerMRZ != null && _controllerMRZ.value.isInitialized) {
      await _controllerMRZ.dispose();
      _controllerMRZ = null;

    }

    // Close text recognizer
    //19 jun  await _textRecognizer.close();

    // Update UI state
    if (mounted) {
      setState(() {
        _isCameraInitializedMRZ = false;
      });


    }

    print("Camera and resources cleaned up successfully");
  }

  Widget _buildOverlayFrameMRZ() {
    return Container(
      color: Colors.black.withOpacity(0.0), // dim entire screen
      child: CustomPaint(
        painter: ScannerOverlayPainterMRZ(borderColor: _borderColorMRZ),
      ),
    );
  }

  Widget _buildStepTextMRZ() {
    return Positioned(
      bottom: 110,
      left: 16,
      right: 16,
      child: Center(
        child: Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.6),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            _currentStepMRZ < _stepsMRZ.length ? _stepsMRZ[_currentStepMRZ] : "Processing...",
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget _buildTipTextMRZ() {
    return Positioned(
      top: 40,
      left: 16,
      right: 16,
      child: AnimatedSwitcher(
        duration: Duration(milliseconds: 500),
        child: Text(
          _tipsMRZ[_tipIndexMRZ],
          key: ValueKey<int>(_tipIndexMRZ),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
  bool _validatePassportMRZ(String text) {
    print("Validating passport MRZ text: $text");

    // Clean the text by removing excessive spaces and normalizing line breaks
    String cleanedText = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Look for MRZ patterns - the most distinctive feature of passport
    bool hasFirstLineMRZ = _extractAndStoreMRZ(cleanedText, _mrzFirstLinePattern, 'mrzFirstLine');
    bool hasSecondLineMRZ = _extractAndStoreMRZ(cleanedText, _mrzSecondLinePattern, 'mrzSecondLine');

    // If we found MRZ lines, extract structured data from them
    if (hasFirstLineMRZ && hasSecondLineMRZ) {
      _extractDataFromMRZ();
      return true;
    }

    // Fall back to looking for other passport indicators
    bool hasPassportIndicator = cleanedText.toLowerCase().contains('passport');
    bool hasPassportNumber = _extractAndStoreMRZ(cleanedText, _passportNumberPattern, 'passportNumber');
    bool hasName = _extractAndStoreMRZ(cleanedText, _namePatternMRZ, 'name');
    bool hasDob = _extractWithContext(cleanedText, RegExp(r'Date of birth|Birth|DOB'), _datePatternMRZ, 'dateOfBirth');
    bool hasExpiry = _extractWithContext(cleanedText, _expiryDatePattern, _datePatternMRZ, 'expiryDate');
    bool hasNationality = _extractWithContext(cleanedText, _nationalityPattern, RegExp(r'[A-Z]{3}|[A-Za-z]+'), 'nationality');

    // For a valid passport scan, we need at least the passport indicator plus a few key fields
    int fieldsFound = [hasPassportNumber, hasName, hasDob, hasExpiry, hasNationality].where((match) => match).length;

    return hasPassportIndicator && fieldsFound >= 2;
  }

  void _extractDataFromMRZ() {
    // Extract structured data from MRZ lines if they exist
    if (_passportInfo.containsKey('mrzFirstLine') && _passportInfo.containsKey('mrzSecondLine')) {
      String firstLine = _passportInfo['mrzFirstLine'] ?? '';
      String secondLine = _passportInfo['mrzSecondLine'] ?? '';

      // Extract issuing country (positions 2-5 of first line)
      if (firstLine.length >= 5) {
        String countryCode = firstLine.substring(2, 5).replaceAll('<', '');
        _passportInfo['issuingCountry'] = countryCode;
      }

      // Extract surname and given names from the first line
      if (firstLine.length > 5) {
        String nameSection = firstLine.substring(5);
        List<String> nameParts = nameSection.split('<<');
        if (nameParts.length >= 2) {
          String surname = nameParts[0].replaceAll('<', ' ').trim();
          String givenNames = nameParts[1].replaceAll('<', ' ').trim();
          _passportInfo['surname'] = surname;
          _passportInfo['givenNames'] = givenNames;
          _passportInfo['name'] = '$surname, $givenNames';
        }
      }

      // Extract passport number (positions 0-9 of second line)
      if (secondLine.length >= 9) {
        _passportInfo['passportNumber'] = secondLine.substring(0, 9);
      }

      // Extract nationality (positions 10-13 of second line)
      if (secondLine.length >= 13) {
        _passportInfo['nationality'] = secondLine.substring(10, 13);
      }

      // Extract date of birth (positions 13-19 of second line) in format YYMMDD
      if (secondLine.length >= 19) {
        String dobRaw = secondLine.substring(13, 19);
        try {
          String year = '20' + dobRaw.substring(0, 2); // Assuming 21st century
          String month = dobRaw.substring(2, 4);
          String day = dobRaw.substring(4, 6);
          _passportInfo['dateOfBirth'] = '$day/$month/$year';
        } catch (e) {
          print("Error parsing date of birth: $e");
        }
      }

      // Extract gender (position 20 of second line)
      if (secondLine.length >= 21) {
        String genderCode = secondLine.substring(20, 21);
        _passportInfo['gender'] = genderCode == 'M' ? 'Male' : genderCode == 'F' ? 'Female' : genderCode;
      }

      // Extract expiry date (positions 21-27 of second line) in format YYMMDD
      if (secondLine.length >= 27) {
        String expiryRaw = secondLine.substring(21, 27);
        try {
          String year = '20' + expiryRaw.substring(0, 2); // Assuming 21st century
          String month = expiryRaw.substring(2, 4);
          String day = expiryRaw.substring(4, 6);
          _passportInfo['expiryDate'] = '$day/$month/$year';
        } catch (e) {
          print("Error parsing expiry date: $e");
        }
      }
    }
  }

  bool _extractAndStoreMRZ(String text, RegExp pattern, String key) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      _passportInfo[key] = match.group(0) ?? '';
      return true;
    }
    return false;
  }

  bool _extractWithContext(String text, RegExp headerPattern, RegExp valuePattern, String key) {
    final headerMatch = headerPattern.firstMatch(text);
    if (headerMatch != null) {
      // Look for the value pattern within a reasonable distance after the header
      int headerEndIndex = headerMatch.end;
      String textAfterHeader = text.substring(headerEndIndex, min(text.length, headerEndIndex + 100));

      final valueMatch = valuePattern.firstMatch(textAfterHeader);
      if (valueMatch != null) {
        _passportInfo[key] = valueMatch.group(0) ?? '';
        return true;
      }
    }
    return false;
  }

  int min(int a, int b) {
    return a < b ? a : b;
  }
  // Method to show successful validation with green border
  void _showSuccessfulValidationTemporary() {
    // Cancel any existing timer
    _borderColorTimerTemporary?.cancel();

    setState(() {
      _borderColorTemporary = Colors.green;
    });

    // Set timer to change border back to white after 1.5 seconds
    _borderColorTimerTemporary = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColorTemporary = Colors.white;
        });
      }
    });
  }

  // Show failed validation with red border
  void _showFailedValidationTemporary() {
    _borderColorTimerTemporary?.cancel();

    setState(() {
      _borderColorTemporary = Colors.red;
    });

    _borderColorTimerTemporary = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColorTemporary = Colors.white;
        });
      }
    });
  }

  Future<void> _processFrameTemporary() async {
    if (_controllerTemporary == null ||
        !_controllerTemporary.value.isInitialized ||
        _isProcessingTemporary) {
      return;
    }

    _isProcessingTemporary = true;
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = p.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await _controllerTemporary.takePicture(filePath);

      final File imageFile = File(filePath);

      if (!imageFile.existsSync()) {
        print("Image file doesn't exist at: $filePath");
        return;
      }
// Convert image file to Base64
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final inputImage = InputImage.fromFilePath(filePath);
      final recognizedText = await _textRecognizerTemporary.processImage(inputImage);

      bool isValidPassport = _validatePassportTemporary(recognizedText.text);

      if (isValidPassport) {
        _capturedImagePathTemporary = filePath;
        passportImage= File(_capturedImagePathTemporary);
        globalVars.capturedPathsTemporary=filePath;
        globalVars.capturedBase64Temporary=base64String;

        globalVars.isValidTemporaryIdentification=true;

        // Stop taking more pictures immediately
        _frameProcessorTemporary?.cancel();

        // Show green border for successful validation
        _showSuccessfulValidationTemporary();

        if (mounted) {
          setState(() {
            _currentStepTemporary = _stepsTemporary.length - 1; // Move to final step
          });
        }

        // Navigate to results after a short delay to show the green border
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            setState(() {
              // Set the base64 string for display
              TemporaryPassport = globalVars.capturedBase64Temporary.isNotEmpty ? globalVars.capturedBase64Temporary : '';
            });
            _stopCameraAndCleanupTemporary();
            uploadPassportTempFile_API(passportImage);
            // _navigateToResultScreenMRZ();
          }
        });
      } else {
        // Show red border for failed validation
        _showFailedValidationTemporary();
      }
    } catch (e) {
      print("Processing error: $e");
    } finally {
      _isProcessingTemporary = false;
    }
  }
  Future<void> _restartCameraPassportTemporary() async {
    print("Restarting camera ...");

    // Reset state variables
    /* _currentStep = 0;
    _currentStepMRZ = 0;
    _isProcessing = false;
    _isProcessingMRZ = false;
    _isProcessingTemporary = false;
    _capturedPaths.clear();
    _capturedBase64.clear();
    globalVars.capturedPaths.clear();
    globalVars.capturedBase64.clear();
    globalVars.capturedPathsMRZ="";
    globalVars.capturedBase64MRZ="";
    globalVars.capturedPathsTemporary="";
    globalVars.capturedBase64Temporary="";

    globalVars.capturedPathsForeign="";
    globalVars.capturedBase64Foreign="";

    _capturedImagePath="";
    _capturedImagePathTemporary="";


    _idInfo.clear();
    _borderColor = Colors.white;
    _remainingTime = _timeoutDuration;
    _tipIndex = 0;
    _tipIndexMRZ = 0;
    _borderColor = Colors.white;
    _borderColorMRZ = Colors.white;
    _borderColorTemporary = Colors.white;
    _idInfo.clear();
    _passportInfoTemporary.clear();
    _passportInfo.clear();
    _tipIndexTemporary = 0;
    _currentStepTemporary = 0;*/


    // Reset state variables
    _currentStep = 0;
    _currentStepMRZ = 0;
    _currentStepTemporary = 0;
    _currentStepForeign=0;

    _isProcessing = false;
    _isProcessingMRZ = false;
    _isProcessingTemporary = false;
    _isProcessingForeign=false;

    _capturedPaths.clear();
    _capturedBase64.clear();
    globalVars.capturedPaths.clear();
    globalVars.capturedBase64.clear();
    globalVars.capturedPathsMRZ="";
    globalVars.capturedBase64MRZ="";
    globalVars.capturedPathsTemporary="";
    globalVars.capturedBase64Temporary="";
    globalVars.capturedPathsForeign="";
    globalVars.capturedBase64Foreign="";

    _capturedImagePath="";
    _capturedImagePathTemporary="";
    _capturedImagePathForeign="";




    _borderColor = Colors.white;
    _borderColorMRZ = Colors.white;
    _borderColorTemporary = Colors.white;
    _borderColorForeign = Colors.white;

    _remainingTime = _timeoutDuration;

    _tipIndex = 0;
    _tipIndexMRZ = 0;
    _tipIndexTemporary = 0;
    _tipIndexForeign = 0;

    _idInfo.clear();
    _passportInfo.clear();
    _passportInfoTemporary.clear();
    _passportInfoForeign.clear();

    // Reinitialize camera
    await _initializeCameraTemporary();

    // Restart timers
    _startTipRotationTemporary();


    print("Camera  restarted successfully");
  }

  Future<void> _initializeCameraForeign() async {
    print("Attempting to initialize Foreign Passport camera...");

    if (!isEkycInitialized) {
      setState(() {
        isloading = true;
      });
      await generateEkycToken();
      setState(() {
        isloading = false;
      });
    }

    if (!isEkycInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("eKYC system not ready. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controllerForeign = CameraController(backCamera, ResolutionPreset.high);
      await _controllerForeign.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitializedForeign = true;
      });

      _startFrameProcessingForeign();
      _startTipRotationForeign();

    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to access camera."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _initializeCameraTemporary() async {
    print("Attempting to initialize Temporary Passport camera...");

    if (!isEkycInitialized) {
      setState(() {
        isloading = true;
      });
      await generateEkycToken();
      setState(() {
        isloading = false;
      });
    }

    if (!isEkycInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("eKYC system not ready. Please try again."),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controllerTemporary = CameraController(backCamera, ResolutionPreset.high);
      await _controllerTemporary.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitializedTemporary = true;
      });

      _startFrameProcessingTemporary();
      _startTipRotationTemporary();

    } catch (e) {
      print("ERROR: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Failed to access camera."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  void _startTipRotationTemporary() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _tipIndexTemporary = (_tipIndexTemporary + 1) % _tipsTemporary.length);
    });
  }

  void _startFrameProcessingTemporary() {
    _frameProcessorTemporary = Timer.periodic(Duration(milliseconds: 1500), (_) {
      _processFrameTemporary();
    });
  }
  void _startFrameProcessingForeign() {
    _frameProcessorForeign = Timer.periodic(Duration(milliseconds: 1500), (_) {
      _processFrameForeign();
    });
  }



   bool _validatePassportTemporary(String text) {
    print("Validating passport Temporary text: $text");

    // Clean the text by removing excessive spaces and normalizing line breaks
    String cleanedText = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Look for MRZ patterns - the most distinctive feature of passport
    bool hasFirstLineTemporary = _extractAndStoreTemporary(cleanedText, _mrzFirstLinePatternTemporary, 'mrzFirstLine');
    bool hasSecondLineTemporary = _extractAndStoreTemporary(cleanedText, _mrzSecondLinePatternTemporary, 'mrzSecondLine');

    // If we found MRZ lines, extract structured data from them
    if (hasFirstLineTemporary && hasSecondLineTemporary) {
      _extractDataFromTemporary();
      return true;
    }

    // Fall back to looking for other passport indicators
    bool hasPassportIndicator = cleanedText.toLowerCase().contains('passport');
    bool hasPassportNumber = _extractAndStoreTemporary(cleanedText, _passportNumberPatternTemporary, 'passportNumber');
    bool hasName = _extractAndStoreTemporary(cleanedText, _namePatternTemporary, 'name');
    bool hasDob = _extractWithContextTemporary(cleanedText, RegExp(r'Date of birth|Birth|DOB'), _datePatternTemporary, 'dateOfBirth');
    bool hasExpiry = _extractWithContextTemporary(cleanedText, _expiryDatePatternTemporary, _datePatternTemporary, 'expiryDate');
    bool hasNationality = _extractWithContextTemporary(cleanedText, _nationalityPatternTemporary, RegExp(r'[A-Z]{3}|[A-Za-z]+'), 'nationality');

    // For a valid passport scan, we need at least the passport indicator plus a few key fields
    int fieldsFound = [hasPassportNumber, hasName, hasDob, hasExpiry, hasNationality].where((match) => match).length;

    return hasPassportIndicator && fieldsFound >= 2;
  }

  void _extractDataFromTemporary() {
    // Extract structured data from MRZ lines if they exist
    if (_passportInfoTemporary.containsKey('mrzFirstLine') && _passportInfoTemporary.containsKey('mrzSecondLine')) {
      String firstLine = _passportInfoTemporary['mrzFirstLine'] ?? '';
      String secondLine = _passportInfoTemporary['mrzSecondLine'] ?? '';

      // Extract issuing country (positions 2-5 of first line)
      if (firstLine.length >= 5) {
        String countryCode = firstLine.substring(2, 5).replaceAll('<', '');
        _passportInfoTemporary['issuingCountry'] = countryCode;
      }

      // Extract surname and given names from the first line
      if (firstLine.length > 5) {
        String nameSection = firstLine.substring(5);
        List<String> nameParts = nameSection.split('<<');
        if (nameParts.length >= 2) {
          String surname = nameParts[0].replaceAll('<', ' ').trim();
          String givenNames = nameParts[1].replaceAll('<', ' ').trim();
          _passportInfoTemporary['surname'] = surname;
          _passportInfoTemporary['givenNames'] = givenNames;
          _passportInfoTemporary['name'] = '$surname, $givenNames';
        }
      }

      // Extract passport number (positions 0-9 of second line)
      if (secondLine.length >= 9) {
        _passportInfoTemporary['passportNumber'] = secondLine.substring(0, 9);
      }

      // Extract nationality (positions 10-13 of second line)
      if (secondLine.length >= 13) {
        _passportInfoTemporary['nationality'] = secondLine.substring(10, 13);
      }

      // Extract date of birth (positions 13-19 of second line) in format YYMMDD
      if (secondLine.length >= 19) {
        String dobRaw = secondLine.substring(13, 19);
        try {
          String year = '20' + dobRaw.substring(0, 2); // Assuming 21st century
          String month = dobRaw.substring(2, 4);
          String day = dobRaw.substring(4, 6);
          _passportInfoTemporary['dateOfBirth'] = '$day/$month/$year';
        } catch (e) {
          print("Error parsing date of birth: $e");
        }
      }

      // Extract gender (position 20 of second line)
      if (secondLine.length >= 21) {
        String genderCode = secondLine.substring(20, 21);
        _passportInfoTemporary['gender'] = genderCode == 'M' ? 'Male' : genderCode == 'F' ? 'Female' : genderCode;
      }

      // Extract expiry date (positions 21-27 of second line) in format YYMMDD
      if (secondLine.length >= 27) {
        String expiryRaw = secondLine.substring(21, 27);
        try {
          String year = '20' + expiryRaw.substring(0, 2); // Assuming 21st century
          String month = expiryRaw.substring(2, 4);
          String day = expiryRaw.substring(4, 6);
          _passportInfoTemporary['expiryDate'] = '$day/$month/$year';
        } catch (e) {
          print("Error parsing expiry date: $e");
        }
      }
    }
  }

  bool _extractAndStoreTemporary(String text, RegExp pattern, String key) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      _passportInfoTemporary[key] = match.group(0) ?? '';
      return true;
    }
    return false;
  }

  bool _extractWithContextTemporary(String text, RegExp headerPattern, RegExp valuePattern, String key) {
    final headerMatch = headerPattern.firstMatch(text);
    if (headerMatch != null) {
      // Look for the value pattern within a reasonable distance after the header
      int headerEndIndex = headerMatch.end;
      String textAfterHeader = text.substring(headerEndIndex, min(text.length, headerEndIndex + 100));

      final valueMatch = valuePattern.firstMatch(textAfterHeader);
      if (valueMatch != null) {
        _passportInfoTemporary[key] = valueMatch.group(0) ?? '';
        return true;
      }
    }
    return false;
  }

  int minTemporary(int a, int b) {
    return a < b ? a : b;
  }
  Future<void> _stopCameraAndCleanupTemporary() async {
    print("Stopping camera and cleaning up resources...");

    // Cancel all timers
    _frameProcessorTemporary?.cancel();
    _borderColorTimerTemporary?.cancel();



    // Stop camera controller
    if (_controllerTemporary != null && _controllerTemporary.value.isInitialized) {
      await _controllerTemporary.dispose();
      _controllerTemporary = null;

    }

    // Close text recognizer
    //19 jun  await _textRecognizer.close();

    // Update UI state
    if (mounted) {
      setState(() {
        _isCameraInitializedTemporary = false;
      });


    }

    print("Camera and resources cleaned up successfully");
  }

  void _showSuccessfulValidationForeign() {
    // Cancel any existing timer
    _borderColorTimerForeign?.cancel();

    setState(() {
      _borderColorForeign = Colors.green;
    });

    // Set timer to change border back to white after 1.5 seconds
    _borderColorTimerForeign = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColorForeign = Colors.white;
        });
      }
    });
  }

  Future<void> _processFrameForeign() async {
    if (_controllerForeign == null ||
        !_controllerForeign.value.isInitialized ||
        _isProcessingForeign) {
      return;
    }

    _isProcessingForeign = true;
    try {
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = p.join(
        tempDir.path,
        '${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      await _controllerForeign.takePicture(filePath);

      final File imageFile = File(filePath);

      if (!imageFile.existsSync()) {
        print("Image file doesn't exist at: $filePath");
        return;
      }
// Convert image file to Base64
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final inputImage = InputImage.fromFilePath(filePath);
      final recognizedText = await _textRecognizerForeign.processImage(inputImage);

      bool isValidPassport = _validatePassportForeign(recognizedText.text);

      if (isValidPassport) {
        _capturedImagePathForeign = filePath;
        passportImage = File(_capturedImagePathForeign);
        globalVars.capturedPathsForeign=filePath;
        globalVars.capturedBase64Foreign=base64String;

        //  globalVars.isValidForeignIdentification=true;

        // Stop taking more pictures immediately
        _frameProcessorForeign?.cancel();

        // Show green border for successful validation
        _showSuccessfulValidationForeign();

        if (mounted) {
          setState(() {
            _currentStepForeign = _stepsForeign.length - 1; // Move to final step
          });
        }

        // Navigate to results after a short delay to show the green border
        Future.delayed(Duration(milliseconds: 1500), () {
          if (mounted) {
            // Ensure UI updates to show captured images
            setState(() {
              print("✅ Foreign Passport Capture complete - UI refreshed with captured data");
            });
            _stopCameraAndCleanupForeign();
            uploadForignPassportFile_API(passportImage);
            // _navigateToResultScreenMRZ();
          }
        });
      } else {
        // Show red border for failed validation
        _showFailedValidationForeign();
      }
    } catch (e) {
      print("Processing error: $e");
    } finally {
      _isProcessingForeign = false;
    }
  }
  void _showFailedValidationForeign() {
    _borderColorTimerForeign?.cancel();

    setState(() {
      _borderColorForeign = Colors.red;
    });

    _borderColorTimerForeign= Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColorForeign = Colors.white;
        });
      }
    });
  }

  Future<void> _stopCameraAndCleanupForeign() async {
    print("Stopping camera and cleaning up resources...");

    // Cancel all timers
    _frameProcessorForeign?.cancel();
    _borderColorTimerForeign?.cancel();



    // Stop camera controller
    if (_controllerForeign != null && _controllerForeign.value.isInitialized) {
      await _controllerForeign.dispose();
      _controllerForeign = null;

    }

    // Close text recognizer
    //19 jun  await _textRecognizer.close();

    // Update UI state
    if (mounted) {
      setState(() {
        _isCameraInitializedForeign = false;
      });


    }

    print("Camera and resources cleaned up successfully");
  }

  bool _validatePassportForeign(String text) {
    print("Validating passport Foreign text: $text");

    // Clean the text by removing excessive spaces and normalizing line breaks
    String cleanedText = text.replaceAll(RegExp(r'\s+'), ' ').trim();

    // Look for MRZ patterns - the most distinctive feature of passport
    bool hasFirstLineForeign= _extractAndStoreForeign(cleanedText, _mrzFirstLinePatternForeign, 'mrzFirstLine');
    bool hasSecondLineForeign = _extractAndStoreForeign(cleanedText, _mrzSecondLinePatternForeign, 'mrzSecondLine');

    // If we found MRZ lines, extract structured data from them
    if (hasFirstLineForeign && hasSecondLineForeign) {
      _extractDataFromForeign();
      return true;
    }

    // Fall back to looking for other passport indicators
    bool hasPassportIndicator = cleanedText.toLowerCase().contains('passport');
    bool hasPassportNumber = _extractAndStoreForeign(cleanedText, _passportNumberPatternForeign, 'passportNumber');
    bool hasName = _extractAndStoreForeign(cleanedText, _namePatternForeign, 'name');
    bool hasDob = _extractWithContextForeign(cleanedText, RegExp(r'Date of birth|Birth|DOB'), _datePatternForeign, 'dateOfBirth');
    bool hasExpiry = _extractWithContextForeign(cleanedText, _expiryDatePatternForeign, _datePatternForeign, 'expiryDate');
    bool hasNationality = _extractWithContextForeign(cleanedText, _nationalityPatternForeign, RegExp(r'[A-Z]{3}|[A-Za-z]+'), 'nationality');

    // For a valid passport scan, we need at least the passport indicator plus a few key fields
    int fieldsFound = [hasPassportNumber, hasName, hasDob, hasExpiry, hasNationality].where((match) => match).length;

    return hasPassportIndicator && fieldsFound >= 2;
  }

  void _extractDataFromForeign() {
    // Extract structured data from MRZ lines if they exist
    if (_passportInfoForeign.containsKey('mrzFirstLine') && _passportInfoForeign.containsKey('mrzSecondLine')) {
      String firstLine = _passportInfoForeign['mrzFirstLine'] ?? '';
      String secondLine = _passportInfoForeign['mrzSecondLine'] ?? '';

      // Extract issuing country (positions 2-5 of first line)
      if (firstLine.length >= 5) {
        String countryCode = firstLine.substring(2, 5).replaceAll('<', '');
        _passportInfoForeign['issuingCountry'] = countryCode;
      }

      // Extract surname and given names from the first line
      if (firstLine.length > 5) {
        String nameSection = firstLine.substring(5);
        List<String> nameParts = nameSection.split('<<');
        if (nameParts.length >= 2) {
          String surname = nameParts[0].replaceAll('<', ' ').trim();
          String givenNames = nameParts[1].replaceAll('<', ' ').trim();
          _passportInfoForeign['surname'] = surname;
          _passportInfoForeign['givenNames'] = givenNames;
          _passportInfoForeign['name'] = '$surname, $givenNames';
        }
      }

      // Extract passport number (positions 0-9 of second line)
      if (secondLine.length >= 9) {
        _passportInfoForeign['passportNumber'] = secondLine.substring(0, 9);
      }

      // Extract nationality (positions 10-13 of second line)
      if (secondLine.length >= 13) {
        _passportInfoForeign['nationality'] = secondLine.substring(10, 13);
      }

      // Extract date of birth (positions 13-19 of second line) in format YYMMDD
      if (secondLine.length >= 19) {
        String dobRaw = secondLine.substring(13, 19);
        try {
          String year = '20' + dobRaw.substring(0, 2); // Assuming 21st century
          String month = dobRaw.substring(2, 4);
          String day = dobRaw.substring(4, 6);
          _passportInfoForeign['dateOfBirth'] = '$day/$month/$year';
        } catch (e) {
          print("Error parsing date of birth: $e");
        }
      }

      // Extract gender (position 20 of second line)
      if (secondLine.length >= 21) {
        String genderCode = secondLine.substring(20, 21);
        _passportInfoForeign['gender'] = genderCode == 'M' ? 'Male' : genderCode == 'F' ? 'Female' : genderCode;
      }

      // Extract expiry date (positions 21-27 of second line) in format YYMMDD
      if (secondLine.length >= 27) {
        String expiryRaw = secondLine.substring(21, 27);
        try {
          String year = '20' + expiryRaw.substring(0, 2); // Assuming 21st century
          String month = expiryRaw.substring(2, 4);
          String day = expiryRaw.substring(4, 6);
          _passportInfoForeign['expiryDate'] = '$day/$month/$year';
        } catch (e) {
          print("Error parsing expiry date: $e");
        }
      }
    }
  }

  bool _extractAndStoreForeign(String text, RegExp pattern, String key) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      _passportInfoForeign[key] = match.group(0) ?? '';
      return true;
    }
    return false;
  }

  bool _extractWithContextForeign(String text, RegExp headerPattern, RegExp valuePattern, String key) {
    final headerMatch = headerPattern.firstMatch(text);
    if (headerMatch != null) {
      // Look for the value pattern within a reasonable distance after the header
      int headerEndIndex = headerMatch.end;
      String textAfterHeader = text.substring(headerEndIndex, min(text.length, headerEndIndex + 100));

      final valueMatch = valuePattern.firstMatch(textAfterHeader);
      if (valueMatch != null) {
        _passportInfoForeign[key] = valueMatch.group(0) ?? '';
        return true;
      }
    }
    return false;
  }

  int minForeign(int a, int b) {
    return a < b ? a : b;
  }
  Future<void> _restartCameraPassportForeign() async {
    print("Restarting camera ...");

    // Reset state variables
    _currentStep = 0;
    _currentStepMRZ = 0;
    _currentStepTemporary = 0;
    _currentStepForeign=0;

    _isProcessing = false;
    _isProcessingMRZ = false;
    _isProcessingTemporary = false;
    _isProcessingForeign=false;

    _capturedPaths.clear();
    _capturedBase64.clear();
    globalVars.capturedPaths.clear();
    globalVars.capturedBase64.clear();
    globalVars.capturedPathsMRZ="";
    globalVars.capturedBase64MRZ="";
    globalVars.capturedPathsTemporary="";
    globalVars.capturedBase64Temporary="";
    globalVars.capturedPathsForeign="";
    globalVars.capturedBase64Foreign="";

    _capturedImagePath="";
    _capturedImagePathTemporary="";
    _capturedImagePathForeign="";




    _borderColor = Colors.white;
    _borderColorMRZ = Colors.white;
    _borderColorTemporary = Colors.white;
    _borderColorForeign = Colors.white;

    _remainingTime = _timeoutDuration;

    _tipIndex = 0;
    _tipIndexMRZ = 0;
    _tipIndexTemporary = 0;
    _tipIndexForeign = 0;

    _idInfo.clear();
    _passportInfo.clear();
    _passportInfoTemporary.clear();
    _passportInfoForeign.clear();




    // Reinitialize camera
    await _initializeCameraForeign();

    // Restart timers
    _startTipRotationForeign();


    print("Camera  restarted successfully");
  }
  void _startTipRotationForeign() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _tipIndexForeign = (_tipIndexForeign + 1) % _tipsForeign.length);
    });
  }
  uploadFrontID_API(File frontImageFile) async {
    final client = createHttpClient();
    setState(() {
      isloading = true;
    });
    try {
      // Create the URL with path parameter
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document-multipart";
      final url = Uri.parse(apiUrl);


      var request = http.MultipartRequest('POST', url);

      // Add headers - Remove Content-Type for multipart requests
      request.headers.addAll({
        'Authorization': "Bearer ${globalVars.ekycTokenID}"
        // Don't set Content-Type manually for multipart requests
      });

      // Add the JSON data as a field
      final jsonData = {
        "citizenship": "JOR",
        "type": "identity_card",
        "id": 13,
        "media": [
          {
            "side": "front",
            "uploadedByFilesystem": true
          }
        ]
      };

      request.fields['data'] = jsonEncode(jsonData);

      // Try different field names for the file
      var multipartFile = await http.MultipartFile.fromPath(
        'front', // Try 'front', 'back', 'image', or 'identity_card' instead of 'file'
        frontImageFile.path,
        filename: 'identity_card_front.jpg',
      );

      request.files.add(multipartFile);

      // Send the request
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        setState(() {
          isloading = false;
          // Set the base64 string for display
          IDFront = globalVars.capturedBase64.isNotEmpty ? globalVars.capturedBase64[0] : '';
        });
        print("success1 haya hazaimeh");
        huploadBackID_API(backImage);

        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

        setState(() {
          isloading = false;

          globalVars.showForeignPassport=false;
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
          globalVars.tackForeign=false;
          globalVars.tackTemporary=false;
          globalVars.showPersonalNumber=false;
          globalVars.tackID= false;
          globalVars.tackJordanPassport= false;

        });
        return null;
      }
    } catch (e) {
      setState(() {
        isloading = false;

        globalVars.showForeignPassport=false;
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
        globalVars.tackForeign=false;
        globalVars.tackTemporary=false;
        globalVars.showPersonalNumber=false;
        globalVars.tackID= false;
        globalVars.tackJordanPassport= false;
      });
      print('Exception: $e');
      return null;
    }
  }

  huploadBackID_API(File backImageFile) async {
    setState(() {
      isloading = true;
    });
    final client = createHttpClient();
    try {
      // Create the URL with path parameter
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document-multipart";
      final url = Uri.parse(apiUrl);

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers - Remove Content-Type for multipart requests
      request.headers.addAll({
        'Authorization': "Bearer ${globalVars.ekycTokenID}"
        // Don't set Content-Type manually for multipart requests
      });

      // Add the JSON data as a field
      final jsonData = {
        "citizenship": "JOR",
        "type": "identity_card",
        "id": 13,
        "media": [
          {
            "side": "back",
            "uploadedByFilesystem": true
          }
        ]
      };

      request.fields['data'] = jsonEncode(jsonData);

      // Try different field names for the file
      var multipartFile = await http.MultipartFile.fromPath(
        'back', // Try 'front', 'back', 'image', or 'identity_card' instead of 'file'
        backImageFile.path,
        filename: 'identity_card_back.jpg',
      );

      request.files.add(multipartFile);

      // Send the request
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("success2 haya hazaimeh");
        setState(() {
          isloading = false;
          // Set the base64 string for display
          IDBack = globalVars.capturedBase64.length > 1 ? globalVars.capturedBase64[1] : '';
        });
        documentProcessingID_API();
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

        setState(() {
          isloading = false;

          globalVars.showForeignPassport=false;
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
          globalVars.tackForeign=false;
          globalVars.tackTemporary=false;
          globalVars.showPersonalNumber=false;
          globalVars.tackID= false;
          globalVars.tackJordanPassport= false;
        });
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        return null;
      }
    } catch (e) {
      setState(() {
        isloading = false;

        globalVars.showForeignPassport=false;
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
        globalVars.tackForeign=false;
        globalVars.tackTemporary=false;
        globalVars.showPersonalNumber=false;
        globalVars.tackID= false;
        globalVars.tackJordanPassport= false;
      });
      print('Exception: $e');
      return null;
    }
  }

  uploadPassportFile_API(File frontImageFile) async {
    setState(() {
      isloading = true;
    });
    final client = createHttpClient();
    try {
      // Create the URL with path parameter
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document-multipart";
      final url = Uri.parse(apiUrl);

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers - Remove Content-Type for multipart requests
      request.headers.addAll({
        'Authorization': "Bearer ${globalVars.ekycTokenID}"
        // Don't set Content-Type manually for multipart requests
      });

      // Add the JSON data as a field
      final jsonData = {
        "citizenship": "JOR",
        "type": "passport",
        "id": 14,
        "media": [
          {
            "side": "front",
            "uploadedByFilesystem": true
          }
        ]
      };

      request.fields['data'] = jsonEncode(jsonData);

      // Try different field names for the file
      var multipartFile = await http.MultipartFile.fromPath(
        'front', // Try 'front', 'back', 'image', or 'identity_card' instead of 'file'
        frontImageFile.path,
        filename: 'identity_passport_front.jpg',
      );

      request.files.add(multipartFile);

      // Send the request
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("success3 haya hazaimeh");
        setState(() {
          isloading = false;
          // Set the base64 string for display
          JordanianPassport = globalVars.capturedBase64MRZ.isNotEmpty ? globalVars.capturedBase64MRZ : '';
        });
        documentProcessingPassport_API();
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

        setState(() {
          isloading = false;

          globalVars.showForeignPassport=false;
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
          globalVars.tackForeign=false;
          globalVars.tackTemporary=false;
          globalVars.showPersonalNumber=false;
          globalVars.tackID= false;
          globalVars.tackJordanPassport= false;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        isloading = false;

        globalVars.showForeignPassport=false;
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
        globalVars.tackForeign=false;
        globalVars.tackTemporary=false;
        globalVars.tackID= false;
        globalVars.tackJordanPassport= false;
        globalVars.showPersonalNumber=false;
      });
      print('Exception: $e');
      return null;
    }
  }

  uploadPassportTempFile_API(File frontImageFile) async {
    setState(() {
      isloading = true;
    });
    final client = createHttpClient();
    try {
      // Create the URL with path parameter
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document-multipart";
      final url = Uri.parse(apiUrl);

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers - Remove Content-Type for multipart requests
      request.headers.addAll({
        'Authorization': "Bearer ${globalVars.ekycTokenID}"
        // Don't set Content-Type manually for multipart requests
      });

      // Add the JSON data as a field
      final jsonData = {
        "citizenship": "UNK",
        "type": "passport",
        "id": 9999,
        "media": [
          {
            "side": "front",
            "uploadedByFilesystem": true
          }
        ]
      };

      request.fields['data'] = jsonEncode(jsonData);

      // Try different field names for the file
      var multipartFile = await http.MultipartFile.fromPath(
        'front', // Try 'front', 'back', 'image', or 'identity_card' instead of 'file'
        frontImageFile.path,
        filename: 'identity_passport_front.jpg',
      );

      request.files.add(multipartFile);

      // Send the request
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("success3 haya hazaimeh");
        setState(() {
          isloading = false;
          // Set the base64 string for display
          JordanianPassport = globalVars.capturedBase64MRZ.isNotEmpty ? globalVars.capturedBase64MRZ : '';
        });
        documentProcessingPassport_API();
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

        setState(() {
          isloading = false;

          globalVars.showForeignPassport=false;
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
          globalVars.tackForeign=false;
          globalVars.tackTemporary=false;
          globalVars.showPersonalNumber=false;
          globalVars.tackID= false;
          globalVars.tackJordanPassport= false;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        isloading = false;

        globalVars.showForeignPassport=false;
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
        globalVars.tackForeign=false;
        globalVars.tackTemporary=false;
        globalVars.tackID= false;
        globalVars.tackJordanPassport= false;
        globalVars.showPersonalNumber=false;
      });
      print('Exception: $e');
      return null;
    }
  }

  uploadForignPassportFile_API(File frontImageFile) async {
    setState(() {
      isloading = true;
    });
    final client = createHttpClient();
    try {
      // Create the URL with path parameter
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document-multipart";
      final url = Uri.parse(apiUrl);

      // Create multipart request
      var request = http.MultipartRequest('POST', url);

      // Add headers - Remove Content-Type for multipart requests
      request.headers.addAll({
        'Authorization': "Bearer ${globalVars.ekycTokenID}"
        // Don't set Content-Type manually for multipart requests
      });

      // Add the JSON data as a field
      final jsonData = {
        "citizenship": "UNK",
        "type": "passport",
        "id": 25,
        "media": [
          {
            "side": "front",
            "uploadedByFilesystem": true
          }
        ]
      };

      request.fields['data'] = jsonEncode(jsonData);

      // Try different field names for the file
      var multipartFile = await http.MultipartFile.fromPath(
        'front', // Try 'front', 'back', 'image', or 'identity_card' instead of 'file'
        frontImageFile.path,
        filename: 'identity_passport_front.jpg',
      );

      request.files.add(multipartFile);

      // Send the request
      var streamedResponse = await client.send(request);
      var response = await http.Response.fromStream(streamedResponse);

      print('Status Code: ${response.statusCode}');
      print('Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("success3 haya hazaimeh");
        setState(() {
          isloading = false;
          // Set the base64 string for display
          ForeignPassport = globalVars.capturedBase64Foreign.isNotEmpty ? globalVars.capturedBase64Foreign : '';
        });
        documentProcessingForignPassport_API();
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');

        setState(() {
          isloading = false;

          globalVars.showForeignPassport=false;
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
          globalVars.tackForeign=false;
          globalVars.tackTemporary=false;
          globalVars.showPersonalNumber=false;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        isloading = false;

        globalVars.showForeignPassport=false;
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
        globalVars.tackForeign=false;
        globalVars.tackTemporary=false;
        globalVars.showPersonalNumber=false;
      });
      print('Exception: $e');
      return null;
    }
  }

  void documentProcessingID_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isloading = true;
    });
    final client = createHttpClient();

    final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document/process";
    final response = await client.post(
      Uri.parse(apiUrl),
      headers: {
        "content-type": "application/json",
        'Authorization':   "Bearer ${globalVars.ekycTokenID}"
      },
    );

    print("API Response: ${response.body}");

    if (response.statusCode == 200) {

      setState(() {
        isloading=false;
        _loadImageFrontID=true;
        _loadImageBackID=true;

      });
      final Map<String, dynamic> responseMap = json.decode(response.body);
      print("Parsed Result: $responseMap");
      // Top-level fields
      print("Success: ${responseMap['success']}");
      print("Timestamp: ${responseMap['timestamp']}");

      // Message
      print("Message (EN): ${responseMap['message']['en']}");
      print("Message (AR): ${responseMap['message']['ar']}");


      // Data object
      final data = responseMap['data'];

      if(responseMap['success']==true){
        // ✅ Document processing successful - set flags
        setState(() {
          _documentProcessingSuccess = true;
          _lastValidatedNationalNo = nationalNo.text; // Store the validated national number
        });
        print("✅ Document processing successful for National No: ${nationalNo.text}");
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?" ${responseMap['message']['en']}":"${responseMap['message']['ar']}"),backgroundColor: Colors.green));
        print("Status: ${data['status']}");
        print("UID: ${data['uid']}");
        print("OCR Attempts: ${data['ocrAttempts']}");


        // Visual Data
        final visual = data['ocrData']['visual'];




        globalVars.fullNameAr=data['ocrData']["localUserGivenNames"];

        // globalVars.fullNameEn=data['ocrData']['userGivenNames'];
        globalVars.fullNameEn=data['ocrData']['visual']['userNames']!= null ? data['ocrData']['visual']['userNames'] : "";

        globalVars.natinalityNumber=visual['userPersonalNumber'];
        globalVars.cardNumber=visual['documentNumber'];
        globalVars.birthdate=data['ocrData']['userDateOfBirth'].split("T").first;
        globalVars.expirayDate=data['ocrData']["documentExpirationDate"].split("T").first;
        globalVars.gender=data['ocrData']['userSex'];
        globalVars.bloodGroup=data['ocrData']['userBloodGroup'];
        globalVars.registrationNumber=data['ocrData']['userCivilRegistrationNumber'];

        // Custom Validation
        final customValidation = data['ocrData']['customValidation'];
        print("Valid Sex: ${customValidation['validSex']}");
        print("Valid Date of Birth: ${customValidation['validDateOfBirth']}");

        // Additional Data
        print("Token ID: ${data['additionalData']['tokenID']}");

        // Loop through media
        List mediaList = data['media'];
        for (var media in mediaList) {
          print("Media Side: ${media['side']}");
          print("Media Filename: ${media['filename']}");
          print("Media Type: ${media['type']}");
          print("Media Path: ${media['path']}");
          print("Media UID: ${media['uid']}");
        }
      }
      if(responseMap['success']==false){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"${responseMap['"errorName']} : ${responseMap['message']['en']}":"${responseMap['"errorName']} :${responseMap['message']['ar']}"),backgroundColor: Colors.red));
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
        globalVars.showPersonalNumber=false;
      }



    } else {
      print('Raw response: ${response.body}');
      setState(() {
        isloading=false;
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
        globalVars.showPersonalNumber=false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? jsonDecode(response.body)['message']['en']
                : jsonDecode(response.body)['message']['ar'],
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isloading=false;
      });
    }
  }

  void documentProcessingForignPassport_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final client = createHttpClient();
    setState(() {
      isloading = true;
    });
    final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document/process";
    final response = await client.post(
      Uri.parse(apiUrl),
      headers: {
        "content-type": "application/json",
        'Authorization':   "Bearer ${globalVars.ekycTokenID}"
      },
    );

    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        isloading=false;

      });
      final Map<String, dynamic> responseMap = json.decode(response.body);
      print("Parsed Result: $responseMap");
      // Top-level fields
      print("Success: ${responseMap['success']}");

      // Message
      print("Message (EN): ${responseMap['message']['en']}");
      print("Message (AR): ${responseMap['message']['ar']}");


      // Data object
      final data = responseMap['data'];

      if(responseMap['success']==true){
        if(data['status']=="working"){
          // ✅ Document processing successful - set flag (passport number validated, not national number for foreign)
          setState(() {
            _documentProcessingSuccess = true;
            // For foreign passports, store the passport number (not national number)
            _lastValidatedNationalNo = passportNo.text;
          });
          print("✅ Foreign passport processing successful for Passport No: ${passportNo.text}");
          
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?" ${responseMap['message']['en']}":"${responseMap['message']['ar']}"),backgroundColor: Colors.green));
          
          // ✅ Combine givenNames and surname for full name
          String givenNames = data['ocrData']['givenNames'] ?? "";
          String surname = data['ocrData']['surname'] ?? "";
          String fullName = givenNames.isNotEmpty && surname.isNotEmpty 
              ? "$givenNames $surname" 
              : (givenNames.isNotEmpty ? givenNames : surname);
          passportNo.text=data['ocrData']['nationalNumber'];

          globalVars.fullNameAr=fullName;
          globalVars.fullNameEn = fullName;
          globalVars.natinalityNumber=data['ocrData']['nationalNumber'] ?? "-";
          globalVars.cardNumber=data['ocrData']['documentNumber'];
          passportNo.text=data['ocrData']['nationalNumber'];
          // ✅ Handle date parsing - dates come as {year, month, day}
          var dobData = data['ocrData']['dateOfBirth'];
          String year = dobData['year'].toString().padLeft(2, '0');
          String month = dobData['month'].toString().padLeft(2, '0');
          String day = dobData['day'].toString().padLeft(2, '0');
          
          // ✅ Convert 2-digit year to full year
          int yearInt = int.parse(year);
          if (yearInt < 100) {
            yearInt = yearInt <= 30 ? 2000 + yearInt : 1900 + yearInt;
          }
          globalVars.birthdate = '$yearInt-$month-$day';
          
          // ✅ Handle expiration date
          var expData = data['ocrData']['expirationDate'];
          String expYear = expData['year'].toString().padLeft(2, '0');
          String expMonth = expData['month'].toString().padLeft(2, '0');
          String expDay = expData['day'].toString().padLeft(2, '0');
          
          int expYearInt = int.parse(expYear);
          if (expYearInt < 100) {
            expYearInt = expYearInt <= 50 ? 2000 + expYearInt : 1900 + expYearInt;
          }
          globalVars.expirayDate = '$expYearInt-$expMonth-$expDay';
          
          globalVars.gender=data['ocrData']['sex'];
          globalVars.bloodGroup="-";
          globalVars.registrationNumber="-";
          setState(() {
            globalVars.showPersonalNumber=true;
            _LoadImageForeignPassport=true; // ✅ Show foreign passport image

          });

        }

      }
      if(responseMap['success']==false){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"${responseMap['"errorName']} : ${responseMap['message']['en']}":"${responseMap['"errorName']} :${responseMap['message']['ar']}"),backgroundColor: Colors.red));
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

      }



    } else {
      print('Raw response: ${response.body}');
      setState(() {
        isloading=false;
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
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? jsonDecode(response.body)['message']['en']
                : jsonDecode(response.body)['message']['ar'],
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isloading=false;
      });
    }
  }

  void documentProcessingPassport_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final client = createHttpClient();
    setState(() {
      isloading = true;
    });
    final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document/process";
    final response = await client.post(
      Uri.parse(apiUrl),
      headers: {
        "content-type": "application/json",
        'Authorization':   "Bearer ${globalVars.ekycTokenID}"
      },
    );

    print("API Response: ${response.body}");

    if (response.statusCode == 200) {
      setState(() {
        isloading=false;
      });
      final Map<String, dynamic> responseMap = json.decode(response.body);
      print("Parsed Result: $responseMap");
      // Top-level fields
      print("Success: ${responseMap['success']}");

      // Message
      print("Message (EN): ${responseMap['message']['en']}");
      print("Message (AR): ${responseMap['message']['ar']}");


      // Data object
      final data = responseMap['data'];
      /*!=null ?responseMap['data']: null;
      final datahaya =data['ocrData']!=null ?data['ocrData'] : null;
      print("ocrData");
      print(datahaya);
      final dataali =data['visual']!=null ?data['visual'] : null;
      print("visual");
      print(dataali);*/


      if(responseMap['success']==true){
        if(data['status']=="working"){
          // ✅ Document processing successful - set flags
          setState(() {
            _documentProcessingSuccess = true;
            _lastValidatedNationalNo = nationalNo.text; // Store the validated national number
          });
          print("✅ Passport processing successful for National No: ${nationalNo.text}");
          
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?" ${responseMap['message']['en']}":"${responseMap['message']['ar']}"),backgroundColor: Colors.green));
          
          // ✅ Combine givenNames and surname for full name
          String givenNames = data['ocrData']['givenNames'] ?? "";
          String surname = data['ocrData']['surname'] ?? "";
          String fullName = givenNames.isNotEmpty && surname.isNotEmpty 
              ? "$givenNames $surname" 
              : (givenNames.isNotEmpty ? givenNames : surname);
          passportNo.text=data['ocrData']['nationalNumber'];

          globalVars.fullNameAr=fullName;
          globalVars.fullNameEn = fullName;
          globalVars.natinalityNumber=data['ocrData']['nationalNumber'] ?? data['ocrData']['userPersonalNumber'] ?? "";
          globalVars.cardNumber=data['ocrData']['documentNumber'];
          
          // ✅ Handle date parsing - dates come as {year, month, day}
          var dobData = data['ocrData']['dateOfBirth'];
          String year = dobData['year'].toString().padLeft(2, '0');
          String month = dobData['month'].toString().padLeft(2, '0');
          String day = dobData['day'].toString().padLeft(2, '0');
          
          // ✅ Convert 2-digit year to full year (e.g., 01 -> 2001, 30 -> 2030)
          int yearInt = int.parse(year);
          if (yearInt < 100) {
            // Assume years 00-30 are 2000-2030, years 31-99 are 1931-1999
            yearInt = yearInt <= 30 ? 2000 + yearInt : 1900 + yearInt;
          }
          globalVars.birthdate = '$yearInt-$month-$day';
          
          // ✅ Handle expiration date
          var expData = data['ocrData']['expirationDate'];
          String expYear = expData['year'].toString().padLeft(2, '0');
          String expMonth = expData['month'].toString().padLeft(2, '0');
          String expDay = expData['day'].toString().padLeft(2, '0');
          
          // ✅ Convert 2-digit year to full year for expiration
          int expYearInt = int.parse(expYear);
          if (expYearInt < 100) {
            // Expiration dates are typically in the future
            expYearInt = expYearInt <= 50 ? 2000 + expYearInt : 1900 + expYearInt;
          }
          globalVars.expirayDate = '$expYearInt-$expMonth-$expDay';
          
          globalVars.gender=data['ocrData']['sex'];
          globalVars.bloodGroup="-";
          globalVars.registrationNumber="-";
          setState(() {
            // ✅ Show the appropriate passport image based on what was captured
            if (globalVars.capturedBase64MRZ.isNotEmpty) {
              _loadImageJordanianPassport=true; // Jordanian passport
            }
            if (globalVars.capturedBase64Temporary.isNotEmpty) {
              _LoadImageTemporaryPassport=true; // Temporary passport
            }
          });


        }

      }
      if(responseMap['success']==false){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"${responseMap['"errorName']} : ${responseMap['message']['en']}":"${responseMap['"errorName']} :${responseMap['message']['ar']}"),backgroundColor: Colors.red));
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

      }



    } else {
      print('Raw response: ${response.body}');
      setState(() {
        isloading=false;
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
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? jsonDecode(response.body)['message']['en']
                : jsonDecode(response.body)['message']['ar'],
          ),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        isloading=false;
      });
    }
  }
  // Reset all document-related data
  void _resetAllDocumentData() {
    print("Resetting all document data...");
    globalVars.SanadPassed=false;

    // Reset display flags
    _loadImageFrontID = false;
    _loadImageBackID = false;
    _loadImageJordanianPassport = false;
    _LoadImageForeignPassport = false;
    _LoadImageTemporaryPassport = false;

    // Reset base64 display strings
    IDFront = '';
    IDBack = '';
    JordanianPassport = '';
    ForeignPassport = '';
    TemporaryPassport = '';

    // Reset camera states
    _isCameraInitialized = false;
    _isCameraInitializedMRZ = false;
    _isCameraInitializedTemporary = false;
    _isCameraInitializedForeign = false;

    // Reset processing states
    _isProcessing = false;
    _isProcessingMRZ = false;
    _isProcessingTemporary = false;
    _isProcessingForeign = false;

    // Reset border colors
    _borderColor = Colors.white;
    _borderColorMRZ = Colors.white;
    _borderColorTemporary = Colors.white;
    _borderColorForeign = Colors.white;

    // Reset step tracking
    _currentStep = 0;
    _currentStepMRZ = 0;
    _currentStepTemporary = 0;
    _currentStepForeign = 0;

    // Reset tip indices
    _tipIndex = 0;
    _tipIndexMRZ = 0;
    _tipIndexTemporary = 0;
    _tipIndexForeign = 0;

    // Reset side tracking
    _frontSideCaptured = false;
    _isShowingWrongSideWarning = false;
    _bothSidesCaptured = false;

    // Reset quality indicators
    _lastBlurScore = 0.0;
    _qualityMessage = "";
    _isImageQualityGood = false;
    _remainingTime = _timeoutDuration;

    // Reset verification flags
    sanadVerificationFailed = false;
    showScanToggle = false;

    // Reset loading state
    isloading = false;

    // Clear captured data
    _capturedPaths.clear();
    _capturedBase64.clear();
    _capturedImagePath = "";
    _capturedImagePathTemporary = "";
    _capturedImagePathForeign = "";

    // Clear info storage
    _idInfo.clear();
    _passportInfo.clear();
    _passportInfoTemporary.clear();
    _passportInfoForeign.clear();

    // Clear global variables
    globalVars.capturedPaths.clear();
    globalVars.capturedBase64.clear();
    globalVars.capturedPathsMRZ = "";
    globalVars.capturedBase64MRZ = "";
    globalVars.capturedPathsTemporary = "";
    globalVars.capturedBase64Temporary = "";
    globalVars.capturedPathsForeign = "";
    globalVars.capturedBase64Foreign = "";
    globalVars.isValidIdentification = false;
    globalVars.ekycTokenID="";
    globalVars.sessionUid="";
    globalVars.isValidPassportIdentification = false;
    globalVars.isValidTemporaryIdentification = false;
    globalVars.isValidForeignIdentification = false;

    globalVars.tackID = false;
    globalVars.tackJordanPassport = false;
    globalVars.tackForeign = false;
    globalVars.tackTemporary = false;
    globalVars.showPersonalNumber = false;
    globalVars.sanadValidation = false;

    // Clear user data
    globalVars.fullNameAr = "";
    globalVars.fullNameEn = "";
    globalVars.natinalityNumber = "";
    globalVars.cardNumber = "";
    globalVars.birthdate = "";
    globalVars.expirayDate = "";
    globalVars.gender = "";
    globalVars.bloodGroup = "";
    globalVars.registrationNumber = "";

    // Cancel all timers
    _frameProcessor?.cancel();
    _frameProcessorMRZ?.cancel();
    _frameProcessorTemporary?.cancel();
    _frameProcessorForeign?.cancel();
    _borderColorTimer?.cancel();
    _borderColorTimerMRZ?.cancel();
    _borderColorTimerTemporary?.cancel();
    _borderColorTimerForeign?.cancel();
    _stepTimeout?.cancel();
    _countdownTimer?.cancel();
    _tipRotationTimer?.cancel();
    _wrongSideWarningTimer?.cancel();
    _autoCloseTimer?.cancel();

    print("All document data reset successfully!");
  }

  /////////////////////////END Shanderma EKYC///////////////////////////////////
  

  void initState() {
    super.initState();
    
    // Reset all data when screen is loaded
    _resetAllDocumentData();

    generateEkycToken();

    _initDeepLinkListener(); // Add this line

    if(Permessions.contains('05.02.03.02.01')==true){
      setState(() {
        DarakRole=true;
      });

    }

    print(role);
    if(marketType=="GSM"){

      _data= generateItems(  2) ;
    }else{
      _data= generateItems(  1) ;
    }

    print(marketType);
    print(packageCode);
    LookUP_Pool();
    MSISDN_General();



    getPostPaidGSMMSISDNListBloc =BlocProvider.of<GetPostPaidGSMMSISDNListBloc>(context);
    postValidateSubscriberBlock = BlocProvider.of<PostValidateSubscriberBlock>(context);
    getPostPaidGSMMSISDNListBloc.add(GetPostPaidGSMMSISDNListFetchEvent());
  }
  void clearNationalNo (){
    // ✅ DON'T clear national number - keep user's input through all flows
    // setState(() {
    //   nationalNo.text='';
    // });
  }
  void clearPassportNo (){
    setState(() {
      passportNo.text='';
    });
  }

  void clearMsisdn(){
    setState(() {
      msisdnNumber.text='';
    });
    setState(() {
      msisdn=null;
    });
  }



  ////////////////////////////////////////////////////////////// New 2 May 2023 ///////////////////////////////////////////////////////////////
  void _Level () async{
    print(msisdn);
    setState(() {
      MSISDN_Level=true;
      MSISDN_Normal=false;
      // ✅ Don't clear msisdn - user is just switching modes
      Level_Select=null;
      // ✅ Don't clear national number - keep user's input
      // nationalNo.text='';
      passportNo.text='';
    });
    if(MSISDN_Level==true ){
      setState(() {
        msisdnNumber.text='';
        // ✅ Don't clear msisdn variable itself
        emptyMSISDN=false;
        emptyNationalNo=false;
        emptyPassportNo=false;
        passportNo.text='';

      });
    }

  }

  void _Normal () async{
    print(msisdn);

    setState(() {

      MSISDN_Level=false;
      MSISDN_Normal=true;

      Level_Select=null;
      // ✅ Don't clear national number - keep user's input
      // nationalNo.text='';
      passportNo.text='';
    });
    if(MSISDN_Normal==true ){
      setState(() {
        Level_Select=null;
        msisdnNumber.text='';
        // ✅ Don't clear msisdn variable itself - just the text field
        emptyMSISDN=false;
        emptyNationalNo=false;
        emptyPassportNo=false;
        passportNo.text="";


      });
    }
  }

  void LookUP_Pool() async{
    print("/Lookup/MSISDN_LEVEL");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lookup/MSISDN_LEVEL';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },

    );
    int statusCode = response.statusCode;
    var data = response.request;


    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');

    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);


      if (result["status"] == 0) {
        setState(() {
          MSISDN_Pool = result["data"];
        });
        for (var i = 0; i < result['data'].length; i++) {

          Pool_Value.add(result['data'][i]['value'].toString());


        }
        print("/********************************************************************/");
        print(MSISDN_Pool );
        print(Pool_Value);


        print("/********************************************************************/");

      } else {
        // showAlertDialogERROR(context, result["messageAr"], result["message"]);
        setState(() {
          //isLoadingReconnect = false;
        });
      }



      return result;
    } else {
      // showAlertDialogOtherERROR(context,statusCode, statusCode);

    }

  }

  void MSISDN_Level_Select() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL+'/Postpaid/mobile/level/list/${selectedPool_key}';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },

    );
    int statusCode = response.statusCode;
    var data = response.request;


    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');

    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);


      if (result["status"] == 0) {
        print(New_MSISDN_Pool);
        setState(() {
          New_MSISDN_Pool = result["data"];
          // ✅ Auto-select first MSISDN from level pool by default if list is not empty
          if (New_MSISDN_Pool != null && New_MSISDN_Pool.isNotEmpty) {
            msisdn = New_MSISDN_Pool[0];
            print("✅ Auto-selected first MSISDN from level: $msisdn");
          }
        });
        /* for (var i = 0; i < result['data'].length; i++) {

          Pool_Value.add(result['data'][i]['value'].toString());


        }*/
        print("/********************************************************************/");
        print(New_MSISDN_Pool );



        print("/********************************************************************/");

      } else {
        // showAlertDialogERROR(context, result["messageAr"], result["message"]);
        setState(() {
          //isLoadingReconnect = false;
        });
      }



      return result;
    } else {
      // showAlertDialogOtherERROR(context,statusCode, statusCode);

    }

  }

  void MSISDN_General() async{
    print("/Postpaid/mobile/list-------");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL+'/Postpaid/mobile/list';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },

    );
    int statusCode = response.statusCode;
    var data = response.request;
    print(data);


    if (statusCode == 401) {
      print('401  error ');

    }
    if (statusCode == 200) {
      print("yes...");
      var result = json.decode(response.body);
      print("result");
      print(result);

      if (result["status"] == 0) {
        print(result);
        setState(() {
          mobile_list = result["data"];
          // ✅ Auto-select first MSISDN by default if list is not empty
          if (mobile_list != null && mobile_list.isNotEmpty && msisdn == null) {
            msisdn = mobile_list[0];
            print("✅ Auto-selected first MSISDN: $msisdn");
          }
        });
        /* for (var i = 0; i < result['data'].length; i++) {

          Pool_Value.add(result['data'][i]['value'].toString());


        }*/
        print("/****************************mobile_list****************************************/");
        print(mobile_list );
        print("/********************************************************************/");

      } else {
        showAlertDialogError(context, result["messageAr"], result["message"]);
        setState(() {
          //isLoadingReconnect = false;
        });
      }



      return result;
    } else {
      showAlertDialogError(context,statusCode.toString(), statusCode.toString());

    }

  }


  showAlertDialogError(BuildContext context,arabicMessage,englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text("alert.tryAgain".tr().toString() ,
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(EasyLocalization.of(context).locale == Locale("en", "US") ? englishMessage : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
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

  // 🎯 Barcode Validation Function
  bool _validateBarcode(String barcode) {
    setState(() {
      emptyBarcode = barcode.trim().isEmpty;
      errorBarcodeFormat = false;
      barcodeErrorMessage = '';
    });

    if (emptyBarcode) {
      setState(() {
        barcodeErrorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Barcode is required"
            : "الباركود مطلوب";
      });
      return false;
    }

    // Must be exactly 10 digits
    if (barcode.length != 10) {
      setState(() {
        errorBarcodeFormat = true;
        barcodeErrorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Barcode must be exactly 10 digits"
            : "يجب أن يكون الباركود 10 أرقام بالضبط";
      });
      return false;
    }

    // Must contain only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(barcode)) {
      setState(() {
        errorBarcodeFormat = true;
        barcodeErrorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Barcode must contain only numbers"
            : "يجب أن يحتوي الباركود على أرقام فقط";
      });
      return false;
    }

    // Must start with 8 or 1
    String firstDigit = barcode[0];
    if (firstDigit != '8' && firstDigit != '1') {
      setState(() {
        errorBarcodeFormat = true;
        barcodeErrorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Barcode must start with 8 or 1"
            : "يجب أن يبدأ الباركود بـ 8 أو 1";
      });
      return false;
    }

    print("✅ Barcode validation passed: $barcode");
    return true;
  }

  /// Upload barcode as manual text entry
  uploadBarcodeManual_API(String barcodeText) async {
    setState(() {
      isloading = true;
      print("📤 uploadBarcodeManual_API - Loading started: isloading = $isloading");
    });
    final client = createHttpClient();
    try {
      final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/barcode";
      final url = Uri.parse(apiUrl);

      final response = await client.post(
        url,
        headers: {
          "content-type": "application/json",
          'Authorization': "Bearer ${globalVars.ekycTokenID}"
        },
        body: jsonEncode({
          "code": barcodeText
        }),
      );

      print('Barcode Manual Upload - Status Code: ${response.statusCode}');
      print('Barcode Manual Upload - Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("✅ Barcode submitted successfully");
        setState(() {
          isloading = false;
          print("✅ uploadBarcodeManual_API - Success, loading stopped: isloading = $isloading");
          passportNo.text=barcodeText;
          barcodeUploaded = true;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Barcode submitted successfully"
                  : "تم إرسال الباركود بنجاح",
            ),
            backgroundColor: Colors.green,
          ),
        );
        
        return jsonDecode(response.body);
      } else {
        print('Barcode Manual Upload Error: ${response.statusCode}');
        final Map<String, dynamic> jsonData = jsonDecode(response.body);
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? jsonData['message']['en'] ?? "Barcode submission failed"
                  : jsonData['message']['ar'] ?? "فشل إرسال الباركود",
            ),
            backgroundColor: Colors.red,
          ),
        );

        setState(() {
          isloading = false;
        });
        return null;
      }
    } catch (e) {
      setState(() {
        isloading = false;
      });
      print('Barcode Manual Upload Exception: $e');
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Failed to upload barcode. Please try again."
                : "فشل تحميل الباركود. يرجى المحاولة مرة أخرى.",
          ),
          backgroundColor: Colors.red,
        ),
      );
      return null;
    } finally {
      client.close();
    }
  }

  // 🎯 Barcode Section Widget for Foreign Passport
  Widget buildBarcode_Section() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with required indicator
          Row(
            children: [
              Icon(Icons.qr_code_scanner, color: Color(0xFF4f2565), size: 24),
              SizedBox(width: 8),
              Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Barcode Information"
                    : "معلومات الباركود",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4f2565),
                ),
              ),
              Text(
                " *",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.red,
                ),
              ),
            ],
          ),
          SizedBox(height: 15),
          
          // Barcode text field
          TextField(
            controller: barcodeController,
            keyboardType: TextInputType.number,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            decoration: InputDecoration(
              labelText: EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Enter Barcode (10 digits)"
                  : "أدخل الباركود (10 أرقام)",
              hintText: EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Must start with 8 or 1..."
                  : "يجب أن يبدأ بـ 8 أو 1...",
              helperText: EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Format: Starts with 8 or 1, exactly 10 digits"
                  : "الصيغة: يبدأ بـ 8 أو 1، 10 أرقام بالضبط",
              helperStyle: TextStyle(fontSize: 11, color: Color(0xFF636f7b)),
              border: OutlineInputBorder(),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (emptyBarcode || errorBarcodeFormat) ? Colors.red : Color(0xFFD1D7E0),
                  width: 1.0,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: (emptyBarcode || errorBarcodeFormat) ? Colors.red : Color(0xFF4f2565),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red, width: 1.0),
              ),
              errorText: barcodeErrorMessage.isNotEmpty ? barcodeErrorMessage : null,
              suffixIcon: capturedBarcodeImage != null
                  ? Icon(Icons.check_circle, color: Colors.green)
                  : IconButton(
                      icon: Icon(Icons.qr_code_scanner, color: Color(0xFF4f2565)),
                      onPressed: () {
                        // Open camera for barcode scanning
                        _openBarcodeCamera();
                      },
                      tooltip: EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Scan Barcode"
                          : "مسح الباركود",
                    ),
            ),
            onChanged: (value) {
              // Clear error when user starts typing
              if (errorBarcodeFormat || emptyBarcode) {
                setState(() {
                  errorBarcodeFormat = false;
                  emptyBarcode = false;
                  barcodeErrorMessage = '';
                });
              }
            },
          ),
          SizedBox(height: 15),
          
          // 🎯 Info message: Barcode will be submitted with Next button
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF4f2565).withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Color(0xFF4f2565).withOpacity(0.3), width: 1),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, color: Color(0xFF4f2565), size: 20),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? "Enter the barcode manually or scan it using the camera icon. The barcode will be submitted when you click the Next button."
                        : "أدخل الباركود يدويًا أو امسحه باستخدام أيقونة الكاميرا. سيتم إرسال الباركود عند النقر على زر التالي.",
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 📷 Barcode Camera Functions
  Future<void> _openBarcodeCamera() async {
    print("📷 Opening barcode camera...");
    
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.back,
        orElse: () => cameras.first,
      );

      _controllerBarcode = CameraController(backCamera, ResolutionPreset.high);
      await _controllerBarcode.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraInitializedBarcode = true;
        _barcodeDetectionAttempts = 0;
        _detectedBarcodeValue = '';
      });

      // Start auto-capture frame processing
      _startBarcodeFrameProcessing();

      // Show camera overlay
      _showBarcodeCameraOverlay();

    } catch (e) {
      print("❌ Error initializing barcode camera: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Failed to access camera. Please try again."
                : "فشل الوصول إلى الكاميرا. يرجى المحاولة مرة أخرى.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showBarcodeCameraOverlay() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return WillPopScope(
          onWillPop: () async {
            await _closeBarcodeCamera();
            return true;
          },
          child: Scaffold(
            backgroundColor: Colors.black,
            body: Stack(
              children: [
                // Camera preview
                if (_isCameraInitializedBarcode && _controllerBarcode != null)
                  Positioned.fill(
                    child: CameraPreview(_controllerBarcode),
                  ),
                
                // Overlay with frame
                Positioned.fill(
                  child: CustomPaint(
                    painter: BarcodeOverlayPainter(),
                  ),
                ),
                
                // Top bar with instructions
                Positioned(
                  top: 50,
                  left: 20,
                  right: 20,
                  child: Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.qr_code_scanner, color: Colors.white, size: 20),
                            SizedBox(width: 8),
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? "Scanning for barcode..."
                                  : "جاري مسح الباركود...",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "Position the barcode in the frame"
                              : "ضع الباركود في الإطار",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 4),
                        Text(
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "Auto-capture enabled"
                              : "التقاط تلقائي مفعّل",
                          style: TextStyle(
                            color: Colors.greenAccent,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
                
                // Bottom buttons
                Positioned(
                  bottom: 40,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      // Cancel button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.red,
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                        ),
                        onPressed: () async {
                          await _closeBarcodeCamera();
                          Navigator.of(dialogContext).pop();
                        },
                        child: Icon(Icons.close, color: Colors.white, size: 30),
                      ),
                      // Capture button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Color(0xFF4f2565),
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(25),
                        ),
                        onPressed: _isProcessingBarcode
                            ? null
                            : () async {
                                await _captureBarcodeImage(dialogContext);
                              },
                        child: _isProcessingBarcode
                            ? CircularProgressIndicator(color: Colors.white)
                            : Icon(Icons.camera, color: Colors.white, size: 35),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _captureBarcodeImage(BuildContext dialogContext) async {
    if (_controllerBarcode == null || !_controllerBarcode.value.isInitialized) {
      print("❌ Camera not initialized");
      return;
    }
    
    if (_controllerBarcode.value.isTakingPicture) {
      print("⚠️ Camera is already taking a picture");
      return;
    }

    setState(() {
      _isProcessingBarcode = true;
    });

    try {
      // Create temporary file path for the captured image
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = p.join(
        tempDir.path,
        'barcode_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );
      
      // Take picture with file path
      await _controllerBarcode.takePicture(filePath);
      final File capturedFile = File(filePath);
      
      // Verify file exists
      if (!capturedFile.existsSync()) {
        print("❌ Barcode image file doesn't exist at: $filePath");
        setState(() {
          _isProcessingBarcode = false;
        });
        return;
      }
      
      print("📷 Barcode image captured: ${capturedFile.path}");

      setState(() {
        capturedBarcodeImage = capturedFile;
        _isProcessingBarcode = false;
      });

      // Close camera
      await _closeBarcodeCamera();
      Navigator.of(dialogContext).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Barcode image captured successfully"
                : "تم التقاط صورة الباركود بنجاح",
          ),
          backgroundColor: Colors.green,
        ),
      );

    } catch (e) {
      print("❌ Error capturing barcode image: $e");
      setState(() {
        _isProcessingBarcode = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Failed to capture image. Please try again."
                : "فشل التقاط الصورة. يرجى المحاولة مرة أخرى.",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _closeBarcodeCamera() async {
    // Cancel frame processor
    _barcodeFrameProcessor?.cancel();
    _barcodeFrameProcessor = null;
    
    if (_controllerBarcode != null) {
      await _controllerBarcode.dispose();
      _controllerBarcode = null;
    }
    
    if (mounted) {
      setState(() {
        _isCameraInitializedBarcode = false;
      });
    }
  }

  // 🔄 Start frame processing for barcode auto-detection
  void _startBarcodeFrameProcessing() {
    _barcodeFrameProcessor = Timer.periodic(Duration(milliseconds: 1000), (_) {
      _processBarcodeFrame();
    });
  }

  // 📸 Process frame to detect barcode automatically
  Future<void> _processBarcodeFrame() async {
    if (_controllerBarcode == null ||
        !_controllerBarcode.value.isInitialized ||
        _controllerBarcode.value.isTakingPicture ||
        _isProcessingBarcode ||
        _detectedBarcodeValue.isNotEmpty) {
      return;
    }

    _isProcessingBarcode = true;
    _barcodeDetectionAttempts++;

    try {
      // Create temporary file path for frame capture
      final Directory tempDir = await getTemporaryDirectory();
      final String filePath = p.join(
        tempDir.path,
        'barcode_scan_${DateTime.now().millisecondsSinceEpoch}.jpg',
      );

      // Capture frame
      await _controllerBarcode.takePicture(filePath);
      final File imageFile = File(filePath);

      if (!imageFile.existsSync()) {
        print("❌ Frame doesn't exist");
        _isProcessingBarcode = false;
        return;
      }

      // Process with ML Kit Barcode Scanner
      final inputImage = InputImage.fromFilePath(filePath);
      final barcodeScanner = BarcodeScanner();
      final List<Barcode> barcodes = await barcodeScanner.processImage(inputImage);

      // Close scanner
      await barcodeScanner.close();

      // Delete temporary file
      try {
        await imageFile.delete();
      } catch (e) {
        print("⚠️ Failed to delete temp file: $e");
      }

      // Check if barcode detected
      if (barcodes.isNotEmpty) {
        for (Barcode barcode in barcodes) {
          String rawValue = barcode.rawValue;
          
          if (rawValue != null && rawValue.isNotEmpty) {
            print("✅ Barcode detected: $rawValue");
            
            // Validate barcode format (10 digits starting with 8 or 1)
            if (_validateBarcodeFormat(rawValue)) {
              print("✅ Valid barcode format detected: $rawValue");
              
              // Store detected barcode
              setState(() {
                _detectedBarcodeValue = rawValue;
                barcodeController.text = rawValue;
              });
              
              // Stop frame processing
              _barcodeFrameProcessor?.cancel();
              
              // Show success feedback and auto-close camera
              await _onBarcodeDetected(rawValue);
              
              break;
            } else {
              print("⚠️ Detected barcode doesn't match format: $rawValue");
            }
          }
        }
      } else {
        print("🔍 Scanning... (Attempt $_barcodeDetectionAttempts)");
      }

    } catch (e) {
      print("❌ Barcode scanning error: $e");
    } finally {
      _isProcessingBarcode = false;
    }
  }

  // ✔️ Validate barcode format (10 digits, starts with 8 or 1)
  bool _validateBarcodeFormat(String barcode) {
    // Must be exactly 10 digits
    if (barcode.length != 10) return false;
    
    // Must contain only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(barcode)) return false;
    
    // Must start with 8 or 1
    String firstDigit = barcode[0];
    return (firstDigit == '8' || firstDigit == '1');
  }

  // ✅ Handle successful barcode detection
  Future<void> _onBarcodeDetected(String barcodeValue) async {
    print("🎯 Barcode auto-detected: $barcodeValue");
    print("📤 Submitting barcode to API immediately...");
    
    // Close camera first
    await _closeBarcodeCamera();
    Navigator.of(context).pop();
    
    // Submit barcode to API immediately using existing function
    await uploadBarcodeManual_API(barcodeValue);
    
    // Note: uploadBarcodeManual_API already handles:
    // - setState for isloading
    // - Setting barcodeUploaded flag
    // - Showing success/error messages
  }

  Widget buildSelect_MSISDN_Level() {
    return  Expanded(
        child:  Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            RichText(
              text: TextSpan(
                  text: "Postpaid.MSISDN_Level".tr().toString(),
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
                    )
                  ]
              ),

            ),
            SizedBox(height: 10),

            Container(

                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptyBuilding == true
                        ? Color(0xFFB10000)
                        : Color(0xFFD1D7E0),
                  ),
                ),
                child: DropdownButtonHideUnderline(

                  child: ButtonTheme(

                    alignedDropdown: true,
                    child: DropdownButton<String>(

                      hint: Text(
                        "Personal_Info_Edit.select_an_option".tr().toString()+"00",
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
                      value: Level_Select,
                      onChanged: (String newValue) {
                        setState(() {
                          Level_Select = newValue;
                          getKeySelectedReseller(newValue);
                          New_MSISDN_Pool = [];



                        });
                        print("hhhhhhhkkkkk");
                        print(msisdnNumber.text);
                        print(msisdn);

                        print(Pool_Value);

                      },

                      items: Pool_Value.map((valueItem) {
                        return DropdownMenuItem<String>(
                          value: valueItem,
                          child: Text(valueItem.toString()),
                        );
                      }).toList(),
                    ),
                  ),
                )),
            SizedBox(height: 25),
          ],
        ));

  }


  void getKeySelectedReseller(val){
    for (var i = 0; i < MSISDN_Pool.length; i++) {
      if(MSISDN_Pool[i]['value'].contains(val)){
        setState(() {
          selectedPool_key=MSISDN_Pool[i]['key'];
        });
        MSISDN_Level_Select();
        print( selectedPool_key);
      }else{
        continue;
      }
    }
  }

  ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
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


  showAlertDialogSucssesJordanian(BuildContext context, arabicMessage, englishMessage, msisdn, Username,Password,Price) {
    AlertDialog alert = AlertDialog(
      title: Text("Postpaid.OperationSuccess".tr().toString()),
      content: SingleChildScrollView(
        child: ListBody(
          children:  <Widget>[
            marketType=="GSM"?
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+ msisdn.toString()
                  : "رقم الخط"+" : "+" "+ msisdn.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+ msisdnNumber.text
                  : "رقم الخط"+" : "+" "+ msisdnNumber.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Price"+" : "+" "+Price.toString()
                  : "السعر"+" : "+" "+Price.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),),


      actions: <Widget>[
        TextButton(
          onPressed: () {
            // clearNationalNo();
            //clearMsisdn();
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
            print("✅ Dialog Next button pressed - Navigating to Jordanian Customer Information");
            print("Data: userName=$userName, price=$price, sendOTP=$sendOTP");
            
            FocusScope.of(context).unfocus();
            Navigator.pop(context); // Close dialog

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JordainianCustomerInformation(
                    role: role,
                    outDoorUserName: outDoorUserName,
                    Permessions: Permessions,
                    msisdn: marketType == "GSM" ? (msisdn ?? msisdnNumber.text) : msisdnNumber.text,
                    nationalNumber: nationalNo.text,
                    passportNumber: null,
                    userName: userName,
                    password: password,
                    marketType: marketType,
                    packageCode: packageCode,
                    sendOtp: sendOTP,
                    showSimCard: showSimCard,
                    price: price, // Use the state variable 'price' not dialog parameter 'Price'
                    isArmy: isArmy,
                    showCommitmentList: showCommitmentList
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
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialogSucssesNoneJordanian(BuildContext context, arabicMessage, englishMessage, msisdn, Username,Password,Price) {
    AlertDialog alert = AlertDialog(
      title: Text("Postpaid.OperationSuccess".tr().toString()),
      content: SingleChildScrollView(
        child: ListBody(
          children:  <Widget>[
            marketType=="GSM"?
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+ msisdn.toString()
                  : "رقم الخط"+" : "+" "+ msisdn.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+ msisdnNumber.text
                  : "رقم الخط"+" : "+" "+ msisdnNumber.text,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),

            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Price"+" : "+" "+Price.toString()
                  : "السعر"+" : "+" "+Price.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            // clearPassportNo();
            //  clearMsisdn();
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
            print("✅ Dialog Next button pressed - Navigating to Non-Jordanian Customer Information");
            print("Data: userName=$userName, price=$price, sendOTP=$sendOTP");
            
            Navigator.pop(context); // Close dialog

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NonJordainianCustomerInformation(
                    role: role,
                    outDoorUserName: outDoorUserName,
                    Permessions: Permessions,
                    msisdn: marketType == "GSM" ? (msisdn ?? msisdnNumber.text) : msisdnNumber.text,
                    nationalNumber: null,
                    passportNumber: passportNo.text,
                    userName: userName,
                    password: password,
                    marketType: marketType,
                    packageCode: packageCode,
                    sendOtp: sendOTP,
                    showSimCard: showSimCard,
                    price: price, // Use the state variable 'price' not dialog parameter 'Price'
                    isArmy: isArmy,
                    showCommitmentList: showCommitmentList
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
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget nationalNumber() {
    return BlocListener<PostValidateSubscriberBlock, PostValidateSubscriberState>(
      listener: (context, state) {
        if (state is PostValidateSubscriberErrorState) {
          setState(() {
            checkNationalDisabled = false;
            isloading = false;
            _isCallingFromNextButton = false; // ✅ Reset flag on error
          });
          showAlertDialogError(context, state.arabicMessage, state.englishMessage);
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
            isloading = false;
            _isCallingFromNextButton = false; // ✅ Reset flag on error
          });
        }
        if (state is PostValidateSubscriberSuccessState) {
          setState(() {
            checkNationalDisabled = false;
            userName = state.Username;
            password = state.Password;
            sendOTP = state.sendOTP;
            showSimCard = state.showSimCard;
            price = state.Price.toString();
            isArmy = state.isArmy;
            showCommitmentList = state.showCommitmentList;
            isloading = false;
          });

          print('sendOTP ${state.sendOTP}');
          
          // ✅ Always show dialog first (whether from Check button or Next button)
          if (_isCallingFromNextButton) {
            setState(() {
              _isCallingFromNextButton = false; // Reset flag
            });
            print("✅ API success from Next button - Showing confirmation dialog");
          }
          
          // Show dialog for both Check and Next button
          showAlertDialogSucssesJordanian(context, state.arabicMessage, state.englishMessage, msisdn, state.Username, state.Password, state.Price);
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
              buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
              onTap: () {
                FocusScope.of(context).unfocus();
              },
              // ✅ Detect changes in national number and reset validation if changed
              onChanged: (value) {
                // If national number changed from the last validated one, reset everything
                if (_lastValidatedNationalNo.isNotEmpty && value != _lastValidatedNationalNo) {
                  setState(() {
                    globalVars.sanadValidation = false;
                    _documentProcessingSuccess = false;
                    _loadImageFrontID = false;
                    _loadImageBackID = false;
                    _loadImageJordanianPassport = false;
                    IDFront = '';
                    IDBack = '';
                    JordanianPassport = '';
                    globalVars.capturedBase64.clear();
                    globalVars.capturedBase64MRZ = '';
                    showScanToggle = false;
                  });
                  print("✅ National number changed from $_lastValidatedNationalNo to $value - Reset validation state");
                }
              },
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Color(0xff11120e)),
              decoration: InputDecoration(
                enabledBorder: emptyNationalNo == true || errorNationalNo == true
                    ? const OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                )
                    : const OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                ),
                border: const OutlineInputBorder(),
                focusedBorder: OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
              ? ReusableRequiredText(text: "Postpaid.nationalNo_required".tr().toString())
              : Container(),
          errorNationalNo == true
              ? ReusableRequiredText(
              text: EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "National Number must be 10 digits and start with 2 or 9"
                  : "يجب أن يتكون الرقم الوطني من 10 أرقام ويبدأ بـ 2 أو 9")
              : Container(),
          SizedBox(height: 10),

          // ✅ Show Check button only when Sanad validation hasn't been triggered yet
          if (!globalVars.sanadValidation)
            Container(
              height: 48,
              width: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: TextButton(
                onPressed: checkNationalDisabled ? null : () async {
                  if (marketType == "GSM") {
                    if (isTextJordianian == false) {
                      setState(() {
                        emptyMSISDN = msisdn == null;
                      });
                    } else {
                      setState(() {
                        emptyMSISDNNumber = msisdnNumber.text.isEmpty;
                      });
                    }
                  } else if (marketType == "PRETOPOST") {
                    setState(() {
                      emptyMSISDNNumber = msisdnNumber.text.isEmpty;
                    });
                  }

                  setState(() {
                    emptyNationalNo = nationalNo.text.isEmpty;
                    errorNationalNo = false;
                  });

                  if (nationalNo.text.isNotEmpty && (msisdn != null || msisdnNumber.text.isNotEmpty)) {
                    if (nationalNo.text.length != 10) {
                      setState(() {
                        errorNationalNo = true;
                      });
                      return;
                    }

                    String firstDigit = nationalNo.text[0];
                    if (firstDigit != '2' && firstDigit != '9') {
                      setState(() {
                        errorNationalNo = true;
                      });
                      return;
                    }

                    await _trySanadVerification();
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                child: Text(
                  "Postpaid.check".tr().toString(),
                  style: TextStyle(color: Colors.white, letterSpacing: 0, fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),

          // ✅ Show warning message and document type toggle after Sanad fails
          if (globalVars.sanadValidation) ...[
            SizedBox(height: 15),
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                border: Border.all(color: Colors.orange, width: 1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange, size: 20),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Sanad verification unavailable. Please scan your ID or Passport."
                          : "التحقق عبر سند غير متاح. يرجى مسح بطاقتك أو جواز سفرك.",
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 15),

            // Document Type Selection Toggle (similar to CheckIdentity)
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Select Document Type"
                  : "اختر نوع المستند",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),

            // Toggle buttons for ID vs Jordanian Passport
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: globalVars.tackID ? Color(0xFF4f2565) : Colors.white,
                      onPrimary: globalVars.tackID ? Colors.white : Color(0xff636f7b),
                      side: BorderSide(
                        color: globalVars.tackID ? Color(0xFF4f2565) : Color(0xffe4e5eb),
                        width: 1,
                      ),
                      minimumSize: Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      setState(() {
                        globalVars.tackID = true;
                        globalVars.tackJordanPassport = false;
                      });
                      _initializeCamera(); // Open ID camera
                    },
                    child: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Scan ID"
                          : "مسح الهوية",
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      primary: globalVars.tackJordanPassport ? Color(0xFF4f2565) : Colors.white,
                      onPrimary: globalVars.tackJordanPassport ? Colors.white : Color(0xff636f7b),
                      side: BorderSide(
                        color: globalVars.tackJordanPassport ? Color(0xFF4f2565) : Color(0xffe4e5eb),
                        width: 1,
                      ),
                      minimumSize: Size(double.infinity, 45),
                    ),
                    onPressed: () {
                      setState(() {
                        globalVars.tackJordanPassport = true;
                        globalVars.tackID = false;
                      });
                      _initializeCameraMRZ(); // Open Passport camera
                    },
                    child: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Jordanian Passport"
                          : "جواز سفر أردني",
                    ),
                  ),
                ),
              ],
            ),
            
            // ✅ Display captured/processed ID images
            if (globalVars.tackID && (globalVars.capturedBase64.isNotEmpty || _loadImageFrontID || _loadImageBackID)) ...[
              SizedBox(height: 15),
              buildFronID_Image(),
              SizedBox(height: 10),
              buildBackID_Image(),
            ],
            
            // ✅ Display captured/processed Jordanian Passport image
            if (globalVars.tackJordanPassport && (globalVars.capturedBase64MRZ.isNotEmpty || _loadImageJordanianPassport)) ...[
              SizedBox(height: 15),
              buildJordanianPassport_Image(),
            ],
          ],
          
          // ✅ Show Next button after successful document processing
          if (_documentProcessingSuccess && globalVars.sanadValidation) ...[
            SizedBox(height: 20),
            Container(
              height: 48,
              width: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: TextButton(
                onPressed: checkNationalDisabled ? null : () async {
                  // ✅ Call PostValidateSubscriber API before navigation
                  print("✅ Calling PostValidateSubscriber API for Jordanian customer");
                  
                  setState(() {
                    checkNationalDisabled = true;
                    isloading = true;
                    _isCallingFromNextButton = true; // ✅ Set flag to indicate API call is from Next button
                  });
                  
                  // Dispatch the PostValidateSubscriber event
                  postValidateSubscriberBlock.add(PostValidateSubscriberPressed(
                    marketType: marketType,
                    isJordanian: true, // This is a Jordanian customer
                    nationalNo: nationalNo.text,
                    passportNo: "",
                    packageCode: packageCode,
                    msisdn: marketType == "GSM" ? (msisdn ?? msisdnNumber.text) : msisdnNumber.text,
                    isRental: false,
                    device5GType: "0",
                    buildingCode: "null",
                    serialNumber: "",
                    itemCode: "null"
                  ));
                  
                  // The navigation will happen in the BLoC listener when API succeeds
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Next"
                          : "التالي",
                      style: TextStyle(color: Colors.white, letterSpacing: 0, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ],

          SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget passportNumber() {
    return BlocListener<PostValidateSubscriberBlock, PostValidateSubscriberState>(
      listener: (context, state) {
        if (state is PostValidateSubscriberLoadingState) {
          setState(() {
            checkPassportDisabled = true;
            isloading = true;
          });
        }
        if (state is PostValidateSubscriberErrorState) {
          setState(() {
            checkPassportDisabled = false;
            isloading = false;
          });
          showAlertDialogError(context, state.arabicMessage, state.englishMessage);
        }
        if (state is PostValidateSubscriberTokenErrorState) {
          UnotherizedError();
          setState(() {
            checkPassportDisabled = false;
            isloading = false;
          });
        }
        if (state is PostValidateSubscriberSuccessState) {
          setState(() {
            checkPassportDisabled = false;
            userName = state.Username;
            password = state.Password;
            sendOTP = state.sendOTP;
            showSimCard = state.showSimCard;
            price = state.Price.toString();
            isArmy = state.isArmy;
            showCommitmentList = state.showCommitmentList;
            isloading = false;
          });
          showAlertDialogSucssesNoneJordanian(context, state.arabicMessage, state.englishMessage, msisdn, state.Username, state.Password, state.Price);
          FocusScope.of(context).unfocus();
        }
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // ✅ STEP 1: Show passport type selection FIRST
          Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Select Passport Type"
                : "اختر نوع جواز السفر",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          
          // Toggle buttons for Temporary vs Foreign Passport
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: globalVars.tackTemporary ? Color(0xFF4f2565) : Colors.white,
                    onPrimary: globalVars.tackTemporary ? Colors.white : Color(0xff636f7b),
                    side: BorderSide(
                      color: globalVars.tackTemporary ? Color(0xFF4f2565) : Color(0xffe4e5eb),
                      width: 1,
                    ),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  onPressed: () async {
                    setState(() {
                      globalVars.tackTemporary = true;
                      globalVars.tackForeign = false;
                    });
                    // For Temporary Passport, directly open camera (no passport number needed)
                    // First ensure eKYC is initialized
                    if (!isEkycInitialized) {
                      await generateEkycToken();
                    }
                    if (isEkycInitialized) {
                      _initializeCameraTemporary(); // Open Temporary Passport camera
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "eKYC system not ready. Please try again."
                                : "نظام التحقق الإلكتروني غير جاهز. يرجى المحاولة مرة أخرى.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? "Temporary Passport"
                        : "جواز سفر مؤقت",
                  ),
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    primary: globalVars.tackForeign ? Color(0xFF4f2565) : Colors.white,
                    onPrimary: globalVars.tackForeign ? Colors.white : Color(0xff636f7b),
                    side: BorderSide(
                      color: globalVars.tackForeign ? Color(0xFF4f2565) : Color(0xffe4e5eb),
                      width: 1,
                    ),
                    minimumSize: Size(double.infinity, 45),
                  ),
                  onPressed: () async {
                    setState(() {
                      globalVars.tackForeign = true;
                      globalVars.tackTemporary = false;
                    });
                    // For Foreign Passport, directly open camera (no passport number needed)
                    // First ensure eKYC is initialized
                    if (!isEkycInitialized) {
                      await generateEkycToken();
                    }
                    if (isEkycInitialized) {
                      _initializeCameraForeign(); // Open Foreign Passport camera
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "eKYC system not ready. Please try again."
                                : "نظام التحقق الإلكتروني غير جاهز. يرجى المحاولة مرة أخرى.",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  child: Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? "Foreign Passport"
                        : "جواز سفر أجنبي",
                  ),
                ),
              ),
            ],
          ),
          
          SizedBox(height: 15),
          
          // ✅ Display captured/processed Foreign Passport image
          if (globalVars.capturedBase64Foreign.isNotEmpty || _LoadImageForeignPassport) ...[
            SizedBox(height: 15),
            buildForeignPassport_Image(),
            
            // 🎯 Show barcode section after foreign passport is captured
            SizedBox(height: 20),
            buildBarcode_Section(),
          ],
          
          // ✅ Display captured/processed Temporary Passport image
          if (globalVars.capturedBase64Temporary.isNotEmpty || _LoadImageTemporaryPassport) ...[
            SizedBox(height: 15),
            buildTemporaryPassport_Image(),
          ],
          
          // ✅ Show Next button after successful document processing for non-Jordanian
          if (_documentProcessingSuccess && (globalVars.tackTemporary || globalVars.tackForeign)) ...[
            SizedBox(height: 20),
            Container(
              height: 48,
              width: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: TextButton(
                onPressed: checkPassportDisabled ? null : () async {
                  // 🎯 VALIDATION: For Foreign Passport, barcode is required
                  if (globalVars.tackForeign) {
                    String barcodeText = barcodeController.text.trim();
                    
                    // Validate barcode
                    if (!_validateBarcode(barcodeText)) {
                      // Validation failed - errors are already set in _validateBarcode
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "Please enter a valid barcode before proceeding"
                                : "الرجاء إدخال باركود صالح قبل المتابعة",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Stop execution
                    }
                    
                    // 📤 Submit barcode if not already uploaded
                    if (!barcodeUploaded) {
                      print("📤 Submitting barcode: $barcodeText");
                      await uploadBarcodeManual_API(barcodeText);
                      
                      // Check if upload was successful
                      if (!barcodeUploaded) {
                        // Upload failed
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? "Failed to submit barcode. Please try again."
                                  : "فشل إرسال الباركود. يرجى المحاولة مرة أخرى.",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                        return; // Stop execution
                      }
                    }
                  }
                  
                  // ✅ Call PostValidateSubscriber API before navigation
                  print("✅ Calling PostValidateSubscriber API for Non-Jordanian customer");
                  
                  setState(() {
                    checkPassportDisabled = true;
                    isloading = true;
                  });
                  
                  // Dispatch the PostValidateSubscriber event
                  postValidateSubscriberBlock.add(PostValidateSubscriberPressed(
                    marketType: marketType,
                    isJordanian: false, // This is a Non-Jordanian customer
                    nationalNo: "",
                    passportNo: passportNo.text,
                    packageCode: packageCode,
                    msisdn: marketType == "GSM" ? (msisdn ?? msisdnNumber.text) : msisdnNumber.text,
                    isRental: false,
                    device5GType: "0",
                    buildingCode: "null",
                    serialNumber: "",
                    itemCode: "null"
                  ));
                  
                  // The dialog will be shown in the BLoC listener when API succeeds
                },
                style: TextButton.styleFrom(
                  backgroundColor: Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Next"
                          : "التالي",
                      style: TextStyle(color: Colors.white, letterSpacing: 0, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, color: Colors.white, size: 20),
                  ],
                ),
              ),
            ),
          ],
          
          SizedBox(height: 20),
        ],
      ),
    );
  }
  Widget buildMSISDNNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.msisdn".tr().toString(),
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
            controller: msisdnNumber,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            onTap: () {
              FocusScope.of(context).unfocus();
              setState(() {
                msisdn=msisdnNumber.text;
              });
            },
            onChanged:(msisdnNumber) {
              setState(() {
                msisdn=msisdnNumber;
              });
              print(msisdn);
            },
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
              const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
              ):
              const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              )
              ,
              border: const OutlineInputBorder(),

              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: clearMsisdn,
                icon: Icon(
                    Icons.close
                ),
                color: Color(0xFFA4B0C1),
              ),
              hintText: "Postpaid.enter_msisdn".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        emptyMSISDNNumber  == true
            ? ReusableRequiredText(
            text: "Postpaid.passportNo_required".tr().toString())
            : Container(),
        errorMSISDNNumber==true ?ReusableRequiredText(
            text:  EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Your MSISDN should be 10 digit and valid"
                : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
      ],
    );
  }

  Widget buildMSISDNListJordainian() {
    return  Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Permessions.contains('05.02.03.02.01')==true?  Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 175, // <-- match_parent
                height: 50, // <-- match-parent
                child:SizedBox(
                  child: ElevatedButton.icon(   // <-- ElevatedButton
                    onPressed: () {
                      _Normal();


                    },
                    style:MSISDN_Normal==true? ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary:Color(0xFF4f2565),
                      side: BorderSide(color:Color(0xFF4f2565), width: 1),
                      shadowColor: Colors.transparent,
                    ): ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color(0xff636f7b),
                      side: BorderSide(color:Color(0xffe4e5eb), width: 1),
                      shadowColor: Colors.transparent,
                    ),
                    icon: MSISDN_Normal==true?Icon(
                      Icons.check_circle,
                      size: 24.0,
                    ):Icon(
                      Icons.circle_outlined,
                      size: 24.0,
                    ),
                    label: Text("Postpaid.MSISDN_Normal".tr().toString()),
                  ),

                ),
              ),
              Spacer(),
              SizedBox(
                width: 175, // <-- match_parent
                height: 50, // <-- match-parent
                child:SizedBox(
                  child: ElevatedButton.icon(   // <-- ElevatedButton
                    onPressed: () {
                      _Level ();




                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      primary: Colors.white,
                      onPrimary: MSISDN_Level==true?Color(0xFF4f2565):Color(0xff636f7b),
                      side: BorderSide(color:MSISDN_Level==true? Color(0xFF4f2565):Color(0xffe4e5eb), width: 1),

                    ),
                    icon: MSISDN_Level==true?Icon(
                      Icons.check_circle,
                      size: 24.0,
                    ):Icon(
                      Icons.circle_outlined,
                      size: 24.0,
                    ),
                    label: Text("Postpaid.MSISDN_Level".tr().toString()),
                  ),
                ),
              ),
            ],
          ):Container(),
          Permessions.contains('05.02.03.02.01')==true? SizedBox(
            height: 15,
          ):Container(),
          Permessions.contains('05.02.03.02.01')==true?  Row(
              children:[
                MSISDN_Normal==false?
                buildSelect_MSISDN_Level():Container(),]
          ):Container(),
          Level_Select==null && MSISDN_Normal==false &&  Permessions.contains('05.02.03.02.01')==true?Container():
          Row(

              children:[
                Level_Select!=null && MSISDN_Normal==false &&  Permessions.contains('05.02.03.02.01')==true?
                RichText(
                  text: TextSpan(
                    text: "Postpaid.msisdn".tr().toString(),
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
                ): RichText(
                  text: TextSpan(
                    text: "Postpaid.msisdn".tr().toString(),
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
                Spacer(),
                marketType=="GSM"? new SlidingSwitch(
                  value: isTextJordianian,

                  width: 70,
                  onChanged: (bool value) {
                    print (value);
                    setState(() {
                      isTextJordianian = value;
                      isTextNoNJordianian=false;
                    });
                  },
                  height : 30,
                  animationDuration : const Duration(milliseconds: 400),
                  iconOff: Icons.search_outlined,
                  iconOn: Icons.text_format,
                  contentSize: 17,
                  colorOn : const Color(0xFF4f2565),
                  colorOff : const Color(0xFF4f2565),
                  background : const Color(0xffe4e5eb),
                  buttonColor : const Color(0xfff7f5f7),
                  inactiveColor : const Color(0xff636f7b),
                ):Container(),]
          ),
          SizedBox(height: 10,),


          /**************************************************Normal MSISDN Part  With Darak Role*************************************************/
          DarakRole==true && MSISDN_Normal==true&& isTextJordianian==false ?
          Container(

              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  //color: Color(0xFFB10000), red color
                  color: emptyMSISDN == true
                      ? Color(0xFFB10000)
                      : Color(0xFFD1D7E0),
                ),
              ),
              child:CustomSearchableDropDown(
                items:mobile_list,
                initialIndex: (mobile_list != null && mobile_list.isNotEmpty) ? 0 : null, // ✅ Show first item by default
                dropdownHintText: "Personal_Info_Edit.select_an_option".tr().toString() ,
                //  label:msisdn ,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(4),
                    border:null
                ),
                //com.zainsalesapp.sales
                dropDownMenuItems: mobile_list?.map((item) {
                  return item;
                })?.toList() ??
                    [],
                onChanged: (valueLevel){

                  if(valueLevel!=null)
                  {
                    msisdn=valueLevel;


                  }
                  else{
                  }
                },

              )

          ):Container(),
          DarakRole==true && MSISDN_Normal==true&& isTextJordianian==true? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      msisdn=msisdnNumber.text;
                    });

                  },
                  onChanged:(msisdnNumber) {
                    setState(() {
                      msisdn=msisdnNumber;
                    });
                    print(msisdn);
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                    ):
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                    )
                    ,
                    border: const OutlineInputBorder(),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),

              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ):Container(),
          /************************************************************************************************************************************/

          /**************************************************Level MSISDN Part  With Darak Role*************************************************/
          DarakRole==true && Level_Select!=null&& isTextJordianian==false? Container(

              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  //color: Color(0xFFB10000), red color
                  color: emptyMSISDN == true
                      ? Color(0xFFB10000)
                      : Color(0xFFD1D7E0),
                ),
              ),
              child:CustomSearchableDropDown(
                items:New_MSISDN_Pool,
                initialIndex: (New_MSISDN_Pool != null && New_MSISDN_Pool.isNotEmpty) ? 0 : null, // ✅ Show first item by default
                dropdownHintText: "Personal_Info_Edit.select_an_option".tr().toString() ,
                //  label:msisdn ,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(4),
                    border:null
                ),
                //com.zainsalesapp.sales
                dropDownMenuItems: New_MSISDN_Pool?.map((item) {
                  return item;
                })?.toList() ??
                    [],
                onChanged: (valueLevel){

                  if(valueLevel!=null)
                  {
                    msisdn=valueLevel;


                  }
                  else{
                  }
                },

              )

          ):Container(),
          DarakRole==true && Level_Select!=null&& isTextJordianian==true? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      msisdn=msisdnNumber.text;
                    });
                  },
                  onChanged:(msisdnNumber) {
                    setState(() {
                      msisdn=msisdnNumber;
                    });
                    print(msisdn);
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                    ):
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                    )
                    ,
                    border: const OutlineInputBorder(),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ):Container(),
          /************************************************************************************************************************************/

          /**************************************************Normal Without Darak Role*************************************************/
          DarakRole==false && isTextJordianian==false ?Container(

              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  //color: Color(0xFFB10000), red color
                  color: emptyMSISDN == true
                      ? Color(0xFFB10000)
                      : Color(0xFFD1D7E0),
                ),
              ),
              child:CustomSearchableDropDown(
                items:mobile_list,

                dropdownHintText: "Personal_Info_Edit.select_an_option".tr().toString() ,
                //  label:msisdn ,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(4),
                    border:null
                ),
                //com.zainsalesapp.sales
                dropDownMenuItems: mobile_list?.map((item) {
                  return item;
                })?.toList() ??
                    [],
                onChanged: (valueLevel){

                  if(valueLevel!=null)
                  {
                    msisdn=valueLevel;


                  }
                  else{
                  }
                },

              )

          ):Container(),
          DarakRole==false && isTextJordianian==true ?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      msisdn=msisdnNumber.text;
                    });
                  },
                  onChanged:(msisdnNumber) {
                    setState(() {
                      msisdn=msisdnNumber;
                    });
                    print(msisdn);
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                    ):
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                    )
                    ,
                    border: const OutlineInputBorder(),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ):Container(),

          /************************************************************************************************************************************/




          SizedBox(height: 10,),
          emptyMSISDN  == true
              ? ReusableRequiredText(
              text: "Postpaid.nationalNo_required".tr().toString())
              : Container(),
        ],
      ),
    );
  }

  Widget buildMSISDNListNonJordainian() {
    return  Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          /***************************************************New 10-May-2023*****************************************************/

          Permessions.contains('05.02.03.02.01')==true? Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 175, // <-- match_parent
                height: 50, // <-- match-parent
                child:SizedBox(
                  child: ElevatedButton.icon(   // <-- ElevatedButton
                    onPressed: () {
                      _Normal();
                    },
                    style:MSISDN_Normal==true? ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary:Color(0xFF4f2565),
                      side: BorderSide(color:Color(0xFF4f2565), width: 1),
                      shadowColor: Colors.transparent,
                    ): ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Color(0xff636f7b),
                      side: BorderSide(color:Color(0xffe4e5eb), width: 1),
                      shadowColor: Colors.transparent,
                    ),
                    icon: MSISDN_Normal==true?Icon(
                      Icons.check_circle,
                      size: 24.0,
                    ):Icon(
                      Icons.circle_outlined,
                      size: 24.0,
                    ),
                    label: Text("Postpaid.MSISDN_Normal".tr().toString()),
                  ),

                ),
              ),
              Spacer(),
              SizedBox(
                width: 175, // <-- match_parent
                height: 50, // <-- match-parent
                child:SizedBox(
                  child: ElevatedButton.icon(   // <-- ElevatedButton
                    onPressed: () {
                      _Level ();
                    },
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.transparent,
                      primary: Colors.white,
                      onPrimary: MSISDN_Level==true?Color(0xFF4f2565):Color(0xff636f7b),
                      side: BorderSide(color:MSISDN_Level==true? Color(0xFF4f2565):Color(0xffe4e5eb), width: 1),

                    ),
                    icon: MSISDN_Level==true?Icon(
                      Icons.check_circle,
                      size: 24.0,
                    ):Icon(
                      Icons.circle_outlined,
                      size: 24.0,
                    ),
                    label: Text("Postpaid.MSISDN_Level".tr().toString()),
                  ),
                ),
              ),
            ],
          ):Container(),
          Permessions.contains('05.02.03.02.01')==true? SizedBox(
            height: 15,
          ):Container(),
          Permessions.contains('05.02.03.02.01')==true ?Row(
              children:[
                MSISDN_Normal==false?
                buildSelect_MSISDN_Level():Container(),]
          ):Container(),
          Level_Select==null && MSISDN_Normal==false &&  Permessions.contains('05.02.03.02.01')==true?Container():
          Row(
              children:[
                Level_Select!=null && MSISDN_Normal==false &&  Permessions.contains('05.02.03.02.01')==true?
                RichText(
                  text: TextSpan(
                    text: "Postpaid.msisdn".tr().toString(),
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
                ):  RichText(
                  text: TextSpan(
                    text: "Postpaid.msisdn".tr().toString(),
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
                Spacer(),
                marketType=="GSM"?  SlidingSwitch(
                  value: isTextNoNJordianian,
                  width: 70,
                  onChanged: (bool value) {
                    setState(() {

                      isTextNoNJordianian = value;
                      isTextJordianian=false;
                    });
                  },
                  height : 30,
                  animationDuration : const Duration(milliseconds: 400),
                  iconOff: Icons.search_outlined,
                  iconOn: Icons.text_format,
                  contentSize: 17,
                  colorOn : const Color(0xFF4f2565),
                  colorOff : const Color(0xFF4f2565),
                  background : const Color(0xffe4e5eb),
                  buttonColor : const Color(0xfff7f5f7),
                  inactiveColor : const Color(0xff636f7b),
                ):Container(),]
          ),
          SizedBox(height: 10,),


          /**************************************************Normal MSISDN Part  With Darak Role*************************************************/
          DarakRole==true && MSISDN_Normal==true&& isTextNoNJordianian==false ?Container(

              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  //color: Color(0xFFB10000), red color
                  color: emptyMSISDN == true
                      ? Color(0xFFB10000)
                      : Color(0xFFD1D7E0),
                ),
              ),
              child:CustomSearchableDropDown(
                items:mobile_list,
                initialIndex: (mobile_list != null && mobile_list.isNotEmpty) ? 0 : null, // ✅ Show first item by default
                dropdownHintText: "Personal_Info_Edit.select_an_option".tr().toString() ,
                //  label:msisdn ,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(4),
                    border:null
                ),
                //com.zainsalesapp.sales
                dropDownMenuItems: mobile_list?.map((item) {
                  return item;
                })?.toList() ??
                    [],
                onChanged: (valueLevel){

                  if(valueLevel!=null)
                  {
                    msisdn=valueLevel;


                  }
                  else{
                  }
                },

              )

          ):Container(),
          DarakRole==true && MSISDN_Normal==true&& isTextNoNJordianian==true?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      msisdn=msisdnNumber.text;
                    });
                  },

                  onChanged:(msisdnNumber) {
                    setState(() {
                      msisdn=msisdnNumber;
                    });
                    print(msisdn);
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                    ):
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                    )
                    ,
                    border: const OutlineInputBorder(),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ):Container(),
          /************************************************************************************************************************************/

          /**************************************************Level MSISDN Part  With Darak Role*************************************************/
          DarakRole==true && Level_Select!=null&& isTextNoNJordianian==false?       Container(

              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  //color: Color(0xFFB10000), red color
                  color: emptyMSISDN == true
                      ? Color(0xFFB10000)
                      : Color(0xFFD1D7E0),
                ),
              ),
              child:CustomSearchableDropDown(
                items:New_MSISDN_Pool,
                initialIndex: (New_MSISDN_Pool != null && New_MSISDN_Pool.isNotEmpty) ? 0 : null, // ✅ Show first item by default
                dropdownHintText: "Personal_Info_Edit.select_an_option".tr().toString() ,
                //  label:msisdn ,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(4),
                    border:null
                ),
                //com.zainsalesapp.sales
                dropDownMenuItems: New_MSISDN_Pool?.map((item) {
                  return item;
                })?.toList() ??
                    [],
                onChanged: (valueLevel){

                  if(valueLevel!=null)
                  {
                    msisdn=valueLevel;


                  }
                  else{
                  }
                },

              )

          ):Container(),
          DarakRole==true && Level_Select!=null&& isTextNoNJordianian==true? Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      msisdn=msisdnNumber.text;
                    });

                  },
                  onChanged:(msisdnNumber) {
                    setState(() {
                      msisdn=msisdnNumber;
                    });
                    print(msisdn);
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                    ):
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                    )
                    ,
                    border: const OutlineInputBorder(),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ):Container(),
          /************************************************************************************************************************************/

          /**************************************************Normal Without Darak Role*************************************************/
          DarakRole==false && isTextNoNJordianian==false ?Container(

              height: 48,
              decoration: BoxDecoration(
                color: Colors.white,

                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  //color: Color(0xFFB10000), red color
                  color: emptyMSISDN == true
                      ? Color(0xFFB10000)
                      : Color(0xFFD1D7E0),
                ),
              ),
              child:CustomSearchableDropDown(
                items:mobile_list,
                initialIndex: (mobile_list != null && mobile_list.isNotEmpty) ? 0 : null, // ✅ Show first item by default
                dropdownHintText: "Personal_Info_Edit.select_an_option".tr().toString() ,
                //  label:msisdn ,
                decoration: BoxDecoration(

                    borderRadius: BorderRadius.circular(4),
                    border:null
                ),
                //com.zainsalesapp.sales
                dropDownMenuItems: mobile_list?.map((item) {
                  return item;
                })?.toList() ??
                    [],
                onChanged: (valueLevel){

                  if(valueLevel!=null)
                  {
                    msisdn=valueLevel;


                  }
                  else{
                  }
                },

              )

          ):Container(),
          DarakRole==false && isTextNoNJordianian==true ?Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                    setState(() {
                      msisdn=msisdnNumber.text;
                    });

                  },
                  onChanged:(msisdnNumber) {
                    setState(() {
                      msisdn=msisdnNumber;
                    });
                    print(msisdn);
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                    ):
                    const OutlineInputBorder(
                      // width: 0.0 produces a thin "hairline" border
                      borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                    )
                    ,
                    border: const OutlineInputBorder(),

                    focusedBorder: OutlineInputBorder(
                      borderSide:
                      const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    suffixIcon: IconButton(
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ):Container(),

          /************************************************************************************************************************************/



          SizedBox(height: 10,),
          emptyMSISDN  == true
              ? ReusableRequiredText(
              text: "Postpaid.nationalNo_required".tr().toString())
              : Container(),


        ],
      ),
    );
  }




  Widget _buildListPanel(){return ExpansionPanelList(
    expansionCallback: (int index, bool isExpanded){
      if (isExpanded == false) {
        for (final item in _data) {
          if (_data[index] != item) {
            setState(() {
              item.isExpanded = true;
              // ✅ Don't clear msisdn and msisdnNumber - keep user selections
              // ✅ Don't clear national number - keep user's input
              // nationalNo.text='';
              passportNo.text='';
              isTextJordianian=false;
              isTextNoNJordianian=false;

            });
          }
          setState(() {
            item.isExpanded = false;
            // ✅ Don't clear msisdn and msisdnNumber - keep user selections
            // ✅ Don't clear national number - keep user's input
            // nationalNo.text='';
            passportNo.text='';
            isTextJordianian=false;
            isTextNoNJordianian=false;

          });
        }
      }
      setState(() {
        _data[index].isExpanded = !isExpanded;
        isTextJordianian=false;
        isTextNoNJordianian=false;

      });

      _data[index].headerValue=='Jordanian' || _data[index].headerValue=='أردني'?setState(() {
        isJordanian = true;
        isTextJordianian=false;
        Level_Select=null;

      }):setState(() {
        isJordanian = false;
        isTextNoNJordianian=false;
        Level_Select=null;

      });
    },
    children:

    _data.map<ExpansionPanel>((Item item){
      return  isJordanian == true ?
      ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded){
            return ListTile(
              title: Text(item.headerValue,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff11120e),
                    fontWeight: FontWeight.normal),),
            );
          },
          body: ListTile(
            title:Column(
              children: [
                marketType=="GSM"? buildMSISDNListJordainian(): buildMSISDNNumber(),

                SizedBox(height: 10,),
                Level_Select==null && MSISDN_Normal==false &&  Permessions.contains('05.02.03.02.01')==true?Container():  nationalNumber()
              ],
            )

            ,
            //subtitle: Text('To delete this panel '),
            /* trailing: Icon(Icons.delete),
              onTap: (){
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              },*/
          ),

          isExpanded: item.isExpanded
      ):

      ExpansionPanel(
          headerBuilder: (BuildContext context, bool isExpanded){
            return ListTile(
              title: Text(item.headerValue,
                style: TextStyle(
                    fontSize: 16,
                    color: Color(0xff11120e),
                    fontWeight: FontWeight.normal),),
            );
          },
          body: ListTile(
              title:
              Column(
                children: [
                  marketType=="GSM"? buildMSISDNListNonJordainian(): buildMSISDNNumber(),

                  SizedBox(height: 10,),
                  Level_Select==null && MSISDN_Normal==false && Permessions.contains('05.02.03.02.01')==true?Container(): passportNumber(),

                ],
              )


            //subtitle: Text('To delete this panel '),
            /* trailing: Icon(Icons.delete),
              onTap: (){
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              },*/
          ),

          isExpanded: item.isExpanded
      );

    }).toList(),

  );


  }

  @override
  Widget build(BuildContext context) {
    // Handle ID Scanner Camera
    if (_isCameraInitialized) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller),
          _buildOverlayFrame(),
          _buildTipText(),
          _buildQualityIndicator(),
          _buildSideIndicator(),
          _buildRestartButton(),

          // Cancel button
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 70),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () async {
                      await _stopCameraAndCleanup();
                      globalVars.capturedPaths.clear();
                      globalVars.capturedBase64.clear();
                      globalVars.isValidIdentification = false;
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Cancel",
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                        SizedBox(width: 8),
                        Icon(Icons.close, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Handle MRZ Passport Camera
    if (_isCameraInitializedMRZ) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controllerMRZ),
          _buildOverlayFrameMRZ(),
          _buildStepTextMRZ(),
          _buildTipTextMRZ(),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 70),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _stopCameraAndCleanupMRZ();
                      globalVars.isValidPassportIdentification = false;
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(width: 8),
                        Icon(Icons.close, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Handle Temporary Passport Camera
    if (_isCameraInitializedTemporary) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controllerTemporary),
          _buildOverlayFrameTemporary(),
          _buildStepTextTemporary(),
          _buildTipTextTemporary(),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 70),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _stopCameraAndCleanupTemporary();
                      globalVars.isValidTemporaryIdentification = false;
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(width: 8),
                        Icon(Icons.close, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Handle Foreign Passport Camera
    if (_isCameraInitializedForeign) {
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controllerForeign),
          _buildOverlayFrameForeign(),
          _buildStepTextForeign(),
          _buildTipTextForeign(),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 70),
              child: Center(
                child: SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () {
                      _stopCameraAndCleanupForeign();
                      globalVars.isValidForeignIdentification = false;
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.all(12),
                      backgroundColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                        side: BorderSide(color: Colors.white, width: 1),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Cancel", style: TextStyle(color: Colors.white, fontSize: 18)),
                        SizedBox(width: 8),
                        Icon(Icons.close, color: Colors.white),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // Default: Show the form UI
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Stack(
        children: <Widget>[
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              centerTitle: false,
              title: Text(
                "Select_Nationality.select_nationality".tr().toString(),
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: ListView(
              padding: EdgeInsets.only(top: 10),
              children: <Widget>[
                _buildListPanel(),
              ],
            ),
          ),
          // Loading overlay
          if (isloading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5),
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF4f2565),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}



class Item{
  String expandedValue;
  String headerValue;
  bool isExpanded;

  Item({this.expandedValue,this.headerValue,this.isExpanded=false});
}

List<Item> generateItems(int numberOfItem){
  return List.generate(numberOfItem, (index) {
    return Item(

      headerValue:  index == 0?"Select_Nationality.jordanian".tr().toString(): "Select_Nationality.non_jordanian".tr().toString(),
      // expandedValue: 'this is item number $index'
    );
  });
}

// 🎯 Barcode Overlay Painter for camera scan
class BarcodeOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.6)
      ..style = PaintingStyle.fill;

    // Define barcode scan area (rectangular)
    final holeWidth = size.width * 0.85;
    final holeHeight = size.height * 0.2; // Narrower rectangle for barcode
    final holeLeft = (size.width - holeWidth) / 2;
    final holeTop = (size.height - holeHeight) / 2;

    final outerRect = Rect.fromLTWH(0, 0, size.width, size.height);
    final holeRect = Rect.fromLTWH(holeLeft, holeTop, holeWidth, holeHeight);
    final holeRRect = RRect.fromRectAndRadius(holeRect, Radius.circular(12));

    // Draw dimmed overlay with a transparent hole
    final path = Path()
      ..addRect(outerRect)
      ..addRRect(holeRRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    // Draw white border around the hole
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3;

    canvas.drawRRect(holeRRect, borderPaint);
    
    // Draw corner accents
    final accentPaint = Paint()
      ..color = Color(0xFF4f2565)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round;
    
    final cornerLength = 30.0;
    
    // Top-left corner
    canvas.drawLine(
      Offset(holeLeft, holeTop + cornerLength),
      Offset(holeLeft, holeTop),
      accentPaint,
    );
    canvas.drawLine(
      Offset(holeLeft, holeTop),
      Offset(holeLeft + cornerLength, holeTop),
      accentPaint,
    );
    
    // Top-right corner
    canvas.drawLine(
      Offset(holeLeft + holeWidth - cornerLength, holeTop),
      Offset(holeLeft + holeWidth, holeTop),
      accentPaint,
    );
    canvas.drawLine(
      Offset(holeLeft + holeWidth, holeTop),
      Offset(holeLeft + holeWidth, holeTop + cornerLength),
      accentPaint,
    );
    
    // Bottom-left corner
    canvas.drawLine(
      Offset(holeLeft, holeTop + holeHeight - cornerLength),
      Offset(holeLeft, holeTop + holeHeight),
      accentPaint,
    );
    canvas.drawLine(
      Offset(holeLeft, holeTop + holeHeight),
      Offset(holeLeft + cornerLength, holeTop + holeHeight),
      accentPaint,
    );
    
    // Bottom-right corner
    canvas.drawLine(
      Offset(holeLeft + holeWidth - cornerLength, holeTop + holeHeight),
      Offset(holeLeft + holeWidth, holeTop + holeHeight),
      accentPaint,
    );
    canvas.drawLine(
      Offset(holeLeft + holeWidth, holeTop + holeHeight - cornerLength),
      Offset(holeLeft + holeWidth, holeTop + holeHeight),
      accentPaint,
    );
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
