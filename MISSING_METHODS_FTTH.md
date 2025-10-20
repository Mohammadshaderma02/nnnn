# Missing eKYC Methods for FTTH NationalityList.dart

## Summary
The FTTH `NationalityList.dart` file is missing 5 methods that exist in the GSM `GSM_NationalityList.dart` file. These methods need to be manually copied to complete the eKYC integration.

**Missing Methods:**
1. `createHttpClient()` - HTTP client with certificate bypass
2. `huploadBackID_API()` - Upload back side of ID card
3. `uploadForignPassportFile_API()` - Upload foreign passport
4. `documentProcessingForignPassport_API()` - Process foreign passport OCR
5. `documentProcessingPassportTemp_API()` - Process temporary passport OCR (If needed)

---

## Method 1: createHttpClient()

**Location to insert:** After the `sanad_API()` method around line 2036 in GSM

```dart
// Create HTTP client that skips certificate verification
http.Client createHttpClient() {
  HttpClient httpClient = HttpClient();
  httpClient.badCertificateCallback = (X509Certificate cert, String host, int port) {
    return true;
  };
  return IOClient(httpClient);
}
```

---

## Method 2: huploadBackID_API()

**Location to insert:** After the `uploadFrontID_API()` method around line 4967 in GSM

```dart
huploadBackID_API(File backImageFile) async {
  setState(() {
    isloading = true;
  });
  final client = createHttpClient();
  try {
    // Create the URL with path parameter
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document-multipart";
    final url = Uri.parse(apiUrl);

    // Create multipart request
    var request = http.MultipartRequest('POST', url);

    // Add headers - Remove Content-Type for multipart requests
    request.headers.addAll({
      'Authorization': "Bearer ${globalVars.ekycTokenID}"
      // Don't set Content-Type manually for multipart requests
    });

    // Add the JSON data as a field
    final jsonData = {
      "citizenship": "JOR",
      "type": "identity_card",
      "id": 13,
      "media": [
        {
          "side": "back",
          "uploadedByFilesystem": true
        }
      ]
    };

    request.fields['data'] = jsonEncode(jsonData);

    // Try different field names for the file
    var multipartFile = await http.MultipartFile.fromPath(
      'back', // Try 'front', 'back', 'image', or 'identity_card' instead of 'file'
      backImageFile.path,
      filename: 'identity_card_back.jpg',
    );

    request.files.add(multipartFile);

    // Send the request
    var streamedResponse = await client.send(request);
    var response = await http.Response.fromStream(streamedResponse);

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("success2 haya hazaimeh");
      setState(() {
        isloading = false;
        // Set the base64 string for display
        IDBack = globalVars.capturedBase64.length > 1 ? globalVars.capturedBase64[1] : '';
        _loadImageBackID = true;  // ✅ SET THIS FLAG TO SHOW IMAGE
      });
      documentProcessingID_API();
      return jsonDecode(response.body);
    } else {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

      setState(() {
        isloading = false;

        globalVars.showForeignPassport=false;
        globalVars.capturedPaths.clear();
        globalVars.capturedBase64.clear();
        globalVars.isValidIdentification = false;

        globalVars.capturedPathsMRZ="";
        globalVars.capturedBase64MRZ="";
        globalVars.isValidPassportIdentification = false;

        globalVars.capturedPathsTemporary="";
        globalVars.capturedBase64Temporary="";
        globalVars.isValidTemporaryIdentification = false;

        globalVars.capturedPathsForeign="";
        globalVars.capturedBase64Foreign="";
        globalVars.isValidForeignIdentification = false;
        globalVars.tackForeign=false;
        globalVars.tackTemporary=false;
        globalVars.showPersonalNumber=false;
        globalVars.tackID= false;
        globalVars.tackJordanPassport= false;
      });
      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');
      return null;
    }
  } catch (e) {
    setState(() {
      isloading = false;

      globalVars.showForeignPassport=false;
      globalVars.capturedPaths.clear();
      globalVars.capturedBase64.clear();
      globalVars.isValidIdentification = false;

      globalVars.capturedPathsMRZ="";
      globalVars.capturedBase64MRZ="";
      globalVars.isValidPassportIdentification = false;

      globalVars.capturedPathsTemporary="";
      globalVars.capturedBase64Temporary="";
      globalVars.isValidTemporaryIdentification = false;

      globalVars.capturedPathsForeign="";
      globalVars.capturedBase64Foreign="";
      globalVars.isValidForeignIdentification = false;
      globalVars.tackForeign=false;
      globalVars.tackTemporary=false;
      globalVars.showPersonalNumber=false;
      globalVars.tackID= false;
      globalVars.tackJordanPassport= false;
    });
    print('Exception: $e');
    return null;
  }
}
```

