//IdentificationSelfRecording.dart

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Ekyc/EKYC_Colors/ekyc_colors.dart';
import 'package:path/path.dart' as path;
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
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
import '../../../../../../Shared/BaseUrl.dart';
import '../../../../../../blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import '../../../../../../blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import '../../../../../../blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:crypto/crypto.dart';

class IdentificationSelfRecording extends StatefulWidget {
  final Function onStepChanged;
  final List<CameraDescription> cameras;
  IdentificationSelfRecording({ this.onStepChanged,this.cameras});
  @override
  _IdentificationSelfRecordingState createState() => _IdentificationSelfRecordingState();
}

class _IdentificationSelfRecordingState extends State<IdentificationSelfRecording> {
  String _currentVideoHash;
  String _currentVideoFingerprint;

  APP_URLS urls = new APP_URLS();
  bool simTypeData= false;
  bool simTypeGSM= false;

  int selectedNumber = -1; // Initialize with an invalid index

  String selected = "";
  bool isGSMSelected = true;
  bool isDATASelected = false;



  int selectedItemIndex;
  bool isLoading=false;

  TextEditingController _merchantID = TextEditingController();
  TextEditingController _terminalID = TextEditingController();
  TextEditingController otp = TextEditingController();

  bool emptyMerchantID = false;
  bool emptyTerminalID = false;
  bool emptyOTP = false;

  /*------------------------The following variable for record video--------------------------*/
  CameraController _controller;
  bool _isRecording = false;
  bool _isInitialized = false;
  bool _isPreparingRecording = false;
  bool _isUploading = false; // Add upload state
  String _currentVideoPath;

  Timer _recordingTimer;
  Timer _instructionTimer;
  Timer _countdownTimer;

  String _currentInstruction = '';
  List<String> _instructions = ['Blink your eyes', 'Turn your head left', 'Turn your head right', 'Smile'];
  int _currentInstructionIndex = 0;
  int _countdown = 3;
  bool _showCountdown = false;
  String _videoPath = '';
  String _errorMessage = '';


  String _previousVideoPath; // Track previous video for cleanup
  int _recordingCounter = 0; // Add counter for unique naming



  // STEP 1: Complete cleanup method

  Future<void> _completeCleanup() async {
    try {
      print('🧹 Starting complete cleanup...');

      // Cancel all timers first
      _countdownTimer?.cancel();
      _instructionTimer?.cancel();
      _recordingTimer?.cancel();

      // Stop recording if active
      if (_controller != null && _isRecording) {
        try {
          await _controller.stopVideoRecording();
          await Future.delayed(Duration(milliseconds: 500));
        } catch (e) {
          print('Error stopping recording during cleanup: $e');
        }
      }

      // Dispose camera controller
      if (_controller != null) {
        await _controller.dispose();
        _controller = null;
      }

      // Delete current video file
      await _deleteCurrentVideoFile();

      // Clear all video files in the directory
      await _clearAllVideoFiles();

      // Reset state
      if (mounted) {
        setState(() {

          _currentVideoHash = null;        // NEW: Clear hash
          _currentVideoFingerprint = null;
          _currentVideoPath = null;
          _currentVideoHash = null;
          _currentVideoPath = null;
          _isInitialized = false;
          _isRecording = false;
          _isUploading = false;
          _isPreparingRecording = false;
          _showCountdown = false;
          _currentInstructionIndex = 0;
          _recordingCounter = 0;
          _errorMessage = '';
        });
      }

      print('✅ Complete cleanup finished');
    } catch (e) {
      print('Error in complete cleanup: $e');
    }
  }


  // STEP 2: Initialize camera
  Future<void> _initializeCamera() async {
    print('🎥 Initializing camera with full cleanup...');

    // Step 1: Clear all streams before initialization
    await _clearAllStreamsBeforeRecording();

    // Step 2: Wait for system to stabilize
    await Future.delayed(Duration(milliseconds: 500));

    // Step 3: Check if widget is still mounted
    if (!mounted) {
      print('❌ Widget unmounted during initialization');
      return;
    }

    // Step 4: Set loading state
    setState(() {
      isLoading = true;
      _errorMessage = '';
    });

    try {
      // Step 5: Request camera permission
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        setState(() {
          _errorMessage = 'Camera permission denied';
          isLoading = false;
        });
        return;
      }

      // Step 6: Get available cameras
      List<CameraDescription> cameras = widget.cameras ?? await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras available on this device';
          isLoading = false;
        });
        return;
      }

      // Step 7: Find front camera
      CameraDescription frontCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Step 8: Initialize camera controller with fresh instance
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      // Step 9: Initialize camera
      await _controller.initialize();

      // Step 10: Update state if still mounted
      if (mounted) {
        setState(() {
          _isInitialized = true;
          _currentInstruction = _instructions.isNotEmpty ? _instructions[0] : '';
          _errorMessage = '';
          isLoading = false;
        });

        print('✅ Camera initialized successfully');

        // Step 11: Start liveness test
        _startLivenessTest();
      }

    } catch (e) {
      print('❌ Camera initialization error: $e');

      if (mounted) {
        setState(() {
          _errorMessage = 'Camera initialization error: $e';
          isLoading = false;
        });
      }
    }
  }

  // STEP 3: Start liveness test
  void _startLivenessTest() {
    if (!_isInitialized || _isRecording) return;

    setState(() {
      _showCountdown = true;
    });

    int countdown = 3;
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (countdown > 0) {
        countdown--;
      } else {
        timer.cancel();
        _startRecording();
      }
    });
  }

  // STEP 4: Start recording with proper path management
  Future<void> _startRecording() async {
    print('🎬 Starting recording with enhanced path management...');

    // Ensure we're in a clean state
    if (!_isInitialized || _isRecording || _isPreparingRecording) {
      print('❌ Cannot start recording - invalid state');
      return;
    }

    // Clear any existing video files and reset current path
    await _clearAllVideoFiles();
    _currentVideoPath = null;

    // Wait for cleanup to complete
    await Future.delayed(Duration(milliseconds: 500));

    setState(() {
      _isPreparingRecording = true;
      _showCountdown = false;
    });

    try {
      // Generate a truly unique video path
      final String videoPath = await _generateUniqueVideoPathAsync();

      print('🎬 Generated unique path: $videoPath');

      // Verify the path is available
      final File videoFile = File(videoPath);
      if (await videoFile.exists()) {
        await videoFile.delete();
        print('🗑️ Removed existing file at path');
      }

      // Start recording with the unique path
      await _controller.startVideoRecording(videoPath);

      // IMPORTANT: Store the path IMMEDIATELY after successful start
      _currentVideoPath = videoPath;

      // Update state ONLY after successful recording start
      if (mounted) {
        setState(() {
          _isRecording = true;
          _isPreparingRecording = false;
          _currentInstructionIndex = 0;
          _currentInstruction = _instructions[0];
        });
      }

      print('✅ Recording started successfully with path: $videoPath');
      print('📍 Current video path stored: $_currentVideoPath');

      // Start instruction timer
      _instructionTimer = Timer.periodic(Duration(seconds: 1), (timer) {
        if (_currentInstructionIndex < _instructions.length - 1) {
          setState(() {
            _currentInstructionIndex++;
            _currentInstruction = _instructions[_currentInstructionIndex];
          });
        } else {
          timer.cancel();
        }
      });

      // Auto-stop recording after 5 seconds
      _recordingTimer = Timer(Duration(seconds: 5), () {
        _stopRecording();
      });

    } catch (e) {
      print('❌ Recording error: $e');
      if (mounted) {
        setState(() {
          _isRecording = false;
          _isPreparingRecording = false;
          _errorMessage = 'Recording error: $e';
          _currentVideoPath = null;
        });
      }
    }
  }

  // STEP 5: Stop recording and upload
  Future<void> _stopRecording() async {
    if (!_isRecording || _currentVideoPath == null) {
      print('❌ Cannot stop recording - invalid state');
      print('❌ _isRecording: $_isRecording');
      print('❌ _currentVideoPath: $_currentVideoPath');
      return;
    }

    // Capture the current video path IMMEDIATELY
    final String videoPathForUpload = _currentVideoPath;
    print('🛑 Stopping recording for path: $videoPathForUpload');

    try {
      // Stop recording
      await _controller.stopVideoRecording();

      // Cancel timers
      _recordingTimer?.cancel();
      _instructionTimer?.cancel();

      // Wait for file to be completely written
      await Future.delayed(Duration(milliseconds: 2000)); // Increased wait time

      // Update UI state
      if (mounted) {
        setState(() {
          _isRecording = false;
          _currentInstructionIndex = 0;
          _currentInstruction = _instructions[0];
          _isInitialized = false;
          // Keep _currentVideoPath for upload verification
        });
      }

      // Debug: Check if file exists and get its details
     // await _debugVideoFile(videoPathForUpload);

      // Verify the file exists before upload
      final File videoFile = File(videoPathForUpload);
      if (!await videoFile.exists()) {
        throw Exception('Video file not found after recording: $videoPathForUpload');
      }

      final int fileSize = await videoFile.length();
      if (fileSize == 0) {
        throw Exception('Video file is empty after recording: $videoPathForUpload');
      }

      print('✅ Recording stopped successfully');
      print('📊 File size: $fileSize bytes');
      print('📁 File path: $videoPathForUpload');

      // Upload the specific video file
      await _verifyAndUploadVideo(videoPathForUpload);

    } catch (e) {
      print('❌ Stop recording error: $e');
      if (mounted) {
        setState(() {
          _isRecording = false;
          _errorMessage = 'Stop recording error: $e';
        });
      }
    }
  }

