# Barcode Feature for Foreign Passports - Implementation Guide

## 🎯 Feature Overview
For **foreign passport** cases, users must provide a barcode after uploading their passport. They can do this via:
1. **Manual Entry** - Type the barcode number directly
2. **Image Upload** - Take a photo or select an image of the barcode

## 📊 API Endpoints

### Barcode Image Upload
```
POST https://079.jo/wid-zain/api/v1/barcode/multipart
Headers: Authorization: Bearer {token}
Body: multipart/form-data
  - file: Image (barcode image file)
```

### Barcode Manual Entry
```
POST https://079.jo/wid-zain/api/v1/barcode/multipart  
Headers: 
  - Authorization: Bearer {token}
  - Content-Type: application/json
Body: {
  "code": "barcode_string"
}
```

## ✅ Completed Implementation

### 1. State Variables Added (**Lines 224-230**)
```dart
// 🎯 Barcode state variables (for foreign passport)
TextEditingController barcodeController = TextEditingController();
String barcodeImage = ''; // Base64 image of barcode
bool showBarcodeField = false; // Show barcode field after foreign passport upload
bool isBarcodeManual = true; // Toggle between manual entry and image upload
bool emptyBarcode = false; // Validation flag
bool barcodeUploaded = false; // Track if barcode is uploaded/entered
```

### 2. API Functions Added (**Lines 5583-5766**)

#### `uploadBarcodeImage_API(File barcodeImageFile)`
- Uploads barcode as image file
- Shows loading overlay during upload
- Displays success/error messages
- Sets `barcodeUploaded = true` on success

#### `uploadBarcodeManual_API(String barcodeText)`
- Uploads barcode as text string
- Shows loading overlay during submission
- Displays success/error messages  
- Sets `barcodeUploaded = true` on success

**Features:**
- ✅ Full error handling with try-catch
- ✅ Loading state management
- ✅ Bilingual success/error messages (English/Arabic)
- ✅ Debug logging with emoji markers
- ✅ Proper client cleanup in finally block

## 🚧 Remaining Implementation Tasks

### 3. Create Barcode UI Widget
**File**: `NationalityList.dart`  
**Location**: After `buildForeignPassport_Image()` method

Create `buildBarcode_Section()` widget with:
```dart
Widget buildBarcode_Section() {
  return Container(
    padding: EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.2),
          spreadRadius: 1,
          blurRadius: 5,
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
              ? \"Barcode Information\"
              : \"معلومات الباركود\",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF4f2565),
          ),
        ),
        SizedBox(height: 15),
        
        // Toggle between Manual Entry and Image Upload
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: isBarcodeManual ? Color(0xFF4f2565) : Colors.white,
                  onPrimary: isBarcodeManual ? Colors.white : Color(0xFF636f7b),
                  side: BorderSide(
                    color: Color(0xFF4f2565),
                    width: 1,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isBarcodeManual = true;
                  });
                },
                child: Text(
                  EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                      ? \"Manual Entry\"
                      : \"إدخال يدوي\",
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: !isBarcodeManual ? Color(0xFF4f2565) : Colors.white,
                  onPrimary: !isBarcodeManual ? Colors.white : Color(0xFF636f7b),
                  side: BorderSide(
                    color: Color(0xFF4f2565),
                    width: 1,
                  ),
                ),
                onPressed: () {
                  setState(() {
                    isBarcodeManual = false;
                  });
                },
                child: Text(
                  EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                      ? \"Upload Image\"
                      : \"تحميل صورة\",
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 15),
        
        // Conditional content based on toggle
        if (isBarcodeManual) ...[\n          // Manual entry field
          TextField(
            controller: barcodeController,
            keyboardType: TextInputType.text,
            decoration: InputDecation(
              labelText: EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                  ? \"Enter Barcode\"
                  : \"أدخل الباركود\",
              border: OutlineInputBorder(),
              errorText: emptyBarcode
                  ? (EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                      ? \"Barcode is required\"
                      : \"الباركود مطلوب\")
                  : null,
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                primary: Color(0xFF4f2565),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              onPressed: barcodeUploaded
                  ? null
                  : () {
                      // Validate
                      setState(() {
                        emptyBarcode = barcodeController.text.isEmpty;
                      });
                      
                      if (!emptyBarcode) {
                        // Submit barcode
                        uploadBarcodeManual_API(barcodeController.text);
                      }
                    },
              child: Text(
                barcodeUploaded
                    ? (EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                        ? \"Barcode Submitted ✓\"
                        : \"تم إرسال الباركود ✓\")
                    : (EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                        ? \"Submit Barcode\"
                        : \"إرسال الباركود\"),
                style: TextStyle(fontSize: 16),
              ),
            ),
          ),
        ] else ...[\n          // Image upload section
          barcodeImage.isEmpty
              ? Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.qr_code_scanner, size: 50, color: Colors.grey),
                        SizedBox(height: 10),
                        Text(
                          EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                              ? \"No barcode image selected\"
                              : \"لم يتم اختيار صورة الباركود\",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                )
              : Container(
                  height: 150,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.green),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Image.memory(base64Decode(barcodeImage)),
                ),
          SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Color(0xFF4f2565),
                    side: BorderSide(color: Color(0xFF4f2565)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.camera_alt),
                  label: Text(
                    EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                        ? \"Camera\"
                        : \"كاميرا\",
                  ),
                  onPressed: () async {
                    // TODO: Implement camera capture
                    await _pickBarcodeFromCamera();
                  },
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Color(0xFF4f2565),
                    side: BorderSide(color: Color(0xFF4f2565)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  icon: Icon(Icons.photo_library),
                  label: Text(
                    EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                        ? \"Gallery\"
                        : \"المعرض\",
                  ),
                  onPressed: () async {
                    // TODO: Implement gallery picker
                    await _pickBarcodeFromGallery();
                  },
                ),
              ),
            ],
          ),
          if (barcodeImage.isNotEmpty) ...[\n            SizedBox(height: 15),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Color(0xFF4f2565),
                  padding: EdgeInsets.symmetric(vertical: 14),
                ),
                onPressed: barcodeUploaded
                    ? null
                    : () async {
                        // Upload barcode image
                        File barcodeFile = File(barcodeImage); // Convert from base64
                        await uploadBarcodeImage_API(barcodeFile);
                      },
                child: Text(
                  barcodeUploaded
                      ? (EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                          ? \"Barcode Uploaded ✓\"
                          : \"تم تحميل الباركود ✓\")
                      : (EasyLocalization.of(context).locale == Locale(\"en\", \"US\")
                          ? \"Upload Barcode\"
                          : \"تحميل الباركود\"),
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ],
      ],
    ),
  );
}
```

