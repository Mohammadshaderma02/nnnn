


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

class LivenessScreen extends StatefulWidget {
  final List<CameraDescription> cameras;

  const LivenessScreen({Key key, this.cameras}) : super(key: key);

  @override
  _LivenessScreenState createState() => _LivenessScreenState();
}

class _LivenessScreenState extends State<LivenessScreen> {
  CameraController _controller;
  bool _isRecording = false;
  bool _isInitialized = false;
  Timer _recordingTimer;
  Timer _instructionTimer;
  String _currentInstruction = '';
  List<String> _instructions = ['Blink your eyes', 'Turn your head left', 'Turn your head right', 'Smile'];
  int _currentInstructionIndex = 0;
  int _countdown = 3;
  bool _showCountdown = false;
  String _videoPath = '';
  String _errorMessage = '';
  bool _isUploading = false; // Add upload state


  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    // Request camera permission
    final status = await Permission.camera.request();
    if (status != PermissionStatus.granted) {
      setState(() {
        _errorMessage = 'Camera permission denied';
      });
      return;
    }

    List<CameraDescription> cameras = widget.cameras;

    // If cameras list is null or empty, get available cameras
    if (cameras == null || cameras.isEmpty) {
      try {
        cameras = await availableCameras();
      } catch (e) {
        setState(() {
          _errorMessage = 'Error getting available cameras: $e';
        });
        return;
      }
    }

    if (cameras != null && cameras.isNotEmpty) {
      // Use front camera if available
      CameraDescription frontCamera;
      try {
        frontCamera = cameras.firstWhere(
              (camera) => camera.lensDirection == CameraLensDirection.front,
          orElse: () => cameras.first,
        );
      } catch (e) {
        frontCamera = cameras.first;
      }

      _controller = CameraController(
        frontCamera,
        ResolutionPreset.medium,
        enableAudio: true,
      );

      try {
        await _controller.initialize();
        setState(() {
          _isInitialized = true;
          _currentInstruction = _instructions[_currentInstructionIndex];
          _errorMessage = '';
        });
      } catch (e) {
        setState(() {
          _errorMessage = 'Camera initialization error: $e';
        });
      }
    } else {
      setState(() {
        _errorMessage = 'No cameras available on this device';
      });
    }
  }

  void _startLivenessTest() {
    if (!_isInitialized || _isRecording) return;

    setState(() {
      _showCountdown = true;
      _countdown = 3;
    });

    Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _countdown--;
      });

      if (_countdown <= 0) {
        timer.cancel();
        _startRecording();
      }
    });
  }

  void _startRecording() async {
    if (!_isInitialized || _isRecording) return;

    setState(() {
      _showCountdown = false;
      _isRecording = true;
    });

    try {
      final Directory appDocDir = await getApplicationDocumentsDirectory();
      _videoPath = '${appDocDir.path}/liveness_${DateTime.now().millisecondsSinceEpoch}.mp4';

      // Start video recording with file path
      await _controller.startVideoRecording(_videoPath);

      // Change instructions every second
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

      // Stop recording after 3 seconds
      _recordingTimer = Timer(Duration(seconds: 3), () {
        _stopRecording();
      });
    } catch (e) {
      print('Recording error: $e');
      setState(() {
        _isRecording = false;
        _errorMessage = 'Recording error: $e';
      });
    }
  }

  void _stopRecording() async {
    if (!_isRecording) return;

    try {
      await _controller.stopVideoRecording();
      _recordingTimer?.cancel();
      _instructionTimer?.cancel();

      setState(() {
        _isRecording = false;
        _currentInstructionIndex = 0;
        _currentInstruction = _instructions[_currentInstructionIndex];
      });

      // Show success dialog with video path
     // _showSuccessDialog(_videoPath);
      // Call recordAndUpload function with the recorded video
      await recordAndUpload(_videoPath);
    } catch (e) {
      print('Stop recording error: $e');
      setState(() {
        _isRecording = false;
        _errorMessage = 'Stop recording error: $e';
      });
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
  Future<void> recordAndUpload(String videoPath) async {
    if (videoPath.isEmpty || !File(videoPath).existsSync()) {
      _showErrorDialog('Video file not found');
      return;
    }

    setState(() {
      _isUploading = true;
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
        videoPath,
        filename: "self_recorded_video.webm",
      );

      request.files.add(multipartFile);

      // Send the request
      var response = await client.send(request);

      if (response.statusCode == 200) {
        _showSuccessDialog(videoPath);
      } else {
        String responseBody = await response.stream.bytesToString();
        _showErrorDialog('Upload failed: ${response.statusCode}\n$responseBody');
        print('Error: $responseBody');
      }
    } catch (e) {
      print('Upload error: $e');
      _showErrorDialog('Upload error: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  void _showErrorDialog(String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(error),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(String videoPath) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Liveness Test Complete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 64),
              SizedBox(height: 16),
              Text('Video recorded successfully!'),
              SizedBox(height: 8),
              Text('Path: $videoPath', style: TextStyle(fontSize: 12)),
              SizedBox(height: 16),
              Text('File exists: ${File(videoPath).existsSync()}',
                  style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _retryInitialization() {
    setState(() {
      _errorMessage = '';
      _isInitialized = false;
    });
    _initializeCamera();
  }

  @override
  void dispose() {
    _controller?.dispose();
    _recordingTimer?.cancel();
    _instructionTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage.isNotEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text('Liveness Detection')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red),
              SizedBox(height: 16),
              Text('Error: $_errorMessage',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _retryInitialization,
                child: Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (!_isInitialized) {
      return Scaffold(
        appBar: AppBar(title: Text('Liveness Detection')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing camera...'),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Liveness Detection'),
        backgroundColor: Colors.blue,
      ),
      body: Column(
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
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  child: CustomPaint(
                    painter: FaceOverlayPainter(),
                  ),
                ),
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
          Expanded(
            flex: 1,
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              color: Colors.grey[100],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _isRecording ? 'Follow the instruction:' : 'Position your face in the oval',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  SizedBox(height: 8),
                  if (_isRecording)
                    Text(
                      _currentInstruction,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _isRecording ? null : _startLivenessTest,
                    child: Text(_isRecording ? 'Recording...' : 'Start Liveness Test'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      textStyle: TextStyle(fontSize: 18),
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