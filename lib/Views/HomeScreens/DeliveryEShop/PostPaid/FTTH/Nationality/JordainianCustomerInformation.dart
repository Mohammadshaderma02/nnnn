import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:typed_data';

import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/FTTH/Contract/contract_details.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/FTTH/Nationality/NationalityList.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_bloc.dart';
import 'package:sales_app/blocs/PostPaid/FTTHBuildingCode/getAddressBuildingCode_bloc.dart';
import 'package:sales_app/blocs/PostPaid/FTTHBuildingCode/getAddressBuildingCode_events.dart';
import 'package:sales_app/blocs/PostPaid/FTTHBuildingCode/getAddressBuildingCode_state.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHArea/getAdressAreaLookUp_bloc.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHArea/getAdressAreaLookUp_events.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHArea/getAdressAreaLookUp_state.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHBuildingNumber/getAdressBuildingLookUp_bloc.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHBuildingNumber/getAdressBuildingLookUp_events.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHBuildingNumber/getAdressBuildingLookUp_state.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHStreet/getAdressStreetLookUp_bloc.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHStreet/getAdressStreetLookUp_events.dart';
import 'package:sales_app/blocs/PostPaid/GetAddressLookUp/FTTHStreet/getAdressStreetLookUp_state.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_bloc.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dropdown_search/dropdown_search.dart';

import '../../../../../../main.dart';
//import 'contract_details.dart';

class JordainianCustomerInformation extends StatefulWidget {

  var PermessionDeliveryEShop = [];
  var orderID = '';
  String packageCode;
  var packageName = '';
  var role = '';

  var outDoorUserName;
  final String msisdn;
  final String nationalNumber;
  final String passportNumber;

  var userName;

  var password;
  String marketType;

  JordainianCustomerInformation(
  this.PermessionDeliveryEShop,
  this.role,
  this.orderID,
  this.packageName,
  this.packageCode,
  this.marketType,
  this.msisdn,
  this.nationalNumber,
  this.passportNumber,
  this.userName,
  this.password);

  @override
  _JordainianCustomerInformationState createState() =>
      _JordainianCustomerInformationState(
  this.PermessionDeliveryEShop,
  this.role,
  this.orderID,
  this.packageName,
  this.packageCode,
  this.marketType,
  this.msisdn,
  this.nationalNumber,
  this.passportNumber,
  this.userName,
  this.password);
}

class Item {
  const Item(this.value, this.textEn, this.textAr);

  final String value;
  final String textEn;
  final String textAr;
}

