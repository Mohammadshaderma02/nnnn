# Loading Indicators & Rescan Button Text - Feature Documentation ✅

## Features Added

### 1. **Loading Indicators During Camera Initialization** 🔄
- Shows a circular progress indicator while the camera is being initialized
- Prevents double-clicking the scan buttons
- Provides visual feedback to the user that something is happening

### 2. **Dynamic Button Text (Scan → Rescan)** 🔄
- Button text changes from "Scan" to "Rescan" after first successful scan
- Applies to all document types (ID, Jordanian Passport, Temporary Passport, Foreign Passport)
- Works in both English and Arabic languages

## Changes Made

### File Modified
**`lib/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/NationalityList.dart`**

### 1. Added Loading State Variables (Lines 179-183)
```dart
// ✅ Loading states for camera initialization
bool _isLoadingIDCamera = false;
bool _isLoadingPassportCamera = false;
bool _isLoadingTemporaryCamera = false;
bool _isLoadingForeignCamera = false;
```

### 2. Updated Scan ID Button (Lines 6568-6620)

**Before:**
```dart
onPressed: () {
  // Initialize camera
},
child: Text("Scan ID"),
```

**After:**
```dart
onPressed: _isLoadingIDCamera ? null : () {
  setState(() {
    _isLoadingIDCamera = true; // ✅ Show loading
  });
  
  Future.microtask(() async {
    try {
      await _initializeCamera();
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingIDCamera = false; // ✅ Hide loading on error
        });
      }
    }
  });
},
child: _isLoadingIDCamera
    ? SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(
            globalVars.tackID ? Colors.white : Color(0xFF4f2565),
          ),
        ),
      )
    : Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? (globalVars.capturedBase64.isNotEmpty && 
               globalVars.capturedBase64.length >= 2 
                 ? "Rescan ID" 
                 : "Scan ID")
            : (globalVars.capturedBase64.isNotEmpty && 
               globalVars.capturedBase64.length >= 2 
                 ? "إعادة مسح الهوية" 
                 : "مسح الهوية"),
      ),
```

### 3. Updated Jordanian Passport Button (Lines 6636-6686)

Similar changes with:
- Loading state: `_isLoadingPassportCamera`
- Rescan logic: Checks `_loadImageJordanianPassport || JordanianPassport.isNotEmpty`
- Button text: "Scan Passport" → "Rescan Passport" / "جواز أردني" → "إعادة مسح جواز"

### 4. Updated Temporary Passport Button (Lines 6838-6890)

Similar changes with:
- Loading state: `_isLoadingTemporaryCamera`
- Rescan logic: Checks `_LoadImageTemporaryPassport || TemporaryPassport.isNotEmpty`
- Button text: "Temporary Passport" → "Rescan Temporary" / "جواز سفر مؤقت" → "إعادة مسح مؤقت"

### 5. Updated Foreign Passport Button (Lines 6907-6959)

Similar changes with:
- Loading state: `_isLoadingForeignCamera`
- Rescan logic: Checks `_LoadImageForeignPassport || ForeignPassport.isNotEmpty`
- Button text: "Foreign Passport" → "Rescan Foreign" / "جواز سفر أجنبي" → "إعادة مسح أجنبي"

### 6. Reset Loading States After Camera Init

Added loading reset in all camera initialization methods:

**ID Camera (Line 2748):**
```dart
setState(() {
  _isCameraInitialized = true;
  _isLoadingIDCamera = false; // ✅ Hide loading indicator
});
```

**Jordanian Passport Camera (Line 3760):**
```dart
setState(() {
  _isCameraInitializedMRZ = true;
  _isLoadingPassportCamera = false; // ✅ Hide loading indicator
});
```

**Temporary Passport Camera (Line 4410):**
```dart
setState(() {
  _isCameraInitializedTemporary = true;
  _isLoadingTemporaryCamera = false; // ✅ Hide loading indicator
});
```

**Foreign Passport Camera (Line 4357):**
```dart
setState(() {
  _isCameraInitializedForeign = true;
  _isLoadingForeignCamera = false; // ✅ Hide loading indicator
});
```

## How It Works

### Loading Indicator Flow