// STEP 6: Verify and upload video
  Future<void> _verifyAndUploadVideo(String videoPath) async {
    try {
      print('🔍 Verifying video file: $videoPath');

      // Verification logic remains the same
      final File videoFile = File(videoPath);
      if (!await videoFile.exists()) {
        throw Exception('Video file not found: $videoPath');
      }

      int fileSize = await videoFile.length();
      if (fileSize == 0) {
        throw Exception('Video file is empty: $videoPath');
      }

      // File stability check
      await Future.delayed(Duration(milliseconds: 1000));
      int newFileSize = await videoFile.length();
      if (newFileSize != fileSize) {
        await Future.delayed(Duration(milliseconds: 2000));
        newFileSize = await videoFile.length();

      }

      // NEW: Generate hash and fingerprint for file verification
      final Uint8List videoBytes = await videoFile.readAsBytes();
      final String fileHash = VideoHashVerifier.generateMD5Hash(videoBytes);
      final String fingerprint = VideoHashVerifier.generateFingerprint(videoBytes);

      // Store hash in state for later verification
      _currentVideoHash = fileHash;
      _currentVideoFingerprint = fingerprint;

      print('✅ Video verification passed');
      print('📊 Final file size: $newFileSize bytes');
      print('🔐 File MD5 hash: $fileHash');
      print('👆 File fingerprint: $fingerprint');


      // Start upload using blob method
      if (mounted) {
        setState(() {
          _isUploading = true;
          isLoading = true;
        });
      }

      // Choose your preferred method:
      // Method 1: Using http package (blob-style)
      await _uploadVideo(videoPath, fileHash);

      // OR Method 2: Using Dio (more similar to axios)
      // await _uploadVideoAsBlobWithDio(videoPath);

    } catch (e) {
      print('❌ Video verification failed: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Video verification failed: $e';
          isLoading = false;
          _isUploading = false;
        });
      }
    }
  }

  Future<void> _uploadVideo(String videoPath, String expectedHash) async {
    if (videoPath == null || videoPath.isEmpty) {
      throw Exception('Invalid video path provided for upload');
    }

    print('📤 Starting video upload with hash verification...');
    print('📁 Video path: $videoPath');
    print('🔐 Expected hash: $expectedHash');

    final File videoFile = File(videoPath);
    if (!await videoFile.exists()) {
      throw Exception('Video file does not exist: $videoPath');
    }

    // Read file directly without chunking
    final Uint8List videoBytes = await videoFile.readAsBytes();
    if (videoBytes.isEmpty) {
      throw Exception('Video file is empty: $videoPath');
    }

    // Remove this hash verification - it's redundant
    // final String currentHash = VideoHashVerifier.generateMD5Hash(videoBytes);
    // if (currentHash != expectedHash) {
    //   throw Exception('File hash mismatch - file may have been corrupted or changed');
    // }

    await uploadVideoBytes(videoBytes, videoPath, expectedHash); // Use the expected hash
  }

  Future<void> uploadVideoBytes(Uint8List videoBytes, String videoPath, String fileHash) async {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final int random = DateTime.now().microsecond % 10000;
    final String uniqueId = '${timestamp}_${random}';

    final client = createHttpClient();

    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/liveness')
      );

      request.headers.addAll({
        'Authorization': "Bearer ${globalVars.ekycTokenID}",
        'Content-Type': 'multipart/form-data',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Connection': 'close',
      });

      request.fields['extension'] = 'webm';
      request.fields['partIndex'] = '1';
      request.fields['nationalId'] = '1234';
      request.fields['close'] = 'true';
      // Add hash as a field for server-side verification (optional)
      request.fields['fileHash'] = fileHash;
      request.fields['fileFingerprint'] = _currentVideoFingerprint ?? '';

      var multipartFile = http.MultipartFile.fromBytes(
        'file', // Make sure this matches your API expectation
        videoBytes,
        filename: 'liveness_${uniqueId}.webm',
        contentType: MediaType('video', 'webm'),
      );

      request.files.add(multipartFile);

      print('📤 Uploading video: ${videoBytes.length} bytes');
      print('📤 Filename: liveness_${uniqueId}.webm');
      print('🔐 Upload hash: $fileHash');
      print('👆 Upload fingerprint: ${_currentVideoFingerprint}');

      var response = await client.send(request).timeout(Duration(seconds: 60));
      await _handleUploadResponse(response, videoPath, uniqueId, fileHash);

    } catch (e) {
      print('❌ Video upload error: $e');
      if (mounted) {
        setState(() {
          isLoading = false;

        });
      }
      _showErrorDialog('Upload error: $e');
    }
  }

  // STEP 8: Handle upload response
  Future<void> _handleUploadResponse(http.StreamedResponse response, String videoPath, String uploadId, String originalHash) async {
    if (mounted) {
      setState(() {
        isLoading = false;
        _isUploading = false;
      });
    }

    String responseBody = await response.stream.bytesToString();

    print('📥 Blob upload response received:');
    print('  Upload ID: $uploadId');
    print('  Status Code: ${response.statusCode}');
    print('  Original Hash: $originalHash');
    print('  Response Body: $responseBody');
    // Final file verification before processing response
    final File videoFile = File(videoPath);
    if (await videoFile.exists()) {
      try {
        final Uint8List finalBytes = await videoFile.readAsBytes();
        final String finalHash = VideoHashVerifier.generateMD5Hash(finalBytes);

        if (finalHash == originalHash) {
          print('✅ Final hash verification passed: $finalHash');
        } else {
          print('⚠️ Hash mismatch detected: expected $originalHash, got $finalHash');
        }
      } catch (e) {
        print('❌ Error during final hash verification: $e');
      }
    }

    try {
      Map<String, dynamic> responseData = jsonDecode(responseBody);

      // Check for error messages first
      if (responseData['errorMessageEn'] != null && responseData['errorMessageAr'] != null) {
        final errorMessageEn = responseData['errorMessageEn'];
        final errorMessageAr = responseData['errorMessageAr'];

        final errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
            ? errorMessageEn
            : errorMessageAr;

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage), backgroundColor: Colors.red)
        );

        if (mounted) {
          setState(() {
            globalVars.isValidLivness = false;
          });
        }
        return;
      }

      // Handle success/failure
      if (response.statusCode == 200 && responseData["success"] == true) {
        print('✅ Blob upload successful with hash verification');

        // Fix: Handle message properly - it's already a Map
        dynamic messageData = responseData['message'];
        String message;

        if (messageData is Map) {
          message = EasyLocalization.of(context).locale == Locale("en", "US")
              ? messageData["en"] ?? 'Upload successful'
              : messageData["ar"] ?? 'Upload successful';
        } else {
          message = messageData?.toString() ?? 'Upload successful';
        }

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.green)
        );

        if (mounted) {
          setState(() {
            globalVars.isValidLivness = true;
          });
        }
        // Log successful upload with hash info
        print('🎯 Upload completed successfully');
        print('🔐 File hash: $originalHash');
        print('👆 File fingerprint: ${_currentVideoFingerprint}');
        // Continue flow
        if (globalVars.isEsim == true) {
          _handleShowDialog();
        } else {
          validateEKYC_API();
        }
      } else {
        print('❌ Blob upload failed');

        if (mounted) {
          setState(() {
            globalVars.isValidLivness = false;
          });
        }

        // Fix: Handle message properly
        dynamic messageData = responseData['message'];
        String message;

        if (messageData is Map) {
          message = EasyLocalization.of(context).locale == Locale("en", "US")
              ? messageData["en"] ?? 'Upload failed'
              : messageData["ar"] ?? 'Upload failed';
        } else {
          message = messageData?.toString() ?? 'Upload failed';
        }

        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message), backgroundColor: Colors.red)
        );
      }
    } catch (e) {
      print('❌ Error parsing response: $e');
      _showErrorDialog('Server response error');
      if (mounted) {
        setState(() {
          globalVars.isValidLivness = false;
        });
      }
    }

    // Clean up
    await _deleteVideoFile(videoPath);
    if (mounted) {
      setState(() {
        _currentVideoPath = null;
        _currentVideoHash = null;
        _currentVideoFingerprint = null;
      });
    }
  }

  Future<void> saveRequestData(http.MultipartRequest request, String uniqueId, int fileSize) async {
    try {
      final directory = await getApplicationDocumentsDirectory();
      final logsDir = Directory('${directory.path}/apilogs');

  // Create logs directory if it doesn't exist
  if (!await logsDir.exists()) {
    await logsDir.create(recursive: true);
  }

  final requestFile = File('${logsDir.path}/request_${uniqueId}.json');

  // Create request data map
  final requestData = {
    'timestamp': DateTime.now().toIso8601String(),
    'method': request.method,
    'url': request.url.toString(),
    'headers': request.headers,
    'fields': request.fields,
    'files': request.files.map((file) => {
      'field': file.field,
      'filename': file.filename,
      'contentType': file.contentType?.toString(),
      'length': file.length,
    }).toList(),
    'totalFileSize': fileSize,
  };

  // Write to file
  await requestFile.writeAsString(
    JsonEncoder.withIndent('  ').convert(requestData),
    encoding: utf8,
  );

  print('✅ Request data saved to: ${requestFile.path}');
  } catch (e) {
    print('❌ Error saving request data: $e');
  }
  }

  // Save to Downloads folder (most accessible)
  Future<void> _saveToDownloads(String jsonString, String uniqueId) async {
    try {
      // Try multiple download paths
      final downloadPaths = [
        '/storage/emulated/0/Download',
        '/sdcard/Download',
        '/storage/sdcard0/Download',
      ];

      for (String downloadPath in downloadPaths) {
        try {
          final downloadsDir = Directory(downloadPath);
          if (await downloadsDir.exists()) {
            final logsDir = Directory('${downloadsDir.path}/ApiLogs');

            // Create logs directory if it doesn't exist
            if (!await logsDir.exists()) {
              await logsDir.create(recursive: true);
            }

            final requestFile = File('${logsDir.path}/request_${uniqueId}.json');
            await requestFile.writeAsString(jsonString, encoding: utf8);

            print('✅ Request data saved to Downloads: ${requestFile.path}');
            print('🔍 You can find this file in: Downloads/ApiLogs/request_${uniqueId}.json');
            return; // Success, exit the loop
          }
        } catch (e) {
          print('❌ Failed to save to $downloadPath: $e');
          continue; // Try next path
        }
      }

      print('❌ Could not find accessible Downloads directory');
    } catch (e) {
      print('❌ Error saving to Downloads: $e');
    }
  }



  // STEP 9: File management methods
  Future<void> _deleteCurrentVideoFile() async {
    if (_currentVideoPath != null) {
      await _deleteVideoFile(_currentVideoPath);
      _currentVideoPath = null;
    }
  }

  Future<void> _deleteVideoFile(String videoPath) async {
    if (videoPath == null || videoPath.isEmpty) return;

    try {
      final File file = File(videoPath);
      if (await file.exists()) {
        await file.delete();
        print('🗑️ Deleted video file: $videoPath');
      } else {
        print('⚠️ Video file not found for deletion: $videoPath');
      }
    } catch (e) {
      print('❌ Could not delete video file: $videoPath, error: $e');
    }
  }

  // STEP 10: Error handling
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }


  void _showErrorAPIDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
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
                globalVars.isValidLivness = false;
              });
              Navigator.pop(context);

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      Menu(Permessions:globalVars.permessionsChangePackage,role: globalVars.roleChangePackage,outDoorUserName: globalVars.outDoorUserNameChangePackage),

                ),
              );
            },
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  // STEP 11: Retry mechanism
  void _retryRecording() {
    print('🔄 Retrying recording...');
    print('🔄 Current state - Recording: $_isRecording, Path: $_currentVideoPath');

    // Complete cleanup before retry
    _completeCleanup().then((_) {
      // Wait longer for cleanup to complete
      Future.delayed(Duration(milliseconds: 1500), () {
        if (mounted) {
          print('🔄 Initializing camera after cleanup...');
          _initializeCamera();
        }
      });
    });
  }

  String _generateUniqueVideoPath() {
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String randomSuffix = (DateTime.now().microsecond % 10000).toString();
    final String processId = (++_recordingCounter).toString().padLeft(3, '0');

    return '${getApplicationDocumentsDirectory().then((dir) => dir.path)}/liveness_${processId}_${timestamp}_${randomSuffix}.mp4';
  }

  Future<String> _generateUniqueVideoPathAsync() async {
    final Directory appDocDir = await getApplicationDocumentsDirectory();
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final String randomSuffix = (DateTime.now().microsecond % 10000).toString();
    final String processId = (++_recordingCounter).toString().padLeft(3, '0');

    // Ensure the directory exists
    if (!await appDocDir.exists()) {
      await appDocDir.create(recursive: true);
    }

    final String videoPath = '${appDocDir.path}/liveness_${processId}_${timestamp}_${randomSuffix}.mp4';

    // Ensure the file doesn't already exist
    final File testFile = File(videoPath);
    if (await testFile.exists()) {
      await testFile.delete();
      print('🗑️ Deleted existing file: $videoPath');
    }

    return videoPath;
  }

  Future<void> _clearAllStreamsBeforeRecording() async {
    print('🧹 Starting comprehensive stream cleanup...');

    try {
      // 1. Cancel all active timers first
      _countdownTimer?.cancel();
      _countdownTimer = null;

      _instructionTimer?.cancel();
      _instructionTimer = null;

      _recordingTimer?.cancel();
      _recordingTimer = null;

      print('✅ All timers cancelled');

      // 2. Stop any active recording immediately
      if (_controller != null && _isRecording) {
        try {
          await _controller.stopVideoRecording();
          print('✅ Active recording stopped');

          // Small delay to ensure recording has fully stopped
          await Future.delayed(Duration(milliseconds: 300));
        } catch (e) {
          print('⚠️ Warning: Error stopping active recording: $e');
        }
      }

      // 3. Dispose camera controller to free camera stream
      if (_controller != null) {
        try {
          await _controller.dispose();
          _controller = null;
          print('✅ Camera controller disposed');
        } catch (e) {
          print('⚠️ Warning: Error disposing camera controller: $e');
        }
      }

      // 4. Clear all temporary and cached video files
      await _clearAllVideoFiles();

      // 5. Clear any cached camera streams/buffers
      await _clearCameraStreamBuffers();

      // 6. Reset all state variables
      if (mounted) {
        setState(() {
          _currentVideoPath = null;
          _videoPath = '';
          _isInitialized = false;
          _isRecording = false;
          _isUploading = false;
          _isPreparingRecording = false;
          _showCountdown = false;
          _currentInstructionIndex = 0;
          _recordingCounter = 0;
          _errorMessage = '';
          _currentInstruction = _instructions.isNotEmpty ? _instructions[0] : '';
        });
      }

      // 7. Force garbage collection to free memory
      await _forceGarbageCollection();

      // 8. Add delay to ensure all streams are fully cleared
      await Future.delayed(Duration(milliseconds: 1000));

      print('✅ Stream cleanup completed successfully');

    } catch (e) {
      print('❌ Error during stream cleanup: $e');
      // Don't throw - continue with recording attempt
    }
  }


  // STEP 2: Enhanced video file clearing
  Future<void> _clearAllVideoFiles() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      if (await appDocDir.exists()) {
        final List<FileSystemEntity> files = appDocDir.listSync();

        for (FileSystemEntity file in files) {
          if (file is File && (file.path.contains('liveness_') || file.path.contains('CAM_'))) {
            try {
              await file.delete();
              print('🗑️ Deleted old video file: ${file.path}');
            } catch (e) {
              print('Could not delete file: ${file.path}, error: $e');
            }
          }
        }
      }
    } catch (e) {
      print('Error clearing video files: $e');
    }
  }

