# Terms & Conditions Behavior - Quick Reference

## New Behavior: Terms Must Be Accepted Every Time

### Scenario 1: First Time Selection
1. User opens **PostPaidOptions** screen
2. User taps on **GSM** option
3. ✅ **Terms & Conditions** screen is shown
4. User reads and accepts both terms (toggles both switches)
5. User clicks "Next"
6. User navigates to **GSM Options** screen

### Scenario 2: Selecting Same Option Again
1. User is on **GSM Options** screen
2. User goes back to **PostPaidOptions** screen
3. User taps on **GSM** option again
4. ✅ **Terms & Conditions** screen is shown **AGAIN**
5. User must accept terms again
6. User navigates to **GSM Options** screen

### Scenario 3: Selecting Different Option
1. User is on **GSM Options** screen
2. User goes back to **PostPaidOptions** screen
3. User taps on **BroadBand** option
4. ✅ **Terms & Conditions** screen is shown
5. User must accept terms
6. User navigates to **BroadBand Options** screen

### Scenario 4: User Rejects Terms
1. User opens **PostPaidOptions** screen
2. User taps on **FTTH** option
3. **Terms & Conditions** screen is shown
4. User reads but does NOT accept terms (doesn't toggle switches)
5. User clicks "Back" button
6. User returns to **PostPaidOptions** screen
7. ❌ Toast message shown: "You must accept Terms & Conditions to proceed"

## Key Points

✅ **Terms MUST be accepted every time** before accessing any PostPaid service  
✅ Terms are **automatically cleared** after navigation to prevent skipping  
✅ Terms are **cleared at the start** of each selection  
✅ Applies to **all three** PostPaid options: GSM, BroadBand, FTTH  
✅ **Does NOT affect** the eKYC flow (separate flow)  

## Technical Implementation

- Terms flags cleared **before** showing T&C screen: `globalVars.termCondition1 = false` and `globalVars.termCondition2 = false`
- Terms flags cleared **after** successful navigation (100ms delay)
- This ensures users cannot bypass the Terms & Conditions requirement

## User Experience

- Clear and consistent: Users always know they need to review terms
- No confusion about whether terms were previously accepted
- Ensures compliance: Terms are explicitly accepted for each service selection
