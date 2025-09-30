import 'dart:convert';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;


import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class checkIdentity extends StatefulWidget {
  final Function onStepChanged;
  checkIdentity({ this.onStepChanged});
  @override
  _checkIdentityState createState() => _checkIdentityState();
}

class _checkIdentityState extends State<checkIdentity> {
  bool isLoading =false;
  bool _isForeign=true;
  bool _isTemporary=false;

  bool _ID= false;
  bool _jordanianPassport= false;


  bool _loadImageFrontID = false;
  bool _loadImageBackID = false;
  bool _loadImageJordanianPassport = false;
  bool _LoadImageForeignPassport = false;
  bool _LoadImageTemporaryPassport = false;


  String IDFront='';
  String IDBack='';
  String JordanianPassport='';
  String ForeignPassport='';
  String TemporaryPassport='';

  String redirectUrl;
  StreamSubscription _sub;
  BuildContext _dialogContext;


  String selected = "";
  bool isJordanianSelected = true;
  bool isNonJordanianSelected = false;

  TextEditingController _sanadNationalNumber = TextEditingController();
  TextEditingController _sanadPassportNumber = TextEditingController();
  TextEditingController _personalNumber = TextEditingController();

  bool emptyPersonal=false;
  final border = OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(5),)
  );



  /*----> The following for camera ID */
  CameraController _controller;
  bool _isCameraInitialized = false;
  int _currentStep = 0;
  final TextRecognizer _textRecognizer = TextRecognizer();
  Timer _frameProcessor;
  bool _isProcessing = false;
  List<String> _capturedPaths = [];
  // Add a new list to hold base64 strings
  List<String> _capturedBase64 = [];

  // Add a border color state variable
  Color _borderColor = Colors.white;

  // Add a timer for changing border color back to white
  Timer _borderColorTimer;

  // Store extracted ID information
  Map<String, String> _idInfo = {};

  // Define validation patterns for Jordanian ID
  final RegExp _nationalIdPattern = RegExp(r'\d{10}');
  final RegExp _namePattern = RegExp(r'[A-Z]+<<[A-Z]+<[A-Z]+<[A-Z]+');
  final RegExp _datePattern = RegExp(r'\d{2}/\d{2}/\d{4}');
  final RegExp _expiryPattern = RegExp(r'Expiry.+\d{2}/\d{2}/\d{4}');
  final RegExp _idNumberPattern = RegExp(r'ID no\.: [A-Z0-9]+');

  final List<String> _steps = [
    "Place the front side of the ID in the frame",
    "Hold still...",
    "Place the back side of the ID in the frame",
    "Hold still..."
  ];

  final List<String> _tips = [
    "Use a plain background",
    "Avoid glares and reflections",
    "Keep the ID within the frame",
    "Make sure the photo is clear"
  ];

  int _tipIndex = 0;

  /*----> End variable for camera ID*/

  /*----> The following for camera Passport */
  CameraController _controllerMRZ;
  bool _isCameraInitializedMRZ = false;
  int _currentStepMRZ = 0;
  final TextRecognizer _textRecognizerMRZ = TextRecognizer();
  Timer _frameProcessorMRZ;
  bool _isProcessingMRZ = false;
  String _capturedImagePath;
  String _capturedImagePathBase64;

  // Add a border color state variable
  Color _borderColorMRZ = Colors.white;

  // Add a timer for changing border color back to white
  Timer _borderColorTimerMRZ;

  // Store extracted passport information
  Map<String, String> _passportInfo = {};

  // Define validation patterns for passport MRZ (Machine Readable Zone)
  // First line of MRZ is typically 44 characters starting with P<
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

  int _tipIndexMRZ = 0;
  /*----> End variable for camera Passport*/

  @override
  void initState() {
    if(globalVars.nationality==true){
      setState(() {
        isJordanianSelected = true;
        isNonJordanianSelected = false;

      });
    }
    if(globalVars.nationality==false){
      setState(() {
        isJordanianSelected = false;
        isNonJordanianSelected = true;

      });
    }
    _initDeepLinkListener();
    setState(() {
      _capturedPaths = [];
      _capturedBase64 = [];
      _capturedImagePath = '';
      _capturedImagePathBase64='';
      _ID= false;
      _jordanianPassport= false;
      isJordanianSelected = true;
      isNonJordanianSelected = false;
    });
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
    _sub.cancel();

    /*----> The following for camera */
    _controller?.dispose();
    _textRecognizer.close();
    _frameProcessor?.cancel();
    _borderColorTimer?.cancel(); // Cancel border color timer


    _controllerMRZ?.dispose();
    _textRecognizerMRZ.close();
    _frameProcessorMRZ?.cancel();
    _borderColorTimerMRZ?.cancel(); // Cancel border color timer
    /*----> End camera */
    super.dispose();
  }


  /*----> The following for camera */
  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controller = CameraController(backCamera, ResolutionPreset.high);
    await _controller.initialize();
    setState(() => _isCameraInitialized = true);
    _startFrameProcessing();
  }

  void _startTipRotation() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
    });
  }

  void _startFrameProcessing() {
    // Cancel any existing timer first
    _frameProcessor?.cancel();
    _frameProcessor = Timer.periodic(Duration(milliseconds: 1500), (_) {
      _processFrame();
    });
  }
