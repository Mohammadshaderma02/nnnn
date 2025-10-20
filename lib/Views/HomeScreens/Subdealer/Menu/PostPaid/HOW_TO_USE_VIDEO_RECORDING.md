# How to Use PostpaidIdentificationSelfRecording

## Overview
`PostpaidIdentificationSelfRecording` is a reusable, dynamic eKYC video recording screen that can be integrated into any postpaid flow (GSM, FTTH, etc.).

## Features
- ✅ Front camera video recording with countdown
- ✅ Voice instructions during recording ("Blink your eyes", "Turn head left/right", "Smile")
- ✅ Automatic upload to eKYC API
- ✅ Video hash calculation for verification
- ✅ Callback-based navigation (fully dynamic)
- ✅ Retake functionality
- ✅ Clean error handling
- ✅ Automatic cleanup of resources

## Integration Steps

### Step 1: Add Import
```dart
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/PostpaidIdentificationSelfRecording.dart';
import 'package:camera/camera.dart';
```

### Step 2: Integration in GSM_JordainianCustomerInformation.dart

Find the "Next" button in `GSM_JordainianCustomerInformation.dart` and modify it to navigate to video recording before going to contract:

```dart
// In the Next button onPressed handler
ElevatedButton(
  onPressed: () async {
    // Validate all fields first
    if (_validateAllFields()) {
      // Get available cameras
      final cameras = await availableCameras();
      
      // Navigate to video recording screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostpaidIdentificationSelfRecording(
            sessionUid: globalVars.sessionUid,
            ekycToken: globalVars.ekycTokenID,
            cameras: cameras,
            onVideoRecorded: (videoPath, videoHash) {
              // Success callback - navigate to contract screen
              print('✅ Video recorded successfully!');
              print('Video path: $videoPath');
              print('Video hash: $videoHash');
              
              // Store video info if needed
              globalVars.videoPath = videoPath;
              globalVars.videoHash = videoHash;
              
              // Navigate to contract screen
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => GSM_contract_details(
                    role: role,
                    outDoorUserName: outDoorUserName,
                    Permessions: Permessions,
                    msisdn: msisdn,
                    nationalNumber: nationalNumber,
                    passportNumber: passportNumber,
                    userName: userName,
                    password: password,
                    marketType: marketType,
                    packageCode: packageCode,
                    // ... other parameters
                  ),
                ),
              );
            },
          ),
        ),
      );
    }
  },
  child: Text('Next'),
)
```

### Step 3: Add Video Info to Global Variables (Optional)

If you want to store video information globally, add these to `global_variables.dart`:

```dart
class GlobalVars {
  // ... existing variables ...
  
  // Video recording info
  static String videoPath = '';
  static String videoHash = '';
  
  // ... rest of code ...
}
```

## API Flow

```
1. User clicks "Next" in Customer Information screen
   ↓
2. Navigate to PostpaidIdentificationSelfRecording
   ↓
3. Camera initializes with front camera
   ↓
4. User clicks "Start Recording"
   ↓
5. 3-second countdown appears
   ↓
6. Recording starts (15 seconds max)
   - Shows instructions: Blink, Turn left, Turn right, Smile
   ↓
7. Recording stops (automatic or manual)
   ↓
8. Video hash is calculated
   ↓
9. Video uploads to: POST /wid-zain/api/v1/session/{sessionUid}/selfie-video
   ↓
10. On success → onVideoRecorded callback fires
   ↓
11. Navigate to Contract screen with video info
```

## Complete Example for GSM Flow

