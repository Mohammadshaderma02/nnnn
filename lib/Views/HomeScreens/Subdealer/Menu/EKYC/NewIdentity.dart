
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
//import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/IdentificationSelfRecording.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import '../../../Corporate/Multi_Use_Components/RequiredField.dart';
import 'dart:io' as Io;
import 'dart:io';

class DocumentUpdate extends StatefulWidget {
  const DocumentUpdate({Key key}) : super(key: key);

  @override
  State<DocumentUpdate> createState() => _DocumentUpdateState();
}

class _DocumentUpdateState extends State<DocumentUpdate> {
  final channel = const MethodChannel('NativeChannel');
  static const platform = const MethodChannel('com.example.flutter/native');



  DateTime backButtonPressedTime;
  bool non_jordanianType= false;
  bool jordanianType= false;

  bool isChecked = false;

  String selected = "";


  TextEditingController personalNumber = TextEditingController();
  bool emptyPersonalNumber = false;
  bool errorPersonalNumber = false;

  final _picker = ImagePicker();

  File imageFrontID;
  File imageBackID;

  File imagePassport;
  File imagePersonalNumber;


  bool _loadImageFrontID = false;
  bool _loadImageBackID = false;

  bool _loadImagePassport = false;
  bool _loadImagePersonalNumber = false;

  var pickedFileFrontID;
  var pickedFileBackID;

  var pickedFilePasspor;
  var pickedFilePersonalNumber;


  String img64FrontID;
  String img64BackID;

  String img64Passport;
  String img64PersonalNumber;


  String IDFront='';
  String IDBack='';
  String PassportFront='';
  String PassortBack='';
  var ocrResultList;

  Uint8List imageBytes;

  Map<String, dynamic> responseJson;
  var OcrResult;
  String _result ;//save result  that come from OCR_IOS in String
  Map<String, dynamic> responseJsonID_IOS; //save result in list
/*.................................................SDK function IOS...........................................*/
  Future<void>  _callPasIOS() async {
    print("....................._callPassIOS.........................");
    setState(() {
      _loadImageBackID = false;
      _loadImageFrontID=false;
      IDFront="";
      IDBack="";
    });

    try {
      await platform.invokeMethod('OCRPass',{'openDoc': true});
      // getOcrResultIOS();
      print("platform.invokeMethod('OCRPass')");
      print(".....................Start_handleMethodCall.........................");
      // platform.setMethodCallHandler(_handleMethodCallOCR);
      print(".....................End_handleMethodCall.........................");

    } on PlatformException catch (e) {
      print("PlatformException catch (e)");

      print(e.message);
    }
  }

  Future<void> _handleMethodCallOCR(MethodCall call) async {
    switch (call.method) {
      case 'sendResultOCR':
        setState(() {
          _result = call.arguments;
          _loadImageBackID = true;
          _loadImageFrontID=true;
          responseJsonID_IOS=jsonDecode(_result);
          IDFront=responseJsonID_IOS['cropped']['front'];
          IDBack=responseJsonID_IOS['cropped']['back'];
        });
        print("....................._result = call.arguments.........................");
        print(IDBack);

        print("....................._result = call.arguments.........................");

        break;
      default:
        throw MissingPluginException('Not implemented: ${call.method}');
    }
  }

  void _emptyResponseJson() {
    setState(() {
      responseJson = null; // or responseJson = {};
    });
  }
  /*I use this function when save data locally in flutter and swift and I call it in _callOCRios */
  Future<void> getOcrResultIOS()async{

    print("..............................from flutter ......................");
    OcrResult = await platform.invokeMethod('getPrettyPrintedResult');
    if (OcrResult != null) {

      //  Map<String, dynamic> responseJson = json.decode(OcrResult);
      responseJson = json.decode(OcrResult);

      String frontValue = responseJson['cropped']['front'];

      setState(() {
        _loadImageBackID = true;
        _loadImageFrontID=true;
        IDFront=responseJson['cropped']['front'];
        IDBack=responseJson['cropped']['back'];
      });


      print("Retrieved prettyPrintedResult: $frontValue");
    } else {
      print("Failed to retrieve prettyPrintedResult");
    }

    /*  try {
      print(await platform.invokeMethod('getPrettyPrintedResult'));
      return await platform.invokeMethod('getPrettyPrintedResult');

    } on PlatformException catch (e) {
      print("Error: ${e.message}");
      return null;
    }*/
  }

