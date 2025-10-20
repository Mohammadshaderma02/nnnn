//PostpaidIdentificationSelfRecording.dart
// Dynamic eKYC Video Recording Screen for Postpaid flows

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:camera/camera.dart';
import 'package:http/io_client.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';

/// Dynamic eKYC Video Recording Screen
/// 
/// This screen can be used across multiple postpaid flows (GSM, FTTH, etc.)
/// 
/// **Parameters:**
/// - `onVideoRecorded`: Callback when video is successfully recorded and uploaded
/// - `sessionUid`: eKYC session UID for API calls
/// - `ekycToken`: Authorization token for eKYC APIs
/// - `cameras`: Available camera list
/// - `returnRoute`: Optional custom route to navigate after success
/// 
/// **Usage Example:**
/// ```dart
/// Navigator.push(
///   context,
///   MaterialPageRoute(
///     builder: (context) => PostpaidIdentificationSelfRecording(
///       sessionUid: globalVars.sessionUid,
///       ekycToken: globalVars.ekycTokenID,
///       cameras: await availableCameras(),
///       onVideoRecorded: (videoPath, videoHash) {
///         // Handle success - navigate to next screen
///         Navigator.pushReplacement(
///           context,
///           MaterialPageRoute(
///             builder: (context) => ContractScreen(...),
///           ),
///         );
///       },
///     ),
///   ),
/// );
/// ```
class PostpaidIdentificationSelfRecording extends StatefulWidget {
  final Function(String videoPath, String videoHash) onVideoRecorded;
  final String sessionUid;
  final String ekycToken;
  final List<CameraDescription> cameras;
  final Widget returnRoute; // Optional custom return route

  PostpaidIdentificationSelfRecording({
    @required this.onVideoRecorded,
    @required this.sessionUid,
    @required this.ekycToken,
    this.cameras,
    this.returnRoute,
  });

  @override
  _PostpaidIdentificationSelfRecordingState createState() =>
      _PostpaidIdentificationSelfRecordingState();
}

