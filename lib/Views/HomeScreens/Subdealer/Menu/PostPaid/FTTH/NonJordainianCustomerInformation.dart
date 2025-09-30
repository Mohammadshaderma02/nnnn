import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
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
import 'package:dropdown_search/dropdown_search.dart';

import 'dart:io' as Io;
import 'dart:io';

import 'Contract.dart';
import 'contract_details.dart';

class NonJordainianCustomerInformation extends StatefulWidget {
  var role;
  var outDoorUserName;
  final List<dynamic> Permessions;
  final String msisdn;
  final String nationalNumber;
  final String passportNumber;
  final String packageCode;
  var userName;

  var password;
  String marketType;

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
      this.packageCode});

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
          this.packageCode);
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
  var userName;

  final picker = ImagePicker();
  File imageFile;

  String img64Passport;
  var TestingDecodebase64;
  /***********************************************New 12/6/2023************************************************/
  String img64PassportBack;
  /***********************************************************************************************************/

  String img64Location;
  var givenDate = '';
  var password;
  String marketType;
  bool isJordainian = false;
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
      this.packageCode);

  TextEditingController PassportNumber = TextEditingController();
  TextEditingController MSISDN = TextEditingController();
  TextEditingController UserName = TextEditingController();
  TextEditingController Password = TextEditingController();
  TextEditingController MarketType = TextEditingController();
  TextEditingController PackageName = TextEditingController();
  TextEditingController mbbMsisdn = TextEditingController();
  TextEditingController referenceNumber = TextEditingController();
  TextEditingController referenceNumber2 = TextEditingController();
  TextEditingController otp = TextEditingController();
  TextEditingController FirstName = TextEditingController();
  TextEditingController SecondName = TextEditingController();
  TextEditingController ThirdName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController buildingCode = TextEditingController();

  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController ticketNo = TextEditingController();

  TextEditingController salesLeadValue = TextEditingController();
  TextEditingController tawasoleNumber= TextEditingController();

  VerifyOTPSCheckMSISDNBloc verifyOTPSCheckMSISDNBloc;
  SendOTPSCheckMSISDNBloc sendOTPSCheckMSISDNBloc;
  GetLookUpListBloc getLookUpListBloc;
  GetAddressLookupAreaBloc getAddressLookupAreaBloc;
  GetAddressLookupStreetBloc getAddressLookupStreetBloc;
  GetAddressLookupBuildingBloc getAddressLookupBuildingBloc;
  PostpaidGenerateContractBloc postpaidGenerateContractBloc;
  GetBuildingCodeBloc getBuildingCodeBloc;

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
  bool imagePassportRequired = false;
  bool imageLocationRequired = false;
  bool emptyMBBMSISDN = false;
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
  bool duplicateSecondReferenceNumber = false;
  bool emptyBuildinCode = false;

  bool showCircular = false;
  bool isMigrate = false;
  String packagesSelect;

  bool emptyArea = false;
  bool emptyStreet = false;
  bool emptyBuilding = false;

  bool emptyExtraFreeMonth = false;
  bool emptyFreeExtender = false;

  bool extraMonth = false;
  bool freeExtender = false;
  bool isDisabled = false;
  bool emptyTawasolNumber=false;
  String area;
  String street;
  String building;
  String extra_month;
  String free_extender;
  //String buildingCode ='' ;
  List<Item> AREAS = <Item>[];
  List<Item> STREET = <Item>[];
  List<Item> BUILDINGS = <Item>[];
  List<Item> EXTRA_MONTHS = <Item>[];
  List<Item> FREE_EXTENDER = <Item>[];

  int imageWidth = 200;
  int imageHeight = 200;

  int d, m, y;
  int days1, month1, year1;

  final _picker = ImagePicker();
  File imageFilePassport;
  bool _loadPassport = false;
  var pickedFilePassport;



  File imageFileLocation;
  bool _loadIdLocation = false;
  var pickedFileLocation;

