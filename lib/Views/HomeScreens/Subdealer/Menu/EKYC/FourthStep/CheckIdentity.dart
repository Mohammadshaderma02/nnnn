import 'dart:convert';
import 'dart:async';
import 'dart:math';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:http/io_client.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

/*THE FOLLOWING FOR IMAGES*/
import 'package:camera/camera.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'dart:typed_data';
import 'dart:math' as math;
import 'package:image/image.dart' as img;

import '../../../../../../Shared/BaseUrl.dart'; // Add this dependency to pubspec.yaml
/*END OF IMAGE PROCESS*/



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

  APP_URLS urls = new APP_URLS();
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

  File frontImage;
  File backImage;
  File passportImage;
  String _dataPersonalNumber = "";
  bool emptyPersonal=false;
  final borderLeft = OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(left: Radius.circular(5),)
  );
  final borderRight = OutlineInputBorder(
      borderRadius: BorderRadius.horizontal(right: Radius.circular(5),)
  );
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*------------------------------------------------The following function for image 17 June-----------------------------------------------*/
  CameraController _controller;
  bool _isCameraInitialized = false;
  int _currentStep = 0;
  final TextRecognizer _textRecognizer = TextRecognizer();
  Timer _frameProcessor;
  bool _isProcessing = false;
  List<String> _capturedPaths = [];
  List<String> _capturedBase64 = [];

  // Border and validation states
  Color _borderColor = Colors.white;
  Timer _borderColorTimer;
  Map<String, String> _idInfo = {};

  // Timeout feature variables
  Timer _stepTimeout;
  int _timeoutDuration = 60; // 30 seconds timeout per step
  int _remainingTime = 60;
  Timer _countdownTimer;

  // Image quality variables
  double _lastBlurScore = 0.0;
  String _qualityMessage = "";
  bool _isImageQualityGood = false;

  String sanad_code;
  String sanad_state;



  // Validation patterns
  // final RegExp _nationalIdPattern = RegExp(r'\d{10}');
  final RegExp _namePattern = RegExp(r'[A-Z]+<<[A-Z]+<[A-Z]+<[A-Z]+');
  // final RegExp _datePattern = RegExp(r'\d{2}/\d{2}/\d{4}');
  final RegExp _expiryPattern = RegExp(r'Expiry.+\d{2}/\d{2}/\d{4}');
  final RegExp _idNumberPattern = RegExp(r'ID no\.: [A-Z0-9]+');


  // Updated validation patterns for Jordanian ID
  final RegExp _frontSidePatterns = RegExp(r'(الهوية|الاردنية|Jordan|المملكة|الهاشمية)', caseSensitive: false);
  final RegExp _backSidePatterns = RegExp(r'(\d{10}|<<<|JOR\d)', caseSensitive: false);
  final RegExp _namePatternArabic = RegExp(r'[\u0600-\u06FF\s]+'); // Arabic text
  final RegExp _namePatternEnglish = RegExp(r'[A-Z][a-z]+\s+[A-Z][a-z]+'); // English names
  final RegExp _datePattern = RegExp(r'\d{2}/\d{2}/\d{4}');
  final RegExp _nationalIdPattern = RegExp(r'\d{10}'); // 10-digit ID number
  final RegExp _mrzPattern = RegExp(r'[A-Z0-9<]{2,}<<<[A-Z0-9<]+'); // MRZ line pattern



  // Update your step titles to be more explicit
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
  // Add these new state variables
  bool _frontSideCaptured = false;
  bool _isShowingWrongSideWarning = false;
  Timer _wrongSideWarningTimer;
  bool _bothSidesCaptured = false;
  Timer _autoCloseTimer;