  Future<void>  _callOCRios() async {
    print("....................._callOCRios.........................");
    setState(() {
      _loadImageBackID = false;
      _loadImageFrontID=false;
      IDFront="";
      IDBack="";
    });

    try {
      await platform.invokeMethod('OCRID',{'openDoc': true});
      // getOcrResultIOS();
      print("platform.invokeMethod('OCRID')");
      print(".....................Start_handleMethodCall.........................");
      platform.setMethodCallHandler(_handleMethodCallOCR);
      print(".....................End_handleMethodCall.........................");

    } on PlatformException catch (e) {
      print("PlatformException catch (e)");

      print(e.message);
    }
  }

/*..............................................Get Ocr Result from SDK function Android..........................................*/
  Future<void> callOCR() async {
    String data;
    try {
      await channel.invokeMethod('OCRSDK');
      data=await channel.invokeMethod('OCRSDK');
      print( await channel.invokeMethod('OCRSDK'));
      getOcrResult();

    } catch (e) {
      print('Error calling InitSDK method: $e');
    }

  }

  Future<void> getOcrResult() async {
    print("I am in getOcrResult Function in flutter");
    setState(() {
      _loadImageBackID = false;
      _loadImageFrontID=false;
      IDFront="";
      IDBack="";
    });
    String ocrResult;
    try {
      print(".............................Get Result of OCR as string.................................");
      /*..................................Get Result of OCR as string.................................*/

      final String result = await MethodChannel('NativeChannel').invokeMethod('getOcrResult');
      ocrResult = result;
      if(result != null || result !=""){
        /*........................Convert String to List to get all arguments...........................*/
        ocrResultList = (ocrResult.split(','));
        setState(() {
          _loadImageBackID = true;
          _loadImageFrontID=true;
          IDFront=ocrResultList[2];
          IDBack=ocrResultList[3];
        });
      }
      else{
        print("No get result back getOcrResult");
      }


    } on PlatformException catch (e) {
      print(",,,,,,,,,,,PlatformException,,,,,,,,,,,,,,");
      print(e.message);
      ocrResult = "Failed to get OCR result: '${e.message}'.";
    }

  }
/*...................................................................................................................................*/
/*....................................................Capture ID front side function.................................................*/
  void pickImageCameraFrontID() async {
    pickedFileFrontID = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileFrontID != null) {
      imageFrontID = File(pickedFileFrontID.path);
      _loadImageFrontID = true;
      var imageName = pickedFileFrontID.path.split('/').last;
      if (pickedFileFrontID != null) {
        _cropImageFrontID(File(pickedFileFrontID.path));
      }
    }
  }

  _cropImageFrontID(Io.File picture) async {
    print('called');
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      compressQuality: 100,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile
          .readAsBytesSync()
          .lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadImageFrontID = false;
            pickedFileFrontID = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64FrontID = base64Encode(base64Image);
          print('img64Crop: ${img64FrontID}');
          imageFrontID = File(cropped.path);
          print("...........imageFrontID..........");
        }
      });
    } else {
      this.setState(() {
        _loadImageFrontID = false;
        pickedFileFrontID = null;
      });
    }
  }

/*...................................................................................................................................*/
/*....................................................Capture ID front side function.................................................*/
  void pickImageCameraBackID() async {
    pickedFileBackID = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileBackID != null) {
      imageBackID = File(pickedFileBackID.path);
      _loadImageBackID = true;
      var imageName = pickedFileBackID.path.split('/').last;
      if (pickedFileBackID != null) {
        _cropImageBackID(File(pickedFileBackID.path));
      }
    }
  }

  _cropImageBackID(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      compressQuality: 100,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile
          .readAsBytesSync()
          .lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadImageBackID = false;
            pickedFileBackID = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64BackID = base64Encode(base64Image);
          print('img64Crop: ${img64BackID}');
          imageBackID = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadImageBackID = false;
        pickedFileBackID = null;
      });
    }
  }

