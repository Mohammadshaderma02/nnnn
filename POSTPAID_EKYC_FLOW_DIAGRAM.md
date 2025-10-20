# Postpaid eKYC Video Recording Flow Diagram

## Complete User Journey

```
┌─────────────────────────────────────────────────────────────────────┐
│                     USER STARTS POSTPAID GSM FLOW                   │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│              📱 GSM_JordainianCustomerInformation Screen            │
│                                                                       │
│  User fills in:                                                       │
│  • National Number                                                    │
│  • MSISDN (Phone Number)                                             │
│  • Reference Number                                                   │
│  • SIM Card                                                          │
│  • Document Expiry Date                                              │
│  • Military Number (if applicable)                                   │
│  • Commitment selection                                              │
│  • Upload ID images (front/back)                                     │
│                                                                       │
│  [User clicks "Next" button]                                         │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      🔄 VALIDATION & PRICE API                       │
│                                                                       │
│  Function: Update_Price() → retrieve_updated_price_API()            │
│                                                                       │
│  API Call: POST /Postpaid/preSubmitValidation                       │
│  Body: {                                                             │
│    "MarketType": "GSM",                                              │
│    "IsJordanian": true,                                              │
│    "NationalNo": "...",                                              │
│    "PackageCode": "...",                                             │
│    "Msisdn": "...",                                                  │
│    "isClaimed": false                                                │
│  }                                                                   │
│                                                                       │
│  Response: { "status": 0, "data": { "price": "25.00" } }            │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
             ✅ Success                      ❌ Error
                    │                               │
                    ▼                               ▼
┌─────────────────────────────────┐   ┌──────────────────────────┐
│    _navigateToVideoRecording()  │   │   Show Error Toast       │
│                                  │   │   User stays on screen   │
│  1. Get available cameras        │   └──────────────────────────┘
│  2. Get sessionUid from          │
│     globalVars                   │
│  3. Get ekycToken from           │
│     globalVars                   │
│  4. Navigate to video screen     │
└─────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│          🎥 PostpaidIdentificationSelfRecording Screen              │
│          (lib/Views/.../PostPaid/PostpaidIdentificationSelfRecording.dart) │
│                                                                       │
│  Parameters:                                                          │
│  • cameras: [frontCamera, backCamera]                                │
│  • sessionUid: "ekyc-session-12345"                                  │
│  • ekycToken: "Bearer eyJ..."                                        │
│  • onVideoRecorded: (videoPath, videoHash) => {...}                 │
│                                                                       │
│  Screen UI:                                                          │
│  ┌─────────────────────────────────┐                                │
│  │  📹 eKYC Video Recording        │                                │
│  ├─────────────────────────────────┤                                │
│  │                                 │                                │
│  │     [Camera Preview Area]       │                                │
│  │                                 │                                │
│  │  "Position your face in the     │                                │
│  │   camera and click Start"       │                                │
│  │                                 │                                │
│  ├─────────────────────────────────┤                                │
│  │                                 │                                │
│  │   [Start Recording Button]      │                                │
│  │                                 │                                │
│  └─────────────────────────────────┘                                │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                        [User clicks "Start Recording"]
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      ⏱️ 3-SECOND COUNTDOWN                           │
│                                                                       │
│                              3... 2... 1... GO!                       │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                     🔴 RECORDING IN PROGRESS                         │
│                                                                       │
│  Duration: 15 seconds max                                            │
│                                                                       │
│  Instructions shown sequentially (every 3-4 seconds):                │
│  1. "Blink your eyes" 👁️                                             │
│  2. "Turn your head left" ⬅️                                         │
│  3. "Turn your head right" ➡️                                        │
│  4. "Smile" 😊                                                       │
│                                                                       │
│  UI shows:                                                           │
│  • Red REC indicator                                                 │
│  • Timer countdown                                                   │
│  • Current instruction text                                          │
│                                                                       │
│  [Recording auto-stops after 15 seconds]                             │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                    🔒 VIDEO HASH CALCULATION                         │
│                                                                       │
│  1. Read video file bytes                                            │
│  2. Calculate SHA-256 hash                                           │
│  3. Generate fingerprint (first 16 chars of hash)                    │
│                                                                       │
│  Example:                                                            │
│  videoHash: "a1b2c3d4e5f6789012345678901234567890abcdef..."          │
│  fingerprint: "a1b2c3d4e5f67890"                                    │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      📤 UPLOAD VIDEO TO EKYC API                     │
│                                                                       │
│  API: POST /wid-zain/api/v1/session/{sessionUid}/selfie-video       │
│                                                                       │
│  Headers:                                                            │
│  • Authorization: Bearer {ekycToken}                                 │
│  • Content-Type: multipart/form-data                                │
│                                                                       │
│  Body:                                                               │
│  • video: [video file binary]                                        │
│  • filename: "selfie_video.mp4"                                      │
│                                                                       │
│  [Waiting for response...]                                           │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                    ┌───────────────┴───────────────┐
                    │                               │
             ✅ Success (200/201)            ❌ Error
                    │                               │
                    ▼                               ▼
┌─────────────────────────────────┐   ┌──────────────────────────┐
│  onVideoRecorded() Callback     │   │  Show Error Message      │
│  Fires!                          │   │  "Upload failed"         │
│                                  │   │                          │
│  Receives:                       │   │  Options:                │
│  • videoPath: "/path/to/video"   │   │  • [Retry]               │
│  • videoHash: "a1b2c3..."        │   │  • [Cancel]              │
│                                  │   └──────────────────────────┘
│  Actions:                        │
│  1. Print success log            │
│  2. Navigator.pop(context)       │
│     → Close video screen         │
│  3. _showPriceConfirmation       │
│     Dialog()                     │
└─────────────────────────────────┘
                    │
                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                  💰 PRICE CONFIRMATION DIALOG                        │
│                                                                       │
│  Arabic: "المبلغ الكلي المطلوب هو 25 دينار، هل انت متأكد؟"         │
│  English: "The total amount required is 25 JD, are you sure?"       │
│                                                                       │
│  Buttons:                                                            │
│  ┌──────────┐  ┌──────────┐                                         │
│  │  Close   │  │   Save   │                                         │
│  └──────────┘  └──────────┘                                         │
│        │              │                                              │
│        │              └──────────────┐                               │
│        │                             │                               │
│        ▼                             ▼                               │
│  Cancel & Return        Proceed to Contract Generation              │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                        [User clicks "Save"]
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│                📝 GENERATE CONTRACT (Existing Flow)                  │
│                                                                       │
│  Function: postpaidGenerateContractBloc.add(...)                    │
│                                                                       │
│  All customer data + video info sent to backend                     │
│  Contract PDF generated                                              │
│                                                                       │
│  [Loading...]                                                        │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
┌─────────────────────────────────────────────────────────────────────┐
│              📋 GSM_contract_details Screen                          │
│                                                                       │
│  Shows:                                                              │
│  • Contract PDF preview                                              │
│  • Customer information                                              │
│  • Package details                                                   │
│  • Price breakdown                                                   │
│  • Payment options                                                   │
│                                                                       │
│  [User reviews and signs contract]                                   │
└─────────────────────────────────────────────────────────────────────┘
                                    │
                                    ▼
                         ✅ PROCESS COMPLETE!
```

