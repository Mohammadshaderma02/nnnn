# eKYC & Sanad Migration Guide
## Applying GSM Logic to BroadBand and FTTH Modules

---

## 📋 Overview

This guide provides step-by-step instructions for migrating the Sanad verification and eKYC document scanning logic from GSM modules to BroadBand and FTTH modules.

**Source Files** (Reference):
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_NationalityList.dart`
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_JordainianCustomerInformation.dart`
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_NonJordainianCustomerInformation.dart`

**Target Files** (To be updated):

**BroadBand:**
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_SelectNationality.dart`
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_Jordainian.dart`
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_NonJordanina.dart`

**FTTH:**
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/NationalityList.dart`
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/JordainianCustomerInformation.dart`
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/NonJordainianCustomerInformation.dart`

---

## 🎯 Components to Migrate

### 1. **State Variables**
### 2. **Import Statements**
### 3. **eKYC Token Generation**
### 4. **Sanad Verification**
### 5. **Camera Controllers**
### 6. **Document Processing**
### 7. **API Integration**
### 8. **UI Components**

---

## 📦 Part 1: Required Imports

Add these imports to your NationalityList files:

```dart
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:photo_view/photo_view.dart';
import 'package:http/http.dart' as http;
```

---

## 📦 Part 2: State Variables

Add these state variables to your `_NationalityListState` class:

```dart
class _NationalityListState extends State<NationalityList> {
  // ... existing variables ...
  
  // ✅ eKYC State Variables
  bool _bothSidesCaptured = false;
  bool showScanToggle = false;
  bool _loadImageFrontID = false;
  bool _loadImageBackID = false;
  bool _loadImageJordanianPassport = false;
  bool _LoadImageForeignPassport = false;
  bool _LoadImageTemporaryPassport = false;
  bool sanadVerificationFailed = false;
  Timer _autoCloseTimer;
  
  // eKYC Token
  String ekycTokenID = '';
  String sessionUid = '';
  String tokenUid = '';
  bool isEkycInitialized = false;
  
  // Next button logic
  String _lastValidatedNationalNo = '';
  bool _documentProcessingSuccess = false;
  bool _isCallingFromNextButton = false;
  
  // MRZ patterns for passport validation
  final RegExp _mrzFirstLinePattern = RegExp(r'P<[A-Z]{3}[A-Z<]{39}');
  final RegExp _mrzSecondLinePattern = RegExp(r'[A-Z0-9<]{44}');
  final RegExp _passportNumberPattern = RegExp(r'[A-Z0-9]{9}');
  final RegExp _namePatternMRZ = RegExp(r'[A-Z]+/[A-Z]+|[A-Z]+, [A-Z]+');
  final RegExp _datePatternMRZ = RegExp(r'\\d{2}[A-Z]{3}\\d{4}|\\d{2}/\\d{2}/\\d{4}|\\d{2}\\.\\d{2}\\.\\d{4}');
  
  // Image data
  String IDFront = '';
  String IDBack = '';
  String JordanianPassport = '';
  String ForeignPassport = '';
  String TemporaryPassport = '';
  
  // Sanad
  String redirectUrl;
  StreamSubscription _sub;
  BuildContext _dialogContext;
  
  // Camera controllers
  CameraController _controller;
  CameraController _controllerMRZ;
  CameraController _controllerTemporary;
  CameraController _controllerForeign;
  
  // Camera states
  bool _isCameraInitialized = false;
  bool _isCameraInitializedMRZ = false;
  bool _isCameraInitializedTemporary = false;
  bool _isCameraInitializedForeign = false;
  
  // Tips and steps for camera UI
  final List<String> _tipsForeign = [
    "Ensure the entire passport is visible",
    "Make sure the MRZ (bottom two lines) is clearly visible",
    "Avoid reflections and shadows on the passport",
    "Hold the camera steady for better results"
  ];
  
  final List<String> _stepsForeign = [
    "Position passport's MRZ (machine readable zone) in the frame",
    "Hold still while scanning...",
    "Processing passport data..."
  ];
  
