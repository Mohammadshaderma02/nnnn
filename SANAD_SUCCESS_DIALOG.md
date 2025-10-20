# Sanad Verification Success - Dialog Implementation

## Issue
When Sanad verification succeeded, the app launched the Sanad URL but did not show a success dialog or call the `PostValidateSubscriber` API, leaving the user flow incomplete.

---

## Solution
After successful Sanad verification, the app now:
1. Launches Sanad URL for user authentication
2. Calls `PostValidateSubscriber` API to get username, password, price
3. Shows success dialog with MSISDN and Price
4. Allows user to click Next to proceed to customer information screen

---

## Implementation

### Before:
```dart
if (result["data"] != null && result["data"]["verified"] == true) {
  redirectUrl = result["data"]["redirectUrl"];
  final Uri sanadUrl = Uri.parse(redirectUrl);

  setState(() {
    isloading = false;
    checkNationalDisabled = false;
  });

  if (await canLaunchUrl(sanadUrl)) {
    await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
    // ❌ Nothing happens after this - user is stuck
  }
}
```

### After:
```dart
if (result["data"] != null && result["data"]["verified"] == true) {
  // ✅ Sanad verification successful
  print("✅ Sanad verification successful - calling PostValidateSubscriber API");
  
  redirectUrl = result["data"]["redirectUrl"];
  final Uri sanadUrl = Uri.parse(redirectUrl);

  setState(() {
    isloading = false;
    checkNationalDisabled = false;
  });

  // Launch Sanad URL
  if (await canLaunchUrl(sanadUrl)) {
    await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
    
    // ✅ After Sanad completes, call PostValidateSubscriber API
    // Wait a moment for the external process
    await Future.delayed(Duration(seconds: 2));
    
    // Set loading state
    setState(() {
      isloading = true;
      checkNationalDisabled = true;
    });
    
    // Call PostValidateSubscriber API to get username, password, price
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
    
    // The dialog will be shown in the BLoC listener when API succeeds
  }
}
```

---

## User Flow

### Complete Sanad Verification Flow:

```
User enters National Number + MSISDN
            ↓
     Click Check Button
            ↓
   Try Sanad Verification API
            ↓
   ┌────────────────────┐
   │ Sanad Verification │
   └────────┬───────────┘
            │
       ┌────┴────┐
       │         │
   Success    Failure
       │         │
       │         └─→ Show document scan options
       │              (ID or Jordanian Passport)
       │
       ▼
Launch Sanad URL
(External authentication)
       ↓
User completes Sanad auth
       ↓
Return to app
       ↓
Call PostValidateSubscriber API
       ↓
   ┌─────────┐
   │ API Call│
   └────┬────┘
        │
   ┌────┴────┐
   │         │
Success   Error
   │         │
   │         └─→ Show error dialog
   │
   ▼
Show Success Dialog
(MSISDN, Price)
   ↓
User clicks Next
   ↓
Navigate to JordainianCustomerInformation
```

---

## Key Changes

### 1. **API Call After Sanad Success**
- Previously: No API call after Sanad
- Now: Calls `PostValidateSubscriber` to fetch data

### 2. **Success Dialog**
- Previously: No dialog shown
- Now: Shows dialog with MSISDN and Price for review

### 3. **User Flow Completion**
- Previously: Flow stopped after Sanad URL launch
- Now: Complete flow to customer information screen

### 4. **Loading States**
- Added loading indicators during API call
- Disabled Check button during process

---

## BLoC Listener Behavior

