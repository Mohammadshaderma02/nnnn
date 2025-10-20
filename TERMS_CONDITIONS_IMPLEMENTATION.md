# Terms & Conditions Integration with PostPaid Options

## Summary
This document describes the implementation of Terms & Conditions validation before accessing PostPaid services (GSM, BroadBand, FTTH).

## Changes Made

### 1. PostPaidOptions.dart
**Location:** `lib/Views/HomeScreens/Subdealer/Menu/PostPaid/PostPaidOptions.dart`

#### Added Method: `_checkAndNavigateWithTerms`
- **Purpose:** Always show Terms & Conditions before navigating to any PostPaid service
- **Logic:**
  1. Clear any previously accepted terms (`globalVars.termCondition1` and `globalVars.termCondition2`)
  2. Navigate to `Terms_Conditions` screen
  3. After returning from Terms screen, check if terms are accepted
  4. If accepted, execute the callback to navigate to the selected service
  5. After navigation, clear the terms again (with a small delay) so they must be accepted next time
  6. If not accepted, show a toast message to the user

#### Updated onTap Handlers
All three PostPaid options now use the `_checkAndNavigateWithTerms` method:

- **GSM** (line 146-165): Wraps navigation to `GSMOptions`
- **BroadBand** (line 189-380): Wraps navigation to `BroadBandpackage` or shows ZAIN/MADA dialog
- **FTTH** (line 406-607): Wraps navigation to `ConnectionType` or shows ZAIN/MADA dialog

### 2. Terms_Conditions.dart
**Location:** `lib/Views/HomeScreens/Subdealer/Menu/EKYC/ThirdStep/Terms_Conditions.dart`

#### Added Parameter: `isPostPaidFlow`
- **Type:** `bool` (default: `false`)
- **Purpose:** Distinguish between eKYC flow and PostPaid flow

#### Updated Next Button Logic
- **Line 469-484:** Modified to check `widget.isPostPaidFlow`
  - If `true`: Simply pop back to PostPaidOptions (user has accepted terms)
  - If `false`: Continue with normal eKYC step progression

#### Updated Back Button & AppBar Back Logic
- **Lines 96-103, 114-121:** Clear terms when user navigates back without accepting
- Sets `globalVars.termCondition1 = false` and `globalVars.termCondition2 = false`

## Flow Diagram

```
PostPaidOptions Screen
    |
    | User selects GSM/BroadBand/FTTH
    |
    v
_checkAndNavigateWithTerms() called
    |
    | Clear previous terms acceptance
    |
    v
Navigate to Terms_Conditions (isPostPaidFlow: true)
    |
    | User reads and toggles both switches
    |
    +---> Clicks "Next" ---> Pop back to PostPaidOptions
    |                        (terms now accepted in globalVars)
    |                        Navigate to selected service
    |                        Clear terms again (for next time)
    |
    +---> Clicks "Back" ---> Pop back to PostPaidOptions
                             (terms cleared)
                             Show toast: "Must accept terms"
                             
                             
User returns to PostPaidOptions
    |
    | Selects another option or same option again
    |
    v
Terms & Conditions shown again (terms were cleared)
```

## Global Variables Used

- `globalVars.termCondition1` - Boolean flag for first terms acceptance
- `globalVars.termCondition2` - Boolean flag for second terms acceptance

## Testing Checklist

- [ ] First time selecting GSM: Shows Terms & Conditions screen
- [ ] After accepting terms: Navigates to GSM options
- [ ] Without accepting terms (back button): Shows error toast
- [ ] **After returning from GSM, selecting GSM again: Shows Terms & Conditions screen again**
- [ ] **After selecting GSM, going back to PostPaidOptions, then selecting BroadBand: Shows Terms & Conditions screen**
- [ ] Same behavior for BroadBand option (always shows T&C)
- [ ] Same behavior for FTTH option (always shows T&C)
- [ ] Terms screen works correctly in eKYC flow (not affected by changes)
- [ ] Back button in Terms screen clears acceptance flags

## Additional Notes

- The implementation preserves existing functionality for the eKYC flow
- **Terms are cleared before and after each PostPaid service selection, ensuring users must accept them every time**
- Terms are cleared when user navigates back without accepting
- The same Terms_Conditions screen is reused for both flows (eKYC and PostPaid)
- A small delay (100ms) is used after navigation before clearing terms to ensure smooth navigation flow