```
1. User clicks "Scan ID" button
   ↓
2. Button becomes disabled (onPressed: null)
   ↓
3. Loading indicator appears (CircularProgressIndicator)
   ↓
4. Camera initialization begins
   ↓
5. Camera successfully initializes
   ↓
6. Loading indicator hidden
   ↓
7. Camera view appears
```

### Rescan Button Text Flow

```
First Time:
1. User sees "Scan ID" button
2. Clicks button → Camera opens
3. Scans document successfully
4. Returns to form

Second Time:
1. User sees "Rescan ID" button (text changed!)
2. Clicks button → Camera opens again
3. Can scan again to replace previous image
```

## Visual Examples

### Button States

#### 1. **Initial State (Not Scanned)**
```
┌─────────────────────────┐
│      Scan ID            │  ← Default text
└─────────────────────────┘
```

#### 2. **Loading State**
```
┌─────────────────────────┐
│      ⏳ (spinner)        │  ← Loading indicator
└─────────────────────────┘
    Button is disabled
```

#### 3. **After First Scan**
```
┌─────────────────────────┐
│      Rescan ID          │  ← Text changed to "Rescan"
└─────────────────────────┘
```

## Rescan Logic

### For Each Document Type

| Document Type | Condition for "Rescan" |
|--------------|------------------------|
| **ID** | `globalVars.capturedBase64.isNotEmpty && globalVars.capturedBase64.length >= 2` |
| **Jordanian Passport** | `_loadImageJordanianPassport \|\| JordanianPassport.isNotEmpty` |
| **Temporary Passport** | `_LoadImageTemporaryPassport \|\| TemporaryPassport.isNotEmpty` |
| **Foreign Passport** | `_LoadImageForeignPassport \|\| ForeignPassport.isNotEmpty` |

### Why Different Conditions?

- **ID**: Requires both front and back (2 images), so checks `length >= 2`
- **Passports**: Single image, so checks image loaded flags or base64 data

## Button Text Translations

### English
| Original | After Scan |
|----------|------------|
| Scan ID | Rescan ID |
| Jordanian Passport | Rescan Passport |
| Temporary Passport | Rescan Temporary |
| Foreign Passport | Rescan Foreign |

### Arabic
| Original | After Scan |
|----------|------------|
| مسح الهوية | إعادة مسح الهوية |
| جواز أردني | إعادة مسح جواز |
| جواز سفر مؤقت | إعادة مسح مؤقت |
| جواز سفر أجنبي | إعادة مسح أجنبي |

## Error Handling

### Scenario: Camera Fails to Initialize

```dart
try {
  await _initializeCamera();
} catch (e) {
  if (mounted) {
    setState(() {
      _isLoadingIDCamera = false; // ✅ Hide loading on error
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Failed to open camera: $e"),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

**Result:** Loading indicator stops, user sees error message, button becomes clickable again

## Benefits

### 1. **Better User Experience** ✅
- Users know something is happening (no confusion)
- Can't accidentally double-click buttons
- Clear visual feedback

### 2. **Intuitive Button Text** ✅
- "Rescan" indicates document was already scanned
- Users understand they can replace previous scan
- Reduces confusion about whether scan was successful

### 3. **Prevents Crashes** ✅
- Disabled buttons during loading prevent race conditions
- Proper error handling ensures UI stays responsive

### 4. **Professional UI** ✅
- Loading indicators are standard in modern apps
- Dynamic button text shows app intelligence
- Matches user expectations

## Testing Scenarios

### ✅ Test 1: Initial Load - Scan ID
```
1. Open FTTH screen (Jordanian tab)
2. Enter national number → Sanad fails
3. Click "Scan ID" button
4. Expected: 
   - Button shows spinner immediately
   - Camera opens after ~1-2 seconds
   - Button is disabled during loading
5. Console: "✅ Camera initialized successfully!"
```

### ✅ Test 2: After Successful Scan - Rescan
```
1. Complete Test 1 (scan both sides of ID)
2. Return to form
3. Expected:
   - Button text changed to "Rescan ID"
   - Images displayed in UI
4. Click "Rescan ID"
5. Expected:
   - Loading indicator shows
   - Camera opens again
   - Can scan new document