// Add these variables to track timers at the class level
  Timer _tipRotationTimer;

  /*--------------------------------------------------------End of variable image process--------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*----------------------------------------------The following Functions fo image ID front Bak processor ---------------------------------*/
  // NEW: Reset method to clear all scanner state
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
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controller = CameraController(backCamera, ResolutionPreset.high);
    await _controller.initialize();
    //setState(() => _isCameraInitialized = true);
    setState(() {

      _isCameraInitialized = true;
    });
    _startFrameProcessing();
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: IconButton(
          onPressed: () {
            _showRestartConfirmation();
          },
          icon: Icon(
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
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*-----------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------The following function for Passport-------------------------------------------------*/
  CameraController _controllerMRZ;
  bool _isCameraInitializedMRZ = false;
  int _currentStepMRZ = 0;
  final TextRecognizer _textRecognizerMRZ = TextRecognizer();
  Timer _frameProcessorMRZ;
  bool _isProcessingMRZ = false;
  String _capturedImagePath;

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

  /*--------------------------------------------------------End of variable image process--------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*----------------------------------------------The following Functions fo passport processor ---------------------------------*/
  // Add method to restart camera and timers
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

  void _navigateToResultScreenMRZ() {
    // Navigate to a results screen with the extracted information
   /* Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PassportResultScreen(
          passportInfo: _passportInfo,
          imagePath: _capturedImagePath,
        ),
      ),
    );*/
  }

  // Add this method to stop camera and cleanup
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

/*--------------------------------------------------------End of variable Passport process-------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------The following Temporary for Passport-------------------------------------------------*/
  CameraController _controllerTemporary;
  bool _isCameraInitializedTemporary = false;
  int _currentStepTemporary = 0;
  final TextRecognizer _textRecognizerTemporary = TextRecognizer();
  Timer _frameProcessorTemporary;
  bool _isProcessingTemporary = false;
  String _capturedImagePathTemporary;

  // Add a border color state variable
  Color _borderColorTemporary = Colors.white;

  // Add a timer for changing border color back to white
  Timer _borderColorTimerTemporary;

  // Store extracted passport information
  Map<String, String> _passportInfoTemporary = {};

  // Define validation patterns for passport MRZ (Machine Readable Zone)
  // First line of MRZ is typically 44 characters starting with P<
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

  final List<String> _stepsTemporary = [
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

  int _tipIndexTemporary = 0;

  /*----------------------------------------------------End of variable Temporary image process--------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*----------------------------------------------The following Functions fo Temporary processor ---------------------------------*/
  // Add method to restart camera and timers
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

  Future<void> _initializeCameraTemporary() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controllerTemporary = CameraController(backCamera, ResolutionPreset.high);
    await _controllerTemporary.initialize();
    setState(() => _isCameraInitializedTemporary = true);
    _startFrameProcessingTemporary();
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
            _stopCameraAndCleanupTemporary();
            uploadPassportFile_API(passportImage);
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

  void _navigateToResultScreenTemporary() {
    // Navigate to a results screen with the extracted information
    /* Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PassportResultScreen(
          passportInfo: _passportInfoTemporary,
          imagePath: _capturedImagePath,
        ),
      ),
    );*/
  }

  // Add this method to stop camera and cleanup
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

  Widget _buildOverlayFrameTemporary() {
    return Container(
      color: Colors.black.withOpacity(0.0), // dim entire screen
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

/*--------------------------------------------------------End of variable Temporary Passport process-------------------------------------------------*/
/*--------------------------------------------------------------------------------------------------------------------------------------------------*/

  /*---------------------------------------------------------------------------------------------------------------------------------------*/
/*---------------------------------------------------The following Temporary for Passport-------------------------------------------------*/
  CameraController _controllerForeign;
  bool _isCameraInitializedForeign = false;
  int _currentStepForeign = 0;
  final TextRecognizer _textRecognizerForeign = TextRecognizer();
  Timer _frameProcessorForeign;
  bool _isProcessingForeign = false;
  String _capturedImagePathForeign;

  // Add a border color state variable
  Color _borderColorForeign = Colors.white;

  // Add a timer for changing border color back to white
  Timer _borderColorTimerForeign;

  // Store extracted passport information
  Map<String, String> _passportInfoForeign = {};

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

  final List<String> _tipsForeign = [
    "Ensure the entire passport is visible",
    "Make sure the MRZ (bottom two lines) is clearly visible",
    "Avoid reflections and shadows on the passport",
    "Hold the camera steady for better results"
  ];

  int _tipIndexForeign = 0;

  /*----------------------------------------------------End of variable Temporary image process--------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*---------------------------------------------------------------------------------------------------------------------------------------*/
  /*----------------------------------------------The following Functions fo passport processor ---------------------------------*/
  // Add method to restart camera and timers
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

  Future<void> _initializeCameraForeign() async {
    final cameras = await availableCameras();
    final backCamera = cameras.firstWhere(
          (camera) => camera.lensDirection == CameraLensDirection.back,
      orElse: () => cameras.first,
    );
    _controllerForeign = CameraController(backCamera, ResolutionPreset.high);
    await _controllerForeign.initialize();
    setState(() => _isCameraInitializedForeign = true);
    _startFrameProcessingForeign();
  }

  void _startTipRotationForeign() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _tipIndexForeign = (_tipIndexForeign + 1) % _tipsForeign.length);
    });
  }

  void _startFrameProcessingForeign() {
    _frameProcessorForeign = Timer.periodic(Duration(milliseconds: 1500), (_) {
      _processFrameForeign();
    });
  }

  // Method to show successful validation with green border
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

  // Show failed validation with red border
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

  void _navigateToResultScreenForeign() {
    // Navigate to a results screen with the extracted information
    /* Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PassportResultScreen(
          passportInfo: _passportInfoTemporary,
          imagePath: _capturedImagePath,
        ),
      ),
    );*/
  }

  // Add this method to stop camera and cleanup
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

  Widget _buildOverlayFrameForeign() {
    return Container(
      color: Colors.black.withOpacity(0.0), // dim entire screen
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

/*--------------------------------------------------------End of variable Temporary Passport process-------------------------------------------------*/
/*-----------------------------------------------------------------------------------------------------------------------------------------*/




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
    // TODO: implement initState
    super.initState();
  }


  @override
  void dispose() {
  /*  _sub.cancel();
    _controller?.dispose();
    _textRecognizer.close();
    _frameProcessor?.cancel();
    _borderColorTimer?.cancel();
    _stepTimeout?.cancel();
    _countdownTimer?.cancel();
    _wrongSideWarningTimer?.cancel();
    _stopCameraAndCleanup();*/
    // Cancel all timers
    _frameProcessor?.cancel();
    _borderColorTimer?.cancel();
    _stepTimeout?.cancel();
    _countdownTimer?.cancel();
    _tipRotationTimer?.cancel();

    // Dispose camera controller
    _controller?.dispose();

    // Close text recognizer only in dispose
    _textRecognizer.close();


    _controllerMRZ?.dispose();
    _textRecognizerMRZ.close();
    _frameProcessorMRZ?.cancel();
    _borderColorTimerMRZ?.cancel(); // Cancel border color timer


    _controllerTemporary?.dispose();
    _textRecognizerTemporary.close();
    _frameProcessorTemporary?.cancel();
    _borderColorTimerTemporary?.cancel(); // Cancel border color timer

    _controllerForeign?.dispose();
    _textRecognizerForeign.close();
    _frameProcessorForeign?.cancel();
    _borderColorTimerForeign?.cancel(); // Cancel border color timer
    _sub?.cancel(); // Cancel the deep link subscription

    super.dispose();
  }

  // ✅ Initialize deep link listener
// Also update your deep link listener initialization
  void _initDeepLinkListener() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null && mounted) {
        _handleDeepLink(initialUri);
      }
    } on PlatformException {
      print('Failed to receive initial uri.');
    } on FormatException catch (err) {
      print('Malformed initial uri: $err');
    }

    _sub = uriLinkStream.listen((Uri uri) {
      if (uri != null && mounted) {
        _handleDeepLink(uri);
      }
    }, onError: (err) {
      print('Deeplink error: $err');
    });
  }


  void _handleDeepLink(Uri uri) {
    print("-----------------queryParameters---------------------------");
    print(uri.queryParameters);
    print("--------------------queryParameters------------------------");
    final status = uri.queryParameters['status'];
    final error = uri.queryParameters['error'];
    final errorCode = uri.queryParameters['error_code'];
    final getCode= uri.queryParameters['code'];// ✅ Get error_code directly
    setState(() {
      sanad_code=uri.queryParameters['code'];
      sanad_state=uri.queryParameters['state'];
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

    // ✅ Check specifically for incorrect_login_credentials
    if (errorCode == 'incorrect_login_credentials') {
      setState(() {
        globalVars.sanadValidation = true;
      });

     /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );*/
     // return; // Stop further processing
    }
    // ✅ Handle the code parameter that's actually in your URI
    if (getCode != null && getCode.isNotEmpty) {
      print("Received authorization code: $getCode");
      // Handle successful authorization code
      sanadAuthorization_API();
     /* globalVars.currentStep += 2;
      print(globalVars.currentStep);
      widget.onStepChanged();
      getScreen();*/
      return; // Stop further processing since we got the code
    }
    if (errorCode == 'unauthorized_client') {
      setState(() {
        globalVars.sanadValidation = true;
      });

      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );*/
      // return; // Stop further processing
    }
   /* if(getCode.length !=0){

                globalVars.currentStep += 2;
                print(globalVars.currentStep);
                widget.onStepChanged(); // notify parent (optional)
                getScreen();

    }*/

    // ✅ Handle success
    if (status == 'success') {
      print("Sanad process succeeded: $status");
      setState(() {
        globalVars.sanadValidation = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );
    }

    // ✅ Handle common failure statuses
    else if (['cancelled', 'canceled', 'timeout', 'expired', 'failed', 'failure'].contains(status)) {
      print("Sanad process was cancelled or failed: $status");
      setState(() {
        globalVars.sanadValidation = true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );
    }
  }


  /*void _handleDeepLink(Uri uri) {
    final status = uri.queryParameters['status'];
    final error = uri.queryParameters['error'];

    // Check if the widget is still mounted before accessing context
    if (!mounted) return;

    // 👇 Close the dialog if it's open - with proper context checking
    if (_dialogContext != null) {
      try {
        // Check if the dialog context is still valid and can be popped
        if (Navigator.of(_dialogContext, rootNavigator: false).canPop()) {
          Navigator.of(_dialogContext).pop();
        }
      } catch (e) {
        print('Error closing dialog: $e');
      } finally {
        _dialogContext = null; // Always clear reference
      }
    }

    // Double-check mounted state before navigation
    if (!mounted) return;

    if (error != null) {
      setState(() {
        globalVars.sanadValidation=true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );

    } else if (status == 'success') {
      print("Sanad process was cancelled or failed1: $status");
      setState(() {
        globalVars.sanadValidation=true;
      });
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );

    }
    else if (status == 'cancelled' || status == 'canceled' || status == 'timeout' || status == 'expired' || status == 'failed' || status == 'failure') {
      setState(() {
        globalVars.sanadValidation=true;
      });
      print("Sanad process was cancelled or failed2: $status");
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => checkIdentity()),
      );

    }
  }*/

  //9971010867
//37375383-f46b-41d4-a79c-a4a4c2f8b1e4

  /*This is stage void sanad_API() async {
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

    print("API Response: ${response.body}");
    print("API Response: ${_sanadNationalNumber.text}");
    if (response.statusCode == 200) {
      setState(() {
        isLoading=false;
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
            _sanadNationalNumber.text="";
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
        isLoading=false;
      });
    }
  }*/

  void sanad_API() async {
    setState(() {
      isLoading = true;
    });
    final apiUrl = "https://dsc.jo.zain.com/eKYC/api/lines/sanad/digitalId/${_sanadNationalNumber.text}/${globalVars.sessionUid}";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "content-type": "application/json",
        "X-API-KEY": "7c4a509c-a205-4cbc-9061-c95415f3deb8"
      },
    );

    print("API Response: ${response.body}");
    print("API Response: ${_sanadNationalNumber.text}");
    if (response.statusCode == 200) {
      setState(() {
        isLoading=false;
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
        isLoading=false;
      });
    }
  }
  // Create a custom HTTP client that skips certificate verification
  http.Client createHttpClient() {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Return true to ignore all certificate errors
      // WARNING: This should only be used in development!
      return true;
    };
    return IOClient(httpClient);
  }



  void sanadAuthorization_API() async {
    setState(() {
      isLoading = true;
    });
    final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/authorize";
    Map body={
      "code": sanad_code,
      "ekycUid": globalVars.sessionUid,
      "state": sanad_state,
      "redirectUrl":redirectUrl,
      "nationalId": _sanadNationalNumber.text,
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
          isLoading = false;
        });
        //I/flutter (30181): API Response: {data: {fullName: محمد محمود محمد شادرما, nationalNo: 2000264514, birthDate: 2001-03-30T00:00:00, gender: Male, cardNumber: LMG80224, cardDateOfExp: 2032-05-17T00:00:00}, message: {en: The Operation has been Successfully Completed, ar: تمت العملية بنجاح}, success: true, timestamp: 2025-07-02T23:14:15.725Z}
