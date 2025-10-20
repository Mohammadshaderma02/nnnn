# Non-Jordanian Customer Information - eKYC Integration

## Overview
Updated `GSM_NonJordainianCustomerInformation.dart` to integrate with the eKYC passport processing flow. When passport data is available from OCR processing, the form automatically populates and disables relevant fields.

## Updated Date
December 10, 2025

---

## Changes Summary

### File Modified
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_NonJordainianCustomerInformation.dart`

### Key Changes

1. ✅ **Import globalVars** - Added import for global_variables.dart
2. ✅ **State Variable** - Added `isDataFromEkyc` to track if data came from eKYC
3. ✅ **Auto-populate Fields** - Parse passport OCR data and populate form fields
4. ✅ **Disable Fields** - Disable name and date fields when populated from eKYC
5. ✅ **Hide Passport Capture** - Hide passport image capture section when data exists

---

## Data Flow

```
┌─────────────────────────────────────┐
│  GSM_NationalityList.dart           │
│  (Passport OCR Processing)          │
└─────────────────────────────────────┘
                 │
                 ▼
    documentProcessingPassport_API()
    documentProcessingForignPassport_API()
                 │
                 ▼
         ┌────────────────┐
         │  globalVars    │
         ├────────────────┤
         │ fullNameEn     │ → "MOHAMMAD MAHMOUD MOHAMAD SHADERMA"
         │ birthdate      │ → "2001-03-30"
         │ expirayDate    │ → "2030-07-21"
         │ nationalNumber │ → "2000264514"
         └────────────────┘
                 │
                 ▼
┌─────────────────────────────────────┐
│  GSM_NonJordainianCustomerInfo.dart │
│  (Form Auto-Population)             │
└─────────────────────────────────────┘
                 │
                 ▼
         ┌────────────────┐
         │ Form Fields    │
         ├────────────────┤
         │ FirstName      │ → "MOHAMMAD"
         │ SecondName     │ → "MAHMOUD"
         │ ThirdName      │ → "MOHAMAD"
         │ LastName       │ → "SHADERMA"
         │ day/month/year │ → "30/03/2001"
         │ documentExpiry │ → "21/07/2030"
         └────────────────┘
```

---

## Technical Implementation

### 1. State Variable Added

```dart
bool isDataFromEkyc = false; // Track if data came from eKYC passport processing
```

**Purpose:** Controls whether fields should be disabled and passport capture hidden.

---

### 2. initState() Enhancement

Added logic to check for and populate data from `globalVars`:

```dart
void initState() {
  // ... existing code ...
  
  // ✅ Check if data is available from eKYC passport processing
  if (globalVars.fullNameEn != null && globalVars.fullNameEn.isNotEmpty) {
    setState(() {
      isDataFromEkyc = true;
    });
    
    // Parse name parts
    List<String> nameParts = globalVars.fullNameEn.trim().split(' ');
    // ... populate FirstName, SecondName, ThirdName, LastName
    
    // Parse and populate birthdate
    // ... populate day, month, year
    
    // Populate document expiry date
    // ... populate documentExpiryDate
  }
}
```

---

### 3. Name Parsing Logic

The full name from passport OCR is split intelligently:

| Input | FirstName | SecondName | ThirdName | LastName |
|-------|-----------|------------|-----------|----------|
| `"MOHAMMAD MAHMOUD MOHAMAD SHADERMA"` | MOHAMMAD | MAHMOUD | MOHAMAD | SHADERMA |
| `"JOHN ROBERT SMITH"` | JOHN | ROBERT | *(empty)* | SMITH |
| `"AHMED ALI"` | AHMED | *(empty)* | *(empty)* | ALI |
| `"SARA"` | SARA | *(empty)* | *(empty)* | *(empty)* |

**Parsing Rules:**
- **4+ parts:** First → Second → Third → Rest (joined as Last)
- **3 parts:** First → Second → Last
- **2 parts:** First → Last
- **1 part:** First only

---

### 4. Date Format Conversions

#### Birthdate Conversion
**Input Format:** `YYYY-MM-DD` (e.g., `"2001-03-30"`)  
**Output Format:** Separate fields `day`, `month`, `year`

```dart
// Input: "2001-03-30"
List<String> dateParts = globalVars.birthdate.split('-');
year.text = dateParts[0];  // "2001"
month.text = dateParts[1]; // "03"
day.text = dateParts[2];   // "30"
```

#### Document Expiry Date Conversion
**Input Format:** `YYYY-MM-DD` (e.g., `"2030-07-21"`)  
**Output Format:** `DD/MM/YYYY` (e.g., `"21/07/2030"`)

```dart
// Input: "2030-07-21"
List<String> dateParts = globalVars.expirayDate.split('-');
documentExpiryDate.text = '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
// Output: "21/07/2030"
```

---

### 5. Field Disabling

All name and date fields are disabled when `isDataFromEkyc == true`:

```dart
TextField(
  controller: FirstName,
  enabled: !isDataFromEkyc, // ✅ Disabled if from eKYC
  style: TextStyle(
    color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)
  ),
  // ...
)
```

**Disabled Fields:**
- ✅ First Name
- ✅ Second Name
- ✅ Third Name
- ✅ Last Name
- ✅ Day (birthdate)
- ✅ Month (birthdate)
- ✅ Year (birthdate)
- ✅ Document Expiry Date

**Visual Indicator:** Disabled fields show text in gray color (`0xFF5A6F84`) instead of black.

---

### 6. Passport Capture Section Hidden

When data exists from eKYC, the passport capture section is completely hidden:

```dart
// ✅ Hide passport capture section when data is from eKYC
!isDataFromEkyc
    ? Column(
        children: [
          Container(/* Passport Photo Header */),
          Container(child: buildImagePassport()),
        ],
      )
    : Container() // Empty container when eKYC data exists