// Method to clear camera stream buffers
  Future<void> _clearCameraStreamBuffers() async {
    try {
      print('🧽 Clearing camera stream buffers...');

      // Clear temporary directories that might contain camera streams
      final directories = [
        await getTemporaryDirectory(),
        await getApplicationCacheDirectory(),
      ];

      for (final dir in directories) {
        if (await dir.exists()) {
          final files = dir.listSync();

          for (final file in files) {
            if (file is File) {
              final fileName = path.basename(file.path).toLowerCase();

              // Clear camera-related temporary files
              if (fileName.contains('camera') ||
                  fileName.contains('video') ||
                  fileName.contains('stream') ||
                  fileName.contains('buffer') ||
                  fileName.contains('capture') ||
                  fileName.startsWith('vid_') ||
                  fileName.startsWith('img_') ||
                  file.path.endsWith('.tmp') ||
                  file.path.endsWith('.cache')) {

                try {
                  await file.delete();
                  print('🧽 Cleared buffer: ${path.basename(file.path)}');
                } catch (e) {
                  // Ignore errors for files in use
                  print('⚠️ Could not clear buffer: ${file.path}');
                }
              }
            }
          }
        }
      }

      print('✅ Camera stream buffers cleared');

    } catch (e) {
      print('❌ Error clearing camera buffers: $e');
    }
  }

