/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class IDScannerScreen extends StatefulWidget {
  @override
  _IDScannerScreenState createState() => _IDScannerScreenState();
}

class _IDScannerScreenState extends State<IDScannerScreen> {
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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startTipRotation();
  }

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
    _frameProcessor = Timer.periodic(Duration(milliseconds: 1500), (_) {
      _processFrame();
    });
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
          _navigateToResultScreen();
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

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    _frameProcessor?.cancel();
    _borderColorTimer?.cancel(); // Cancel border color timer
    super.dispose();
  }

  /*Widget _buildOverlayFrame() {
    return Center(
      child: Container(
        width: 300,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }*/


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan ID - Step ${_currentStep + 1}/${_steps.length}")),
      body: _isCameraInitialized
          ? Stack(
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
                    onPressed: () {
                      // Cancel action
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
      )
          : Center(child: CircularProgressIndicator()),
    );
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
}*/



/*import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class IDScannerScreen extends StatefulWidget {
  @override
  _IDScannerScreenState createState() => _IDScannerScreenState();
}

class _IDScannerScreenState extends State<IDScannerScreen> {
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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startTipRotation();
  }

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
    _frameProcessor = Timer.periodic(Duration(milliseconds: 1500), (_) {
      _processFrame();
    });
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
          _navigateToResultScreen();
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

    // More specific patterns for front side
    final RegExp nameFieldPattern = RegExp(r'(Name|NAME).{0,5}:.+', caseSensitive: false);
    final RegExp genderFieldPattern = RegExp(r'(Sex|Gender|SEX).{0,5}:.{0,5}[MF]', caseSensitive: false);
    final RegExp dobFieldPattern = RegExp(r'(Date of Birth|DOB|Birth).{0,10}\d{2}[/\-\.]\d{2}[/\-\.]\d{4}', caseSensitive: false);

    // Search for specific patterns in Jordanian ID front side
    bool hasNationalId = _extractAndStore(text, _nationalIdPattern, 'nationalId');
    bool hasNameField = nameFieldPattern.hasMatch(text) || _extractAndStore(text, RegExp(r'Name:.+'), 'name');
    bool hasDateOfBirth = dobFieldPattern.hasMatch(text) || _extractAndStore(text, RegExp(r'\d{2}/\d{2}/\d{4}'), 'dateOfBirth');
    bool hasGenderField = genderFieldPattern.hasMatch(text) || text.contains('M') || text.contains('F');

    // Additional front side indicators
    bool hasPhotoArea = text.contains('Photo') || text.contains('PHOTO');

    // Check for back side indicators that should NOT be on front
    bool hasMrz = text.contains('JOR') && text.contains('<<<');
    bool hasExpiryField = text.contains('Expiry') || text.contains('EXP');

    // If it contains back side indicators, reject it
    if (hasMrz || hasExpiryField) {
      print("Rejected: Contains back side indicators");
      return false;
    }

    // Count valid front side matches
    List<bool> frontSideMatches = [hasNationalId, hasNameField, hasDateOfBirth, hasGenderField, hasPhotoArea];
    int matchCount = frontSideMatches.where((match) => match).length;

    print("Front side validation - National ID: $hasNationalId, Name: $hasNameField, DOB: $hasDateOfBirth, Gender: $hasGenderField, Photo: $hasPhotoArea");
    print("Match count: $matchCount");

    // Require at least 2 front side indicators
    return matchCount >= 2;
  }

  bool _validateBackSide(String text) {
    print("Validating back side text: $text");

    // More specific patterns for Jordanian ID back side
    final RegExp mrzPattern = RegExp(r'JOR[A-Z0-9<]{27,}'); // More specific MRZ pattern
    final RegExp backIdPattern = RegExp(r'[A-Z]{2}[0-9]{7}'); // Common back ID number format
    final RegExp expiryDatePattern = RegExp(r'(Expiry|EXP).{0,10}\d{2}[/\-\.]\d{2}[/\-\.]\d{4}', caseSensitive: false);
    final RegExp issueByPattern = RegExp(r'(Issue|Issued).{0,20}(by|By)', caseSensitive: false);

    // Check for specific back side indicators
    bool hasMrz = mrzPattern.hasMatch(text) || (text.contains('JOR') && text.contains('<<<'));
    bool hasBackIdNumber = backIdPattern.hasMatch(text) || _extractAndStore(text, _idNumberPattern, 'idNumber');
    bool hasExpiryDate = expiryDatePattern.hasMatch(text) || _extractAndStore(text, _expiryPattern, 'expiry');
    bool hasIssueBy = issueByPattern.hasMatch(text);

    // Additional checks to ensure it's NOT the front side
    bool hasNameField = text.contains('Name:') || text.contains('NAME:');
    bool hasGenderField = text.contains('Sex:') || text.contains('Gender:') || text.contains('SEX:');
    bool hasDobField = text.contains('Date of Birth') || text.contains('DOB');

    // If it contains front side indicators, reject it
    if (hasNameField || hasGenderField || hasDobField) {
      print("Rejected: Contains front side indicators");
      return false;
    }

    // Count valid back side matches
    List<bool> backSideMatches = [hasMrz, hasBackIdNumber, hasExpiryDate, hasIssueBy];
    int matchCount = backSideMatches.where((match) => match).length;

    print("Back side validation - MRZ: $hasMrz, ID Number: $hasBackIdNumber, Expiry: $hasExpiryDate, Issue By: $hasIssueBy");
    print("Match count: $matchCount");

    // Require at least 2 back side indicators and no front side indicators
    return matchCount >= 2;
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

  @override
  void dispose() {
    _controller?.dispose();
    _textRecognizer.close();
    _frameProcessor?.cancel();
    _borderColorTimer?.cancel(); // Cancel border color timer
    super.dispose();
  }

  /*Widget _buildOverlayFrame() {
    return Center(
      child: Container(
        width: 300,
        height: 180,
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor, width: 1),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }*/


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan ID - Step ${_currentStep + 1}/${_steps.length}")),
      body: _isCameraInitialized
          ? Stack(
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
                      onPressed: () {
                        // Cancel action
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
      )
          : Center(child: CircularProgressIndicator()),
    );
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
}*/



