import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';
import 'package:sales_app/blocs/LookUpList/LokkUpList_state.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_bloc.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_events.dart';
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
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:dotted_border/dotted_border.dart';
import 'package:photo_view/photo_view.dart';
import 'dart:io' as Io;
import 'dart:io';
import 'package:image_picker_ios/image_picker_ios.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
import 'package:camera/camera.dart';
import '../../../../Corporate/Multi_Use_Components/RequiredField.dart';
import 'GSM_contract_details.dart';
import '../PostpaidIdentificationSelfRecording.dart';

class NonJordainianCustomerInformation extends StatefulWidget {
  var role;
  var outDoorUserName;
  final List<dynamic> Permessions;
  final String msisdn;
  final String nationalNumber;
  final String passportNumber;
  final String packageCode;
  final bool sendOtp;
  var userName;

  var password;
  String marketType;
  bool showSimCard;
  String price;
  final bool isArmy;
  final bool showCommitmentList;

  NonJordainianCustomerInformation(
      {this.role,
      this.outDoorUserName,
      this.Permessions,
      this.msisdn,
      this.nationalNumber,
      this.passportNumber,
      this.userName,
      this.password,
      this.marketType,
      this.packageCode,
      this.sendOtp,
      this.showSimCard,
      this.price,
      this.isArmy,
      this.showCommitmentList});

  @override
  _NonJordainianCustomerInformationState createState() =>
      _NonJordainianCustomerInformationState(
          this.role,
          this.outDoorUserName,
          this.Permessions,
          this.msisdn,
          this.nationalNumber,
          this.passportNumber,
          this.userName,
          this.password,
          this.marketType,
          this.packageCode,
          this.sendOtp,
          this.showSimCard,
          this.price,
          this.isArmy,
          this.showCommitmentList);
}

class Item {
  const Item(this.value, this.textEn, this.textAr);
  final String value;
  final String textEn;
  final String textAr;
}