class _JordainianCustomerInformationState
    extends State<JordainianCustomerInformation> {
  DateTime backButtonPressedTime;
  var PermessionDeliveryEShop = [];
  var role = '';
  var packageName = '';
  var orderID = '';

  var outDoorUserName;

  final String msisdn;
  final String passportNumber;
  final String nationalNumber;
   String packageCode;
  var userName;

  final picker = ImagePicker();
  File imageFile;
  File imageFileIDFront;
  File imageFileIDBack;

  String img64Front;
  String img64Back;
  String img64Location;

  String localPath;
  bool isAgree = false;

  var password;
  String marketType;
  bool isJordainian = true;
  APP_URLS urls = new APP_URLS();

  int imageWidth = 200;
  int imageHeight = 200;

  _JordainianCustomerInformationState(
  this.PermessionDeliveryEShop,
  this.role,
  this.orderID,
  this.packageName,
  this.packageCode,
  this.marketType,
  this.msisdn,
  this.nationalNumber,
  this.passportNumber,
  this.userName,
  this.password,);

  TextEditingController NationalNumber = TextEditingController();

  TextEditingController MSISDN = TextEditingController();
  TextEditingController UserName = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController mbbMsisdn = TextEditingController();
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController referenceNumber2 = TextEditingController();
  TextEditingController buildingCode = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController ticketNo = TextEditingController();
  TextEditingController salesLeadValue = TextEditingController();
  TextEditingController sellectSalesLead = TextEditingController();

  /***********************New 9-8-2023****************************************************************************************************/
  TextEditingController OrderId = TextEditingController();
  TextEditingController MarketType = TextEditingController();
  TextEditingController PackageName = TextEditingController();
  TextEditingController PackageCode = TextEditingController();
  var old_packageCode;
  var options_PACKGE =[];
  List <String> PACKGE_Value=[];
  bool on_ChangePackge=false;
  var selectedPackge_Key;
  var selectedPackge_Value=null;
  bool emptyselectedPackege = false;


  /*************************************************************************************************************************************/

  VerifyOTPSCheckMSISDNBloc verifyOTPSCheckMSISDNBloc;
  SendOTPSCheckMSISDNBloc sendOTPSCheckMSISDNBloc;
  GetLookUpListBloc getLookUpListBloc;
  GetAddressLookupAreaBloc getAddressLookupAreaBloc;
  GetAddressLookupStreetBloc getAddressLookupStreetBloc;
  GetAddressLookupBuildingBloc getAddressLookupBuildingBloc;
  GetBuildingCodeBloc getBuildingCodeBloc;
  PostpaidGenerateContractBloc postpaidGenerateContractBloc;

  bool response = false;
  bool emptyMSISDN = false;
  bool emptyUserName = false;
  bool emptyPassword = false;
  bool emptyReferenceNumber = false;
  bool errorReferenceNumber = false;
  bool emptySecondReferenceNumber = false;
  bool errorSecondReferenceNumber = false;
  bool successFlag = false;
  int clearSucssesFlag=0;
  bool successFlagSecondeReferancenumber = false;
  bool imageIDFrontRequired = false;
  bool imageIDBackRequired = false;
  bool imageLocationRequired = false;
  bool emptyMBBMSISDN = false;
  bool emptyBuildinCode = false;
  bool duplicateSecondReferenceNumber = false;

  bool showCircular = false;
  bool isMigrate = false;
  bool extraMonth = false;
  bool freeExtender = false;
  String packagesSelect;

  bool emptyExtraFreeMonth = false;
  bool emptyFreeExtender = false;

  bool emptyArea = false;
  bool emptyStreet = false;
  bool emptyBuilding = false;

  String area;
  String street;
  String building;
  String extra_month;
  String free_extender;
  bool isDisabled = false;

  //String buildingCode ='' ;
  List<Item> AREAS = <Item>[];
  List<Item> STREET = <Item>[];
  List<Item> BUILDINGS = <Item>[];
  List<Item> EXTRA_MONTHS = <Item>[];
  List<Item> FREE_EXTENDER = <Item>[];

  File imageFileFrontID = File('');
  bool _loadIdFront = false;
  var pickedFileFrontId;

  File imageFileBackID = File('');
  bool _loadIdBack = false;
  var pickedFileBackId;

  File imageFileLocation = File('');
  bool _loadIdLocation = false;
  var pickedFileLocation;

  String img64 = '';
  final _picker = ImagePicker();

  /////////////////////////////////New///////////////////////////////////////////
  String optionValue;
  bool switchValidateSalesLead = true;
  bool emptyOption = false;
  bool emptysalesLeadValue = false;
  var sellectSalesLeadOption = [
    "Postpaid.LCMSalesLead".tr().toString(),
    "Postpaid.EshopOrderNO".tr().toString()
  ];
  bool emptyTicketNo = false;

  int salesLeadType = 0;
///////////////////////////End New///////////////////////////////////////////
  /////////////////////////////////New 22/3/2023///////////////////////////////////////////
  bool on_BEHALF=false;
  var options_BEHALF = [];
  var selectedBEHALF;
  bool emptyselectedBEHALF = false;
  List <String> BEHALF_Value=[];
  var selectedBEHALF_Value=null;
  var selectedBEHALF_key;
  ///////////////////////////End New///////////////////////////////////////////
  /////////////////////////////////New 17/4/2023///////////////////////////////////////////
  bool reseller=false;
  var options_Reseller = [];
  var selectedReseller;
  bool emptyselectedReseller = false;

  List <String> Reseller_Value=[];
  var selectedReseller_Value=null;
  var selectedReseller_key;
  bool claim = false;

  ///////////////////////////End New//////////////////////////////////////////////////////
  /***********************************************New 12/6/2023************************************************/
  TextEditingController notes = TextEditingController();
  bool maximumcharacter=false;
  /***********************************************************************************************************/
/*...........................................Document Expiry Date.........................................*/
  bool emptyDocumentExpiryDate=false;
  TextEditingController documentExpiryDate = TextEditingController();
  DateTime Expiry_Date = DateTime.now();

  void initState() {
    getEligiblePackages();
    LookupON_Reseller();
    LookupON_BEHALF();
    super.initState();
    getAddressLookupAreaBloc =
        BlocProvider.of<GetAddressLookupAreaBloc>(context);
    getAddressLookupStreetBloc =
        BlocProvider.of<GetAddressLookupStreetBloc>(context);
    getAddressLookupBuildingBloc =
        BlocProvider.of<GetAddressLookupBuildingBloc>(context);
    getBuildingCodeBloc = BlocProvider.of<GetBuildingCodeBloc>(context);
    getAddressLookupAreaBloc.add(GetAddressLookupAreaFetchEvent('FTTHArea'));
    getAddressLookupStreetBloc.add(GetAddressLookupStreetFetchEvent(''));
    getAddressLookupBuildingBloc.add(GetAddressLookupBuildingFetchEvent(''));
    verifyOTPSCheckMSISDNBloc =
        BlocProvider.of<VerifyOTPSCheckMSISDNBloc>(context);
    postpaidGenerateContractBloc =
        BlocProvider.of<PostpaidGenerateContractBloc>(context);
    NationalNumber.text = nationalNumber;
    MSISDN.text = msisdn;
    Password.text = password;
    UserName.text = userName;


    /***********************New 9-8-2023****************************************************************************************************/
    OrderId.text = orderID;
    MarketType.text = marketType;
    PackageName.text = packageName;
    PackageCode.text = packageCode;
    old_packageCode=packageCode;
    salesLeadValue.text =orderID;
    sellectSalesLead.text="Postpaid.EshopOrderNO_Ticket".tr().toString();
    optionValue="Postpaid.EshopOrderNO_Ticket".tr().toString();
    salesLeadType=2;

    /*************************************************************************************************************************************/


  }

  final msg =
  BlocBuilder<PostpaidGenerateContractBloc, PostpaidGenerateContractState>(
      builder: (context, state) {
        if (state is PostpaidGenerateContractLoadingState) {
          return Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF392156)),
                ),
              ));
        } else {
          return Container();
        }
      });

  void printLongString(String text) {
    final RegExp pattern =
    RegExp('.{1,10000}'); // 100000 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
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
          print('image height after ${imageHeight}');
          print('image width after ${imageWidth}');
        },
      ),
    );
  }

  void pickImageCameraFront() async {
    pickedFileFrontId = await _picker.pickImage(
      source: ImageSource.camera,
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

  void pickImageCameraLocation() async {
    pickedFileLocation = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileLocation != null) {
      imageFileLocation = File(pickedFileLocation.path);
      _loadIdLocation = true;
      var imageName = pickedFileLocation.path.split('/').last;
      print(pickedFileLocation);

      print(pickedFileLocation.path);
      final bytes =
          File(pickedFileLocation.path).readAsBytesSync().lengthInBytes;

      calculateImageSize(pickedFileLocation.path);
      if (pickedFileLocation != null) {
        _cropImageLocation(File(pickedFileLocation.path));
      }
    }
  }

  void pickImageGalleryLocation() async {
    pickedFileLocation = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileLocation != null) {
      imageFileLocation = File(pickedFileLocation.path);
      _loadIdLocation = true;
      var imageName = pickedFileLocation.path.split('/').last;
      calculateImageSize(pickedFileLocation.path);
      if (pickedFileLocation != null) {
        _cropImageLocation(File(pickedFileLocation.path));
      }
    }
  }

  _cropImageFront(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /* aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/

      compressQuality: 100,
      /*compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),
        maxWidth: imageWidth,
        maxHeight: imageHeight*/
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
            _loadIdFront = false;
            pickedFileFrontId = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Front = base64Encode(base64Image);
          print('img64Crop after crop:');
          printLongString(img64Front);
          imageFileFrontID = File(cropped.path);

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
      /* aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /*compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
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

  _cropImageLocation(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.ratio5x4,
          CropAspectRatioPreset.ratio16x9
        ],*/
      compressQuality: 100,
      /* compressFormat:ImageCompressFormat.jpg,
        aspectRatio: CropAspectRatio(ratioX:  imageWidth.toDouble(), ratioY: imageHeight.toDouble()),

        maxWidth: imageWidth,
        maxHeight: imageHeight*/
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
            _loadIdLocation = false;
            pickedFileLocation = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Location = base64Encode(base64Image);
          print('img64Crop: ${img64Location}');
          imageFileLocation = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadIdLocation = false;
        pickedFileLocation = null;

        ///here
      });
    }
  }

  void clearImageIDFront() {
    /* this.setState(()=>
    imageFileID = null );*/

    this.setState(() {
      _loadIdFront = false;
      pickedFileFrontId = null;

      ///here
    });
  }

  void clearImageIDBack() {
    this.setState(() {
      _loadIdBack = false;
      pickedFileBackId = null;
    });
  }

  void clearImageLocation() {
    this.setState(() {
      _loadIdLocation = false;
      pickedFileLocation = null;
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
                  role=="MadaOutdoor"?Container():  GestureDetector(
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
                  role=="MadaOutdoor"?Container():   GestureDetector(
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

  void _showPickerLocation(context) {
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
                      pickImageCameraLocation();
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
                  role=="MadaOutdoor"?Container():   GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageGalleryLocation();
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

  Widget buildDashedBorder({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

  /*.................................................Document Expiry Date 12/6/2024...............................................*/
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
                      showDatePicker(
                        context: context,
                        firstDate: DateTime.now(),
                        // firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 60),
                        initialDate: DateTime.now(),
                        lastDate:DateTime(DateTime.now().year+20,
                        ),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF4f2565), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary:
                                  Color(0xFF4f2565), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((fromData) => {
                        setState(() {
                          Expiry_Date = fromData;
                          documentExpiryDate.text =
                          "${fromData.day.toString().padLeft(2, '0')}/${fromData.month.toString().padLeft(2, '0')}/${fromData.year.toString()}";
                        }),
                      });
                    }),
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
  /*..............................................................................................................................*/


  final msgTwo =
  BlocBuilder<VerifyOTPSCheckMSISDNBloc, VerifyOTPSCheckMSISDNState>(
      builder: (context, state) {
        if (state is VerifyOTPSCheckMSISDNLoadingState) {
          return Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 0, top: 20),
                child: Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
                  ),
                ),
              ));
        } else {
          return Container();
        }
      });

  showAlertDialogVerify(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.pop(context, true);
        // Navigator.pop(context, true);
        otp.clear();
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

  showAlertDialogSaveData(BuildContext context, arabicMessage, englishMessage) {
    Widget close = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.pop(context, true);
        // Navigator.pop(context, true);
        otp.clear();
      },
    );
    Widget save = TextButton(
      child: Text(
        "alert.save".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pop(context, true);
        setState(() {
          isDisabled = true;
        });
        postpaidGenerateContractBloc.add(PostpaidGenerateContractButtonPressed(
            marketType: marketType,
            isJordanian: isJordainian,
            nationalNo: nationalNumber,
            passportNo: null,
            firstName: null,
            secondName: null,
            lastName: null,
            birthDate: null,
            msisdn: msisdn,
            buildingCode: buildingCode.text,
            migrateMBB: isMigrate,
            mbbMsisdn: mbbMsisdn.text,
            packageCode: packageCode,
            username: UserName.text,
            password: Password.text,
            referenceNumber: referenceNumber.text,
            referenceNumber2: referenceNumber2.text,
            frontIdImageBase64: img64Front,
            backIdImageBase64: img64Back,
            passportImageBase64: null,
            locationScreenshotImageBase64: img64Location,
            extraFreeMonths: extra_month,
            extraExtender: free_extender,
            simCard: null,
            contractImageBase64: null,
            onBehalfUser:selectedBEHALF_key==null?"":selectedBEHALF_key,
            resellerID :selectedReseller_key==null?"":selectedReseller_key,
            isClaimed:claim,
            backPassportImageBase64:null,
            note: notes.text,
            scheduledDate:""));
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
      actions: [close, save],
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

  SendOtp() async {
    print('called');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(
      Uri.parse(urls.BASE_URL + "/OTP/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode({"msisdn": referenceNumber.text}),
    );

    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    print(statusCode);
    if (statusCode == 200) {
      var result = json.decode(res.body);
      print(result);
      if (result['status'] == 0) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "CustomerService.verify_code".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 16,
              ),
            ),
            content: Container(
              width: double.maxFinite,
              height: showCircular ? 170 : 110,
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(
                    child: ListView(
                      // shrinkWrap: false,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            height: 50,
                            child: ListTile(
                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                              title: Text(
                                "CustomerService.enter_OTP".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: ListTile(
                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 4),
                              title: TextField(
                                controller: otp,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D7E0), width: 1.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF4F2565), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  hintText:
                                  "CustomerService.verify_hint".tr().toString(),
                                  hintStyle: TextStyle(
                                      color: Color(0xFFA4B0C1), fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          msgTwo
                        ]))
              ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  referenceNumber.clear();
                  // Navigator.of(context).pop();
                  Navigator.pop(context, true);
                },
                child: Text(
                  "CustomerService.Cancel".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFF392156),
                    fontSize: 16,
                  ),
                ),
              ),
              BlocListener<VerifyOTPSCheckMSISDNBloc,
                  VerifyOTPSCheckMSISDNState>(
                listener: (context, state) {
                  if (state is VerifyOTPSCheckMSISDNLoadingState) {
                    setState(() {
                      showCircular = true;
                    });
                  }
                  if (state is VerifyOTPSCheckMSISDNErrorState) {
                    setState(() {
                      showCircular = false;
                    });
                    setState(() {
                      otp.text = '';
                    });
                    showAlertDialogVerify(
                        context, state.arabicMessage, state.englishMessage);
                    // Navigator.of(context).pop();
                  }
                  if (state is VerifyOTPSCheckMSISDNSuccessState) {
                    setState(() {
                      showCircular = false;
                    });
                    //Navigator.of(context).pop();
                    setState(() {
                      otp.text = '';
                      successFlag = true;
                      clearSucssesFlag=1;
                    });
                    Navigator.pop(context, true);

                  }
                },
                child: TextButton(
                  onPressed: () {
                    // Navigator.of(ctx).pop();
                    verifyOTPSCheckMSISDNBloc.add(VerifyOTPSCheckMSISDNPressed(
                        msisdn: referenceNumber.text, otp: otp.text));
                    //Navigator.of(ctx).pop();
                  },
                  child: Text(
                    "CustomerService.verify".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF392156),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      } else {
        setState(() {
          errorReferenceNumber = true;
        });
      }

    }
  }

  SendOtpSecondReferanceNumber() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(
      Uri.parse(urls.BASE_URL + "/OTP/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode({"msisdn": referenceNumber2.text}),
    );

    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200) {
      var result = json.decode(res.body);
      if (result['status'] == 0) {
        showDialog(
          barrierDismissible: false,
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "CustomerService.verify_code".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 16,
              ),
            ),
            content: Container(
              width: double.maxFinite,
              height: showCircular ? 170 : 110,
              child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
                Expanded(
                    child: ListView(
                      // shrinkWrap: false,
                        physics: const NeverScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            width: double.maxFinite,
                            height: 50,
                            child: ListTile(
                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                              title: Text(
                                "CustomerService.enter_OTP".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xff11120e),
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 50,
                            child: ListTile(
                              contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 4),
                              title: TextField(
                                controller: otp,
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  enabledBorder: const OutlineInputBorder(
                                    // width: 0.0 produces a thin "hairline" border
                                    borderSide: const BorderSide(
                                        color: Color(0xFFD1D7E0), width: 1.0),
                                  ),
                                  border: const OutlineInputBorder(),
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(
                                        color: Color(0xFF4F2565), width: 1.0),
                                  ),
                                  contentPadding: EdgeInsets.all(16),
                                  hintText:
                                  "CustomerService.verify_hint".tr().toString(),
                                  hintStyle: TextStyle(
                                      color: Color(0xFFA4B0C1), fontSize: 14),
                                ),
                              ),
                            ),
                          ),
                          msgTwo
                        ]))
              ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  referenceNumber2.clear();
                  // Navigator.of(context).pop();
                  Navigator.pop(context, true);
                },
                child: Text(
                  "CustomerService.Cancel".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFF392156),
                    fontSize: 16,
                  ),
                ),
              ),
              BlocListener<VerifyOTPSCheckMSISDNBloc,
                  VerifyOTPSCheckMSISDNState>(
                listener: (context, state) {
                  if (state is VerifyOTPSCheckMSISDNLoadingState) {
                    setState(() {
                      showCircular = true;
                    });
                  }
                  if (state is VerifyOTPSCheckMSISDNErrorState) {
                    setState(() {
                      showCircular = false;
                    });
                    setState(() {
                      otp.text = '';
                    });
                    showAlertDialogVerify(
                        context, state.arabicMessage, state.englishMessage);
                    // Navigator.of(context).pop();
                  }
                  if (state is VerifyOTPSCheckMSISDNSuccessState) {
                    setState(() {
                      showCircular = false;
                    });
                    //Navigator.of(context).pop();
                    setState(() {
                      otp.text = '';
                      successFlagSecondeReferancenumber = true;
                    });
                    Navigator.pop(context, true);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) => ActiveAndEligiblePackages(
                    //         EasyLocalization.of(context).locale == Locale("en", "US")
                    //             ? arabicName
                    //             : englishName,msisdn.text,enableMsisdn),
                    //   ),
                    // );
                    //  getCurrentPackageBloc.add(GetCurrentPackageButtonPressed(msisdn.text));

                    // Navigator.of(context).push(MaterialPageRoute(builder:(context)=>Service(numberService)));
                  }
                },
                child: TextButton(
                  onPressed: () {
                    // Navigator.of(ctx).pop();
                    verifyOTPSCheckMSISDNBloc.add(VerifyOTPSCheckMSISDNPressed(
                        msisdn: referenceNumber2.text, otp: otp.text));
                    //Navigator.of(ctx).pop();
                  },
                  child: Text(
                    "CustomerService.verify".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF392156),
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }
    }
  }

  void changeSwitched(value) async {
    setState(() {
      isMigrate = !isMigrate;
      mbbMsisdn.text='';
    });
  }
  /*......................................................New 9-8-2023..........................................................*/
  void getEligiblePackages()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Postpaid/eligible-packages';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);
    Map body;
    body = {
      "marketType": marketType
    };

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),
    );
    int statusCode = response.statusCode;
    print(json.encode(body));
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? statusCode.toString()
                  : statusCode.toString())));
    }
    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? statusCode.toString()
                  : statusCode.toString())));
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if (result["status"] == 0) {
        if (result["data"] == null || result["data"].length == 0) {

          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("PatternSimilarity.EmptyData".tr().toString())));
        } else {
          setState(() {
            options_PACKGE = result["data"];

          });
          for (var i = 0; i < result['data'].length; i++) {

            PACKGE_Value.add(result['data'][i]['descEn'].toString());

          }
          print("/****************************New Package ****************************************/");
          print(options_PACKGE );
          print(PACKGE_Value );
          print("/********************************************************************/");


          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text("PatternSimilarity.Success".tr().toString())));
        }
      }

      return result;
    } else {

    }
  }

  void change_packge(value) async {
    setState(() {
      on_ChangePackge = !on_ChangePackge;
      selectedPackge_Key=null;
      selectedPackge_Value=null;

    });
    if(on_ChangePackge==false){
      setState(() {
        packageCode= old_packageCode;
      });
    }

    print(on_ChangePackge);
    print(old_packageCode);
    print(packageCode);

  }

  Widget buildChangePackge() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: on_ChangePackge,
            onChanged: (value) {
              change_packge(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "DeliveryEShop.ChangePackage".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildSelect_Packge() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: "DeliveryEShop.ChangePackage".tr().toString(),
              style: TextStyle(
                color: Color(0xFF11120E),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: '',
                  style: TextStyle(
                    color: Color(0xFFB10000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]
          ),
        ),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.only(left: 10,right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyselectedPackege == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child:DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  cursorColor: Color(0xFF392156),


                ),

              ),
              items: PACKGE_Value,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:  Color(0xFFD1D7E0)),
                  ),

                    hintText:  packageName,
                    hintStyle: TextStyle(
                      color: Color(0xFF11120E),
                      fontSize: 14,)

                ),
              ),
              onChanged:(val){


                print("ddddd");
                print(val);
                print("dddddddddd");
                getKeySelectedPackge(val);

              },

              selectedItem: selectedPackge_Value,
            )),
        emptyselectedPackege == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required"
                .tr()
                .toString()) : Container(),
      ],
    );
  }

  void getKeySelectedPackge(val){
    for (var i = 0; i < options_PACKGE.length; i++) {
      if(options_PACKGE[i]['descEn'].contains(val)){
        setState(() {
          selectedPackge_Key=options_PACKGE[i]['packageCode'];
        });
        print("aaaaaaaaaaaaa");
        print(selectedPackge_Key);
        print(packageCode);
        setState(() {
          packageCode=selectedPackge_Key;
          PackageCode.text = packageCode;

        });
        print(packageCode);
      }else{
        continue;
      }
    }
  }

  /*........................................................End New.............................................................*/


  /***********************New 9-8-2023****************************************************************************************************/
  Widget buildOrderID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "DeliveryEShop.orderID".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: OrderId,
            enabled: false,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMarketType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "DeliveryEShop.markettype".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: MarketType,
            enabled: false,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPackageName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "DeliveryEShop.packageName".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: PackageName,
            enabled: false,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildPackageCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "DeliveryEShop.PackageCode".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: PackageCode,
            enabled: false,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }
  /*************************************************************************************************************************************/

  Widget buildNationalNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.nationalNo".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: NationalNumber,
            enabled: false,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildMSISDNNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.msisdn".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: MSISDN,
            enabled: false,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildUserName() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "Postpaid.userName".tr().toString(),
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
              controller: UserName,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Color(0xff11120e)),
              decoration: InputDecoration(
                enabledBorder: emptyUserName == true
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
                hintText: "Postpaid.userName".tr().toString(),
                hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.password".tr().toString(),
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
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: Password,
            enabled: true,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyPassword == true
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
              hintText: "Postpaid.password".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBuildingCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.building_code".tr().toString(),
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
            controller: buildingCode,
            enabled: role == 'Subdealer' ? false : true,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyBuildinCode == true
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
              hintText: "Postpaid.building_code".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildReferenceNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.reference_number".tr().toString(),
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
            controller: referenceNumber,
            maxLength: 10,
            onChanged: (text) {
              if (text.length == 10) {
                if (text.substring(3, 10) == '0000000' ||
                    text.substring(0, 10) == '0000000000') {
                  setState(() {
                    errorReferenceNumber = true;
                  });
                } else {
                  SendOtp();
                  setState(() {
                    errorReferenceNumber = false;
                  });
                }
              }else{
                setState(() {
                  errorReferenceNumber = true;
                  clearSucssesFlag = 2;
                });
              }
            },
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            keyboardType: TextInputType.phone,
            /*    inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp('[a-z A-Z á-ú Á-Ú]')),
                              ],*/
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder:
              emptyReferenceNumber == true || errorReferenceNumber == true
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
              hintText: "Postpaid.enter_reference_number".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildReferenceNumber2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.Secondreference_number".tr().toString(),
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
            controller: referenceNumber2,
            maxLength: 10,
            onChanged: (text) {
              if (text.length == 10) {
                print(text.substring(0, 10));
                if (text.substring(3, 10) == '0000000' ||
                    text.substring(0, 10) == '0000000000') {
                  setState(() {
                    errorSecondReferenceNumber = true;
                  });
                } else {
                  setState(() {
                    errorSecondReferenceNumber = false;
                  });
                }
              }
            },
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp('[a-z A-Z á-ú Á-Ú]')),
            ],
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptySecondReferenceNumber == true ||
                  errorSecondReferenceNumber == true ||
                  duplicateSecondReferenceNumber == true
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
              hintText: "Postpaid.enter_reference_number".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildmbbMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.migration_msisdn".tr().toString(),
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
            controller: mbbMsisdn,
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp('[a-z A-Z á-ú Á-Ú]')),
            ],
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMBBMSISDN == true
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
              hintText: "Postpaid.enter_migration_number".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildEnableMBB() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: isMigrate,
            onChanged: (value) {
              changeSwitched(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "Postpaid.check_migration".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

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

  Widget buildAreaName() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "Postpaid.area".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                role == 'Subdealer'
                    ? TextSpan(
                  text: ' * ',
                  style: TextStyle(
                    color: Color(0xFFB10000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                )
                    : TextSpan(
                  text: '',
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
          BlocBuilder<GetAddressLookupAreaBloc, GetAddressLookupAreaState>(
              builder: (context, state) {
                if (state is GetAddressLookupAreaSuccessState ||
                    state is GetAddressLookupAreaLoadingState ||
                    state is GetAddressLookupAreaErrorState) {
                  AREAS = [];
                  if (state is GetAddressLookupAreaSuccessState) {
                    AREAS = [];
                    for (var obj in state.data) {
                      AREAS.add(Item(obj, obj.toString(), obj.toString()));
                    }
                  }
                  return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          //color: Color(0xFFB10000), red color
                          color: emptyArea == true
                              ? Color(0xFFB10000)
                              : Color(0xFFD1D7E0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            hint: Text(
                              "Personal_Info_Edit.select_an_option".tr().toString(),
                              style: TextStyle(
                                color: Color(0xFFA4B0C1),
                                fontSize: 14,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            iconSize: 30,
                            iconEnabledColor: Colors.grey,
                            underline: SizedBox(),
                            isExpanded: true,
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 14,
                            ),
                            value: area,
                            onChanged: (String newValue) {
                              setState(() {
                                area = newValue;
                              });

                              if (street != null && street != '') {
                                setState(() {
                                  STREET = <Item>[];
                                  BUILDINGS = <Item>[];
                                  street = null;
                                  building = null;
                                });
                              }
                              getAddressLookupStreetBloc
                                  .add(GetAddressLookupStreetFetchEvent(area));
                            },
                            items: AREAS.map((valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem.value,
                                child: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? Text(valueItem.textEn)
                                    : Text(valueItem.textAr),
                              );
                            }).toList(),
                          ),
                        ),
                      ));
                } else {
                  return Container();
                }
              }),
          SizedBox(height: 10),
        ]);
  }

  Widget buildStreetName() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "Postpaid.street".tr().toString(),
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                role == 'Subdealer'
                    ? TextSpan(
                  text: ' * ',
                  style: TextStyle(
                    color: Color(0xFFB10000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                )
                    : TextSpan(
                  text: '',
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
          BlocBuilder<GetAddressLookupStreetBloc, GetAddressLookupStreetState>(
              builder: (context, state) {
                if (state is GetAddressLookupStreetInitState ||
                    state is GetAddressLookupStreetSuccessState ||
                    state is GetAddressLookupStreetLoadingState ||
                    state is GetAddressLookupStreetErrorState) {
                  STREET = [];

                  if (state is GetAddressLookupStreetSuccessState) {
                    STREET = [];
                    for (var obj in state.data) {
                      if (obj != null) {
                        STREET.add(Item(obj, obj.toString(), obj.toString()));
                      }
                    }
                  }
                  return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          //color: Color(0xFFB10000), red color
                          color: emptyStreet == true
                              ? Color(0xFFB10000)
                              : Color(0xFFD1D7E0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            hint: Text(
                              "Personal_Info_Edit.select_an_option".tr().toString(),
                              style: TextStyle(
                                color: Color(0xFFA4B0C1),
                                fontSize: 14,
                              ),
                            ),
                            dropdownColor: Colors.white,
                            icon: Icon(Icons.keyboard_arrow_down_rounded),
                            iconSize: 30,
                            iconEnabledColor: Colors.grey,
                            underline: SizedBox(),
                            isExpanded: true,
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 14,
                            ),
                            value: street,
                            onChanged: (String newValue) {
                              setState(() {
                                street = newValue;
                              });

                              if (building != null && building != '') {
                                setState(() {
                                  BUILDINGS = <Item>[];
                                  building = null;
                                });
                              }

                              getAddressLookupBuildingBloc
                                  .add(GetAddressLookupBuildingFetchEvent(street));
                            },
                            items: STREET.map((valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem.value,
                                child: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? Text(valueItem.textEn)
                                    : Text(valueItem.textAr),
                              );
                            }).toList(),
                          ),
                        ),
                      ));
                } else {
                  return Container();
                }
              }),
          SizedBox(height: 10),
        ]);
  }

  Widget buildBuildingName() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      RichText(
        text: TextSpan(
          text: "Postpaid.building_number".tr().toString(),
          style: TextStyle(
            color: Color(0xff11120e),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
          children: <TextSpan>[
            role == 'Subdealer'
                ? TextSpan(
              text: ' * ',
              style: TextStyle(
                color: Color(0xFFB10000),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            )
                : TextSpan(
              text: '',
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
      BlocBuilder<GetAddressLookupBuildingBloc, GetAddressLookupBuildingState>(
          builder: (context, state) {
            if (state is GetAddressLookupBuildingSuccessState ||
                state is GetAddressLookupBuildingLoadingState ||
                state is GetAddressLookupBuildingErrorState) {
              BUILDINGS = [];
              if (state is GetAddressLookupBuildingSuccessState) {
                BUILDINGS = [];
                for (var obj in state.data) {
                  BUILDINGS.add(Item(obj, obj.toString(), obj.toString()));
                }
              }
              return BlocListener<GetBuildingCodeBloc, GetBuildingCodeState>(
                listener: (context, state) {
                  if (state is GetBuildingCodeSuccessState) {
                    print('state.data');
                    print(state.data);
                    buildingCode.clear();
                    setState(() {
                      buildingCode.text = state.data;
                    });

                    buildingCode.text = state.data;
                  }
                },
                child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        //color: Color(0xFFB10000), red color
                        color: emptyBuilding == true
                            ? Color(0xFFB10000)
                            : Color(0xFFD1D7E0),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: ButtonTheme(
                        alignedDropdown: true,
                        child: DropdownButton<String>(
                          hint: Text(
                            "Personal_Info_Edit.select_an_option".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFFA4B0C1),
                              fontSize: 14,
                            ),
                          ),
                          dropdownColor: Colors.white,
                          icon: Icon(Icons.keyboard_arrow_down_rounded),
                          iconSize: 30,
                          iconEnabledColor: Colors.grey,
                          underline: SizedBox(),
                          isExpanded: true,
                          style: TextStyle(
                            color: Color(0xFF11120e),
                            fontSize: 14,
                          ),
                          value: building,
                          onChanged: (String newValue) {
                            setState(() {
                              building = newValue;
                            });

                            getBuildingCodeBloc.add(
                                GetBuildingCodeFetchEvent(area, street, building));
                          },
                          items: BUILDINGS.map((valueItem) {
                            return DropdownMenuItem<String>(
                              value: valueItem.value,
                              child: EasyLocalization.of(context).locale ==
                                  Locale("en", "US")
                                  ? Text(valueItem.textEn)
                                  : Text(valueItem.textAr),
                            );
                          }).toList(),
                        ),
                      ),
                    )),
              );
            } else {
              return Container();
            }
          }),
      SizedBox(height: 10),
    ]);
  }

  Widget buildImageLoction() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      color: Colors.white,
      height: 313,
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
                child: _loadIdLocation == true
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
                                image: FileImage(imageFileLocation),
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
                                                            imageFileLocation),
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
                              _showPickerLocation(context);
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
                      _showPickerLocation(context);
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
          imageLocationRequired == true
              ? ReusableRequiredText(
              text: "Jordan_Nationality.this_feild_is_required"
                  .tr()
                  .toString())
              : Container(),
        ]),
      ),
    );
  }

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.cancel".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pop(
          context,
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

  void changeExtraMonthCheak(value) async {
    setState(() {
      extraMonth = !extraMonth;
      extra_month = null;
    });
  }

  Widget extraFreeMonths() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: extraMonth,
            onChanged: (value) {
              changeExtraMonthCheak(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "Postpaid.extra_free_months".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildExtraMonths() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.extra_free_months".tr().toString(),
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
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptyExtraFreeMonth == true
                        ? Color(0xFFB10000)
                        : Color(0xFFD1D7E0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      hint: Text(
                        "Personal_Info_Edit.select_an_option".tr().toString(),
                        style: TextStyle(
                          color: Color(0xFFA4B0C1),
                          fontSize: 14,
                        ),
                      ),
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      iconSize: 30,
                      iconEnabledColor: Colors.grey,
                      underline: SizedBox(),
                      isExpanded: true,
                      style: TextStyle(
                        color: Color(0xFF11120e),
                        fontSize: 14,
                      ),
                      value: extra_month,
                      onChanged: (String newValue) {
                        setState(() {
                          extra_month = newValue;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text("1"),
                          value: '1',
                        ),
                        DropdownMenuItem(
                          child: Text("2"),
                          value: '2',
                        ),
                        DropdownMenuItem(
                          child: Text("3"),
                          value: '3',
                        ),
                        DropdownMenuItem(
                          child: Text("4"),
                          value: '4',
                        ),
                        DropdownMenuItem(
                          child: Text("5"),
                          value: '5',
                        ),
                        DropdownMenuItem(
                          child: Text("6"),
                          value: '6',
                        ),
                      ],
                    ),
                  ),
                )))
      ],
    );
  }

  void changeFreeExtenderCheak(value) async {
    setState(() {
      freeExtender = !freeExtender;
      free_extender = null;
    });
  }

  Widget extenderFree() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: freeExtender,
            onChanged: (value) {
              changeFreeExtenderCheak(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "Postpaid.free_extender".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildextenderFree() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.free_extender".tr().toString(),
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
            child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptyFreeExtender == true
                        ? Color(0xFFB10000)
                        : Color(0xFFD1D7E0),
                  ),
                ),
                child: DropdownButtonHideUnderline(
                  child: ButtonTheme(
                    alignedDropdown: true,
                    child: DropdownButton<String>(
                      hint: Text(
                        "Personal_Info_Edit.select_an_option".tr().toString(),
                        style: TextStyle(
                          color: Color(0xFFA4B0C1),
                          fontSize: 14,
                        ),
                      ),
                      dropdownColor: Colors.white,
                      icon: Icon(Icons.keyboard_arrow_down_rounded),
                      iconSize: 30,
                      iconEnabledColor: Colors.grey,
                      underline: SizedBox(),
                      isExpanded: true,
                      style: TextStyle(
                        color: Color(0xFF11120e),
                        fontSize: 14,
                      ),
                      value: free_extender,
                      onChanged: (String newValue) {
                        setState(() {
                          free_extender = newValue;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          child: Text("1"),
                          value: '1',
                        ),
                        DropdownMenuItem(
                          child: Text("2"),
                          value: '2',
                        ),
                      ],
                    ),
                  ),
                )))
      ],
    );
  }

  /////////////////////////////////New 17/3/2023///////////////////////////////////////////
  void LookupON_Reseller() async{
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
        print("/********************************************************************/");
        print(options_Reseller );
        print("/********************************************************************/");

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
  /////////////////////////////////////End New/////////////////////////////////////////////
  /*.................................................New 17/4/2023..............................................................*/
  void changeCLAIM(value) async {
    setState(() {
      claim = !claim;
    });
    print(claim);

  }

  Widget buildON_CLAIM() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: claim,
            onChanged: (value) {
              changeCLAIM(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "Postpaid.CLAIM".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  void changeON_Reseller(value) async {
    setState(() {
      reseller = !reseller;
      selectedReseller=null;
      selectedReseller_key=null;
      selectedReseller_Value=null;
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
            activeColor: Color(0xFF392156),
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
              children: <TextSpan>[
                role=="DeliveryEShop"?  TextSpan(
                  text: ' * ',
                  style: TextStyle(
                    color: Color(0xFFB10000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ):TextSpan(
                  text: '',
                  style: TextStyle(
                    color: Color(0xFFB10000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]
          ),
        ),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.only(left: 10,right: 5),
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
            child:DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  cursorColor: Color(0xFF392156),


                ),

              ),
              items: Reseller_Value,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:  Color(0xFFD1D7E0)),
                  ),


                  hintText:  "Personal_Info_Edit.select_an_option".tr().toString(),
                  hintStyle: TextStyle(
                    color: Color(0xFFA4B0C1),
                    fontSize: 14,),

                ),
              ),
              onChanged:(val){
                print(val);
                getKeySelectedReseller(val);

              },

              selectedItem: selectedReseller_Value,
            )),
        emptyselectedReseller == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required"
                .tr()
                .toString()) : Container(),
      ],
    );
  }


  void getKeySelectedReseller(val){
    for (var i = 0; i < options_Reseller.length; i++) {
      if(options_Reseller[i]['value'].contains(val)){
        setState(() {
          selectedReseller_key=options_Reseller[i]['key'];
        });
        print(selectedReseller_key);
      }else{
        continue;
      }
    }
  }

  /*....................................................End New ................................................................*/



  /////////////////////////////////New 22/3/2023///////////////////////////////////////////
  void LookupON_BEHALF() async{
    print("/Lookup/ON_BEHALF");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lookup/ON_BEHALF';
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
          options_BEHALF = result["data"];
        });
        for (var i = 0; i < result['data'].length; i++) {

          BEHALF_Value.add(result['data'][i]['value'].toString());

        }
        print("/********************************************************************/");
        print(options_BEHALF );
        print("/********************************************************************/");

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
  /////////////////////////////////////End New/////////////////////////////////////////////
  /*.................................................New 22/3/2023..............................................................*/

  void changeON_BEHALF(value) async {
    setState(() {
      on_BEHALF = !on_BEHALF;
      selectedBEHALF=null;
      selectedBEHALF_key=null;
      selectedBEHALF_Value=null;
    });
    print(on_BEHALF);

  }

  Widget buildON_BEHALF() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: on_BEHALF,
            onChanged: (value) {
              changeON_BEHALF(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "Postpaid.ON_BEHALF".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildSelect_BEHALF() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: "Postpaid.ON_BEHALF".tr().toString(),
              style: TextStyle(
                color: Color(0xFF11120E),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                role=="DeliveryEShop"?  TextSpan(
                  text: ' * ',
                  style: TextStyle(
                    color: Color(0xFFB10000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ):TextSpan(
                  text: '',
                  style: TextStyle(
                    color: Color(0xFFB10000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]
          ),
        ),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.only(left: 10,right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyselectedBEHALF == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child:DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  cursorColor: Color(0xFF392156),


                ),

              ),
              items: BEHALF_Value,
              dropdownDecoratorProps: DropDownDecoratorProps(
                dropdownSearchDecoration: InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color:  Color(0xFFD1D7E0)),
                  ),


                  hintText:  "Personal_Info_Edit.select_an_option".tr().toString(),
                  hintStyle: TextStyle(
                    color: Color(0xFFA4B0C1),
                    fontSize: 14,),

                ),
              ),
              onChanged:(val){
                print(val);
                getKeySelected(val);

              },

              selectedItem: selectedBEHALF_Value,
            )),
        emptyselectedBEHALF == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required"
                .tr()
                .toString()) : Container(),
      ],
    );
  }

  void getKeySelected(val){
    for (var i = 0; i < options_BEHALF.length; i++) {
      if(options_BEHALF[i]['value']==val){
        setState(() {
          selectedBEHALF_key=options_BEHALF[i]['key'];
        });
        print(selectedBEHALF_key);
      }else{
        continue;
      }
    }
  }

  /*....................................................End New ................................................................*/
  /*......................................................new...................................................................*/
  void changeValidateSalesLeadBy(value) async {
    setState(() {
     // switchValidateSalesLead = !switchValidateSalesLead;
      switchValidateSalesLead=true;
      optionValue = "Postpaid.EshopOrderNO".tr().toString();
      salesLeadType = 2;
     // optionValue=null;
    });

  }

  Widget buildValidateSalesLeadBy() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: switchValidateSalesLead,
            onChanged: null/*(value) {
              changeValidateSalesLeadBy(value);
            }*/,
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "Postpaid.ValidateSalesLeadBy".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  /*Widget buildSalesLeadOptions() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      RichText(
        text: TextSpan(
          text: "Postpaid.SelectSalesLead".tr().toString(),
          style: TextStyle(
            color: Color(0xff11120e),
            fontSize: 14,
            fontWeight: FontWeight.normal,
          ),
        ),
      ),
      SizedBox(height: 10),
      Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              //color: Color(0xFFB10000), red color
              color:
              emptyOption == true ? Color(0xFFB10000) : Color(0xFFD1D7E0),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton<String>(
                hint: Text(
                  "Personal_Info_Edit.select_an_option".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFFA4B0C1),
                    fontSize: 14,
                  ),
                ),
                dropdownColor: Colors.white,
                icon: Icon(Icons.keyboard_arrow_down_rounded),
                iconSize: 30,
                iconEnabledColor: Colors.grey,
                underline: SizedBox(),
                isExpanded: true,
                style: TextStyle(
                  color: Color(0xFF11120e),
                  fontSize: 14,
                ),
                value: optionValue,
                onChanged: (String newValue) {
                  setState(() {
                    optionValue = newValue;
                  });
                  if (optionValue == "Postpaid.LCMSalesLead".tr().toString()) {
                    setState(() {
                      salesLeadType = 1;
                    });
                    print("/*********************************************/");
                    print(optionValue);
                    print(salesLeadType);
                    print("/*********************************************/");
                  }
                  if (optionValue == "Postpaid.EshopOrderNO".tr().toString()) {
                    setState(() {
                      salesLeadType = 2;
                    });

                    print("/*********************************************/");
                    print(optionValue);
                    print(salesLeadType);
                    print("/*********************************************/");
                  }
                },
                items: sellectSalesLeadOption.map((valueItem) {
                  return DropdownMenuItem<String>(
                    value: valueItem,
                    child: EasyLocalization.of(context).locale ==
                        Locale("en", "US")
                        ? Text(valueItem)
                        : Text(valueItem),
                  );
                }).toList(),
              ),
            ),
          )),
      SizedBox(height: 10),
    ]);
  }*/
  Widget buildSalesLeadOptions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.SelectSalesLead".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: '',
                style: TextStyle(
                  color: Colors.transparent,
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
            controller: sellectSalesLead,

            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            enabled: false,
            keyboardType: TextInputType.text,
            /* inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp('[a-z A-Z á-ú Á-Ú]')),
            ],*/

            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        )
      ],
    );
  }

  Widget buildLCM_SalesLeadTicket() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: salesLeadType==1? "Postpaid.LCM_Ticket".tr().toString():"Postpaid.EshopOrderNO_Ticket".tr().toString(),
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
            controller: salesLeadValue,

            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            enabled: false,
            keyboardType: TextInputType.text,
            /* inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp('[a-z A-Z á-ú Á-Ú]')),
            ],*/

            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
        )
      ],
    );
  }