---

## Method 3: uploadForignPassportFile_API()

**Location to insert:** After the `uploadPassportTempFile_API()` method around line 5344 in GSM

```dart
uploadForignPassportFile_API(File frontImageFile) async {
  setState(() {
    isloading = true;
  });
  final client = createHttpClient();
  try {
    // Create the URL with path parameter
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document-multipart";
    final url = Uri.parse(apiUrl);

    // Create multipart request
    var request = http.MultipartRequest('POST', url);

    // Add headers - Remove Content-Type for multipart requests
    request.headers.addAll({
      'Authorization': "Bearer ${globalVars.ekycTokenID}"
      // Don't set Content-Type manually for multipart requests
    });

    // Add the JSON data as a field
    final jsonData = {
      "citizenship": "UNK",
      "type": "passport",
      "id": 25,
      "media": [
        {
          "side": "front",
          "uploadedByFilesystem": true
        }
      ]
    };

    request.fields['data'] = jsonEncode(jsonData);

    // Try different field names for the file
    var multipartFile = await http.MultipartFile.fromPath(
      'front', // Try 'front', 'back', 'image', or 'identity_card' instead of 'file'
      frontImageFile.path,
      filename: 'identity_passport_front.jpg',
    );

    request.files.add(multipartFile);

    // Send the request
    var streamedResponse = await client.send(request);
    var response = await http.Response.fromStream(streamedResponse);

    print('Status Code: ${response.statusCode}');
    print('Response Body: ${response.body}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("success3 haya hazaimeh");
      setState(() {
        isloading = false;
        // Set the base64 string for display
        ForeignPassport = globalVars.capturedBase64Foreign.isNotEmpty ? globalVars.capturedBase64Foreign : '';
        _LoadImageForeignPassport = true;  // ✅ SET THIS FLAG TO SHOW IMAGE
      });
      documentProcessingForignPassport_API();
      return jsonDecode(response.body);
    } else {
      final Map<String, dynamic> jsonData = jsonDecode(response.body);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?jsonData['message']['en']:jsonData['message']['ar']),backgroundColor: Colors.red));

      print('Error: ${response.statusCode}');
      print('Response: ${response.body}');

      setState(() {
        isloading = false;

        globalVars.showForeignPassport=false;
        globalVars.capturedPaths.clear();
        globalVars.capturedBase64.clear();
        globalVars.isValidIdentification = false;


        globalVars.capturedPathsMRZ="";
        globalVars.capturedBase64MRZ="";
        globalVars.isValidPassportIdentification = false;

        globalVars.capturedPathsTemporary="";
        globalVars.capturedBase64Temporary="";
        globalVars.isValidTemporaryIdentification = false;

        globalVars.capturedPathsForeign="";
        globalVars.capturedBase64Foreign="";
        globalVars.isValidForeignIdentification = false;
        globalVars.tackForeign=false;
        globalVars.tackTemporary=false;
        globalVars.showPersonalNumber=false;
      });
      return null;
    }
  } catch (e) {
    setState(() {
      isloading = false;

      globalVars.showForeignPassport=false;
      globalVars.capturedPaths.clear();
      globalVars.capturedBase64.clear();
      globalVars.isValidIdentification = false;

      globalVars.capturedPathsMRZ="";
      globalVars.capturedBase64MRZ="";
      globalVars.isValidPassportIdentification = false;

      globalVars.capturedPathsTemporary="";
      globalVars.capturedBase64Temporary="";
      globalVars.isValidTemporaryIdentification = false;

      globalVars.capturedPathsForeign="";
      globalVars.capturedBase64Foreign="";
      globalVars.isValidForeignIdentification = false;
      globalVars.tackForeign=false;
      globalVars.tackTemporary=false;
      globalVars.showPersonalNumber=false;
    });
    print('Exception: $e');
    return null;
  }
}
```

