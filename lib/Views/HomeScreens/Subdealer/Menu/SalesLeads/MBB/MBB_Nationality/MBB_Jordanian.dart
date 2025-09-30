import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_view/photo_view.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/MBB/Contract/BroadBand_contractDetails.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
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

import '../../../../CustomBottomNavigationBar.dart';



class MBB_Jordanian extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var ticketID;
  var ticketNumber;
  var packageName;
  String packageCode;
  String marketType;
  var msisdn;

  String nationalNumber;
  String passportNumber;


  var userName;


  var password;

  bool sendOtp;


  MBB_Jordanian(
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.ticketID,
      this.ticketNumber,
      this.packageName,
      this.packageCode,
      this.marketType ,

      );

  @override
  _MBB_JordanianState createState() => _MBB_JordanianState(
    this.Permessions,
    this.role,
    this.outDoorUserName,
    this.ticketID,
    this.ticketNumber,

    this.packageName,
    this.packageCode,
    this.marketType ,
  );
}

class Item {
  const Item(this.value, this.textEn, this.textAr);

  final String value;
  final String textEn;
  final String textAr;
}

class _MBB_JordanianState extends State<MBB_Jordanian> {

  var role;
  var outDoorUserName;
  final List<dynamic> Permessions;
  var ticketID;
  var  ticketNumber;

  var packageName;

  var msisdn;
  var passportNumber;
  var nationalNumber;
  String packageCode;

  var price;
  var sendOtp;

  var userName;

  final picker = ImagePicker();
  File imageFile;
  File imageFileIDFront;
  File imageFileIDBack;

  String img64Front;
  String img64Back;
  String img64SerialDevice;

  String localPath;
  bool isAgree = false;

  var password;
  String marketType;
  String _serialCode = "";

  bool isJordainian = true;

  APP_URLS urls = new APP_URLS();



  _MBB_JordanianState(
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.ticketID,
      this.ticketNumber,
      this.packageName,
      this.packageCode,
      this.marketType ,
      );
  /***********************New 9-8-2023****************************************************************************************************/
  var old_packageCode;
  TextEditingController ticketNum = TextEditingController();
  TextEditingController MarketType = TextEditingController();
  TextEditingController PackageName = TextEditingController();
  TextEditingController PackageCode = TextEditingController();
  TextEditingController sellectSalesLead = TextEditingController();
  TextEditingController referenceNumber2 = TextEditingController();
  TextEditingController buildingCode = TextEditingController();



  var options_PACKGE =[];
  List <String> PACKGE_Value=[];
  bool on_ChangePackge=false;
  var selectedPackge_Key;
  var selectedPackge_Value=null;
  bool emptyselectedPackege = false;

  bool emptySecondReferenceNumber = false;
  bool errorSecondReferenceNumber = false;
  bool duplicateSecondReferenceNumber = false;

  /*************************************************************************************************************************************/
  TextEditingController NationalNumber = TextEditingController();
  TextEditingController MSISDN = TextEditingController();
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController kitCode = TextEditingController();
  TextEditingController simCard = TextEditingController();
  TextEditingController SerialNumber = TextEditingController();
  TextEditingController isParentEligibleShow = TextEditingController();
  TextEditingController OnBehalfId = TextEditingController();
  TextEditingController ResellerId= TextEditingController();
  TextEditingController CustomerAdress= TextEditingController();
  TextEditingController deviceName = TextEditingController();
  TextEditingController deviceSerial  = TextEditingController();
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
  bool emptyReferenceNumber = false;
  bool errorReferenceNumber = false;



  bool imageIDFrontRequired = false;
  bool imageIDBackRequired = false;

  bool imageSerialDeviceRequired = false;

  bool showCircular = false;
  String packagesSelect;

  bool emptySimCard = false;
  bool errorSimCard = false;

  bool emptySerialNumber = false;
  bool errorSerialNumber = false;




  File imageFileFrontID;
  bool _loadIdFront = false;
  var pickedFileFrontId;

  File imageFileBackID;
  bool _loadIdBack = false;
  var pickedFileBackId;

  File imageFileSerialDevice;
  bool _loadSerialDevice = false;
  var pickedFileSerialDevice;

  bool isDisabled = false;
  bool isDisabledUnsucss = false;
  bool isDisabledDeliveryInProgress = false;


  int imageWidth = 200;
  int imageHeight = 200;

  final _picker = ImagePicker();
  DateTime backButtonPressedTime;
  /////////////////////////////////New 22/3/2023///////////////////////////////////////////
  bool on_BEHALF = false;
  var options_BEHALF = [];
  var selectedBEHALF;
  bool emptyselectedBEHALF = false;

  List<String> BEHALF_Value = [];
  var selectedBEHALF_Value = null;
  var selectedBEHALF_key;
  ///////////////////////////End New///////////////////////////////////////////////////////

  /////////////////////////////////New 17/4/2023///////////////////////////////////////////
  bool reseller = false;
  var options_Reseller = [];
  var selectedReseller;
  bool emptyselectedReseller = false;

  List<String> Reseller_Value = [];
  var selectedReseller_Value = null;
  var selectedReseller_key;
  bool claim = false;

  ///////////////////////////End New//////////////////////////////////////////////////////
  /////////////////////////////////New 18/4/2023///////////////////////////////////////////
  String optionValue;
  bool switchValidateSalesLead = true;
  bool emptyOption = false;

  bool emptyTicketNo = false;
  int salesLeadType = 0;
  TextEditingController salesLeadValue = TextEditingController();
  var Old_price;
  var General_price;
  var serialNumberValue;
  var simCardValue;

///////////////////////////End New///////////////////////////////////////////
  /***********************************************New 12/6/2023************************************************/
  TextEditingController notes = TextEditingController();
  TextEditingController rejectedReason = TextEditingController();

  bool maximumcharacter=false;
  bool rejectedReasonEmpty=false;
  File imageFilePassportBack;
  var pickedFilePassportBack;
  bool checkLeadsList = true;
  bool leadListEmpty = false;
  List listOfTickets = [];
  var customerContactNo;
  bool show_SendOTP = true;
  bool successFlag = false;
  bool successFlagSecondeReferancenumber = false;
  bool emptyResone=false;
  List resoneOfUnsucssful = [];
  var newStatusResone;
  var newStatusId;


  var status;
  bool _loadPassportBack = false;
  bool changePackage = false;
  bool flag =false;
  //String img64PassportBack;
  /***********************************************************************************************************/
  bool recontract=false;
  bool emptyBuildinCode = false;

  bool isProceedManual=false;
  var campaignTypeName;
  ValidateKitCodeRqBloc validateKitCodeRqBloc;


