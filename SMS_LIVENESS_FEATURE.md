# SMS Liveness Feature Documentation

## Overview
Added SMS-based liveness verification feature to `PostpaidIdentificationSelfRecording.dart` screen, allowing customers to complete video liveness verification remotely via a link sent to their mobile phone.

## Implementation Date
December 10, 2025

## Feature Description

Users now have **two options** for liveness verification:
1. **Record Video Here** - Record video directly on the agent's device (existing functionality)
2. **Send Link via SMS** - Send a link to customer's mobile phone for remote video recording

---

## User Interface Changes

### Main Screen
```
┌─────────────────────────────────────┐
│  📹 eKYC Video Recording           │
├─────────────────────────────────────┤
│                                     │
│     [Camera Preview Area]           │
│                                     │
├─────────────────────────────────────┤
│                                     │
│  [Record Video Here]   (Purple)     │
│                                     │
│  ──────────── OR ────────────       │
│                                     │
│  [Send Link via SMS]   (Green)      │
│                                     │
└─────────────────────────────────────┘
```

### SMS Dialog
```
┌─────────────────────────────────────┐
│  Send Liveness Link via SMS         │
├─────────────────────────────────────┤
│  Enter customer's mobile number     │
│  to send the liveness link          │
│                                     │
│  ┌─────────────────────────────┐   │
│  │ 07xxxxxxxx                  │   │
│  │ Must start with 07 and      │   │
│  │ be 10 digits                │   │
│  └─────────────────────────────┘   │
│                                     │
│  [Cancel]         [Send SMS]        │
└─────────────────────────────────────┘
```

### Waiting Status
```
┌─────────────────────────────────────┐
│  ⏳ Waiting for customer to         │
│     complete liveness...            │
├─────────────────────────────────────┤
│     [Camera Preview Area]           │
│                                     │
│  [SMS Sent - Waiting...]            │
│                                     │
└─────────────────────────────────────┘
```

### Completion Status
```
┌─────────────────────────────────────┐
│  ✅ Liveness verification           │
│     completed successfully!         │
├─────────────────────────────────────┤
│     [Camera Preview Area]           │
│                                     │
│  [SMS Sent - Waiting...]            │
│                                     │
│  [Next →]                           │
│                                     │
└─────────────────────────────────────┘
```

---

## Technical Implementation

### 1. API Endpoints

#### Send SMS API
```
POST {BASE_URL}/Postpaid/SendSMSVideoEkyc

Headers:
  Content-Type: application/json
  Authorization: Bearer {accessToken}

Request Body:
{
  "msisdn": "07xxxxxxxx",      // Customer's mobile number
  "sessionId": "session-uid"   // eKYC session UID
}

Success Response (200):
{
  "status": 0,
  "message": "SMS sent successfully",
  "messageAr": "تم إرسال الرسالة بنجاح"
}

Error Response:
{
  "status": 1,
  "message": "Failed to send SMS",
  "messageAr": "فشل إرسال الرسالة"
}
```

#### Check Liveness Status API
```
GET https://dsc.jo.zain.com/eKYC/api/Lines/session/{sessionUID}

Headers:
  X-API-KEY: 37375383-f46b-41d4-a79c-a4a4c2f8b1e4

Response (200):
{
  "status": 0,
  "message": "The Operation has been Successfully Completed",
  "messageAr": "تمت العملية بنجاح",
  "data": {
    "status": "working",              // or "completed"
    "session": {
      "uid": "session-uid",
      "status": "working",
      "livenessAccepted": false,      // or true when completed
      "livenessThreshold": "0.6",
      // ... other fields
    },
    // ... other fields
  }
}
```

### 2. MSISDN Validation Rules

The MSISDN input field enforces the following validation:

| Rule | Description | Error Message (EN) | Error Message (AR) |
|------|-------------|-------------------|-------------------|
| **Not Empty** | Field must not be empty | "Please enter a mobile number" | "الرجاء إدخال رقم الهاتف" |
| **Length** | Must be exactly 10 digits | "Mobile number must be 10 digits" | "يجب أن يكون رقم الهاتف 10 أرقام" |
| **Start Pattern** | Must start with "07" | "Mobile number must start with 07" | "يجب أن يبدأ رقم الهاتف بـ 07" |
| **Digits Only** | Must contain only numeric digits | "Mobile number must contain only digits" | "يجب أن يحتوي رقم الهاتف على أرقام فقط" |

**Valid Examples:**
- ✅ `0791234567`
- ✅ `0781234567`
- ✅ `0771234567`

