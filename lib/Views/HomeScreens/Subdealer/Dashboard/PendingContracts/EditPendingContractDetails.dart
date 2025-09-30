import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/PendingContracts/PendingContracts.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';

import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'dart:io' as Io;
import 'dart:convert';

import 'package:sales_app/blocs/UploadImage/UploadImage_events.dart';
import 'package:sales_app/blocs/UploadImage/UploadImage_bloc.dart';
import 'package:sales_app/blocs/UploadImage/UploadImage_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:sales_app/blocs/ReservedLine/ReservedLine_bloc.dart';
import 'package:sales_app/blocs/ReservedLine/ReservedLine_state.dart';
import 'package:sales_app/blocs/ReservedLine/ReservedLine_events.dart';

import 'package:sales_app/blocs/UnReservedLine/UnReservedLine_bloc.dart';
import 'package:sales_app/blocs/UnReservedLine/UnReservedLine_state.dart';
import 'package:sales_app/blocs/UnReservedLine/UnReservedLine_events.dart';

import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditContractDetails extends StatefulWidget {
  Map data = new Map();
  var Permessions=[];
  var role;
  var outDoorUserName;
  EditContractDetails({this.data,this.Permessions,this.role,this.outDoorUserName});
  @override
  _EditContractDetailsState createState() =>
      _EditContractDetailsState(this.data,this.Permessions,this.role,this.outDoorUserName);
}

class _EditContractDetailsState extends State<EditContractDetails> {
  Map data = new Map();
  var Permessions=[];
  var role;
  var outDoorUserName;
  _EditContractDetailsState(this.data,this.Permessions,this.role,this.outDoorUserName);
  Map ReservedLinedata = new Map();

  UploadImageBloc uploadimageBloc; //new
  ReservedLineBloc reservedLineBloc; // nwe
  UnReservedLineBloc unReservedLineBloc; //new

  bool imageIDRequired = false;
  bool imageContractRequired = false;
  var entryDate ;


  @override
  void initState() {
    uploadimageBloc = BlocProvider.of<UploadImageBloc>(context); //New
    reservedLineBloc = BlocProvider.of<ReservedLineBloc>(context); //New
    unReservedLineBloc = BlocProvider.of<UnReservedLineBloc>(context); //New
    //unReservedLineBloc.add(UnPressReservedLineEvent(kitCode:data['kitCode'].toString()));

    entryDate = data['entryDate'].toString().split('T');
    print(entryDate);
    print(data);
    super.initState();
  }


  String img64;
  String img64Contract;
  final _picker = ImagePicker();

  File imageFileID ;
  bool _loadId = false;
  var pickedFileId;


  File imageFileContract ;
  bool _loadContract = false;
  var pickedFileContract;


  int imageWidth=200;
  int imageHeight=200;