/*....................................................................................................................................*/
/*..........................................................Clear Image ID function...................................................*/
  void clearJordanianImageID() {

    this.setState(() {
      _loadImageFrontID = false;
      _loadImageBackID=false;
      IDFront="";
      IDBack="";

      pickedFileFrontID=null;
      pickedFileBackID=null;
    });
  }
/*....................................................................................................................................*/

/*.........................................................Capture Passport function..................................................*/
  void pickImageCameraPassport() async {
    pickedFilePasspor = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFilePasspor != null) {
      imagePassport = File(pickedFilePasspor.path);
      _loadImagePassport = true;
      var imageName = pickedFilePasspor.path.split('/').last;
      if (pickedFilePasspor != null) {
        _cropImageFrontPassport(File(pickedFilePasspor.path));
      }
    }
  }

  _cropImageFrontPassport(Io.File picture) async {
    print('called');
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      compressQuality: 100,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile
          .readAsBytesSync()
          .lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadImagePassport = false;
            pickedFilePasspor = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Passport = base64Encode(base64Image);
          print('img64CropPassport: ${img64Passport}');
          imagePassport = File(cropped.path);
          print("...........imagePassport..........");
          print(imagePassport);
          print("...........imagePassport..........");
        }
      });
    } else {
      this.setState(() {
        _loadImagePassport = false;
        pickedFilePasspor = null;
      });
    }
  }

/*....................................................................................................................................*/
/*...................................................Capture personal number function.................................................*/
  void pickImageCameraPersonalNumber() async {
    pickedFilePersonalNumber = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFilePersonalNumber != null) {
      imagePersonalNumber = File(pickedFilePersonalNumber.path);
      _loadImagePersonalNumber = true;
      var imageName = pickedFilePersonalNumber.path.split('/').last;
      if (pickedFilePersonalNumber != null) {
        _cropImagePersonalNumber(File(pickedFilePersonalNumber.path));
      }
    }
  }

  _cropImagePersonalNumber(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      compressQuality: 100,
      maxWidth: 1080,
      maxHeight: 1080,
    );
    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile
          .readAsBytesSync()
          .lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadImagePersonalNumber = false;
            pickedFilePersonalNumber = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64PersonalNumber = base64Encode(base64Image);
          print('img64Crop: ${img64PersonalNumber}');
          imagePersonalNumber = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadImagePersonalNumber = false;
        pickedFilePersonalNumber = null;
      });
    }
  }

/*....................................................................................................................................*/
/*..........................................................Clear passport function...................................................*/
  void clearNonJordanianImageID() {
    this.setState(() {
      _loadImagePassport = false;
      _loadImagePersonalNumber = false;

      pickedFilePasspor=null;
      pickedFilePersonalNumber=null;
    });
  }

