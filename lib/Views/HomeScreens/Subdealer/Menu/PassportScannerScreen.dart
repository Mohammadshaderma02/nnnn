/*import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PassportScannerScreen extends StatefulWidget {
  @override
  _PassportScannerScreenState createState() => _PassportScannerScreenState();
}

class _PassportScannerScreenState extends State<PassportScannerScreen> {
  CameraController _controllerMRZ;
  bool _isCameraInitializedMRZ = false;
  int _currentStepMRZ = 0;
  final TextRecognizer _textRecognizerMRZ = TextRecognizer();
  Timer _frameProcessorMRZ;
  bool _isProcessingMRZ = false;
  List<String> _capturedPaths = [];

  // Add a border color state variable
  Color _borderColor = Colors.white;

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

  final List<String> _tips = [
    "Ensure the entire passport is visible",
    "Make sure the MRZ (bottom two lines) is clearly visible",
    "Avoid reflections and shadows on the passport",
    "Hold the camera steady for better results"
  ];

  int _tipIndexMRZ = 0;

  @override
  void initState() {
    super.initState();
    _initializeCameraMRZ();
    _startTipRotationMRZ();
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
      setState(() => _tipIndexMRZ = (_tipIndexMRZ + 1) % _tips.length);
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
      _borderColor = Colors.green;
    });

    // Set timer to change border back to white after 1.5 seconds
    _borderColorTimerMRZ = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColor = Colors.white;
        });
      }
    });
  }

  // Show failed validation with red border
  void _showFailedValidationMRZ() {
    _borderColorTimerMRZ?.cancel();

    setState(() {
      _borderColor = Colors.red;
    });

    _borderColorTimerMRZ = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColor = Colors.white;
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



      final inputImage = InputImage.fromFilePath(filePath);
      final recognizedText = await _textRecognizerMRZ.processImage(inputImage);

      bool isValidPassport = _validatePassportMRZ(recognizedText.text);

      if (isValidPassport) {
        _capturedPaths.add(filePath);

        // Show green border for successful validation
        _showSuccessfulValidationMRZ();

        if (mounted) {
          setState(() {
            if (_currentStepMRZ < _stepsMRZ.length - 1) {
              _currentStepMRZ++;
            } else {
              // If we're at the last step, proceed to results
              _frameProcessorMRZ?.cancel();
              _navigateToResultScreenMRZ();
            }
          });
        }
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PassportResultScreen(
          passportInfo: _passportInfo,
          imagePaths: _capturedPaths,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerMRZ?.dispose();
    _textRecognizerMRZ.close();
    _frameProcessorMRZ?.cancel();
    _borderColorTimerMRZ?.cancel(); // Cancel border color timer
    super.dispose();
  }

  Widget _buildOverlayFrame() {
    // Use 3:2 aspect ratio for passport (standard passport dimensions)
    return Center(
      child: Container(
        width: 320,
        height: 220, // Adjusted for passport dimensions (3:2 ratio plus extra for MRZ)
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Add a focus area specifically for the MRZ zone
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Center(
                child: Text(
                  "MRZ AREA",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
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
          _tips[_tipIndexMRZ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Passport Scanner")),
      body: _isCameraInitializedMRZ
          ? Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controllerMRZ),
          _buildOverlayFrame(),
          _buildStepTextMRZ(),
          _buildTipTextMRZ(),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
}

// Screen to display passport results and validations
class PassportResultScreen extends StatelessWidget {
  final Map<String, String> passportInfo;
  final List<String> imagePaths;

  const PassportResultScreen({
    Key key,
     this.passportInfo,
     this.imagePaths,
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

  Widget _buildImageGallery() {
    return Container(
      height: 220,
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
                height: 200,
                width: 300, // Match 3:2 passport ratio
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildVerificationStatus() {
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
}*/