  void calculateImageSize (String path){
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
          double ratio=0;
          if(size.height>size.width){
            ratio= (size.height / 1024);
          }else{
            ratio= (size.width / 1024);
          }


          setState(() {
            imageHeight= (size.height /ratio).toInt()  ;
            imageWidth=(size.width/ ratio).toInt() ;
          });
          print('ratio ${ratio}');
        },
      ),
    );
  }

  void pickImageCamera() async {
    pickedFileId = await _picker.pickImage(source: ImageSource.camera,
    );

    if(pickedFileId!=null){
    imageFileID = File(pickedFileId.path);
    _loadId = true;
    var imageName = pickedFileId.path
        .split('/')
        .last;
    print(pickedFileId);

    print(pickedFileId.path);
    final bytes = File(pickedFileId.path)
        .readAsBytesSync()
        .lengthInBytes;
        calculateImageSize(pickedFileId.path);
        if (pickedFileId != null) {
          _cropImage(File(pickedFileId.path));
        }

  }
  }
  void pickImageGallery() async {
    pickedFileId = await _picker.pickImage(source: ImageSource.gallery,

    );


    if(pickedFileId!=null) {
      imageFileID = File(pickedFileId.path);
      _loadId = true;
      var imageName = pickedFileId.path
          .split('/')
          .last;
      print(pickedFileId);

      print(pickedFileId.path);
      final bytes = File(pickedFileId.path)
          .readAsBytesSync()
          .lengthInBytes;
          calculateImageSize(pickedFileId.path);
          if (pickedFileId != null) {
            _cropImage(File(pickedFileId.path));
          }
        }


  }

  _cropImage(File picture) async {
  CroppedFile cropped = await ImageCropper().cropImage(
        sourcePath: picture.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],
        compressQuality: 100,
        compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight);
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
            _loadId=false;
            pickedFileId=null;

          });
        }
        else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64 = base64Encode(base64Image);
          print('img64Crop: ${img64}');
          imageFileID= File(cropped.path);
        }
      });

    }
    else{
      this.setState(() {

        _loadId=false;
        pickedFileId=null;

        ///here
      });

    }
  }
  void clearImageID() {
    /* this.setState(()=>
    imageFileID = null );*/


    this.setState(() {

      _loadId=false;
      pickedFileId=null;

      ///here
    });
  }
  /////////////End ImageID Functions/////////////
  //** Pick & Crop & Clear --> "ImageContract"  Camera/Gallery  **//


  void pickImageContractCamera() async {

    pickedFileContract = await _picker.pickImage(source: ImageSource.camera,

    );

    if(pickedFileContract!=null) {
      imageFileContract = File(pickedFileContract.path);
      _loadContract = true;
      var imageName = pickedFileContract.path
          .split('/')
          .last;
      print(pickedFileContract);

      print(pickedFileContract.path);
      final bytes = File(pickedFileContract.path)
          .readAsBytesSync();
      calculateImageSize(pickedFileContract.path);

      if (pickedFileContract != null) {
        _cropImageContract(File(pickedFileContract.path));
      }
    }
  }

  void pickImageContractGallery() async {
    pickedFileContract = await _picker.pickImage(source: ImageSource.gallery,

    );


    if(pickedFileContract!=null) {
      imageFileContract = File(pickedFileContract.path);
      _loadContract = true;
      var imageName = pickedFileContract.path
          .split('/')
          .last;
      print(pickedFileContract);

      print(pickedFileContract.path);
      final bytes = File(pickedFileContract.path)
          .readAsBytesSync()
          .lengthInBytes;
      calculateImageSize(pickedFileContract.path);
          if (pickedFileContract != null) {
            _cropImageContract(File(pickedFileContract.path));
          }
    }
  }

  _cropImageContract(File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
        sourcePath: picture.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],
        compressQuality: 100,
        compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight);
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
            _loadContract=false;
            pickedFileContract=null;

          });
        }
        else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Contract = base64Encode(base64Image);
          print('img64Crop: ${img64Contract}');
          imageFileContract= File(cropped.path);
        }
      });

    }
    else{
      this.setState(() {

        _loadContract=false;
        pickedFileContract=null;

        ///here
      });

    }
  }
  void clearImageContract() {
    this.setState(() {

      _loadContract=false;
      pickedFileContract=null;

      ///here
    });

  }


  void _showPicker(context) {
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
                        "DashBoard_Form.select_option".tr().toString(),
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
                      pickImageCamera();
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
                          "DashBoard_Form.open_camera".tr().toString(),
                          style:
                              TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  role=="MadaOutdoor"?Container():   GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageGallery();
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
                          "DashBoard_Form.Choose_photos".tr().toString(),
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

  void _showPickerContarct(context) {
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
                        "DashBoard_Form.select_option".tr().toString(),
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
                      pickImageContractCamera();
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
                          "DashBoard_Form.open_camera".tr().toString(),
                          style:
                              TextStyle(color: Color(0xff11120e), fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  role=="MadaOutdoor"?Container():   GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageContractGallery();
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
                          "DashBoard_Form.Choose_photos".tr().toString(),
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

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.cancel".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PendingContracts(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
          ),
        );
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(
        "alert.error_Document".tr().toString(),
        style: TextStyle(
          color: Colors.black,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('Menu_Form.kit_code'.tr().toString() +
                " " +
                '${data['kitCode']}'),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? englishMessage
                  : arabicMessage,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
      actions: [
        tryAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget buildDashedBorder({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          //tooltip: 'Menu Icon',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => PendingContracts(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
              ),
            );
          },
        ),
        centerTitle:false,
        title: Text(
          "DashBoard_Form.Edit_contract_details".tr().toString(),
        ),
        backgroundColor: Color(0xFF4f2565),
      ),
      backgroundColor: Color(0xFFEBECF1),
      body: ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
        Container(
          color: Colors.white,
          child: Center(
            child: ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                children: [
                  SizedBox(
                    height: 50,
                    child: ListTile(
                      leading: Container(
                        width: 160,
                        child: Text(
                          "DashBoard_Form.kit_code".tr().toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      title: Text(
                        data['kitCode'],
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListTile(
                      leading: Container(
                        width: 160,
                        child: Text(
                          "DashBoard_Form.mobile_number".tr().toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      title: Text(
                        data['msisdn'],
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  SizedBox(
                    height: 55,
                    child: ListTile(
                      leading: Container(
                        width: 160,
                        child: Text(
                          "DashBoard_Form.status".tr().toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      title: Text(
                        data['statusDesc'],
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),
                  Divider(
                    thickness: 1,
                    color: Color(0xFFedeff3),
                  ),
                  SizedBox(
                    height: 50,
                    child: ListTile(
                      leading: Container(
                        width: 160,
                        child: Text(
                          "DashBoard_Form.actovation_date".tr().toString(),
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      title: Text(
                        entryDate[0]+" / "+entryDate[1],
                        style: TextStyle(
                            fontSize: 14,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                  ),

                ]),
          ),
        ),
        Container(
          height: 60,
          padding: EdgeInsets.only(top: 8),
          child: ListTile(
            leading: Container(
              width: 280,
              child: Text(
                "DashBoard_Form.id_photo".tr().toString(),
                style: TextStyle(
                  color: Color(0xFF11120e),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing: _loadId == true
                ? Container(
                    child: IconButton(
                        icon: Icon(Icons.delete),
                        color: Color(0xff0070c9),
                        onPressed: () => {clearImageID()}),
                  )
                : null,
          ),
        ),
        Container(
          color: Colors.white,
          height: 200,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    // color: Colors.amber,
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: _loadId == true
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
                                          image: FileImage(imageFileID),
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
                                                              enableRotation:
                                                                  true,
                                                              backgroundDecoration:
                                                                  BoxDecoration(),
                                                              imageProvider:
                                                                  FileImage(
                                                                      imageFileID),
                                                            ),
                                                            // A simplified version of dialog.
                                                            width: 300.0,
                                                            height: 350.0,
                                                          )));
                                                },
                                                child: Align(
                                                  alignment: Alignment.center,
                                                  child: Text(
                                                    "DashBoard_Form.preview_photo"
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
                                        _showPicker(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "DashBoard_Form.re_take_photo"
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
                                _showPicker(context);
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
                                                "DashBoard_Form.take_photo1"
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
                                                "DashBoard_Form.take_photo2"
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
                                            "DashBoard_Form.take_photo1"
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
                  //SizedBox(width: 10),
                ],
              ),
              imageIDRequired == true
                  ? ReusableRequiredText(
                      text: "DashBoard_Form.image_required".tr().toString())
                  : Container(),
            ]),
          ),
        ),
        Container(
          height: 60,
          padding: EdgeInsets.only(top: 8),
          child: ListTile(
            leading: Container(
              width: 280,
              child: Text(
                "DashBoard_Form.contract_photo".tr().toString(),
                style: TextStyle(
                  color: Color(0xFF11120e),
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            trailing: _loadContract == null
                ? Container(
                    child: IconButton(
                        icon: Icon(Icons.delete),
                        color: Color(0xff0070c9),
                        onPressed: () => {clearImageContract()}),
                  )
                : null,
          ),
        ),
        Container(
          color: Colors.white,
          height: 330,
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.all(10),
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: <
                    Widget>[
              new Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    // color: Colors.amber,
                    padding: EdgeInsets.only(left: 10, right: 5),
                    child: _loadContract == true
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
                                          image: FileImage(imageFileContract),
                                          fit: BoxFit.cover,
                                        )),
                                    child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                                      FocusScope.of(context).unfocus();
                                                      showDialog(
                                                          context: context,
                                                          builder: (_) =>
                                                              Center(
                                                                  // Aligns the container to center
                                                                  child:
                                                                      Container(
                                                                child:
                                                                    PhotoView(
                                                                  enableRotation:
                                                                      true,
                                                                  backgroundDecoration:
                                                                      BoxDecoration(
                                                                          color:
                                                                              Colors.transparent),
                                                                  imageProvider:
                                                                      FileImage(
                                                                          imageFileContract),
                                                                ),
                                                                // A simplified version of dialog.
                                                                width: 310.0,
                                                                height: 500.0,
                                                              )));
                                                    },
                                                    child: Align(
                                                      alignment:
                                                          Alignment.center,
                                                      child: Text(
                                                        "DashBoard_Form.preview_photo"
                                                            .tr()
                                                            .toString(),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFffffff),
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
                                        _showPickerContarct(context);
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          "DashBoard_Form.re_take_photo"
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
                                _showPickerContarct(context);
                              },
                              child: Container(
                                width: 180,
                                height: 235,
                                child: GestureDetector(
                                  child: Align(
                                    alignment: Alignment.center,
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
                                                  "DashBoard_Form.take_photo1"
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
                                                  "DashBoard_Form.take_photo2"
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
                                              "DashBoard_Form.take_photo1"
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
              imageContractRequired == true
                  ? ReusableRequiredText(
                      text: "DashBoard_Form.image_required".tr().toString())
                  : Container(),
            ]),
          ),
        ),
        SizedBox(height: 30),
        BlocListener<ReservedLineBloc, ReservedLineState>(
            listener: (context, state) {
              if (state is ReservedLineErrorState) {
                print("ReservedLineError ReservedLineError ReservedLineError");

                showAlertDialog(
                    context, state.arabicMessage, state.englishMessage);
                //unReservedLineBloc.add(UnPressReservedLineEvent(kitCode:data['kitCode'].toString()));
              }
              if (state is ReservedLineSuccessState) {
                uploadimageBloc.add(PressUploadImageRepositoryEvent(
                    kitCode: data['kitCode'].toString(),
                    idImageBase64: img64,
                    contractImageBase64: img64Contract));

                showToast(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? state.englishMessage
                        : state.arabicMessage,
                    context: context,
                    animation: StyledToastAnimation.scale,
                    fullWidth: true);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PendingContracts(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
                  ),
                );
              }
            },
            child: Container(
              height: 48,
              width: 300,
              margin: EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: BlocListener<UploadImageBloc, UploadImageState>(
                  listener: (context, state) {
                    if (state is UploadImageStateErrorState) {
                      showAlertDialog(
                          context, state.arabicMessage, state.englishMessage);
                      unReservedLineBloc.add(UnPressReservedLineEvent(
                          kitCode: data['kitCode'].toString()));
                    }
                    if (state is UploadImageStateSuccessState) {
                      print("Image Image Image");
                    }
                  },
                  child: TextButton(

                    onPressed: () async {
                      if (imageFileContract == null) {
                        setState(() {
                          imageContractRequired = true;
                        });
                      }

                      if (imageFileID == null) {
                        setState(() {
                          imageIDRequired = true;
                        });
                      }

                      if (imageFileID != null && imageFileContract != null) {
                        print("hayaaaaaaaaaa");
                        reservedLineBloc.add(PressReservedLineEvent(
                            kitCode: data['kitCode'].toString()));
                      }
                    },
                    style: TextButton.styleFrom(
                      backgroundColor:Color(0xFF4f2565),
                      shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                    ),

                    child: Text(
                      "DashBoard_Form.Submit_photo".tr().toString(),
                      style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 0,
                          fontSize: 16,
                          fontWeight: FontWeight.bold),
                    ),
                  )),
            )),
        SizedBox(height: 30),
      ]),
    );
  }
}
