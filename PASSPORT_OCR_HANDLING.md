# Passport OCR Data Processing - Updates

## Overview
Updated the passport document processing methods in `GSM_NationalityList.dart` to correctly handle the OCR response data structure for passport scans, specifically handling name composition and date parsing.

## Updated Date
December 10, 2025

---

## API Response Structure

Based on the API response provided, the passport OCR data comes in the following structure:

```json
{
  "data": {
    "status": "working",
    "uid": "36de778c-4250-4c7e-87f1-5e3d582c240e",
    "ocrData": {
      "code": "passport",
      "dateOfBirth": {
        "year": 1,
        "month": 3,
        "day": 30
      },
      "documentNumber": "S0896546",
      "expirationDate": {
        "year": 30,
        "month": 7,
        "day": 21
      },
      "givenNames": "MOHAMMAD MAHMOUD MOHAMAD",
      "surname": "SHADERMA",
      "issuingCountry": "JOR",
      "nationality": "JOR",
      "sex": "male",
      "nationalNumber": "2000264514",
      "expired": false
    }
  }
}
```

---

## Changes Made

### File Modified
- `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_NationalityList.dart`

### Methods Updated

#### 1. **`documentProcessingPassport_API()`** (Lines 5802-5925)
**Purpose:** Processes Jordanian passport OCR data

**Changes:**
- ✅ Combines `givenNames` and `surname` fields to create full name
- ✅ Parses date objects `{year, month, day}` correctly
- ✅ Converts 2-digit years to 4-digit years intelligently
- ✅ Extracts `nationalNumber` field for Jordanian citizens
- ✅ Formats dates as `YYYY-MM-DD` format

#### 2. **`documentProcessingForignPassport_API()`** (Lines 5665-5748)
**Purpose:** Processes foreign (non-Jordanian) passport OCR data

**Changes:**
- ✅ Combines `givenNames` and `surname` fields to create full name
- ✅ Parses date objects `{year, month, day}` correctly
- ✅ Converts 2-digit years to 4-digit years intelligently
- ✅ Formats dates as `YYYY-MM-DD` format
- ✅ Sets nationalNumber to extracted value or "-" if not available

---

## Technical Implementation Details

### 1. Name Composition

**Old Approach:**
```dart
globalVars.fullNameEn = data['ocrData']['givenNames'];
```

**New Approach:**
```dart
String givenNames = data['ocrData']['givenNames'] ?? "";
String surname = data['ocrData']['surname'] ?? "";
String fullName = givenNames.isNotEmpty && surname.isNotEmpty 
    ? "$givenNames $surname" 
    : (givenNames.isNotEmpty ? givenNames : surname);
globalVars.fullNameEn = fullName;
```

**Result:** Produces complete name like "MOHAMMAD MAHMOUD MOHAMAD SHADERMA" instead of just "MOHAMMAD MAHMOUD MOHAMAD"

---

### 2. Date of Birth Parsing

**API Date Structure:**
```json
"dateOfBirth": {
  "year": 1,    // 2-digit year (01 = 2001)
  "month": 3,   // Month number
  "day": 30     // Day number
}
```

**Processing Logic:**
```dart
var dobData = data['ocrData']['dateOfBirth'];
String year = dobData['year'].toString().padLeft(2, '0');
String month = dobData['month'].toString().padLeft(2, '0');
String day = dobData['day'].toString().padLeft(2, '0');

// Convert 2-digit year to full year
int yearInt = int.parse(year);
if (yearInt < 100) {
  // Years 00-30 → 2000-2030
  // Years 31-99 → 1931-1999
  yearInt = yearInt <= 30 ? 2000 + yearInt : 1900 + yearInt;
}
globalVars.birthdate = '$yearInt-$month-$day';
```

**Examples:**
| API Year | Converted Year | Full Date |
|----------|---------------|-----------|
| 1 | 2001 | 2001-03-30 |
| 25 | 2025 | 2025-05-15 |
| 30 | 2030 | 2030-12-01 |
| 85 | 1985 | 1985-07-22 |
| 99 | 1999 | 1999-11-10 |