// Reset scanner state when returning from results
  void _resetScannerState() {
    setState(() {
      _currentStep = 0;
      _borderColor = Colors.white;
      _idInfo.clear();
      // _capturedPaths = [];
      // _capturedBase64= [];
      // _capturedPaths.clear();
      // _capturedBase64.clear();
      _isProcessing = false;
    });

    // Restart frame processing
    _startFrameProcessing();
  }
  // Method to show successful validation with green border
  void _showSuccessfulValidation() {
    // Cancel any existing timer
    _borderColorTimer?.cancel();

    setState(() {
      _borderColor = Colors.green;
    });

    // Set timer to change border back to white after 1.5 seconds
    _borderColorTimer = Timer(Duration(milliseconds: 1500), () {
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

      // Using the old way with path parameter
      await _controller.takePicture(filePath);
      final File imageFile = File(filePath);

      if (!imageFile.existsSync()) {
        print("Image file doesn't exist at: $filePath");
        return;
      }
      // Convert image file to Base64
      final bytes = await imageFile.readAsBytes();
      final base64String = base64Encode(bytes);

      final inputImage = InputImage.fromFilePath(filePath);
      final recognizedText = await _textRecognizer.processImage(inputImage);

      bool isValidId = false;

      // Check if front side or back side based on current step
      if (_currentStep == 0) {
        // Front side validation
        isValidId = _validateFrontSide(recognizedText.text);
      } else if (_currentStep == 2) {
        // Back side validation
        isValidId = _validateBackSide(recognizedText.text);
      }

      if (isValidId) {
        _capturedPaths.add(filePath);
        _capturedBase64.add(base64String);  // Save base64 string


        // Show green border for successful validation
        _showSuccessfulValidation();

        if (mounted) {
          setState(() {
            _currentStep += 2; // skip "hold still" steps
          });
        }

        if (_currentStep >= _steps.length) {
          _frameProcessor?.cancel();
          // _navigateToResultScreen();
          bool isValid = _idInfo.length >= 3; // At least 3 fields extracted

          showDialog(
            context: context,
            builder: (BuildContext context) {
              _dialogContext = context; // 👈 Save the dialog context
              return AlertDialog(
                title: Text("Verification", textAlign: TextAlign.center),
                content: Container(
                  width: double.infinity,
                  height: 200,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isValid ? Colors.green[100] : Colors.red[100],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Icon(
                        isValid ? Icons.check_circle : Icons.error,
                        color: isValid ? Colors.green[700] : Colors.red[700],
                        size: 48,
                      ),
                      SizedBox(height: 8),
                      Text(
                        isValid ? "ID Verified Successfully" : "Incomplete ID Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: isValid ? Colors.green[700] : Colors.red[700],
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        isValid
                            ? "All required information has been extracted and verified."
                            : "Some information could not be extracted. Please try scanning again.",
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      _resetScannerState();
                      setState(() {
                        _isCameraInitialized=true;
                      });
                      Navigator.of(context).pop(); // Optional: close here too
                    },
                    child: Text(
                      "Retalk",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ekycColors.primary),
                    ),

                  ),
                  TextButton(
                    onPressed: () {
                      //  _resetScannerState();
                      setState(() {
                        _isCameraInitialized=false;
                      });
                      Navigator.of(context).pop(); // Optional: close here too
                    },
                    child: Text(
                      "Approved",
                      textAlign: TextAlign.center,
                      style: TextStyle(color: ekycColors.primary),
                    ),

                  ),
                ],
              );
            },
          );

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

    // Search for specific patterns in Jordanian ID front side
    bool hasNationalId = _extractAndStore(text, _nationalIdPattern, 'nationalId');
    bool hasName = _extractAndStore(text, RegExp(r'Name:.+'), 'name');
    bool hasDob = _extractAndStore(text, RegExp(r'\d{2}/\d{2}/\d{4}'), 'dateOfBirth');
    bool hasGender = text.contains('F') || text.contains('M');

    // For Jordanian ID card front, we need at least 3 of these elements
    int matchCount = [hasNationalId, hasName, hasDob, hasGender].where((match) => match).length;

    return matchCount >= 2; // At least 2 fields must be detected for front side
  }

  bool _validateBackSide(String text) {
    print("Validating back side text: $text");

    // Search for specific patterns in Jordanian ID back side
    bool hasExpiry = _extractAndStore(text, _expiryPattern, 'expiry');
    bool hasIdNumber = _extractAndStore(text, _idNumberPattern, 'idNumber');
    bool hasMrz = text.contains('JOR') && text.contains('<<<');

    // For Jordanian ID card back, we need at least 2 of these elements
    int matchCount = [hasExpiry, hasIdNumber, hasMrz].where((match) => match).length;

    return matchCount >= 1; // At least 1 field must be detected for back side
  }

  bool _extractAndStore(String text, RegExp pattern, String key) {
    final match = pattern.firstMatch(text);
    if (match != null) {
      _idInfo[key] = match.group(0) ?? '';
      return true;
    }
    return false;
  }

  void _navigateToResultScreen() {
    // Navigate to a results screen with the extracted information
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IDResultScreen(
          idInfo: _idInfo,
          imagePaths: _capturedPaths,
        ),
      ),
    );
  }


  Widget _buildOverlayFrame() {
    return Container(
      color: Colors.black.withOpacity(0.0), // dim entire screen
      child: CustomPaint(
        painter: ScannerOverlayPainter(),
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
  /*----> End for camera */



  /*----> The following for camera Passport */
  Future<void> _initializeCameraMRZ() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controllerMRZ = CameraController(backCamera, ResolutionPreset.high);
    await _controllerMRZ.initialize();
    setState(() => _isCameraInitializedMRZ = true);
    _startFrameProcessingMRZ();
  }

  void _startTipRotationMRZ() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _tipIndexMRZ = (_tipIndexMRZ + 1) % _tipsMRZ.length);
    });
  }

  void _startFrameProcessingMRZ() {
    // Cancel any existing timer first
    _frameProcessorMRZ?.cancel();
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
        setState(() {
          _capturedImagePath = filePath;
          _capturedImagePathBase64=base64String;
        });

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
          // For passports, MRZ is the most reliable indicator
          bool hasMRZ = _passportInfo.containsKey('mrzFirstLine') && _passportInfo.containsKey('mrzSecondLine');

          // Alternatively, we need several key passport fields
          bool hasEssentialInfo = _passportInfo.containsKey('passportNumber') &&
              (_passportInfo.containsKey('name') || (_passportInfo.containsKey('surname') && _passportInfo.containsKey('givenNames'))) &&
              _passportInfo.containsKey('dateOfBirth');

          bool isValid = hasMRZ || hasEssentialInfo;
          if (mounted) {
            // _navigateToResultScreenMRZ();
            showDialog(
              context: context,
              builder: (BuildContext context) {
                _dialogContext = context; // 👈 Save the dialog context
                return AlertDialog(
                  title: Text("Verification", textAlign: TextAlign.center),
                  content: Container(
                    width: double.infinity,
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isValid ? Colors.green[100] : Colors.red[100],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          isValid ? Icons.check_circle : Icons.error,
                          color: isValid ? Colors.green[700] : Colors.red[700],
                          size: 48,
                        ),
                        SizedBox(height: 8),
                        Text(
                          isValid ? "Passport Verified Successfully" : "Incomplete Passport Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isValid ? Colors.green[700] : Colors.red[700],
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          isValid
                              ? hasMRZ
                              ? "Machine Readable Zone (MRZ) data successfully scanned and verified."
                              : "Essential passport information has been extracted and verified."
                              : "MRZ data could not be extracted. Please try scanning again with better lighting and positioning.",
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        _resetScannerStateMRZ();
                        setState(() {
                          _isCameraInitializedMRZ=true;
                        });
                        Navigator.of(context).pop(); // Optional: close here too
                      },
                      child: Text(
                        "Retalk",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ekycColors.primary),
                      ),

                    ),
                    TextButton(
                      onPressed: () {
                        _resetScannerStateMRZ();
                        setState(() {
                          _isCameraInitializedMRZ=false;
                        });
                        Navigator.of(context).pop(); // Optional: close here too
                      },
                      child: Text(
                        "Approved",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: ekycColors.primary),
                      ),

                    ),
                  ],
                );
              },
            );
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

  void _navigateToResultScreenMRZ() async{
    // Navigate to a results screen with the extracted information
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PassportResultScreen(
          passportInfo: _passportInfo,
          imagePath: _capturedImagePath,
        ),
      ),
    );
  }
  // Reset scanner state when returning from results
  void _resetScannerStateMRZ() {
    setState(() {
      _currentStepMRZ = 0;
      _borderColorMRZ = Colors.white;
      _passportInfo.clear();
      _capturedImagePath = null;
      _isProcessingMRZ = false;
    });

    // Restart frame processing
    _startFrameProcessingMRZ();
  }
  Widget _buildOverlayFrameMRZ() {
    return Container(
      color: Colors.black.withOpacity(0.0), // dim entire screen
      child: CustomPaint(
        painter: ScannerOverlayPainterMRZ(),
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
  /*----> End for camera Passport */

  // ✅ Initialize deep link listener
  void _initDeepLinkListener() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) _handleDeepLink(initialUri);
    } on PlatformException {
      print('Failed to receive initial uri.');
    } on FormatException catch (err) {
      print('Malformed initial uri: $err');
    }

    _sub = uriLinkStream.listen((Uri uri) {
      if (uri != null) _handleDeepLink(uri);
    }, onError: (err) {
      print('Deeplink error: $err');
    });
  }

  void _handleDeepLink(Uri uri) {
    final status = uri.queryParameters['status'];
    final error = uri.queryParameters['error'];

    // 👇 Close the dialog if it's open
    if (_dialogContext != null && Navigator.canPop(_dialogContext)) {
      Navigator.of(_dialogContext).pop();
      _dialogContext = null; // Clear reference
    }

    if (error != null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );
    } else if (status == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );
    }
  }

  void sanad_API() async {
    setState(() {
      isLoading = true;
    });
    final apiUrl = "https://dsc.jo.zain.com/eKYCStg/api/lines/sanad/digitalId/${_sanadNationalNumber.text}";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "content-type": "application/json",
        "X-API-KEY": "7c4a509c-a205-4cbc-9061-c95415f3deb8"
      },
    );
    //9971010867
