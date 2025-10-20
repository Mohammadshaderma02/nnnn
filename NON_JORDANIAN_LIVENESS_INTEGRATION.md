# Non-Jordanian Customer Form - Liveness Video Integration

## Overview
Added liveness video recording functionality to `GSM_NonJordainianCustomerInformation.dart` to match the implementation in the Jordanian customer form. The form now navigates to video recording screen before final contract generation.

## Updated Date
December 10, 2025

---

## Changes Summary

### File Modified
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_NonJordainianCustomerInformation.dart`

### Key Changes

1. ✅ **Added Imports** - camera and PostpaidIdentificationSelfRecording
2. ✅ **Added preSubmitValidation_API()** - Validates data before liveness
3. ✅ **Added _navigateToVideoRecording()** - Navigates to video recording screen
4. ✅ **Added _showPriceConfirmationDialog()** - Shows price after video recording
5. ✅ **Updated Submit Button Logic** - Calls preSubmitValidation instead of direct contract generation

---

## Flow Comparison

### Before (Old Flow):
```
Fill Form → Validate → Show Price Dialog → Generate Contract
```

### After (New Flow):
```
Fill Form → Validate → preSubmitValidation API → 
    → Video Recording → Show Price Dialog → Generate Contract
```

---

## Technical Implementation

### 1. New Imports Added

```dart
import 'package:camera/camera.dart';
import '../PostpaidIdentificationSelfRecording.dart';
```

**Purpose:** Access camera functionality and video recording screen.

---

### 2. preSubmitValidation_API() Method

**Location:** Lines 1003-1065

**Purpose:** Validates the form data with backend before proceeding to liveness video recording.

```dart
preSubmitValidation_API() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  Map test = {
    "MarketType": this.marketType,
    "IsJordanian": false, // Non-Jordanian
    "NationalNo": null,
    "PassportNo": passportNumber,
    "PackageCode": this.packageCode,
    "Msisdn": this.msisdn,
    "isClaimed": claim
  };
  
  // Call API endpoint
  var apiArea = urls.BASE_URL + '/Postpaid/preSubmitValidation';
  final response = await http.post(url, headers: {...}, body: body);
  
  if (response.statusCode == 200) {
    var result = json.decode(response.body);
    if (result["status"] == 0) {
      // Update price from API
      General_price = result["data"]["price"].toString();
      
      // ✅ Navigate to video recording
      _navigateToVideoRecording();
    }
  }
}
```

**API Request:**
```json
{
  "MarketType": "GSM",
  "IsJordanian": false,
  "NationalNo": null,
  "PassportNo": "S0896546",
  "PackageCode": "PKG123",
  "Msisdn": "0791234567",
  "isClaimed": false
}
```

**API Response:**
```json
{
  "status": 0,
  "message": "Validation successful",
  "data": {
    "price": "25.5"
  }
}
```

---

### 3. _navigateToVideoRecording() Method

**Location:** Lines 1068-1115

**Purpose:** Navigate to the PostpaidIdentificationSelfRecording screen for video capture.

```dart
void _navigateToVideoRecording() async {
  try {
    // Get available cameras
    final cameras = await availableCameras();
    
    // Get eKYC session data
    String sessionUid = globalVars.sessionUid ?? '';
    String ekycToken = globalVars.ekycTokenID ?? '';
    
    // Navigate to video recording screen
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PostpaidIdentificationSelfRecording(
          cameras: cameras,
          sessionUid: sessionUid,
          ekycToken: ekycToken,
          onVideoRecorded: (videoPath, videoHash) {
            // Video successfully uploaded
            Navigator.pop(context);
            
            // Show price confirmation dialog
            _showPriceConfirmationDialog();
          },
        ),
      ),
    );
  } catch (e) {
    print('❌ Error navigating to video recording: $e');
    showToast("Error navigating to video recording screen", ...);
  }
}
```

**Parameters Passed:**
- `cameras` - List of available device cameras
- `sessionUid` - eKYC session ID from globalVars
- `ekycToken` - eKYC authentication token
- `onVideoRecorded` - Callback when video upload completes

---

### 4. _showPriceConfirmationDialog() Method

**Location:** Lines 1117-1123

**Purpose:** Show final price confirmation after successful video recording.

```dart
void _showPriceConfirmationDialog() {
  showAlertDialogSaveData(
    context,
    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
    'The total amount required is ${General_price}JD are you sure you want to continue?'
  );
}
```

---

### 5. Submit Button Logic Updated

**Changed Lines:**
- Line 4150: First instance
- Line 4187: Second instance  
- Additional instances where `showAlertDialogSaveData` was called directly

**Before:**
```dart
if (errorDay == false && errorMonthe == false && birthDateValid == true) {
  showAlertDialogSaveData(
    context,
    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
    'The total amount required is ${General_price}JD...'
  );
}
```

**After:**
```dart
if (errorDay == false && errorMonthe == false && birthDateValid == true) {
  // ✅ Call preSubmitValidation which will navigate to liveness video
  preSubmitValidation_API();
}
```

---

## User Flow

### Detailed Flow Diagram

```
┌─────────────────────────────────────┐
│ User Fills Non-Jordanian Form      │
│ - Name fields                       │
│ - Birth date                        │
│ - Document expiry                   │
│ - Passport image                    │
│ - Reference number                  │
│ - SIM card                          │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ User Clicks "Submit" Button         │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ Client-Side Validation              │
│ - Check required fields             │
│ - Validate dates                    │
│ - Check images uploaded             │
└─────────────────────────────────────┘
              │
              ▼ (All valid)
