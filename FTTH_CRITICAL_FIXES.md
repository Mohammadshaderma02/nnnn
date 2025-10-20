# CRITICAL FIXES for FTTH eKYC - Session & Sanad Issues

## Problem Summary

You reported that:
1. ❌ Session ID is not being created
2. ❌ Sanad does not appear after clicking "Check"

## Root Causes Identified

### ✅ FIXED: initState() Missing Critical Calls

**Problem:** The `initState()` method was not calling:
- `_resetAllDocumentData()` - Reset document state
- `generateEkycToken()` - **Creates session and token**
- `_initDeepLinkListener()` - **Handles Sanad callback**

**Status:** ✅ **FIXED** - Updated initState() to include all three calls

---

### ❌ REMAINING: Check Button Not Calling Sanad

**Problem:** The "Check" button in `nationalNumber()` widget is calling `PostValidateSubscriberPressed` API directly, but it should first attempt Sanad verification.

**Current FTTH Flow (WRONG):**
```
User clicks Check → PostValidateSubscriberPressed API → Show dialog
```

**Correct GSM Flow (RIGHT):**
```
User clicks Check → _trySanadVerification() → 
  If session ready → Launch Sanad URL → Deep link callback → PostValidateSubscriber API → Show dialog
  If session not ready → Show document scan toggle
```

---

## Required Fixes

### Fix #1: Add `_trySanadVerification()` Method

Add this method to FTTH NationalityList.dart (after line 1310 or near other Sanad methods):

```dart
Future<void> _trySanadVerification() async {
  setState(() {
    isloading = true;
    checkNationalDisabled = true;
    sanadVerificationFailed = false;
  });

  try {
    // Check if eKYC is initialized
    if (!isEkycInitialized) {
      print("❌ eKYC not initialized - attempting to initialize...");
      await generateEkycToken();
    }

    // If still not initialized after attempt, show document scan toggle
    if (!isEkycInitialized) {
      print("❌ eKYC initialization failed - showing document scan toggle");
      setState(() {
        globalVars.sanadValidation = true; // ✅ Show toggle for manual document scan
        isloading = false;
        checkNationalDisabled = false;
      });
      return;
    }

    print("✅ eKYC initialized - attempting Sanad verification");
    print("Session UID: ${globalVars.sessionUid}");
    print("National No: ${nationalNo.text}");

    // Call Sanad Check API
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

      print("Sanad API Response Status: ${response.statusCode}");
      print("Sanad API Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        if (result["data"] != null && result["data"]["verified"] == true) {
          // ✅ Sanad verification URL received
          print("✅ Sanad verification available - launching Sanad URL");
          
          redirectUrl = result["data"]["redirectUrl"];
          final Uri sanadUrl = Uri.parse(redirectUrl);

          setState(() {
            isloading = false;
            checkNationalDisabled = false;
          });

          // Launch Sanad URL
          if (await canLaunchUrl(sanadUrl)) {
            await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
            
            // Note: The deep link callback (_handleDeepLink) will handle the rest
            // After Sanad completes, it will call PostValidateSubscriber API
          } else {
            throw Exception("Could not launch Sanad URL");
          }
        } else {
          // Sanad verification not available, show document scan toggle
          print("⚠️ Sanad verification not available - showing document scan toggle");
          setState(() {
            globalVars.sanadValidation = true; // ✅ Show toggle
            isloading = false;
            checkNationalDisabled = false;
          });
        }
      } else {
        print("❌ Sanad API returned non-200 status");
        setState(() {
          globalVars.sanadValidation = true; // ✅ Show toggle
          isloading = false;
          checkNationalDisabled = false;
        });
      }
    } finally {
      client.close();
    }
  } catch (e) {
    print("❌ Error during Sanad verification: $e");
    setState(() {
      globalVars.sanadValidation = true; // ✅ Show toggle on error
      isloading = false;
      checkNationalDisabled = false;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
              ? "Sanad verification unavailable. Please scan your document."
              : "التحقق عبر سند غير متاح. يرجى مسح مستندك.",
        ),
        backgroundColor: Colors.orange,
      ),
    );
  }
}
```