// Force garbage collection to free memory
  Future<void> _forceGarbageCollection() async {
    try {
      print('🔄 Forcing garbage collection...');

      // Trigger garbage collection multiple times to ensure cleanup
      for (int i = 0; i < 3; i++) {
        await Future.delayed(Duration(milliseconds: 100));
        // Note: Dart doesn't have explicit GC, but creating pressure can help
        List<int> tempList = List.filled(1000, 0);
        tempList.clear();
      }

      print('✅ Garbage collection completed');

    } catch (e) {
      print('⚠️ Error during garbage collection: $e');
    }
  }



// Updated clear temporary camera files method
  Future<void> _clearTemporaryCameraFiles() async {
    try {
      final directories = [
        await getTemporaryDirectory(),
        await getApplicationCacheDirectory(),
      ];

      for (final dir in directories) {
        if (await dir.exists()) {
          final files = dir.listSync();
          for (final file in files) {
            if (file is File &&
                (file.path.contains('camera') ||
                    file.path.contains('video') ||
                    file.path.contains('VID_') ||
                    file.path.contains('liveness_') ||
                    file.path.endsWith('.mp4') ||
                    file.path.endsWith('.mov'))) {
              try {
                await file.delete();
                print('Deleted temp camera file: ${file.path}');
              } catch (e) {
                // Ignore deletion errors for files in use
              }
            }
          }
        }
      }
    } catch (e) {
      print('Error clearing temporary camera files: $e');
    }
  }

  http.Client createHttpClient() {
    HttpClient httpClient = HttpClient();
    httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
      // Return true to ignore all certificate errors
      // WARNING: This should only be used in development!
      return true;
    };
    return IOClient(httpClient);
  }

  // Upload function - uploads MP4 but tells server to treat as WebM
  Future<void> recordAndUpload(String pathToUpload) async {
    print('Uploading video from path: $pathToUpload');


    if (pathToUpload.isEmpty || !File(pathToUpload).existsSync()) {
      _showErrorDialog('Video file not found');
      return;
    }

    // Verify this is actually the latest file by checking timestamp
    final file = File(pathToUpload);
    final fileStats = await file.stat();
    print('File last modified: ${fileStats.modified}');
    print('File size: ${fileStats.size} bytes');

    setState(() {
      _isInitialized = false; // Reset camera state
      _isUploading = true;
      isLoading = true;

    });

    final client = createHttpClient();
    try {
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/liveness')
      );

      request.headers.addAll({
        'Authorization': "Bearer ${globalVars.ekycTokenID}"
        // Don't set Content-Type manually for multipart requests
      });

      // Add JSON data as per API specification
      // Send fields directly
      request.fields['extension'] = 'webm';
      request.fields['partIndex'] = '1';
      request.fields['nationalId'] = '1234';
      request.fields['close'] = 'true';

      // Add JSON as a multipart field named 'data'
      //  request.fields['data'] = jsonEncode(jsonData);

      // Add the video file with a different field name
      var multipartFile = await http.MultipartFile.fromPath(
        'file', // Changed from 'data' to avoid conflict
        pathToUpload,
        filename: "self_recorded_video.webm",
      );

      request.files.add(multipartFile);
//
      // Send the request
      var response = await client.send(request).timeout(Duration(seconds: 60));

      if (response.statusCode == 200) {
        setState(() {
          isLoading = false;
          _isInitialized = false; // Reset camera state
        });

        String responseBody = await response.stream.bytesToString();
        print(response);
        print(responseBody);
        Map<String, dynamic> successResponse = jsonDecode(responseBody);
        print(successResponse["success"]);

        String successMessage = EasyLocalization.of(context).locale == Locale("en", "US")?successResponse['message']["en"]:successResponse['message']["ar"];

        if(successResponse["success"]==true){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?successMessage:successMessage),backgroundColor: Colors.green));
          setState(() {
            globalVars.isValidLivness=true;
          });
          if(globalVars.isEsim==true){
            _handleShowDialog();
          }
          else{
            submit_API();
          }



        }
        if(successResponse["success"]==false){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?successMessage:successMessage),backgroundColor: Colors.red));

        }


      }
      else {
        setState(() {
          isLoading = false;
          _isInitialized = false; // Reset camera state
        });
        String responseBody = await response.stream.bytesToString();
        try {
          Map<String, dynamic> errorResponse = jsonDecode(responseBody);
          print(errorResponse["success"]);
          String errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")?errorResponse['message']["en"]:errorResponse['message']["ar"];
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?errorMessage:errorMessage),backgroundColor: Colors.red));
        } catch (parseError) {
         // showErrorDialog('Upload failed: ${response.statusCode}\n$responseBody');
          print('Error: $responseBody');
        }
      }
    } on TimeoutException {
      setState(() {
        isLoading = false;
        _isUploading = false;
        _isInitialized = false;
      });
      _showErrorDialog(EasyLocalization.of(context).locale == Locale("en", "US")?'Upload timed out. Please try again.':'انتهى وقت التحميل. يُرجى المحاولة مرة أخرى.');
    } catch (e) {
      setState(() {
        isLoading = false;
        _isInitialized = false; // Reset camera state
      });
      print('Upload error: $e');
      _showErrorDialog('Upload error: $e');
    } finally {
      setState(() {
        isLoading = false;
        _isUploading = false;
        _isInitialized = false; // Reset camera state
      });
    }
  }

