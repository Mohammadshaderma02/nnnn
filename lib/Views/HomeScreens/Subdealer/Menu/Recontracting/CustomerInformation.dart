import 'dart:async';
import 'dart:convert';
//import 'dart:html';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/Eshope_Menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:signature/signature.dart';
import '../../../../../Shared/BaseUrl.dart';
import '../../../../ReusableComponents/requiredText.dart';
import 'dart:typed_data';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';

import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:photo_view/photo_view.dart';

import 'dart:io';
import 'dart:io' as Io;
import 'dart:ui' as ui;

import '../../CustomBottomNavigationBar.dart';
APP_URLS urls = new APP_URLS();
class CustomerInformation extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var msisdn;
  var recontractingKey;
  var optionId;
  var optionName;
  var orderId;
   CustomerInformation( this.Permessions, this.role, this.outDoorUserName,this.msisdn,this.recontractingKey,this.optionId,this.optionName,this.orderId);

  @override
  State<CustomerInformation> createState() => _CustomerInformationState( this.Permessions, this.role, this.outDoorUserName,this.msisdn,this.recontractingKey,this.optionId,this.optionName,this.orderId);
}

class _CustomerInformationState extends State<CustomerInformation> {
  _CustomerInformationState(this.Permessions, this.role, this.outDoorUserName,this.msisdn,this.recontractingKey,this.optionId,this.optionName,this.orderId);

  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var msisdn;
  var recontractingKey;
  var optionId;
  var optionName;
  var orderId;
  bool Jordanian=true;
  bool non_Jordanian=false;
  bool isJordanian =true;
  var imgBytes;
  String signatureImageBase64;
  final _picker = ImagePicker();
  bool _loadImageBack = false;
  bool _loadImageFront = false;
  bool imageRequiredBack = false;
  bool imageRequiredFront = false;

  File imageFileBack;
  var pickedFileBack;
  File imageFileFront;
  var pickedFileFront;

  int imageWidth = 200;
  int imageHeight = 200;

  String img64Back;
  String img64Front;

  bool add_signature = false;
  bool save_signature=false;
  bool Reontracting_Submit= false;

  bool checkResponce=false;