/////////////////////////////////New///////////////////////////////////////////
  String optionValue;
  bool switchValidateSalesLead = false;
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
  File imageFilePassportBack;
  var pickedFilePassportBack;
  bool _loadPassportBack = false;
 // String img64PassportBack;
  /**************************************************Ramadan Promotion**************************************************/
  bool isPromotion=false;
  String promotion;
  TextEditingController promoCode = TextEditingController();
  /***********************************************************************************************************/
/*...........................................Document Expiry Date.........................................*/
  bool emptyDocumentExpiryDate=false;
  TextEditingController documentExpiryDate = TextEditingController();
  DateTime Expiry_Date = DateTime.now();


  var options_Country = [];
  var selectedCountry_Value = null;
  List<String> country_ValueEN = [];
  List<String> country_ValueAR = [];
  var selectedCounrty_key;
  bool emptySelectedCountry = false;

  /*........................................................................................................*/

  @override
  void initState() {
    print("????????????????????????????????????????????????????????????");
    LookupON_Reseller();
    LookupON_BEHALF();
    Lookup_ChooseCountry();
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
    PassportNumber.text = passportNumber;
    MSISDN.text = msisdn;
    Password.text = password;
    UserName.text = userName;
    print('hello');
    print(
        '${Permessions} ${passportNumber} ${msisdn} ${userName} ${password} ${marketType} ${packageCode}');
  }


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
  /******************************************************New 12-6-2023*********************************************************/

  void pickImageCameraPassportBack() async {

    pickedFilePassportBack = await _picker.pickImage(
      source: ImageSource.camera,
    );
    if (pickedFilePassportBack != null) {
      imageFilePassportBack = File(pickedFilePassportBack.path);
      _loadPassportBack = true;
      var imageName = pickedFilePassportBack.path.split('/').last;

      calculateImageSize(pickedFilePassportBack.path);
      if (pickedFilePassportBack != null) {
        _cropImagePassportBack(File(pickedFilePassportBack.path));
      }
    }
  }

  void pickImageGalleryPassportBack() async {
    pickedFilePassportBack = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFilePassportBack != null) {
      imageFilePassportBack = File(pickedFilePassportBack.path);
      _loadPassportBack = true;
      var imageName = pickedFilePassportBack.path.split('/').last;
      print(pickedFilePassportBack);

      print(pickedFilePassportBack.path);
      final bytes =
          File(pickedFilePassportBack.path).readAsBytesSync().lengthInBytes;

      calculateImageSize(pickedFilePassportBack.path);
      if (pickedFilePassportBack != null) {
        _cropImagePassportBack(File(pickedFilePassportBack.path));
      }
    }
  }

  _cropImagePassportBack(Io.File picture) async {
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
            _loadPassportBack = false;
            pickedFilePassportBack = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64PassportBack = base64Encode(base64Image);
          print('img64Crop: ${img64PassportBack}');
          imageFilePassportBack = File(cropped.path);
        }
      });
    } else {
      this.setState(() {
        _loadPassportBack = false;
        pickedFilePassportBack = null;
      });
    }
  }
  void clearImageIDPassportBack() {
    this.setState(() {

       img64PassportBack=null;
      _loadPassportBack = false;
      pickedFilePassportBack = null;

      ///here
    });
  }
  void _showPickerPassportBack(context) {
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
                      pickImageCameraPassportBack();
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
                      pickImageGalleryPassportBack();
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

/******************************************************************************************************************************/

  /*void calculateAge() {
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

  void pickImageCameraLocation() async {
    pickedFileLocation = await _picker.pickImage(
      source: ImageSource.camera,
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

  _cropImagePassport(Io.File picture) async {
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

  _cropImageLocation(Io.File picture) async {
    print('called');
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
      });
    }
  }

  void clearImageIDPassport() {
    this.setState(() {
      img64Passport=null;
      _loadPassport = false;
      pickedFilePassport = null;

      ///here
    });
  }

  void clearImageLocation() {
    this.setState(() {
      img64Location=null;
      _loadIdLocation = false;
      pickedFileLocation = null;

      ///here
    });
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
        padding: EdgeInsets.only(bottom: 10),
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
        /****************************************************need to check here******************************************************************/
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
            buildingCode: buildingCode.text,
            migrateMBB: isMigrate,
            mbbMsisdn: mbbMsisdn.text,
            packageCode: packageCode,
            username: UserName.text,
            password: Password.text,
            referenceNumber: referenceNumber.text,
            referenceNumber2: referenceNumber2.text,
            frontIdImageBase64: null,
            backIdImageBase64: null,
            passportImageBase64: img64Passport,
            locationScreenshotImageBase64: img64Location,
            extraFreeMonths: extra_month,
            extraExtender: free_extender,
            simCard: null,
            contractImageBase64: null,
            onBehalfUser:role =='DealerAgent'?tawasoleNumber.text:(selectedBEHALF_key==null?"":selectedBEHALF_key),
            resellerID :selectedReseller_key==null?"":selectedReseller_key,
            isClaimed:claim,
            backPassportImageBase64:img64PassportBack,
            note: notes.text,
            scheduledDate:'',
            jeeranPromoCode:promoCode.text
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
                      clearSucssesFlag=1;
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

  void changeSwitched(value) async {
    setState(() {
      isMigrate = !isMigrate;
      mbbMsisdn.text='';
    });
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
            enabled: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
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
            enabled: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
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
            enabled: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
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
            enabled: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
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
                        maxLength: 2,
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(color: Color(0xff11120e)),
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
                        maxLength: 2,
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(color: Color(0xff11120e)),
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
                        maxLength: 4,
                        keyboardType: TextInputType.datetime,
                        style: TextStyle(color: Color(0xff11120e)),
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
                      //  firstDate: DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day - 60),
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
            activeColor: Color(0xFF4f2565),
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
  /******************************************************New 12-6-2023*********************************************************/
  Widget buildImagePassportBack() {
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
                child: _loadPassportBack == true
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
                                image: FileImage(imageFilePassportBack),
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
                                                            imageFilePassportBack),
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
                              _showPickerPassportBack(context);
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
                      _showPickerPassportBack(context);
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
         /* imagePassportRequired == true
              ? ReusableRequiredText(
              text: "Postpaid.this_feild_is_required".tr().toString())
              : Container(),*/
        ]),
      ),
    );
  }
  /***************************************************************************************************************************/

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
                role == 'Subdealer' || role =='DealerAgent'
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
                print(AREAS);
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
                role == 'Subdealer' || role =='DealerAgent'
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
                print(' streee s  ${state.data.length}');
                STREET = [];
                for (var obj in state.data) {
                  if (obj != null) {
                    print(obj);
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
            role == 'Subdealer' || role =='DealerAgent'
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
            enabled: role == 'Subdealer' || role =='DealerAgent'? false : true,
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
                role=="ZainTelesales"?  TextSpan(
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
                  cursorColor: Color(0xFF4f2565),


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

  /*Widget buildSelect_BEHALF() {
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
          ),
        ),
        SizedBox(height: 10),
        Container(
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
                  items:  options_BEHALF.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["key"],
                      child: Text(valueItem["value"]),
                    );
                  }).toList(),
                  value: selectedBEHALF,
                  onChanged: (String newValue) {
                    //Navigator.pop(context);

                    setState(() {
                      selectedBEHALF = newValue;
                    });

                  },
                ),
              ),
            )),
        emptyselectedBEHALF == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required"
                .tr()
                .toString()) : Container(),
      ],
    );
  }*/


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
                role=="ZainTelesales"?  TextSpan(
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
                  cursorColor: Color(0xFF4f2565),


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
        print(options_BEHALF[i]);
        print(selectedBEHALF_key);
      }else{
        continue;
      }
    }
  }

 /*....................................................End New ................................................................*/


/*.................................................new..............................................................*/
  void changeValidateSalesLeadBy(value) async {
    setState(() {
      switchValidateSalesLead = !switchValidateSalesLead;
      optionValue=null;
      // free_extender=null;
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
            onChanged: (value) {
              changeValidateSalesLeadBy(value);
            },
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
            keyboardType: TextInputType.text,
            /* inputFormatters: [
              FilteringTextInputFormatter.deny(
                  RegExp('[a-z A-Z á-ú Á-Ú]')),
            ],*/
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptysalesLeadValue == true
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
              hintText: salesLeadType==1? "Postpaid.Enter_LCM_Ticket".tr().toString():"Postpaid.Enter_EshopOrderNO_Ticket".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

/*.................................................End new..............................................................*/

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
            activeColor: Color(0xFF4f2565),
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
            activeColor: Color(0xFF4f2565),
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

/*................................................New Ramadan Promotion 6/3/2024................................................*/

  void changePromotionCheak(value) async {
    setState(() {
      isPromotion = !isPromotion;
      promoCode.text = '';
    });
  }

  Widget extraPromotion (){
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: isPromotion,
            onChanged: (value) {
              changePromotionCheak(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF4f2565),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
              Text( EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Promotion'
                  : "ترويج",
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildPromotion() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Jeeran Promo Code'
                : "الرمز الترويجي لجيران",
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
          height: 70,
          child: TextField(
            // maxLength: 10,
           // enabled: checkPromoCode==true?false:true,
            controller: promoCode,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: const OutlineInputBorder(
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){

            },
            onChanged: (national){


            },
          ),
        ),
      ],
    );
  }
/*.........................................................End new..............................................................*/

/*................................................New for Dealer Agent 5/3/2025................................................*/
  Widget buildTawasolNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")?"Tawasol Number":"رقم التواصل",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Colors.white,//Color(0xFFB10000),
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
            controller: tawasoleNumber,
            enabled: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyTawasolNumber == true
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
              hintText:  EasyLocalization.of(context).locale ==
                  Locale("en", "US")?"Enter tawasol number":"أدخل رقم التواصل",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 10),
      ],
    );
  }

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
                  referenceNumber2: referenceNumber2.text,
                  isMigrate: isMigrate,
                  mbbMsisdn: mbbMsisdn.text,
                  frontImg: null,
                  backImg: null,
                  passprotImg: img64Passport,
                  locationImg: img64Location,
                  buildingCode: buildingCode.text,
                  extraFreeMonths: extra_month,
                  extraExtender: free_extender,
                  simCard: null,
                  contractImageBase64: null,
                  salesLeadType: salesLeadType,
                  salesLeadValue: salesLeadValue.text,
                 // onBehalfUser:selectedBEHALF_key==null?"":selectedBEHALF_key,
                  onBehalfUser:role =='DealerAgent'?tawasoleNumber.text:(selectedBEHALF_key==null?"":selectedBEHALF_key),
                  resellerID :selectedReseller_key==null?"":selectedReseller_key,
                  isClaimed:claim,
                  backPassportImageBase64:img64PassportBack,
                  note: notes.text,
                  scheduledDate:'',
                  jeeranPromoCode:promoCode.text,
                  documentExpiryDate:documentExpiryDate.text,
                  countryId: selectedCounrty_key),
            ),
          );
        }
      },
      child: GestureDetector(
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
                          /*.............................Document Expiry Date 12/6/2024.......................*/
                          buildDocumentExpiryDate(),
                          SizedBox(
                            height: 10,
                          ),
                          /*.............................Choose Country 30/10/2024.......................*/
                          SizedBox(
                            height: 10,
                          ),
                          buildSelect_Country(),
                          SizedBox(
                            height: 10,
                          ),
                          /*..................................................................................*/

                          buildBirthDate(),

                          Permessions.contains('05.02.02.07') == true && role =='DealerAgent'?
                          buildTawasolNumber():Container(),

                          isMigrate == true ? buildmbbMSISDN() : Container(),
                          isMigrate == true && emptyMBBMSISDN == true
                              ? ReusableRequiredText(
                                  text: "Postpaid.this_feild_is_required"
                                      .tr()
                                      .toString())
                              : Container(),

                          ////////////////New////////////////////////////////////////
                          switchValidateSalesLead == true
                              ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 12, bottom: 5),
                                  child: buildSalesLeadOptions(),
                                )
                              : Container(),
                          (optionValue != null || optionValue == '') &&
                                  switchValidateSalesLead == true
                              ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 5, bottom: 8),
                                  child: buildLCM_SalesLeadTicket())
                              : Container(),

                          ////////////////New 17/4/2022////////////////////////////////////////
                          Permessions.contains('05.02.02.06') == true && reseller == true?
                          Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                left:0, right:0, top: 12, bottom: 10),
                            child: buildSelect_Reseller(),
                          )
                              : Container(),

                          ////////////////New 22/3/2022////////////////////////////////////////
                          Permessions.contains('05.02.02.05') == true&& on_BEHALF == true
                              ? Container(
                            color: Colors.white,
                            padding: EdgeInsets.only(
                                left: 5, right: 5, top: 12, bottom: 5),
                            child: buildSelect_BEHALF(),
                          )
                              : Container(),
                          Permessions.contains('05.02.02.05') == true&& on_BEHALF == true?SizedBox(
                            height: 20,
                          ):SizedBox(
                            height: 1,
                          ),



                        ],
                      ),
                    ),
                  ],
                ),
              ),

              Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 8),
                  child: buildEnableMBB()),
              ////////////////New////////////////////////////////////////

              Permessions.contains("05.02.02.04")==true?Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 8),
                  child: buildValidateSalesLeadBy()):Container(),

              //////////////// end New////////////////////////////////////////
            ///////////////////22/3/2023///////////////////////////////////
              Permessions.contains("05.02.02.05")==true?Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 8),
                  child: buildON_BEHALF()):Container(),

              //////////////// end New////////////////////////////////////////
              ////////////////New 17/4/2022////////////////////////////////////////
              role=="ZainTelesales"&& Permessions.contains('05.02.02.06') == true?  Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 8,top: 4),
                  child: buildON_Reseller()):Container(),

            /*  Permessions.contains('05.02.01.06') == true?  Container(
                  color: Colors.white,
                  padding: EdgeInsets.only(left: 5, right: 5, bottom: 8,top: 4),
                  child: buildON_CLAIM()):Container(),*/


              //////////////// end New////////////////////////////////////////
              Container(
                height: 60,
                padding: EdgeInsets.only(top: 8),
                child: ListTile(
                  leading: Container(
                    width: 280,
                    child: Text(
                      "Postpaid.passport_photo_front".tr().toString(),
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
//          TestingDecodebase64=base64Decode(img64Passport);
           /*   img64Passport != null?  Container(
                  width: 180,
                  height: 235,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    image: DecorationImage(
                      colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(0.5),
                        BlendMode.dstATop,
                      ),
                      image: MemoryImage(base64Decode(img64Passport)),
                      fit: BoxFit.cover,
                    ),
                  )):Container(),*/
              /***************************************New 13-June-2023****************************************/
              Container(
                height: 60,
                padding: EdgeInsets.only(top: 8),
                child: ListTile(
                  leading: Container(
                    width: 280,
                    child: Text(
                      "Postpaid.passport_photo_back".tr().toString(),
                      style: TextStyle(
                        color: Color(0xFF11120e),
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  trailing: _loadPassportBack == true
                      ? Container(
                    child: IconButton(
                        icon: Icon(Icons.delete),
                        color: Color(0xff0070c9),
                        onPressed: () => {clearImageIDPassportBack()}),
                  )
                      : null,
                ),
              ),
              Container(child: buildImagePassportBack()),
              /**********************************************************************************************/
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
              role == "Subdealer" || role =='DealerAgent'
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
              role == 'Subdealer'|| role =='DealerAgent'
                  ? Container(
                      child: buildImageLoction(),
                    )
                  : Container(),
              Permessions.contains('05.02.02.02')
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
              Permessions.contains('05.02.02.03')
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
                                  height: 20,
                                ),
                                extraFreeMonths(),
                                SizedBox(
                                  height: 10,
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
                                  height: 10,
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
                                SizedBox(
                                  height: 15,
                                ),
                                extraPromotion(),
                                SizedBox(
                                  height: 10,
                                ),
                                isPromotion==true? Container(
                                    padding:
                                    EdgeInsets.only(left: 15, right: 15),
                                    child: buildPromotion()):Container(),
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
              SizedBox(height: 20),
              buildUserNote(),
              SizedBox(height: 20),
              msg,
              Container(
                  height: 48,
                  width: 300,
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF4f2565),
                  ),
                  child: TextButton(
                    onPressed: isDisabled == true
                        ? null
                        : () async {
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

                        /////////////////////////////////////////////new 17-4-2023///////////////////////////////////////
                            if(role=="ZainTelesales"){
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
                            if(Permessions.contains("05.02.02.04")==true){
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

                            if (role == 'Subdealer' || role =='DealerAgent') {
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

                              calculateAge();
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

                            if (role == 'Subdealer' || role =='DealerAgent') {
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

                            if (Permessions.contains('05.02.02.03')) {
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
                            if (Permessions.contains('05.02.02.02')) {
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
////////////////////////////////////////////////////////////////////////////////new 17-4-023/////////////////////////////////////////////////////////////////////
                      if(role=="ZainTelesales"){


                        if(on_BEHALF==true && reseller==false){

                          showToast("Notifications_Form.switch_required".tr().toString(),
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);
                          /*if (duplicateSecondReferenceNumber == false &&
                              area != null &&
                              street != null &&
                              building != null &&
                              img64Passport != null &&

                              referenceNumber.text != '' &&
                              UserName.text != '' &&
                              Password.text != '' &&


                              referenceNumber2.text != '' &&
                              FirstName.text != '' &&
                              LastName.text != '' &&
                              day.text != '' &&
                              month.text != '' &&
                              year.text != ''&&
                              selectedBEHALF_key !=null) {
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
                                  'هل أنت متأكد من حفظ البيانات',
                                  'Are you sure you want to save data?');
                              print("::::::");
                              print(selectedBEHALF_key);
                            }
                          }else{
                            showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }*/

                        }
                        if(on_BEHALF==false && reseller==true ){
                          showToast("Notifications_Form.switch_required".tr().toString(),
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);
                         /* if (duplicateSecondReferenceNumber == false &&
                              area != null &&
                              street != null &&
                              building != null &&
                              img64Passport != null &&

                              referenceNumber.text != '' &&
                              UserName.text != '' &&
                              Password.text != '' &&


                              referenceNumber2.text != '' &&
                              FirstName.text != '' &&
                              LastName.text != '' &&
                              day.text != '' &&
                              month.text != '' &&
                              year.text != ''&&
                              selectedReseller_key !=null) {
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
                                  'هل أنت متأكد من حفظ البيانات',
                                  'Are you sure you want to save data>>>>>>');
                              print("::::::");
                              print(selectedBEHALF_key);
                            }
                          }else{

                          showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);

                          }*/
                        }



                        if(on_BEHALF==true && reseller==true){
                          print(":::::::::::::::::::::::::::::");
                          print(selectedBEHALF_key);
                          print(selectedReseller_key);
                          print(":::::::::::::::::::::::::::::");

                          if (duplicateSecondReferenceNumber == false &&
                              buildingCode.text !='' &&

                              img64Passport != null &&

                              referenceNumber.text != '' &&
                              UserName.text != '' &&
                              Password.text != '' &&
                              documentExpiryDate.text != ''&&

                              referenceNumber2.text != '' &&
                              FirstName.text != '' &&
                              LastName.text != '' &&
                              day.text != '' &&
                              month.text != '' &&
                              year.text != ''&&
                              selectedBEHALF_key !=null &&
                              selectedReseller_key !=null &&
                              selectedCounrty_key != null
                          ) {
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
                                  'هل أنت متأكد من حفظ البيانات',
                                  'Are you sure you want to save data');
                              print("::::::");
                              print(selectedBEHALF_key);
                            }
                          }else{
                            showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }
                        }
                        if(on_BEHALF==false && reseller==false){
                          showToast("Notifications_Form.switch_required".tr().toString(),
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);
                        /*  if (duplicateSecondReferenceNumber == false &&
                              area != null &&
                              street != null &&
                              building != null &&
                              img64Passport != null &&

                              referenceNumber.text != '' &&
                              UserName.text != '' &&
                              Password.text != '' &&


                              referenceNumber2.text != '' &&
                              FirstName.text != '' &&
                              LastName.text != '' &&
                              day.text != '' &&
                              month.text != '' &&
                              year.text != ''
                             ) {
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
                                  'هل أنت متأكد من حفظ البيانات',
                                  'Are you sure you want to save data.');

                            }
                          }else{
                            showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }*/
                        }








                      }
 ///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

                            if(switchValidateSalesLead==true){
                              if (isMigrate == true) {
                                  if (role == 'Subdealer' || role =='DealerAgent') {

                                  if (duplicateSecondReferenceNumber == false &&
                                      area != null &&
                                      street != null &&
                                      building != null &&
                                      img64Passport != null &&
                                      img64Location != null &&
                                      referenceNumber.text != '' &&
                                      UserName.text != '' &&
                                      Password.text != '' &&
                                      documentExpiryDate.text != ''&&
                                      mbbMsisdn.text != '' &&
                                      optionValue!=null &&
                                      salesLeadValue.text!=""&&
                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
                                      LastName.text != '' &&
                                      day.text != '' &&
                                      month.text != '' &&
                                      year.text != ''
                                  &&selectedCounrty_key != null) {
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
                                          'هل أنت متأكد من حفظ البيانات',
                                          'Are you sure you want to save data');
                                    }
                                  }else{
                                    showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }
                                }
                                  else if
                                  (role != 'Subdealer' &&  role !='DealerAgent' && role!="ZainTelesales") {
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          mbbMsisdn.text != '' &&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          extra_month != null &&
                                          free_extender != null&&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          mbbMsisdn.text != '' &&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          extra_month != null&&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          mbbMsisdn.text != '' &&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          free_extender != null&&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          mbbMsisdn.text != '' &&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
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
                              else if (isMigrate == false) {
                                if( role=="ZainTelesales"){
                                  if (duplicateSecondReferenceNumber == false &&
                                      area != null &&
                                      street != null &&
                                      building != null &&
                                      img64Passport != null &&
                                      img64Location != null &&
                                      referenceNumber.text != '' &&
                                      optionValue!=null &&
                                      salesLeadValue.text!=""&&
                                      UserName.text != '' &&
                                      Password.text != '' &&
                                      documentExpiryDate.text != ''&&
                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
                                      LastName.text != '' &&
                                      day.text != '' &&
                                      month.text != '' &&
                                      year.text != ''&&
                                      selectedBEHALF_key !=null &&
                                  selectedReseller_key !=null &&
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
                                          'هل أنت متأكد من حفظ البيانات',
                                          'Are you sure you want to save data');
                                    }
                                  }else{
                                    showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }

                                }
                                if (role == 'Subdealer' || role =='DealerAgent') {
                                  if (duplicateSecondReferenceNumber == false &&
                                      area != null &&
                                      street != null &&
                                      building != null &&
                                      img64Passport != null &&
                                      img64Location != null &&
                                      referenceNumber.text != '' &&
                                      optionValue!=null &&
                                      salesLeadValue.text!=""&&
                                      UserName.text != '' &&
                                      Password.text != '' &&
                                      documentExpiryDate.text != ''&&
                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
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
                                          'هل أنت متأكد من حفظ البيانات',
                                          'Are you sure you want to save data');
                                    }
                                  }else{
                                    showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }
                                } else if (role != 'Subdealer' && role !='DealerAgent' && role!="ZainTelesales") {
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          extra_month != null &&
                                          free_extender != null &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          referenceNumber2.text != '' &&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          extra_month != null &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          referenceNumber2.text != '' &&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          free_extender != null &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          referenceNumber2.text != '' &&
                                          optionValue!=null &&
                                          salesLeadValue.text!=""&&
                                          FirstName.text != '' &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
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
                            }else if(switchValidateSalesLead==false){
                              if (isMigrate == true) {

                                if (role == 'Subdealer' || role =='DealerAgent') {
                                  print('iam hera');
                                  if (duplicateSecondReferenceNumber == false &&
                                      area != null &&
                                      street != null &&
                                      building != null &&
                                      img64Passport != null &&
                                      img64Location != null &&
                                      referenceNumber.text != '' &&
                                      UserName.text != '' &&
                                      Password.text != '' &&
                                      documentExpiryDate.text != ''&&
                                      mbbMsisdn.text != '' &&
                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
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
                                          'هل أنت متأكد من حفظ البيانات',
                                          'Are you sure you want to save data');
                                    }
                                  }else{
                                    showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }
                                } else if (role != 'Subdealer' && role !='DealerAgent' && role!="ZainTelesales") {
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          extra_month != null &&
                                          free_extender != null &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          mbbMsisdn.text != '' &&
                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          extra_month != null &&
                                          selectedCounrty_key != null
                                      ) {
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          mbbMsisdn.text != '' &&

                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          free_extender != null &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          mbbMsisdn.text != '' &&

                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
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
                              else if (isMigrate == false) {

                                if (role == 'Subdealer' || role =='DealerAgent') {
                                  if (duplicateSecondReferenceNumber == false &&
                                      area != null &&
                                      street != null &&
                                      building != null &&
                                      img64Passport != null &&
                                      img64Location != null &&
                                      referenceNumber.text != '' &&
                                      documentExpiryDate.text != ''&&
                                      UserName.text != '' &&
                                      Password.text != '' &&

                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
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
                                          'هل أنت متأكد من حفظ البيانات',
                                          'Are you sure you want to save data');
                                    }
                                  }else{
                                    showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }
                                } else if (role != 'Subdealer' &&  role !='DealerAgent'&& role!="ZainTelesales") {
                                  if (extraMonth == true) {
                                    if (freeExtender == true) {
                                      print('here');
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          referenceNumber2.text != '' &&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          extra_month != null &&
                                          free_extender != null &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          extra_month != null &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    }
                                  } else if (extraMonth == false) {
                                    if (freeExtender == true) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          FirstName.text != '' &&
                                          LastName.text != '' &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' &&
                                          free_extender != null &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
                                      }else{
                                        showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }
                                    } else if (freeExtender == false) {
                                      if (duplicateSecondReferenceNumber == false &&
                                          buildingCode.text != '' &&
                                          img64Passport != null &&
                                          referenceNumber.text != '' &&
                                          UserName.text != '' &&
                                          Password.text != '' &&
                                          referenceNumber2.text != '' &&
                                          documentExpiryDate.text != ''&&
                                          FirstName.text != '' &&
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
                                              'هل أنت متأكد من حفظ البيانات',
                                              'Are you sure you want to save data');
                                        }
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

//////
/**/