//37375383-f46b-41d4-a79c-a4a4c2f8b1e4
    print("API Response: ${response.body}");
    if (response.statusCode == 200) {
      setState(() {
        isLoading=false;
      });
      final result = json.decode(response.body);
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
        }
      } else {
        /* Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => checkIdentity()),

        );*/
        //Navigator.of(context).pop();
      }
    } else {
      print('API call failed with status: ${response.statusCode}');
      setState(() {
        isLoading=false;
      });
    }
  }

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
      /*setState(() {
          globalVars.currentScreenIndex = 3;
        });*/

        if(globalVars.currentStep==4 && globalVars.currentScreen==4){
          setState(() {
            globalVars.currentScreenIndex = 3;
          });
        }
        if(globalVars.currentStep==4 && globalVars.currentScreen==3){

          setState(() {
            globalVars.currentScreenIndex = 5;
          });
        }
        return 0;
      case 5:
        setState(() {
          globalVars.currentScreenIndex = 4;
        });
        return 0;
      case 6:
        setState(() {
          globalVars.currentScreenIndex = 5;
        });
        return 0;


    // Add more cases if needed
      default:
        return 8;
    }
  }

  Widget buildSanadNumber() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Enter your national number",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(children: [
            Text(
              "Check verified Digital ID",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            SizedBox(width: 10),
            Image(
                image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/sanadIcon.png'),
                width: 25,
                height: 25),
          ],),
          SizedBox(height: 15),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 40, // Set desired height
                      child: TextField(
                        controller: _sanadNationalNumber,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16), // Adjust padding for consistency
                          border: border,
                          errorBorder: border,
                          disabledBorder: border,
                          focusedBorder: border,
                          focusedErrorBorder: border,
                        ),
                      ),
                    ),

                  ),
                  Container(
                    height: 40, // Match height of the TextField
                    alignment: Alignment.center, // Center text inside the button
                    padding: EdgeInsets.symmetric(horizontal: 26), // Adjust padding for spacing
                    decoration: BoxDecoration(
                      color: ekycColors.buttonPrimary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            _dialogContext = context; // 👈 Save the dialog context
                            return AlertDialog(
                              title: Text("Verification", textAlign: TextAlign.center),
                              content: Text(
                                "Upon continuing, you will be directed to the Sand website to verify your identity for the purpose of line authentication.",
                                textAlign: TextAlign.center,
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    sanad_API(); // Launch external auth
                                    Navigator.of(context).pop(); // Optional: close here too
                                  },
                                  child: Text(
                                    "Approved",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(color: ekycColors.primary),
                                  ),
                                ),
                              ],
                            );
                          },
                        );

                        print("Search button tapped");
                      },
                      child: Text(
                        "Check",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildSanadPassportNumber() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            "Enter your Personal number",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(children: [
            Text(
              "Check verified Digital ID",
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
            ),
            SizedBox(width: 10),
            Image(
                image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/sanadIcon.png'),
                width: 25,
                height: 25),
          ],),
          SizedBox(height: 15),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(0.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: SizedBox(
                      height: 40, // Set desired height
                      child: TextField(
                        controller: _sanadPassportNumber,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16), // Adjust padding for consistency
                          border: border,
                          errorBorder: border,
                          disabledBorder: border,
                          focusedBorder: border,
                          focusedErrorBorder: border,
                        ),
                      ),
                    ),

                  ),
                  Container(
                    height: 40, // Match height of the TextField
                    alignment: Alignment.center, // Center text inside the button
                    padding: EdgeInsets.symmetric(horizontal: 26), // Adjust padding for spacing
                    decoration: BoxDecoration(
                      color: ekycColors.buttonPrimary,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        print("Search button tapped");
                      },
                      child: Text(
                        "Check",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildFronID_Image(){
    return SizedBox(
        child: Column(
          children: [
            SizedBox(height: 35,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
              child: Text(
                "Capture your ID front side",
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
                    Column(
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
                    ),
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
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child:_capturedPaths.isNotEmpty && _capturedBase64.isNotEmpty?
                      Image.file(
                        File(_capturedPaths[0]),
                        width: 342,
                        height: 200,
                        fit: BoxFit.cover,
                      ):Image(
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
                    _capturedPaths.isNotEmpty && _capturedBase64.isNotEmpty?
                    Container():
                    Column(

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
                    ),
                  ],
                ),
              ),
            ),


          ],
        )


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
              "Capture your ID back side",
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
                  Column(
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
                  ),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: _capturedPaths.isNotEmpty && _capturedBase64.isNotEmpty?
                    Image.file(
                      File(_capturedPaths[1]),
                      width: 342,
                      height: 200,
                      fit: BoxFit.cover,
                    ):Image(
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
                  _capturedPaths.isNotEmpty && _capturedBase64.isNotEmpty?
                  Container()
                      :
                  Column(
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
                  ),
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
              "Capture your Passport",
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
                  Column(
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
                  ),
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
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child:_capturedImagePath!=null && _capturedImagePathBase64!=null?
                    Image.file(
                      File(_capturedImagePath),
                      width: 342,
                      height: 200,
                      fit: BoxFit.cover,
                    ): Image(
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
                  _capturedImagePath!=null && _capturedImagePathBase64!=null?
                  Container()
                      :
                  Column(
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
                  ),
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
          SizedBox(height: 25,),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
            child: Text(
              "Capture your Passport",
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
                  Column(
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
                  ),
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
              child: Stack(
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
                  Column(
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
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }

  Widget buildPearonalNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Enter your Personal number",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: _personalNumber,
            enabled: true,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              enabledBorder:
              emptyPersonal == true
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
              // hintText: "Postpaid.building_code".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPersonal_Image(){
    return SizedBox(
      child:  Column(
        children: [
          SizedBox(height: 25,),


          Center(
            child: GestureDetector(
              onTap: () {
                // Handle tap event to open camera
                //  pickImageCameraBackID();

              },
              child: Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8), // Set border radius
                    child: Image(
                      image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/personalNumber.png'),
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

                ],
              ),
            ),
          ),


        ],
      ),
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
              "Capture your Passport",
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
                  Column(
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
                  ),
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
              child: Stack(
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
                  Column(
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
                  ),
                ],
              ),
            ),
          ),


        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    if (_isCameraInitialized){
      return Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller),
          _buildOverlayFrame(),
          _buildStepText(),
          _buildTipText(),
          // Tip text with background

          /*  Positioned(
            bottom: 130,
            left: 20,
            right: 20,
            child: Container(
                padding: EdgeInsets.all(8),
                margin: EdgeInsets.symmetric(horizontal: 70),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0),
                  borderRadius: BorderRadius.circular(8),
                ),
                child:Center(
                  child: SizedBox(
                    width: double.infinity,
                    child:       ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child: Image(
                        image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/jordanianFrontID.png'),
                        fit: BoxFit.fill,
                        width:90,
                        height: 90,
                      ),
                    ),
                  ),
                )


            ),
          ),*/
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
                child:Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async{
                        setState(() {
                          _isCameraInitialized = false;
                          _ID=false;
                        });
                        if (_controller != null && _controller.value.isInitialized) {

                          await _controller.dispose();
                          _controller = null;
                        }
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
                        mainAxisAlignment: MainAxisAlignment.center, // Center text + icon
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
                )


            ),
          ),

        ],
      );
    }
    else if(_isCameraInitializedMRZ){
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
                child:Center(
                  child: SizedBox(
                    width: double.infinity,
                    child: TextButton(
                      onPressed: () async  {
                        setState(() {
                          _isCameraInitializedMRZ = false;
                          _jordanianPassport=false;
                        });
                        // Stop the camera
                        if (_controllerMRZ != null && _controllerMRZ.value.isInitialized) {

                          await _controllerMRZ.dispose();
                          _controllerMRZ = null;
                        }
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
                        mainAxisAlignment: MainAxisAlignment.center, // Center text + icon
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
                )


            ),
          ),
        ],
      );
    }
    else{
      return  Stack(
          children:[
            Scaffold(
              backgroundColor: Color(0xFFEBECF1),
              body: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(top: 25, bottom: 90, left: 0, right: 0),
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                        child: Text(
                          "Document Upload",
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
                                          primary: isJordanianSelected ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                          onPrimary: isJordanianSelected ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                          side: BorderSide(
                                            color: isJordanianSelected ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                            width: 1, // Border width ekycColors.backgroundBorder
                                          ),
                                          minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                        ),
                                        onPressed:  () {
                                          setState(() {
                                            globalVars.nationality=true;
                                            isJordanianSelected = true;
                                            isNonJordanianSelected = false;
                                            _sanadNationalNumber.text= "";

                                          });
                                        },
                                        child: Text("Jordanian"),
                                      ),
                                    ),
                                    SizedBox(width: 10), // Space between buttons
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: isNonJordanianSelected ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                          onPrimary: isNonJordanianSelected ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                          side: BorderSide(
                                            color: isNonJordanianSelected ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                            width: 1, // Border width ekycColors.backgroundBorder
                                          ),
                                          minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                        ),
                                        onPressed:  () {
                                          setState(() {
                                            globalVars.nationality=false;
                                            isNonJordanianSelected = true;
                                            isJordanianSelected = false;
                                            _sanadNationalNumber.text= "";

                                          });
                                        },
                                        child: Text("Non-Jordanian"),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /* isJordanianSelected?
                      Center(

                        child: Text(
                          "Please choose your preferred number from the list below",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                        ),
                      ):Container(),*/

                              isJordanianSelected? SizedBox(height: 20):  SizedBox(height: 10),
                              isJordanianSelected?buildSanadNumber():Container(),
                              SizedBox(height: 15),
                              /*___________________________________________Jordanian/Message Error When Check Sanad_____________________________*/
                              isJordanianSelected? Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                  color: ekycColors.accent,
                                  border: Border.all(
                                    color: ekycColors.accent,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min, // Prevents unnecessary width expansion
                                  mainAxisAlignment: MainAxisAlignment.center, // Aligns content in the center
                                  crossAxisAlignment: CrossAxisAlignment.center, // Aligns text & image properly
                                  children: [ // Adds spacing between image and text
                                    Flexible( // Allows text to wrap and prevent overflow
                                      child: Text(
                                        "Sorry, You don’t have a verified digital ID.\n Please upload/scan a copy of your ID or\n Passport below.",
                                        textAlign: TextAlign.center, // Aligns text properly
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        softWrap: true, // Ensures text wraps instead of overflowing
                                        overflow: TextOverflow.visible, // Allows all text to show
                                      ),
                                    ),
                                    SizedBox(width: 25),
                                    Image(
                                        image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/arrowCoolDown.png'),
                                        width: 20,
                                        height: 20),
                                  ],
                                ),
                              ):Container(),
                              /*_____________________________________________________Jordanian/Document Type____________________________________*/
                              isJordanianSelected ?  SizedBox(height: 20):Container(),
                              isJordanianSelected ? Text(
                                "Select Document Type",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                              ):Container(),
                              isJordanianSelected ? SizedBox(height: 10):Container(),
                              isJordanianSelected ? SizedBox(
                                width: double.infinity, // Ensures full width
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //for ID button
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: _ID ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                          onPrimary: _ID ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                          side: BorderSide(
                                            color: _ID ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                            width: 1, // Border width ekycColors.backgroundBorder
                                          ),
                                          minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                        ),
                                        onPressed:  () {
                                          setState(() {
                                            _ID = true;
                                            _jordanianPassport = false;
                                            _sanadNationalNumber.text= "";

                                          });
                                          _resetScannerStateMRZ();
                                          _initializeCamera();
                                          _startTipRotation();
                                        },
                                        child: Text("ID"),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    //for Jordanian Passport bbutton
                                    // Space between buttons
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: _jordanianPassport ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                          onPrimary: _jordanianPassport ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                          side: BorderSide(
                                            color: _jordanianPassport ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                            width: 1, // Border width ekycColors.backgroundBorder
                                          ),
                                          minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                        ),
                                        onPressed:  () {
                                          setState(() {
                                            _jordanianPassport = true;
                                            _ID = false;
                                            _sanadNationalNumber.text= "";

                                          });
                                          _resetScannerState();
                                          _initializeCameraMRZ();
                                          _startTipRotationMRZ();
                                        },
                                        child: Text("Jordanian Passport"),
                                      ),
                                    ),
                                  ],
                                ),
                              ):Container(),
                              isJordanianSelected && _ID ?  buildFronID_Image():Container(),
                              isJordanianSelected && _ID? buildBackID_Image():Container(),
                              isJordanianSelected && _jordanianPassport? buildJordanianPassport_Image():Container(),




                              /*________________________________________________non-Jordanian/Passport Type____________________________________*/

                              isNonJordanianSelected ? Text(
                                "Select Passport Type",
                                textAlign: TextAlign.start,
                                style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                              ):Container(),
                              isNonJordanianSelected ? SizedBox(height: 10):Container(),
                              isNonJordanianSelected ? SizedBox(
                                width: double.infinity, // Ensures full width
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    //for ID button
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: _isForeign ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                          onPrimary: _isForeign ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                          side: BorderSide(
                                            color: _isForeign ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                            width: 1, // Border width ekycColors.backgroundBorder
                                          ),
                                          minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                        ),
                                        onPressed:  () {
                                          setState(() {
                                            _isForeign = true;
                                            _isTemporary = false;
                                            _sanadPassportNumber.text= "";

                                          });
                                        },
                                        child: Text("Foreign"),
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    //for Jordanian Passport bbutton
                                    // Space between buttons
                                    Expanded(
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 0,
                                          primary: _isTemporary ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                          onPrimary: _isTemporary ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                          side: BorderSide(
                                            color: _isTemporary ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                            width: 1, // Border width ekycColors.backgroundBorder
                                          ),
                                          minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                        ),
                                        onPressed:  () {
                                          setState(() {
                                            _isTemporary = true;
                                            _isForeign = false;
                                            _sanadPassportNumber.text= "";

                                          });
                                        },
                                        child: Text("Temporary"),
                                      ),
                                    ),
                                  ],
                                ),
                              ):Container(),
                              _isForeign || _isTemporary? SizedBox(height: 20):Container(),
                              isNonJordanianSelected &&(_isForeign || _isTemporary) ? buildSanadPassportNumber():Container(),
                              /*_________________________________________non-Jordanian/Message Error When Check Sanad_________________________*/
                              isNonJordanianSelected &&(_isForeign || _isTemporary)   ? SizedBox(height: 20):Container(),
                              isNonJordanianSelected &&(_isForeign || _isTemporary) ? Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                decoration: BoxDecoration(
                                  color: ekycColors.accent,
                                  border: Border.all(
                                    color: ekycColors.accent,
                                    width: 0.5,
                                  ),
                                  borderRadius: BorderRadius.circular(5.0),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min, // Prevents unnecessary width expansion
                                  mainAxisAlignment: MainAxisAlignment.center, // Aligns content in the center
                                  crossAxisAlignment: CrossAxisAlignment.center, // Aligns text & image properly
                                  children: [ // Adds spacing between image and text
                                    Flexible( // Allows text to wrap and prevent overflow
                                      child: Text(
                                        "Sorry, You don’t have a verified Passport.\n Please upload/scan a copy of your Passport \n or Scan the personal number.",
                                        textAlign: TextAlign.center, // Aligns text properly
                                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                        softWrap: true, // Ensures text wraps instead of overflowing
                                        overflow: TextOverflow.visible, // Allows all text to show
                                      ),
                                    ),
                                    SizedBox(width: 25),
                                    Image(
                                        image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/arrowCoolDown.png'),
                                        width: 20,
                                        height: 20),
                                  ],
                                ),
                              ):Container(),
                              isNonJordanianSelected&& _isForeign?  SizedBox(height: 10):Container(),
                              isNonJordanianSelected&& _isForeign?  buildForeignPassport_Image():Container(),
                              isNonJordanianSelected&& _isForeign? SizedBox(height: 30):Container(),
                              isNonJordanianSelected&& _isForeign? buildPearonalNumber():Container(),
                              isNonJordanianSelected&& _isForeign?  buildPersonal_Image():Container(),
                              isNonJordanianSelected&& _isTemporary? buildTemporaryPassport_Image():Container(),

                              SizedBox(height: 20),
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
                            globalVars.currentScreen=3;
                            globalVars.currentStep=4;
                            widget.onStepChanged(); // Notify the parent widget to update value
                            getScreen();
                            print("Next Step: ${globalVars.currentStep}");
                          });



                          /*disable on27 March 2025 setState(() {
                    if ( globalVars.currentStep < 5) { // Ensure the last step is 5
                      globalVars.currentStep++;
                      widget.onStepChanged(); // Notify the parent widget to update value
                    }
                    getScreen();
                    print("Next Step: ${globalVars.currentStep}");
                  });*/
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
          ]
      );
    }

  }
}