```

### ✅ Test 3: Multiple Document Types
```
1. Test Jordanian Passport:
   - Click "Jordanian Passport"
   - See loading indicator
   - Scan passport
   - Return to form
   - Button text: "Rescan Passport"

2. Test Temporary Passport:
   - Switch to Non-Jordanian tab
   - Click "Temporary Passport"
   - See loading indicator
   - Scan passport
   - Button text: "Rescan Temporary"

3. Test Foreign Passport:
   - Click "Foreign Passport"
   - See loading indicator
   - Scan passport
   - Button text: "Rescan Foreign"
```

### ✅ Test 4: Error Handling
```
1. Deny camera permissions (in device settings)
2. Click "Scan ID"
3. Expected:
   - Loading indicator appears
   - Error message shows
   - Loading indicator disappears
   - Button becomes clickable again
```

### ✅ Test 5: Language Switching
```
1. Scan ID successfully
2. Button shows "Rescan ID" (English)
3. Switch app language to Arabic
4. Button shows "إعادة مسح الهوية" (Arabic)
5. Both loading indicator and text work in Arabic
```

### ✅ Test 6: Rapid Clicking Prevention
```
1. Click "Scan ID" button
2. Immediately try clicking again (within 1 second)
3. Expected:
   - Second click does nothing (button disabled)
   - No crash or double camera initialization
   - Loading indicator continues
```

## Implementation Details

### Loading Indicator Styling

```dart
CircularProgressIndicator(
  strokeWidth: 2,  // Thin spinner
  valueColor: AlwaysStoppedAnimation<Color>(
    globalVars.tackID ? Colors.white : Color(0xFF4f2565),
  ),
)
```

**Color Logic:**
- If button is selected (purple background) → White spinner
- If button is not selected (white background) → Purple spinner
- Ensures spinner is always visible against background

### Button Size During Loading

```dart
SizedBox(
  height: 20,
  width: 20,
  child: CircularProgressIndicator(...),
)
```

**Why 20x20?**
- Matches text height
- Doesn't change button size
- Looks balanced in button

### Async Wrapper: Future.microtask

```dart
Future.microtask(() async {
  // Camera initialization code
});
```

**Why microtask?**
- Avoids calling async functions directly in setState
- Prevents potential crashes
- Ensures proper widget lifecycle

## Edge Cases Handled

### ✅ Widget Disposed During Loading
```dart
if (!mounted) return;
setState(() {
  _isLoadingIDCamera = false;
});
```
**Protection:** Only updates state if widget still exists

### ✅ Camera Init Fails
```dart
catch (e) {
  if (mounted) {
    setState(() {
      _isLoadingIDCamera = false; // Reset loading
    });
    // Show error to user
  }
}
```
**Protection:** Loading indicator stops, user can try again

### ✅ eKYC Not Initialized
```dart
if (!isEkycInitialized) {
  setState(() {
    _isLoadingTemporaryCamera = false;
  });
  ScaffoldMessenger.of(context).showSnackBar(...);
}
```
**Protection:** Shows error, resets loading state

## Summary

✅ **Loading Indicators:** All 4 scan buttons show spinner during camera init  
✅ **Rescan Text:** Button text changes after first successful scan  
✅ **Error Handling:** Loading stops on errors, user can retry  
✅ **Bilingual:** Works in English and Arabic  
✅ **Professional UI:** Matches modern app standards  
✅ **Crash Prevention:** Disabled buttons prevent double-click issues  

---

**Status:** ✅ COMPLETE  
**Files Modified:** 1 (FTTH/NationalityList.dart)  
**Lines Changed:** ~300 lines (4 buttons + 4 camera inits + variables)  
**Risk Level:** LOW (additive only, improves UX)  
**Testing Priority:** MEDIUM (test all scan buttons)  

---

## Quick Test

```
1. Open FTTH → Jordanian tab
2. Enter national number → Sanad fails
3. Click "Scan ID"
   → Should see spinner (not text)
   → Button disabled
4. Camera opens
5. Scan both sides
6. Return to form
7. Button text: "Rescan ID" ✅
8. Click "Rescan ID"
   → Spinner shows again ✅
```

If you see the loading spinner and "Rescan" text, it's working! 🎉