  final SignatureController _controller = SignatureController(
    penStrokeWidth: 3,
    penColor: Color(0xFF4f2565),
    exportBackgroundColor: Colors.white,
  );

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  Widget selectNationality(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Color(0xFFEBECF1),
          margin:EdgeInsets.only(left: 15,right: 15,bottom: 10) ,
          child:   RichText(
            text: TextSpan(
              text: "reContract.select_Nationality".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
        ),
        Container(
            color: Colors.white,
            // alignment: Alignment.centerLeft,
            height: 60,
            child:
            Row(
              children: [
                Expanded(
                  child: Align(
                    alignment:EasyLocalization.of(context).locale == Locale("en", "US")?
                    Alignment.centerLeft:Alignment.centerRight,
                    child: Container(
                      color: Colors.white,
                      child:        ElevatedButton.icon(
                        // <-- ElevatedButton
                        onPressed: () {  if (Jordanian == true) {
                          setState(() {
                            Jordanian = false;
                            non_Jordanian = true;
                            isJordanian=Jordanian;
                            img64Front=null;
                            img64Back=null;
                            _loadImageBack = false;
                            pickedFileBack = null;
                            _loadImageFront = false;
                            pickedFileFront = null;
                            signatureImageBase64 =null;
                            _controller.clear();
                            //for non-jordanian
                          });
                          print("isJordanian");
                          print(Jordanian);

                        }
                        },
                        style: non_Jordanian == true
                            ? ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Color(0xFF4f2565),

                          shadowColor: Colors.transparent,
                        )
                            : ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black87,

                          shadowColor: Colors.transparent,
                        ),
                        icon: non_Jordanian == true
                            ? Icon(
                          Icons.check_circle,
                          size: 24.0,
                        )
                            : Icon(
                          Icons.circle_outlined,
                          size: 24.0,
                        ),
                        label: Text("reContract.non_jordanian".tr().toString(),style:TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment:EasyLocalization.of(context).locale == Locale("en", "US")?
                    Alignment.centerLeft:Alignment.centerRight,
                    child: Container(
                      color: Colors.white,
                      child:        ElevatedButton.icon(
                        // <-- ElevatedButton
                        onPressed: () {  if (non_Jordanian == true) {
                          setState(() {
                            non_Jordanian = false;
                            Jordanian = true;
                            isJordanian=non_Jordanian;//for jordanian
                            img64Front=null;
                            img64Back=null;
                            _loadImageBack = false;
                            pickedFileBack = null;
                            _loadImageFront = false;
                            pickedFileFront = null;
                            signatureImageBase64 =null;
                            _controller.clear();

                          });
                          print(Jordanian);
                          print(non_Jordanian);
                        }
                        },
                        style: Jordanian == true
                            ? ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Color(0xFF4f2565),

                          shadowColor: Colors.transparent,
                        )
                            : ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black87,

                          shadowColor: Colors.transparent,
                        ),
                        icon: Jordanian == true
                            ? Icon(
                          Icons.check_circle,
                          size: 24.0,
                        )
                            : Icon(
                          Icons.circle_outlined,
                          size: 24.0,
                        ),
                        label: Text("reContract.jordanian".tr().toString(),style:TextStyle(
                            fontSize: 16,
                            color: Colors.black87,
                            fontWeight: FontWeight.normal)),
                      ),
                    ),
                  ),
                ),


              ],
            )),
        SizedBox(height: 10),

      ],
    );




  }

  Widget signature(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          color: Color(0xFFEBECF1),
          margin:EdgeInsets.only(left: 15,right: 15,bottom: 10) ,
          child:   RichText(
            text: TextSpan(
              text: "reContract.signature".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 16,
                fontWeight: FontWeight.bold,
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
        ),
        SizedBox(height: 10),
        Container(
          color: Colors.white,
          padding: EdgeInsets.only(left: 40,right: 40,top: 30,bottom: 10),
          child: buildDashedBorder(
                      child:AbsorbPointer(
                        absorbing: save_signature, // Set to true to disable user input, false to enable
                        child: Signature(
                          controller: _controller,
                          height: MediaQuery.of(context).size.height / 2 * 1.00,
                          backgroundColor: Colors.transparent,
                        ),
                      )
                )
        ),
        Container(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                mainAxisSize: MainAxisSize.max,
                children: <Widget>[
                  //SHOW EXPORTED IMAGE IN NEW ROUTE
                  IgnorePointer(
                    ignoring: save_signature, // Replace 'condition' with your actual condition
                    child: IconButton(
                      icon: Icon(Icons.check),
                      color: save_signature ==true?Colors.black12:Color(0xFF4f2565),
                      onPressed: () async {
                        if (_controller.isNotEmpty) {
                          var data = await _controller.toPngBytes();
                          final imageEncoded = base64.encode(data);
                          setState(() {
                            save_signature=true;
                            imgBytes = data;
                            signatureImageBase64 = imageEncoded;
                            add_signature=false;
                          });
                          print(signatureImageBase64);
                        }
                      },
                    ),
                  ),
                  //CLEAR CANVAS
                  IconButton(
                    icon: const Icon(Icons.clear),
                    color: Color(0xFF4f2565),
                    onPressed: () {
                      setState(() =>
                          _controller.clear(),

                      );
                      setState(() {
                        signatureImageBase64 =null;
                        save_signature=false;
                        add_signature=false;
                      });
                    },
                  ),

                ],
              ),
              add_signature == true
                  ? ReusableRequiredText(
                  text: "Postpaid.this_feild_is_required".tr().toString())
                  : Container(),
              add_signature == true? SizedBox(height: 10):Container(),

            ],
          ),
        ),


      ],
    );
  }
  /*.............................................................................................................................................*/
  /*...............................................Functions for pick Image "Back" from Gallery and Camera.........................................*/
  void pickImageCameraBack() async {
    pickedFileBack = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFileBack != null) {
      imageFileBack = File(pickedFileBack.path);
      _loadImageBack = true;
      var imageName = pickedFileBack.path.split('/').last;

      calculateImageSize(pickedFileBack.path);


      if (pickedFileBack != null) {
        _cropImageBack(File(pickedFileBack.path));
      }
    }
  }

  void pickImageGalleryBack() async {
    pickedFileBack = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileBack != null) {
      imageFileBack = File(pickedFileBack.path);
      _loadImageBack = true;
      var imageName = pickedFileBack.path.split('/').last;
      print(pickedFileBack);

      print(pickedFileBack.path);
      final bytes =
          File(pickedFileBack.path).readAsBytesSync().lengthInBytes;

      calculateImageSize(pickedFileBack.path);
      if (pickedFileBack != null) {
        _cropImageBack(File(pickedFileBack.path));
      }
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
            _loadImageBack = false;
            pickedFileBack = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Back = base64Encode(base64Image);
          print('img64Crop: ${img64Back}');
          imageFileBack = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadImageBack = false;
        pickedFileBack = null;
      });
    }
  }

  void clearImageBack() {
    this.setState(() {
      _loadImageBack = false;
      pickedFileBack = null;

      ///here
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
                    onTap: () async {
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

  Widget buildImageBack() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      color: Colors.white,
      height: 350,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                padding: EdgeInsets.only(left: 10, right: 5),
                child: _loadImageBack == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 180,
                          height: 235,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(imageFileBack),
                                fit: BoxFit.cover,
                              )),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: new Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Container(
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
                                            FocusScope.of(context)
                                                .unfocus();
                                            showDialog(
                                                context: context,
                                                builder: (_) => Center(
                                                  // Aligns the container to center
                                                    child: Container(
                                                      child: PhotoView(
                                                        enableRotation:
                                                        true,
                                                        backgroundDecoration:
                                                        BoxDecoration(
                                                            color: Colors
                                                                .transparent),
                                                        imageProvider:
                                                        FileImage(
                                                            imageFileBack),
                                                      ),
                                                      // A simplified version of dialog.
                                                      width: 310.0,
                                                      height: 500.0,
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
                                                fontWeight:
                                                FontWeight.w600,
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
                    : buildDashedBorder(
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _showPickerBack(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
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
                                )
                              ],
                            )
                                : Text(
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )
              //SizedBox(width: 10),
            ],
          ),
          imageRequiredBack == true?SizedBox(height: 20):Container(),
          imageRequiredBack == true
              ? ReusableRequiredText(
              text: "Postpaid.this_feild_is_required".tr().toString())
              : Container(),
        ]),
      ),
    );
  }


  /*.............................................................................................................................................*/
  /*...............................................Functions for pick Image "Front" from Gallery and Camera.........................................*/
  void pickImageCameraFront() async {
    pickedFileFront = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFileFront != null) {
      imageFileFront = File(pickedFileFront.path);
      _loadImageFront = true;
      var imageName = pickedFileFront.path.split('/').last;

      calculateImageSize(pickedFileFront.path);


      if (pickedFileFront != null) {
        _cropImageFront(File(pickedFileFront.path));
      }
    }
  }

  void pickImageGalleryFront() async {
    pickedFileFront = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileFront != null) {
      imageFileFront = File(pickedFileFront.path);
      _loadImageFront = true;
      var imageName = pickedFileFront.path.split('/').last;
      print(pickedFileFront);

      print(pickedFileFront.path);
      final bytes =
          File(pickedFileFront.path).readAsBytesSync().lengthInBytes;

      calculateImageSize(pickedFileFront.path);
      if (pickedFileFront != null) {
        _cropImageFront(File(pickedFileFront.path));
      }
    }
  }

  _cropImageFront(Io.File picture) async {
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
            _loadImageFront = false;
            pickedFileFront = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Front = base64Encode(base64Image);
          print('img64Crop: ${img64Front}');
          imageFileFront = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadImageFront = false;
        pickedFileFront = null;
      });
    }
  }

  void clearImageFront() {
    this.setState(() {
      _loadImageFront = false;
      pickedFileFront = null;

      ///here
    });
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
                    onTap: () async {
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

  Widget buildImageFront() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      color: Colors.white,
      height: 350,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.all(10),
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children:
        <
            Widget>[
          new Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                // color: Colors.amber,
                padding: EdgeInsets.only(left: 10, right: 5),
                child: _loadImageFront == true
                    ? Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 180,
                          height: 235,
                          decoration: BoxDecoration(
                              color: Colors.black,
                              image: DecorationImage(
                                colorFilter: new ColorFilter.mode(
                                    Colors.black.withOpacity(0.5),
                                    BlendMode.dstATop),
                                image: FileImage(imageFileFront),
                                fit: BoxFit.cover,
                              )),
                          child: new Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Center(
                                  child: new Column(
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: <Widget>[
                                      new Container(
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
                                            FocusScope.of(context)
                                                .unfocus();
                                            showDialog(
                                                context: context,
                                                builder: (_) => Center(
                                                  // Aligns the container to center
                                                    child: Container(
                                                      child: PhotoView(
                                                        enableRotation:
                                                        true,
                                                        backgroundDecoration:
                                                        BoxDecoration(
                                                            color: Colors
                                                                .transparent),
                                                        imageProvider:
                                                        FileImage(
                                                            imageFileFront),
                                                      ),
                                                      // A simplified version of dialog.
                                                      width: 310.0,
                                                      height: 500.0,
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
                                                fontWeight:
                                                FontWeight.w600,
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
                    : buildDashedBorder(
                  child: InkWell(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      _showPickerFront(context);
                    },
                    child: Container(
                      width: 180,
                      height: 235,
                      child: GestureDetector(
                        child: Align(
                          alignment: Alignment.center,
                          child: Align(
                            alignment: Alignment.center,
                            child: EasyLocalization.of(context).locale ==
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
                                )
                              ],
                            )
                                : Text(
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
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              )

            ],
          ),
          imageRequiredFront == true?SizedBox(height: 20):Container(),
          imageRequiredFront == true
              ? ReusableRequiredText(
              text: "Postpaid.this_feild_is_required".tr().toString())
              : Container(),
        ]),
      ),
    );
  }

  /*.............................................................................................................................................*/
  Widget buildDashedBorder({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

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
            imageHeight = (size.height ~/ ratio).toInt();
            imageWidth = (size.width ~/ ratio).toInt();
          });
          print('ratio ${ratio}');
        },
      ),
    );
  }

  ReontractingSubmit_API() async {
    setState(() {
      Reontracting_Submit=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/recontracting/submit';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn,
      "recontractingType":recontractingKey,
      "optionId": this.optionId,
      "optionName": this.optionName,
      "isJordanian": isJordanian,
      "frontIdImageBase64": isJordanian==true?img64Front:"",
      "backIdImageBase64": isJordanian==true?img64Back:"",
      "passportImageBase64": isJordanian==false?img64Front:"",
      "backPassportImageBase64": isJordanian==false?img64Back:"",
      "signatureImageBase64": signatureImageBase64,
      "eshopOrderID": this.orderId



    };
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),

    );
    print(body);

    int statusCode = response.statusCode;
    var data = response.request;
    print("*******************************************************************");
    print(statusCode);
    print(response);
    print('body: [${response.body}]');
    print("*******************************************************************");


    if (statusCode == 401) {
      setState(() {
        Reontracting_Submit=false;
      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print("................................................................");
      print(result);
      print("................................................................");

      if(result["status"]== 0 ){

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));

        setState(() {
          Reontracting_Submit=false;
        });

        if (prefs.getString('role') == 'DeliveryEShop'){

          showAlertDialogSuccessDelivaryEshop(
              context, " اكتملت العملية بنجاح ، سيتم إرسال نسخة من العقد إلى الرقم المرجعي الخاص بك",
              "The operation has been successfully completed, a copy of the contract will sent to your reference number");
        }

        if(prefs.getString('role') != 'DeliveryEShop'){

          showAlertDialogSuccess(
              context, " اكتملت العملية بنجاح ، سيتم إرسال نسخة من العقد إلى الرقم المرجعي الخاص بك",
              "The operation has been successfully completed, a copy of the contract will sent to your reference number");
        }


      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          Reontracting_Submit=false;
        });
      }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        Reontracting_Submit=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  showAlertDialogSuccess(BuildContext context, arabicMessage, englishMessage) {
    Widget close = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();




        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
          ),
        );
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
        close,

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

  showAlertDialogSuccessDelivaryEshop(BuildContext context, arabicMessage, englishMessage) {
    Widget close = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () async {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>Eshope_Menu()
          ),
        );
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
        close,

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



  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                //tooltip: 'Menu Icon',
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              centerTitle:false,
              title: Text(
                "reContract.CustomerInformation".tr().toString(),
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body:Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            selectNationality(),
                            Container(
                              height: 60,
                              padding: EdgeInsets.only(top: 8),
                              child: ListTile(
                                leading: Container(
                                  width: 280,
                                  child: RichText(
                                    text: TextSpan(
                                      text:  Jordanian==true? "reContract.photoIDFront".tr().toString():"Postpaid.passport_photo_front".tr().toString(),
                                      style: TextStyle(
                                        color: Color(0xff11120e),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
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
                                ),
                                trailing: _loadImageFront == true
                                    ? Container(
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Color(0xff0070c9),
                                      onPressed: () => {clearImageFront()}),
                                )
                                    : null,
                              ),
                            ),
                            Container(child: buildImageFront()),
                            Container(
                              height: 60,
                              padding: EdgeInsets.only(top: 8),
                              child: ListTile(
                                leading: Container(
                                  width: 280,
                                  child:  RichText(
                                    text: TextSpan(
                                      text:  Jordanian==true?"reContract.photoIDBack".tr().toString() :"Postpaid.passport_photo_back".tr().toString(),
                                      style: TextStyle(
                                        color: Color(0xff11120e),
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: ' * ',
                                          style: TextStyle(
                                            color:Jordanian==true? Color(0xFFB10000):Colors.white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                trailing: _loadImageBack == true
                                    ? Container(
                                  child: IconButton(
                                      icon: Icon(Icons.delete),
                                      color: Color(0xff0070c9),
                                      onPressed: () => {clearImageBack()}),
                                )
                                    : null,
                              ),
                            ),
                            Container(child: buildImageBack()),
                            SizedBox(height: 20),
                            signature(),
                            SizedBox(height: 20),

                            SizedBox(height: 5),
                          ],
                        ),
                      ),

                      Container(
                          height: 48,
                          width: 300,
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50),
                            color: Color(0xFF4f2565),
                          ),
                          child: TextButton(
                            onPressed:  () async {
                              /*........................................Check Signature.......................................*/
                              if(signatureImageBase64==null){
                                setState(() {
                                  add_signature=true;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        EasyLocalization.of(context).locale == Locale("en", "US")
                                            ?"Please save your signature"
                                            : "الرجاء حفظ التوقيع")));
                              }
                              if(signatureImageBase64!=null){
                                setState(() {
                                  add_signature=false;
                                });
                              }
                              /*........................................Check Photo Front.......................................*/
                              if(img64Front==null){
                                setState(() {
                                  imageRequiredFront=true;
                                });
                              }
                              if(img64Front!=null){
                                setState(() {
                                  imageRequiredFront=false;
                                });
                              }
                              /*........................................Check Photo Back.......................................*/
                              if(Jordanian==true){
                                if(img64Back==null){
                                  setState(() {
                                    imageRequiredBack=true;
                                  });
                                }
                                if(img64Back!=null){
                                  setState(() {
                                    imageRequiredBack=false;
                                  });
                                }
                              }

                              /*........................................Check To Submit.......................................*/
                              if(Jordanian==true){
                                if(signatureImageBase64 != null && img64Front != null && img64Back != null){
                                  setState(() {
                                    Reontracting_Submit= true;
                                  });
                                  ReontractingSubmit_API();

                                }
                              }
                              if(Jordanian!=true){
                                if(signatureImageBase64 != null && img64Front != null ){
                                  setState(() {
                                    Reontracting_Submit= true;
                                  });
                                  ReontractingSubmit_API();

                                }
                              }



                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Color(0xFF4f2565),
                              shape: const BeveledRectangleBorder(
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(24))),
                            ),
                            child: Text(
                              "reContract.Save".tr().toString(),
                              style: TextStyle(
                                  color: Colors.white,
                                  letterSpacing: 0,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          )),

                      SizedBox(height: 20)

                    ],
                  )
                ),




                // Transparent overlay
                Visibility(
                  visible: Reontracting_Submit, // Adjust the condition based on when you want to show the overlay
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
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
            )


        ));
  }
}
