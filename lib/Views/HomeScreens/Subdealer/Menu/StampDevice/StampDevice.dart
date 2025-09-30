import 'dart:io';
import 'dart:io' as Io;

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/StampDevice/getContract.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import '../../../../ReusableComponents/requiredText.dart';
import '../../../Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:flutter/material.dart';
//import 'package:camera/camera.dart';
//import '../../../Subdealer/Menu/StampDevice/camera_page.dart';


//import 'package:flutter_barcode_sdk/dynamsoft_barcode.dart';
//import 'package:flutter_barcode_sdk/flutter_barcode_sdk.dart';
import 'dart:ui' as ui;
import 'dart:async';
//import '../../../Subdealer/Menu/StampDevice/utils.dart';
import 'dart:ui' as ui;

class StampDevice extends StatefulWidget {
  final List<dynamic> Permessions;
  final outDoorUserName;
  StampDevice(this.Permessions, this.outDoorUserName);

  @override
  State<StampDevice> createState() => _StampDeviceState(this.Permessions,this.outDoorUserName);
}

APP_URLS urls = new APP_URLS();

class _StampDeviceState extends State<StampDevice> {
  List<dynamic> Permessions;
  final outDoorUserName;
  DateTime backButtonPressedTime;
  bool isLooding = false;
  TextEditingController msisdn = TextEditingController();
  TextEditingController serialNumber = TextEditingController();



  bool emptyMSISDN = false;
  bool errorMSISDN = false;
  bool errorChecklength =false;

  bool emptySerial = false;
  bool errorSerial = false;
  String _dataKitCode="";



  bool reseller = false;
  var options_Reseller = [];
  var selectedReseller;
  bool emptyselectedReseller = false;

  List<String> Reseller_Value = [];
  var selectedReseller_Value = null;
  var selectedReseller_key;

  String localPath;
  File fileContract;
  bool isLoading = false;

/*........................New Part on 25 March 2025 to add Image for ID & Passport & Expiry Date............*/
  bool isJordanian = true;
  bool isNonJordanian = false;
  bool nationality=true;

  int imageWidth = 200;
  int imageHeight = 200;
  final _picker = ImagePicker();

  File imageFileFrontID;
  bool _loadIdFront = false;
  var pickedFileFrontId;

  File imageFileBackID;
  bool _loadIdBack = false;
  var pickedFileBackId;

  File imageFilePassport;
  bool _loadPassport = false;
  var pickedFilePassport;

  String img64Front;
  String img64Back;
  String img64Passport;

  File imageFileIDFront;
  File imageFileIDBack;


  bool imageIDFrontRequired = false;
  bool imageIDBackRequired = false;
  bool imagePassportRequired = false;
  /*...........................................Document Expiry Date.........................................*/
  bool emptyDocumentExpiryDate=false;
  TextEditingController documentExpiryDate = TextEditingController();
  DateTime Expiry_Date = DateTime.now();

  _StampDeviceState(this.Permessions,this.outDoorUserName);

  @override
  void initState() {
    LookupON_Reseller();
    super.initState();
  }