//I/flutter (26370): API Response: {"code":"cdd02bb7-7cb0-4264-8856-6f568f882a25","errorName":"AppException","message":{"ar":"غير مسموح بتغيير حالة الملف","en":"Change status of dossier forbidden"},"method":"POST","path":"/wid-zain/api/v1/session/28327f83-692b-48cf-b5a6-6cce2d28b4a1/sanad/authorize","timestamp":"2025-07-02T23:09:10.244Z","success":false}
        final result = json.decode(response.body);
        print("API Response: ${result}");

        if(result["success"] == true && result['message']['en'] == "The Operation has been Successfully Completed"){
          if(result['data']!= null ){
            if(result['data']['nationalNo'] != _sanadNationalNumber.text){
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"The National Number does not match the one in Sanad":"رقم الهوية الوطنية لا يتطابق مع الموجود في سند"),backgroundColor: Colors.red));
            }else{
              globalVars.fullNameAr= result['data']['fullName'];
              globalVars.natinalityNumber= result['data']['nationalNo'];
              globalVars.birthdate= result['data']['birthDate'];
              creation_API();
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
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
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
      isLoading = true;
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
          isLoading = false;
        });
        var result = json.decode(response.body);
        print(result["data"]);
        if (result["status"] == 0 && result['message'] == "The Operation has been Successfully Completed") {
          setState(() {


            globalVars.currentStep += 2;
            print(globalVars.currentStep);
            widget.onStepChanged();
            getScreen();

            print("Next Step: ${globalVars.currentStep}");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"],),backgroundColor: Colors.red));


        }

      } else {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?response.statusCode.toString(): response.statusCode.toString(),),backgroundColor: Colors.red));

      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during API call: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.",),backgroundColor: Colors.red));



    }

  }


  void sanadCheck_API() async {
    setState(() {
      isLoading = true;
    });

    final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/digitalId/${_sanadNationalNumber.text}";

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
      print("API Response: ${_sanadNationalNumber.text}");

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
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
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
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
      isLoading = true;
    });

    final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/digitalId/${_personalNumber.text}";

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
      print("API Response: ${_personalNumber.text}");

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
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
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error: $e');
      setState(() {
        isLoading = false;
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


  /* this is importenet void sanadCheck_API() async {
    setState(() {
      isLoading = true;
    });
    final apiUrl = "https://079.jo/wid-zain/api/v1/session/${globalVars.sessionUid}/sanad/digitalId/${_sanadNationalNumber.text}";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "content-type": "application/json",
        "Authorization": "Bearer ${globalVars.ekycTokenID}",

      },
    );
print(apiUrl);
    print("API Response: ${response.body}");
    print("API Response: ${_sanadNationalNumber.text}");
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Could not launch Sanad URL":"تعذر تشغيل رابط سند"),backgroundColor: Colors.red));

        }
      }
      if (result["data"]["verified"] == false)
      {
        setState(() {
          globalVars.sanadValidation = true;
          _sanadNationalNumber.text="";
        });
      }


    } else {
      print('API call failed with status: ${response.statusCode}');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?response.statusCode.toString():response.statusCode.toString()),backgroundColor: Colors.red));

      setState(() {
        isLoading=false;
      });
    }
  }*/




  uploadFrontID_API(File frontImageFile) async {
    final client = createHttpClient();
    setState(() {
      isLoading = true;
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
          isLoading = false;
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
          isLoading = false;
          _sanadPassportNumber.text="";
          _personalNumber.text= "";
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
        isLoading = false;
        _sanadPassportNumber.text="";
        _personalNumber.text= "";
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
      isLoading = true;
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
          isLoading = false;
        });
        documentProcessingID_API();
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

        setState(() {
          isLoading = false;
          _sanadPassportNumber.text="";
          _personalNumber.text= "";
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
        isLoading = false;
        _sanadPassportNumber.text="";
        _personalNumber.text= "";
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
      isLoading = true;
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
          isLoading = false;
        });
        documentProcessingPassport_API();
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

        setState(() {
          isLoading = false;
          _sanadPassportNumber.text="";
          _personalNumber.text= "";
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
        isLoading = false;
        _sanadPassportNumber.text="";
        _personalNumber.text= "";
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
      isLoading = true;
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
          isLoading = false;
        });
        documentProcessingForignPassport_API();
        return jsonDecode(response.body);
      } else {
        final Map<String, dynamic> jsonData = jsonDecode(response.body);

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

        print('Error: ${response.statusCode}');
        print('Response: ${response.body}');

        setState(() {
          isLoading = false;
          _sanadPassportNumber.text="";
          _personalNumber.text= "";
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
        isLoading = false;
        _sanadPassportNumber.text="";
        _personalNumber.text= "";
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
      isLoading = true;
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
        isLoading=false;
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
        isLoading=false;
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
        isLoading=false;
      });
    }
  }

  void documentProcessingForignPassport_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final client = createHttpClient();
    setState(() {
      isLoading = true;
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
        isLoading=false;
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?" ${responseMap['message']['en']}":"${responseMap['message']['ar']}"),backgroundColor: Colors.green));
          globalVars.fullNameAr="";
          globalVars.fullNameEn=data['ocrData']['givenNames'];
          globalVars.natinalityNumber="-";
          globalVars.cardNumber=data['ocrData']['documentNumber'];
          globalVars.birthdate=data['ocrData']['dateOfBirth']['day'].toString()+'-'+data['ocrData']['dateOfBirth']['month'].toString()+'-'+data['ocrData']['dateOfBirth']['year'].toString();
          globalVars.expirayDate=data['ocrData']['expirationDate']['day'].toString()+'-'+data['ocrData']['expirationDate']['month'].toString()+'-'+data['ocrData']['expirationDate']['year'].toString();
          globalVars.gender=data['ocrData']['sex'];
          globalVars.bloodGroup="-";
          globalVars.registrationNumber="-";
          setState(() {
            globalVars.showPersonalNumber=true;

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
        isLoading=false;
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
        isLoading=false;
      });
    }
  }

  void documentProcessingPassport_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final client = createHttpClient();
    setState(() {
      isLoading = true;
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
        isLoading=false;
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
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?" ${responseMap['message']['en']}":"${responseMap['message']['ar']}"),backgroundColor: Colors.green));
          globalVars.fullNameAr=data['ocrData']['localUserGivenNames'] != null ? data['ocrData']['localUserGivenNames'] : "";
          globalVars.fullNameEn=data['ocrData']['givenNames']!= null ? data['ocrData']['givenNames'] : "";
          globalVars.natinalityNumber=data['ocrData']['userPersonalNumber']!= null ? data['ocrData']['userPersonalNumber'] : "";
          globalVars.cardNumber=data['ocrData']['documentNumber'];
          globalVars.birthdate=data['ocrData']['dateOfBirth']['day'].toString()+'-'+data['ocrData']['dateOfBirth']['month'].toString()+'-'+data['ocrData']['dateOfBirth']['year'].toString();
          globalVars.expirayDate=data['ocrData']['expirationDate']['day'].toString()+'-'+data['ocrData']['expirationDate']['month'].toString()+'-'+data['ocrData']['expirationDate']['year'].toString();
          globalVars.gender=data['ocrData']['sex'];
          globalVars.bloodGroup="-";
          globalVars.registrationNumber="-";


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
        isLoading=false;
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
        isLoading=false;
      });
    }
  }





  /*void uploadPassportFile_API(File frontImageFile) async {
    setState(() {
      isLoading = true;
    });

    final apiUrl =
        "https://079.jo/wid/api/v1/consumer/session/${globalVars.tokenUid}/document-multipart";

    final uri = Uri.parse(apiUrl);
    final request = http.MultipartRequest('POST', uri);

    // Add the 'data' field as a JSON string
    final Map<String, dynamic> payload = {
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
    request.fields['data'] = jsonEncode(payload);

    // Add the file
    final multipartFile = await http.MultipartFile.fromPath(
      'front', // this must match the API's expected field name
      frontImageFile.path,
      filename: p.basename(frontImageFile.path),
      contentType: MediaType('image', 'jpeg'), // adjust if it's png
    );
    request.files.add(multipartFile);

    try {
      final response = await request.send();

      final responseBody = await response.stream.bytesToString();

      print("API Response: $responseBody");

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          _sanadPassportNumber.text="";

        });

        final Map<String, dynamic> successMap = jsonDecode(responseBody);
        final result = json.decode(responseBody);
        print("Parsed Result: $result");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"${successMap['message']['en']}":"${successMap['message']['ar']}"),
            backgroundColor: Colors.green,
          ),
        );
        documentProcessing_API();
      } else {
        setState(() {
          isLoading = false;
          _sanadPassportNumber.text="";
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
        });

        final Map<String, dynamic> errorMap = jsonDecode(responseBody);
        print("Error Name: ${errorMap['errorName']}");
        print("Message (EN): ${errorMap['message']['en']}");
        print("Method: ${errorMap['method']}");
        print("Path: ${errorMap['path']}");
        print("Timestamp: ${errorMap['timestamp']}");
        print("Success: ${errorMap['success']}");

        print('API call failed with status: ${response.statusCode}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error Name: ${errorMap['errorName']}",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error: $e');
    }
  }*/



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

  Widget buildSanadNumber() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            EasyLocalization.of(context).locale == Locale("en", "US")?"Enter your national number":"ادخل رقمك الوطني",
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),
          Row(children: [
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")?"Check verified Digital ID":"التحقق من الهوية الرقمية",
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
                        keyboardType: TextInputType.number,
                        inputFormatters: [FilteringTextInputFormatter.digitsOnly], // Allow only numbers

                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(16), // Adjust padding for consistency
                          border:EasyLocalization.of(context).locale == Locale("en", "US")? borderLeft:borderRight,
                          errorBorder:EasyLocalization.of(context).locale == Locale("en", "US")? borderLeft:borderRight,
                          disabledBorder:EasyLocalization.of(context).locale == Locale("en", "US")? borderLeft:borderRight,
                          focusedBorder: EasyLocalization.of(context).locale == Locale("en", "US")? borderLeft:borderRight,
                          focusedErrorBorder: EasyLocalization.of(context).locale == Locale("en", "US")? borderLeft:borderRight,
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
                      borderRadius:EasyLocalization.of(context).locale == Locale("en", "US")?
                      BorderRadius.only(
                        topRight: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                        topLeft: Radius.circular(0),
                        bottomLeft: Radius.circular(0),
                      ):
                      BorderRadius.only(
                        topRight: Radius.circular(0),
                        bottomRight: Radius.circular(0),
                        topLeft: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                      ),
                    ),
                    child: GestureDetector(
                      onTap: () {
                        _sanadNationalNumber.text==""?
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Please insert ID number":"الرجاء ادخال رقم الهوية"),backgroundColor: Colors.red))
                            :
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            _dialogContext = context; // 👈 Save the dialog context
                            return AlertDialog(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              contentPadding: const EdgeInsets.all(20),
                            //  title: Text("Verification", textAlign: TextAlign.center),
                              content:ConstrainedBox(
                            constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.6),
                            child: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Centered Icon
                                Image(
                                    image: AssetImage('lib/Views/HomeScreens/Subdealer/Menu/EKYC/images/sanadIcon.png'),
                                    width: 60,
                                    height: 60),

                                const SizedBox(height: 20),


                                Text(
                                  EasyLocalization.of(context).locale == Locale("en", "US")?"Upon continuing, you will be directed to the Sand website to verify your identity for the purpose of line authentication.":"عند الاستمرار سيتم توجيهك إلى موقع سند للتحقق من هويتك لغرض مصادقة الخط",
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),

                                const SizedBox(height: 20),

                                // Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      setState(() {
                                        globalVars.sanadValidation = false;
                                        globalVars.tackID  =false;
                                        globalVars.tackJordanPassport=false;
                                        globalVars.sanadValidation=false;
                                      });
                                      sanadCheck_API(); // Launch external auth
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
                                          ? "Approved"
                                          : "موافق",
                                    ),
                                  ),
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
                            ),
                            ),
                            );
                          },
                        );

                        print("Search button tapped");
                      },
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")? "Check":"تحقق",
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

                child:globalVars.capturedBase64.isNotEmpty?
                Stack(
                  alignment: Alignment.center,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child:Image.file(
                        File(globalVars.capturedPaths[0]),
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

              child:globalVars.capturedBase64.isNotEmpty?
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child:Image.file(
                        File(globalVars.capturedPaths[1]),
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
              child: globalVars.capturedBase64MRZ.isNotEmpty?
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child:Image.file(
                        File(globalVars.capturedPathsMRZ),
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
              child: globalVars.capturedBase64Foreign.isNotEmpty?
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipRRect(
                      borderRadius: BorderRadius.circular(8), // Set border radius
                      child:Image.file(
                        File(globalVars.capturedPathsForeign),
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

  Widget buildPearonalNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:EasyLocalization.of(context).locale == Locale("en", "US")? "Enter your personal number": "ادخل رقمك الشخصي",
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
            onChanged: (value) {
              if (value.length == 10) {
                if (value.startsWith('8') || value.startsWith('1')) {
                  sanadPersonalNumberCheck_API();
                } else {
                  globalVars.isValidForeignIdentification = false;
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(EasyLocalization.of(context).locale == Locale("en", "US")
                        ? "The first digit must be 8 or 1"
                        : "يجب أن يبدأ الرقم بـ 8 أو 1"),
                    backgroundColor: Colors.red,
                  ));
                }
              } else {
                globalVars.isValidForeignIdentification = false;
              }
            },
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: _personalNumber,
            enabled: true,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Color(0xff11120e)),
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
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.document_scanner,
                    color: ekycColors.primary,
                  ),
                  onPressed: _ScanPearsonalNumber,
                )
            ),
          ),
        ),
      ],
    );
  }

  _ScanPearsonalNumber() async {
    try {
      final value = await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE,
      );

      if (value != "-1" && value.length == 10) {
        if (value.startsWith('8') || value.startsWith('1')) {
          setState(() {
            _personalNumber.text = value;
          });
          sanadPersonalNumberCheck_API();
          print("Scanned Personal Number: $_dataPersonalNumber");
        } else {
          setState(() {
            _personalNumber.text = "";
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale == Locale("en", "US")
                ? "The first digit must be 8 or 1"
                : "يجب أن يبدأ الرقم بـ 8 أو 1"),
            backgroundColor: Colors.red,
          ));
          print("Invalid scanned value: $value");
        }
      } else {
        setState(() {
          _personalNumber.text = "";
        });
         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Invalid personal number":"الرقم الشخصي غير صالح"),backgroundColor: Colors.red));

        print("Scan cancelled or invalid value: $value");
      }
    } catch (e) {
      print("Error during scanning: $e");
    }
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



  @override
  Widget build(BuildContext context) {
   if(_isCameraInitialized){
     return Stack(
       fit: StackFit.expand,
       children: [
         CameraPreview(_controller),
         _buildOverlayFrame(),
        // _buildStepText(),
         _buildTipText(),
       //  _buildTimeoutCounter(), // New timeout counter
         _buildQualityIndicator(), // New quality indicator
         _buildSideIndicator(), // New side indicator
         _buildRestartButton(), // Optional floating restart button

         // Cancel button (same as before)
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
                   onPressed: () async{
                     await  _stopCameraAndCleanup();
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
                     globalVars.tackForeign = false;
                     globalVars.tackTemporary=false;


                    // Navigator.of(context).pop();
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
   }if(_isCameraInitializedMRZ){
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
                     onPressed: () {
                       _stopCameraAndCleanupMRZ();
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
                       globalVars.tackForeign = false;
                       globalVars.tackTemporary=false;
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
   if(_isCameraInitializedTemporary){
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
               decoration: BoxDecoration(
                 color: Colors.black.withOpacity(0),
                 borderRadius: BorderRadius.circular(8),
               ),
               child:Center(
                 child: SizedBox(
                   width: double.infinity,
                   child: TextButton(
                     onPressed: () {
                       _stopCameraAndCleanupTemporary();
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
                       globalVars.tackForeign = false;
                       globalVars.tackTemporary=false;
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
   if(_isCameraInitializedForeign){
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
               decoration: BoxDecoration(
                 color: Colors.black.withOpacity(0),
                 borderRadius: BorderRadius.circular(8),
               ),
               child:Center(
                 child: SizedBox(
                   width: double.infinity,
                   child: TextButton(
                     onPressed: () {
                       _stopCameraAndCleanupForeign();
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

                       setState(() {
                         globalVars.tackForeign = false;
                         globalVars.tackTemporary=false;
                         _sanadPassportNumber.text="";
                         _personalNumber.text= "";
                       });
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
     return Stack(
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
                       child: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Document Upload": "تحميل المستندات",
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
                                           _personalNumber.text= "";
                                           globalVars.sanadValidation=false;

                                         });
                                       },
                                       child: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Jordanian":"الأردنيون"),
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
                                           globalVars.sanadValidation=false;
                                           _personalNumber.text= "";

                                         });
                                       },
                                       child: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Non-Jordanian": "غير الأردنيون"),
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
                             isJordanianSelected && globalVars.sanadValidation? Container(
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
                                     child: Text(EasyLocalization.of(context).locale == Locale("en", "US")?
                                       "Sorry, You don’t have a verified digital ID.\n Please upload a copy of your ID or\n Passport below."
                                       :"عذراً، ليس لديك هوية رقمية موثقة.\n يرجى تحميل نسخة من هويتك أو\n جواز سفرك أدناه.",
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
                             isJordanianSelected && globalVars.sanadValidation?  SizedBox(height: 20):Container(),
                             isJordanianSelected && globalVars.sanadValidation? Text(
                               EasyLocalization.of(context).locale == Locale("en", "US")? "Select Document Type":"اختر نوع المستند",
                               textAlign: TextAlign.start,
                               style: TextStyle(fontSize: 14,fontWeight: FontWeight.bold),
                             ):Container(),
                             isJordanianSelected && globalVars.sanadValidation? SizedBox(height: 10):Container(),
                             isJordanianSelected && globalVars.sanadValidation? SizedBox(
                               width: double.infinity, // Ensures full width
                               child: Row(
                                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                 children: [
                                   //for ID button
                                   Expanded(
                                     child: ElevatedButton(
                                       style: ElevatedButton.styleFrom(
                                         elevation: 0,
                                         primary: globalVars.tackID  ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                         onPrimary: globalVars.tackID  ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                         side: BorderSide(
                                           color: globalVars.tackID  ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                           width: 1, // Border width ekycColors.backgroundBorder
                                         ),
                                         minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                       ),
                                       onPressed:  () {
                                         setState(() {
                                           globalVars.tackID  = true;
                                           globalVars.tackJordanPassport = false;
                                          // _sanadNationalNumber.text= "";
                                         });

                                         _restartCameraAndTimers();

                                       },

                                       child:EasyLocalization.of(context).locale == Locale("en", "US")? Text(globalVars.capturedBase64.isNotEmpty?"Re-Tack ID":"ID"): Text(globalVars.capturedBase64.isNotEmpty?"اعادة الهوية":"الهوية"),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   //for Jordanian Passport bbutton
                                   // Space between buttons
                                   Expanded(
                                     child: ElevatedButton(
                                       style: ElevatedButton.styleFrom(
                                         elevation: 0,
                                         primary: globalVars.tackJordanPassport ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                         onPrimary: globalVars.tackJordanPassport ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                         side: BorderSide(
                                           color: globalVars.tackJordanPassport ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                           width: 1, // Border width ekycColors.backgroundBorder
                                         ),
                                         minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                       ),
                                       onPressed:  () {
                                         setState(() {
                                           globalVars.tackJordanPassport = true;
                                           globalVars.tackID  = false;
                                         //  _sanadNationalNumber.text= "";

                                         });
                                         _restartCameraPassport();
                                       },
                                       child:EasyLocalization.of(context).locale == Locale("en", "US")? Text(globalVars.capturedBase64MRZ.isNotEmpty?"Re-Tack Passport":"Jordanian Passport"): Text(globalVars.capturedBase64MRZ.isNotEmpty?"اعادة جواز السفر":"جواز السفر الأردني"),
                                     ),
                                   ),
                                 ],
                               ),
                             ):Container(),
                             isJordanianSelected && globalVars.tackID  && globalVars.sanadValidation?  buildFronID_Image():Container(),
                             isJordanianSelected && globalVars.tackID  && globalVars.sanadValidation? buildBackID_Image():Container(),
                             isJordanianSelected && globalVars.tackJordanPassport && globalVars.sanadValidation? buildJordanianPassport_Image():Container(),



                             /*________________________________________________non-Jordanian/Passport Type____________________________________*/

                             isNonJordanianSelected ? Text(
                               EasyLocalization.of(context).locale == Locale("en", "US")?"Select Passport Type": "اختر نوع الجواز",
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
                                         primary: globalVars.tackForeign ? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                         onPrimary: globalVars.tackForeign ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                         side: BorderSide(
                                           color: globalVars.tackForeign ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                           width: 1, // Border width ekycColors.backgroundBorder
                                         ),
                                         minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                       ),
                                       onPressed:  () {
                                         setState(() {
                                           globalVars.tackForeign = true;
                                           globalVars.tackTemporary = false;
                                           _sanadPassportNumber.text= "";
                                           _personalNumber.text= "";

                                         });
                                        _restartCameraPassportForeign();
                                       },
                                       child: EasyLocalization.of(context).locale == Locale("en", "US")?Text(globalVars.capturedBase64Foreign.isNotEmpty?"Re-Tack Foreign":"Foreign"): Text(globalVars.capturedBase64Foreign.isNotEmpty?"اعادة جواز السفر":"جواز سفر أجنبي"),
                                     ),
                                   ),
                                   SizedBox(width: 10),
                                   //for Jordanian Passport bbutton
                                   // Space between buttons
                                   Expanded(
                                     child: ElevatedButton(
                                       style: ElevatedButton.styleFrom(
                                         elevation: 0,
                                         primary: globalVars.tackTemporary? ekycColors.primary:ekycColors.backgroundWhite , // Disable color
                                         onPrimary: globalVars.tackTemporary ? ekycColors.backgroundWhite : ekycColors.textFourth, // Text color
                                         side: BorderSide(
                                           color:globalVars.tackTemporary ? ekycColors.primary : ekycColors.buttonBorder, // Border color
                                           width: 1, // Border width ekycColors.backgroundBorder
                                         ),
                                         minimumSize: Size(double.infinity, 45), // 👈 Set width & height

                                       ),
                                       onPressed:  () {
                                         setState(() {
                                           globalVars.tackTemporary = true;
                                           globalVars.tackForeign = false;
                                           globalVars.showForeignPassport=false;
                                           _sanadPassportNumber.text= "";
                                           _personalNumber.text= "";

                                         });
                                        _restartCameraPassportTemporary();
                                       },
                                       child: EasyLocalization.of(context).locale == Locale("en", "US")?Text(globalVars.capturedBase64Temporary.isNotEmpty?"Re-Tack Temporary":"Temporary"): Text(globalVars.capturedBase64Temporary.isNotEmpty?"اعادة جواز مؤقت":"جواز مؤقت"),
                                     ),
                                   ),
                                 ],
                               ),
                             ):Container(),
                             globalVars.tackForeign || globalVars.tackTemporary? SizedBox(height: 20):Container(),
                             /*_________________________________________non-Jordanian/Message Error When Check Sanad_________________________*/
                             isNonJordanianSelected &&(globalVars.tackForeign )   ? SizedBox(height: 20):Container(),
                            /* isNonJordanianSelected &&(globalVars.tackForeign ) ? Container(
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
                             ):Container(),*/
                             isNonJordanianSelected&& globalVars.tackForeign?  SizedBox(height: 10):Container(),
                             isNonJordanianSelected&& globalVars.tackForeign?  buildForeignPassport_Image():Container(),
                             isNonJordanianSelected&& globalVars.tackForeign? SizedBox(height: 30):Container(),
                             isNonJordanianSelected&& globalVars.tackForeign && globalVars.showPersonalNumber? buildPearonalNumber():Container(),
                           //  isNonJordanianSelected&& globalVars.tackForeign?  buildPersonal_Image():Container(),
                             isNonJordanianSelected&& globalVars.tackTemporary? buildTemporaryPassport_Image():Container(),

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
                             globalVars.termCondition1 =false;
                             globalVars.termCondition2 =false;
                             globalVars.tackID =false;
                             globalVars.tackJordanPassport =false;
                             globalVars.capturedPaths.clear();
                             globalVars.capturedBase64.clear();
                             globalVars.capturedPathsMRZ="";
                             globalVars.capturedBase64MRZ="";
                             globalVars.isValidPassportIdentification = false;
                             globalVars.isValidIdentification=false;
                             globalVars.sanadValidation = false;


                             globalVars.tackTemporary = false;
                             globalVars.tackForeign=false;
                             globalVars.capturedPathsTemporary="";
                             globalVars.capturedBase64Temporary="";
                             globalVars.capturedPathsForeign="";
                             globalVars.capturedBase64Foreign="";
                             globalVars.isValidTemporaryIdentification = false;
                             globalVars.isValidForeignIdentification = false;
                             globalVars.isValidLivness=false;
                             globalVars.tackForeign=false;
                             globalVars.tackTemporary=false;
                             globalVars.merchantID="";
                             globalVars.terminalID="";
                             globalVars.otp_ekyc="";

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
                           Text(EasyLocalization.of(context).locale == Locale("en", "US")?'Back':'رجوع', style: TextStyle(color: Colors.white)),
                         ],
                       ),
                     ),
                   ),
                   SizedBox(width: 16), // Space between buttons

                   // Next Button
                   globalVars.isValidIdentification ||
                   globalVars.isValidPassportIdentification ||
                   globalVars.isValidTemporaryIdentification ||
                   globalVars.isValidForeignIdentification ?
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
                           globalVars.videoPathUploaded="";
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
                   )
                   :
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
         ]
     );
   }
  }
}