// New screen to display results and validations
class IDResultScreen extends StatelessWidget {
  final Map<String, String> idInfo;
  final List<String> imagePaths;

  const IDResultScreen({
    Key key,
    this.idInfo,
    this.imagePaths,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("ID Verification Results"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Extracted Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildInfoCard(),
            SizedBox(height: 24),
            Text(
              "Captured Images",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildImageGallery(),
            SizedBox(height: 32),
            _buildVerificationStatus(),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (idInfo.containsKey('name')) _buildInfoRow("Name", idInfo['name']),
            if (idInfo.containsKey('nationalId')) _buildInfoRow("National ID", idInfo['nationalId']),
            if (idInfo.containsKey('dateOfBirth')) _buildInfoRow("Date of Birth", idInfo['dateOfBirth']),
            if (idInfo.containsKey('expiry')) _buildInfoRow("Expiry Date", idInfo['expiry']),
            if (idInfo.containsKey('idNumber')) _buildInfoRow("ID Number", idInfo['idNumber']),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label + ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildImageGallery() {
    return Container(
      height: 200,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imagePaths.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(right: 16),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.file(
                File(imagePaths[index]),
                height: 180,
                width: 280,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationStatus() {
    // Determine if we have enough information to consider the ID valid
    bool isValid = idInfo.length >= 3; // At least 3 fields extracted

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isValid ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.error,
            color: isValid ? Colors.green[700] : Colors.red[700],
            size: 48,
          ),
          SizedBox(height: 8),
          Text(
            isValid ? "ID Verified Successfully" : "Incomplete ID Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isValid ? Colors.green[700] : Colors.red[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            isValid
                ? "All required information has been extracted and verified."
                : "Some information could not be extracted. Please try scanning again.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}


class ScannerOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final holeWidth = size.width * 0.8;
    final holeHeight = size.height * 0.3;
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

    // Now draw white border around the hole
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // adjust thickness as needed

    canvas.drawRRect(holeRRect, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}


// Screen to display passport results and validations
class PassportResultScreen extends StatelessWidget {
  final Map<String, String> passportInfo;
  final String imagePath;

  const PassportResultScreen({
    Key key,
    this.passportInfo,
    this.imagePath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Passport Verification Results"),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MRZ section (if captured)
            if (passportInfo.containsKey('mrzFirstLine') || passportInfo.containsKey('mrzSecondLine'))
              _buildMRZSection(),
            SizedBox(height: 24),
            Text(
              "Extracted Information",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildInfoCard(),
            SizedBox(height: 24),
            if (imagePath != null) ...[
              Text(
                "Captured Image",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              _buildCapturedImage(),
              SizedBox(height: 32),
            ],
            _buildVerificationStatusMRZ(),
          ],
        ),
      ),
    );
  }

  Widget _buildMRZSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Machine Readable Zone (MRZ)",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 16),
        Card(
          elevation: 4,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (passportInfo.containsKey('mrzFirstLine'))
                  Text(
                    passportInfo['mrzFirstLine'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 16,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                SizedBox(height: 8),
                if (passportInfo.containsKey('mrzSecondLine'))
                  Text(
                    passportInfo['mrzSecondLine'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Courier',
                      fontSize: 16,
                      letterSpacing: 0.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard() {
    return Card(
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (passportInfo.containsKey('surname') && passportInfo.containsKey('givenNames'))
              _buildInfoRow("Full Name", "${passportInfo['surname']} ${passportInfo['givenNames']}"),
            if (passportInfo.containsKey('name') && !passportInfo.containsKey('surname'))
              _buildInfoRow("Name", passportInfo['name'] ?? ''),
            if (passportInfo.containsKey('passportNumber'))
              _buildInfoRow("Passport Number", passportInfo['passportNumber'] ?? ''),
            if (passportInfo.containsKey('nationality'))
              _buildInfoRow("Nationality", passportInfo['nationality'] ?? ''),
            if (passportInfo.containsKey('issuingCountry'))
              _buildInfoRow("Issuing Country", passportInfo['issuingCountry'] ?? ''),
            if (passportInfo.containsKey('dateOfBirth'))
              _buildInfoRow("Date of Birth", passportInfo['dateOfBirth'] ?? ''),
            if (passportInfo.containsKey('gender'))
              _buildInfoRow("Gender", passportInfo['gender'] ?? ''),
            if (passportInfo.containsKey('expiryDate'))
              _buildInfoRow("Expiry Date", passportInfo['expiryDate'] ?? ''),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              label + ":",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: Text(value),
          ),
        ],
      ),
    );
  }

  Widget _buildCapturedImage() {
    if (imagePath == null) return Container();

    return Center(
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.file(
          File(imagePath),
          height: 200,
          width: 300, // Match 3:2 passport ratio
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildVerificationStatusMRZ() {
    // For passports, MRZ is the most reliable indicator
    bool hasMRZ = passportInfo.containsKey('mrzFirstLine') && passportInfo.containsKey('mrzSecondLine');

    // Alternatively, we need several key passport fields
    bool hasEssentialInfo = passportInfo.containsKey('passportNumber') &&
        (passportInfo.containsKey('name') || (passportInfo.containsKey('surname') && passportInfo.containsKey('givenNames'))) &&
        passportInfo.containsKey('dateOfBirth');

    bool isValid = hasMRZ || hasEssentialInfo;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isValid ? Colors.green[100] : Colors.red[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(
            isValid ? Icons.check_circle : Icons.error,
            color: isValid ? Colors.green[700] : Colors.red[700],
            size: 48,
          ),
          SizedBox(height: 8),
          Text(
            isValid ? "Passport Verified Successfully" : "Incomplete Passport Information",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isValid ? Colors.green[700] : Colors.red[700],
            ),
          ),
          SizedBox(height: 8),
          Text(
            isValid
                ? hasMRZ
                ? "Machine Readable Zone (MRZ) data successfully scanned and verified."
                : "Essential passport information has been extracted and verified."
                : "MRZ data could not be extracted. Please try scanning again with better lighting and positioning.",
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class ScannerOverlayPainterMRZ extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.black.withOpacity(0.5)
      ..style = PaintingStyle.fill;

    final holeWidth = size.width * 0.8;
    final holeHeight = size.height * 0.3;
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

    // Now draw white border around the hole
    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1; // adjust thickness as needed

    canvas.drawRRect(holeRRect, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