  /*.................................................Document Expiry .........................................................*/
  Widget buildDocumentExpiryDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? "Document Expiry Date"
                : "تاريخ انتهاء الوثيقة",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Color(0xFFB10000),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            controller: documentExpiryDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder: emptyDocumentExpiryDate == true
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/icon-calendar.png"),
                    onPressed: () async {
                      DateTime pickedDate = await showDatePicker(
                        context: context,
                        firstDate: DateTime.now().add(Duration(days: 1)), // Disable current & past dates
                        initialDate: DateTime.now().add(Duration(days: 1)),
                        lastDate: DateTime(DateTime.now().year + 20),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(0xFF4f2565), // Header background color
                                onPrimary: Colors.white, // Header text color
                                onSurface: Colors.black, // Body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Color(0xFF4f2565), // Button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      );

                      // ✅ Null check before updating state
                      if (pickedDate != null) {
                        setState(() {
                          Expiry_Date = pickedDate;
                          documentExpiryDate.text =
                          "${pickedDate.day.toString().padLeft(2, '0')}/${pickedDate.month.toString().padLeft(2, '0')}/${pickedDate.year.toString()}";
                        });
                      }
                    }
                ),
              ),
              hintText:  EasyLocalization.of(context).locale ==
                  Locale("en", "US")
                  ? "dd/mm/yyyy":"يوم/شهر/سنة",
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }


  void calculateImageSize(String path) {
    Completer<Size> completer = Completer();
    Image image = Image.file(File(path));
    image.image.resolve(ImageConfiguration()).addListener(
      ImageStreamListener(
            (ImageInfo image, bool synchronousCall) {
          var myImage = image.image;
          Size size = Size(myImage.width.toDouble(), myImage.height.toDouble());
          completer.complete(size);
          print("size = ${size}");
          print(size.height);
          print(size.width);
          print(size.aspectRatio);
          double ratio = 0;
          if (size.height > size.width) {
            ratio = (size.height / 1024);
          } else {
            ratio = (size.width / 1024);
          }

          setState(() {
            imageHeight = (size.height / ratio).toInt();
            imageWidth = (size.width / ratio).toInt();
          });
          print('ratio ${ratio}');
        },
      ),
    );
  }


  void pickImageCameraFront() async {
    pickedFileFrontId = await _picker.pickImage(
      source: ImageSource.camera,
    );
    // final bytes = File(pickedFileFrontId.path).readAsBytesSync().lengthInBytes;

    // final kb = bytes / 1024;
    //final mb = kb / 1024;

    // print('size in mb before crop ${mb}');

    if (pickedFileFrontId != null) {
      imageFileIDFront = File(pickedFileFrontId.path);
      _loadIdFront = true;
      var imageName = pickedFileFrontId.path.split('/').last;

      calculateImageSize(pickedFileFrontId.path);
      if (pickedFileFrontId != null) {
        _cropImageFront(File(pickedFileFrontId.path));
      }
    }
  }

  void pickImageGalleryFront() async {
    pickedFileFrontId = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileFrontId != null) {
      imageFileIDFront = File(pickedFileFrontId.path);
      _loadIdFront = true;
      var imageName = pickedFileFrontId.path.split('/').last;
      calculateImageSize(pickedFileFrontId.path);
      if (pickedFileFrontId != null) {
        _cropImageFront(File(pickedFileFrontId.path));
      }
    }
  }

  void pickImageCameraBack() async {
    pickedFileBackId = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileBackId != null) {
      imageFileIDBack = File(pickedFileBackId.path);
      _loadIdBack = true;

      var imageName = pickedFileBackId.path.split('/').last;
      calculateImageSize(pickedFileBackId.path);

      if (pickedFileBackId != null) {
        _cropImageBack(File(pickedFileBackId.path));
      }
    }
  }

  void pickImageGalleryBack() async {
    pickedFileBackId = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileBackId != null) {
      imageFileIDBack = File(pickedFileBackId.path);
      _loadIdBack = true;
      var imageName = pickedFileBackId.path.split('/').last;
      calculateImageSize(pickedFileBackId.path);

      if (pickedFileBackId != null) {
        _cropImageBack(File(pickedFileBackId.path));
      }
    }
  }

  _cropImageFront(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,

      maxWidth: 1080,
      maxHeight: 1080,
      //aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0)
    );
    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      print('size in mb after crop ${mb}');
      print(kb);

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadIdFront = false;
            pickedFileFrontId = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Front = base64Encode(base64Image);
          print("HAYA ALI HAZAIMEH");
          print('img64Crop: ${img64Front}');
          imageFileFrontID = File(cropped.path);

          print("imageFileFrontID");
          print(imageFileFrontID);
        }
      });
    } else {
      this.setState(() {
        _loadIdFront = false;
        pickedFileFrontId = null;

        ///here
      });
    }
  }

  _cropImageBack(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      compressQuality: 100,
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadIdBack = false;
            pickedFileBackId = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Back = base64Encode(base64Image);
          print('img64Crop: ${img64Back}');
          imageFileIDBack = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadIdBack = false;
        pickedFileBackId = null;

        ///here
      });
    }
  }


  void _showPickerFront(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: new ListTile(
                      leading: new Text(
                        "Jordan_Nationality.select_option".tr().toString(),
                        style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: new IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Color(0xFF747E8D),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageCameraFront();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.open_camera".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageGalleryFront();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.photo_size_select_actual_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.Choose_photos".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _showPickerBack(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: new ListTile(
                      leading: new Text(
                        "Jordan_Nationality.select_option".tr().toString(),
                        style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: new IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Color(0xFF747E8D),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageCameraBack();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.open_camera".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageGalleryBack();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.photo_size_select_actual_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.Choose_photos".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
        });
  }


  void clearImageIDFront() {
    /* this.setState(()=>
    imageFileID = null );*/

    this.setState(() {
      _loadIdFront = false;
      pickedFileFrontId = null;
      img64Front=null;

      ///here
    });
  }

  void clearImageIDBack() {
    this.setState(() {
      _loadIdBack = false;
      pickedFileBackId = null;
     img64Back=null;

      ///here
    });
  }


  void pickImageCameraPassport() async {
    pickedFilePassport = await _picker.pickImage(
      source: ImageSource.camera,
    );
    // final bytes = File(pickedFilePassport.path).readAsBytesSync().lengthInBytes;

    // final kb = bytes / 1024;
    //final mb = kb / 1024;

    // print('size in mb before crop ${mb}');

    if (pickedFilePassport != null) {
      imageFilePassport = File(pickedFilePassport.path);
      _loadPassport = true;
      var imageName = pickedFilePassport.path.split('/').last;

      calculateImageSize(pickedFilePassport.path);
      if (pickedFilePassport != null) {
        _cropImagePassport(File(pickedFilePassport.path));
      }
    }
  }

  void pickImageGalleryPassport() async {
    pickedFilePassport = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFilePassport != null) {
      imageFilePassport = File(pickedFilePassport.path);
      _loadPassport = true;
      var imageName = pickedFilePassport.path.split('/').last;
      calculateImageSize(pickedFilePassport.path);
      if (pickedFilePassport != null) {
        _cropImagePassport(File(pickedFilePassport.path));
      }
    }
  }

  _cropImagePassport(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      compressQuality: 100,
      maxWidth: 1080,
      maxHeight: 1080,
    );

    if (cropped != null) {
      final File innerFile = File(cropped.path);
      final bytes = innerFile.readAsBytesSync().lengthInBytes;

      final kb = bytes / 1024;
      final mb = kb / 1024;

      this.setState(() {
        if (mb > 2) {
          showToast("Notifications_Form.size_mb".tr().toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadPassport = false;
            pickedFilePassport = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Passport = base64Encode(base64Image);
          print('img64CropPassport: ${img64Passport}');
          imageFilePassport = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadPassport = false;
        pickedFilePassport = null;

        ///here
      });
    }
  }

  void _showPickerPassport(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              child: new Wrap(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: new ListTile(
                      leading: new Text(
                        "Jordan_Nationality.select_option".tr().toString(),
                        style: TextStyle(
                            color: Color(0xff11120e),
                            fontSize: 14,
                            fontWeight: FontWeight.w600),
                      ),
                      trailing: new IconButton(
                        icon: Icon(Icons.close),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        color: Color(0xFF747E8D),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageCameraPassport();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.camera_alt_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.open_camera".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageGalleryPassport();
                      Navigator.of(context).pop();
                    },
                    child: Row(
                      children: [
                        SizedBox(
                          width: 15,
                        ),
                        new Icon(
                          Icons.photo_size_select_actual_outlined,
                          color: Color(0xFF747E8D),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        new Text(
                          "Jordan_Nationality.Choose_photos".tr().toString(),
                          style:
                          TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          );
        });
  }

  void clearImagePassport() {
    this.setState(() {
      _loadPassport = false;
      pickedFilePassport = null;
       img64Passport=null;

      ///here
    });
  }

  Widget buildDashedBorder({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));


  Widget buildImageIdFront() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                padding: EdgeInsets.only(left: 10, right: 5),
                child: _loadIdFront == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 170,
                          height: 110,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(imageFileIDFront),
                                fit: BoxFit.cover,
                              )),
                          child: new Row(children: <Widget>[
                            Center(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.only(
                                        top: 25, left: 70, right: 70),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/iconCheck.png'),
                                      fit: BoxFit.cover,
                                      height: 24.0,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  new Container(
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
                                                    imageProvider: FileImage(
                                                        imageFileIDFront),
                                                  ),
                                                  // A simplified version of dialog.
                                                  width: 300.0,
                                                  height: 350.0,
                                                )));
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Jordan_Nationality.preview_photo"
                                              .tr()
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: 170,
                          padding: EdgeInsets.only(top: 15),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _showPickerFront(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Jordan_Nationality.re_take_photo"
                                    .tr()
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0070c9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    : Column(children: [
                  buildDashedBorder(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showPickerFront(context);
                      },
                      child: Container(
                        width: 170,
                        height: 110,
                        child: GestureDetector(
                          child: Align(
                              alignment: Alignment.center,
                              child: EasyLocalization.of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Jordan_Nationality.take_photo1"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Jordan_Nationality.take_photo2"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                                  : Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Jordan_Nationality.take_photo1"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              //SizedBox(width: 10),
            ],
          ),
          imageIDFrontRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
        ]),
      ),
    );
  }

  Widget buildImageIdBack() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                padding: EdgeInsets.only(left: 10, right: 5),
                child: _loadIdBack == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 170,
                          height: 110,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(imageFileIDBack),
                                fit: BoxFit.cover,
                              )),
                          child: new Row(children: <Widget>[
                            Center(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.only(
                                        top: 25, left: 70, right: 70),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/iconCheck.png'),
                                      fit: BoxFit.cover,
                                      height: 24.0,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  new Container(
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
                                                    imageProvider: FileImage(
                                                        imageFileIDBack),
                                                  ),
                                                  // A simplified version of dialog.
                                                  width: 300.0,
                                                  height: 350.0,
                                                )));
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Jordan_Nationality.preview_photo"
                                              .tr()
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: 170,
                          padding: EdgeInsets.only(top: 15),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _showPickerBack(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Jordan_Nationality.re_take_photo"
                                    .tr()
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0070c9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    : Column(children: [
                  buildDashedBorder(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showPickerBack(context);
                      },
                      child: Container(
                        width: 170,
                        height: 110,
                        child: GestureDetector(
                          child: Align(
                              alignment: Alignment.center,
                              child: EasyLocalization.of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Jordan_Nationality.take_photo1"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Jordan_Nationality.take_photo2"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                                  : Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Jordan_Nationality.take_photo1"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              //SizedBox(width: 10),
            ],
          ),
          imageIDBackRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
        ]),
      ),
    );
  }

  Widget buildImagePassport() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(20),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                padding: EdgeInsets.only(left: 10, right: 5),
                child: _loadPassport == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 170,
                          height: 110,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(imageFilePassport),
                                fit: BoxFit.cover,
                              )),
                          child: new Row(children: <Widget>[
                            Center(
                              child: new Column(
                                children: <Widget>[
                                  new Container(
                                    padding: EdgeInsets.only(
                                        top: 25, left: 70, right: 70),
                                    child: Image(
                                      image: AssetImage(
                                          'assets/images/iconCheck.png'),
                                      fit: BoxFit.cover,
                                      height: 24.0,
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  new Container(
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
                                                    imageProvider: FileImage(
                                                        imageFilePassport),
                                                  ),
                                                  // A simplified version of dialog.
                                                  width: 300.0,
                                                  height: 350.0,
                                                )));
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "Jordan_Nationality.preview_photo"
                                              .tr()
                                              .toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Color(0xFFffffff),
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ]),
                        ),
                      ],
                    ),
                    new Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        new Container(
                          width: 170,
                          padding: EdgeInsets.only(top: 15),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _showPickerPassport(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Jordan_Nationality.re_take_photo"
                                    .tr()
                                    .toString(),
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xFF0070c9),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
                    : Column(children: [
                  buildDashedBorder(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showPickerPassport(context);
                      },
                      child: Container(
                        width: 170,
                        height: 110,
                        child: GestureDetector(
                          child: Align(
                              alignment: Alignment.center,
                              child: EasyLocalization.of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Jordan_Nationality.take_photo1"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    "Jordan_Nationality.take_photo2"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )
                                  : Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Jordan_Nationality.take_photo1"
                                        .tr()
                                        .toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                    ),
                  ),
                ]),
              ),
              //SizedBox(width: 10),
            ],
          ),
          imagePassportRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
        ]),
      ),
    );
  }


  /************************************************************New 18/3/2024************************************************************/
  void LookupON_Reseller() async {
    print("/Lookup/RESELLER");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lookup/RESELLER';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
    );
    int statusCode = response.statusCode;
    var data = response.request;

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);

      if (result["status"] == 0) {
        setState(() {
          options_Reseller = result["data"];
        });
        for (var i = 0; i < result['data'].length; i++) {
          Reseller_Value.add(result['data'][i]['value'].toString());
        }
        print(
            "/********************************************************************/");
        print(options_Reseller);
        print(
            "/********************************************************************/");
      } else {
        // showAlertDialogERROR(context, result["messageAr"], result["message"]);
        setState(() {
          //isLoadingReconnect = false;
        });
      }

      return result;
    } else {
      // showAlertDialogOtherERROR(context,statusCode, statusCode);
    }
  }

  void changeON_Reseller(value) async {
    setState(() {
      reseller = !reseller;
      selectedReseller = null;
      selectedReseller_key = null;
      selectedReseller_Value = null;
    });
    print(reseller);
  }

  Widget buildON_Reseller() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: reseller,
            onChanged: (value) {
              changeON_Reseller(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF4f2565),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "Postpaid.Reseller".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildSelect_Reseller() {
    return Column(

      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.Reseller".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
            margin: EasyLocalization.of(context).locale == Locale("en", "US")?
            EdgeInsets.only(right: 10,left: 0):EdgeInsets.only(right: 0,left: 10),
            padding: EdgeInsets.only(left: 10, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyselectedReseller == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  cursorColor: Color(0xFF4f2565),
                ),
              ),
              items: Reseller_Value,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Color(0xFFD1D7E0)),
                  ),
                  hintText:
                  "Personal_Info_Edit.select_an_option".tr().toString(),
                  hintStyle: TextStyle(
                    color: Color(0xFFA4B0C1),
                    fontSize: 14,
                  ),
                ),
              ),
              onChanged: (val) {
                print(val);
                getKeySelectedReseller(val);
              },
              selectedItem: selectedReseller_Value,
            )),
        emptyselectedReseller == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required".tr().toString())
            : Container(),
      ],
    );
  }

  void getKeySelectedReseller(val) {
    for (var i = 0; i < options_Reseller.length; i++) {
      if (options_Reseller[i]['value']==(val)) {
        setState(() {
          selectedReseller_key = options_Reseller[i]['key'];
        });
        print(selectedReseller_key);
      } else {
        continue;
      }
    }
  }

  /************************************************************End New****************************************************************/

  Widget enterMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'MSISDN'
                : "الرقم",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Color(0xFFB10000),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            controller: msisdn,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: emptyMSISDN == true || errorMSISDN == true
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
              hintText: "xxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onChanged: (msisdn) {


                  if(msisdn.length != 0){
                    setState(() {
                      emptyMSISDN=false;
                    });
                  }


            },
          ),
        ),

      ],
    );
  }

  Widget enterSerialNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Serial Number'
                : "الرقم التسلسلي",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Color(0xFFB10000),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 5),
        Container(
          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            controller: serialNumber,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              enabledBorder: emptySerial == true || errorSerial == true
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
              suffixIcon: IconButton(
                onPressed: clearSerialNumber,
                icon: Icon(
                    Icons.close
                ),
                color: Color(0xFFA4B0C1),
              ),
             // hintText: "079xxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onChanged: (serialNumber) {


              if(serialNumber.length != 0){
                setState(() {
                  emptySerial = false;
                });
              }
              if(serialNumber.length == 0){
                emptySerial = true;
              }
            },
          ),
        ),

      ],
    );
  }


  void clearSerialNumber(){
    setState(() {
      serialNumber.text='';
      errorSerial = false;
    });
  }

  Widget buildStampBtn() {
    return Column(children: [
      Container(
          height: 48,
          width: 400,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(50),
              color: Color(0xFF4f2565)),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Color(0xFF4f2565),
              textStyle: TextStyle(fontSize: 16),
              minimumSize: Size.fromHeight(30),
              shape: StadiumBorder(),
            ),
            child:  Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? "Next"
                        : "التالي",
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            onPressed:() async {
              print("/////nationality");
              print(nationality);
              print("/////nationality");
              if (isJordanian == true) {
                if (img64Front == null) {
                  setState(() {
                    imageIDFrontRequired = true;
                  });
                }
                if (img64Front != null) {
                  setState(() {
                    imageIDFrontRequired = false;
                  });
                }

                if (img64Back == null) {
                  setState(() {
                    imageIDBackRequired = true;
                  });
                }
                if (img64Back != null) {
                  setState(() {
                    imageIDBackRequired = false;
                  });
                }
              }

              if (isNonJordanian == true) {
                if (img64Passport == null) {
                  setState(() {
                    imagePassportRequired = true;
                  });
                }
                if (img64Passport != null) {
                  setState(() {
                    imagePassportRequired = false;
                  });
                }
              }

              if (msisdn.text == '') {
                setState(() {
                  emptyMSISDN = true;
                });
              }
              if (serialNumber.text == '') {
                setState(() {
                  emptySerial = true;
                });
              }
              if (documentExpiryDate.text == '') {
                setState(() {
                  emptyDocumentExpiryDate = true;
                });
              }
              if (documentExpiryDate.text != '') {
                setState(() {
                  emptyDocumentExpiryDate = false;
                });
              }

              if (msisdn.text != '') {
                setState(() {
                  emptyMSISDN = false;
                });
              }


              if(nationality==false){
                if(msisdn.text.length != 0  && serialNumber.text.length != 0 && documentExpiryDate.text !='' && img64Passport != null){
                  setState(() {
                    isLooding=true;
                    errorMSISDN=false;
                    emptyMSISDN=false;
                    emptySerial=false;

                    imageIDFrontRequired=false;
                    imageIDBackRequired=false;
                    imagePassportRequired=false;
                  });
                  //8Dec 2024 stampAPI();
                  get_contract();
                }
              }

              if(nationality==true){
                if(msisdn.text.length != 0  && serialNumber.text.length != 0 && documentExpiryDate.text !=''   && img64Front != null && img64Back != null){
                  setState(() {
                    isLooding=true;
                    errorMSISDN=false;
                    emptyMSISDN=false;
                    emptySerial=false;

                    imageIDFrontRequired=false;
                    imageIDBackRequired=false;
                    imagePassportRequired=false;
                  });
                  //8Dec 2024 stampAPI();
                  get_contract();
                }
              }


            }




          )),
    ]);
  }



  /********************************************** APIS  **********************************************/

  get_contract() async{
    setState(() {
      isLoading=true;
    });
    print("-------------------------------------------Haya hazaimeh----------------------------------------");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Postpaid/device/stamp/generate';

    final Uri url = Uri.parse(apiArea);

    print(url);
    Map body = {
      "msisdn": msisdn.text,
      "serialNumber": serialNumber.text,
      "reSellerID":selectedReseller_key,
      "signatureImageBase64": ""

    };
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body: json.encode(body),);
    int statusCode = response.statusCode;
    print(statusCode);

    print(json.encode(body));
    if (statusCode == 500) {
      setState(() {
        isLoading=false;
      });

    }
    if(statusCode==401 ){
      print('401  error ');
      setState(() {
        isLoading=false;
      });
      showAlertDialog(
          context, statusCode.toString(),statusCode.toString());
    }
    if (statusCode == 200) {

      setState(() {
        isLoading=false;
      });

      var result = json.decode(response.body);

      print(result["data"]);
      print(result);


      if( result["status"]==0){
        /*...................................For Contract File...................................*/
        var dir = await getApplicationDocumentsDirectory();
        fileContract = new File("${dir.path}/data.pdf");
        // fileContract.writeAsBytesSync(state.filePath['result'].bodyBytes, flush: true);
        Uint8List decodedbytes = base64.decode(result["data"]["contractBase64"]);
        Uint8List decodedbytes1 = base64Decode(result["data"]["contractBase64"]);
        //fileContract.writeAsBytesSync(bytes, flush: true);
        fileContract.writeAsBytesSync(decodedbytes1, flush: true);

        setState(() {
          localPath = fileContract.path;
        });

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => getContract(
                Permessions: Permessions,
                outDoorUserName:outDoorUserName,
                msisdn:msisdn.text,
                serialNumber:serialNumber.text,
                selectedResellerkey:selectedReseller_key,
                localPath: fileContract.path,
                isJordanian: nationality,
                frontIdImageBase64: img64Front,
                backIdImageBase64: img64Back,
                passportImageBase64: img64Passport,
                documentExpiryDate: documentExpiryDate.text
            ),
          ),
        );

      }else{

        setState(() {
          isLoading=false;
        });

        showAlertDialog(
            context, result["message"],result["messageAr"]);
      }





    }
    else{
      showAlertDialog(
          context, statusCode.toString(),statusCode.toString());
      setState(() {
        isLoading=false;
      });
    }
  }

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.cancel".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        Navigator.pop(context);
        setState(() {
          isLoading=false;
        });


      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage
            : arabicMessage,
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        tryAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

 /* void stampAPI() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Postpaid/device/stamp';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    Map body = {
      "msisdn":msisdn.text,
      "serialNumber":serialNumber.text,
      "reSellerID":selectedReseller_key

    };
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(json.encode(body));
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if( result["status"]==0){
        setState(() {
          isLooding =false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));

        setState(() {
          isLooding =false;
        });

      }




      return result;
    }else{
      //   showAlertDialogOtherERROR(context,statusCode, statusCode);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));
    }
  }*/
  /******************************************** End APIS ********************************************/


  _ScanKitCode() async{
    await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE).then((value)=>setState(()=>_dataKitCode=value));
    setState(() {
      serialNumber.text = _dataKitCode;
    });
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
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Stack(
          children: [
            Scaffold(
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
                      ? 'Stamp Device'
                      : "ختم الجهاز",
                ),
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body: Center(
                child: ListView(
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 0, bottom: 90, left: 0, right: 0),
                  children: <Widget>[
                    Column(
                      children: [

                      Container(
                        padding:  EdgeInsets.symmetric(horizontal: 0), // Adds left & right margin

                        color: Colors.white,
                        child: Column(
                          children:<Widget>[
                            SizedBox(height: 25),
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 16), // Left & right margin
                           child:  Row(
                             children: [
                               Expanded(
                                 child: ElevatedButton(
                                   onPressed: () async {
                                     if (!isJordanian) {
                                       setState(() {
                                         isJordanian = true;
                                         isNonJordanian = false;
                                         nationality=true;
                                         emptyDocumentExpiryDate=false;
                                         imageIDFrontRequired=false;
                                         imageIDBackRequired=false;
                                         imagePassportRequired=false;
                                         documentExpiryDate.text="";
                                         serialNumber.text="";
                                          msisdn.text="";
                                         img64Front=null;
                                         pickedFileFrontId=null;
                                         img64Back=null;
                                         pickedFileBackId=null;
                                          img64Passport=null;
                                         pickedFilePassport=null;
                                         imageFileFrontID=null;
                                         imageFileBackID=null;
                                         imageFilePassport=null;
                                         _loadPassport= false;
                                          _loadIdFront= false;
                                          _loadIdBack= false;


                                       });
                                     }
                                   },
                                   style: ElevatedButton.styleFrom(
                                     backgroundColor: isJordanian ? Color(0xFF4f2565) : Colors.white,
                                     shadowColor: Colors.white,
                                     minimumSize: Size(double.infinity, 50), // Set button height
                                     side: BorderSide(color: Color(0xFF4f2565), width: 1), // Add border
                                   ),
                                   child: Text("Jordanian",style: TextStyle(
                                     color: isNonJordanian ?  Color(0xFF4f2565) : Colors.white,
                                   ),),
                                 ),
                               ),
                               SizedBox(width: 10), // Space between buttons
                               Expanded(
                                 child: ElevatedButton(
                                   onPressed: () async {
                                     if (!isNonJordanian) {
                                       setState(() {
                                         isJordanian = false;
                                         isNonJordanian = true;
                                         nationality=false;
                                         errorMSISDN=false;
                                         emptyMSISDN=false;
                                         emptySerial=false;
                                         emptyDocumentExpiryDate=false;
                                         imageIDFrontRequired=false;
                                         imageIDBackRequired=false;
                                         imagePassportRequired=false;
                                         documentExpiryDate.text="";
                                         serialNumber.text="";
                                         msisdn.text="";
                                         img64Front=null;
                                         pickedFileFrontId=null;
                                         img64Back=null;
                                         pickedFileBackId=null;
                                         img64Passport=null;
                                         pickedFilePassport=null;

                                         imageFileFrontID=null;
                                          imageFileBackID=null;
                                          imageFilePassport=null;

                                         _loadPassport= false;
                                         _loadIdFront= false;
                                         _loadIdBack= false;
                                       });
                                     }
                                   },
                                   style: ElevatedButton.styleFrom(
                                     backgroundColor: isNonJordanian ? Color(0xFF4f2565) : Colors.white,
                                     minimumSize: Size(double.infinity, 50), // Set button height
                                     side: BorderSide(color: Color(0xFF4f2565), width: 1), // Add border
                                   ),
                                   child: Text("Non Jordanian",style: TextStyle(
                                     color: isNonJordanian ?  Colors.white:Color(0xFF4f2565),
                                   ),),
                                 ),
                               ),
                             ],
                           ),),
                            SizedBox(height: 25),
                            Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16), // Left & right margin
                                child:buildDocumentExpiryDate()),
                            SizedBox(height: 20),
                   isJordanian ?     Container(
                              color:Color(0xFFEBECF1) ,
                              height: 60,
                              child: ListTile(
                                leading: Container(
                                  width: 280,
                                  child: Text(
                                    "Jordan_Nationality.id_photo".tr().toString() +
                                        " " +
                                        "Postpaid.frontـside".tr().toString(),
                                    style: TextStyle(
                                      color: Color(0xFF11120e),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                trailing: _loadIdFront == true
                                    ? Container(
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Color(0xff0070c9),
                                      onPressed: () => {clearImageIDFront()}),
                                )
                                    : null,
                              ),
                            ):Container(),
                            isJordanian ?     Container(child: buildImageIdFront()):Container(),
                            isJordanian ?  Container(
                              height: 60,
                              color: Color(0xFFEBECF1),
                              padding: EdgeInsets.only(top: 8),
                              child: ListTile(
                                leading: Container(
                                  width: 280,
                                  child: Text(
                                    "Jordan_Nationality.id_photo".tr().toString() +
                                        " " +
                                        "Postpaid.backـside".tr().toString(),
                                    style: TextStyle(
                                      color: Color(0xFF11120e),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                trailing: _loadIdBack == true
                                    ? Container(
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Color(0xff0070c9),
                                      onPressed: () => {clearImageIDBack()}),
                                )
                                    : null,
                              ),
                            ):Container(),
                            isJordanian ?  Container(
                              child: buildImageIdBack(),
                            ):Container(),


                    isNonJordanian  ?   Container(
                              height: 60,
                              color: Color(0xFFEBECF1),
                              padding: EdgeInsets.only(top: 8),
                              child: ListTile(
                                leading: Container(
                                  width: 280,
                                  child: Text(
                                    EasyLocalization.of(context).locale == Locale("en", "US")
                                    ?"Passport Photo":"صورة الجواز",
                                    style: TextStyle(
                                      color: Color(0xFF11120e),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ),
                                trailing: _loadPassport == true
                                    ? Container(
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Color(0xff0070c9),
                                      onPressed: () => {clearImagePassport()}),
                                )
                                    : null,
                              ),
                            ):Container(),
            isNonJordanian?  Container(
                              child: buildImagePassport(),
                            ):Container(),

                            SizedBox(height: 20),
                          ]
                        ),
                      ),
                        SizedBox(height: 50),

                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                child: Column(
                                  children: <Widget>[
                                    Image(
                                      image: AssetImage('assets/images/barcode-scan.png'),
                                      width: 160,
                                      height: 160,
                                    ),
                                    TextButton(
                                      child: Text(
                                        "Menu_Form.ScanBarcode".tr().toString(),
                                        style: TextStyle(
                                            color: Colors.black,
                                            letterSpacing: 0,
                                            fontSize: 21,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                height: 48,
                                width: 420,
                                margin: EdgeInsets.symmetric(horizontal: 10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xFF4f2565),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Color(0xFF4f2565),
                                    shape: const BeveledRectangleBorder(
                                        borderRadius: BorderRadius.all(Radius.circular(24))),
                                  ),
                                  onPressed: () => _ScanKitCode(),
                                  child: Text(
                                    "Menu_Form.StartScan".tr().toString(),
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          height: 55,
                          width: 420,
                          margin: const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),
                                ),
                              ),
                              Text("Menu_Form.OR".tr().toString()),
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 36,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(left: 15, right: 15, top: 10),
                          child: Column(
                            children: <Widget>[
                              Container(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(height: 10),
                                    enterSerialNumber(),
                                    emptySerial == true
                                        ? RequiredFeild(
                                        text: EasyLocalization.of(context).locale ==
                                            Locale("en", "US")
                                            ? 'This field is required'
                                            : "هذا الحقل مطلوب")
                                        : Container(),
                                    SizedBox(height: 20),
                                    enterMSISDN(),
                                    emptyMSISDN == true
                                        ? RequiredFeild(
                                        text: EasyLocalization.of(context).locale ==
                                            Locale("en", "US")
                                            ? 'This field is required'
                                            : "هذا الحقل مطلوب")
                                        : Container(),
                                    errorMSISDN == true
                                        ? RequiredFeild(
                                        text: EasyLocalization.of(context).locale ==
                                            Locale("en", "US")
                                            ? "Your MSISID should be 10 digits"
                                            : "رقم الهاتف يجب أن يتكون من 10 أرقام")
                                        : Container(),
                                    SizedBox(height: 20),
                                    Permessions.contains('05.10.01')
                                        ? buildSelect_Reseller()
                                        : Container(),
                                  ],
                                ),
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: buildStampBtn(),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isLoading, // This should be a boolean indicating loading state
              child: Container(
                color: Colors.black.withOpacity(0.5),
                width: double.infinity,
                height: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF392156),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}