/*.........................................................End new..............................................................*/
/*..................................................New 12/6/2023...............................................................*/
  Widget buildUserNote(){
    return  Container(

      color: Colors.white,
      padding: EdgeInsets.all(10),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Basic_Info_Edit.Note"
                    .tr()
                    .toString(),
                style: TextStyle(
                  color: Color(0xff11120e),
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),

              ),
            ),
            SizedBox(height: 10),
            Container(
              alignment: Alignment.centerLeft,
              height: 100,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: 3, // <-- SEE HERE
                minLines: 3,
                // <-- SEE HERE
                inputFormatters: [
                  new LengthLimitingTextInputFormatter(101), /// here char limit is 5
                ],
                controller: notes,
                //  keyboardType: TextInputType.phone,
                style: TextStyle(color: Color(0xff11120e)),
                decoration: InputDecoration(
                  enabledBorder:
                  maximumcharacter == true
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
                  focusedBorder:    maximumcharacter == true?OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFFB10000), width: 1.0),
                  ): OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF4F2565), width: 1.0),
                  ),
                  contentPadding: EdgeInsets.all(16),
                  hintText:"Basic_Info_Edit.Enter_Note"
                      .tr()
                      .toString(),
                  hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                ),
                onChanged: (value){
                  //Checking if the value's length is less than 4, if it is, it should be type `text`.
                  if( value.length > 100) {
                    print(value.length);
                    print(maximumcharacter);
                    /*  Fluttertoast.showToast(
                      msg: "This Note is to long",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );*/
                    setState(() {
                      maximumcharacter=true;
                    });

                    /* showToast("Notifications_Form.switch_required".tr().toString(),
                      context: context,
                      animation: StyledToastAnimation.scale,
                      fullWidth: true,
                  position: );*/
                    /*  content: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? englishMessage
                          : arabicMessage,
                  setState(() => keyboardType = TextInputType.text);*/
                  } else {
                    //Else, it should be type `number`
                    /*setState(() => keyboardType = TextInputType.number);*/
                    setState(() {
                      maximumcharacter=false;
                    });
                    print(notes.text);
                  }
                },
              ),
            ),
            maximumcharacter == true
                ? ReusableRequiredText(
                text:  "Basic_Info_Edit.Maximum_Characters"
                    .tr()
                    .toString())
                : Container(),
            SizedBox(height: 5),

          ],
        ),
      ),);
  }