The existing BLoC listener handles the API response:

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
  
  // Since _isCallingFromNextButton is false (default),
  // it will show the dialog
  if (_isCallingFromNextButton) {
    // Navigate directly (for Next button after scan)
    Navigator.push(...);
  } else {
    // ✅ Show dialog (for Check button and Sanad success)
    showAlertDialogSucssesJordanian(...);
  }
}
```

---

## Dialog Contents

The success dialog displays:
- **Title**: "Operation Success" (نجح العملية)
- **MSISDN**: The phone number
- **Price**: The package price
- **Buttons**:
  - **Cancel**: Close dialog without navigation
  - **Next**: Navigate to JordainianCustomerInformation

---

## Timing Considerations

### Delay After Sanad Launch:
```dart
await Future.delayed(Duration(seconds: 2));
```

**Why 2 seconds?**
- Gives time for Sanad external process to complete
- Allows user to return to app
- Prevents race conditions

**Note**: This is a simplified approach. In production, you might want to:
1. Use a deep link callback instead of delay
2. Poll for Sanad completion status
3. Show a loading screen while waiting

---

## Testing Checklist

### Sanad Success Flow:
- [ ] Enter valid National Number and MSISDN
- [ ] Click Check button
- [ ] Verify Sanad API called
- [ ] Verify Sanad URL launches (external browser/app)
- [ ] Complete Sanad authentication
- [ ] Return to app
- [ ] Verify PostValidateSubscriber API called
- [ ] Verify success dialog appears
- [ ] Dialog shows correct MSISDN and Price
- [ ] Click Next in dialog
- [ ] Verify navigation to JordainianCustomerInformation
- [ ] All parameters passed correctly

### Sanad Failure Flow:
- [ ] Enter National Number and MSISDN
- [ ] Click Check button
- [ ] Sanad verification fails
- [ ] Verify document scan options appear
- [ ] Can scan ID or Jordanian Passport
- [ ] After scan, Next button appears
- [ ] Clicking Next calls API and navigates

---

## Error Handling

### API Errors:
```dart
if (state is PostValidateSubscriberErrorState) {
  setState(() {
    checkNationalDisabled = false;
    isloading = false;
  });
  showAlertDialogError(context, state.arabicMessage, state.englishMessage);
}
```

### Token Errors:
```dart
if (state is PostValidateSubscriberTokenErrorState) {
  UnotherizedError();
  setState(() {
    checkNationalDisabled = false;
    isloading = false;
  });
}
```

---

## Code Locations

| Component | Line | Description |
|-----------|------|-------------|
| Sanad Verification | ~1312-1378 | `_trySanadVerification()` method |
| Sanad Success Handler | ~1348-1390 | API call after Sanad success |
| BLoC Listener | ~6720-6763 | Handles API response |
| Success Dialog | ~6497-6591 | `showAlertDialogSucssesJordanian()` |

---

## Related Flows

### 1. **Check Button (No Sanad)**
If Sanad is not available or fails:
- Shows document scan options
- User scans ID or Passport
- Clicks Next button
- Calls API and navigates directly (no dialog)

### 2. **Check Button (With Sanad)**
If Sanad is available and succeeds:
- Launches Sanad URL
- User authenticates
- Returns to app
- API called automatically
- Shows dialog
- User clicks Next to proceed

### 3. **Direct Scan (After Sanad Fail)**
If user scans document after Sanad fails:
- Clicks Next button after scan
- Calls API directly
- Navigates without dialog

---

## Benefits

### ✅ **Complete User Flow**
- No dead ends
- Clear path from Sanad to customer info

### ✅ **Data Validation**
- API validates subscriber
- Fetches required data (username, password, price)

### ✅ **User Review**
- Dialog allows user to review information
- Confirm before proceeding

### ✅ **Consistent UX**
- Same dialog whether using Sanad or not
- Familiar flow for users

---

## Future Improvements

1. **Deep Link Integration**
   - Replace delay with actual deep link callback
   - More reliable than timing-based approach

2. **Progress Indicators**
   - Show "Waiting for Sanad..." message
   - Better user feedback during process

3. **Retry Mechanism**
   - Allow retry if Sanad process fails
   - Don't force document scan immediately

4. **Caching**
   - Cache Sanad result
   - Avoid repeated verification

---

## Notes

1. **Delay Duration**: 2 seconds may need adjustment based on actual Sanad process time
2. **API Call**: Happens automatically after Sanad success
3. **Dialog Behavior**: Only Check button flow shows dialog (not Next button after scan)
4. **State Management**: `_isCallingFromNextButton` flag controls navigation behavior
5. **Error Handling**: All error states properly handled with user feedback

---

**Implementation Date**: 2025-10-04  
**Status**: ✅ Complete and Ready for Testing  
**Related Docs**: 
- DIALOG_NAVIGATION_FIX.md
- JORDANIAN_NEXT_BUTTON_API.md
- IMPLEMENTATION_SUMMARY.md