---

## Method 4: documentProcessingForignPassport_API()

**Location to insert:** After the `documentProcessingPassport_API()` method around line 5626 in GSM

```dart
void documentProcessingForignPassport_API() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  final client = createHttpClient();
  setState(() {
    isloading = true;
  });
  final apiUrl = "https://079.jo/wid/api/v1/consumer/session/${globalVars.sessionUid}/document/process";
  final response = await client.post(
    Uri.parse(apiUrl),
    headers: {
      "content-type": "application/json",
      'Authorization':   "Bearer ${globalVars.ekycTokenID}"
    },
  );

  print("API Response: ${response.body}");

  if (response.statusCode == 200) {
    setState(() {
      isloading=false;

    });
    final Map<String, dynamic> responseMap = json.decode(response.body);
    print("Parsed Result: $responseMap");
    // Top-level fields
    print("Success: ${responseMap['success']}");

    // Message
    print("Message (EN): ${responseMap['message']['en']}");
    print("Message (AR): ${responseMap['message']['ar']}");


    // Data object
    final data = responseMap['data'];

    if(responseMap['success']==true){
      if(data['status']=="working"){
        // ✅ Document processing successful - set flag (passport number validated, not national number for foreign)
        setState(() {
          _documentProcessingSuccess = true;
          // For foreign passports, store the passport number (not national number)
          _lastValidatedNationalNo = passportNo.text;
        });
        print("✅ Foreign passport processing successful for Passport No: ${passportNo.text}");
        
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?" ${responseMap['message']['en']}":"${responseMap['message']['ar']}"),backgroundColor: Colors.green));
        globalVars.fullNameAr="";
        globalVars.fullNameEn=data['ocrData']['givenNames'];
        globalVars.natinalityNumber="-";
        globalVars.cardNumber=data['ocrData']['documentNumber'];
        globalVars.birthdate=data['ocrData']['dateOfBirth']['day'].toString()+'-'+data['ocrData']['dateOfBirth']['month'].toString()+'-'+data['ocrData']['dateOfBirth']['year'].toString();
        globalVars.expirayDate=data['ocrData']['expirationDate']['day'].toString()+'-'+data['ocrData']['expirationDate']['month'].toString()+'-'+data['ocrData']['expirationDate']['year'].toString();
        globalVars.gender=data['ocrData']['sex'];
        globalVars.bloodGroup="-";
        globalVars.registrationNumber="-";
        globalVars.nationality=data['ocrData']['nationality'];
      }
      if(data['status']=="timeout"){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?responseMap['message']['en']:responseMap['message']['ar']),backgroundColor: Colors.red));
        globalVars.capturedPaths.clear();
        globalVars.capturedBase64.clear();
        globalVars.isValidIdentification = false;

        globalVars.capturedPathsMRZ="";
        globalVars.capturedBase64MRZ="";
        globalVars.isValidPassportIdentification = false;

        globalVars.capturedPathsTemporary="";
        globalVars.capturedBase64Temporary="";
        globalVars.isValidTemporaryIdentification = false;

        globalVars.capturedPathsForeign="";
        globalVars.capturedBase64Foreign="";
        globalVars.isValidForeignIdentification = false;
        globalVars.tackID  = false;
        globalVars.tackJordanPassport = false;
        globalVars.tackForeign=false;
        globalVars.tackTemporary=false;
        globalVars.showPersonalNumber=false;
      }

    }
    if(responseMap['success']==false){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?"${responseMap['"errorName']} : ${responseMap['message']['en']}":"${responseMap['"errorName']} :${responseMap['message']['ar']}"),backgroundColor: Colors.red));
      globalVars.capturedPaths.clear();
      globalVars.capturedBase64.clear();
      globalVars.isValidIdentification = false;

      globalVars.capturedPathsMRZ="";
      globalVars.capturedBase64MRZ="";
      globalVars.isValidPassportIdentification = false;

      globalVars.capturedPathsTemporary="";
      globalVars.capturedBase64Temporary="";
      globalVars.isValidTemporaryIdentification = false;

      globalVars.capturedPathsForeign="";
      globalVars.capturedBase64Foreign="";
      globalVars.isValidForeignIdentification = false;
      globalVars.tackID  = false;
      globalVars.tackJordanPassport = false;
      globalVars.tackForeign=false;
      globalVars.tackTemporary=false;
      globalVars.showPersonalNumber=false;
    }



  } else {
    print('Raw response: ${response.body}');
    setState(() {
      isloading=false;
      globalVars.capturedPaths.clear();
      globalVars.capturedBase64.clear();
      globalVars.isValidIdentification = false;

      globalVars.capturedPathsMRZ="";
      globalVars.capturedBase64MRZ="";
      globalVars.isValidPassportIdentification = false;

      globalVars.capturedPathsTemporary="";
      globalVars.capturedBase64Temporary="";
      globalVars.isValidTemporaryIdentification = false;

      globalVars.capturedPathsForeign="";
      globalVars.capturedBase64Foreign="";
      globalVars.isValidForeignIdentification = false;
      globalVars.tackID  = false;
      globalVars.tackJordanPassport = false;
      globalVars.tackForeign=false;
      globalVars.tackTemporary=false;
      globalVars.showPersonalNumber=false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
              ? jsonDecode(response.body)['message']['en']
              : jsonDecode(response.body)['message']['ar'],
        ),
        backgroundColor: Colors.red,
      ),
    );
    setState(() {
      isloading=false;
    });
  }
}
```