  int _tipIndexMRZ = 0;
}
```

---

## 📦 Part 3: eKYC Token Generation

Add this method to generate eKYC tokens:

```dart
Future<void> generateEkycToken() async {
  final APP_URLS urls = APP_URLS();
  final client = createHttpClient();
  
  try {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    
    final response = await client.post(
      Uri.parse('${urls.base_url}/api/v1/token/generate'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      
      if (result['data'] != null) {
        setState(() {
          globalVars.ekycTokenID = result['data']['tokenId'] ?? '';
          globalVars.sessionUid = result['data']['sessionUid'] ?? '';
          globalVars.tokenUid = result['data']['tokenUid'] ?? '';
          isEkycInitialized = globalVars.ekycTokenID.isNotEmpty;
        });
        
        print('✅ eKYC Token Generated: ${globalVars.ekycTokenID}');
      }
    }
  } catch (e) {
    print('❌ eKYC Token Generation Error: $e');
    setState(() {
      isEkycInitialized = false;
    });
  } finally {
    client.close();
  }
}

HttpClient createHttpClient() {
  final client = HttpClient();
  client.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  return client;
}
```

---

## 📦 Part 4: Sanad Verification

Add Sanad verification method:

```dart
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
        globalVars.sanadValidation = true;
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
            
            // After Sanad completes, call PostValidateSubscriber API
            await Future.delayed(Duration(seconds: 2));
            
            setState(() {
              isloading = true;
              checkNationalDisabled = true;
            });
            
            // Call PostValidateSubscriber API
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
          }
        } else {
          setState(() {
            globalVars.sanadValidation = true;
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
      globalVars.sanadValidation = true;
      isloading = false;
      checkNationalDisabled = false;
    });
  }
}
```

---

## 📦 Part 5: Camera Initialization Methods

### For ID Scanning (Jordanian):

```dart
Future<void> _initializeCamera() async {
  if (!isEkycInitialized) {
    await generateEkycToken();
  }
  
  if (!isEkycInitialized) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("eKYC system not ready")),
    );
    return;
  }
  
  final cameras = await availableCameras();
  final backCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.back,
    orElse: () => cameras.first,
  );
  
  _controller = CameraController(
    backCamera,
    ResolutionPreset.high,
    enableAudio: false,
  );
  
  await _controller.initialize();
  
  setState(() {
    _isCameraInitialized = true;
  });
  
  _startIDCapture();
}
```

### For Jordanian Passport:

```dart
Future<void> _initializeCameraMRZ() async {
  if (!isEkycInitialized) {
    await generateEkycToken();
  }
  
  final cameras = await availableCameras();
  final backCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.back,
    orElse: () => cameras.first,
  );
  
  _controllerMRZ = CameraController(
    backCamera,
    ResolutionPreset.high,
    enableAudio: false,
  );
  
  await _controllerMRZ.initialize();
  
  setState(() {
    _isCameraInitializedMRZ = true;
  });
  
  _startMRZCapture();
}
```

### For Foreign Passport:

```dart
Future<void> _initializeCameraForeign() async {
  if (!isEkycInitialized) {
    await generateEkycToken();
  }
  
  final cameras = await availableCameras();
  final backCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.back,
    orElse: () => cameras.first,
  );
  
  _controllerForeign = CameraController(
    backCamera,
    ResolutionPreset.high,
    enableAudio: false,
  );
  
  await _controllerForeign.initialize();
  
  setState(() {
    _isCameraInitializedForeign = true;
  });
  
  _startForeignPassportCapture();
}
```

### For Temporary Passport:

```dart
Future<void> _initializeCameraTemporary() async {
  if (!isEkycInitialized) {
    await generateEkycToken();
  }
  
  final cameras = await availableCameras();
  final backCamera = cameras.firstWhere(
    (camera) => camera.lensDirection == CameraLensDirection.back,
    orElse: () => cameras.first,
  );
  
  _controllerTemporary = CameraController(
    backCamera,
    ResolutionPreset.high,
    enableAudio: false,
  );
  
  await _controllerTemporary.initialize();
  
  setState(() {
    _isCameraInitializedTemporary = true;
  });
  
  _startTemporaryPassportCapture();
}
```

---

## 📦 Part 6: BLoC Listener Updates

Update your BLoC listener to handle API responses:

```dart
Widget nationalNumber() {
  return BlocListener<PostValidateSubscriberBlock, PostValidateSubscriberState>(
    listener: (context, state) {
      if (state is PostValidateSubscriberErrorState) {
        setState(() {
          checkNationalDisabled = false;
          isloading = false;
          _isCallingFromNextButton = false;
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
          _isCallingFromNextButton = false;
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
        
        // Check if called from Next button or Check button
        if (_isCallingFromNextButton) {
          setState(() {
            _isCallingFromNextButton = false;
          });
          // Navigate directly
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => JordainianCustomerInformation(
                // ... parameters
              ),
            ),
          );
        } else {
          // Show dialog
          showAlertDialogSucssesJordanian(
            context, 
            state.arabicMessage, 
            state.englishMessage, 
            msisdn, 
            state.Username, 
            state.Password, 
            state.Price
          );
        }
      }
    },
    child: Column(
      // ... your UI
    ),
  );
}
```

---

## 📦 Part 7: UI Components for Document Scanning

### Jordanian - After Sanad Fails:

```dart
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
  
  Text(
    EasyLocalization.of(context).locale == Locale("en", "US")
        ? "Select Document Type"
        : "اختر نوع المستند",
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  ),
  SizedBox(height: 10),
  
  Row(
    children: [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: globalVars.tackID ? Color(0xFF4f2565) : Colors.white,
            onPrimary: globalVars.tackID ? Colors.white : Color(0xff636f7b),
          ),
          onPressed: () {
            setState(() {
              globalVars.tackID = true;
              globalVars.tackJordanPassport = false;
            });
            _initializeCamera();
          },
          child: Text("Scan ID / مسح الهوية"),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: globalVars.tackJordanPassport ? Color(0xFF4f2565) : Colors.white,
            onPrimary: globalVars.tackJordanPassport ? Colors.white : Color(0xff636f7b),
          ),
          onPressed: () {
            setState(() {
              globalVars.tackJordanPassport = true;
              globalVars.tackID = false;
            });
            _initializeCameraMRZ();
          },
          child: Text("Jordanian Passport / جواز سفر أردني"),
        ),
      ),
    ],
  ),
],
```

### Non-Jordanian - Passport Type Selection:

```dart
Text(
  EasyLocalization.of(context).locale == Locale("en", "US")
      ? "Select Passport Type"
      : "اختر نوع جواز السفر",
  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
),
SizedBox(height: 10),