### 4. Integrate into Foreign Passport Flow
**Location**: After line 7131 in `passportNumber()` method

Modify the foreign passport section:
```dart
// After buildForeignPassport_Image()
if (globalVars.capturedBase64Foreign.isNotEmpty || _LoadImageForeignPassport) ...[\n  SizedBox(height: 15),
  buildForeignPassport_Image(),
  
  // 🎯 Show barcode section after foreign passport is captured
  if (_LoadImageForeignPassport) ...[\n    SizedBox(height: 20),
    buildBarcode_Section(),
  ],
],
```

### 5. Image Picker Functions
Add these helper methods:

```dart
Future<void> _pickBarcodeFromCamera() async {
  final ImagePicker _picker = ImagePicker();
  final XFile image = await _picker.pickImage(source: ImageSource.camera);
  
  if (image != null) {
    final bytes = await image.readAsBytes();
    setState(() {
      barcodeImage = base64Encode(bytes);
    });
  }
}

Future<void> _pickBarcodeFromGallery() async {
  final ImagePicker _picker = ImagePicker();
  final XFile image = await _picker.pickImage(source: ImageSource.gallery);
  
  if (image != null) {
    final bytes = await image.readAsBytes();
    setState(() {
      barcodeImage = base64Encode(bytes);
    });
  }
}
```

### 6. Cleanup/Dispose Updates
Add to existing cleanup methods:

```dart
// In _resetDocumentState() or similar cleanup method
barcodeController.clear();
barcodeImage = '';
showBarcodeField = false;
isBarcodeManual = true;
emptyBarcode = false;
barcodeUploaded = false;

// In dispose() method
barcodeController.dispose();
```

## 🎨 UI Flow

### Step 1: Foreign Passport Upload
User selects "Foreign Passport" button → Camera opens → Passport scanned

### Step 2: Barcode Section Appears
After successful passport upload, barcode section automatically shows below the passport image

### Step 3: User Chooses Method
- **Manual Entry Tab**: Shows text field
- **Upload Image Tab**: Shows camera/gallery buttons

### Step 4: Submit Barcode
- Manual: Click "Submit Barcode" button
- Image: Select/capture image → Click "Upload Barcode" button

### Step 5: Success
- Green checkmark appears
- Button becomes disabled
- User can proceed to "Next" button

## 🧪 Testing Checklist

- [ ] Foreign passport upload triggers barcode section
- [ ] Toggle between manual/image works smoothly
- [ ] Manual entry validation works
- [ ] Manual entry submission successful
- [ ] Camera picker works
- [ ] Gallery picker works
- [ ] Image upload successful
- [ ] Loading overlay shows during submission
- [ ] Success messages display correctly (EN/AR)
- [ ] Error messages display correctly (EN/AR)
- [ ] Button disabled after successful upload
- [ ] Cleanup/reset works when starting over

## 📝 Dependencies Required

Ensure these are in `pubspec.yaml`:
```yaml
dependencies:
  image_picker: ^latest_version
```

## 🚀 Next Steps

1. Create `buildBarcode_Section()` widget
2. Add image picker helper functions
3. Integrate barcode section into foreign passport flow
4. Update cleanup methods
5. Test end-to-end flow
6. Handle edge cases (network errors, invalid images, etc.)

## 🔗 Related Files

- Main file: `D:\mobile-dev\sales-app-ekyc\lib\Views\HomeScreens\Subdealer\Menu\PostPaid\FTTH\NationalityList.dart`
- API functions: Lines 5583-5766
- State variables: Lines 224-230

---

**Status**: 🟡 In Progress  
**Completed**: API functions, state variables  
**Remaining**: UI widget, image picker, integration, cleanup