// Add this method to save video to gallery for verification
  Future<void> saveVideoToGallery(String videoPath) async {
    try {
      if (videoPath.isNotEmpty && File(videoPath).existsSync()) {
        await GallerySaver.saveVideo(videoPath);
        print('Video saved to gallery: $videoPath');
      }
    } catch (e) {
      print('Error saving video to gallery: $e');
    }
  }

// Method 2: Enhanced logging with file details
  Future<void> logVideoDetails(String videoPath) async {
    try {
      if (videoPath.isEmpty) {
        print('ERROR: Video path is empty');
        return;
      }

      final file = File(videoPath);
      if (!file.existsSync()) {
        print('ERROR: Video file does not exist at path: $videoPath');
        return;
      }

      final fileStats = await file.stat();
      final fileName = path.basename(videoPath);

      print('=== VIDEO FILE DETAILS ===');
      print('File Name: $fileName');
      print('Full Path: $videoPath');
      print('File Size: ${fileStats.size} bytes');
      print('Created: ${fileStats.changed}');
      print('Modified: ${fileStats.modified}');
      print('Accessed: ${fileStats.accessed}');
      print('========================');

      // Calculate duration if possible (requires video_player plugin)
      // await getVideoDuration(videoPath);
    } catch (e) {
      print('Error getting video details: $e');
    }
  }

// Method 3: List all videos in directory with timestamps
  Future<void> listAllVideosInDirectory() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      final files = appDocDir.listSync();

      List<FileSystemEntity> videoFiles = files.where((file) =>
      file is File &&
          (file.path.endsWith('.mp4') || file.path.endsWith('.mov')) &&
          file.path.contains('liveness_')
      ).toList();

      // Sort by modification time (newest first)
      videoFiles.sort((a, b) {
        final aFile = File(a.path);
        final bFile = File(b.path);
        return bFile.lastModifiedSync().compareTo(aFile.lastModifiedSync());
      });

      print('=== ALL LIVENESS VIDEOS ===');
      for (var file in videoFiles) {
        final fileObj = File(file.path);
        final stats = await fileObj.stat();
        final fileName = path.basename(file.path);

        print('File: $fileName');
        print('  Path: ${file.path}');
        print('  Size: ${stats.size} bytes');
        print('  Modified: ${stats.modified}');
        print('  ---');
      }
      print('==========================');
    } catch (e) {
      print('Error listing videos: $e');
    }
  }