/*....................................................................................................................................*/

  Widget enterPersonalNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        Container(
          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            controller: personalNumber,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: emptyPersonalNumber == true || errorPersonalNumber == true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              )
                  : const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4F2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Enter personal number here..",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onChanged: (number) {
              if(number.length != 0){
                setState(() {
                  emptyPersonalNumber=false;
                });
              }


            },
          ),
        ),

      ],
    );
  }


  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);
      return true;
    }
    return true;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();


    setState(() {
      non_jordanianType= false;
      jordanianType= false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async {
                Navigator.pop(context);
              },
            ),
            centerTitle: false,
            title: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Document Upload'
                  : "تحميل المرفقات",
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 25, bottom: 0, left: 0, right: 0),
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center, // Align text to the start (left)
                children: [
                  /*..........................................................Please choose nationality.............................................*/
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                    child: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? 'Select your nationality'
                          : "اختر الجنسية",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),

                  SizedBox(height: 20,),
                  /*........................................JordanianType - nonJordanianType & Capture - Retake photo...............................*/

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(

                        height: 48,
                        width: 160,
                        //  margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: jordanianType==true?Color(0xFF4f2565):Colors.white,
                          border: Border.all( // Add border properties here
                            color: jordanianType==true?Color(0xFF4f2565):Colors.grey, // Set border color
                            width: 1, // Set border width
                          ),
                        ),
                        child: TextButton(

                          style: TextButton.styleFrom(
                            backgroundColor:jordanianType==true?Color(0xFF4f2565):Colors.white,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                          ),

                          onPressed:() async {

                            clearNonJordanianImageID();
                            setState(() {
                              non_jordanianType=false;
                              jordanianType=true;
                            });


                          },

                          child: Text(
                            "Jordanian",
                            style: TextStyle(
                                color:jordanianType==true?Colors.white: Colors.black54,
                                letterSpacing: 0,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                      Container(
                        height: 48,
                        width: 160,
                        //  margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: non_jordanianType==true?Color(0xFF4f2565):Colors.white,
                          border: Border.all( // Add border properties here
                            color: non_jordanianType==true?Color(0xFF4f2565):Colors.grey, // Set border color
                            width: 1, // Set border width
                          ),
                        ),
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor:non_jordanianType==true?Color(0xFF4f2565):Colors.white,
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                          ),

                          onPressed:() async {
                            /* Fluttertoast.showToast(
                                  msg: EasyLocalization.of(context).locale ==
                                      Locale("en", "US")
                                      ? 'This Service not available now'
                                      : 'هذه الخدمة غير متاحة الآن',
                                  backgroundColor: Color(0xFF323232),
                                  textColor: Colors.white);*/



                            clearJordanianImageID();
                            setState(() {
                              non_jordanianType=true;
                              jordanianType=false;
                            });

                          },

                          child: Text(
                            "Non-Jordanian",
                            style: TextStyle(
                                color:non_jordanianType==true?Colors.white: Colors.black54,
                                letterSpacing: 0,
                                fontSize: 16,
                                fontWeight: FontWeight.w400),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20,),

                  Container(
                    height: 48,
                    width: 420,
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF4f2565),
                    ),
                    child: TextButton(

                        style: TextButton.styleFrom(
                          backgroundColor:Color(0xFF4f2565),
                          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                        ),

                        onPressed:() async {
                          if( jordanianType==false){
                            Fluttertoast.showToast(
                                msg: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? 'Need to select nationality'
                                    : 'بحاجة إلى اختيار الجنسية',
                                backgroundColor: Color(0xFF323232),

                                textColor: Colors.white);
                          }
                          if( non_jordanianType==false){
                            Fluttertoast.showToast(
                                msg: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? 'Need to select nationality'
                                    : 'بحاجة إلى اختيار الجنسية',
                                backgroundColor: Color(0xFF323232),

                                textColor: Colors.white);
                          }
                          if( non_jordanianType==true){
                            if (Platform.isIOS) {
                              print('Running on iOS');
                              setState(()async {
                                _loadImageBackID = false;
                                _loadImageFrontID=false;
                                // IDFront="";
                                // IDBack="";
                              });
                              _callPasIOS();
                            } else if (Platform.isAndroid) {
                              print('Running on Android');
                              Fluttertoast.showToast(
                                  msg: EasyLocalization.of(context).locale ==
                                      Locale("en", "US")
                                      ? 'This Service not available now'
                                      : 'هذه الخدمة غير متاحة الآن',
                                  backgroundColor: Color(0xFF323232),

                                  textColor: Colors.white);
                            }
                          }
                          if( jordanianType==true){
                            if (Platform.isIOS) {

                              print('Running on iOS');
                              setState(()async {
                                _loadImageBackID = false;
                                _loadImageFrontID=false;
                                // IDFront="";
                                // IDBack="";
                              });
                              print("......... _loadImageBackID = false.........");
                              print( _loadImageBackID);
                              _emptyResponseJson();
                              _callOCRios();
                            } else if (Platform.isAndroid) {
                              print('Running on Android');
                              callOCR();
                            }

                          }

                          /*  if( non_jordanianType ==true || non_jordanianType == false){
                          Fluttertoast.showToast(
                              msg: EasyLocalization.of(context).locale ==
                                  Locale("en", "US")
                                  ? 'This Service not available now'
                                  : 'هذه الخدمة غير متاحة الآن',
                              backgroundColor: Color(0xFF323232),

                              textColor: Colors.white);
                        }*/

                        },

                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(
                              Icons.photo_camera, // Replace with your desired icon
                              color: Colors.white,
                            ),
                            SizedBox(width: 8),
                            Text(
                              "Start to captures photo",
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                    ),
                  ),
/*....................................................Capture your ID front side.................................................*/
                  jordanianType==true?
                  Column(
                    children: [
                      SizedBox(height: 35,),
                      /* Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                        child: Text(
                          "Capture your ID front side",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),*/
                      SizedBox(height: 20,),
                      _loadImageFrontID == true?
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            showDialog(
                                context: context,
                                builder: (_) => Center(
                                  // Aligns the container to center
                                    child: Container(
                                      //color: Colors.deepOrange.withOpacity(0.5),
                                      child: PhotoView(
                                        enableRotation: true,
                                        backgroundDecoration:
                                        BoxDecoration(),
                                        imageProvider:MemoryImage(base64Decode(IDFront)),
                                      ),
                                      // A simplified version of dialog.
                                      width: 300.0,
                                      height: 350.0,
                                    )));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                        // image: FileImage(imageFrontID),
                                        image: MemoryImage(base64Decode(IDFront)),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                    size: 30,

                                  ),
                                  SizedBox(height: 15,),
                                  Text(
                                    'Preview Photo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                          :
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap event to open camera
                            //   pickImageCameraFrontID();
                            //  getOcrResult();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Image(
                                  image: AssetImage('assets/images/JordanianID.jpeg'),
                                  fit: BoxFit.cover,
                                  width: 342,
                                  height: 200,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  color: Color(0xFF505050).withOpacity(0.6), // Adjust opacity as needed
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Your ID Front Side',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  )
                      :
                  Container(),

                  SizedBox(height: 20,),
                  /*....................................................Capture your ID Back side..............................................*/
                  jordanianType==true?
                  Column(
                    children: [

                      /* Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                        child: Text(
                          "Capture your ID back side",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),*/
                      SizedBox(height: 20,),
                      _loadImageBackID == true?
                      Center(
                        child: GestureDetector(
                          onTap: () async {
                            FocusScope.of(context).unfocus();
                            showDialog(
                                context: context,
                                builder: (_) => Center(
                                  // Aligns the container to center
                                    child: Container(
                                      //color: Colors.deepOrange.withOpacity(0.5),
                                      child: PhotoView(
                                        enableRotation: true,
                                        backgroundDecoration:
                                        BoxDecoration(),
                                        imageProvider:MemoryImage(base64Decode(IDBack)),
                                      ),
                                      // A simplified version of dialog.
                                      width: 300.0,
                                      height: 350.0,
                                    )));
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                        //  image: FileImage(imageBackID),
                                        image: MemoryImage(base64Decode(IDBack)),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.remove_red_eye,
                                    color: Colors.white,
                                    size: 30,

                                  ),
                                  SizedBox(height: 15,),
                                  Text(
                                    'Preview Photo',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      )
                          :
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap event to open camera
                            //  pickImageCameraBackID();

                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Image(
                                  image: AssetImage('assets/images/JordanianID.jpeg'),
                                  fit: BoxFit.cover,
                                  width: 342,
                                  height: 200,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  color: Color(0xFF505050).withOpacity(0.6), // Adjust opacity as needed
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Your ID Back Side',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  )
                      :
                  Container(),
                  /*.........................................................Capture Passport................................................*/
                  non_jordanianType==true?
                  Column(
                    children: [
                      SizedBox(height: 20,),
                      /* Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                        child: Text(
                          "Capture Passport",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),*/
                      SizedBox(height: 20,),
                      _loadImagePassport == true?
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap event to open camera
                            //  pickImageCameraPassport();

                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                        image: MemoryImage(base64Decode(IDFront)) ,
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 30,

                                  ),
                                  SizedBox(height: 15,),
                                  Text(
                                    'Retake',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ) :
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap event to open camera
                            // pickImageCameraPassport();
                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Image(
                                  image: AssetImage('assets/images/JordanianID.jpeg'),
                                  fit: BoxFit.cover,
                                  width: 342,
                                  height: 200,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  color: Color(0xFF505050).withOpacity(0.6), // Adjust opacity as needed
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Click here to capture a photo copy\n of your ID Back Side',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                    ],
                  )
                      :
                  Container(),
                  SizedBox(height: 20,),
                  /*....................................................Capture personal number..............................................*/
                  non_jordanianType==true?
                  Column(
                    children: [

                      /*  Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20), // Add padding here
                        child: Text(
                          "Capture personal number",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),*/
                      SizedBox(height: 20,),
                      _loadImagePersonalNumber == true?
                      Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap event to open camera
                            //  pickImageCameraPersonalNumber();

                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  decoration: BoxDecoration(
                                      color: Colors.black,
                                      image: DecorationImage(
                                        colorFilter: new ColorFilter.mode(
                                            Colors.black.withOpacity(0.5),
                                            BlendMode.dstATop),
                                        image: FileImage(imagePersonalNumber),
                                        fit: BoxFit.cover,
                                      )),
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  color: Color(0xFF505050).withOpacity(0.1), // Adjust opacity as needed
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.refresh,
                                    color: Colors.white,
                                    size: 30,

                                  ),
                                  SizedBox(height: 15,),
                                  Text(
                                    'Retake',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ) :  Center(
                        child: GestureDetector(
                          onTap: () {
                            // Handle tap event to open camera
                            //   pickImageCameraPersonalNumber();

                          },
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Image(
                                  image: AssetImage('assets/images/JordanianID.jpeg'),
                                  fit: BoxFit.cover,
                                  width: 342,
                                  height: 200,
                                ),
                              ),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(8), // Set border radius
                                child: Container(
                                  width: 342,
                                  height: 200,
                                  color: Color(0xFF505050).withOpacity(0.6), // Adjust opacity as needed
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Click here to capture a photo copy\n of your ID Back Side',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),

                                ],
                              ),
                            ],
                          ),
                        ),
                      ),


                    ],
                  )
                      :
                  Container(),

/*...........................................................Check field...................................................*/
                  non_jordanianType == true ?
                  Column(
                    children: [
                      SizedBox(height: 5,),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal:18),
                        child:  Row(
                          children: [
                            Checkbox(
                              fillColor: MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                    if (states.contains(MaterialState.selected)) {
                                      return  Color(0xFF4f2565); // change the color when checked
                                    }
                                    return Colors.grey; // default color
                                  }),
                              value: isChecked,
                              onChanged: (bool value) {
                                setState(() {
                                  isChecked = value;
                                });
                              },
                            ),
                            Text('Enter personal number manually'),
                          ],
                        ),
                      ),
                    ],
                  ):Container(),

                  /*....................................................Personal Number Field...............................................*/
                  non_jordanianType==true && isChecked==true? Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal:25),
                        child:
                        enterPersonalNumber(),
                      ),
                    ],
                  ):Container(),

                  /*........................................................Next Button.................................................*/

                  SizedBox(height: 20,),
                  non_jordanianType==true || jordanianType==true?
                  Container(
                    height: 48,
                    width: 420,
                    margin: EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Color(0xFF0E7074),
                    ),
                    child: TextButton(

                      style: TextButton.styleFrom(
                        backgroundColor:Color(0xFF0E7074),
                        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                      ),

                      onPressed:() async {

                        if( IDFront!=""&& IDBack!="" && jordanianType==true ){
                         /* Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IdentificationSelfRecording(),
                            ),
                          );*/
                        }

                        if( IDFront==""&& IDBack=="" && jordanianType==true ){
                          Fluttertoast.showToast(
                              msg: EasyLocalization.of(context).locale ==
                                  Locale("en", "US")
                                  ? 'You need to capture ID photo '
                                  : 'تحتاج إلى التقاط صورة الهوية',
                              backgroundColor: Color(0xFF323232),

                              textColor: Colors.white);
                        }

                        if( PassportFront!=""&& PassortBack!="" && non_jordanianType==true ){
                       /*   Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  IdentificationSelfRecording(),
                            ),
                          );*/
                        }

                        if( PassportFront==""&& PassortBack=="" && non_jordanianType==true ){
                          Fluttertoast.showToast(
                              msg: EasyLocalization.of(context).locale ==
                                  Locale("en", "US")
                                  ? 'You need to capture Passport photo '
                                  : 'تحتاج إلى التقاط صورة جواز السفر',
                              backgroundColor: Color(0xFF323232),

                              textColor: Colors.white);
                        }

                      },

                      child: Text(
                        "Next",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  )
                      :
                  Container(),
                ],
              ),


            ],
          ),
        ),
      ),
      onWillPop: onWillPop,
    );
  }

}