---

### 3. Expiration Date Parsing

**API Date Structure:**
```json
"expirationDate": {
  "year": 30,   // 2-digit year (30 = 2030)
  "month": 7,   // Month number
  "day": 21     // Day number
}
```

**Processing Logic:**
```dart
var expData = data['ocrData']['expirationDate'];
String expYear = expData['year'].toString().padLeft(2, '0');
String expMonth = expData['month'].toString().padLeft(2, '0');
String expDay = expData['day'].toString().padLeft(2, '0');

int expYearInt = int.parse(expYear);
if (expYearInt < 100) {
  // Expiration dates typically in future
  // Years 00-50 → 2000-2050
  // Years 51-99 → 1951-1999
  expYearInt = expYearInt <= 50 ? 2000 + expYearInt : 1900 + expYearInt;
}
globalVars.expirayDate = '$expYearInt-$expMonth-$expDay';
```

**Examples:**
| API Year | Converted Year | Full Date |
|----------|---------------|-----------|
| 30 | 2030 | 2030-07-21 |
| 35 | 2035 | 2035-12-31 |
| 50 | 2050 | 2050-01-01 |
| 85 | 1985 | 1985-06-15 |

---

### 4. National Number Extraction

**For Jordanian Passports:**
```dart
globalVars.natinalityNumber = data['ocrData']['nationalNumber'] 
    ?? data['ocrData']['userPersonalNumber'] 
    ?? "";
```

**For Foreign Passports:**
```dart
globalVars.natinalityNumber = data['ocrData']['nationalNumber'] ?? "-";
```

**Fallback Logic:**
1. First try to get `nationalNumber`
2. If not available for Jordanian, try `userPersonalNumber`
3. For foreign passports, default to "-"

---

## Global Variables Set

After successful passport processing, the following global variables are populated:

| Variable | Source | Example |
|----------|--------|---------|
| `globalVars.fullNameEn` | `givenNames + surname` | "MOHAMMAD MAHMOUD MOHAMAD SHADERMA" |
| `globalVars.fullNameAr` | `localUserGivenNames` (Jordanian only) | "محمد محمود محمد شادرما" |
| `globalVars.natinalityNumber` | `nationalNumber` or `userPersonalNumber` | "2000264514" |
| `globalVars.cardNumber` | `documentNumber` | "S0896546" |
| `globalVars.birthdate` | Parsed from `dateOfBirth` | "2001-03-30" |
| `globalVars.expirayDate` | Parsed from `expirationDate` | "2030-07-21" |
| `globalVars.gender` | `sex` | "male" |
| `globalVars.bloodGroup` | Not in passport | "-" |
| `globalVars.registrationNumber` | Not in passport | "-" |

---

## Date Format Conversion

### Input Format (API Response)
```json
{
  "year": 1,
  "month": 3,
  "day": 30
}
```

### Output Format (Application)
```
2001-03-30
```

### Conversion Rules

#### For Birth Dates:
- **Years 0-30**: Add 2000 (e.g., 1 → 2001, 30 → 2030)
- **Years 31-99**: Add 1900 (e.g., 85 → 1985, 99 → 1999)

#### For Expiration Dates:
- **Years 0-50**: Add 2000 (e.g., 30 → 2030, 50 → 2050)
- **Years 51-99**: Add 1900 (e.g., 85 → 1985)

**Rationale:** Expiration dates are typically in the future, so we allow a wider range (up to 50) before assuming 19xx century.

---

## Testing Scenarios

### Test Case 1: Jordanian Passport (Sample Data)
**Input:**
```json
{
  "givenNames": "MOHAMMAD MAHMOUD MOHAMAD",
  "surname": "SHADERMA",
  "nationalNumber": "2000264514",
  "documentNumber": "S0896546",
  "dateOfBirth": {"year": 1, "month": 3, "day": 30},
  "expirationDate": {"year": 30, "month": 7, "day": 21},
  "sex": "male"
}
```