┌─────────────────────────────────────┐
│ preSubmitValidation_API()           │
│ POST /Postpaid/preSubmitValidation  │
└─────────────────────────────────────┘
              │
              ▼ (API Success)
┌─────────────────────────────────────┐
│ Update General_price from API       │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ _navigateToVideoRecording()         │
│ Get cameras & eKYC session data     │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ PostpaidIdentificationSelfRecording │
│ - User records 3-second video       │
│ - Video uploaded to eKYC API        │
│ - Returns video path & hash         │
└─────────────────────────────────────┘
              │
              ▼ (Video Uploaded)
┌─────────────────────────────────────┐
│ onVideoRecorded Callback Fires      │
│ Navigator.pop(context)              │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ _showPriceConfirmationDialog()      │
│ "Amount is X JD, confirm?"          │
└─────────────────────────────────────┘
              │
              ▼ (User Confirms)
┌─────────────────────────────────────┐
│ PostpaidGenerateContract BLoC       │
│ Generate final contract             │
└─────────────────────────────────────┘
              │
              ▼
┌─────────────────────────────────────┐
│ Navigate to Contract Details        │
└─────────────────────────────────────┘
```

---

## Data Requirements

### Required Before Video Recording:

| Field | Type | Source | Required |
|-------|------|--------|----------|
| `sessionUid` | String | `globalVars.sessionUid` | ✅ Yes |
| `ekycTokenID` | String | `globalVars.ekycTokenID` | ✅ Yes |
| `msisdn` | String | Form field | ✅ Yes |
| `passportNumber` | String | Constructor param | ✅ Yes |
| `packageCode` | String | Constructor param | ✅ Yes |

**Note:** If `sessionUid` or `ekycTokenID` are missing, video recording will fail gracefully with error toast.

---

## Error Handling

### Scenario 1: preSubmitValidation API Fails

**Response:** HTTP 401 or 500
```dart
if (statusCode == 401) {
  print('401 error');
  // User sees no navigation, stays on form
}
```

**User Impact:** Form submission halts, no navigation to video recording.

---

### Scenario 2: Camera Access Fails

**Error:** Exception in `availableCameras()`
```dart
catch (e) {
  print('❌ Error navigating to video recording: $e');
  showToast(
    "Error navigating to video recording screen",
    context: context,
    animation: StyledToastAnimation.scale,
    fullWidth: true,
  );
}
```

**User Impact:** Error toast displayed, user remains on form.

---

### Scenario 3: Missing eKYC Session Data

**Condition:** `globalVars.sessionUid` or `globalVars.ekycTokenID` is null/empty

**Result:** 
- Video recording screen opens but upload will fail
- Error message shown in video recording screen
- User can retry or go back

---

### Scenario 4: Video Upload Fails

**Handled By:** `PostpaidIdentificationSelfRecording` screen

**User Experience:**
- Error message shown on video screen
- Option to retry video recording
- Option to cancel and return to form

---

## Testing Scenarios

### Test Case 1: Happy Path - Complete Flow

**Steps:**
1. Fill all form fields correctly
2. Upload passport image
3. Click Submit button
4. ✅ preSubmitValidation API returns success with price
5. ✅ Navigate to video recording screen
6. Record 3-second video
7. ✅ Video uploads successfully
8. ✅ Return to form (auto-closed)
9. ✅ Price confirmation dialog appears
10. Confirm price
11. ✅ Contract generated

**Expected Result:** Complete flow without errors, contract created successfully.

---

### Test Case 2: Missing eKYC Session

**Condition:**
```dart
globalVars.sessionUid = null; // or empty
```

**Steps:**
1. Fill form and submit
2. preSubmitValidation succeeds
3. Navigate to video recording

**Expected Result:**  
- Video recording screen opens
- Error shown when trying to upload
- User can go back to form

---

### Test Case 3: Camera Permission Denied

**Steps:**
1. Fill form and submit
2. preSubmitValidation succeeds
3. `availableCameras()` throws permission exception

**Expected Result:**
- Error toast: "Error navigating to video recording screen"
- User stays on form
- Can try again after granting permission

---

### Test Case 4: API Validation Fails

**API Response:**
```json
{
  "status": 1,
  "message": "Validation failed",
  "messageAr": "فشل التحقق"
}
```

**Expected Result:**
- No navigation to video recording
- User remains on form
- Can correct data and retry

---

## Comparison with Jordanian Form

Both forms now have **identical** liveness video recording flow:

| Feature | Jordanian Form | Non-Jordanian Form |
|---------|---------------|-------------------|
| preSubmitValidation API | ✅ Yes | ✅ Yes |
| Video Recording Navigation | ✅ Yes | ✅ Yes |
| Price Confirmation After Video | ✅ Yes | ✅ Yes |
| Error Handling | ✅ Yes | ✅ Yes |
| Uses PostpaidIdentificationSelfRecording | ✅ Yes | ✅ Yes |

**Only Difference:** API request body `IsJordanian` field
- Jordanian: `"IsJordanian": true, "NationalNo": "xxx", "PassportNo": null`
- Non-Jordanian: `"IsJordanian": false, "NationalNo": null, "PassportNo": "xxx"`

---

## Benefits

### For Users
✅ **Consistent Experience** - Same flow for all customers  
✅ **Secure Verification** - Video liveness prevents fraud  
✅ **Clear Progress** - Video → Price → Contract  
✅ **Better Onboarding** - Smooth step-by-step process

### For Developers
✅ **Code Consistency** - Both forms use same pattern  
✅ **Maintainability** - Shared video recording component  
✅ **Reusability** - PostpaidIdentificationSelfRecording is reusable  
✅ **Testable** - Clear separation of concerns

### For Business
✅ **Fraud Prevention** - Liveness video verification  
✅ **Compliance** - eKYC regulatory requirements met  
✅ **Audit Trail** - Video proof of customer verification  
✅ **Quality Assurance** - Validated data before contract

---

## Related Files

| File | Role |
|------|------|
| `GSM_NonJordainianCustomerInformation.dart` | ✅ **This file** - Form with liveness integration |
| `GSM_JordainianCustomerInformation.dart` | Reference implementation |
| `PostpaidIdentificationSelfRecording.dart` | Shared video recording screen |
| `global_variables.dart` | Stores sessionUid and ekycTokenID |

---

## API Documentation

### Endpoint: preSubmitValidation

**URL:** `{BASE_URL}/Postpaid/preSubmitValidation`  
**Method:** POST  
**Headers:**
```
Content-Type: application/json
Authorization: Bearer {accessToken}
```

**Request Body (Non-Jordanian):**
```json
{
  "MarketType": "GSM",
  "IsJordanian": false,
  "NationalNo": null,
  "PassportNo": "S0896546",
  "PackageCode": "PKG_GSM_001",
  "Msisdn": "0791234567",
  "isClaimed": false
}
```

**Success Response (200):**
```json
{
  "status": 0,
  "message": "Validation successful",
  "messageAr": "تم التحقق بنجاح",
  "data": {
    "price": "25.50"
  }
}
```

**Error Response (200 with status 1):**
```json
{
  "status": 1,
  "message": "Validation failed",
  "messageAr": "فشل التحقق",
  "data": null
}
```

---

## Migration Notes

**Backward Compatibility:** ✅ Maintained  
- Old contract generation flow still exists
- Only triggered after successful video recording

**Breaking Changes:** ❌ None  
- All existing functionality preserved
- Added layer before contract generation

**Required Updates:**
- Ensure `globalVars.sessionUid` is populated from passport processing
- Ensure `globalVars.ekycTokenID` is available from token generation

---

**Implementation Status:** ✅ Complete and Ready for Testing  
**Last Updated:** December 10, 2025