// this is final result

import 'dart:convert';
import 'dart:typed_data';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:image/image.dart' as img; // Add this dependency to pubspec.yaml

class IDScannerScreen extends StatefulWidget {
  @override
  _IDScannerScreenState createState() => _IDScannerScreenState();
}

class _IDScannerScreenState extends State<IDScannerScreen> {
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
  int _timeoutDuration = 30; // 30 seconds timeout per step
  int _remainingTime = 30;
  Timer _countdownTimer;

  // Image quality variables
  double _lastBlurScore = 0.0;
  String _qualityMessage = "";
  bool _isImageQualityGood = false;

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

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    _startTipRotation();
    _startStepTimeout();
    _resetScannerState(); // Initialize clean state


  }
  // NEW: Reset method to clear all scanner state
  void _resetScannerState() {
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
    setState(() => _isCameraInitialized = true);
    _startFrameProcessing();
  }

  void _startTipRotation() {
    Timer.periodic(Duration(seconds: 4), (timer) {
      if (!mounted) return;
      setState(() => _tipIndex = (_tipIndex + 1) % _tips.length);
    });
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

        if (_currentStep >= _steps.length) {
          _frameProcessor?.cancel();
          _navigateToResultScreen();
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


  // Your existing validation methods remain the same
  // Enhanced validation methods with better detection
  bool _validateFrontSide(String text) {
    print("Validating front side text: $text");

    // Front side indicators (adjust based on your ID format)
    bool hasArabicText = RegExp(r'(الهوية|الاردنية|Jordan|المملكة|الهاشمية)', caseSensitive: false).hasMatch(text);
    bool hasName = _extractAndStore(text, RegExp(r'[\u0600-\u06FF\s]+'), 'nameArabic') ||
        _extractAndStore(text, RegExp(r'[A-Z][a-z]+\s+[A-Z][a-z]+'), 'nameEnglish');
    bool hasDateOfBirth = _extractAndStore(text, RegExp(r'\d{2}/\d{2}/\d{4}'), 'dateOfBirth');

    // Strong indicators this is NOT the back side
    bool hasNoMRZ = !text.contains('<<<') && !text.contains('JOR');
    bool hasNoLongNumbers = !RegExp(r'\d{10}').hasMatch(text);

    bool hasGender = text.toLowerCase().contains('male') ||
        text.toLowerCase().contains('female') ||
        text.contains('M') || text.contains('F') ||
        text.contains('ذكر') || text.contains('انثى');

    int positiveMatches = [hasArabicText, hasName, hasDateOfBirth, hasGender].where((match) => match).length;
    int negativeMatches = [hasNoMRZ, hasNoLongNumbers].where((match) => match).length;

    print("Front side - Positive: $positiveMatches, Negative: $negativeMatches");

    // Need at least 2 positive indicators AND both negative indicators
    return positiveMatches >= 2 && negativeMatches >= 1;
  }

  bool _validateBackSide(String text) {
    print("Validating back side text: $text");

    // Back side indicators
    bool hasNationalId = _extractAndStore(text, RegExp(r'\d{10}'), 'nationalId');
    bool hasMrzCode = text.contains('JOR') && text.contains('<<<');
    bool hasExpiryDate = _extractAndStore(text, RegExp(r'(Expiry|انتهاء).{0,10}\d{2}/\d{2}/\d{4}'), 'expiry');
    bool hasIdNumber = (text.contains('ID') && text.contains('No')) ||
        (text.contains('رقم') && text.contains('الهوية'));

    // Strong indicators this is NOT the front side
    bool hasNoPhoto = !text.toLowerCase().contains('photo') && !text.contains('صورة');

    int positiveMatches = [hasNationalId, hasMrzCode, hasExpiryDate, hasIdNumber].where((match) => match).length;

    print("Back side - Positive matches: $positiveMatches");

    // Need at least 2 positive indicators for back side
    return positiveMatches >= 2;
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

    // Navigate to results
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => IDResultScreen(
          idInfo: Map<String, String>.from(_idInfo),
          imagePaths: List<String>.from(_capturedPaths),
        ),
      ),
    ).then((_) {
      // When user returns from result screen, restart scanning
      _restartScanning();
    });
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
              onPressed: () {
                Navigator.of(context).pop();
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

  @override
  void dispose() {

    _controller?.dispose();
    _textRecognizer.close();
    _frameProcessor?.cancel();
    _borderColorTimer?.cancel();
    _stepTimeout?.cancel();
    _countdownTimer?.cancel();
    _wrongSideWarningTimer?.cancel();
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Scan ID - Step ${_currentStep + 1}/${_steps.length}"),  actions: [
        // Add restart button to app bar
        IconButton(
          onPressed: _showRestartConfirmation,
          icon: Icon(Icons.refresh),
          tooltip: "Restart Scanning",
        ),
      ],),
      body: _isCameraInitialized
          ? Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller),
          _buildOverlayFrame(),
          _buildStepText(),
          _buildTipText(),
          _buildTimeoutCounter(), // New timeout counter
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
                    onPressed: () {
                      Navigator.of(context).pop();
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
      )
          : Center(child: CircularProgressIndicator()),
    );
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