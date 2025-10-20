# FTTH Sanad Error Handling & Non-Jordanian Support Fix

## Current Status

### ✅ Already Working (from previous fixes):
1. **Session initialization in `initState()`** - Creates session and token when screen loads
2. **Check button calls `_trySanadVerification()`** - Attempts Sanad before document scanning
3. **Error handling in `_trySanadVerification()`** - Sets `globalVars.sanadValidation = true` on:
   - eKYC initialization failure
   - Sanad API returning non-200 status
   - Sanad verification not available
   - Network/connection errors
4. **Comprehensive debug logging** - All steps are logged to console

## Issue Reported

❌ **Problem 1:** When Sanad has errors (3 trials exceeded, API error, etc.), scan options don't appear  
❌ **Problem 2:** Non-Jordanian handling is different from GSM

## Root Cause Analysis

### Problem 1: Scan Toggle Not Showing
The `_trySanadVerification()` method correctly sets `globalVars.sanadValidation = true` on errors, but the `nationalNumber()` widget doesn't display scan toggle buttons when this flag is `true`.

**GSM Behavior:**
- When `globalVars.sanadValidation = true`, GSM shows toggle buttons for:
  - Scan ID
  - Jordanian Passport

**FTTH Current Behavior:**
- The `nationalNumber()` widget doesn't check `globalVars.sanadValidation`
- No scan toggle buttons appear after Sanad fails

### Problem 2: Non-Jordanian Flow
The FTTH file has a `passportNumber()` widget for non-Jordanians, but it directly calls the API without attempting eKYC document scanning first (unlike GSM which offers scan options for non-Jordanians too).

## Required Changes

### Change 1: Add Scan Toggle Buttons to `nationalNumber()` Widget

**Location:** After the "Check" button in the `nationalNumber()` widget (around line 6488)

**Add this code:**
```dart
SizedBox(height: 20),

// ✅ Show scan options when Sanad fails
if (globalVars.sanadValidation == true)
  Column(
    children: [
      Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Sanad verification unavailable. Please scan your document:"
            : "التحقق عبر سند غير متاح. يرجى مسح مستندك:",
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 15),
      
      // Scan ID Button
      Container(
        height: 48,
        width: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Color(0xFF4f2565), width: 2),
          color: Colors.white,
        ),
        child: TextButton(
          onPressed: () {
            print("✅ User selected: Scan ID");
            _initializeCamera(); // Open ID scanner
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          child: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Scan ID"
                : "مسح الهوية",
            style: TextStyle(
              color: Color(0xFF4f2565),
              letterSpacing: 0,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(height: 10),
      
      // Scan Jordanian Passport Button
      Container(
        height: 48,
        width: 420,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          border: Border.all(color: Color(0xFF4f2565), width: 2),
          color: Colors.white,
        ),
        child: TextButton(
          onPressed: () {
            print("✅ User selected: Scan Jordanian Passport");
            _showPassportScanOptions(); // Show passport type selection
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            shape: const BeveledRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          child: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Scan Jordanian Passport"
                : "مسح جواز السفر الأردني",
            style: TextStyle(
              color: Color(0xFF4f2565),
              letterSpacing: 0,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
      SizedBox(height: 20),
    ],
  ),
```

**What this does:**
- Shows a message explaining that Sanad is unavailable
- Displays two buttons: "Scan ID" and "Scan Jordanian Passport"
- Clicking "Scan ID" opens the ID scanner camera
- Clicking "Scan Jordanian Passport" shows the passport type selection dialog

### Change 2: Ensure `_showPassportScanOptions()` Method Exists

The FTTH file should already have this method (similar to GSM). If not, add it:

```dart
void _showPassportScanOptions() {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
              ? "Select Passport Type"
              : "اختر نوع جواز السفر",
        ),
        content: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
              ? "Please select the type of passport you want to scan:"
              : "الرجاء تحديد نوع جواز السفر الذي تريد مسحه:",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US") 
                  ? "Cancel" 
                  : "إلغاء",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeCameraMRZ(); // Jordanian Passport
            },
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Jordanian Passport"
                  : "جواز سفر أردني",
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              _initializeCameraForeign(); // Foreign Passport
            },
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Foreign Passport"
                  : "جواز سفر أجنبي",
            ),
          ),
        ],
      );
    },
  );
}
```

### Change 3: Update Non-Jordanian Section to Offer Scan Options

The `passportNumber()` widget currently directly calls the API. To match GSM behavior, it should also offer scan options for non-Jordanians.

**Add scan toggle buttons to `passportNumber()` widget:**

```dart
// After the "Check" button (around line 6656)
SizedBox(height: 20),

// ✅ Show scan options for non-Jordanians
Column(
  children: [
    Text(
      EasyLocalization.of(context).locale == Locale("en", "US")
          ? "Or scan your passport document:"
          : "أو امسح جواز سفرك:",
      style: TextStyle(
        color: Color(0xFF4f2565),
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    ),
    SizedBox(height: 15),
    
    // Scan Foreign Passport Button
    Container(
      height: 48,
      width: 420,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: Color(0xFF4f2565), width: 2),
        color: Colors.white,
      ),
      child: TextButton(
        onPressed: () {
          print("✅ User selected: Scan Foreign Passport");
          _initializeCameraForeign(); // Open foreign passport scanner
        },
        style: TextButton.styleFrom(
          backgroundColor: Colors.white,
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
        child: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
              ? "Scan Passport"
              : "مسح جواز السفر",
          style: TextStyle(
            color: Color(0xFF4f2565),
            letterSpacing: 0,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
    SizedBox(height: 20),
  ],
),
```