```dart
// In GSM_JordainianCustomerInformation.dart

// Add this import at the top
import 'package:camera/camera.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/PostpaidIdentificationSelfRecording.dart';

// In your Next button widget
Container(
  height: 48,
  width: 420,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(50),
    color: Color(0xFF4f2565),
  ),
  child: TextButton(
    onPressed: () async {
      // Validate all required fields
      bool isValid = _validateCustomerInfo();
      
      if (!isValid) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Please fill all required fields')),
        );
        return;
      }
      
      try {
        // Get available cameras
        final cameras = await availableCameras();
        
        // Navigate to video recording
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PostpaidIdentificationSelfRecording(
              sessionUid: globalVars.sessionUid,
              ekycToken: globalVars.ekycTokenID,
              cameras: cameras,
              onVideoRecorded: (videoPath, videoHash) {
                print('✅ Video recorded: $videoPath');
                
                // Navigate to contract screen
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => GSM_contract_details(
                      role: role,
                      outDoorUserName: outDoorUserName,
                      Permessions: Permessions,
                      msisdn: msisdn,
                      nationalNumber: nationalNumber,
                      passportNumber: passportNumber,
                      userName: userName,
                      password: password,
                      marketType: marketType,
                      packageCode: packageCode,
                      sendOtp: sendOtp,
                      showSimCard: showSimCard,
                      price: price,
                      isArmy: isArmy,
                      showCommitmentList: showCommitmentList,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      } catch (e) {
        print('Error accessing camera: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to access camera. Please check permissions.'),
            backgroundColor: Colors.red,
          ),
        );
      }
    },
    style: TextButton.styleFrom(
      backgroundColor: Color(0xFF4f2565),
      shape: const BeveledRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
    ),
    child: Text(
      "Postpaid.next".tr().toString(),
      style: TextStyle(
        color: Colors.white,
        letterSpacing: 0,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
)
```

## Non-Jordanian Flow Example

```dart
// For non-Jordanian customers in GSM_NonJordainianCustomerInformation.dart
// Same integration pattern as above, just use the appropriate contract screen

onVideoRecorded: (videoPath, videoHash) {
  Navigator.pushReplacement(
    context,
    MaterialPageRoute(
      builder: (context) => NonJordanianContractScreen(
        // ... parameters
      ),
    ),
  );
}
```

## Error Handling

The screen automatically handles:
- ❌ Camera permission denied
- ❌ No camera available
- ❌ Recording failures
- ❌ Upload failures
- ❌ Network errors

Each error shows a user-friendly message with retry option.

## Customization Options

### Custom Return Route
```dart
PostpaidIdentificationSelfRecording(
  sessionUid: globalVars.sessionUid,
  ekycToken: globalVars.ekycTokenID,
  cameras: cameras,
  returnRoute: CustomScreen(), // Optional custom return
  onVideoRecorded: (videoPath, videoHash) {
    // Handle success
  },
)
```

### Conditional Navigation
```dart
onVideoRecorded: (videoPath, videoHash) {
  // Navigate based on market type
  if (marketType == "GSM") {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => GSMContractScreen(...)),
    );
  } else if (marketType == "FTTH") {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => FTTHContractScreen(...)),
    );
  }
}
```

## Testing Checklist

- ✅ Camera permission request works
- ✅ Front camera initializes correctly
- ✅ Countdown displays (3, 2, 1)
- ✅ Recording starts and instructions appear
- ✅ Recording stops after 15 seconds or manual stop
- ✅ Video uploads successfully to eKYC API
- ✅ Success callback fires with correct parameters
- ✅ Navigation to contract screen works
- ✅ Back button cleanup works properly
- ✅ Retake functionality works

## Common Issues & Solutions

### Issue: Camera Permission Denied
**Solution**: Ensure AndroidManifest.xml and Info.plist have camera permissions declared.

### Issue: Video Upload Fails
**Solution**: Verify `globalVars.sessionUid` and `globalVars.ekycTokenID` are correctly set from eKYC initialization.

### Issue: Navigation Doesn't Work
**Solution**: Use `Navigator.pushReplacement` instead of `Navigator.push` to replace the video recording screen.

## Benefits of This Approach

1. ✅ **Reusable**: One screen for all postpaid flows
2. ✅ **Dynamic**: Callback-based navigation = fully flexible
3. ✅ **Clean**: Automatic resource cleanup
4. ✅ **Maintainable**: Single source of truth for video recording logic
5. ✅ **Testable**: Easy to test in isolation
6. ✅ **Scalable**: Can be used in GSM, FTTH, or any future postpaid flow