## Key Integration Points

### 1. Entry Point
```dart
// File: GSM_JordainianCustomerInformation.dart
// Line: ~846
void retrieve_updated_price_API() async {
    // ... API call code ...
    if (result["status"] == 0) {
        setState(() {
          General_price = result["data"]["price"].toString();
        });
        
        // 🎥 NEW: Navigate to video recording
        _navigateToVideoRecording();
        
        // OLD: showAlertDialogSaveData(...) - REMOVED
    }
}
```

### 2. Navigation Method
```dart
// File: GSM_JordainianCustomerInformation.dart
// Line: ~862
void _navigateToVideoRecording() async {
    final cameras = await availableCameras();
    
    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => PostpaidIdentificationSelfRecording(
                cameras: cameras,
                sessionUid: globalVars.sessionUid,
                ekycToken: globalVars.ekycTokenID,
                onVideoRecorded: (videoPath, videoHash) {
                    Navigator.pop(context);
                    _showPriceConfirmationDialog();
                },
            ),
        ),
    );
}
```

### 3. Shared Video Recording Screen
```dart
// File: PostpaidIdentificationSelfRecording.dart
class PostpaidIdentificationSelfRecording extends StatefulWidget {
    final Function(String videoPath, String videoHash) onVideoRecorded;
    final String sessionUid;
    final String ekycToken;
    final List<CameraDescription> cameras;
    
    // Handles all video recording logic
    // Calls onVideoRecorded() on success
}
```

## Data Flow

```
┌───────────────────┐
│   Global Vars     │
│                   │
│ • sessionUid      │───┐
│ • ekycTokenID     │   │
└───────────────────┘   │
                        │
                        ▼
              ┌─────────────────────┐
              │ Video Recording     │
              │ Screen              │
              └─────────────────────┘
                        │
                        │ Uploads video
                        ▼
              ┌─────────────────────┐
              │ eKYC API            │
              │ (External)          │
              └─────────────────────┘
                        │
                        │ Returns success
                        ▼
              ┌─────────────────────┐
              │ onVideoRecorded     │
              │ Callback            │
              └─────────────────────┘
                        │
                        ▼
              ┌─────────────────────┐
              │ Price Confirmation  │
              │ Dialog              │
              └─────────────────────┘
                        │
                        ▼
              ┌─────────────────────┐
              │ Contract Generation │
              │ (Existing Flow)     │
              └─────────────────────┘
```

## Error Handling Flow

```
                    START
                      │
                      ▼
        ┌─────────────────────────┐
        │ Any Error Occurs?       │
        └─────────────────────────┘
                      │
        ┌─────────────┴─────────────┐
        │                           │
     YES │                          │ NO
        │                           │
        ▼                           ▼
┌──────────────────┐        Continue Normal Flow
│ Show Error Toast │
│ or Dialog        │
└──────────────────┘
        │
        ▼
┌──────────────────┐
│ Error Types:     │
│                  │
│ 1. Camera        │───► Show: "Camera permission denied"
│    Permission    │      Action: Request permission again
│                  │
│ 2. No Camera     │───► Show: "No camera available"
│    Available     │      Action: Close screen
│                  │
│ 3. Recording     │───► Show: "Failed to record video"
│    Failed        │      Action: [Retry] button
│                  │
│ 4. Upload        │───► Show: "Failed to upload video"
│    Failed        │      Action: [Retry] [Cancel]
│                  │
│ 5. API Error     │───► Show error message from API
│                  │      Action: [Close]
└──────────────────┘
```

---

**Note:** This flow is designed to be reusable across all postpaid flows (GSM, FTTH, etc.) by simply providing different callbacks in the `onVideoRecorded` parameter.