**Invalid Examples:**
- ❌ `79123456` (missing 07 prefix)
- ❌ `07912345` (too short, < 10 digits)
- ❌ `079123456789` (too long, > 10 digits)
- ❌ `08912345678` (doesn't start with 07)
- ❌ `07a1234567` (contains non-digit characters)

### 3. Status Checking Logic

```dart
// Checks status every 5 seconds
Timer.periodic(Duration(seconds: 5), (timer) {
  _checkLivenessStatus();
});

// Completion condition
if (status != "working" || livenessAccepted == true) {
  // Liveness is complete
  // Show "Next" button
  // Stop timer
}
```

### 4. State Variables

```dart
bool _isCheckingStatus = false;      // True when polling status
bool _smsLivenessSent = false;       // True after SMS sent successfully
bool _livenessCompleted = false;     // True when status != "working"
String _livenessStatus = '';         // Current status from API
Timer _statusCheckTimer;             // Timer for periodic checks
```

---

## User Flow

### Flow Diagram

```
┌─────────────────────────────────────────────┐
│  User Opens Video Recording Screen         │
└─────────────────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────┐
│  Two Options Available:                     │
│  1. Record Video Here (Local)               │
│  2. Send Link via SMS (Remote)              │
└─────────────────────────────────────────────┘
                    │
          ┌─────────┴─────────┐
          │                   │
    Option 1             Option 2
    (Local)              (Remote)
          │                   │
          ▼                   ▼
    ┌─────────┐      ┌──────────────────┐
    │ Record  │      │ SMS Dialog Opens │
    │ Video   │      └──────────────────┘
    │ Locally │               │
    └─────────┘               ▼
          │           ┌──────────────────┐
          │           │ Enter MSISDN     │
          │           │ (07xxxxxxxx)     │
          │           └──────────────────┘
          │                   │
          │                   ▼
          │           ┌──────────────────┐
          │           │ Validate:        │
          │           │ • Starts with 07 │
          │           │ • Length = 10    │
          │           │ • Only digits    │
          │           └──────────────────┘
          │                   │
          │              ✅ Valid
          │                   ▼
          │           ┌──────────────────┐
          │           │ Send SMS API     │
          │           │ POST /SendSMS... │
          │           └──────────────────┘
          │                   │
          │                   ▼
          │           ┌──────────────────┐
          │           │ SMS Sent Success │
          │           └──────────────────┘
          │                   │
          │                   ▼
          │           ┌──────────────────┐
          │           │ Start Polling    │
          │           │ Status (Every 5s)│
          │           └──────────────────┘
          │                   │
          │                   ▼
          │           ┌──────────────────┐
          │           │ Check Status API │
          │           │ GET /session/... │
          │           └──────────────────┘
          │                   │
          │          ┌────────┴────────┐
          │          │                 │
          │    status="working"   status!="working"
          │          │              OR
          │    (Continue Poll)    livenessAccepted=true
          │          │                 │
          │          └──────┐          ▼
          │                 │   ┌──────────────────┐
          │                 │   │ Stop Timer       │
          │                 │   │ Show "Next" Btn  │
          │                 │   └──────────────────┘
          │                 │          │
          ▼                 ▼          ▼
    ┌────────────────────────────────────┐
    │  Video Uploaded / Verified         │
    │  globalVars.isValidLivness = true  │
    └────────────────────────────────────┘
                    │
                    ▼
    ┌────────────────────────────────────┐
    │  User Clicks "Next"                │
    │  (Only if liveness completed)      │
    └────────────────────────────────────┘
                    │
                    ▼
    ┌────────────────────────────────────┐
    │  onVideoRecorded() Callback Fires  │
    │  Navigate to Price Confirmation    │
    └────────────────────────────────────┘
```

---

## Code Changes Summary

### File Modified
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/PostpaidIdentificationSelfRecording.dart`

### Changes Made

#### 1. **Added State Variables** (Lines 108-113)
```dart
bool _isCheckingStatus = false;
bool _smsLivenessSent = false;
bool _livenessCompleted = false;
String _livenessStatus = '';
Timer _statusCheckTimer;
```

#### 2. **Updated Cleanup** (Line 136)
```dart
_statusCheckTimer?.cancel();
```

#### 3. **Added SMS Dialog Method** (Lines 652-724)
- Shows dialog to input MSISDN
- Validates input before proceeding
- Calls `_sendSMSLiveness()` on submit

#### 4. **Added Send SMS Method** (Lines 726-827)
- Calls `POST /Postpaid/SendSMSVideoEkyc`
- Handles success and error responses
- Starts status checking on success

#### 5. **Added Status Checking Methods** (Lines 829-894)
- `_startStatusChecking()` - Starts periodic timer
- `_checkLivenessStatus()` - Polls external API every 5 seconds
- Checks if `status != "working"` or `livenessAccepted == true`
- Stops timer and shows "Next" button when complete

#### 6. **Updated UI** (Lines 1131-1296)
- Added status checking indicator
- Reorganized control buttons
- Added "OR" divider between options
- Added "Send Link via SMS" button
- Added conditional "Next" button (shows only when `_livenessCompleted == true`)

---

## Testing Checklist

### SMS Dialog
- [ ] Dialog opens when "Send Link via SMS" clicked
- [ ] TextField shows hint "07xxxxxxxx"
- [ ] Helper text displays validation rules
- [ ] Max length enforced at 10 characters
- [ ] Cancel button closes dialog

### MSISDN Validation
- [ ] Empty input shows error: "Please enter a mobile number"
- [ ] Input < 10 digits shows error: "Mobile number must be 10 digits"
- [ ] Input > 10 digits prevented by maxLength
- [ ] Input not starting with "07" shows error: "Mobile number must start with 07"
- [ ] Input with letters shows error: "Must contain only digits"
- [ ] Valid input (07xxxxxxxx) proceeds successfully

### SMS Sending
- [ ] Valid MSISDN sends SMS API request
- [ ] Success response shows: "SMS sent successfully! Checking liveness status..."
- [ ] Button text changes to: "SMS Sent - Waiting..."
- [ ] Button becomes disabled after sending
- [ ] Status indicator appears: "Waiting for customer to complete liveness..."

### Status Checking
- [ ] Status API called immediately after SMS sent
- [ ] Status API called every 5 seconds
- [ ] Console logs show status checks
- [ ] When status changes from "working", timer stops
- [ ] When livenessAccepted becomes true, timer stops
- [ ] Success message shows: "Liveness verification completed successfully!"

### Next Button
- [ ] "Next" button does NOT show while status = "working"
- [ ] "Next" button DOES show when status != "working"
- [ ] "Next" button DOES show when livenessAccepted = true
- [ ] Clicking "Next" triggers `onVideoRecorded()` callback
- [ ] Navigation proceeds to price confirmation

### Cleanup
- [ ] Timer stops when screen is closed
- [ ] Timer stops when back button pressed
- [ ] No memory leaks from active timers

---

## Error Handling

| Scenario | Response | User Feedback |
|----------|----------|---------------|
| Invalid MSISDN format | Validation error | Red snackbar with specific error |
| SMS API failure (non-200) | API error | "Failed to send SMS. Please try again." |
| SMS API returns status != 0 | Business logic error | Show `message` or `messageAr` from response |
| Status check API failure | Silent retry | Continue polling |
| Network timeout | Exception caught | "Error: [exception message]" |

---

## Bilingual Support

All messages support both English and Arabic:

| Context | English | Arabic |
|---------|---------|--------|
| **Dialog Title** | "Send Liveness Link via SMS" | "إرسال رابط التحقق عبر SMS" |
| **Dialog Content** | "Enter customer's mobile number..." | "أدخل رقم هاتف العميل..." |
| **Input Label** | "Mobile Number (MSISDN)" | "رقم الهاتف" |
| **Input Hint** | "07xxxxxxxx" | "07xxxxxxxx" |
| **Helper Text** | "Must start with 07 and be 10 digits" | "يجب أن يبدأ بـ 07 ويتكون من 10 أرقام" |
| **Cancel Button** | "Cancel" | "إلغاء" |
| **Send Button** | "Send SMS" | "إرسال" |
| **Main Button** | "Send Link via SMS" | "إرسال رابط عبر SMS" |
| **After Sent** | "SMS Sent - Waiting..." | "تم الإرسال - في الانتظار..." |
| **Status Indicator** | "Waiting for customer to complete liveness..." | "في انتظار إكمال العميل للتحقق..." |
| **Success Message** | "SMS sent successfully! Checking liveness status..." | "تم إرسال الرسالة بنجاح! جاري فحص حالة التحقق..." |
| **Completion** | "Liveness verification completed successfully!" | "تم التحقق من الهوية بنجاح!" |
| **Next Button** | "Next" | "التالي" |

---

## Benefits

### For Agents
✅ **Flexibility** - Choose between local or remote recording
✅ **No Customer Device Needed** - Agent doesn't need customer's phone
✅ **Better Privacy** - Customer records in private
✅ **Parallel Processing** - Agent can continue other work while customer records

### For Customers
✅ **Convenience** - Record from their own device
✅ **Privacy** - Complete verification in private setting
✅ **Better Quality** - Use their own camera and environment
✅ **Less Pressure** - Record at their own pace

### For Business
✅ **Improved Completion Rate** - Customers more likely to complete
✅ **Better Video Quality** - Customers can retry until satisfied
✅ **Audit Trail** - SMS provides proof of verification request
✅ **Scalability** - Reduces agent involvement time

---

## Future Enhancements

Potential improvements:
1. Add timeout for status checking (e.g., stop after 10 minutes)
2. Add manual refresh button for status checking
3. Show timer/elapsed time while waiting
4. Add notification when customer completes verification
5. Allow resending SMS if first attempt fails
6. Show customer name in status indicator
7. Add SMS cost tracking/reporting

---

## Support & Troubleshooting

### Common Issues

**Issue:** SMS not received by customer
- **Solution:** Verify MSISDN format is correct (07xxxxxxxx)
- **Solution:** Check SMS service provider status
- **Solution:** Verify customer's phone is on and has signal

**Issue:** Status shows "working" indefinitely
- **Solution:** Ask customer to check SMS and complete verification
- **Solution:** Verify customer has internet connection
- **Solution:** Consider timeout and allow agent to retry

**Issue:** "Next" button doesn't appear
- **Solution:** Verify status API is returning correct data
- **Solution:** Check console logs for status value
- **Solution:** Ensure `livenessAccepted` field is being parsed correctly

---

**Implementation Status:** ✅ Complete and Ready for Testing
**Last Updated:** December 10, 2025