```

**Result:**  
- **With eKYC Data:** Passport capture section NOT shown
- **Without eKYC Data:** Normal passport capture UI displayed

---

## User Experience

### Scenario 1: User Completes Passport Scan in eKYC Flow

**Steps:**
1. User scans passport in `GSM_NationalityList.dart`
2. OCR processing extracts data to `globalVars`
3. User navigates to Non-Jordanian Customer Information screen
4. Form **automatically populates** with:
   - ✅ Full name split across 4 fields
   - ✅ Birthdate in day/month/year format
   - ✅ Document expiry date formatted
5. All populated fields are **disabled** (gray text)
6. Passport capture section is **hidden**
7. User can only edit:
   - Reference number
   - SIM card
   - Other non-disabled fields

**Benefits:**
- ✅ No duplicate data entry
- ✅ Prevents accidental modifications
- ✅ Cleaner UI (no redundant capture option)
- ✅ Faster form completion

---

### Scenario 2: User Did NOT Complete eKYC Passport Scan

**Steps:**
1. User navigates directly to Non-Jordanian Customer Information
2. `globalVars.fullNameEn` is empty
3. Form shows **normally**:
   - All fields enabled
   - Passport capture section visible
4. User must **manually enter** all information
5. User must **capture passport photo**

**This maintains backward compatibility!**

---

## Field Mapping

| globalVars Field | Form Field | Transformation |
|------------------|------------|----------------|
| `fullNameEn` | `FirstName`, `SecondName`, `ThirdName`, `LastName` | Split by space, distributed across 4 fields |
| `birthdate` (YYYY-MM-DD) | `day`, `month`, `year` | Split by `-`, extract parts |
| `expirayDate` (YYYY-MM-DD) | `documentExpiryDate` | Convert to DD/MM/YYYY format |
| `nationalNumber` | *(Not used in this form)* | Available if needed |
| `cardNumber` | `PassportNumber` *(constructor param)* | Pre-filled from previous screen |

---

## Testing Scenarios

### Test Case 1: Standard Passport Data
**Input:**
```dart
globalVars.fullNameEn = "MOHAMMAD MAHMOUD MOHAMAD SHADERMA";
globalVars.birthdate = "2001-03-30";
globalVars.expirayDate = "2030-07-21";
```

**Expected Output:**
```
FirstName:     "MOHAMMAD"
SecondName:    "MAHMOUD"
ThirdName:     "MOHAMAD"
LastName:      "SHADERMA"
day:           "30"
month:         "03"
year:          "2001"
documentExpiry: "21/07/2030"
```

✅ All fields disabled  
✅ Passport capture section hidden

---

### Test Case 2: Three-Part Name
**Input:**
```dart
globalVars.fullNameEn = "JOHN ROBERT SMITH";
globalVars.birthdate = "1985-11-15";
globalVars.expirayDate = "2035-12-31";
```

**Expected Output:**
```
FirstName:     "JOHN"
SecondName:    "ROBERT"
ThirdName:     ""
LastName:      "SMITH"
day:           "15"
month:         "11"
year:          "1985"
documentExpiry: "31/12/2035"
```

---

### Test Case 3: No eKYC Data
**Input:**
```dart
globalVars.fullNameEn = null; // or empty
```

**Expected Output:**
```
FirstName:     "" (enabled, editable)
SecondName:    "" (enabled, editable)
ThirdName:     "" (enabled, editable)
LastName:      "" (enabled, editable)
day:           "" (enabled, editable)
month:         "" (enabled, editable)
year:          "" (enabled, editable)
documentExpiry: "" (enabled, date picker works)
```

✅ All fields enabled  
✅ Passport capture section visible

---

### Test Case 4: Long Compound Last Name
**Input:**
```dart
globalVars.fullNameEn = "AHMAD ABDULLAH MOHAMMED AL RASHID AL MAKTOUM";
```

**Expected Output:**
```
FirstName:  "AHMAD"
SecondName: "ABDULLAH"
ThirdName:  "MOHAMMED"
LastName:   "AL RASHID AL MAKTOUM" // Rest joined with spaces
```

---

## Error Handling

### Date Parsing Errors
If date format is unexpected, errors are caught and logged:

```dart
try {
  List<String> dateParts = globalVars.birthdate.split('-');
  // ... populate fields
} catch (e) {
  print('❌ Error parsing birthdate: $e');
  // Fields remain empty, user can manually enter
}
```

**Graceful Degradation:** If parsing fails, fields remain empty but editable.

---

### Name Parsing Edge Cases

| Edge Case | Handling |
|-----------|----------|
| Single word name | → FirstName only |
| Empty string | → All fields empty (treated as no data) |
| Extra whitespace | → `.trim()` before split |
| Null value | → Condition `!= null && .isNotEmpty` prevents errors |

---

## Benefits

### For Users
✅ **Faster Form Completion** - No re-entering passport data  
✅ **Fewer Errors** - OCR data is more accurate than manual typing  
✅ **Better UX** - Disabled fields indicate pre-verified data  
✅ **Clear Workflow** - Passport capture not needed when data exists

### For Developers
✅ **Data Consistency** - Single source of truth (globalVars)  
✅ **Maintainable** - Clear flag (`isDataFromEkyc`) controls behavior  
✅ **Backward Compatible** - Existing flows without eKYC still work  
✅ **Testable** - Easy to test with/without globalVars data

### For Business
✅ **Reduced Processing Time** - Faster customer onboarding  
✅ **Higher Data Quality** - OCR-extracted data vs manual entry  
✅ **Better Compliance** - Pre-verified passport data  
✅ **Improved Metrics** - Track eKYC vs manual flow completion rates

---

## Related Files

| File | Purpose |
|------|---------|
| `GSM_NationalityList.dart` | Passport OCR processing, populates globalVars |
| `GSM_NonJordainianCustomerInformation.dart` | ✅ **This file** - Form with auto-population |
| `global_variables.dart` | Shared state for passport data |
| `PASSPORT_OCR_HANDLING.md` | Documentation for OCR processing |

---

## Future Enhancements

Potential improvements:
1. Add visual indicator (icon/badge) showing "Data from eKYC"
2. Allow "Edit" button to unlock fields if needed
3. Show original passport image thumbnail
4. Add validation against passport data before submission
5. Track which fields were auto-populated vs manually edited
6. Add "Re-scan Passport" option even when data exists

---

## Migration Notes

### For Existing Implementations

**No Breaking Changes!**  
- Existing manual flow continues to work
- eKYC integration is additive, not replacing

**To Enable:**  
- Ensure `globalVars` is properly populated in passport scanning flow
- Data automatically detected and used in this screen

**To Disable:**  
- Simply don't populate `globalVars.fullNameEn`
- Form behaves as before (all fields editable)

---

## Debugging

### Check if eKYC Data is Being Used

Look for console logs in initState():

```
✅ Populated fields from eKYC data
Name: MOHAMMAD MAHMOUD MOHAMAD SHADERMA
Birthdate: 30/03/2001
Expiry Date: 21/07/2030
```

If this appears, eKYC integration is active.

### Verify Field States

Check the value of `isDataFromEkyc`:
- `true` → Fields should be disabled, passport capture hidden
- `false` → Normal behavior

---

**Implementation Status:** ✅ Complete and Ready for Testing  
**Last Updated:** December 10, 2025