### Fix #2: Update `_handleDeepLink()` to Call PostValidateSubscriber

Update the deep link handler to call the PostValidateSubscriber API after successful Sanad callback.

Find the section in `_handleDeepLink()` around line 1682 where it handles success, and add:

```dart
// ✅ Handle successful authorization code
if (getCode != null && getCode.isNotEmpty) {
  print("Received authorization code: $getCode");
  setState(() {
    sanadVerificationFailed = false;
    showScanToggle = false;
  });
  
  // Call sanadAuthorization_API and then PostValidateSubscriber
  sanadAuthorization_API();
  
  // After Sanad completes successfully, call PostValidateSubscriber API
  await Future.delayed(Duration(seconds: 1));
  postValidateSubscriberBlock.add(PostValidateSubscriberPressed(
    marketType: marketType,
    isJordanian: true,
    nationalNo: nationalNo.text,
    passportNo: "",
    packageCode: packageCode,
    msisdn: null,
  ));
  
  return;
}
```

### Fix #3: Update Check Button to Call `_trySanadVerification()`

In the `nationalNumber()` widget, replace the check button logic (around line 6415-6446):

**Replace this:**
```dart
onPressed: checkNationalDisabled
    ? null
    :  ()
{
  print('checked');
  if (nationalNo.text == '') {
    setState(() {
      emptyNationalNo = true;
    });
  }
  if (nationalNo.text != '') {
    setState(() {
      emptyNationalNo = false;
    });
  }

  if(nationalNo.text!='' ){
    if(nationalNo.text.length!=10){
      setState(() {
        errorNationalNo = true;
      });

    }else {
      postValidateSubscriberBlock.add(
          PostValidateSubscriberPressed(
              marketType:marketType,isJordanian:isJordanian,
              nationalNo:nationalNo.text,
              passportNo:passportNo.text,
              packageCode:packageCode,
              msisdn: null
          ));

    }
  }
},
```

**With this:**
```dart
onPressed: checkNationalDisabled ? null : () async {
  print('Check button pressed');
  
  // Validate national number is not empty
  setState(() {
    emptyNationalNo = nationalNo.text.isEmpty;
  });

  if (nationalNo.text.isNotEmpty) {
    // Validate length
    if (nationalNo.text.length != 10) {
      setState(() {
        errorNationalNo = true;
      });
      return;
    }

    // ✅ Try Sanad verification first
    await _trySanadVerification();
  }
},
```

### Fix #4: Add Document Scan Toggle UI (After Sanad Fails)

After the Check button in `nationalNumber()` widget, add the toggle UI (similar to GSM):