class _NonJordainianCustomerInformationState
    extends State<NonJordainianCustomerInformation> {
  var role;
  var outDoorUserName;
  final List<dynamic> Permessions;
  final String msisdn;
  final String nationalNumber;
  final String passportNumber;
  final String packageCode;
  final bool sendOtp;
  final bool showSimCard;
  final String price;
  var userName;
  String _dataKitCode = "";
  final picker = ImagePicker();
  File imageFile;

  String img64Passport;
  String img64Location;
  String img64Contract;
  var givenDate = '';
  var password;
  String marketType;
  bool isJordainian = false;
  final bool isArmy;
  final bool showCommitmentList;
  APP_URLS urls = new APP_URLS();

  _NonJordainianCustomerInformationState(
      this.role,
      this.outDoorUserName,
      this.Permessions,
      this.msisdn,
      this.nationalNumber,
      this.passportNumber,
      this.userName,
      this.password,
      this.marketType,
      this.packageCode,
      this.sendOtp,
      this.showSimCard,
      this.price,
      this.isArmy,
      this.showCommitmentList);

  TextEditingController PassportNumber = TextEditingController();
  TextEditingController MSISDN = TextEditingController();

  TextEditingController MarketType = TextEditingController();
  TextEditingController PackageName = TextEditingController();

  TextEditingController referenceNumber = TextEditingController();

  TextEditingController otp = TextEditingController();
  TextEditingController FirstName = TextEditingController();
  TextEditingController SecondName = TextEditingController();
  TextEditingController ThirdName = TextEditingController();
  TextEditingController LastName = TextEditingController();

  TextEditingController simCard = TextEditingController();

  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();

  VerifyOTPSCheckMSISDNBloc verifyOTPSCheckMSISDNBloc;
  SendOTPSCheckMSISDNBloc sendOTPSCheckMSISDNBloc;
  PostpaidGenerateContractBloc postpaidGenerateContractBloc;

  bool response = false;
  bool emptyMSISDN = false;
  bool emptyReferenceNumber = false;
  bool errorReferenceNumber = false;
  bool successFlag = false;

  bool imagePassportRequired = false;

  bool emptyFirstName = false;
  bool emptySecondName = false;
  bool emptyThirdName = false;
  bool emptyLastName = false;

  bool emptyDay = false;
  bool emptyMonth = false;
  bool emptyYear = false;
  bool emptyPassportNumber = false;
  bool errorDayMonthe = false;
  bool errorDay = false;
  bool errorMonthe = false;
  bool birthDateValid = true;
  bool errorYear = false;

  bool emptySimCard = false;
  bool errorSimCard = false;

  bool imageContractRequired = false;

  bool isDisabled = false;

  int imageWidth = 200;
  int imageHeight = 200;

  bool showCircular = false;

  String packagesSelect;

  int d, m, y;
  int days1, month1, year1;

  File imageFilePassport;
  bool _loadPassport = false;
  var pickedFilePassport;

  File imageFileContract;
  bool _loadContract = false;
  var pickedFileContract;

  final _picker = ImagePicker();
  bool emptyCommitmentList = false;
  var commitmentList = [];

  var commitmentDefultSelected;
  var Old_price;
  var General_price;
  bool claim = false;
  bool isDataFromEkyc = false; // ✅ Track if data came from eKYC passport processing

  /////////////////////////////////New 20/9/2023/////////////////////////////////////////////////////////////////////////////////////////
  bool reseller = false;
  var options_Reseller = [];
  var selectedReseller;
  bool emptyselectedReseller = false;

  List<String> Reseller_Value = [];
  var selectedReseller_Value = null;
  var selectedReseller_key;

  bool on_BEHALF = false;
  var options_BEHALF = [];
  bool emptyselectedBEHALF = false;

  List<String> BEHALF_Value = [];
  var selectedBEHALF_Value = null;
  var selectedBEHALF_key;


  var options_Country = [];
  var selectedCountry_Value = null;
  List<String> country_ValueEN = [];
  List<String> country_ValueAR = [];
  var selectedCounrty_key;
  bool emptySelectedCountry = false;


/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*...........................................Document Expiry Date.........................................*/
  bool emptyDocumentExpiryDate=false;
  TextEditingController documentExpiryDate = TextEditingController();
  DateTime Expiry_Date = DateTime.now();

  /*........................................................................................................*/

  void initState() {
    LookupON_BEHALF();
    LookupON_Reseller();
    Lookup_ChooseCountry();
    super.initState();
    setState(() {
      Old_price = price;
      General_price = price;
    });
    print(price);
    print(Old_price);
    print(General_price);
    print(this.price);
    print("price");
    print("------------showCommitmentList-------------");
    if (showCommitmentList == true) {
      print("showCommitmentList");
      commitmentlist_API();
    }
    print("______________------------_________________");
    verifyOTPSCheckMSISDNBloc =
        BlocProvider.of<VerifyOTPSCheckMSISDNBloc>(context);
    postpaidGenerateContractBloc =
        BlocProvider.of<PostpaidGenerateContractBloc>(context);
    PassportNumber.text = passportNumber;
    MSISDN.text = msisdn;

    // ✅ Check if data is available from eKYC passport processing
    if (globalVars.fullNameEn != null && globalVars.fullNameEn.isNotEmpty) {
      setState(() {
        isDataFromEkyc = true;
      });
      
      // ✅ Parse full name and split into components
      List<String> nameParts = globalVars.fullNameEn.trim().split(' ');
      
      if (nameParts.length >= 4) {
        // Full name with at least 4 parts: First Second Third Last
        FirstName.text = nameParts[0];
        SecondName.text = nameParts[1];
        ThirdName.text = nameParts[2];
        LastName.text = nameParts.sublist(3).join(' '); // Rest goes to last name
      } else if (nameParts.length == 3) {
        // 3 parts: First Second Last
        FirstName.text = nameParts[0];
        SecondName.text = nameParts[1];
        LastName.text = nameParts[2];
      } else if (nameParts.length == 2) {
        // 2 parts: First Last
        FirstName.text = nameParts[0];
        LastName.text = nameParts[1];
      } else if (nameParts.length == 1) {
        // Only 1 part
        FirstName.text = nameParts[0];
      }
      
      // ✅ Parse and populate birthdate (format: YYYY-MM-DD)
      if (globalVars.birthdate != null && globalVars.birthdate.isNotEmpty) {
        try {
          List<String> dateParts = globalVars.birthdate.split('-');
          if (dateParts.length == 3) {
            year.text = dateParts[0]; // YYYY
            month.text = dateParts[1]; // MM
            day.text = dateParts[2]; // DD
          }
        } catch (e) {
          print('❌ Error parsing birthdate: $e');
        }
      }
      
      // ✅ Populate document expiry date (format: YYYY-MM-DD to DD/MM/YYYY)
      if (globalVars.expirayDate != null && globalVars.expirayDate.isNotEmpty) {
        try {
          List<String> dateParts = globalVars.expirayDate.split('-');
          if (dateParts.length == 3) {
            documentExpiryDate.text = '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}';
          }
        } catch (e) {
          print('❌ Error parsing expiry date: $e');
        }
      }
      
      print('✅ Populated fields from eKYC data');
      print('Name: ${FirstName.text} ${SecondName.text} ${ThirdName.text} ${LastName.text}');
      print('Birthdate: ${day.text}/${month.text}/${year.text}');
      print('Expiry Date: ${documentExpiryDate.text}');
    }

    print('hello');
    print(
        '${Permessions} ${passportNumber} ${msisdn} ${userName} ${password} ${marketType} ${packageCode}');
  }

  void clearSimCard() {
    setState(() {
      simCard.text = '';

      errorSimCard = false;
    });
  }

 /* void calculateAge() {
    print('me');
    var Month, Day;
    if (month.text.length < 2) {
      if (int.parse(month.text) < 10) {
        Month = '0' + month.text;
      } else {
        Month = month.text;
      }
    } else {
      Month = month.text;
    }

    if (day.text.length < 2) {
      if (int.parse(day.text) < 10) {
        Day = '0' + day.text;
      } else {
        Day = day.text;
      }
    } else {
      Day = day.text;
    }
    givenDate = year.text + '-' + Month + '-' + Day;

    var givenDateFormat = DateTime.parse(givenDate);

    var dateNow = new DateTime.now();
    int d = int.parse(DateFormat("dd").format(givenDateFormat));
    int m = int.parse(DateFormat("MM").format(givenDateFormat));
    int y = int.parse(DateFormat("yyyy").format(givenDateFormat));

    int d1 = int.parse(DateFormat("dd").format(DateTime.now()));
    int m1 = int.parse(DateFormat("MM").format(DateTime.now()));
    int y1 = int.parse(DateFormat("yyyy").format(DateTime.now()));
    print('${d},${m},${y}');
    print('${d1},${m1},${y1}');

    int daypermonth = findDifferencedays(m1, y1);
    if (d1 - d >= 0) {
      days1 = d1 - d;
    } else {
      days1 = d1 + daypermonth - d;
      m1 = m1 - 1;
    }

    if (m1 - m >= 0) {
      month1 = m1 - m;
    } else {
      month1 = m1 + 12 - m;
      y1 = y1 - 1;
    }
    year1 = y1 - y;

    if (year1 == 18 && days1 == 0 && month1 == 0) {
      setState(() {
        birthDateValid = true;
      });
    } else if (year1 >= 18) {
      setState(() {
        birthDateValid = true;
      });
    } else if (year1 < 18) {
      setState(() {
        birthDateValid = false;
      });
    }

    print('${days1},${month1},${year1}');
  }*/

  String convertToEnglishNumbers(String input) {
    return input
        .replaceAll('٠', '0')
        .replaceAll('١', '1')
        .replaceAll('٢', '2')
        .replaceAll('٣', '3')
        .replaceAll('٤', '4')
        .replaceAll('٥', '5')
        .replaceAll('٦', '6')
        .replaceAll('٧', '7')
        .replaceAll('٨', '8')
        .replaceAll('٩', '9');
  }

  void calculateAge() {
    print('me');
    var Month, Day;

    // Convert Arabic numerals to English before parsing
    String monthText = convertToEnglishNumbers(month.text);
    String dayText = convertToEnglishNumbers(day.text);
    String yearText = convertToEnglishNumbers(year.text);

    if (monthText.length < 2) {
      if (int.parse(monthText) < 10) {
        Month = '0' + monthText;
      } else {
        Month = monthText;
      }
    } else {
      Month = monthText;
    }

    if (dayText.length < 2) {
      if (int.parse(dayText) < 10) {
        Day = '0' + dayText;
      } else {
        Day = dayText;
      }
    } else {
      Day = dayText;
    }

    givenDate = yearText + '-' + Month + '-' + Day;

    try {
      var givenDateFormat = DateTime.parse(givenDate);
      var dateNow = DateTime.now();

      int d = int.parse(DateFormat("dd").format(givenDateFormat));
      int m = int.parse(DateFormat("MM").format(givenDateFormat));
      int y = int.parse(DateFormat("yyyy").format(givenDateFormat));

      int d1 = int.parse(DateFormat("dd").format(dateNow));
      int m1 = int.parse(DateFormat("MM").format(dateNow));
      int y1 = int.parse(DateFormat("yyyy").format(dateNow));

      print('${d},${m},${y}');
      print('${d1},${m1},${y1}');

      int daypermonth = findDifferencedays(m1, y1);
      if (d1 - d >= 0) {
        days1 = d1 - d;
      } else {
        days1 = d1 + daypermonth - d;
        m1 = m1 - 1;
      }

      if (m1 - m >= 0) {
        month1 = m1 - m;
      } else {
        month1 = m1 + 12 - m;
        y1 = y1 - 1;
      }
      year1 = y1 - y;

      setState(() {
        birthDateValid = (year1 >= 18);
      });

      print('${days1},${month1},${year1}');
    } catch (e) {
      print('Error parsing date: $e');
    }
  }

  int findDifferencedays(int m2, int y2) {
    int day2;
    if (m2 == 1 ||
        m2 == 3 ||
        m2 == 5 ||
        m2 == 7 ||
        m2 == 8 ||
        m2 == 10 ||
        m2 == 12) {
      day2 = 31;
    } else {
      day2 = 30;
    }
    if (y2 % 4 == 0) {
      day2 = 29;
    } else {
      day2 = 28;
    }
    return day2;
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

  void pickImageCameraPassport() async {
    pickedFilePassport = await _picker.pickImage(
      source: ImageSource.camera,
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

  void pickImageGalleryPassport() async {
    pickedFilePassport = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFilePassport != null) {
      imageFilePassport = File(pickedFilePassport.path);
      _loadPassport = true;
      var imageName = pickedFilePassport.path.split('/').last;
      print(pickedFilePassport);

      print(pickedFilePassport.path);
      final bytes =
          File(pickedFilePassport.path).readAsBytesSync().lengthInBytes;

      calculateImageSize(pickedFilePassport.path);
      if (pickedFilePassport != null) {
        _cropImagePassport(File(pickedFilePassport.path));
      }
    }
  }

  void pickImageCameraContract() async {
    pickedFileContract = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileContract != null) {
      imageFileContract = File(pickedFileContract.path);
      _loadContract = true;
      var imageName = pickedFileContract.path.split('/').last;
      calculateImageSize(pickedFileContract.path);
      if (pickedFileContract != null) {
        _cropImageContract(File(pickedFileContract.path));
      }
    }
  }

  void pickImageGalleryContract() async {
    pickedFileContract = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileContract != null) {
      imageFileContract = File(pickedFileContract.path);
      _loadContract = true;
      var imageName = pickedFileContract.path.split('/').last;
      calculateImageSize(pickedFileContract.path);
      if (pickedFileContract != null) {
        _cropImageContract(File(pickedFileContract.path));
      }
    }
  }

  _cropImagePassport(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*  aspectRatioPresets: [
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
          print('img64Crop: ${img64Passport}');
          imageFilePassport = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadPassport = false;
        pickedFilePassport = null;
      });
    }
  }

  void clearImageIDPassport() {

    /* this.setState(()=>
    imageFileID = null );*/
    this.setState(() {
      img64Passport=null;
      _loadPassport = false;
      pickedFilePassport = null;

      ///here
    });
  }

  void clearImageContract() {
    /* this.setState(()=>
    imageFileID = null );*/

    this.setState(() {
      img64Contract=null;
      _loadContract = false;
      pickedFileContract = null;

      ///here
    });
  }

  _cropImageContract(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /*aspectRatioPresets: [
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
            _loadContract = false;
            pickedFileContract = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Contract = base64Encode(base64Image);
          print('img64Crop: ${img64Contract}');
          imageFileContract = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadContract = false;
        pickedFileContract = null;
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
                  role=="MadaOutdoor"?Container():  GestureDetector(
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

  void _showPickerContract(context) {
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
                      pickImageCameraContract();
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
                  role=="MadaOutdoor"?Container():    GestureDetector(
                    onTap: () {
                      FocusScope.of(context).unfocus();
                      pickImageGalleryContract();
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

  /*****************************************************************************************************/
  // ✅ Pre-submit validation - calls API to validate before proceeding to liveness
  preSubmitValidation_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "MarketType": this.marketType,
      "IsJordanian": false, // Non-Jordanian
      "NationalNo": null,
      "PassportNo": passportNumber,
      "PackageCode": this.packageCode,
      "Msisdn": this.msisdn,
      "isClaimed": claim
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Postpaid/preSubmitValidation';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: body,
    );
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('----------------Non-Jordanian PreSubmit---------------');
      print(result["data"]);
      if (result["data"] == null) {}
      if (result["status"] == 0) {
        print(result["data"]);
        setState(() {
          General_price = result["data"]["price"].toString();
        });
        print(price);
        print(General_price);
        // ✅ Navigate to video recording screen instead of showing dialog
        _navigateToVideoRecording();
      } else {}

      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL + '/Postpaid/preSubmitValidation');

      return result;
    } else {}
  }
  /*****************************************************************************************************/
  
  // ✅ Navigate to video recording screen for eKYC
  void _navigateToVideoRecording() async {
    try {
      // Get available cameras
      final cameras = await availableCameras();
      
      // Get eKYC session UID and token from SharedPreferences or globalVars
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String sessionUid = globalVars.sessionUid ?? '';
      String ekycToken = globalVars.ekycTokenID ?? '';
      
      print('📹 Navigating to video recording screen...');
      print('Session UID: $sessionUid');
      print('MSISDN: $msisdn');
      
      // ✅ Navigate to shared video recording screen
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PostpaidIdentificationSelfRecording(
            cameras: cameras,
            sessionUid: sessionUid,
            ekycToken: ekycToken,
            onVideoRecorded: (videoPath, videoHash) {
              // Video successfully recorded and uploaded
              print('✅ Video recorded successfully!');
              print('Video Path: $videoPath');
              print('Video Hash: $videoHash');
              
              // Close video recording screen
              Navigator.pop(context);
              
              // ✅ Show confirmation dialog with price
              _showPriceConfirmationDialog();
            },
          ),
        ),
      );
    } catch (e) {
      print('❌ Error navigating to video recording: $e');
      showToast(
        "Error navigating to video recording screen",
        context: context,
        animation: StyledToastAnimation.scale,
        fullWidth: true,
      );
    }
  }
  
  // ✅ Show price confirmation dialog after video recording
  void _showPriceConfirmationDialog() {
    showAlertDialogSaveData(
        context,
        ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
        'The total amount required is ${General_price}JD are you sure you want to continue?');
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
            passportNo: passportNumber,
            firstName: FirstName.text,
            secondName: SecondName.text,
            thirdName: ThirdName.text,
            lastName: LastName.text,
            birthDate: givenDate,
            msisdn: msisdn,
            buildingCode: null,
            migrateMBB: false,
            mbbMsisdn: null,
            packageCode: packageCode,
            username: null,
            password: null,
            referenceNumber: referenceNumber.text,
            referenceNumber2: null,
            frontIdImageBase64: null,
            backIdImageBase64: null,

            passportImageBase64: img64Passport,
            locationScreenshotImageBase64: img64Location,
            extraFreeMonths: null,
            extraExtender: null,
            simCard: sendOtp == true ? simCard.text : null,
            contractImageBase64: img64Contract,
            isClaimed: claim,
            note: commitmentDefultSelected,
            militaryID: null,
            scheduledDate: null,
            onBehalfUser: selectedBEHALF_key == null ? "" : selectedBEHALF_key,
            resellerID:
            selectedReseller_key == null ? "" : selectedReseller_key));
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(
      Uri.parse(urls.BASE_URL + "/OTP/send"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode({"msisdn": referenceNumber.text}),
    );

    print('called');

    final data = json.decode(res.body);

    int statusCode = res.statusCode;

    if (statusCode == 200) {
      print("haya");
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
                  referenceNumber.clear();
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
                      successFlag = true;
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

  Widget buildPassportNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.passportNo".tr().toString(),
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
            controller: PassportNumber,
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

  Widget buildImageContract() {
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
                                                                      imageFileContract),
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
                                    (context);
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
                            _showPickerContract(context);
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
          imageContractRequired == true
              ? ReusableRequiredText(
                  text: "Postpaid.this_feild_is_required".tr().toString())
              : Container(),
        ]),
      ),
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

  Widget buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.first_name".tr().toString(),
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
            controller: FirstName,
            enabled: !isDataFromEkyc, // ✅ Disable if data from eKYC
            keyboardType: TextInputType.name,
            style: TextStyle(color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyFirstName == true
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
              hintText: "Postpaid.enter_first_name".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSecondName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.second_name".tr().toString(),
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
            controller: SecondName,
            enabled: !isDataFromEkyc, // ✅ Disable if data from eKYC
            keyboardType: TextInputType.name,
            style: TextStyle(color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptySecondName == true
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
              hintText: "Postpaid.enter_second_name".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildThirdName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.third_name".tr().toString(),
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
            controller: ThirdName,
            enabled: !isDataFromEkyc, // ✅ Disable if data from eKYC
            keyboardType: TextInputType.name,
            style: TextStyle(color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyThirdName == true
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
              hintText: "Postpaid.enter_third_name".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.last_name".tr().toString(),
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
            controller: LastName,
            enabled: !isDataFromEkyc, // ✅ Disable if data from eKYC
            keyboardType: TextInputType.name,
            style: TextStyle(color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyLastName == true
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
              hintText: "Postpaid.enter_last_name".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildBirthDate() {
    return Column(
      children: [
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: "Non_Jordan_Nationality.date_of_birth".tr().toString(),
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
                height: 58,
                child: Row(
                  children: [
                    Container(
                      width: 90,
                      child: TextField(
                        controller: day,
                        enabled: !isDataFromEkyc, // ✅ Disable if data from eKYC
                        maxLength: 2,
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)),
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: emptyDay == true ||
                                  errorDay == true ||
                                  birthDateValid == false
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
                            borderSide: const BorderSide(
                                color: Color(0xFF4f2565), width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText: "Non_Jordan_Nationality.dd".tr().toString(),
                          hintStyle:
                              TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 90,
                      child: TextField(
                        controller: month,
                        enabled: !isDataFromEkyc, // ✅ Disable if data from eKYC
                        maxLength: 2,
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)),
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder: emptyMonth == true ||
                                  errorMonthe == true ||
                                  birthDateValid == false
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
                            borderSide: const BorderSide(
                                color: Color(0xFF4f2565), width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText: "Non_Jordan_Nationality.mm".tr().toString(),
                          hintStyle:
                              TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                        ),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 150,
                      child: TextField(
                        controller: year,
                        enabled: !isDataFromEkyc, // ✅ Disable if data from eKYC
                        maxLength: 4,
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)),
                        decoration: InputDecoration(
                          counterText: '',
                          enabledBorder:
                              emptyYear == true || birthDateValid == false
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
                            borderSide: const BorderSide(
                                color: Color(0xFF4f2565), width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText:
                              "Non_Jordan_Nationality.yyyy".tr().toString(),
                          hintStyle:
                              TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
        emptyDay || emptyMonth || emptyYear == true
            ? ReusableRequiredText(
                text: "Postpaid.this_feild_is_required".tr().toString())
            : Container(),
        errorDay == true || errorMonthe == true || errorYear == true
            ? ReusableRequiredText(
                text: EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Please enter birth date correctly"
                    : "الرجاء إدخال تاريخ الميلاد بشكل صحيح")
            : Container(),
        birthDateValid == false
            ? ReusableRequiredText(
                text: EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Your age less than 18"
                    : "العمر أقل من 18")
            : Container(),
        SizedBox(
          height: 20,
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
                  sendOtp == true ? SendOtp() : null;
                  setState(() {
                    errorReferenceNumber = false;
                  });
                }
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
            enabled: !isDataFromEkyc, // ✅ Disable if data from eKYC
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: isDataFromEkyc ? Color(0xFF5A6F84) : Color(0xff11120e)),
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
              hintText: "Test.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
/*..............................................................................................................................*/

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
              suffixIcon: IconButton(
                onPressed: clearSimCard,
                icon: Icon(Icons.close),
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

  Widget buildImagePassport() {
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
                child: _loadPassport == true
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
                                      image: FileImage(imageFilePassport),
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
                                                                      imageFilePassport),
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
                    : buildDashedBorder(
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context).unfocus();
                            _showPickerPassport(context);
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
          imagePassportRequired == true
              ? ReusableRequiredText(
                  text: "Postpaid.this_feild_is_required".tr().toString())
              : Container(),
        ]),
      ),
    );
  }

  _ScanKitCode() async {
    await FlutterBarcodeScanner.scanBarcode(
            "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _dataKitCode = value));
    setState(() {
      simCard.text = _dataKitCode;
    });
  }

  /****************************************************12-SEP-2023*************************************************************/
  commitmentlist_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lookup/GSM_COMMITMENT/' + this.packageCode;
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
    );
    int statusCode = response.statusCode;
    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
    }
    if (statusCode == 200) {
      var result = json.decode(response.body);
      if (result["status"] == 0) {
        if (result["data"] == null || result["data"].length == 0) {
          //   showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");
        } else {
          print("commitmentList");
          print(result["data"]);
          setState(() {
            commitmentList = result["data"];
            commitmentDefultSelected = result["data"][0]["value"];
          });
        }
      } else {
        // showAlertDialogERROR(context,result["messageAr"], result["message"]);
      }
      return result;
    } else {
      // showAlertDialogOtherERROR(context,statusCode, statusCode);
    }
  }

  Widget buildCommitmentlist() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.CommitmentList".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyCommitmentList == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text(
                    "Postpaid.select_CommitmentList".tr().toString(),
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
                  items: commitmentList.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["value"],
                      child: EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                          ? Text(valueItem["value"])
                          : Text(valueItem["valueAr"]),
                    );
                  }).toList(),
                  value: commitmentDefultSelected,
                  onChanged: (String newValue) {
                    setState(() {
                      commitmentDefultSelected = newValue;
                    });
                  },
                ),
              ),
            )),
        emptyCommitmentList == true
            ? RequiredFeild(text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }

  /*..........................................New 13-SEP-2023.......................................*/
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

  void Update_Price() async {
    if (claim == true) {
      retrieve_updated_price_API();
    }
    if (claim == false) {
      setState(() {
        General_price = Old_price;
      });
      print(price);
      print(General_price);
    }
  }

  /*...............................................New RESELLER 20/9/2023...........................................*/
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
              children: <TextSpan>[
                role == "ZainTelesales"
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
              ]),
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
      if (options_Reseller[i]['value'].contains(val)) {
        setState(() {
          selectedReseller_key = options_Reseller[i]['key'];
        });
        print(selectedReseller_key);
      } else {
        continue;
      }
    }
  }

