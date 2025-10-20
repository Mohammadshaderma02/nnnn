# Non-Jordanian Passport Flow - Quick Reference Guide

## 🎯 Overview
Simple, streamlined flow for non-Jordanian customers with **immediate camera scanning**.

---

## 📱 User Flow

### Step 1: Select Nationality
User expands "Non-Jordanian" (غير أردني) option

### Step 2: Enter MSISDN (Optional based on market type)
User enters phone number (رقم الخط)

### Step 3: Choose Passport Type
User sees two buttons:
- **🟣 جواز سفر مؤقت** (Temporary Passport)
- **🟣 جواز سفر أجنبي** (Foreign Passport)

### Step 4: Immediate Camera Launch
- Click **any button** → Camera opens **immediately**
- No passport number entry needed
- No intermediate steps

### Step 5: Scan Document
- Point camera at passport
- System automatically captures image
- Document is processed

### Step 6: View & Proceed
- ✅ Scanned document image displayed
- ✅ "Next" (التالي) button appears
- Click Next → Navigate to customer information screen

---

## 🔧 Technical Implementation

### Key Components

#### 1. Passport Type Selection UI
```dart
Widget passportNumber() {
  // Shows two toggle buttons
  // - Temporary Passport
  // - Foreign Passport
  // Both open camera immediately on click
}
```

#### 2. Camera Initialization
- **Temporary Passport**: `_initializeCameraTemporary()`
- **Foreign Passport**: `_initializeCameraForeign()`

#### 3. State Management
```dart
// Passport type flags
globalVars.tackTemporary  // true if Temporary selected
globalVars.tackForeign    // true if Foreign selected

// Document processing
_documentProcessingSuccess  // true when scan complete
```

#### 4. Navigation Trigger
```dart
if (_documentProcessingSuccess && (globalVars.tackTemporary || globalVars.tackForeign)) {
  // Show Next button
}
```

---

## 🔄 Complete Flow Diagram

```
┌─────────────────────────────────────────┐
│  User Selects "Non-Jordanian" (غير أردني) │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  Enter MSISDN (if required)             │
└─────────────────┬───────────────────────┘
                  │
                  ▼
┌─────────────────────────────────────────┐
│  اختر نوع جواز السفر                    │
│  (Select Passport Type)                 │
│                                         │
│  ┌──────────────┐  ┌──────────────┐    │
│  │ جواز سفر مؤقت│  │ جواز سفر أجنبي│   │
│  └──────┬───────┘  └──────┬───────┘    │
└─────────┼──────────────────┼───────────┘
          │                  │
          │ Click            │ Click
          ▼                  ▼
┌────────────────┐  ┌────────────────┐
│ eKYC Init      │  │ eKYC Init      │
│ ↓              │  │ ↓              │
│ Camera Opens   │  │ Camera Opens   │
│ (Temporary)    │  │ (Foreign)      │
└────────┬───────┘  └────────┬───────┘
         │                   │
         └─────────┬─────────┘
                   ▼
         ┌─────────────────┐
         │  Scan Passport  │
         └────────┬────────┘
                  ▼
         ┌─────────────────┐
         │ Process Image   │
         └────────┬────────┘
                  ▼
         ┌─────────────────┐
         │ Display Image   │
         │ Show Next Button│
         └────────┬────────┘
                  ▼
         ┌─────────────────┐
         │ Click Next (التالي)│
         └────────┬────────┘
                  ▼
    ┌───────────────────────────┐
    │ NonJordainianCustomer     │
    │ Information Screen        │
    └───────────────────────────┘
```

---

## ⚡ Key Features

### ✨ Immediate Action
- **One-click scanning** - No intermediate forms
- Camera launches **instantly** after button click

### 🔄 Unified Experience
- Same flow for both passport types
- Consistent UI/UX pattern

### 🌐 Bilingual Support
- Arabic (primary)
- English (secondary)
- RTL support

### 🔐 eKYC Integration
- Auto-initialization before camera
- Error handling with clear messages
- Seamless token management

---

## 🎨 UI Elements

### Toggle Buttons
```
┌──────────────────────┐ ┌──────────────────────┐
│  جواز سفر مؤقت        │ │  جواز سفر أجنبي       │
│  Temporary Passport  │ │  Foreign Passport    │
└──────────────────────┘ └──────────────────────┘
   🟣 Selected: Purple     ⚪ Unselected: White
   ⚪ Unselected: White     🟣 Selected: Purple
```

### Next Button
```
┌──────────────────────────────┐
│  التالي  →                   │
│  Next    →                   │
└──────────────────────────────┘
```

---

## 📝 Code Locations

| Component | Line/Section | Purpose |
|-----------|-------------|---------|
| `passportNumber()` | ~Line 7057 | Main passport selection widget |
| Toggle buttons | ~Line 6986-7203 | Temporary/Foreign selection |
| Camera init (Temp) | `_initializeCameraTemporary()` | Opens temp passport camera |
| Camera init (Foreign) | `_initializeCameraForeign()` | Opens foreign passport camera |
| Document images | ~Line 7206-7226 | Display captured passports |
| Next button | ~Line 7229-7293 | Navigate to customer info |
| Non-Jordanian panel | ~Line 8479 | Expansion panel body |

---

## 🔍 Testing Checklist

- [ ] Temporary Passport button opens camera immediately
- [ ] Foreign Passport button opens camera immediately
- [ ] eKYC initializes before camera opens
- [ ] Document images display after capture
- [ ] Next button appears after successful capture
- [ ] Navigation to NonJordainianCustomerInformation works
- [ ] Arabic/English text displays correctly
- [ ] Error messages show when eKYC fails
- [ ] Cancel button works in camera view
- [ ] State resets properly after cancel

---

## 🚀 Performance Notes

- eKYC initialization: ~1-2 seconds
- Camera startup: ~0.5-1 second
- Document processing: ~2-3 seconds
- Total flow time: ~5-10 seconds (optimal)

---

## 📞 User Support

**Common Questions:**

Q: Do I need to enter passport number?
A: No, just select passport type and scan.

Q: What if camera doesn't open?
A: Check eKYC system status, retry selection.

Q: Can I switch between passport types?
A: Yes, click the other button to switch.

Q: What if I made a mistake?
A: Use Cancel button in camera, start over.
