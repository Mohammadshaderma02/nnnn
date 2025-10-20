# Jordanian Next Button - API Integration

## Overview
Added `PostValidateSubscriber` API call to the Jordanian Next button before navigating to the customer information screen. This ensures all validations pass (price, username, password, etc.) before proceeding.

---

## Changes Made

### 1. **New State Variable**
```dart
bool _isCallingFromNextButton = false;
```
- Tracks whether the API call originated from the Next button or the Check button
- Used to differentiate navigation behavior

### 2. **Next Button Updates**

#### Before (Direct Navigation):
```dart
onPressed: () {
  // Direct navigation without API call
  Navigator.push(...);
}
```

#### After (API Call + Navigation):
```dart
onPressed: checkNationalDisabled ? null : () async {
  setState(() {
    checkNationalDisabled = true;
    isloading = true;
    _isCallingFromNextButton = true; // Set flag
  });
  
  // Call API
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
  
  // Navigation happens in BLoC listener on success
}
```

### 3. **BLoC Listener Updates**

#### Success State Handler:
```dart
if (state is PostValidateSubscriberSuccessState) {
  setState(() {
    userName = state.Username;
    password = state.Password;
    sendOTP = state.sendOTP;
    showSimCard = state.showSimCard;
    price = state.Price.toString();
    isArmy = state.isArmy;
    showCommitmentList = state.showCommitmentList;
    isloading = false;
  });
  
  // ✅ Check flag to determine behavior
  if (_isCallingFromNextButton) {
    setState(() {
      _isCallingFromNextButton = false; // Reset flag
    });
    // Navigate directly to customer information
    Navigator.push(context, MaterialPageRoute(...));
  } else {
    // Show dialog (original Check button behavior)
    showAlertDialogSucssesJordanian(...);
  }
}
```

#### Error State Handlers:
```dart
if (state is PostValidateSubscriberErrorState) {
  setState(() {
    checkNationalDisabled = false;
    isloading = false;
    _isCallingFromNextButton = false; // ✅ Reset flag
  });
  showAlertDialogError(...);
}

if (state is PostValidateSubscriberTokenErrorState) {
  UnotherizedError();
  setState(() {
    checkNationalDisabled = false;
    isloading = false;
    _isCallingFromNextButton = false; // ✅ Reset flag
  });
}
```

---

## Flow Diagram

### **Jordanian Customer Flow with Next Button**

```
┌───────────────────────────────────┐
│  User enters National Number      │
│  and MSISDN                        │
└──────────────┬────────────────────┘
               │
               ▼
┌───────────────────────────────────┐
│  Click "Check" Button             │
└──────────────┬────────────────────┘
               │
               ▼
┌───────────────────────────────────┐
│  Try Sanad Verification           │
└──────────────┬────────────────────┘
               │
               ▼
        [Sanad Fails]
               │
               ▼
┌───────────────────────────────────┐
│  Show Document Type Toggle        │
│  - Scan ID                         │
│  - Jordanian Passport              │
└──────────────┬────────────────────┘
               │
               ▼
┌───────────────────────────────────┐
│  User scans document (ID/Passport)│
└──────────────┬────────────────────┘
               │
               ▼
┌───────────────────────────────────┐
│  Document images displayed         │
│  ✅ "Next" button appears          │
└──────────────┬────────────────────┘
               │
               ▼
┌───────────────────────────────────┐
│  User clicks "Next" Button        │
└──────────────┬────────────────────┘
               │
               ▼
┌───────────────────────────────────┐
│  Set _isCallingFromNextButton=true│
│  Call PostValidateSubscriber API  │
└──────────────┬────────────────────┘
               │
          ┌────┴────┐
          │         │
     [Success]  [Error]
          │         │
          │         └──────────────────┐
          │                            │
          ▼                            ▼
┌─────────────────────┐    ┌──────────────────────┐
│ Update user/pass/   │    │ Show error dialog    │
│ price/permissions   │    │ Reset flag           │
└──────────┬──────────┘    │ Enable button        │
           │               └──────────────────────┘
           ▼
┌─────────────────────┐
│ Navigate directly   │
│ to Jordanian        │
│ CustomerInformation │
│ (No dialog shown)   │
└─────────────────────┘
```

---

## API Request Parameters

### PostValidateSubscriberPressed Event:
```dart
{
  marketType: "GSM" or "PRETOPOST",
  isJordanian: true,
  nationalNo: "1234567890", // 10 digits
  passportNo: "",
  packageCode: "package_code",
  msisdn: "07xxxxxxxx",
  isRental: false,
  device5GType: "0",
  buildingCode: "null",
  serialNumber: "",
  itemCode: "null"
}
```

### API Response (Success):
```dart
{
  Username: "username",
  Password: "password",
  sendOTP: true/false,
  showSimCard: true/false,
  Price: 25.0,
  isArmy: true/false,
  showCommitmentList: true/false,
  arabicMessage: "نجح",
  englishMessage: "Success"
}
```

---

## Key Differences: Check Button vs Next Button

| Aspect | Check Button | Next Button |
|--------|--------------|-------------|
| **Trigger** | Before document scan | After document scan |
| **Purpose** | Validate national number | Final validation before customer info |
| **On Success** | Shows dialog with Next button | Navigates directly |
| **Flag Set** | `_isCallingFromNextButton = false` | `_isCallingFromNextButton = true` |
| **User Action** | Must click Next in dialog | Automatic navigation |

---

## Benefits

### ✅ **Data Validation**
- Ensures price, username, password are fetched before proceeding
- Validates package availability
- Checks permissions (army, commitment list, etc.)

### ✅ **Consistent Flow**
- Both Check button and Next button use same API
- Centralized validation logic
- No data mismatch between Check and Next

### ✅ **Better UX**
- Next button navigates directly (no extra dialog)
- Check button still shows dialog for review
- Loading states properly handled

### ✅ **Error Handling**
- API errors shown to user
- State properly reset on errors
- Button re-enabled after error

---

## Testing Checklist

- [ ] Next button calls API before navigation
- [ ] API success navigates to JordainianCustomerInformation
- [ ] API error shows error dialog
- [ ] Loading state disables button during API call
- [ ] Username, password, price updated from API response
- [ ] Check button still shows dialog (not affected)
- [ ] Flag resets properly after success
- [ ] Flag resets properly after error
- [ ] Navigation includes all required parameters
- [ ] Both GSM and PRETOPOST market types work

---

## Code Locations

| Component | Line | Description |
|-----------|------|-------------|
| State variable | ~152 | `_isCallingFromNextButton` declaration |
| Next button | ~7006-7065 | API call implementation |
| BLoC listener | ~6698-6763 | Success/error handling |
| Error handler 1 | ~6698-6706 | PostValidateSubscriberErrorState |
| Error handler 2 | ~6709-6719 | PostValidateSubscriberTokenErrorState |
| Success handler | ~6721-6763 | PostValidateSubscriberSuccessState |

---

## Related Files

- **Current file**: `GSM_NationalityList.dart`
- **Reference file**: `GSM_NationalityListOld.dart` (original implementation)
- **Destination**: `GSM_JordainianCustomerInformation.dart`

---

## Notes

1. **Passport Number**: Always empty string for Jordanians (they use national number)
2. **isJordanian**: Always `true` for this flow
3. **Dialog Behavior**: Only Check button shows dialog; Next button navigates directly
4. **State Management**: Flag ensures correct behavior based on button source
5. **Loading State**: Properly managed with `isloading` variable