/*...................................................End New.....................................................*/
/*.............................................New ON_BEHALF 20/9/2023...........................................*/
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
        print(BEHALF_Value);
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

  void changeON_BEHALF(value) async {
    setState(() {
      on_BEHALF = !on_BEHALF;
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
                color: Color(0xFF11120E),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
                role == "ZainTelesales"
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
              ]),
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

  /*********************************************New 22-May-2023******************************************/
  void retrieve_updated_price_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map test = {
      "MarketType": this.marketType,
      "IsJordanian": false,
      "NationalNo": null,
      "PassportNo": this.passportNumber,
      "PackageCode": this.packageCode,
      "Msisdn": this.msisdn,
      "isClaimed": true
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Postpaid/preSubmitValidation';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: body,
    );
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('----------------HAYA HAZAIMEH---------------');
      print(result["data"]);
      if (result["data"] == null) {}
      if (result["status"] == 0) {
        print(result["data"]);
        setState(() {
          General_price = result["data"]["price"];
        });
        print(price);
        print(General_price);
      } else {}

      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL + '/Postpaid/preSubmitValidation');

      return result;
    } else {}
  }
  /*****************************************************************************************************/


  /*.............................................New Choose the Country 30/10/2024...........................................*/
  void Lookup_ChooseCountry() async {
    print("/Lookup/ChooseCountry");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Lookup/COUNTRIES';
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
          options_Country = result["data"];
        });
        for (var i = 0; i < result['data'].length; i++) {
          country_ValueEN.add(result['data'][i]['value'].toString());
          country_ValueAR.add(result['data'][i]['valueAr'].toString());
        }

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


  Widget buildSelect_Country() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              text: EasyLocalization.of(context).locale == Locale("en", "US")?"Select Country":"اختر المدينة",
              style: TextStyle(
                color: Color(0xFF11120E),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
              children: <TextSpan>[
               TextSpan(
                  text: '*',
                  style: TextStyle(
                    color: Color(0xFFB10000),
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ]),
        ),
        SizedBox(height: 10),
        Container(
            padding: EdgeInsets.only(left: 10, right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptySelectedCountry == true
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
              items:EasyLocalization.of(context).locale == Locale("en", "US")? country_ValueEN:country_ValueAR,
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
                setState(() {
                  selectedCountry_Value = val;
                });
                print(val);
                getKeySelectedCountry(val);
              },
              selectedItem: selectedCountry_Value,
            )),
      /*  emptySelectedCountry == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required".tr().toString())
            : Container(),*/
      ],
    );
  }

  void getKeySelectedCountry(val) {

    if(EasyLocalization.of(context).locale == Locale("en", "US")){
      for (var i = 0; i < options_Country.length; i++) {
        if (options_Country[i]['value'].contains(val)) {
          setState(() {
            selectedCounrty_key = options_Country[i]['key'];
          });
          print(selectedCounrty_key);
        } else {
          continue;
        }
      }
    }
    if(EasyLocalization.of(context).locale != Locale("en", "US")){
      for (var i = 0; i < options_Country.length; i++) {
        if (options_Country[i]['valueAr'].contains(val)) {
          setState(() {
            selectedCounrty_key = options_Country[i]['key'];
          });
          print(selectedCounrty_key);
        } else {
          continue;
        }
      }
    }
  }
  /*....................................................End New ................................................................*/

  @override
  Widget build(BuildContext context) {
    return BlocListener<PostpaidGenerateContractBloc,
        PostpaidGenerateContractState>(
      listener: (context, state) async {
        if (state is PostpaidGenerateContractErrorState) {
          setState(() {
            isDisabled = false;
          });
          showAlertDialog(
              context,
              state.arabicMessage == null
                  ? "حدث خطأ ما. أعد المحاولة من فضلك"
                  : state.arabicMessage,
              state.englishMessage == null
                  ? "Something went wrong please try again"
                  : state.englishMessage);
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

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ContractDetails(
                Permessions: Permessions,
                role: role,
                outDoorUserName: outDoorUserName,
                FileEPath: file.path,
                isJordainian: isJordainian,
                marketType: marketType,
                packageCode: packageCode,
                msisdn: msisdn,
                nationalNumber: nationalNumber,
                passportNumber: passportNumber,
                userName: userName,
                password: password,
                firstName: FirstName.text,
                secondName: SecondName.text,
                thirdName: ThirdName.text,
                lastName: LastName.text,
                birthdate: givenDate,
                referenceNumber: referenceNumber.text,
                referenceNumber2: null,
                isMigrate: false,
                mbbMsisdn: null,
                frontImg: null,
                backImg: null,
                passprotImg: img64Passport,
                locationImg: img64Location,
                buildingCode: null,
                extraFreeMonths: null,
                extraExtender: null,
                simCard: sendOtp == true ? simCard.text : null,
                contractImageBase64: img64Contract,
                note: commitmentDefultSelected,
                militaryID: null,
                scheduledDate: null,
                isClaimed: claim,
                onBehalfUser: selectedBEHALF_key == null ? "" : selectedBEHALF_key,
                resellerID: selectedReseller_key == null ? "" : selectedReseller_key,
                documentExpiryDate:documentExpiryDate.text,
                  countryId: selectedCounrty_key
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
            body: ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
              Container(
                  color: Color(0xFFEBECF1),
                  padding:
                      EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 15),
                  child: Text(
                    "Profile_Form.personal_information".tr().toString(),
                    style: TextStyle(
                        color: Color(0xFF11120e),
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  )),
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
                          showCommitmentList == true
                              ? buildCommitmentlist()
                              : Container(),
                          emptyCommitmentList == true
                              ? ReusableRequiredText(
                                  text: "Postpaid.this_feild_is_required"
                                      .tr()
                                      .toString())
                              : Container(),
                          SizedBox(
                            height: 10,
                          ),
                          buildPassportNumber(),
                          SizedBox(height: 10),
                          buildMSISDNNumber(),
                          emptyMSISDN == true
                              ? ReusableRequiredText(
                                  text: "Postpaid.this_feild_is_required"
                                      .tr()
                                      .toString())
                              : Container(),
                          SizedBox(height: 10),
                          buildFirstName(),
                          emptyFirstName == true
                              ? ReusableRequiredText(
                                  text: "Postpaid.this_feild_is_required"
                                      .tr()
                                      .toString())
                              : Container(),
                          SizedBox(height: 10),
                          buildSecondName(),
                          SizedBox(height: 10),
                          buildThirdName(),
                          emptyThirdName == true
                              ? ReusableRequiredText(
                                  text: "Postpaid.this_feild_is_required"
                                      .tr()
                                      .toString())
                              : Container(),
                          SizedBox(height: 10),
                          buildLastName(),
                          emptyLastName == true
                              ? ReusableRequiredText(
                                  text: "Postpaid.this_feild_is_required"
                                      .tr()
                                      .toString())
                              : Container(),
                          SizedBox(height: 10),
                          buildReferenceNumber(),
                          emptyReferenceNumber == true
                              ? ReusableRequiredText(
                                  text: "Postpaid.this_feild_is_required"
                                      .tr()
                                      .toString())
                              : Container(),
                          errorReferenceNumber == true
                              ? ReusableRequiredText(
                                  text: EasyLocalization.of(context).locale ==
                                          Locale("en", "US")
                                      ? "Your MSISDN shoud be 10 digit and valid"
                                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح ")
                              : Container(),
                          successFlag == true
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
                          /*.............................Document Expiry Date 12/6/2024.......................*/
                         buildDocumentExpiryDate(),
                          /*.............................Choose Country 30/10/2024.......................*/
                          SizedBox(
                            height: 10,
                          ),
                          buildSelect_Country(),
                          /*..................................................................................*/
                          SizedBox(
                            height: 10,
                          ),
                          buildBirthDate(),
                          SizedBox(
                            height: 10,
                          ),
                          /******************************************New 20-9-2023 *************************************************************/
                          role == "ZainTelesales" && on_BEHALF == true
                              ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 12, bottom: 10),
                                  child: buildSelect_BEHALF(),
                                )
                              : Container(),
                          role == "ZainTelesales" && reseller == true
                              ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, top: 12, bottom: 10),
                                  child: buildSelect_Reseller(),
                                )
                              : Container(),
                          role == "ZainTelesales"
                              ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, bottom: 5, top: 10),
                                  child: buildON_Reseller())
                              : Container(),
                          role == "ZainTelesales"
                              ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 0, right: 0, bottom: 5, top: 10),
                                  child: buildON_BEHALF())
                              : Container(),
                          /*************************************************************** End *****************************************************/
                          /*****************************************New 13-Sep-2023**********************************************************/
                          Container(
                              color: Colors.white,
                              padding: EdgeInsets.only(
                                  left: 0, right: 0, bottom: 5, top: 10),
                              child: buildON_CLAIM()),
                          /*********************************************************************************************************************************/
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ✅ Hide passport capture section when data is from eKYC
              !isDataFromEkyc
                  ? Column(
                      children: [
                        Container(
                          height: 60,
                          padding: EdgeInsets.only(top: 8),
                          child: ListTile(
                            leading: Container(
                              width: 280,
                              child: Text(
                                "Postpaid.passport_photo".tr().toString(),
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
                                        onPressed: () => {clearImageIDPassport()}),
                                  )
                                : null,
                          ),
                        ),
                        Container(child: buildImagePassport()),
                      ],
                    )
                  : Container()
              ,Permessions.contains('05.02.03.01') == true
                  ? Container(
                      height: 60,
                      padding: EdgeInsets.only(top: 8),
                      child: ListTile(
                        leading: Container(
                          width: 280,
                          child: Text(
                            "Handset Contract test",
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        trailing: _loadContract == true
                            ? Container(
                                child: IconButton(
                                    icon: Icon(Icons.delete),
                                    color: Color(0xff0070c9),
                                    onPressed: () => {clearImageContract()}),
                              )
                            : null,
                      ),
                    )
                  : Container(),
              Permessions.contains('05.02.03.01')
                  ? Container(
                      child: buildImageContract(),
                    )
                  : Container(),
              Column(
                children: [
                  Container(
                    height: 60,
                    padding: EdgeInsets.only(top: 8),
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
                  Container(
                    color: Colors.white,
                    padding: EdgeInsets.only(left: 15, right: 15, bottom: 10),
                    child: Column(
                      children: <Widget>[
                        Container(
                          child: Column(
                            children: <Widget>[
                              Image(
                                  image: AssetImage(
                                      'assets/images/barcode-scan.png'),
                                  width: 160,
                                  height: 160),
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(24))),
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
                    decoration: BoxDecoration(),
                    child: Row(children: <Widget>[
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 10.0, right: 20.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                      Text(
                        "Menu_Form.OR".tr().toString(),
                      ),
                      Expanded(
                        child: new Container(
                            margin:
                                const EdgeInsets.only(left: 20.0, right: 10.0),
                            child: Divider(
                              color: Colors.black,
                              height: 36,
                            )),
                      ),
                    ]),
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
                                      text: EasyLocalization.of(context)
                                                  .locale ==
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
                ],
              ),
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
                    color: Color(0xFF4f2565),
                  ),
                  child: TextButton(
                    onPressed: isDisabled
                        ? null
                        : () async {
                            if (FirstName.text == '') {
                              setState(() {
                                emptyFirstName = true;
                              });
                            }
                            if (FirstName.text != '') {
                              setState(() {
                                emptyFirstName = false;
                              });
                            }
                            if(selectedCounrty_key == null){
                              setState(() {
                                emptySelectedCountry=true;
                              });
                            }

                            if(selectedCounrty_key != null){
                              setState(() {
                                emptySelectedCountry=false;
                              });
                            }

                            /*if(SecondName.text==''){
                        setState(() {
                          emptySecondName=true;
                        });
                      }if(SecondName.text!=''){
                        setState(() {
                          emptySecondName=false;
                        });
                      }*/
                            /*  if(ThirdName.text==''){
                        setState(() {
                          emptyThirdName=true;
                        });
                      }if(ThirdName.text!=''){
                        setState(() {
                          emptyThirdName=false;
                        });
                      }*/

                            if (LastName.text == '') {
                              setState(() {
                                emptyLastName = true;
                              });
                            }
                            if (LastName.text != '') {
                              setState(() {
                                emptyLastName = false;
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

                            if (Permessions.contains('05.02.03.01') == true) {
                              if (img64Contract == null) {
                                setState(() {
                                  imageContractRequired = true;
                                });
                              }
                              if (img64Contract != null) {
                                setState(() {
                                  imageContractRequired = false;
                                });
                              }
                            }

                            if (day.text == '') {
                              setState(() {
                                emptyDay = true;
                              });
                            }
                            if (day.text != '') {
                              setState(() {
                                emptyDay = false;
                              });
                            }
                            if (month.text == '') {
                              setState(() {
                                emptyMonth = true;
                              });
                            }
                            if (month.text != '') {
                              setState(() {
                                emptyMonth = false;
                              });
                            }
                            if (year.text == '') {
                              setState(() {
                                emptyYear = true;
                              });
                            }
                            if (year.text != '') {
                              setState(() {
                                emptyYear = false;
                              });

                              if (year.text.length < 4) {
                                setState(() {
                                  errorYear = true;
                                });
                              } else {
                                setState(() {
                                  errorYear = false;
                                });
                              }
                            }

                            if (day.text != '' &&
                                month.text != '' &&
                                year.text != '') {
                              print('cales');
                              calculateAge();
                            }



                            if (Permessions.contains('05.02.03.01') == true) {
                              if (role == "ZainTelesales" &&
                                  on_BEHALF == false &&
                                  reseller == false) {
                                showToast(
                                    "Notifications_Form.switch_required"
                                        .tr()
                                        .toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                              if (role == "ZainTelesales" &&
                                  on_BEHALF == false &&
                                  reseller == true) {
                                showToast(
                                    "Notifications_Form.switch_required"
                                        .tr()
                                        .toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                              if (role == "ZainTelesales" &&
                                  on_BEHALF == true &&
                                  reseller == false) {
                                showToast(
                                    "Notifications_Form.switch_required"
                                        .tr()
                                        .toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                              if (role == "ZainTelesales" &&
                                  on_BEHALF == true &&
                                  reseller == true) {
                                if (img64Passport != null &&
                                    img64Contract != null &&
                                    referenceNumber.text != '' &&
                                    documentExpiryDate.text != ''&&
                                    FirstName.text != '' &&
                                    simCard.text != '' &&
                                    LastName.text != '' &&
                                    day.text != '' &&
                                    month.text != '' &&
                                    year.text != '' && selectedCounrty_key != null) {
                                  if (int.parse(day.text) >= 1 &&
                                      int.parse(day.text) <= 31) {
                                    errorDay = false;
                                  } else {
                                    setState(() {
                                      errorDay = true;
                                    });
                                  }
                                  if (int.parse(month.text) >= 1 &&
                                      int.parse(month.text) <= 12) {
                                    errorMonthe = false;
                                  } else {
                                    setState(() {
                                      errorMonthe = true;
                                    });
                                  }

                                  if (errorDay == false &&
                                      errorMonthe == false &&
                                      birthDateValid == true) {
                                    // ✅ Call preSubmitValidation which will navigate to liveness video
                                    preSubmitValidation_API();
                                  }
                                }
                              }
                              if (role != "ZainTelesales") {
                                if (img64Passport != null &&
                                    img64Contract != null &&
                                    referenceNumber.text != '' &&
                                    documentExpiryDate.text != ''&&
                                    FirstName.text != '' &&
                                    simCard.text != '' &&
                                    LastName.text != '' &&
                                    day.text != '' &&
                                    month.text != '' &&
                                    year.text != '' &&
                                    selectedCounrty_key != null) {
                                  if (int.parse(day.text) >= 1 &&
                                      int.parse(day.text) <= 31) {
                                    errorDay = false;
                                  } else {
                                    setState(() {
                                      errorDay = true;
                                    });
                                  }
                                  if (int.parse(month.text) >= 1 &&
                                      int.parse(month.text) <= 12) {
                                    errorMonthe = false;
                                  } else {
                                    setState(() {
                                      errorMonthe = true;
                                    });
                                  }

                                  if (errorDay == false &&
                                      errorMonthe == false &&
                                      birthDateValid == true) {
                                    // ✅ Call preSubmitValidation which will navigate to liveness video
                                    preSubmitValidation_API();
                                  }
                                }
                              }
                            } else {
                              if (role == "ZainTelesales" &&
                                  on_BEHALF == false &&
                                  reseller == false) {
                                showToast(
                                    "Notifications_Form.switch_required"
                                        .tr()
                                        .toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                              if (role == "ZainTelesales" &&
                                  on_BEHALF == false &&
                                  reseller == true) {
                                showToast(
                                    "Notifications_Form.switch_required"
                                        .tr()
                                        .toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                              if (role == "ZainTelesales" &&
                                  on_BEHALF == true &&
                                  reseller == false) {
                                showToast(
                                    "Notifications_Form.switch_required"
                                        .tr()
                                        .toString(),
                                    context: context,
                                    animation: StyledToastAnimation.scale,
                                    fullWidth: true);
                              }
                              if (role == "ZainTelesales" &&
                                  on_BEHALF == true &&
                                  reseller == true) {
                                if (img64Passport != null &&
                                    referenceNumber.text != '' &&
                                    documentExpiryDate.text != ''&&
                                    FirstName.text != '' &&
                                    simCard.text != '' &&
                                    LastName.text != '' &&
                                    day.text != '' &&
                                    month.text != '' &&
                                    year.text != '' &&
                                    selectedCounrty_key != null) {
                                  if (int.parse(day.text) >= 1 &&
                                      int.parse(day.text) <= 31) {
                                    errorDay = false;
                                  } else {
                                    setState(() {
                                      errorDay = true;
                                    });
                                  }
                                  if (int.parse(month.text) >= 1 &&
                                      int.parse(month.text) <= 12) {
                                    errorMonthe = false;
                                  } else {
                                    setState(() {
                                      errorMonthe = true;
                                    });
                                  }

                                  if (errorDay == false &&
                                      errorMonthe == false &&
                                      birthDateValid == true) {
                                    showAlertDialogSaveData(
                                        context,
                                        ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                        'The total amount required is ${General_price}JD are you sure you want to continue?');
                                  }
                                }
                              }
                              if (role != "ZainTelesales") {
                                if (
                                    referenceNumber.text != '' &&
                                    documentExpiryDate.text != ''&&
                                    FirstName.text != '' &&
                                    simCard.text != '' &&
                                    LastName.text != '' &&
                                    day.text != '' &&
                                    month.text != '' &&
                                    year.text != '' &&
                                    selectedCounrty_key != null) {
                                  if (int.parse(day.text) >= 1 &&
                                      int.parse(day.text) <= 31) {
                                    errorDay = false;
                                  } else {
                                    setState(() {
                                      errorDay = true;
                                    });
                                  }
                                  if (int.parse(month.text) >= 1 &&
                                      int.parse(month.text) <= 12) {
                                    errorMonthe = false;
                                  } else {
                                    setState(() {
                                      errorMonthe = true;
                                    });
                                  }

                                  if (errorDay == false &&
                                      errorMonthe == false &&
                                      birthDateValid == true) {
                                    // showAlertDialogSaveData(
                                    //     context,
                                    //     ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    //     'The total amount required is ${General_price}JD are you sure you want to continue?');
                                    preSubmitValidation_API();

                                  }
                                }
                              }
                            }
                          },
                    style: TextButton.styleFrom(
                      backgroundColor: Color(0xFF4f2565),
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
            ])),
      ),
    );
  }
}