```dart
// Show Check button only when Sanad validation hasn't been triggered
if (!globalVars.sanadValidation)
  Container(
    // ... existing check button code ...
  ),

// ✅ Show warning message and document type toggle after Sanad fails
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

  // Document Type Selection Toggle
  Text(
    EasyLocalization.of(context).locale == Locale("en", "US")
        ? "Select Document Type"
        : "اختر نوع المستند",
    style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
  ),
  SizedBox(height: 10),

  // Toggle buttons for ID vs Jordanian Passport
  Row(
    children: [
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: globalVars.tackID ? Color(0xFF4f2565) : Colors.white,
            onPrimary: globalVars.tackID ? Colors.white : Color(0xff636f7b),
            side: BorderSide(
              color: globalVars.tackID ? Color(0xFF4f2565) : Color(0xffe4e5eb),
              width: 1,
            ),
            minimumSize: Size(double.infinity, 45),
          ),
          onPressed: () {
            setState(() {
              globalVars.tackID = true;
              globalVars.tackJordanPassport = false;
            });
            _initializeCamera(); // Open ID camera
          },
          child: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Scan ID"
                : "مسح الهوية",
          ),
        ),
      ),
      SizedBox(width: 10),
      Expanded(
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            primary: globalVars.tackJordanPassport ? Color(0xFF4f2565) : Colors.white,
            onPrimary: globalVars.tackJordanPassport ? Colors.white : Color(0xff636f7b),
            side: BorderSide(
              color: globalVars.tackJordanPassport ? Color(0xFF4f2565) : Color(0xffe4e5eb),
              width: 1,
            ),
            minimumSize: Size(double.infinity, 45),
          ),
          onPressed: () {
            setState(() {
              globalVars.tackJordanPassport = true;
              globalVars.tackID = false;
            });
            _initializeCameraMRZ(); // Open Passport camera
          },
          child: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Jordanian Passport"
                : "جواز سفر أردني",
          ),
        ),
      ),
    ],
  ),
  
  // Display captured/processed ID images
  if (globalVars.tackID && (globalVars.capturedBase64.isNotEmpty || _loadImageFrontID || _loadImageBackID)) ...[
    SizedBox(height: 15),
    buildFronID_Image(),
    SizedBox(height: 10),
    buildBackID_Image(),
  ],
  
  // Display captured/processed Jordanian Passport image
  if (globalVars.tackJordanPassport && (globalVars.capturedBase64MRZ.isNotEmpty || _loadImageJordanianPassport)) ...[
    SizedBox(height: 15),
    buildJordanianPassport_Image(),
  ],
],

// ✅ Show Next button after successful document processing
if (_documentProcessingSuccess && globalVars.sanadValidation) ...[
  SizedBox(height: 20),
  Container(
    height: 48,
    width: 420,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Color(0xFF4f2565),
    ),
    child: TextButton(
      onPressed: checkNationalDisabled ? null : () async {
        // Call PostValidateSubscriber API before navigation
        postValidateSubscriberBlock.add(
          PostValidateSubscriberPressed(
            marketType: marketType,
            isJordanian: true,
            nationalNo: nationalNo.text,
            passportNo: "",
            packageCode: packageCode,
            msisdn: null,
          )
        );
      },
      style: TextButton.styleFrom(
        backgroundColor: Color(0xFF4f2565),
        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
      ),
      child: Text(
        "Next",
        style: TextStyle(color: Colors.white, letterSpacing: 0, fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ),
  ),
],
```

---

## Testing Steps

After applying these fixes:

1. **Test Session Creation:**
   ```
   - Open FTTH NationalityList screen
   - Check console logs for "✅ eKYC Token generated"
   - Check console logs for "✅ Session started successfully"
   ```

2. **Test Sanad Flow:**
   ```
   - Enter a valid 10-digit national number
   - Click "Check" button
   - Sanad app should open
   - Complete verification in Sanad
   - Return to app - dialog with username/password should appear
   ```

3. **Test Fallback (if Sanad fails):**
   ```
   - If Sanad doesn't open, document scan toggle should appear
   - Select "Scan ID" or "Jordanian Passport"
   - Camera should open for scanning
   - After successful scan, "Next" button should appear
   ```

---

## Quick Fix Summary

1. ✅ **initState()** - ALREADY FIXED (added session init calls)
2. ❌ **Add _trySanadVerification()** method
3. ❌ **Update Check button** to call _trySanadVerification()
4. ❌ **Update _handleDeepLink()** to call PostValidateSubscriber after Sanad
5. ❌ **Add document scan toggle UI** after Check button

---

## Expected Console Output (Success Path)

```
Starting eKYC token generation...
✅ eKYC Token generated: [token]
Starting eKYC session with token: [token]
✅ Session started successfully!
Session UID: [session-id]
Token UID: [token-id]
✅ eKYC initialization complete
---
Check button pressed
✅ eKYC initialized - attempting Sanad verification
Session UID: [session-id]
National No: 1234567890
Sanad API Response Status: 200
✅ Sanad verification available - launching Sanad URL
[Sanad opens externally]
---
[After Sanad callback]
Received authorization code: [code]
Calling PostValidateSubscriber API
[Dialog shows with username/password/price]
```

---

**Status:** initState() fix applied ✅, remaining fixes documented above ⏳