class _PostpaidIdentificationSelfRecordingState
    extends State<PostpaidIdentificationSelfRecording> {
  String _currentVideoHash;
  String _currentVideoFingerprint;
  APP_URLS urls = new APP_URLS();

  /*------------------------Video Recording Variables--------------------------*/
  CameraController _controller;
  bool _isRecording = false;
  bool _isInitialized = false;
  bool _isPreparingRecording = false;
  bool _isUploading = false;
  String _currentVideoPath;

  Timer _recordingTimer;
  Timer _instructionTimer;
  Timer _countdownTimer;

  String _currentInstruction = '';
  List<String> _instructions = [
    'Blink your eyes',
    'Turn your head left',
    'Turn your head right',
    'Smile'
  ];
  int _currentInstructionIndex = 0;
  int _countdown = 3;
  bool _showCountdown = false;
  String _videoPath = '';
  String _errorMessage = '';

  String _previousVideoPath;
  int _recordingCounter = 0;
  bool isLoading = false;
  
  // SMS Liveness state variables
  bool _isCheckingStatus = false;
  bool _smsLivenessSent = false;
  bool _livenessCompleted = false;
  String _livenessStatus = '';
  Timer _statusCheckTimer;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  @override
  void dispose() {
    _completeCleanup();
    super.dispose();
  }

  // Complete cleanup method
  Future<void> _completeCleanup() async {
    try {
      print('🧹 Starting complete cleanup...');

      // Cancel all timers first
      _countdownTimer?.cancel();
      _instructionTimer?.cancel();
      _recordingTimer?.cancel();
      _statusCheckTimer?.cancel();

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
          _currentVideoHash = null;
          _currentVideoFingerprint = null;
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

  // Initialize camera
  Future<void> _initializeCamera() async {
    print('🎥 Initializing camera with full cleanup...');

    // Clear all streams before initialization
    await _clearAllStreamsBeforeRecording();

    // Wait for system to stabilize
    await Future.delayed(Duration(milliseconds: 500));

    // Check if widget is still mounted
    if (!mounted) {
      print('❌ Widget unmounted during initialization');
      return;
    }

    // Set loading state
    setState(() {
      isLoading = true;
      _errorMessage = '';
    });

    try {
      // Request camera permission
      final status = await Permission.camera.request();
      if (status != PermissionStatus.granted) {
        setState(() {
          _errorMessage = 'Camera permission denied';
          isLoading = false;
        });
        return;
      }

      // Get available cameras
      List<CameraDescription> cameras =
          widget.cameras ?? await availableCameras();

      if (cameras.isEmpty) {
        setState(() {
          _errorMessage = 'No cameras available on this device';
          isLoading = false;
        });
        return;
      }

      // Find front camera
      final frontCamera = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
        orElse: () => cameras.first,
      );

      // Create camera controller
      _controller = CameraController(
        frontCamera,
        ResolutionPreset.high,
        enableAudio: true,
      );

      // Initialize controller
      await _controller.initialize();

      if (!mounted) return;

      setState(() {
        _isInitialized = true;
        isLoading = false;
      });

      print('✅ Camera initialized successfully');
    } catch (e) {
      print('❌ Camera initialization error: $e');
      if (mounted) {
        setState(() {
          _errorMessage = 'Failed to initialize camera: ${e.toString()}';
          isLoading = false;
        });
      }
    }
  }

  // Clear all streams before recording
  Future<void> _clearAllStreamsBeforeRecording() async {
    print('🧹 Clearing all streams before recording...');

    // Cancel existing timers
    _countdownTimer?.cancel();
    _instructionTimer?.cancel();
    _recordingTimer?.cancel();

    // Delete previous video if exists
    await _deleteCurrentVideoFile();

    // Wait for cleanup
    await Future.delayed(Duration(milliseconds: 300));

    print('✅ All streams cleared');
  }

  // Delete current video file
  Future<void> _deleteCurrentVideoFile() async {
    if (_currentVideoPath != null && _currentVideoPath.isNotEmpty) {
      try {
        final file = File(_currentVideoPath);
        if (await file.exists()) {
          await file.delete();
          print('🗑️ Deleted current video: $_currentVideoPath');
        }
      } catch (e) {
        print('Error deleting current video: $e');
      }
    }
    _currentVideoPath = null;
    _currentVideoHash = null;
  }

  // Clear all video files
  Future<void> _clearAllVideoFiles() async {
    try {
      final directory = await getTemporaryDirectory();
      final videoFiles = directory
          .listSync()
          .where((file) =>
              file.path.contains('ekyc_video') && file.path.endsWith('.mp4'))
          .toList();

      for (var file in videoFiles) {
        try {
          await file.delete();
          print('🗑️ Deleted old video: ${file.path}');
        } catch (e) {
          print('Error deleting file ${file.path}: $e');
        }
      }
    } catch (e) {
      print('Error clearing video files: $e');
    }
  }

  // Start recording with countdown
  Future<void> _startRecordingWithCountdown() async {
    if (!_isInitialized || _isRecording || _isPreparingRecording) {
      print('⚠️ Cannot start recording - state check failed');
      return;
    }

    // Clear previous recording
    await _clearAllStreamsBeforeRecording();

    setState(() {
      _isPreparingRecording = true;
      _showCountdown = true;
      _countdown = 3;
      _errorMessage = '';
    });

    // Countdown timer
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_countdown > 0) {
        setState(() {
          _countdown--;
        });
      } else {
        timer.cancel();
        _startRecording();
      }
    });
  }

  // Start actual recording
  Future<void> _startRecording() async {
    if (!_isInitialized || _isRecording) return;

    try {
      setState(() {
        _showCountdown = false;
        _isPreparingRecording = false;
      });

      // Create unique file path
      final directory = await getTemporaryDirectory();
      _recordingCounter++;
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      _currentVideoPath =
          '${directory.path}/ekyc_video_${timestamp}_$_recordingCounter.mp4';

      print('📹 Starting recording to: $_currentVideoPath');

      await _controller.startVideoRecording(_currentVideoPath);

      setState(() {
        _isRecording = true;
        _currentInstructionIndex = 0;
      });

      // Start instructions
      _showInstructions();

      // Auto-stop after 15 seconds
      _recordingTimer = Timer(Duration(seconds: 15), () {
        _stopRecording();
      });
    } catch (e) {
      print('❌ Error starting recording: $e');
      setState(() {
        _errorMessage = 'Failed to start recording: ${e.toString()}';
        _isRecording = false;
        _isPreparingRecording = false;
      });
    }
  }

  // Show instructions during recording
  void _showInstructions() {
    _instructionTimer = Timer.periodic(Duration(seconds: 3), (timer) {
      if (_currentInstructionIndex < _instructions.length && _isRecording) {
        setState(() {
          _currentInstruction = _instructions[_currentInstructionIndex];
          _currentInstructionIndex++;
        });
      } else {
        timer.cancel();
      }
    });
  }

  // Stop recording
  Future<void> _stopRecording() async {
    if (!_isRecording) return;

    try {
      print('⏹️ Stopping recording...');

      _recordingTimer?.cancel();
      _instructionTimer?.cancel();

      final videoFile = await _controller.stopVideoRecording();

      setState(() {
        _isRecording = false;
        _currentInstruction = '';
        _videoPath = _currentVideoPath;
      });

      print('✅ Recording stopped successfully');
      print('📁 Video saved at: $_videoPath');

      // Calculate video hash
      await _calculateVideoHash(_videoPath);

      // Upload video automatically
      await _uploadVideo();
    } catch (e) {
      print('❌ Error stopping recording: $e');
      setState(() {
        _errorMessage = 'Failed to stop recording: ${e.toString()}';
        _isRecording = false;
      });
    }
  }

  // Calculate video hash
  Future<void> _calculateVideoHash(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes);
      _currentVideoHash = digest.toString();
      _currentVideoFingerprint = digest.toString().substring(0, 16);
      print('🔒 Video hash: $_currentVideoHash');
    } catch (e) {
      print('Error calculating hash: $e');
    }
  }

  // Upload video to eKYC Liveness API
  Future<void> _uploadVideo() async {
    if (_videoPath.isEmpty) {
      print('❌ No video path available');
      return;
    }

    setState(() {
      _isUploading = true;
      _errorMessage = '';
      isLoading = true;
    });

    try {
      final file = File(_videoPath);
      if (!await file.exists()) {
        throw Exception('Video file does not exist');
      }

      print('📤 Uploading video to eKYC Liveness API...');
      print('Session UID: ${widget.sessionUid}');
      print('National ID: ${globalVars.natinalityNumber}');

      // Create HTTP client
      final client = createHttpClient();

      // Create multipart request - CORRECT API ENDPOINT
      final uri = Uri.parse(
          'https://079.jo/wid/api/v1/consumer/session/${widget.sessionUid}/liveness');
      final request = http.MultipartRequest('POST', uri);

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer ${widget.ekycToken}'
        // Don't set Content-Type manually for multipart requests
      });

      // Add required fields as per API specification
      request.fields['extension'] = 'webm';
      request.fields['partIndex'] = '1';
      request.fields['nationalId'] = globalVars.natinalityNumber != null && globalVars.natinalityNumber != '' 
          ? globalVars.natinalityNumber 
          : '';
      request.fields['close'] = 'true';

      print('📝 Request fields:');
      print('  extension: webm');
      print('  partIndex: 1');
      print('  nationalId: ${request.fields['nationalId']}');
      print('  close: true');

      // Add the video file
      var multipartFile = await http.MultipartFile.fromPath(
        'file', // Field name is 'file' not 'video'
        _videoPath,
        filename: 'self_recorded_video.webm',
      );

      request.files.add(multipartFile);

      // Send request with timeout
      print('🚀 Sending liveness video upload request...');
      final streamedResponse = await client.send(request).timeout(Duration(seconds: 60));

      print('📥 Upload response status: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 200) {
        String responseBody = await streamedResponse.stream.bytesToString();
        print('📥 Upload response body: $responseBody');

        Map<String, dynamic> successResponse = jsonDecode(responseBody);
        print('Success flag: ${successResponse["success"]}');

        String successMessage = EasyLocalization.of(context).locale == Locale("en", "US")
            ? successResponse['message']["en"]
            : successResponse['message']["ar"];

        if (successResponse["success"] == true) {
          print('✅ Liveness video uploaded successfully!');

          setState(() {
            _isUploading = false;
            isLoading = false;
            globalVars.isValidLivness = true;
          });

          // Show success message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: Colors.green,
            ),
          );

          // Call success callback with video path and hash
          widget.onVideoRecorded(_videoPath, _currentVideoHash);
        } else {
          // API returned success: false
          print('❌ Liveness check failed');
          
          setState(() {
            _isUploading = false;
            isLoading = false;
            _errorMessage = successMessage;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(successMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        // Non-200 status code
        String responseBody = await streamedResponse.stream.bytesToString();
        print('❌ Upload failed with status: ${streamedResponse.statusCode}');
        print('Response body: $responseBody');

        setState(() {
          _isUploading = false;
          isLoading = false;
        });

        try {
          Map<String, dynamic> errorResponse = jsonDecode(responseBody);
          String errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
              ? errorResponse['message']["en"]
              : errorResponse['message']["ar"];

          setState(() {
            _errorMessage = errorMessage;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        } catch (parseError) {
          print('Error parsing error response: $parseError');
          setState(() {
            _errorMessage = 'Upload failed: ${streamedResponse.statusCode}\n$responseBody';
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Upload failed: ${streamedResponse.statusCode}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }

      client.close();
    } catch (e) {
      print('❌ Error uploading video: $e');
      setState(() {
        _isUploading = false;
        isLoading = false;
        _errorMessage = 'Failed to upload video: ${e.toString()}';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Failed to upload video. Please try again.'
                : 'فشل تحميل الفيديو. يرجى المحاولة مرة أخرى.',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Retake video
  Future<void> _retakeVideo() async {
    await _clearAllStreamsBeforeRecording();
    setState(() {
      _videoPath = '';
      _currentVideoHash = null;
      _errorMessage = '';
    });
  }

  // Create HTTP client helper
  IOClient createHttpClient() {
    HttpClient httpClient = HttpClient()
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
    return IOClient(httpClient);
  }
  
  // Show dialog to enter MSISDN for SMS liveness
  void _showSendSMSDialog() {
    TextEditingController msisdnController = TextEditingController();
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
              ? "Send Liveness Link via SMS"
              : "إرسال رابط التحقق عبر SMS",
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Enter customer's mobile number to send the liveness link"
                  : "أدخل رقم هاتف العميل لإرسال رابط التحقق",
            ),
            SizedBox(height: 20),
            TextField(
              controller: msisdnController,
              keyboardType: TextInputType.phone,
              maxLength: 10,
              decoration: InputDecoration(
                labelText: EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Mobile Number (MSISDN)"
                    : "رقم الهاتف",
                hintText: "07xxxxxxxx",
                helperText: EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Must start with 07 and be 10 digits"
                    : "يجب أن يبدأ بـ 07 ويتكون من 10 أرقام",
                border: OutlineInputBorder(),
                counterText: "", // Hide character counter
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Cancel"
                  : "إلغاء",
            ),
          ),
          ElevatedButton(
            onPressed: () {
              String msisdn = msisdnController.text.trim();
              
              // Validation: Check if empty
              if (msisdn.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Please enter a mobile number"
                          : "الرجاء إدخال رقم الهاتف",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              // Validation: Check length (must be 10 digits)
              if (msisdn.length != 10) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Mobile number must be 10 digits"
                          : "يجب أن يكون رقم الهاتف 10 أرقام",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              // Validation: Must start with 07
              if (!msisdn.startsWith('07')) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Mobile number must start with 07"
                          : "يجب أن يبدأ رقم الهاتف بـ 07",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              // Validation: Must contain only digits
              if (!RegExp(r'^[0-9]+$').hasMatch(msisdn)) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Mobile number must contain only digits"
                          : "يجب أن يحتوي رقم الهاتف على أرقام فقط",
                    ),
                    backgroundColor: Colors.red,
                  ),
                );
                return;
              }
              
              Navigator.pop(context);
              _sendSMSLiveness(msisdn);
            },
            style: ElevatedButton.styleFrom(primary: Color(0xFF4f2565)),
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Send SMS"
                  : "إرسال",
            ),
          ),
        ],
      ),
    );
  }
  
  // Send SMS with liveness link
  Future<void> _sendSMSLiveness(String msisdn) async {
    setState(() {
      isLoading = true;
    });
    
    try {
      print('📤 Sending SMS liveness link...');
      print('MSISDN: $msisdn');
      print('Session UID: ${widget.sessionUid}');
      
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final uri = Uri.parse(urls.BASE_URL + '/Postpaid/SendSMSVideoEkyc');
      
      final response = await http.post(
        uri,
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs.getString("accessToken"),
        },
        body: jsonEncode({
          "msisdn": msisdn,
          "sessionId": widget.sessionUid,
        }),
      );
      
      print('📥 SMS API response status: ${response.statusCode}');
      print('📥 SMS API response body: ${response.body}');
      
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        
        if (result['status'] == 0) {
          setState(() {
            isLoading = false;
            _smsLivenessSent = true;
            _isCheckingStatus = true;
          });
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "SMS sent successfully! Checking liveness status..."
                    : "تم إرسال الرسالة بنجاح! جاري فحص حالة التحقق...",
              ),
              backgroundColor: Colors.green,
            ),
          );
          
          // Start checking status every 5 seconds
          _startStatusChecking();
        } else {
          setState(() {
            isLoading = false;
          });
          
          String errorMessage = EasyLocalization.of(context).locale == Locale("en", "US")
              ? result['message'] ?? 'Failed to send SMS'
              : result['messageAr'] ?? 'فشل إرسال الرسالة';
          
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(errorMessage),
              backgroundColor: Colors.red,
            ),
          );
        }
      } else {
        setState(() {
          isLoading = false;
        });
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Failed to send SMS. Please try again."
                  : "فشل إرسال الرسالة. يرجى المحاولة مرة أخرى.",
            ),
            backgroundColor: Colors.red,
          ),
        );
      }
    } catch (e) {
      print('❌ Error sending SMS: $e');
      setState(() {
        isLoading = false;
      });
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Error: ${e.toString()}"
                : "خطأ: ${e.toString()}",
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
  
  // Start checking liveness status periodically
  void _startStatusChecking() {
    // Check immediately
    _checkLivenessStatus();
    
    // Then check every 5 seconds
    _statusCheckTimer = Timer.periodic(Duration(seconds: 5), (timer) {
      _checkLivenessStatus();
    });
  }
  
  // Check liveness status from external API
  Future<void> _checkLivenessStatus() async {
    try {
      print('🔍 Checking liveness status...');
      
      final uri = Uri.parse(
          'https://dsc.jo.zain.com/eKYC/api/Lines/session/${widget.sessionUid}');
      
      final response = await http.get(
        uri,
        headers: {
          'X-API-KEY': '37375383-f46b-41d4-a79c-a4a4c2f8b1e4',
        },
      );
      
      print('📥 Status check response: ${response.statusCode}');
      
      if (response.statusCode == 200) {
        var result = jsonDecode(response.body);
        
        if (result['status'] == 0 && result['data'] != null) {
          String status = result['data']['status'] ?? '';
          bool livenessAccepted = result['data']['session']['livenessAccepted'] ?? false;
          
          print('Current status: $status');
          print('Liveness accepted: $livenessAccepted');
          
          setState(() {
            _livenessStatus = status;
          });
          
          // If status is not "working", liveness is complete
          if (status != "working" || livenessAccepted) {
            print('✅ Liveness completed!');
            
            setState(() {
              _livenessCompleted = true;
              _isCheckingStatus = false;
              globalVars.isValidLivness = true;
            });
            
            // Stop the timer
            _statusCheckTimer?.cancel();
            
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Liveness verification completed successfully!"
                      : "تم التحقق من الهوية بنجاح!",
                ),
                backgroundColor: Colors.green,
              ),
            );
          }
        }
      }
    } catch (e) {
      print('❌ Error checking status: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _completeCleanup();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "eKYC Video Recording"
                : "تسجيل فيديو التحقق الإلكتروني",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color(0xFF4f2565),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () async {
              await _completeCleanup();
              Navigator.pop(context);
            },
          ),
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: Color(0xFF4f2565)),
              )
            : _buildBody(),
      ),
    );
  }

  Widget _buildBody() {
    if (_errorMessage.isNotEmpty) {
      return _buildErrorView();
    }

    if (_videoPath.isNotEmpty && !_isUploading) {
      return _buildSuccessView();
    }

    return _buildCameraView();
  }

  Widget _buildErrorView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, color: Colors.red, size: 60),
            SizedBox(height: 20),
            Text(
              _errorMessage,
              style: TextStyle(color: Colors.white, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _errorMessage = '';
                });
                _initializeCamera();
              },
              style: ElevatedButton.styleFrom(primary: Color(0xFF4f2565)),
              child: Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle, color: Colors.green, size: 80),
            SizedBox(height: 20),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Video Recorded Successfully!"
                  : "تم تسجيل الفيديو بنجاح!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _retakeVideo,
                  style: ElevatedButton.styleFrom(primary: Colors.orange),
                  child: Text('Retake'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraView() {
    if (!_isInitialized) {
      return Center(
        child: CircularProgressIndicator(color: Color(0xFF4f2565)),
      );
    }

    return Stack(
      children: [
        // Camera preview
        Positioned.fill(
          child: CameraPreview(_controller),
        ),

        // Countdown overlay
        if (_showCountdown)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Text(
                  _countdown.toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 120,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

        // Recording indicator
        if (_isRecording)
          Positioned(
            top: 20,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Recording...',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Current instruction
        if (_isRecording && _currentInstruction.isNotEmpty)
          Positioned(
            bottom: 150,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.7),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  _currentInstruction,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

        // Uploading indicator
        if (_isUploading)
          Positioned.fill(
            child: Container(
              color: Colors.black54,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(color: Colors.white),
                    SizedBox(height: 20),
                    Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Uploading video..."
                          : "جاري تحميل الفيديو...",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
          ),

        // Status checking indicator
        if (_isCheckingStatus)
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    ),
                    SizedBox(width: 15),
                    Expanded(
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? "Waiting for customer to complete liveness..."
                            : "في انتظار إكمال العميل للتحقق...",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        
        // Control buttons
        if (!_isRecording && !_isPreparingRecording && !_isUploading)
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Start Recording Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _startRecordingWithCountdown,
                    style: ElevatedButton.styleFrom(
                      primary: Color(0xFF4f2565),
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.videocam, size: 28),
                        SizedBox(width: 10),
                        Text(
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? "Record Video Here"
                              : "تسجيل الفيديو هنا",
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 15),
                // OR Divider
                Row(
                  children: [
                    Expanded(child: Divider(color: Colors.white, thickness: 1)),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? "OR"
                            : "أو",
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.white, thickness: 1)),
                  ],
                ),
                SizedBox(height: 15),
                // Send SMS Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _smsLivenessSent ? null : _showSendSMSDialog,
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.sms, size: 28),
                        SizedBox(width: 10),
                        Text(
                          _smsLivenessSent
                              ? (EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? "SMS Sent - Waiting..."
                                  : "تم الإرسال - في الانتظار...")
                              : (EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? "Send Link via SMS"
                                  : "إرسال رابط عبر SMS"),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
                // Show Next button if liveness completed via SMS
                if (_livenessCompleted)
                  Padding(
                    padding: EdgeInsets.only(top: 15),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // Call success callback
                          widget.onVideoRecorded('', '');
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.blue,
                          padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.arrow_forward, size: 28),
                            SizedBox(width: 10),
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? "Next"
                                  : "التالي",
                              style: TextStyle(fontSize: 18),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),

        // Stop button during recording
        if (_isRecording)
          Positioned(
            bottom: 40,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton(
                onPressed: _stopRecording,
                style: ElevatedButton.styleFrom(
                  primary: Colors.red,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.stop, size: 30),
                    SizedBox(width: 10),
                    Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "Stop Recording"
                          : "إيقاف التسجيل",
                      style: TextStyle(fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