**Expected Output:**
- ✅ Full Name: "MOHAMMAD MAHMOUD MOHAMAD SHADERMA"
- ✅ National Number: "2000264514"
- ✅ Document Number: "S0896546"
- ✅ Birth Date: "2001-03-30"
- ✅ Expiration Date: "2030-07-21"
- ✅ Gender: "male"

---

### Test Case 2: Foreign Passport (No National Number)
**Input:**
```json
{
  "givenNames": "JOHN ROBERT",
  "surname": "SMITH",
  "documentNumber": "AB1234567",
  "dateOfBirth": {"year": 85, "month": 11, "day": 15},
  "expirationDate": {"year": 35, "month": 12, "day": 31},
  "sex": "male"
}
```

**Expected Output:**
- ✅ Full Name: "JOHN ROBERT SMITH"
- ✅ National Number: "-"
- ✅ Document Number: "AB1234567"
- ✅ Birth Date: "1985-11-15"
- ✅ Expiration Date: "2035-12-31"
- ✅ Gender: "male"

---

### Test Case 3: Missing Surname
**Input:**
```json
{
  "givenNames": "AHMED",
  "surname": "",
  "nationalNumber": "1234567890",
  "documentNumber": "P1234567",
  "dateOfBirth": {"year": 95, "month": 5, "day": 20},
  "expirationDate": {"year": 28, "month": 8, "day": 10},
  "sex": "male"
}
```

**Expected Output:**
- ✅ Full Name: "AHMED" (surname omitted if empty)
- ✅ National Number: "1234567890"
- ✅ Birth Date: "1995-05-20"
- ✅ Expiration Date: "2028-08-10"

---

### Test Case 4: Passport Born in 2000s, Expires in 2020s
**Input:**
```json
{
  "givenNames": "SARA",
  "surname": "ALI",
  "dateOfBirth": {"year": 5, "month": 1, "day": 1},
  "expirationDate": {"year": 25, "month": 1, "day": 1}
}
```

**Expected Output:**
- ✅ Birth Date: "2005-01-01"
- ✅ Expiration Date: "2025-01-01"

---

## Error Handling

### Null Safety
All fields use null-coalescing operators to prevent crashes:

```dart
String givenNames = data['ocrData']['givenNames'] ?? "";
String surname = data['ocrData']['surname'] ?? "";
```

### Missing Fields
- If `givenNames` is empty but `surname` exists → use surname only
- If both are empty → empty string
- If `nationalNumber` missing → fallback to `userPersonalNumber`
- If dates are malformed → existing try-catch prevents crashes

---

## Benefits

✅ **Accurate Name Display**: Full name includes both given names and surname
✅ **Correct Date Interpretation**: 2-digit years properly converted to 4-digit format
✅ **Consistent Date Format**: All dates in `YYYY-MM-DD` format for consistency
✅ **Robust Null Handling**: No crashes from missing or null fields
✅ **Flexible National Number**: Handles both `nationalNumber` and `userPersonalNumber` fields
✅ **Foreign Passport Support**: Works for both Jordanian and non-Jordanian passports

---

## Related Files

- **Main File**: `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_NationalityList.dart`
- **Global Variables**: Referenced in `global_variables.dart` (implied)
- **API Endpoint**: `https://079.jo/wid/api/v1/consumer/session/{sessionUid}/document/process`

---

## Future Enhancements

Potential improvements:
1. Add validation for expired passports using `expired` field
2. Store `issuingCountry` and `nationality` in global variables
3. Add age calculation from `dateOfBirth`
4. Validate passport number format based on country
5. Add multi-language support for name display
6. Store MRZ text field for reference

---

**Implementation Status:** ✅ Complete and Ready for Testing
**Last Updated:** December 10, 2025