// Method 4: Copy video to external storage for verification
  Future<void> copyVideoToExternalStorage(String videoPath) async {
    try {
      if (videoPath.isEmpty || !File(videoPath).existsSync()) {
        print('Cannot copy: Video file not found');
        return;
      }

      final fileName = path.basename(videoPath);
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final newFileName = 'debug_${timestamp}_$fileName';

      // Copy to Downloads directory (Android) or Documents (iOS)
      Directory externalDir;
      if (Platform.isAndroid) {
        externalDir = Directory('/storage/emulated/0/Download');
      } else if (Platform.isIOS) {
        externalDir = await getApplicationDocumentsDirectory();
      }

      if (externalDir != null && await externalDir.exists()) {
        final newPath = '${externalDir.path}/$newFileName';
        await File(videoPath).copy(newPath);
        print('Video copied to: $newPath');
      }
    } catch (e) {
      print('Error copying video: $e');
    }
  }
// Delete all video files method
  Future<void> _deleteAllVideoFiles() async {
    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();

      // Delete specific files
      List<String> pathsToDelete = [];

      if (_videoPath.isNotEmpty) {
        pathsToDelete.add(_videoPath);
      }

      if (_currentVideoPath != null && _currentVideoPath.isNotEmpty) {
        pathsToDelete.add(_currentVideoPath);
      }

      // Delete specific files
      for (String path in pathsToDelete) {
        if (path.isNotEmpty) {
          final File file = File(path);
          if (await file.exists()) {
            await file.delete();
            print('Deleted specific video file: $path');
          }
        }
      }

      // Also delete all liveness video files in the directory
      if (await appDocDir.exists()) {
        final files = appDocDir.listSync();
        for (final file in files) {
          if (file is File && file.path.contains('liveness_') &&
              (file.path.endsWith('.mp4') || file.path.endsWith('.mov'))) {
            try {
              await file.delete();
              print('Deleted liveness video file: ${file.path}');
            } catch (e) {
              print('Could not delete file: ${file.path}, error: $e');
            }
          }
        }
      }

      await _clearTemporaryCameraFiles();

    } catch (e) {
      print('Error deleting video files: $e');
    }
  }

  // STEP 7: Upload video
  /*Future<void> _uploadVideo(String videoPath) async {
    if (videoPath == null || videoPath.isEmpty) {
      throw Exception('Invalid video path provided for upload');
    }

    print('📤 Starting blob-style upload process...');
    print('📁 Video path: $videoPath');

    // Read video file as bytes (equivalent to blob)

    final File videoFile = File(videoPath);
    if (!await videoFile.exists()) {
      throw Exception('Video file does not exist: $videoPath');
    }

    //final List<int> videoBytes = await videoFile.readAsBytes();
    final Uint8List videoBytes = await File(videoPath).readAsBytes();
    if (videoBytes.isEmpty) {
      throw Exception('Video file is empty: $videoPath');
    }

    // Create unique identifiers
    final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    final int random = DateTime.now().microsecond % 10000;
    final String uniqueId = '${timestamp}_${random}';

    print('📊 Upload session details:');
    print('  Path: $videoPath');
    print('  Size: ${videoBytes.length} bytes');
    print('  Upload ID: $uniqueId');

    final client = createHttpClient();

    try {
      // Create multipart request
      var request = http.MultipartRequest(
          'POST',
          Uri.parse('https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/liveness')
      );

      // Add headers
      request.headers.addAll({
        'Authorization': "Bearer ${globalVars.ekycTokenID}",
        'Content-Type': 'multipart/form-data',
        'Cache-Control': 'no-cache, no-store, must-revalidate',
        'Connection': 'close',
      });

      // Add fields - using only the fields that worked in your original code
      request.fields['extension'] = 'webm';  // Use lowercase 'extension' from original
      request.fields['partIndex'] = '1';
      request.fields['nationalId'] = '1234';
      request.fields['close'] = 'true';

      // Create multipart file from bytes (blob equivalent)
      var multipartFile = http.MultipartFile.fromBytes(
        'file',  // Use 'file' field name from your original working code
        videoBytes,
        filename: 'liveness_${uniqueId}.webm',
        contentType: MediaType('video', 'webm'),
      );

      request.files.add(multipartFile);

      // Log request details
      print('📤 Request details:');
      print('  URL: ${request.url}');
      print('  Headers: ${request.headers}');
      print('  Fields: ${request.fields}');
      print('  File field: ${multipartFile.field}');
      print('  File name: ${multipartFile.filename}');
      print('  File size: ${multipartFile.length} bytes');

      // Send request
      print('📡 Sending blob-style request...');
      var response = await client.send(request).timeout(Duration(seconds: 60));

      print('📡 Request sent, processing response...');
      await _handleUploadResponse(response, videoPath, uniqueId);

    } catch (e) {
      print('❌ Blob upload error: $e');
      if (mounted) {
        setState(() {
          isLoading = false;
          _isUploading = false;
        });
      }
      _showErrorDialog('Upload error: $e');
    }
  }*/

  void validateEKYC_API() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/validateEkyc';
    final Uri url = Uri.parse(apiArea);

    var body = {
      "lineType": globalVars.lineType,
      "marketType": globalVars.marketType,
      "eKycUid": globalVars.sessionUid,
      "nationalNumber":globalVars.nationality==true? globalVars.natinalityNumber:"",
      "passportNumber":  globalVars.nationality==false?globalVars.cardNumber:"",
      "isJordanian": globalVars.nationality==false ? false : true,
    };
    print("validateEkyc body:");
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
        print("validateEkyc result:");
        print(result);
        if (result["status"] == 0) {
          setState(() {


          });
          submit_API();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"],),backgroundColor: Colors.red));
          _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"]);

        }

      } else {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?response.statusCode.toString(): response.statusCode.toString(),),backgroundColor: Colors.red));
        _showErrorAPIDialog(response.statusCode.toString());
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during API call: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.",),backgroundColor: Colors.red));
      _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.");


    }

  }

  void validate_otpEKYC_API() async {
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/validateEkyc';
    final Uri url = Uri.parse(apiArea);

    var body = {
      "lineType": globalVars.lineType,
      "marketType": globalVars.marketType,
      "eKycUid": globalVars.sessionUid,
      "nationalNumber":globalVars.nationality==true? globalVars.natinalityNumber:"",
      "passportNumber":  globalVars.nationality==false?globalVars.cardNumber:"",
      "isJordanian": globalVars.nationality==false ? false : true,
    };
    print("validateEkyc body:");
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
        print("validateEkyc result:");
        print(result);
        if (result["status"] == 0) {
          setState(() {


          });
          submitOTP_API();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"],),backgroundColor: Colors.red));
          _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"]);

        }

      } else {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?response.statusCode.toString(): response.statusCode.toString(),),backgroundColor: Colors.red));
        _showErrorAPIDialog(response.statusCode.toString());
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during API call: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.",),backgroundColor: Colors.red));

      _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.");

    }

  }

  void submit_API() async {

    String fullName = globalVars.fullNameEn ?? '';
    List<String> nameParts = fullName.split(' ');

// Accessing parts
    String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    String secondName = nameParts.length > 1 ? nameParts[1] : '';
    String thirdName = nameParts.length > 2 ? nameParts[2] : '';
    String lastName = nameParts.length > 3 ? nameParts[3] : '';

// Print results
    print("First Name: $firstName");
    print("Middle Name: $secondName");
    print("Last Name: $lastName");
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/submit';
    final Uri url = Uri.parse(apiArea);

    var body = {
      "msisdn": globalVars.numberSelected,
      "isJordanian": globalVars.nationality==false ? false : true,
      "nationalNo":globalVars.nationality==true? globalVars.natinalityNumber:"",
      "passportNo": globalVars.nationality==false?globalVars.cardNumber:"",
      "packageCode":"",
      "firstName": firstName,
      "secondName": secondName,
      "thirdName": thirdName,
      "lastName": lastName,
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
    print("submit_API body:");
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


            if ( globalVars.currentStep < 6) { // Ensure the last step is 6
              globalVars.currentStep++;
              widget.onStepChanged(); // Notify the parent widget to update value
              print(globalVars.currentScreenIndex);
              print(globalVars.currentStep);

            }
            getScreen();

            print("Next Step: ${globalVars.currentStep}");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"],),backgroundColor: Colors.red));
          _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"]);

        }

      } else {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?response.statusCode.toString(): response.statusCode.toString(),),backgroundColor: Colors.red));
        _showErrorAPIDialog(response.statusCode.toString());

      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during API call: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.",),backgroundColor: Colors.red));
      _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.");



    }

  }


  void initiatePayment_API() async {
    setState(() {
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/initiatePayment';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    var  boody={
      "msisdn": globalVars.numberSelected,
      "isJordanian": globalVars.nationality==false ? false : true,
      "nationalNo":globalVars.natinalityNumber,
      "passportNo":globalVars.cardNumber,
      "packageCode":  "",
      "merchantID": globalVars.merchantID,
      "terminalID":globalVars.terminalID,
    };

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body:jsonEncode({
        "msisdn": globalVars.numberSelected,
        "isJordanian": globalVars.nationality==false ? false : true,
        "nationalNo":globalVars.natinalityNumber,
        "passportNo":globalVars.cardNumber,
        "packageCode":  "",
        "merchantID": globalVars.merchantID,
        "terminalID":globalVars.terminalID,
      }),
    );
    print(boody);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      //showErroreAlertDialog(context,"401","401");
      setState(() {
        isLoading = false;
      });

    }
    if (statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      var result = json.decode(response.body);
      print(result["data"]);
      if (result["data"] == null) {}
      if (result["status"] == 0) {

        if(result['message']=="The Operation has been Successfully Completed"){
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (context) => AlertDialog(
              title: Text(
                "CustomerService.verify_code".tr().toString(),
                style: TextStyle(
                  color: Color(0xff11120e),
                  fontSize: 16,
                ),
              ),
              content: Container(
                width: double.maxFinite,
                height: 110,
                child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                  Expanded(
                      child: ListView(
                        // shrinkWrap: false,
                          physics: const NeverScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              width: double.maxFinite,
                              height: 50,
                              child: ListTile(
                                contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                                title: Text(
                                  "CustomerService.enter_OTP".tr().toString(),
                                  style: TextStyle(
                                    color: Color(0xff11120e),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 50,
                              child: ListTile(
                                contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 4),
                                title: TextField(
                                  controller: otp,
                                  keyboardType: TextInputType.phone,
                                  decoration: InputDecoration(
                                    enabledBorder: const OutlineInputBorder(
                                      // width: 0.0 produces a thin "hairline" border
                                      borderSide: const BorderSide(
                                          color: Color(0xFFD1D7E0), width: 1.0),
                                    ),
                                    border: const OutlineInputBorder(),
                                    focusedBorder: OutlineInputBorder(
                                      borderSide: const BorderSide(
                                          color: Color(0xFF4F2565), width: 1.0),
                                    ),
                                    contentPadding: EdgeInsets.all(16),
                                    hintText:
                                    "CustomerService.verify_hint".tr().toString(),
                                    hintStyle: TextStyle(
                                        color: Color(0xFFA4B0C1), fontSize: 14),
                                  ),
                                ),
                              ),
                            ),

                          ]))
                ]),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    otp.clear();
                    // Navigator.of(context).pop();
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    "CustomerService.Cancel".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF392156),
                      fontSize: 16,
                    ),
                  ),
                ),

                TextButton(
                  onPressed: () {
                    if (otp.text.trim().isEmpty) {
                      // Show an error (SnackBar or Alert inside dialog)
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? "Please enter the OTP"
                                : "يرجى إدخال رمز التحقق",
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return; // Do not close the dialog
                    }
                      globalVars.otp_ekyc= otp.text.trim();
                    // Proceed if not empty
                    validate_otpEKYC_API();
                    Navigator.pop(context, true);
                  },
                  child: Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")?"NEXT":"التالي",
                    style: TextStyle(
                      color: Color(0xFF392156),
                      fontSize: 16,
                    ),
                  ),
                ),

              ],
            ),
          );

          setState(() {
            isLoading = false;

          });
        }
      } else {

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"]),backgroundColor: Colors.red));
        _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"]);

        setState(() {
          isLoading = false;

        });
      }

      return result;
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString(): statusCode.toString()),backgroundColor: Colors.red));
      _showErrorAPIDialog(statusCode.toString());


      setState(() {
        isLoading = false;

      });
    }
  }


  showAlertDialogVerify(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.pop(context, true);
        // Navigator.pop(context, true);
        otp.clear();
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(

      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }


  Future<String> showPredefinedDialog(BuildContext context) {

    TextEditingController merchantID = TextEditingController();
    TextEditingController terminalID = TextEditingController();

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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Text(
                    EasyLocalization.of(context).locale == const Locale("en", "US")
                        ? "Pleas fill the following"
                        : "الرجاء ادخال المعلومات التالية",
                    style:  TextStyle(fontWeight: FontWeight.w600,fontSize: 14,),
                  ),
                  const SizedBox(height: 20),
                  Text("Merchant ID",
                    textAlign: TextAlign.start,
                    style:  TextStyle(fontWeight: FontWeight.normal,fontSize: 13,),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: merchantID,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "merchant ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: errorText,
                    ),
                    style:  TextStyle(fontSize: 12,),
                  ),

                  const SizedBox(height: 10),
                  Text("Terminal ID",
                    textAlign: TextAlign.start,
                    style:  TextStyle(fontWeight: FontWeight.normal,fontSize: 13,),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: terminalID,
                    maxLength: 10,
                    keyboardType: TextInputType.number,
                    maxLines: 1,
                    decoration: InputDecoration(
                      hintText: "terminal ID",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      errorText: errorText,
                    ),
                    style:  TextStyle(fontSize: 12),
                  ),


                  const SizedBox(height: 20),
                  // Next button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(

                    onPressed: () {
                        if (terminalID.text.trim().isEmpty) {
                          setState(() {
                            errorText =" enter terminalID";
                          });
                        }
                        if (merchantID.text.trim().isEmpty) {
                          setState(() {
                            errorText =" enter merchantID";
                          });
                        }

                        else {
                          globalVars.merchantID=merchantID.text.trim();
                          globalVars.terminalID=terminalID.text.trim();



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


  void _handleShowDialog() async {
    final result = await showPredefinedDialog(context);

    if (result == "reset") {
      setState(() {

      });
    } else if (result == "next") {
      setState(() {
        initiatePayment_API();
      });
    }
  }

  void submitOTP_API() async {

    String fullName = globalVars.fullNameEn ?? '';
    List<String> nameParts = fullName.split(' ');

// Accessing parts
    String firstName = nameParts.isNotEmpty ? nameParts[0] : '';
    String secondName = nameParts.length > 1 ? nameParts[1] : '';
    String thirdName = nameParts.length > 2 ? nameParts[2] : '';
    String lastName = nameParts.length > 3 ? nameParts[3] : '';

// Print results
    print("First Name: $firstName");
    print("Middle Name: $secondName");
    print("Last Name: $lastName");
    setState(() {
      isLoading = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/submit';
    final Uri url = Uri.parse(apiArea);

    var body = {
      "msisdn": globalVars.numberSelected,
      "isJordanian": globalVars.nationality==false ? false : true,
      "nationalNo":globalVars.nationality==true? globalVars.natinalityNumber:"",
      "passportNo": globalVars.nationality==false?globalVars.cardNumber:"",
      "packageCode":"",
      "firstName": firstName,
      "secondName": secondName,
      "thirdName": thirdName,
      "lastName": lastName,
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
      "otp": globalVars.otp_ekyc,
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
            if ( globalVars.currentStep < 6) { // Ensure the last step is 6
              globalVars.currentStep++;
              widget.onStepChanged(); // Notify the parent widget to update value
              print(globalVars.currentScreenIndex);
              print(globalVars.currentStep);

            }
            getScreen();

            print("Next Step: ${globalVars.currentStep}");
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"],),backgroundColor: Colors.red));

          _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]: result["messageAr"]);

        }

      } else {

        setState(() {
          isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?response.statusCode.toString(): response.statusCode.toString(),),backgroundColor: Colors.red));
        _showErrorAPIDialog(response.statusCode.toString());

      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error during API call: $e");
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.",),backgroundColor: Colors.red));
      _showErrorAPIDialog(EasyLocalization.of(context).locale == Locale("en", "US")?"Failed to submit the request. Please try again later.": "فشل إرسال الطلب. يُرجى المحاولة لاحقًا.");


    }

  }


  @override
  void dispose() {
    //_countdownTimer?.cancel();
    _controller?.dispose();
   // _recordingTimer?.cancel();
  //  _instructionTimer?.cancel();
    _completeCleanup();
    _clearAllStreamsBeforeRecording();

    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
    if(_isInitialized){
      return Stack(
        children: [
          Column(
            children: [
              Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      child: CameraPreview(_controller),
                    ),
                    // Overlay for face detection area
                   /* Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: CustomPaint(
                        painter: FaceOverlayPainter(),
                      ),
                    ),*/
                    // Countdown overlay
                    if (_showCountdown)
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: Colors.black54,
                        child: Center(
                          child: Text(
                            _countdown > 0 ? _countdown.toString() : 'GO!',
                            style: TextStyle(
                              fontSize: 72,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    // Recording indicator
                    if (_isRecording)
                      Positioned(
                        top: 20,
                        left: 20,
                        child: Container(
                          padding: EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.circle, color: Colors.white, size: 12),
                              SizedBox(width: 4),
                              Text('REC', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

            ],
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
      );
    }
    else{
      return Stack(
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
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")? "Identification self-recording": "تسجيل الهوية الذاتية",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black,
                          letterSpacing: 0,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: Container(
                        margin: EdgeInsets.symmetric(horizontal: 10),
                        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                        decoration: BoxDecoration(
                        //  color: Colors.white,
                          border: Border.all(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10),

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
                  globalVars.isValidLivness == false?
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
                          Text(EasyLocalization.of(context).locale == Locale("en", "US")?'Back':"رجوع", style: TextStyle(color: Colors.white)),
                        ],
                      ),
                    ),
                  ):Expanded(child: Text("-",style: TextStyle(color: Colors.white),)),
                  SizedBox(width: 16), // Space between buttons
                  globalVars.isValidLivness == false?
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        primary: Color(0xFFC92626),
                      ),
                      onPressed:() async{
                        // Cancel any existing timers
                        _countdownTimer?.cancel();
                        _instructionTimer?.cancel();
                        _recordingTimer?.cancel();

                        // Reset state
                        setState(() {
                          _isRecording = false;
                          _showCountdown = false;
                          _currentInstructionIndex = 0;
                          _currentInstruction = _instructions[_currentInstructionIndex];
                          _errorMessage = '';
                        });
                       _retryRecording();


                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.fiber_smart_record_rounded, color: Colors.white),
                          SizedBox(width: 8),
                          Text(EasyLocalization.of(context).locale == Locale("en", "US")? "Start Recording": "بدء التسجيل", style: TextStyle(color: Colors.white)),
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
        ],
      );
    }


  }
}


class FaceOverlayPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Color(0xFF0AC9B2)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) * 0.35;

    // Draw oval for face positioning
    canvas.drawOval(
      Rect.fromCenter(center: center, width: radius * 2, height: radius * 2.3),
      paint,
    );

    // Draw semi-transparent overlay
    final overlayPaint = Paint()
      ..color = Colors.black.withOpacity(0.3);

    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(Rect.fromCenter(center: center, width: radius * 2, height: radius * 2.3))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(path, overlayPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}



class VideoHashVerifier {
  static String generateMD5Hash(Uint8List bytes) {
    var digest = md5.convert(bytes);
    return digest.toString();
  }

  static String generateFingerprint(Uint8List bytes) {
    if (bytes.length < 200) {
      return bytes.toString();
    }

    // Take first 100 bytes and last 100 bytes
    final firstBytes = bytes.sublist(0, 100);
    final lastBytes = bytes.sublist(bytes.length - 100);
    final combined = [...firstBytes, ...lastBytes];

    return md5.convert(combined).toString();
  }
}

