/*import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:uni_links/uni_links.dart';
import 'package:flutter/services.dart';

class SanadScreen extends StatefulWidget {
  const SanadScreen({Key key}) : super(key: key);

  @override
  State<SanadScreen> createState() => _SanadScreenState();
}

class _SanadScreenState extends State<SanadScreen> {
  StreamSubscription _sub;
  TextEditingController simCardController = TextEditingController();
  bool emptySimCard = false;
  bool errorSimCard = false;
  String _dataSimCard = "";
  String redirectUrl;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  // ✅ Initialize deep link listener
  void _initDeepLinkListener() async {
    try {
      final initialUri = await getInitialUri();
      if (initialUri != null) _handleDeepLink(initialUri);
    } on PlatformException {
      print('Failed to receive initial uri.');
    } on FormatException catch (err) {
      print('Malformed initial uri: $err');
    }

    _sub = uriLinkStream.listen((Uri uri) {
      if (uri != null) _handleDeepLink(uri);
    }, onError: (err) {
      print('Deeplink error: $err');
    });
  }

  // ✅ Handle success/error deep links
  void _handleDeepLink(Uri uri) {
    print("Deep link received: $uri");

    final status = uri.queryParameters['status'] ?? '';
    final error = uri.queryParameters['error'];

    if (error != null && error != 'none') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ErrorScreen(error: error)),
      );
    } else if (status == 'success') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => SuccessScreen()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => ErrorScreen(error: 'Unknown error')),
      );
    }
  }

  // ✅ Simulated API call to check verification
  void sanad_API() async {
    final apiUrl = "https://dsc.jo.zain.com/eKYC/api/lines/sanad/digitalId/9971010867";
    final response = await http.get(
      Uri.parse(apiUrl),
      headers: {
        "content-type": "application/json",
        "X-API-KEY": "37375383-f46b-41d4-a79c-a4a4c2f8b1e4"
      },
    );

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      if (result["data"]["verified"] == true) {
        redirectUrl = result["data"]["redirectUrl"];
        final Uri sanadUrl = Uri.parse(
          "https://signflow.sanad.gov.jo/signflow/v2/auth?client_id=ca02ff3345ab4cb5b73bd7ba2e753f3f&redirect_uri=https://079.jo/user/steps/sanad&state=nW7hgyXuNTPmBKFSk5OYCxgA06UZduCAlvs9KZxvyZ0==&challenge=cFcsRMjAW4yKpExVwOibhvxZyLaKYHnI5QEQYiqGr9E&culture=en"

        );

        if (await canLaunchUrl(sanadUrl)) {
          await launchUrl(sanadUrl, mode: LaunchMode.externalApplication);
        } else {
          print('Could not launch Sanad URL');
        }
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => TermsConditions()),
        );
      }
    } else {
      print('API call failed with status: ${response.statusCode}');
    }
  }

  Widget enterSerialNumber() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 28),
      child: TextFormField(
        controller: simCardController,
        decoration: InputDecoration(
          hintText: 'Identity number',
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: errorSimCard ? Colors.red : Colors.grey),
            borderRadius: BorderRadius.circular(5),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(5),
          ),
          suffixIcon: IconButton(
            icon: Icon(Icons.close),
            onPressed: () => setState(() => simCardController.clear()),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => true,
      child: Scaffold(
        appBar: AppBar(
          title: Text('Sanad Verification'),
          backgroundColor: Colors.deepPurple,
        ),
        body: ListView(
          padding: EdgeInsets.all(20),
          children: [
            SizedBox(height: 20),
            enterSerialNumber(),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: sanad_API,
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF0E7074),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                padding: EdgeInsets.symmetric(vertical: 14),
              ),
              child: Text(
                'Check',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// ✅ Success Screen
class SuccessScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Success')),
      body: Center(child: Text('Welcome! Authentication successful 🎉')),
    );
  }
}

// ✅ Error Screen
class ErrorScreen extends StatelessWidget {
  final String error;
  const ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login Failed')),
      body: Center(child: Text('Error: $error')),
    );
  }
}

// ✅ Placeholder for TermsConditions
class TermsConditions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Terms & Conditions')),
      body: Center(child: Text('Terms go here')),
    );
  }
}*/