// Updated ScannerOverlayPainter to accept border color
class ScannerOverlayPainter extends CustomPainter {
  final Color borderColor;

  ScannerOverlayPainter({this.borderColor = Colors.white});

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

    final path = Path()
      ..addRect(outerRect)
      ..addRRect(holeRRect)
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, paint);

    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawRRect(holeRRect, borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}


// Update the ScannerOverlayPainterMRZ class to accept and use border color
class ScannerOverlayPainterMRZ extends CustomPainter {
  final Color borderColor;

  ScannerOverlayPainterMRZ({this.borderColor = Colors.white});

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

    // Now draw border around the hole using the dynamic border color
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // Made thicker for better visibility

    canvas.drawRRect(holeRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainterMRZ oldDelegate) {
    return oldDelegate.borderColor != borderColor;
  }
}


// Update the ScannerOverlayPainterTemporary class to accept and use border color
class ScannerOverlayPainterTemporary extends CustomPainter {
  final Color borderColorTemporary;

  ScannerOverlayPainterTemporary({this.borderColorTemporary = Colors.white});

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

    // Now draw border around the hole using the dynamic border color
    final borderPaint = Paint()
      ..color = borderColorTemporary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // Made thicker for better visibility

    canvas.drawRRect(holeRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainterTemporary oldDelegate) {
    return oldDelegate.borderColorTemporary != borderColorTemporary;
  }
}


// Update the ScannerOverlayPainterForeign class to accept and use border color
class ScannerOverlayPainterForeign extends CustomPainter {
  final Color borderColorForeign;

  ScannerOverlayPainterForeign({this.borderColorForeign = Colors.white});

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

    // Now draw border around the hole using the dynamic border color
    final borderPaint = Paint()
      ..color = borderColorForeign
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3; // Made thicker for better visibility

    canvas.drawRRect(holeRRect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant ScannerOverlayPainterForeign oldDelegate) {
    return oldDelegate.borderColorForeign != borderColorForeign;
  }
}