---

## Method 5: documentProcessingPassportTemp_API()

**Note:** This method may already exist as `documentProcessingPassport_API()` in the FTTH file. If it handles temporary passports, you may not need a separate method. Check if the existing method can handle both Jordanian and temporary passports.

If you need a separate method for temporary passports specifically, it would be similar to `documentProcessingPassport_API()` but with modified data parsing for the temporary passport format.

---

## Next Steps

1. **Open FTTH NationalityList.dart** file in your editor
2. **Copy each method** from this document into the appropriate location
3. **Update method call in uploadFrontID_API()**: Change line that calls `uploadBackID_API(backImage)` to `huploadBackID_API(backImage)`
4. **Update calls in passport foreign scanning**: Make sure `uploadForignPassportFile_API()` is called when foreign passport is captured
5. **Verify imports**: Make sure you have `dart:io` import for `X509Certificate`
6. **Test compilation**: Run `flutter analyze` to check for errors
7. **Test the flow**: Run the app and test document scanning for:
   - Jordanian ID (front and back)
   - Jordanian passport
   - Temporary passport
   - Foreign passport

---

## Important Notes

- ✅ All methods include the flag setting for displaying images (`_loadImageBackID`, `_LoadImageForeignPassport`)
- ✅ The `_documentProcessingSuccess` and `_lastValidatedNationalNo` flags are set for Next button logic
- ✅ Global variable cleanup is included in error handlers
- ⚠️ Make sure the method names match exactly (note: `huploadBackID_API` starts with 'h')
- ⚠️ The foreign passport upload is named `uploadForignPassportFile_API` (note spelling: "Forign")

---

## Backup Information

A backup of your FTTH file was created at:
`D:\mobile-dev\sales-app-ekyc\backup_ftth_ekyc_20251011_135155\NationalityList.dart.backup`

To restore if needed:
```powershell
Copy-Item "D:\mobile-dev\sales-app-ekyc\backup_ftth_ekyc_20251011_135155\NationalityList.dart.backup" "D:\mobile-dev\sales-app-ekyc\lib\Views\HomeScreens\Subdealer\Menu\PostPaid\FTTH\NationalityList.dart" -Force
```