  void initState() {

   // getDeviceInformation_API();
    print(ticketID);
    print(packageName);
    print(packageCode);
    print(marketType);
    getLeadsById_API();
    getEligiblePackages();
    LookupON_BEHALF();
    LookupON_Reseller();
    super.initState();
    validateKitCodeRqBloc = BlocProvider.of<ValidateKitCodeRqBloc>(context);
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

    MSISDN.text = msisdn;
    /***********************New 9-8-2023****************************************************************************************************/
    ticketNum.text = ticketNumber;
    MarketType.text = marketType;
    PackageName.text = packageName;
    PackageCode.text = packageCode;

    old_packageCode=packageCode;
    salesLeadValue.text =ticketNumber;


    sellectSalesLead.text="Postpaid.LCMSalesLead".tr().toString();
    optionValue="Postpaid.LCMSalesLead".tr().toString();
    salesLeadType=1;
    /*************************************************************************************************************************************/


  }
  void getDeviceInformation_API() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Reports/GetDeviceInformation/'+this.msisdn.toString();
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
          deviceName.text= result["data"]['description']!=null?result["data"]['description']:"";
          deviceSerial.text=result["data"]['serialnumber']!=null?result["data"]['serialnumber']:"";
        });

      } else {
         showAlertDialogOtherERROR(context, result["messageAr"], result["message"]);
        setState(() {
          //isLoadingReconnect = false;
        });
      }



      return result;
    } else {
       showAlertDialogOtherERROR(context,statusCode, statusCode);

    }

  }
  showAlertDialogOtherERROR(BuildContext context, arabicMessage, englishMessage) {

    Widget save = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pop(context, true);

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
      actions: [ save],
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

  final msg =
  BlocBuilder<PostpaidGenerateContractBloc, PostpaidGenerateContractState>(
      builder: (context, state) {
        if (state is PostpaidGenerateContractLoadingState) {
          return Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 10, top: 10),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
                ),
              ));
        } else {
          return Container();
        }
      });

  final msgScan = BlocBuilder<ValidateKitCodeRqBloc, ValidateKitCodeRqState>(
      builder: (context, state) {
        if (state is ValidateKitCodeRqScanLoadingState) {
          return Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 10),
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
                ),
              ));
        } else {
          return Container();
        }
      });

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

  void pickImageCameraSerialDevice() async {
    pickedFileSerialDevice = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileSerialDevice != null) {
      imageFileSerialDevice = File(pickedFileSerialDevice.path);
      _loadSerialDevice = true;
      var imageName = pickedFileSerialDevice.path.split('/').last;
      calculateImageSize(pickedFileSerialDevice.path);
      if (pickedFileSerialDevice != null) {
        _cropImageSerialDevice(File(pickedFileSerialDevice.path));
      }
    }
  }

  void pickImageGallerySerialDevice() async {
    pickedFileSerialDevice = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileSerialDevice != null) {
      imageFileSerialDevice = File(pickedFileSerialDevice.path);
      _loadSerialDevice = true;
      var imageName = pickedFileSerialDevice.path.split('/').last;
      calculateImageSize(pickedFileSerialDevice.path);
      if (pickedFileSerialDevice != null) {
        _cropImageSerialDevice(File(pickedFileSerialDevice.path));
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

  _cropImageSerialDevice(Io.File picture) async {
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
            _loadSerialDevice = false;
            pickedFileSerialDevice = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64SerialDevice = base64Encode(base64Image);
          print('img64Crop: ${img64SerialDevice}');
          imageFileSerialDevice = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadSerialDevice = false;
        pickedFileSerialDevice = null;
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

      ///here
    });
  }

  void clearImageSerialDevice() {
    /* this.setState(()=>
    imageFileID = null );*/

    this.setState(() {
      _loadSerialDevice = false;
      pickedFileSerialDevice = null;

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

  void _showPickerSerialDevice(context) {
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
                      pickImageCameraSerialDevice();
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
                      pickImageGallerySerialDevice();
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

  void ManualProceedStatus_API()async{
    setState(() {
      isDisabledDeliveryInProgress=true;
      isDisabledUnsucss=true;
      isProceedManual=true;

    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/TeleSalesAPIs/ProceedToManual';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "id": ticketID,

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
      //UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if(result['status'] ==0){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
          ),
        );
        setState(() {
          isProceedManual=false;
          isDisabledDeliveryInProgress=true;
          isDisabledUnsucss=true;

        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result["data"]["message"]
                : result["data"]["message"])));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result['message']
                : result['messageAr'])));
        setState(() {

          isProceedManual=false;
          isDisabledDeliveryInProgress=false;
          isDisabledUnsucss=false;

        });

      }


      return result;
    } else {
      setState(() {
        isProceedManual=false;
        isDisabledDeliveryInProgress=false  ;
        isDisabledUnsucss=false;

      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }

  }
  final msgTwo =
  BlocBuilder<VerifyOTPSCheckMSISDNBloc, VerifyOTPSCheckMSISDNState>(
      builder: (context, state) {
        if (state is VerifyOTPSCheckMSISDNLoadingState) {
          return Center(
              child: Container(
                padding: EdgeInsets.only(bottom: 0, top: 20),
                child: Container(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
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
          color: Color(0xFF4f2565),
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
          color: Color(0xFF4f2565),
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
          color: Color(0xFF4f2565),
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
            msisdn: MSISDN.text,
            buildingCode: buildingCode.text=="--"?null:buildingCode.text,
            migrateMBB: false,
            mbbMsisdn: null,
            packageCode: packageCode,
            username: null,
            password: null,
            referenceNumber: referenceNumber.text,
            referenceNumber2: null,
            frontIdImageBase64: img64Front,
            backIdImageBase64: img64Back,
            passportImageBase64: null,
            ContractImageBase64: null,
            locationScreenshotImageBase64: null,
            extraFreeMonths: null,
            extraExtender: null,
            simCard: simCard.text,

            deviceSerialNumber: SerialNumber.text,
            deviceSerialNumberImageBase64: img64SerialDevice,
            onBehalfUser:OnBehalfId.text,
            resellerID :ResellerId.text,
            isClaimed: claim,
            salesLeadType: salesLeadType,
            salesLeadValue: salesLeadValue.text,
            backPassportImageBase64:null,
            note: notes.text,
            scheduledDate:'',

        ));
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


  /*.............................................................Functions Unsuccessful Button..............................................................*/
  void validatePackage_API() async {
    if (changePackage == true){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Please waite to update package information"
                  : "يرجى الانتظار لتحديث معلومات الحزمة")));
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Postpaid/validate';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body ={
      "marketType": marketType,
      "isJordanian": true,
      "nationalNo": nationalNumber,
      "packageCode": packageCode,
      "msisdn":null,



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
      //UnotherizedError();
    }

    if (statusCode == 200) {


      var result = json.decode(response.body);
      print(result);
      if(result["status"]!=0){
        setState(() {
          isDisabledDeliveryInProgress=true;
          isDisabledUnsucss=true;
          isDisabled=true;
        });
        showAlertDialogMissingData( context,
            result["messageAr"],
            result["message"]);
       /* setState(() {
          isDisabled=true;
        });*/
      }

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no data available"
                    : "لا توجد متاحة")));

      } else {
        setState(() {

          MSISDN.text =result["data"]['msisdn'];


        });
        if (changePackage == true){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Updated Sucssfully"
                      : "تم التحديث بنجاح")));
          setState(() {
            changePackage = false;
          });
        }


      }


      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
        //_Unauthorized(context);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }

  void _buildReasonofUnsuccessful() {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Text(
                "SalesLeads.ReasonofUnsuccessful".tr().toString(),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content:
              Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                SingleChildScrollView(
                  child: ListBody(
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[

                          SizedBox(height: 10.0),
                          Container(
                              height: 80,
                              child: Column(
                                children: [
                                  Container(
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          //color: Color(0xFFB10000), red color
                                          color: emptyResone == true
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
                                              color: Color(0xff11120e),
                                              fontSize: 14,
                                            ),
                                            items: resoneOfUnsucssful.map((valueItem) {
                                              return DropdownMenuItem<String>(
                                                value:  valueItem["id"].toString(),
                                                child: EasyLocalization.of(context).locale ==
                                                    Locale("en", "US")
                                                    ? Text(valueItem["statusNameEn"])
                                                    : Text(valueItem["statusNameAr"]),
                                              );
                                            }).toList(),
                                            value: newStatusId,
                                            onChanged: (String newValue) {
                                              getNewStatusId(newValue);
                                              setState(() {
                                                newStatusId = newValue;
                                              });
                                              print(newStatusId);
                                            },
                                          ),
                                        ),
                                      )),
                                ],
                              )),
                          // 9 OCT 2024  newStatusId=='190'?buildRejectedReason():Container(),
                          buildRejectedReason(),

                          rejectedReasonEmpty==true?   ReusableRequiredText(
                              text: "Postpaid.this_feild_is_required"
                                  .tr()
                                  .toString()):Container(),
                        ],
                      ),
                    ],
                  ),
                ),


              ]),
              actions: [
                TextButton(
                  onPressed: () {
                    setState(() {
                    });
                    Navigator.pop(context, 'OK');
                  },
                  child: Text(
                    "SalesLeads.Cancel".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ), TextButton(
                  onPressed: () async{

                    if(rejectedReason.text == ''){
                      setState(() {
                        rejectedReasonEmpty=true;
                      });
                      ReusableRequiredText(
                          text: "Postpaid.this_feild_is_required"
                              .tr()
                              .toString());
                    }
                    if(newStatusId=='190' && rejectedReason.text != ''){
                      updateLeadsStatus_API();
                      setState(() {
                        rejectedReasonEmpty=false;
                        isDisabledDeliveryInProgress=true;
                        isDisabledUnsucss=true;
                        isDisabled=true;
                      });
                      Navigator.pop(context, 'OK');
                    }
                    if(newStatusId!='190' && rejectedReason.text != ''){
                      updateLeadsStatus_API();
                      setState(() {
                        rejectedReasonEmpty=false;
                        isDisabledDeliveryInProgress=true;
                        isDisabledUnsucss=true;
                        isDisabled=true;
                      });
                      Navigator.pop(context, 'OK');
                    }
                    //9 OCT 2024

                   /* if(newStatusId=='190' && rejectedReason.text != ''){
                      updateLeadsStatus_API();
                      setState(() {
                        rejectedReasonEmpty=false;
                        isDisabledDeliveryInProgress=true;
                        isDisabledUnsucss=true;
                        isDisabled=true;
                      });
                      Navigator.pop(context, 'OK');
                    }
                    if(newStatusId=='190' && rejectedReason.text == ''){
                      setState(() {
                        rejectedReasonEmpty=true;
                      });

                      print(rejectedReason.text);

                    }
                    if(newStatusId!='190'){
                      updateLeadsStatus_API();
                      setState(() {
                        rejectedReasonEmpty=false;
                        isDisabledDeliveryInProgress=true;
                        isDisabledUnsucss=true;
                        isDisabled=true;
                      });
                      Navigator.pop(context, 'OK');
                    }*/

                  },
                  child: Text(
                    "SalesLeads.Submit".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void getNewStatusId(newValue) {
    for (var i = 0; i < resoneOfUnsucssful.length; i++) {
      if (resoneOfUnsucssful[i]['id'].toString().contains(newValue)) {
        setState(() {
          newStatusId=newValue;
           newStatusResone=
           EasyLocalization.of(context).locale ==
               Locale("en", "US")
               ?  resoneOfUnsucssful[i]['statusNameEn'].toString()
               :  resoneOfUnsucssful[i]['statusNameAr'].toString();
        });
        print(".......................................................");
        print(newStatusResone);
        print(newStatusId);

        print(".......................................................");

      } else {
        continue;
      }
    }
  }

  getLeadsById_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/TeleSalesAPIs/GetLeadsById';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "id": ticketID,

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
      //UnotherizedError();
    }

    if (statusCode == 200) {
      setState(() {
        checkLeadsList = true;
      });

      var result = json.decode(response.body);
      print(result);

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no orders available"
                    : "لا توجد أوامر متاحة")));
        setState(() {
          checkLeadsList = false;
          leadListEmpty = true;
        });
      } else {

        setState(() {
          deviceSerial.text=result["data"]['deviceSerialNumber']==null?"":result["data"]['deviceSerialNumber'];
          deviceName.text=result["data"]['deviceItemName']==null?"":result["data"]['deviceItemName'];
          NationalNumber.text = result["data"]['customerNationalNo'];
          nationalNumber=result["data"]['customerNationalNo'];
          referenceNumber.text=result["data"]['customerContactNo'];
          customerContactNo=result["data"]['customerContactNo'];
          SerialNumber.text=result["data"]['deviceSerialNumber']==null?"":result["data"]['deviceSerialNumber'];
          serialNumberValue=result["data"]['deviceSerialNumber']==null?"":result["data"]['deviceSerialNumber'];
          simCard.text=result["data"]['simCardNumber']==null?"":result["data"]['simCardNumber'];
          simCardValue=result["data"]['simCardNumber']==null?"":result["data"]['simCardNumber'];
          price=result["data"]['price']==null?"":result["data"]['price'];
          OnBehalfId.text=result["data"]['onBehalf']== null || result["data"]['onBehalf'].length == 0 ? '' : result["data"]['onBehalf'];
          ResellerId.text=result["data"]['resellerId']== null || result["data"]['resellerId'].length == 0 ? '' : result["data"]['resellerId'];
          buildingCode.text=result["data"]['customerBuildingCode']== null || result["data"]['customerBuildingCode'].length == 0 ? '--' : result["data"]['customerBuildingCode'];
          CustomerAdress.text=result["data"]['customerAddress']== null || result["data"]['customerAddress'].length == 0 ? '--' : result["data"]['customerAddress'];
          //salesLeadValue.text =result["data"]['leadNumber'];
          salesLeadValue.text =result["data"]['ticketNumber'];

          ticketNum.text=result["data"]['leadNumber'];
          notes.text=result["data"]['notes']== null || result["data"]['notes'].length == 0 ?"":result["data"]['notes'];

          campaignTypeName=result["data"]['campaignTypeName']== null || result["data"]['campaignTypeName'].length == 0 ? '' : result["data"]['campaignTypeName'];

          checkLeadsList = false;
          leadListEmpty = false;
        });
        if(campaignTypeName=="Recontracting"){
          setState(() {
            recontract=true;
          });
        }
        validatePackage_API();
       /* if(ticketNumber.length==0){
          showAlertDialogMissingData( context,
              "المتابعة إلى التنشيط غير متاحة نظرًا لوجود بيانات مفقودة",
              "Proceed to Activation not available because there is missing data");
          setState(() {
            isDisabled=true;
          });
        }
        if(ticketNumber.length!=0){
          print(ticketNumber);
          validatePackage_API();
        }*/

        setState(() {
          Old_price=price;
          General_price=price;
        });
        print(price);
        print(Old_price);
        print(General_price);

        // DeliverySuccessful = 110,
        // DeliveryInProgress = 090,
        // New = 010,
        //DeliveryUnsuccessful_FollowUpNeeded = 180,
        //Zain170174

        for (var i = 0; i < result["data"]['leadStatus']['availableStatueses'].length; i++) {
          print("++++++++++++++++availableStatueses+++++++++++++");
          if(result["data"]['leadStatus']['availableStatueses'][i]['id']!="110"){
            print("yes not 110");
            if(result["data"]['leadStatus']['availableStatueses'][i]['id']!="90"){
              print("yes not 090");
              resoneOfUnsucssful.add(result["data"]['leadStatus']['availableStatueses'][i]);
            }
            if(result["data"]['leadStatus']['availableStatueses'][i]['id']=="90"){
              print("yes its 090");
              setState(() {
                flag=true;
              });
            }
          }
        }

      }
      print('Sucses API');

      print("................................................................");
      print(resoneOfUnsucssful);
      print(result["data"]['customerBuildingCode']);

      print("................................................................");

      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
        //_Unauthorized(context);
      }

      setState(() {
        checkLeadsList = false;
        status = statusCode.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }
  DeliveryInProgressUpdateStatus_API()async{
    setState(() {
      isDisabledDeliveryInProgress=true;
      isDisabledUnsucss=true;
      isDisabled=true;
    });
    print(newStatusResone);
    print(newStatusId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/TeleSalesAPIs/UpdateLeadsStatus';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "id": ticketID,
      "newStatusId":  090,
      "newStatusReason": "DeliveryInProgress"
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
      //UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if(result['status'] ==0){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
          ),
        );
        setState(() {
          isDisabledDeliveryInProgress=false;
          isDisabledUnsucss=true;
          isDisabled=true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result["data"]["message"]
                : result["data"]["message"])));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result['message']
                : result['messageAr'])));
        setState(() {
          isDisabledDeliveryInProgress=false;
          isDisabledUnsucss=false;
          isDisabled=false;
        });

      }


      return result;
    } else {
      setState(() {
        isDisabledDeliveryInProgress=false  ;
        isDisabledUnsucss=false;
        isDisabled=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }

  }

  updateLeadsStatus_API() async{
    setState(() {
      isDisabledDeliveryInProgress=true;
      isDisabledUnsucss=true;
      isDisabled=true;
    });
    print(newStatusResone);
    print(newStatusId);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/TeleSalesAPIs/UpdateLeadsStatus';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body = {
      "id": ticketID,
      "newStatusId":  int.parse(newStatusId),
      // 9 OCT 2024     "newStatusReason": newStatusId=='190' ? rejectedReason.text :newStatusResone
      "newStatusReason":  rejectedReason.text,
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
      //UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if(result['status'] ==0){
        Navigator.push(
          context,
          MaterialPageRoute(
              builder:(context)=>CustomBottomNavigationBar(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,)
          ),
        );
        setState(() {
          isDisabledDeliveryInProgress=true;
          isDisabledUnsucss=false;
          isDisabled=true;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result["data"]["message"]
                : result["data"]["message"])));
      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? result['message']
                : result['messageAr'])));
        setState(() {
          isDisabledDeliveryInProgress=false;
          isDisabledUnsucss=false;
          isDisabled=false;
        });

      }


      return result;
    } else {
      setState(() {
        isDisabledDeliveryInProgress=false;
        isDisabledUnsucss=false;
        isDisabled=false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }

  showAlertDialogMissingData(BuildContext context, arabicMessage, englishMessage) {
    Widget close = TextButton(
      child: Text(
        "alert.close".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        // Navigator.of(context).pop();
        Navigator.pop(context, true);
      },
    );
    Widget save = TextButton(
      child: Text(
        "SalesLeads.TryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pop(context, true);

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
      actions: [save],
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

  /*.........................................................................................................................................................*/

  /*.................................................new 18/4/2023..............................................................*/
  void changeValidateSalesLeadBy(value) async {
    setState(() {
      switchValidateSalesLead = true;
      optionValue = "Postpaid.LCMSalesLead".tr().toString();
      salesLeadType = 1;
    });

    print("/*********************************************/");
    print(optionValue);
    print(salesLeadType);
    print("/*********************************************/");
  }

  Widget buildValidateSalesLeadBy() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: switchValidateSalesLead,
            /*  value: switchValidateSalesLead,
            onChanged: (value) {
              changeValidateSalesLeadBy(value);
            },*/
            onChanged: null,
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF4f2565),
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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

/*.................................................End new..............................................................*/

  /////////////////////////////////New 17/3/2023///////////////////////////////////////////
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

  /////////////////////////////////////End New/////////////////////////////////////////////
  /*.................................................New 8/5/2-23...............................................................*/

  void retrieve_updated_price_API () async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map test = {
      "MarketType": this.marketType,
      "IsJordanian": true,
      "NationalNo": this.nationalNumber,
      "PassportNo": null,
      "PackageCode": this.packageCode,
      "Msisdn": null,
      "isClaimed": true
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL +'/Postpaid/preSubmitValidation';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if(statusCode==401 ){
      print('401  error ');
    }
    if (statusCode == 200) {

      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('----------------HAYA HAZAIMEH---------------');
      print(result["data"]);
      if(result["data"]==null){

      }
      if( result["status"]==0){
        print(result["data"]);
        setState(() {
          General_price= result["data"]["price"];
        });
        print(price);
        print(General_price);

      }else{

      }


      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL +'/Postpaid/preSubmitValidation');

      return result;
    }else{


    }


  }
  void Update_Price() async{

    if(claim==true){

      retrieve_updated_price_API();

    }
    if(claim==false){
      setState(() {
        General_price= Old_price;
      });
      print(price);
      print(General_price);
    }

  }
  /*.................................................New 17/4/2023..............................................................*/
  void changeCLAIM(value) async {
    setState(() {
      claim = !claim;
    });
    Update_Price();
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
            activeColor: Color(0xFF4f2565),
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
      if (options_Reseller[i]['value']=(val)) {
        setState(() {
          selectedReseller_key = options_Reseller[i]['key'];
        });
        print(selectedReseller_key);
      } else {
        continue;
      }
    }
  }

  /*....................................................End New ................................................................*/

  /////////////////////////////////New 22/3/2023///////////////////////////////////////////
  void LookupON_BEHALF() async {
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
        print(
            "/********************************************************************/");
        print(options_BEHALF);
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
  /////////////////////////////////////End New/////////////////////////////////////////////
  /*.................................................New 22/3/2023..............................................................*/

  void changeON_BEHALF(value) async {
    setState(() {
      on_BEHALF = !on_BEHALF;
      selectedBEHALF = null;
      selectedBEHALF_key = null;
      selectedBEHALF_Value = null;
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
            activeColor: Color(0xFF4f2565),
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
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              role == "DeliveryEShop"
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
        Container(
            padding: EdgeInsets.only(left: 10, right: 5),
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
            child: DropdownSearch<String>(
              popupProps: PopupProps.menu(
                showSelectedItems: true,
                showSearchBox: true,
                searchFieldProps: TextFieldProps(
                  cursorColor: Color(0xFF4f2565),
                ),
              ),
              items: BEHALF_Value,
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
                getKeySelected(val);
              },
              selectedItem: selectedBEHALF_Value,
            )),
        emptyselectedBEHALF == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required".tr().toString())
            : Container(),
      ],
    );
  }

  void getKeySelected(val) {
    for (var i = 0; i < options_BEHALF.length; i++) {
      if (options_BEHALF[i]['value']==val) {
        setState(() {
          selectedBEHALF_key = options_BEHALF[i]['key'];
        });
        print(selectedBEHALF_key);
      } else {
        continue;
      }
    }
  }
  /*....................................................End New ................................................................*/
  /*......................................................New 9-8-2023..........................................................*/
  void getEligiblePackages()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Postpaid/eligible-packages';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);
    Map body;
    body = {
      "marketType": this.marketType
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

           // PACKGE_Value.add(result['data'][i]['descEn'].toString());
            EasyLocalization.of(context).locale == Locale("en", "US")
                ?  PACKGE_Value.add(result['data'][i]['descEn'].toString())
                : PACKGE_Value.add(result['data'][i]['descAr'].toString());

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
            activeColor: Color(0xFF4f2565),
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
                  cursorColor: Color(0xFF4f2565),


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
                setState(() {
                  selectedPackge_Value = val; // Update the selected value
                });
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
        validatePackage_API();
        print(packageCode);
      }else{
        continue;
      }
    }
  }

  /*........................................................End New.............................................................*/
  SendOtp() async {
    print(customerContactNo);
    print(referenceNumber.text);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(
      Uri.parse(urls.BASE_URL + "/OTP/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode({"msisdn": referenceNumber.text}),
    );

    //final data = json.decode(res.body);
    int statusCode = res.statusCode;
    print(res.body);
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

                  setState(() {
                    referenceNumber.text = customerContactNo;
                    otp.text = '';
                    show_SendOTP = true;

                  });

                  Navigator.pop(context, true);
                },
                child: Text(
                  "CustomerService.Cancel".tr().toString(),
                  style: TextStyle(
                    color: Color(0xFF4f2565),
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
                      show_SendOTP = false;
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
                      color: Color(0xFF4f2565),
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
                    color: Color(0xFF4f2565),
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
                      color: Color(0xFF4f2565),
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

  /***********************New 9-8-2023****************************************************************************************************/
  Widget buildDeviceSerial() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: EasyLocalization.of(context).locale ==
                  Locale("en", "US")
                  ? 'Device Serial'
                  : "الرقم التسلسلي للجهاز",
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' * ',
                  style: TextStyle(
                    color: Colors.white,
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
              enabled: false,
              controller: deviceSerial,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Color(0xFF5A6F84)),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                ),
                fillColor: Color(0xFFEBECF1),
                filled: true,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDeviceName() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: EasyLocalization.of(context).locale ==
                  Locale("en", "US")
                  ? 'Device Name'
                  : "اسم الجهاز",
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' * ',
                  style: TextStyle(
                    color: Colors.white,
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
              enabled: false,
              controller:  deviceName,
              keyboardType: TextInputType.text,
              style: TextStyle(color: Color(0xFF5A6F84)),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
                disabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
                focusedBorder: OutlineInputBorder(
                  borderSide:
                  const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                ),
                fillColor: Color(0xFFEBECF1),
                filled: true,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTicketNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SalesLeads.leadNumber".tr().toString(),
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
            controller: ticketNum,
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
  Widget buildOnBehalfId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SalesLeads.OnBehalf".tr().toString(),
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
            controller: OnBehalfId,
            enabled: false,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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

  Widget buildResellerId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SalesLeads.Reseller".tr().toString(),
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
            controller: ResellerId,
            enabled: false,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
          /*  maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,*/
            controller: buildingCode,
            enabled: true,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              enabledBorder:
              emptyBuildinCode == true
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
              hintText: "Postpaid.building_code".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildCustomerAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SalesLeads.CustomerAdress".tr().toString(),
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
            controller: CustomerAdress,
            enabled: false,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
              print('sendOtp ${sendOtp}');

              if (text.length == 10) {
                if (text.substring(3, 10) == '0000000' ||
                    text.substring(0, 10) == '0000000000') {
                  setState(() {
                    errorReferenceNumber = true;
                  });
                } else {
                  /*1.To check if no change on Reference Number that come from API ----> SEND OTP optional */
                  /*2.To check if driver change on Reference Number that come from API ----> SEND OTP Automatic */
                  if (referenceNumber.text == customerContactNo) {
                    print("yes");
                    setState(() {
                      errorReferenceNumber = false;
                      show_SendOTP = true;
                    });
                  } else {
                    print("no");
                    print(referenceNumber.text);
                    print(customerContactNo);
                    setState(() {
                      show_SendOTP = false;
                      errorReferenceNumber = false;
                    });
                    SendOtp();
                  }



                }
              }  if (text.length == 0 || text.length <10) {
                setState(() {
                  errorReferenceNumber = false;
                  successFlag = false;
                  show_SendOTP = false;
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
                  /*1.To check if Second Reference Number == First that Reference Number ----> SEND OTP optional */
                  /*2.To check if Second Reference Number != First that Reference Number ----> SEND OTP Utomatic */
                  if (referenceNumber2.text == referenceNumber.text) {
                    print("PPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPPP");
                    setState(() {
                      duplicateSecondReferenceNumber = true;

                    });
                  } else {
                    setState(() {
                      duplicateSecondReferenceNumber = false;
                    });
                    SendOtpSecondReferanceNumber();
                  }


                }
              }if (text.length == 0 || text.length <10) {
                setState(() {
                  errorSecondReferenceNumber = false;
                  successFlagSecondeReferancenumber=false;
                });
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

  Widget buildImageSerialDevice() {
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
                child: _loadSerialDevice == true
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
                                image: FileImage(imageFileSerialDevice),
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
                                                            imageFileSerialDevice),
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
                              _showPickerSerialDevice(context);
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
                      _showPickerSerialDevice(context);
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
          imageSerialDeviceRequired == true
              ? ReusableRequiredText(
              text: "Postpaid.this_feild_is_required".tr().toString())
              : Container(),
        ]),
      ),
    );
  }

  Widget _SerialNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.serialDevice_number".tr().toString(),
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
            enabled:  serialNumberValue.length==0?true:false,
            controller: SerialNumber,
            maxLength: 20,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            onTap: () {},
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder:
              emptySerialNumber == true || errorSerialNumber == true
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
              suffixIcon:serialNumberValue.length==0?IconButton(
                onPressed: clearSerialNumber,
                icon: Icon(Icons.close),
                color:  Color(0xFFA4B0C1),
                ): IconButton(
                onPressed: reloadSerialNumber,
                icon: Icon(Icons.refresh),
                color:  Color(0xFFA4B0C1),
              ),
              hintText: "Postpaid.enter_serialDevice_number".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget _SIMCARD() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.simCard".tr().toString(),
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
            controller: simCard,
            maxLength: 20,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            onTap: () {},
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptySimCard == true || errorSimCard == true
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
              suffixIcon: simCardValue.length==0?IconButton(
              onPressed: clearSimCard,
              icon: Icon(Icons.close),
              color: Color(0xFFA4B0C1),
              ):IconButton(
                onPressed: reloadSimCard,
                icon: Icon(Icons.refresh),
                color: Color(0xFFA4B0C1),
              ),
              hintText: "Postpaid.enter_simCard".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
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
        Navigator.pop(
          context,
        );
      },
    );
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? englishMessage + "need to show from bakend"
            : arabicMessage + "need to show from bakend",
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

  void reloadSimCard() {
    setState(() {
      simCard.text = simCardValue;
    });
  }

  void clearSimCard() {
    setState(() {
      simCard.text = "";
    });
    FocusManager.instance.primaryFocus?.unfocus();

  }

  void reloadSerialNumber() {
    setState(() {
      SerialNumber.text = serialNumberValue;

      errorSimCard = false;
    });
  }

  void clearSerialNumber() {
    setState(() {
      SerialNumber.text = "";
      errorSimCard = false;
    });
    FocusManager.instance.primaryFocus?.unfocus();

  }
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
                enabled: true,
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
    border: OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
    disabledBorder: OutlineInputBorder(
    borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
    focusedBorder: OutlineInputBorder(
    borderSide:
    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
    ),
    fillColor: Colors.white,
    filled: true,
    contentPadding: EdgeInsets.all(16),
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
  Widget buildRejectedReason() {
    return Container(
      color: Colors.white,
      //padding: EdgeInsets.all(10),
      child: SizedBox(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                  text: "SalesLeads.RejectedResone".tr().toString(),
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
                    )

                  ]
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
                controller: rejectedReason,
                //  keyboardType: TextInputType.phone,
                style: TextStyle(color: Color(0xff11120e)),
                decoration: InputDecoration(
                  enabledBorder:
                  maximumcharacter == true || rejectedReasonEmpty == true
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
                  focusedBorder:    maximumcharacter == true || rejectedReasonEmpty == true?OutlineInputBorder(
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
                    print("haya");
                    print(value.length);
                    setState(() {
                      rejectedReasonEmpty = false;
                      maximumcharacter=true;
                    });
                    print(maximumcharacter);

                  }  if( value.length <= 100)  {

                    print(value.length);


                    setState(() {
                      rejectedReasonEmpty = false;

                      maximumcharacter=false;
                    });
                    print(maximumcharacter);
                  }
                },
              ),
            ),
            ReusableRequiredText(
                text:  "Basic_Info_Edit.Maximum_Characters"
                    .tr()
                    .toString()),
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



  /*......................................................End New...............................................................*/
  /******** for back button on mobile tap ******/
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
      child: BlocListener<PostpaidGenerateContractBloc,
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

            Uint8List decodedbytes = base64.decode(state.filePath);
            Uint8List decodedbytes1 = base64Decode(state.filePath);
            //file.writeAsBytesSync(bytes, flush: true);
            print(decodedbytes1);
            file.writeAsBytesSync(decodedbytes1, flush: true);

            print(sendOtp);
            print(simCard.text);
            /**************************start from here************/
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BroadBand_contractDetails(
                  ID:ticketID,
                    Permessions: Permessions,
                    role: role,
                    outDoorUserName: outDoorUserName,
                    orderID :ticketNum.text,
                    packageName:packageName,
                    FileEPath: file.path,
                    isJordainian: true,
                    marketType: marketType,
                    packageCode: packageCode,
                    msisdn: MSISDN.text,
                    nationalNumber: nationalNumber,
                    passportNumber: null,
                    userName: null,
                    password: null,
                    firstName: null,
                    secondName: null,
                    lastName: null,
                    birthdate: null,
                    referenceNumber: referenceNumber.text,
                    referenceNumber2:  null,
                    isMigrate: false,
                    mbbMsisdn: null,
                    frontImg: img64Front,
                    backImg: img64Back,
                    passprotImg: null,
                    locationImg: null,
                    buildingCode: buildingCode.text=="--"?null:buildingCode.text,
                    extraFreeMonths: null,
                    extraExtender: null,
                   simCard: simCard.text,

                    contractImageBase64: null,
                    deviceSerialNumber: SerialNumber.text,
                    deviceSerialNumberImageBase64: img64SerialDevice,
                    parentMSISDN: isParentEligibleShow.text,
                    onBehalfUser:OnBehalfId.text,
                    resellerID :ResellerId.text,
                    isClaimed: claim,
                    salesLeadType: salesLeadType,
                    salesLeadValue: salesLeadValue.text,
                    backPassportImageBase64:null,
                    note:notes.text,
                    scheduledDate:'',
                    email: ""
                ),
              ),
            );
          }
        },
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
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
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body:status == '401'
                  ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.view_list,
                        color: Colors.black54,
                        size: 90,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? 'No Order List status is ' + ' ' + "401"
                          : "401" + " " + "لا توجد قائمة طلبات الحالة")
                    ],
                  ))
                  : checkLeadsList == true
                  ? Center(
                child: CircularProgressIndicator(
                  color: Color(0xFF392156),
                  backgroundColor: Colors.transparent,
                ),
              )
                  : leadListEmpty == true
                  ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.view_list,
                        color: Colors.black54,
                        size: 90,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? 'No Order List'
                          : "لا توجد قائمة طلبات")
                    ],
                  )):
              SingleChildScrollView(
                child: Column(
                  children: [
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
                                buildDeviceName(),
                                SizedBox(height: 10),
                                buildDeviceSerial(),
                                SizedBox(height: 10),
                                buildTicketNumber(),
                                SizedBox(height: 10),
                                buildMarketType(),
                                SizedBox(height: 10),
                                // buildPackageName(),
                                buildSelect_Packge(),
                                SizedBox(height: 10),
                                buildPackageCode(),
                                SizedBox(height: 10),
                                buildNationalNumber(),
                                SizedBox(height: 10),
                                buildMSISDNNumber(),
                                SizedBox(height: 10),

                                //////////////// end New////////////////////////////////////////
                                // reference number 2
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        alignment: Alignment.centerLeft,
                        child: Column(children: <Widget>[
                          buildReferenceNumber(),
                          emptyReferenceNumber == true
                              ? ReusableRequiredText(
                              text: "Jordan_Nationality.this_feild_is_required"
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
                          successFlag == true
                              ? Container(
                              padding: EdgeInsets.only(top: 5),
                              alignment: EasyLocalization.of(context).locale ==
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
                          show_SendOTP == true?
                          Container(
                            alignment:
                            EasyLocalization.of(context).locale ==
                                Locale("en", "US")
                                ? Alignment.bottomRight
                                : Alignment.bottomLeft,
                            child: TextButton(
                              style: TextButton.styleFrom(
                                primary: Color(0xFF4f2565),
                              ),
                              onPressed: () {
                                SendOtp();
                              },
                              child: Text(
                                "Jordan_Nationality.send_verification_code"
                                    .tr()
                                    .toString(),
                              ),
                            ),
                          ):Container(),

                          SizedBox(
                            height: 10,
                          ),
                         // buildReferenceNumber2(),
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
                          /////////..............................Field of Switchs..............................///////
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
                          buildOnBehalfId(),
                          SizedBox(height: 10),
                          buildResellerId(),
                          SizedBox(height: 10),
                          buildCustomerAddress(),

                          SizedBox(height: 10),
                          buildBuildingCode(),
                          SizedBox(height: 10),
                          buildUserNote(),
                          SizedBox(height: 10),
                        /*  on_BEHALF==true?  Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                left: 0, right: 0, top: 12, bottom: 10),
                            child: buildSelect_BEHALF(),
                          ):Container(),


                          reseller == true?
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                left: 0, right: 0, top: 12, bottom: 10),
                            child: buildSelect_Reseller(),
                          ):Container(),*/
                          //////..............................end Field of Switchs..............................//////
                          ////////...................................Switchs...................................///////
                         /* Container(
                              color: Colors.white,
                              padding:
                              EdgeInsets.only(left: 0, right: 0, bottom: 8),
                              child: buildValidateSalesLeadBy()),


                          Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 8, top: 10),
                              child: buildON_BEHALF()),

                          Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 8, top: 10),
                              child: buildON_Reseller()),*/

                          Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 8, top: 10),
                              child: buildON_CLAIM()),
                          //////..............................end Switchs..............................//////
                        ])),


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

                    //bar code reader
                    Container(
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.only(
                                left: 0, right: 0, bottom: 10, top: 8),
                            height: 60,
                            child: ListTile(
                              leading: Container(
                                width: 280,
                                child: Text(
                                  "Postpaid.simCard_info".tr().toString(),
                                  style: TextStyle(
                                    color: Color(0xFF11120e),
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
                                _SIMCARD(),
                                emptySimCard == true
                                    ? ReusableRequiredText(
                                    text: "Menu_Form.msisdn_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                errorSimCard == true
                                    ? ReusableRequiredText(
                                    text: EasyLocalization.of(context).locale ==
                                        Locale("en", "US")
                                        ? "Your ICCID shoud be 20 digit"
                                        : "رقم ICCID يجب أن يتكون من 20 خانات")
                                    : Container(),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),

                    /*...........................................End simCardNewOption Information........................................*/
                    Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 8),
                      child: ListTile(
                        leading: Container(
                          width: 280,
                          child: Text(
                            "Postpaid.serialDevice_photo".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        trailing: _loadSerialDevice == true
                            ? Container(
                          child: IconButton(
                              icon: Icon(Icons.delete),
                              color: Color(0xff0070c9),
                              onPressed: () =>
                              {clearImageSerialDevice()}),
                        )
                            : null,
                      ),
                    ),
                    Container(
                      child: buildImageSerialDevice(),
                    ),

                    // serial devide bar code
                    Container(
                      child: Column(
                        children: [
                          Container(
                            height: 60,
                            padding: EdgeInsets.only(top: 8),
                            child: ListTile(
                              leading: Container(
                                width: 280,
                                child: Text(
                                  "Postpaid.serialDevice_information"
                                      .tr()
                                      .toString(),
                                  style: TextStyle(
                                    color: Color(0xFF11120e),
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
                                _SerialNumber(),
                              ],
                            ),
                          ),
                          SizedBox(height: 10),
                        ],
                      ),
                    ),

                SizedBox(height: 20),
                    msg,
                    SizedBox(
                      height: 10,
                    ),
                    Container(
                        height: 48,
                        width: 300,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isDisabledUnsucss==true?Colors.black12:Color(0xFF4f2565),
                        ),
                        child: TextButton(
                          onPressed: isDisabledUnsucss
                              ? null
                              : () async {
                            _buildReasonofUnsuccessful();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor: isDisabledUnsucss==true?Colors.transparent:Color(0xFF4f2565),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                          ),
                          child: Text(
                            "SalesLeads.Unsuccessful".tr().toString(),
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )),
                    SizedBox(height: 15),
                    flag==true?        Container(
                        height: 48,
                        width: 300,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isDisabledDeliveryInProgress==true?Colors.black12:Color(0xFF4f2565),
                        ),
                        child: TextButton(
                          onPressed: isDisabledDeliveryInProgress
                              ? null
                              : () async {
                            DeliveryInProgressUpdateStatus_API();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:isDisabledDeliveryInProgress==true?Colors.transparent: Color(0xFF4f2565),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                          ),
                          child: Text(
                            "SalesLeads.DeliveryInProgress".tr().toString(),
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )):Container(),
                    SizedBox(height: 15),
                    recontract==true? Container(
                        height: 48,
                        width: 300,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isProceedManual==true?Colors.black12:Color(0xFF4f2565),
                        ),
                        child: TextButton(
                          onPressed: isProceedManual
                              ? null
                              : () async {
                            ManualProceedStatus_API();
                          },
                          style: TextButton.styleFrom(
                            backgroundColor:isProceedManual==true?Colors.transparent: Color(0xFF4f2565),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                          ),
                          child: Text(
                            "SalesLeads.ManualProceed".tr().toString(),
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )):Container(),
                    recontract==false? Container(
                        height: 48,
                        width: 300,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isDisabled==true?Colors.black12:Color(0xFF4f2565),
                        ),
                        child: TextButton(
                          onPressed: isDisabled
                              ? null
                              : () async {

                            /*................................................ Check Reference Number.............................................*/

                            if (referenceNumber.text == '') {
                              setState(() {
                                emptyReferenceNumber = true;
                              });
                            }
                            if (referenceNumber.text != '') {
                              setState(() {
                                emptyReferenceNumber = false;
                              });
                              if (referenceNumber.text.length != 10 ||
                                  referenceNumber.text.substring(3, 10) ==
                                      '0000000') {
                                setState(() {
                                  errorReferenceNumber = true;
                                });
                              } else {
                                setState(() {
                                  errorReferenceNumber = false;
                                });
                              }
                            }

                            /*................................................ Check Second Reference Number.............................................*/
                           /* if (referenceNumber2.text == '') {
                              setState(() {
                                emptySecondReferenceNumber = true;
                              });
                            }

                            if (referenceNumber2.text != '') {
                              setState(() {
                                emptySecondReferenceNumber = false;
                              });
                              if (referenceNumber2.text.length != 10 ||
                                  referenceNumber2.text.substring(3, 10) ==
                                      '0000000') {
                                setState(() {
                                  errorSecondReferenceNumber = true;
                                });
                              } else {

                                if (referenceNumber2.text == referenceNumber.text) {
                                  setState(() {
                                    duplicateSecondReferenceNumber = true;

                                  });
                                } else {
                                  setState(() {
                                    duplicateSecondReferenceNumber = false;
                                  });
                                }
                                setState(() {
                                  errorSecondReferenceNumber = false;
                                });
                              }
                            }*/

                            /*................................................ Check ID Photo Front.............................................*/

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
                            /*................................................ Check ID Photo Back.............................................*/

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
                            /*................................................ Check Sim Card.............................................*/
                            if (simCard.text == '') {
                              setState(() {
                                emptySimCard = true;
                              });
                            }
                            if (simCard.text != '') {
                              setState(() {
                                emptySimCard = false;
                              });
                            }
                            /*................................................ Check Serial Device.............................................*/
                           /* if (img64SerialDevice == null) {
                              setState(() {
                                imageSerialDeviceRequired = true;
                              });
                            }
                            if (img64SerialDevice != null) {
                              setState(() {
                                imageSerialDeviceRequired = false;
                              });
                            }*/

                            /*................................................ Check ON BEHALF.............................................*/
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
                            /*................................................ Check Reseller.............................................*/

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
                            /*..............................................................................................................*/


                            if(on_BEHALF==true && reseller==false){
                              showToast("Notifications_Form.switch_required".tr().toString(),
                                  context: context,
                                  animation: StyledToastAnimation.scale,
                                  fullWidth: true);
                            }


                            if(on_BEHALF==false && reseller==true){

                              showToast("Notifications_Form.switch_required".tr().toString(),
                                  context: context,
                                  animation: StyledToastAnimation.scale,
                                  fullWidth: true);
                            }


                            if(on_BEHALF==true && reseller==true){

                                if(img64Front != null &&
                                    img64Back != null &&
                                    referenceNumber.text != '' &&

                                    simCard.text != ''&&
                                    selectedBEHALF_key !=null &&
                                    selectedReseller_key !=null){
                                  showAlertDialogSaveData(
                                      context,
                                      ' المبلغ الإجمالي المطلوب هو ${General_price} هل أنت متأكد من حفظ البيانات؟',
                                      "The total amount wanted is :${General_price} JD are you sure you want to save data?");

                                }else{
                                  showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                      context: context,
                                      animation: StyledToastAnimation.scale,
                                      fullWidth: true);
                                }

                            }

                            if(on_BEHALF==false && reseller==false){
                              if(img64Front != null &&
                                  img64Back != null &&
                                  referenceNumber.text != '' &&

                                  simCard.text != ''){
                                showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الإجمالي المطلوب هو ${General_price} هل أنت متأكد من حفظ البيانات؟',
                                    "The total amount wanted is :${General_price} JD are you sure you want to save data?");
                              }else{
                                showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                            }

                          },
                          style: TextButton.styleFrom(
                            backgroundColor: isDisabled==true?Colors.transparent:Color(0xFF4f2565),
                            shape: const BeveledRectangleBorder(
                                borderRadius:
                                BorderRadius.all(Radius.circular(24))),
                          ),
                          child: Text(
                            "SalesLeads.ProceedtoActivation".tr().toString(),
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        )):Container(),
                    SizedBox(height: 30),
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