Row(
  children: [
    Expanded(
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            globalVars.tackTemporary = true;
            globalVars.tackForeign = false;
          });
          if (!isEkycInitialized) {
            await generateEkycToken();
          }
          if (isEkycInitialized) {
            _initializeCameraTemporary();
          }
        },
        child: Text("Temporary Passport / جواز سفر مؤقت"),
      ),
    ),
    SizedBox(width: 10),
    Expanded(
      child: ElevatedButton(
        onPressed: () async {
          setState(() {
            globalVars.tackForeign = true;
            globalVars.tackTemporary = false;
          });
          if (!isEkycInitialized) {
            await generateEkycToken();
          }
          if (isEkycInitialized) {
            _initializeCameraForeign();
          }
        },
        child: Text("Foreign Passport / جواز سفر أجنبي"),
      ),
    ),
  ],
),
```

---

## 📦 Part 8: Success Dialogs

### Jordanian Success Dialog:

```dart
void showAlertDialogSucssesJordanian(BuildContext context, arabicMessage, englishMessage, msisdn, Username, Password, Price) {
  AlertDialog alert = AlertDialog(
    title: Text("Postpaid.OperationSuccess".tr().toString()),
    content: SingleChildScrollView(
      child: ListBody(
        children: <Widget>[
          Text("MSISDN: $msisdn"),
          Text("Price: $Price"),
        ],
      ),
    ),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Navigator.of(context).pop();
        },
        child: Text("Cancel"),
      ),
      TextButton(
        onPressed: () {
          Navigator.pop(context);
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
                price: price,
                isArmy: isArmy,
                showCommitmentList: showCommitmentList
              ),
            ),
          );
        },
        child: Text("Next"),
      ),
    ],
  );
  
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
```

---

## 🎯 Implementation Steps

### For Each Module (BroadBand & FTTH):

1. **Open the NationalityList file**
2. **Add all required imports** (Part 1)
3. **Add state variables** (Part 2)
4. **Add eKYC token generation** (Part 3)
5. **Add Sanad verification** (Part 4)
6. **Add camera initialization methods** (Part 5)
7. **Update BLoC listener** (Part 6)
8. **Add UI components** (Part 7)
9. **Add success dialogs** (Part 8)
10. **Update customer information screens** to accept all parameters

---

## ⚠️ Important Notes

1. **Market Type**: Ensure `marketType` variable matches your module ("BROADBAND" or "FTTH" instead of "GSM")
2. **Package Code**: Verify package codes are correct for each module
3. **Navigation**: Update navigation routes to use BroadBand/FTTH customer info screens
4. **Global Variables**: Ensure `globalVars` class has all required properties
5. **Testing**: Test each flow thoroughly after implementation

---

## 📚 Testing Checklist

For each module (BroadBand & FTTH):

### Jordanian Flow:
- [ ] Sanad verification succeeds → Shows dialog → Navigate
- [ ] Sanad verification fails → Shows scan options
- [ ] ID scan works and shows Next button
- [ ] Jordanian Passport scan works
- [ ] Next button after scan calls API and navigates

### Non-Jordanian Flow:
- [ ] Temporary passport scan works immediately
- [ ] Foreign passport scan works immediately
- [ ] Document images display correctly
- [ ] Next button appears after scan
- [ ] Navigation to customer info works

---

## 📞 Support Files

Reference these files for complete implementation details:
- GSM_NationalityList.dart (lines 1-8500)
- IMPLEMENTATION_SUMMARY.md
- JORDANIAN_NEXT_BUTTON_API.md
- SANAD_SUCCESS_DIALOG.md
- DIALOG_NAVIGATION_FIX.md

---

**Created**: 2025-10-04  
**Status**: Ready for Implementation  
**Estimated Time**: 2-4 hours per module