/*.........................................................End new..............................................................*/

  /******** for back button on mobile tap ******/
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
       Navigator.pop(context);
   //   Navigator.of(context).pop();
     // Navigator.of(context, rootNavigator: true).pop();

     /* Navigator.push(context, MaterialPageRoute(builder: (_) =>  NationalityList(
          this.PermessionDeliveryEShop,
          this.role,
          this.orderID,
          this.packageName,
          this.packageCode,
          this.marketType),));*/



    /*  Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => NationalityList(
              this.PermessionDeliveryEShop,
              this.role,
              this.orderID,
              this.packageName,
              this.packageCode,
              this.marketType),
        ),
      );*/

      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostpaidGenerateContractBloc,
        PostpaidGenerateContractState>(
      listener: (context, state) async {
        if (state is PostpaidGenerateContractErrorState) {
          showAlertDialog(context, state.arabicMessage, state.englishMessage);
          setState(() {
            isDisabled = false;
          });
          //unReservedLineBloc.add(UnPressReservedLineEvent(kitCode:data['kitCode'].toString()));
        }
        if (state is PostpaidGenerateContractSuccessState) {
          setState(() {
            isDisabled = false;
          });
          var dir = await getApplicationDocumentsDirectory();
          File file = new File("${dir.path}/data.pdf");
          // file.writeAsBytesSync(state.filePath['result'].bodyBytes, flush: true);


          print(state.filePath);
          print(state.filePath);

          Uint8List decodedbytes = base64.decode(state.filePath);
          Uint8List decodedbytes1 = base64Decode(state.filePath);
          //file.writeAsBytesSync(bytes, flush: true);
          print(decodedbytes1);
          file.writeAsBytesSync(decodedbytes1, flush: true);
/************************************************start From Hear **********************************/
       Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractDetails(
                PermessionDeliveryEShop: PermessionDeliveryEShop,
                role: role,
                orderID :orderID,
                packageName:packageName,
                FileEPath: file.path,
                isJordainian: isJordainian,
                marketType: marketType,
                packageCode: packageCode,
                msisdn: msisdn,
                nationalNumber: nationalNumber,
                passportNumber: null,
                userName: userName,
                password: password,
                firstName: null,
                secondName: null,
                lastName: null,
                birthdate: null,
                referenceNumber: referenceNumber.text,
                referenceNumber2: referenceNumber2.text,
                isMigrate: isMigrate,
                mbbMsisdn: mbbMsisdn.text,
                frontImg: img64Front,
                backImg: img64Back,
                passprotImg: null,
                locationImg: img64Location,
                buildingCode: buildingCode.text,
                extraFreeMonths: extra_month,
                extraExtender: free_extender,
                simCard: null,
                contractImageBase64: null,
                salesLeadType: salesLeadType,
                salesLeadValue: salesLeadValue.text,
                onBehalfUser:selectedBEHALF_key==null?"":selectedBEHALF_key,
                resellerID :selectedReseller_key==null?"":selectedReseller_key,
                isClaimed:claim,
                backPassportImageBase64:null,
                note: notes.text,
                  scheduledDate:"",
                  documentExpiryDate:documentExpiryDate.text
           ),
            ),
          );
        }
      },
      child: WillPopScope(child:GestureDetector(
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
              centerTitle: false,
              title: Text(
                "Postpaid.CustomerInformation".tr().toString(),
              ),
              backgroundColor: Color(0xFF392156),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: SingleChildScrollView(
              child: Column(
                  children: <Widget>[
                    Container(
                      height: 50,
                      padding: EdgeInsets.only(top: 2),
                      child: ListTile(
                        leading: Container(
                          width: 280,
                          child: Text(
                            "Profile_Form.personal_information".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                buildOrderID(),
                                SizedBox(height: 10),
                                buildMarketType(),
                                SizedBox(height: 10),
                                // buildPackageName(),
                                /******************************New 9-8-2023***********************************/
                                buildSelect_Packge(),
                                SizedBox(height: 10),
                                /******************************End New 9-8-2023***********************************/
                                buildPackageCode(),
                                SizedBox(height: 10),
                                /*.............................Document Expiry Date 12/6/2024.......................*/
                                buildDocumentExpiryDate(),
                                SizedBox(height: 10,),
                                /*..................................................................................*/
                                buildNationalNumber(),
                                SizedBox(height: 10),
                                buildMSISDNNumber(),
                                emptyMSISDN == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                SizedBox(height: 10),
                                buildUserName(),
                                emptyUserName == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                SizedBox(height: 10),
                                buildPassword(),
                                emptyPassword == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                SizedBox(height: 10),

                                buildReferenceNumber(),
                                emptyReferenceNumber == true
                                    ? ReusableRequiredText(
                                    text:
                                    "Jordan_Nationality.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                errorReferenceNumber == true
                                    ? ReusableRequiredText(
                                    text: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? "Your MSISDN should be 10 digit and valid"
                                        : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح ")
                                    : Container(),
                                successFlag == true && clearSucssesFlag==1
                                    ? Container(
                                    padding: EdgeInsets.only(top: 5),
                                    alignment:
                                    EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Alignment.bottomLeft
                                        : Alignment.bottomRight,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: new Icon(
                                              Icons.assignment_turned_in,
                                              size: 14,
                                              color: Color(0xFF4BB543),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            "Jordan_Nationality.Verify_Number_Successfully"
                                                .tr()
                                                .toString(),
                                            style: TextStyle(
                                              color: Color(0xFF4BB543),
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                    : Container(),

                                // reference number 2

                                SizedBox(
                                  height: 10,
                                ),
                                buildReferenceNumber2(),
                                emptySecondReferenceNumber == true
                                    ? ReusableRequiredText(
                                    text:
                                    "Jordan_Nationality.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                errorSecondReferenceNumber == true
                                    ? ReusableRequiredText(
                                    text: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? "Your MSISDN should be 10 digit and valid"
                                        : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح ")
                                    : Container(),
                                duplicateSecondReferenceNumber == true
                                    ? ReusableRequiredText(
                                    text: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? 'Please insert another reference number'
                                        : 'الرجاء إدخال رقم مرجعي آخر')
                                    : Container(),

                                successFlagSecondeReferancenumber == true
                                    ? Container(
                                    padding: EdgeInsets.only(top: 5),
                                    alignment:
                                    EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? Alignment.bottomLeft
                                        : Alignment.bottomRight,
                                    child: RichText(
                                      text: TextSpan(
                                        children: [
                                          WidgetSpan(
                                            child: new Icon(
                                              Icons.assignment_turned_in,
                                              size: 14,
                                              color: Color(0xFF4BB543),
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                            "Jordan_Nationality.Verify_Number_Successfully"
                                                .tr()
                                                .toString(),
                                            style: TextStyle(
                                              color: Color(0xFF4BB543),
                                              fontSize: 12,
                                              fontWeight: FontWeight.normal,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ))
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                isMigrate == true ? buildmbbMSISDN() : Container(),
                                isMigrate == true && emptyMBBMSISDN == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),


                                ////////////////New 30 Aug 2023////////////////////////////////////////

                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 12, bottom: 5),
                                  child: buildSalesLeadOptions(),
                                ),
                                Container(
                                    color: Colors.white,
                                    padding: EdgeInsets.only(
                                        left: 5, right: 5, top: 5, bottom: 8),
                                    child: buildLCM_SalesLeadTicket()),



                                //////////////// end New////////////////////////////////////////
                                ////////////////New 17/4/2022////////////////////////////////////////
                                PermessionDeliveryEShop.contains('12.01.01.01') == true && reseller == true?
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left:0, right:0, top: 12, bottom: 10),
                                  child: buildSelect_Reseller(),
                                )
                                    : Container(),
                                ////////////////New 22/3/2022////////////////////////////////////////
                                PermessionDeliveryEShop.contains("12.01.01.02")==true&&   on_BEHALF == true
                                    ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 12, bottom: 5),
                                  child: buildSelect_BEHALF(),
                                )
                                    : Container(),
                                PermessionDeliveryEShop.contains("12.01.01.02")==true&&   on_BEHALF == true?SizedBox(
                                  height: 20,
                                ):SizedBox(
                                  height: 1,
                                ),
                                ////////////////////////////end new////////////////////////////////////

                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 8),
                        child: buildEnableMBB()),

                    ////////////////New////////////////////////////////////////

                    PermessionDeliveryEShop.contains("12.01.01.04")==true?Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 8),
                        child: buildValidateSalesLeadBy()):Container(),

                    //////////////// end New////////////////////////////////////////
                    ///////////////////22/3/2023///////////////////////////////////
                    PermessionDeliveryEShop.contains("12.01.01.02")==true?Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 8),
                        child: buildON_BEHALF()):Container(),




                    //////////////// end New////////////////////////////////////////
                    ////////////////New 17/4/2022////////////////////////////////////////
                    role=="DeliveryEShop"&& PermessionDeliveryEShop.contains('12.01.01.01')== true?  Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 8,top: 4),
                        child: buildON_Reseller()):Container(),

                    /*  PermessionDeliveryEShop.contains('05.02.01.06') == true?  Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 8,top:4),
                  child: buildON_CLAIM()):Container(),*/


                    //////////////// end New////////////////////////////////////////


                    Container(
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
                    ),
                    Container(child: buildImageIdFront()),
                    Container(
                      height: 60,
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
                    ),
                    Container(
                      child: buildImageIdBack(),
                    ),
                    Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 8),
                      child: ListTile(
                        leading: Container(
                          width: 280,
                          child: Text(
                            "Postpaid.address_information".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                buildAreaName(),
                                SizedBox(height: 10),
                                emptyArea == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                buildStreetName(),
                                emptyStreet == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                SizedBox(height: 10),
                                buildBuildingName(),
                                emptyBuilding == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                SizedBox(height: 10),
                                buildBuildingCode(),
                                emptyBuildinCode == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container()
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    role == 'Subdealer'
                        ? Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 8),
                      child: ListTile(
                        leading: Container(
                          width: 280,
                          child: Text(
                            "Postpaid.location_photo".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        trailing: _loadIdLocation == true
                            ? Container(
                          child: IconButton(
                              icon: Icon(Icons.delete),
                              color: Color(0xff0070c9),
                              onPressed: () => {clearImageLocation()}),
                        )
                            : null,
                      ),
                    )
                        : Container(),
                    role == 'Subdealer'
                        ? Container(
                      child: buildImageLoction(),
                    )
                        : Container(),
                    PermessionDeliveryEShop.contains('05.02.02.02')
                        ? Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 8),
                      child: ListTile(
                        leading: Container(
                          width: 280,
                          child: Text(
                            "Postpaid.other_information".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                        : Container(),
                    PermessionDeliveryEShop.contains('05.02.02.03')
                        ? Container(
                      color: Colors.white,
                      padding: EdgeInsets.only(left: 0, right: 0),
                      child: Column(
                        children: <Widget>[
                          Container(
                            alignment: Alignment.centerLeft,
                            child: Column(
                              children: <Widget>[
                                SizedBox(
                                  height: 10,
                                ),
                                extraFreeMonths(),
                                SizedBox(
                                  height: 20,
                                ),
                                extraMonth == true
                                    ? Container(
                                    padding:
                                    EdgeInsets.only(left: 15, right: 15),
                                    child: buildExtraMonths())
                                    : Container(),
                                extraMonth == true && emptyExtraFreeMonth == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                SizedBox(
                                  height: 20,
                                ),
                                extenderFree(),
                                SizedBox(
                                  height: 20,
                                ),
                                freeExtender == true
                                    ? Container(
                                    padding:
                                    EdgeInsets.only(left: 15, right: 15),
                                    child: buildextenderFree())
                                    : Container(),
                                freeExtender == true && emptyFreeExtender == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    )
                        : Container(),
                    /* SizedBox(height: 20),
              buildUserNote(),*/
                    SizedBox(height: 20),
                    msg,
                    Container(
                        height: 48,
                        width: 300,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: Color(0xFF392156),
                        ),
                        child: TextButton(
                          onPressed: isDisabled == true
                              ? null
                              : () async {
                            print(UserName.text);
                            if (UserName.text == '') {
                              setState(() {
                                emptyUserName = true;
                              });
                            }
                            if (UserName.text != '') {
                              setState(() {
                                emptyUserName = false;
                              });
                            }

                            if (Password.text == '') {
                              setState(() {
                                emptyPassword = true;
                              });
                            }
                            if (Password.text != '') {
                              setState(() {
                                emptyPassword = false;
                              });
                            }

                            if (referenceNumber.text == '') {
                              setState(() {
                                emptyReferenceNumber = true;
                              });
                            }

                            if (referenceNumber.text != '') {
                              setState(() {
                                emptyReferenceNumber = false;
                              });
                              if (referenceNumber.text.length != 10) {
                                setState(() {
                                  errorReferenceNumber = true;
                                });
                              } else {
                                setState(() {
                                  errorReferenceNumber = false;
                                });
                              }
                            }
                            if(documentExpiryDate.text ==""){
                              setState(() {
                                emptyDocumentExpiryDate = true;
                              });
                            }
                            if(documentExpiryDate.text !=""){
                              setState(() {
                                emptyDocumentExpiryDate = false;
                              });
                            }
                            if (referenceNumber2.text == '') {
                              setState(() {
                                emptySecondReferenceNumber = true;
                              });
                            } else if (referenceNumber2.text != '') {
                              setState(() {
                                emptySecondReferenceNumber = false;
                              });
                              if (referenceNumber2.text == referenceNumber.text) {
                                setState(() {
                                  duplicateSecondReferenceNumber = true;
                                });
                              } else {
                                setState(() {
                                  duplicateSecondReferenceNumber = false;
                                });
                              }

                              if (referenceNumber2.text.length != 10) {
                                setState(() {
                                  errorSecondReferenceNumber = true;
                                });
                              } else {
                                setState(() {
                                  errorSecondReferenceNumber = false;
                                });
                              }
                            }
                            if(PermessionDeliveryEShop.contains("12.01.01.04")==true){
                              if (switchValidateSalesLead == true) {
                                if (optionValue == null) {
                                  setState(() {
                                    emptyOption = true;
                                  });
                                }
                                if (optionValue != null) {
                                  setState(() {
                                    emptyOption = false;
                                  });
                                }
                                if (salesLeadValue.text == "") {
                                  setState(() {
                                    emptysalesLeadValue = true;
                                  });
                                }
                                if (salesLeadValue.text != "") {
                                  setState(() {
                                    emptysalesLeadValue = false;
                                  });
                                }
                              }
                              if (switchValidateSalesLead == false) {
                                setState(() {
                                  emptysalesLeadValue = false;
                                  emptyOption = false;
                                });
                              }

                            }
                            else{
                              setState(() {
                                emptysalesLeadValue = false;
                                emptyOption = false;
                              });
                            }

                            if (role == 'Subdealer') {
                              if (area == null) {
                                setState(() {
                                  emptyArea = true;
                                });
                              }
                              if (area != null) {
                                setState(() {
                                  emptyArea = false;
                                });
                              }
                              if (street == null) {
                                setState(() {
                                  emptyStreet = true;
                                });
                              }
                              if (street != null) {
                                setState(() {
                                  emptyStreet = false;
                                });
                              }
                              if (building == null) {
                                setState(() {
                                  emptyBuilding = true;
                                });
                              }
                              if (building != null) {
                                setState(() {
                                  emptyBuilding = false;
                                });
                              }
                            } else {
                              if (buildingCode.text == '') {
                                setState(() {
                                  emptyBuildinCode = true;
                                });
                              }
                              if (buildingCode.text != '') {
                                setState(() {
                                  emptyBuildinCode = false;
                                });
                              }
                            }

                            if (isMigrate == true) {
                              if (mbbMsisdn.text == '') {
                                setState(() {
                                  emptyMBBMSISDN = true;
                                });
                              }
                              if (mbbMsisdn.text != '') {
                                setState(() {
                                  emptyMBBMSISDN = false;
                                });
                              }
                            }
                            if (isMigrate == false) {
                              setState(() {
                                emptyMBBMSISDN = false;
                              });
                            }

                            if (role == 'Subdealer') {
                              if (img64Location == null) {
                                setState(() {
                                  imageLocationRequired = true;
                                });
                              }
                              if (img64Location != null) {
                                setState(() {
                                  imageLocationRequired = false;
                                });
                              }
                            }

                            if (PermessionDeliveryEShop.contains('05.02.02.03')) {
                              if (extra_month == null) {
                                setState(() {
                                  emptyExtraFreeMonth = true;
                                });
                              }
                              if (extra_month != null) {
                                setState(() {
                                  emptyExtraFreeMonth = false;
                                });
                              }
                            }
                            if (PermessionDeliveryEShop.contains('05.02.02.02')) {
                              if (free_extender == null) {
                                setState(() {
                                  emptyFreeExtender = true;
                                });
                              }
                              if (free_extender != null) {
                                setState(() {
                                  emptyFreeExtender = false;
                                });
                              }
                            }

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
                            /////////////////////////////////////////////new 17-4-2023///////////////////////////////////////
                            if(role=="DeliveryEShop"){
                              if(on_BEHALF==true){
                                if(selectedBEHALF_key==null){
                                  setState(() {
                                    emptyselectedBEHALF=true;
                                  });
                                }
                                else{
                                  setState(() {
                                    emptyselectedBEHALF=false;
                                  });
                                }
                              }

                              if(reseller==true){
                                if(selectedReseller_key==null){
                                  setState(() {
                                    emptyselectedReseller=true;
                                  });
                                }
                                else{
                                  setState(() {
                                    emptyselectedReseller=false;
                                  });
                                }
                              }
                            }
                            ///////////////////////////////////////////////////////////////////////////////////////////////
                            ////////////////////////////////////////////////////////////////////////////////new 17-4-023/////////////////////////////////////////////////////////////////////
                            if(role=="DeliveryEShop"){
                              print("PPPPPPPPP");

                              if(on_BEHALF==true && reseller==false){
                                print("PPPPPPPPPjjjjjj");
                                showToast("Notifications_Form.switch_required".tr().toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);


                              }
                              if(on_BEHALF==false && reseller==true ){
                                showToast("Notifications_Form.switch_required".tr().toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);

                              }



                              if(on_BEHALF==true && reseller==true){
                                if (
                                duplicateSecondReferenceNumber == false &&
                                    buildingCode.text != null &&
                                    img64Front != null &&
                                    img64Back != null &&
                                    img64Location != null &&
                                    referenceNumber.text != '' &&
                                    documentExpiryDate.text !=''&&
                                    UserName.text != '' &&
                                    Password.text != '' &&
                                    referenceNumber2.text != '' &&
                                    selectedBEHALF_key !=null&&
                                    selectedReseller_key !=null) {
                                  showAlertDialogSaveData(
                                      context,
                                      'هل أنت متأكد من حفظ البيانات',
                                      'Are you sure you want to save data');
                                }else{
                                  showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                      context: context,
                                      animation: StyledToastAnimation.scale,
                                      fullWidth: true);
                                }
                              }
                              if(on_BEHALF==false && reseller==false){
                                showAlertDialogSaveData(
                                    context,
                                    'هل أنت متأكد من حفظ البيانات',
                                    'Are you sure you want to save data');

                              }

                            }
                            ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                            if(switchValidateSalesLead==true){
                              if (isMigrate == true) {
                                if (role == 'Subdealer') {
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          area != null &&
                                          street != null &&
                                          building != null &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          area != null &&
                                          street != null &&
                                          building != null &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          area != null &&
                                          street != null &&
                                          building != null &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          area != null &&
                                          street != null &&
                                          building != null &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '') {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  }
                                } else if (role != 'Subdealer' && role!="DeliveryEShop") {
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          mbbMsisdn.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '') {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  }
                                }
                              }
                              else if (isMigrate == false) {
                                if (role == 'Subdealer') {
                                  if (duplicateSecondReferenceNumber == false &&
                                      area != null &&
                                      street != null &&
                                      building != null &&
                                      img64Front != null &&
                                      img64Back != null &&
                                      img64Location != null &&
                                      referenceNumber.text != '' &&
                                      documentExpiryDate.text !=''&&
                                      optionValue!=null &&
                                      salesLeadValue.text!=""&&
                                      UserName.text != '' &&
                                      Password.text != '' &&
                                      referenceNumber2.text != '') {
                                    showAlertDialogSaveData(
                                        context,
                                        'هل أنت متأكد من حفظ البيانات',
                                        'Are you sure you want to save data');
                                  }
                                } else if (role != 'Subdealer' && role!="DeliveryEShop") {
                                  print('hey');
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    print('hello');
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else if (freeExtender == false) {
                                      print('hello2');
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '') {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  }
                                }
                              }
                            }

                            else if(switchValidateSalesLead==false){
                              if (isMigrate == true) {
                                if (role == 'Subdealer') {
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          area != null &&
                                          street != null &&
                                          building != null &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else if
                                    (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          area != null &&
                                          street != null &&
                                          building != null &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&

                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          area != null &&
                                          street != null &&
                                          building != null &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          optionValue!=null &&

                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          area != null &&
                                          street != null &&
                                          building != null &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '') {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  }
                                } else if (role != 'Subdealer' && role!="DeliveryEShop") {
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          referenceNumber.text != '' &&
                                          img64Location != null &&
                                          documentExpiryDate.text !=''&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          referenceNumber.text != '' &&
                                          img64Location != null &&
                                          documentExpiryDate.text !=''&&
                                          mbbMsisdn.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          img64Location != null &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    } else {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          img64Location != null &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '') {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }
                                    }
                                  }
                                }
                              }
                              else if (isMigrate == false) {
                                if (role == 'Subdealer') {
                                  if (duplicateSecondReferenceNumber == false &&
                                      area != null &&
                                      street != null &&
                                      building != null &&
                                      img64Front != null &&
                                      img64Back != null &&
                                      img64Location != null &&
                                      referenceNumber.text != '' &&
                                      documentExpiryDate.text !=''&&

                                      UserName.text != '' &&
                                      Password.text != '' &&
                                      referenceNumber2.text != '') {
                                    showAlertDialogSaveData(
                                        context,
                                        'هل أنت متأكد من حفظ البيانات',
                                        'Are you sure you want to save data');
                                  }else{
                                    showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }
                                } else if (role != 'Subdealer' && role!="DeliveryEShop") {
                                  print('hey');
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          img64Location != null &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          referenceNumber.text != '' &&
                                          img64Location != null &&
                                          documentExpiryDate.text !=''&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          extra_month != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    print('hello');
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          img64Location != null &&
                                          referenceNumber.text != '' &&
                                          documentExpiryDate.text !=''&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          free_extender != null) {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    } else if (freeExtender == false) {
                                      print('hello2');
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Front != null &&
                                          img64Back != null &&
                                          referenceNumber.text != '' &&
                                          img64Location != null &&
                                          documentExpiryDate.text !=''&&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '') {
                                        showAlertDialogSaveData(
                                            context,
                                            'هل أنت متأكد من حفظ البيانات',
                                            'Are you sure you want to save data');
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    }
                                  }
                                }
                              }
                            }

                          },
                          style: TextButton.styleFrom(
                            backgroundColor: Color(0xFF392156),
                            shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(24))),
                          ),
                          child: Text(
                            "Postpaid.Next".tr().toString(),
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(height: 30),
                  ]
              ),
            )),
      ) ,onWillPop:onWillPop ,)
    );
  }
}

//////
/**/