## Expected Flow After Fix

### Scenario 1: Jordanian - Sanad Success
1. User opens FTTH NationalityList screen
2. Session created automatically ✅
3. User enters 10-digit national number
4. User clicks "Check" button
5. `_trySanadVerification()` is called
6. Sanad API succeeds → Sanad app opens
7. User completes verification in Sanad
8. Returns to app → Dialog shows with credentials

### Scenario 2: Jordanian - Sanad Fails (3 Trials / API Error)
1. User opens FTTH NationalityList screen
2. Session created automatically ✅
3. User enters 10-digit national number
4. User clicks "Check" button
5. `_trySanadVerification()` is called
6. Sanad API fails (3 trials exceeded, API error, etc.)
7. **✅ NEW:** `globalVars.sanadValidation = true` is set
8. **✅ NEW:** Two scan buttons appear:
   - "Scan ID"
   - "Scan Jordanian Passport"
9. User clicks "Scan ID" → ID camera opens
10. User scans front and back of ID
11. Document processing API is called
12. On success → "Check" button becomes "Next"
13. User clicks "Next" → Proceeds to customer information screen

### Scenario 3: Non-Jordanian - With Document Scan
1. User opens FTTH NationalityList screen
2. User selects "Non-Jordanian" tab
3. User sees passport number field
4. **✅ NEW:** User sees "Scan Passport" button below the field
5. User clicks "Scan Passport"
6. Foreign passport camera opens
7. User scans passport
8. Document processing API is called
9. On success → "Check" button becomes "Next"
10. User clicks "Next" → Proceeds to customer information screen

### Scenario 4: Non-Jordanian - Manual Entry
1. User opens FTTH NationalityList screen
2. User selects "Non-Jordanian" tab
3. User manually enters passport number
4. User clicks "Check" button
5. API is called with passport number
6. Dialog shows with credentials

## Files to Modify

1. **lib/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/NationalityList.dart**
   - Line ~6488: Add scan toggle buttons to `nationalNumber()` widget (after Check button)
   - Line ~6656: Add scan toggle button to `passportNumber()` widget (after Check button)
   - Verify `_showPassportScanOptions()` method exists (should already be there from GSM migration)

## Verification Checklist

After applying the changes, verify:

- ✅ Session is created when screen loads
- ✅ Clicking "Check" with valid national number attempts Sanad
- ✅ **NEW:** When Sanad fails (any error), scan toggle buttons appear
- ✅ **NEW:** Clicking "Scan ID" opens ID camera
- ✅ **NEW:** Clicking "Scan Jordanian Passport" shows passport type selection
- ✅ **NEW:** Non-Jordanian section has "Scan Passport" button
- ✅ **NEW:** Clicking "Scan Passport" opens foreign passport camera
- ✅ After successful document scan, user can proceed with "Next" button
- ✅ Comprehensive logging in console for debugging

## Testing Instructions

### Test 1: Sanad Failure Shows Scan Options
1. Open FTTH NationalityList screen (Jordanian tab)
2. Enter a valid 10-digit national number
3. Click "Check" button
4. **Simulate/wait for Sanad to fail** (3 trials, API error, timeout, etc.)
5. **Verify:** Two scan buttons should appear:
   - "Scan ID"
   - "Scan Jordanian Passport"
6. Click "Scan ID" → Verify ID camera opens
7. Click "Scan Jordanian Passport" → Verify passport type selection dialog appears

### Test 2: Non-Jordanian Document Scan
1. Open FTTH NationalityList screen (Non-Jordanian tab)
2. **Verify:** Passport number field is visible
3. **Verify:** "Scan Passport" button is visible below the field
4. Click "Scan Passport" button
5. **Verify:** Foreign passport camera opens
6. Scan a passport
7. **Verify:** Document processing API is called
8. **Verify:** On success, user can proceed

### Test 3: Full Jordanian Flow with Sanad Fallback
1. Open FTTH NationalityList screen (Jordanian tab)
2. Enter: 1234567890 (or a test national number)
3. Click "Check"
4. If Sanad fails → Use "Scan ID" button
5. Scan front of ID
6. Scan back of ID
7. Wait for processing
8. **Verify:** Check button changes to "Next"
9. Click "Next"
10. **Verify:** Customer information screen appears with pre-filled data

## Summary

This fix ensures that:
1. **✅ Sanad errors are handled gracefully** - When Sanad fails for any reason (3 trials, API error, etc.), the app shows scan toggle buttons instead of leaving the user stuck
2. **✅ Matches GSM behavior** - The FTTH flow now matches the GSM flow for both Jordanians and non-Jordanians
3. **✅ Better UX** - Users always have a way to proceed, even if Sanad is unavailable
4. **✅ Maintains existing functionality** - All existing logic (session initialization, Sanad verification, etc.) remains intact

## Implementation Priority

**HIGH PRIORITY:**
1. Add scan toggle buttons to `nationalNumber()` widget (Change 1)
2. Add scan button to `passportNumber()` widget (Change 3)

**MEDIUM PRIORITY:**
3. Ensure `_showPassportScanOptions()` method exists (Change 2)

**DONE:**
- ✅ Session initialization
- ✅ Sanad verification logic
- ✅ Error handling with `globalVars.sanadValidation`
- ✅ Debug logging

---

**Next Step:** Apply Change 1 and Change 3 to the FTTH NationalityList.dart file.