/*import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PassportScannerScreen extends StatefulWidget {
  @override
  _PassportScannerScreenState createState() => _PassportScannerScreenState();
}

class _PassportScannerScreenState extends State<PassportScannerScreen> {
  CameraController _controllerMRZ;
  bool _isCameraInitializedMRZ = false;
  int _currentStepMRZ = 0;
  final TextRecognizer _textRecognizerMRZ = TextRecognizer();
  Timer _frameProcessorMRZ;
  bool _isProcessingMRZ = false;
  String _capturedImagePath;

  // Add a border color state variable
  Color _borderColor = Colors.white;

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

  final List<String> _tips = [
    "Ensure the entire passport is visible",
    "Make sure the MRZ (bottom two lines) is clearly visible",
    "Avoid reflections and shadows on the passport",
    "Hold the camera steady for better results"
  ];

  int _tipIndexMRZ = 0;

  @override
  void initState() {
    super.initState();
    _initializeCameraMRZ();
    _startTipRotationMRZ();
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
      setState(() => _tipIndexMRZ = (_tipIndexMRZ + 1) % _tips.length);
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
      _borderColor = Colors.green;
    });

    // Set timer to change border back to white after 1.5 seconds
    _borderColorTimerMRZ = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColor = Colors.white;
        });
      }
    });
  }

  // Show failed validation with red border
  void _showFailedValidationMRZ() {
    _borderColorTimerMRZ?.cancel();

    setState(() {
      _borderColor = Colors.red;
    });

    _borderColorTimerMRZ = Timer(Duration(milliseconds: 1500), () {
      if (mounted) {
        setState(() {
          _borderColor = Colors.white;
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

      if (!imageFile.existsSync()) {
        print("Image file doesn't exist at: $filePath");
        return;
      }

      final inputImage = InputImage.fromFilePath(filePath);
      final recognizedText = await _textRecognizerMRZ.processImage(inputImage);

      bool isValidPassport = _validatePassportMRZ(recognizedText.text);

      if (isValidPassport) {
        _capturedImagePath = filePath;

        // Show green border for successful validation
        _showSuccessfulValidationMRZ();

        if (mounted) {
          setState(() {
            if (_currentStepMRZ < _stepsMRZ.length - 1) {
              _currentStepMRZ++;
            } else {
              // If we're at the last step, proceed to results
              _frameProcessorMRZ?.cancel();
              _navigateToResultScreenMRZ();
            }
          });
        }
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
    bool hasDob = _extractWithContext(cleanedText, RegExp(r'Date of birth|Birth|DOB'), MRZ, 'dateOfBirth');
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PassportResultScreen(
          passportInfo: _passportInfo,
          imagePath: _capturedImagePath,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controllerMRZ?.dispose();
    _textRecognizerMRZ.close();
    _frameProcessorMRZ?.cancel();
    _borderColorTimerMRZ?.cancel(); // Cancel border color timer
    super.dispose();
  }

  Widget _buildOverlayFrame() {
    // Use 3:2 aspect ratio for passport (standard passport dimensions)
    return Center(
      child: Container(
        width: 320,
        height: 220, // Adjusted for passport dimensions (3:2 ratio plus extra for MRZ)
        decoration: BoxDecoration(
          border: Border.all(color: _borderColor, width: 3),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Add a focus area specifically for the MRZ zone
            Container(
              height: 60,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow, width: 2),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(6),
                  bottomRight: Radius.circular(6),
                ),
              ),
              child: Center(
                child: Text(
                  "MRZ AREA",
                  style: TextStyle(
                    color: Colors.yellow,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
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
          _tips[_tipIndexMRZ],
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Passport Scanner")),
      body: _isCameraInitializedMRZ
          ? Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controllerMRZ),
          _buildOverlayFrame(),
          _buildStepTextMRZ(),
          _buildTipTextMRZ(),
        ],
      )
          : Center(child: CircularProgressIndicator()),
    );
  }
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
            _buildVerificationStatus(),
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

  Widget _buildVerificationStatus() {
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
}*/


/*4-6 haya today*/
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

class PassportScannerScreen extends StatefulWidget {
  @override
  _PassportScannerScreenState createState() => _PassportScannerScreenState();
}

class _PassportScannerScreenState extends State<PassportScannerScreen> {
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

  @override
  void initState() {
    super.initState();
    _initializeCameraMRZ();
    _startTipRotationMRZ();
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
            _navigateToResultScreenMRZ();
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
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PassportResultScreen(
          passportInfo: _passportInfo,
          imagePath: _capturedImagePath,
        ),
      ),
    );
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

  @override
  void dispose() {
    _controllerMRZ?.dispose();
    _textRecognizerMRZ.close();
    _frameProcessorMRZ?.cancel();
    _borderColorTimerMRZ?.cancel(); // Cancel border color timer
    super.dispose();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Passport Scanner")),
      body: _isCameraInitializedMRZ
          ? Stack(
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
            _buildVerificationStatus(),
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

  Widget _buildVerificationStatus() {
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


