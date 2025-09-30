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
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/SalesLeads/FTTH/Contract/FTTH_ContractDetails.dart';

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

import '../../../../CustomBottomNavigationBar.dart';

//import 'Contract.dart';
//import 'contract_details.dart';

class FTTH_nonJordanian extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var ticketID;
  var ticketNumber;
  var packageName;
  String packageCode;
  String marketType;
  var msisdn;




  var PermessionDeliveryEShop = [];
  var orderID;

  String national_Number;
  String passport_Number;

  var userName;
  var password;

  var customerName;





  FTTH_nonJordanian(
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.ticketID,
      this.ticketNumber,
      this.packageName,
      this.packageCode,
      this.marketType,
      this.customerName);

  @override
  _FTTH_nonJordanianState createState() =>
      _FTTH_nonJordanianState(
          this.Permessions,
          this.role,
          this.outDoorUserName,
          this.ticketID,
          this.ticketNumber,
          this.packageName,
          this.packageCode,
          this.marketType,
      this.customerName);
}

class Item {
  const Item(this.value, this.textEn, this.textAr);
  final String value;
  final String textEn;
  final String textAr;
}

class _FTTH_nonJordanianState
    extends State<FTTH_nonJordanian> {

  DateTime backButtonPressedTime;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  var ticketID;
  var ticketNumber;
  var packageName;
  String packageCode;
  String marketType;
  var msisdn;
  var customerName;

  var PermessionDeliveryEShop = [];
  var orderID;


  var userName;
  String national_Number;
  String passport_Number;



  final picker = ImagePicker();
  File imageFile;

  String img64Passport;
  /***********************************************New 12/6/2023************************************************/
  String img64PassportBack;
  /***********************************************************************************************************/

  String img64Location;
  var givenDate = '';
  var password;

  bool isJordainian = false;
  APP_URLS urls = new APP_URLS();

  _FTTH_nonJordanianState(
      this.Permessions,
      this.role,
      this.outDoorUserName,
      this.ticketID,
      this.ticketNumber,
      this.packageName,
      this.packageCode,
      this.marketType,
      this.customerName);

  /***********************New 9-8-2023****************************************************************************************************/
  var old_packageCode;
  TextEditingController ticketNum = TextEditingController();
  TextEditingController MarketType = TextEditingController();
  TextEditingController PackageName = TextEditingController();
  TextEditingController PackageCode = TextEditingController();

  var options_PACKGE =[];
  List <String> PACKGE_Value=[];
  bool on_ChangePackge=false;
  var selectedPackge_Key;
  var selectedPackge_Value=null;
  bool emptyselectedPackege = false;


  /*************************************************************************************************************************************/


  TextEditingController PassportNumber = TextEditingController();
  TextEditingController MSISDN = TextEditingController();
  TextEditingController FiberSubscriptionNo = TextEditingController();
  TextEditingController UserName = TextEditingController();
  TextEditingController Password = TextEditingController();
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
  TextEditingController sellectSalesLead = TextEditingController();
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
  bool imagePassportRequiredBack=false;
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
  //bool isMigrate = false;
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
  bool flag=false;

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
  TextEditingController rejectedReason = TextEditingController();

  bool maximumcharacter=false;
  bool rejectedReasonEmpty=false;
  File imageFilePassportBack;
  var pickedFilePassportBack;
  bool _loadPassportBack = false;
  var EshopOrderNo;
  // String img64PassportBack;
  /***********************************************************************************************************/
  bool isDisabledUnsucss = false;
  bool isDisabledDeliveryInProgress=false;

  bool emptyResone=false;
  List resoneOfUnsucssful = [];
  var newStatusResone;
  var newStatusId;
  var status;
  bool checkLeadsList = true;
  bool leadListEmpty = false;
  List listOfTickets = [];
  var customerContactNo;
  bool show_SendOTP = true;
  var sendOtp;
  bool changePackage = false;
  List<String> fullName;
  bool recontract=false;
  bool isProceedManual=false;
  var campaignTypeName;

  //THIS NEW ON 27 mARCH 2025 Based on QA Team feedback
  var options_Country = [];
  var selectedCountry_Value = null;
  List<String> country_ValueEN = [];
  List<String> country_ValueAR = [];
  var selectedCounrty_key;
  bool emptySelectedCountry = false;

  @override
  void initState() {
  //  getDeviceInformation_API();
    getLeadsById_API();
    getEligiblePackages();
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
    PassportNumber.text = passport_Number;

    MSISDN.text = msisdn;
    Password.text = password;
    UserName.text = userName;
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
    /************************************For Split Full Name for Customer*****************************************************/
    print("************************************For Split Full Name for Customer*****************************************************");
    print(customerName);
    fullName = customerName.split(" ");
    print(fullName);
    if(fullName.length==2){
      setState(() {
        FirstName.text = fullName[0];
        LastName.text = fullName[1];
      });

    }
    if(fullName.length==3){
      setState(() {
        FirstName.text = fullName[0];
        SecondName.text = fullName[1];
        LastName.text = fullName[2];
      });


    }
    if(fullName.length>=4){
      setState(() {
        FirstName.text = fullName[0];
        SecondName.text = fullName[1];
        ThirdName.text = fullName[2];
        LastName.text = fullName[3];
      });

    }

    /************************************************************************************************************************/
    print('hello');
    print(
        '${PermessionDeliveryEShop} ${passport_Number} ${msisdn} ${userName} ${password} ${marketType} ${packageCode}');
  }


  /*..................................................New 27/3/2025...............................................................*/
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
                  print("................selectedCountry_Value..........");
                  print(val);
                  print("................selectedCountry_Value..........");
                  getKeySelectedCountry(selectedCountry_Value);
                });

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
      "isJordanian": false,
      "passportNo": passport_Number,
      "packageCode": packageCode,
      "msisdn":null

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
          UserName.text = result["data"]['generatedPassword'];
          Password.text = result["data"]['generatedUsername'];


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

                         //OCT 9 2024 newStatusId=='190'?buildRejectedReason():Container(),
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
                  onPressed: ()async {
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
                        // isDisabledDeliveryInProgress=true;
                        isDisabledUnsucss=true;
                        isDisabled=true;
                      });
                      Navigator.pop(context, 'OK');
                    }
                    if(newStatusId!='190' && rejectedReason.text != ''){
                      updateLeadsStatus_API();
                      setState(() {
                        rejectedReasonEmpty=false;
                        // isDisabledDeliveryInProgress=true;
                        isDisabledUnsucss=true;
                        isDisabled=true;
                      });
                      Navigator.pop(context, 'OK');
                    }


                    //9 OCT 2024

                  /*  if(newStatusId=='190' && rejectedReason.text != ''){
                      updateLeadsStatus_API();
                      setState(() {
                        rejectedReasonEmpty=false;
                        //isDisabledDeliveryInProgress=true;
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
                        //isDisabledDeliveryInProgress=true;
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
          PassportNumber.text = result["data"]['customerPassportNo'];
          passport_Number=result["data"]['customerPassportNo'];
          referenceNumber.text=result["data"]['customerContactNo'];
          customerContactNo=result["data"]['customerContactNo'];
          OnBehalfId.text=result["data"]['onBehalf']== null || result["data"]['onBehalf'].length == 0 ? '' : result["data"]['onBehalf'];
          ResellerId.text=result["data"]['resellerId']== null || result["data"]['resellerId'].length == 0 ? '' : result["data"]['resellerId'];
          buildingCode.text=result["data"]['customerBuildingCode']== null || result["data"]['customerBuildingCode'].length == 0 ? '--' : result["data"]['customerBuildingCode'];
          CustomerAdress.text=result["data"]['customerAddress']== null || result["data"]['customerAddress'].length == 0 ? '--' : result["data"]['customerAddress'];
         // salesLeadValue.text =result["data"]['ticketNumber'];
         // salesLeadValue.text =result["data"]['leadNumber'];
          // salesLeadValue.text =result["data"]['ticketNumber'];
          deviceSerial.text=result["data"]['deviceSerialNumber']==null?"":result["data"]['deviceSerialNumber'];
          deviceName.text=result["data"]['deviceItemName']==null?"":result["data"]['deviceItemName'];
          ticketNum.text=result["data"]['leadNumber'];
          mbbMsisdn.text=result["data"]['fgSubscriptionNo']== null || result["data"]['fgSubscriptionNo'].length == 0 ? '' : result["data"]['fgSubscriptionNo'];
          isMigrate=result["data"]['fgSubscriptionNo']== null || result["data"]['fgSubscriptionNo'].length == 0 ? false : true;
          campaignTypeName=result["data"]['campaignTypeName']== null || result["data"]['campaignTypeName'].length == 0 ? '' : result["data"]['campaignTypeName'];
          checkLeadsList = false;
          leadListEmpty = false;
          FiberSubscriptionNo.text =result["data"]['fiberSubscriptionNo'];
          notes.text=result["data"]['notes'];
        });
        print(";;;;;;;;;;;;;;;;;;");
        print(result["data"]['notes']);
        print(campaignTypeName);
        print(FiberSubscriptionNo.text);
        print(";;;;;;;;;;;;;;;;;;");


        print("-------------------------- This condition for Manual Button -------------------------");

        if(campaignTypeName=="Recontracting"){
          setState(() {
            recontract=true;
          });
        }
        if(campaignTypeName!="Recontracting"){
          setState(() {
            recontract=false;
          });
          validatePackage_API();
        }



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

//Test@20222

        for (var i = 0; i < result["data"]['leadStatus']['availableStatueses'].length; i++) {
          if(result["data"]['leadStatus']['availableStatueses'][i]['id']!="110"){
            if(result["data"]['leadStatus']['availableStatueses'][i]['id']!="90"){
              resoneOfUnsucssful.add(result["data"]['leadStatus']['availableStatueses'][i]);

            }
            if(result["data"]['leadStatus']['availableStatueses'][i]['id']=="90"){
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
      //OCT 9 2024 "newStatusReason": newStatusId=='190' ? rejectedReason.text :newStatusResone
      "newStatusReason": rejectedReason.text
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
                  GestureDetector(
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
      _loadPassport = false;
      pickedFilePassport = null;

      ///here
    });
  }

  void clearImageLocation() {
    this.setState(() {
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
                  GestureDetector(
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

  ManualProceedStatus_API()async{
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
            isJordanian: false,
            nationalNo: null,
            passportNo: passport_Number,
            firstName: FirstName.text,
            secondName: SecondName.text,
            thirdName: ThirdName.text,
            lastName: LastName.text,
            birthDate: givenDate,
            msisdn: recontract==true ?FiberSubscriptionNo.text:MSISDN.text,
            buildingCode: buildingCode.text=="--"?null:buildingCode.text,
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
            onBehalfUser:OnBehalfId.text,
            resellerID :ResellerId.text,
            isClaimed:claim,
            backPassportImageBase64:img64PassportBack,
            note: notes.text,
            scheduledDate:""
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

  void changeSwitched(value) async {
    setState(() {
      isMigrate = !isMigrate;
      mbbMsisdn.text='';
    });
  }
  /***********************New 9-8-2023****************************************************************************************************/
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
  /*************************************************************************************************************************************/

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
            controller: recontract==true ?FiberSubscriptionNo:MSISDN,
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
                    setState(() {
                      duplicateSecondReferenceNumber = true;

                    });
                  } else {
                    setState(() {
                      duplicateSecondReferenceNumber = false;
                    });
                   // SendOtpSecondReferanceNumber();
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
          mbbMsisdn.text.length==0|| mbbMsisdn.text==null?
          Switch(
            onChanged: null,
            value: false,
          /*  onChanged: (value) {
              changeSwitched(value);
            },
            value: isMigrate,*/
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF4f2565),
            inactiveTrackColor: Color(0xFFEBECF1),
          ): Switch(
            onChanged: null,
            value: true,
            /* onChanged: (value) {
              changeSwitched(value);
            },*/
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
          imagePassportRequiredBack == true
              ? ReusableRequiredText(
              text: "Postpaid.this_feild_is_required".tr().toString())
              : Container(),
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

  /*Widget buildBuildingCode() {
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
  }*/
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
           /* maxLength: 10,
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
              text: "DeliveryEShop.packageName".tr().toString(),
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
                    fontSize: 14,),

                ),
              ),
              onChanged:(val){
                setState(() {
                  selectedPackge_Value = val; // Update the selected value
                });

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
        validatePackage_API();
        print(packageCode);
      }else{
        continue;
      }
    }
  }

  /*........................................................End New.............................................................*/

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

  /****here****/

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
      padding: EdgeInsets.all(3),
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
            /****************************************start here***********************************/
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FTTH_ContractDetails(
                    ID:ticketID,
                    Permessions: Permessions,
                    role: role,
                    orderID :ticketNum.text,
                    packageName:packageName,
                    FileEPath: file.path,
                    isJordainian: false,
                    marketType: marketType,
                    packageCode: packageCode,
                    msisdn: recontract==true ?FiberSubscriptionNo.text:MSISDN.text,
                    nationalNumber: national_Number,
                    passportNumber: passport_Number,
                    userName: UserName.text,
                    password: Password.text,
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
                    buildingCode: buildingCode.text=="--"?null:buildingCode.text,
                    extraFreeMonths: extra_month,
                    extraExtender: free_extender,
                    simCard: null,
                    contractImageBase64: null,
                    salesLeadType: salesLeadType,
                    salesLeadValue: salesLeadValue.text,
                    onBehalfUser:OnBehalfId.text,
                    resellerID :ResellerId.text,
                    isClaimed:claim,
                    backPassportImageBase64:img64PassportBack,
                    note: notes.text,
                    scheduledDate:"",
                    countryId: selectedCounrty_key),
              ),
            );
          }
        },
        child: WillPopScope(child:
        GestureDetector(
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
                  color: Color(0xFF4f2565),
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
                  )): SingleChildScrollView(
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
                                buildTicketNumber(),
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
                                recontract==false ?  buildUserName():Container(),
                                emptyUserName == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                SizedBox(height: 10),
                                recontract==false ?  buildPassword():Container(),
                                emptyPassword == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),

                                SizedBox(height: 10),
                                buildDeviceName(),
                                SizedBox(height: 10),
                                buildDeviceSerial(),
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
                                buildBirthDate(),
                                SizedBox(height: 10,),
                                buildSelect_Country(),

                                SizedBox(height: 10,),
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
                                buildOnBehalfId(),
                                SizedBox(height: 10,),
                                buildResellerId(),
                                SizedBox(height: 10,),
                               // isMigrate == true ? buildmbbMSISDN() : Container(),
                                isMigrate == true && emptyMBBMSISDN == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                             /* reseller == true?
                                Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left:0, right:0, top: 12, bottom: 10),
                                  child: buildSelect_Reseller(),
                                )
                                    : Container(),

                                on_BEHALF == true
                                    ? Container(
                                  color: Colors.white,
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 12, bottom: 5),
                                  child: buildSelect_BEHALF(),
                                )
                                    : Container(),
                               on_BEHALF == true?SizedBox(
                                  height: 20,
                                ):SizedBox(
                                  height: 1,
                                ),*/

                                ////////////////////////////end new////////////////////////////////////


                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    /********************switch****************************/

                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 8),
                        child: buildEnableMBB()),

             /*     Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 8, right: 8, bottom: 8),
                        child: buildValidateSalesLeadBy()),


                  Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 8),
                        child: buildON_BEHALF()),

                    Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 5, right: 5, bottom: 8,top: 4),
                        child: buildON_Reseller()),*/




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
                              //  buildAreaName(),
                              //  SizedBox(height: 10),
                                emptyArea == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                              //  buildStreetName(),
                                emptyStreet == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                               // SizedBox(height: 10),
                             //   buildBuildingName(),
                                emptyBuilding == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                               // SizedBox(height: 10),
                                buildCustomerAddress(),
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
                          ),
                          buildUserNote(),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    role == "Subdealer"
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
                   /* PermessionDeliveryEShop.contains('05.02.02.02')
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
                        : Container(),*/


              SizedBox(height: 20),
                    msg,
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
                            backgroundColor: isDisabledDeliveryInProgress==true?Colors.transparent:Color(0xFF4f2565),
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
                    recontract==false?    Container(
                        height: 48,
                        width: 300,
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: isDisabled==true?Colors.black12:Color(0xFF4f2565),
                        ),
                        child: TextButton(
                          onPressed: isDisabled == true
                              ? null
                              : () async {

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
                            /*................................................ Check First Name.............................................*/

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

                            /*................................................ Check Last Name.............................................*/
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
                            /*................................................ Check User Name.............................................*/


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
                            /*................................................ Check Password.............................................*/

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
                            if (referenceNumber2.text == '') {
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
                            }
                            /*................................................ Check Birthday.............................................*/

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


                            /*................................................Check Passport Photo Front.............................................*/
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
                            /*................................................Check Passport Photo Back.............................................*/

                            if (img64PassportBack == null) {
                              setState(() {
                                imagePassportRequiredBack = true;
                              });
                            }
                            if (img64PassportBack != null) {
                              setState(() {
                                imagePassportRequiredBack = false;
                              });
                            }


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
                            /*................................................ Check Location.............................................*/
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
                            }

                            /*................................................ Check isMigrate.............................................*/

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
                            /*................................................ Image Location.............................................*/

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


                            /*................................................ ....... ....... ....... ............................................*/

                           /* if (PermessionDeliveryEShop.contains('05.02.02.03')) {
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
                            }*/



                            /*................................................ ....... ....... ....... ............................................*/



                            if(isMigrate==true){
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
                             if(recontract==false ) {
                               /****Start***/
                               if(on_BEHALF==true && reseller==true){
                                 if (
                                 buildingCode.text !='' &&
                                     img64Passport != null &&
                                     img64PassportBack != null &&
                                     referenceNumber.text != '' &&
                                     UserName.text != '' &&
                                     Password.text != '' &&
                                     referenceNumber2.text != '' &&
                                     FirstName.text != '' &&
                                     selectedCounrty_key != null &&
                                     LastName.text != '' &&
                                     day.text != '' &&
                                     month.text != '' &&
                                     year.text != ''&&
                                     selectedBEHALF_key !=null &&
                                     selectedReseller_key !=null&&
                                     mbbMsisdn.text != '') {
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

                               if(on_BEHALF==false && reseller==false){
                                 if (
                                 buildingCode.text !='' &&
                                     img64Passport != null &&
                                     img64PassportBack != null &&
                                     referenceNumber.text != '' &&
                                     UserName.text != '' &&
                                     Password.text != '' &&
                                     referenceNumber2.text != '' &&
                                     FirstName.text != '' &&
                                     selectedCounrty_key != null &&
                                     LastName.text != '' &&
                                     day.text != '' &&
                                     month.text != '' &&
                                     year.text != ''&&
                                     mbbMsisdn.text != '') {
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
                               /****End****/

                             }

                             if(recontract==true){
                               if(on_BEHALF==true && reseller==true){
                                 if (
                                 buildingCode.text !='' &&
                                     img64Passport != null &&
                                     img64PassportBack != null &&
                                     referenceNumber.text != '' &&
                                     referenceNumber2.text != '' &&
                                     FirstName.text != '' &&
                                     selectedCounrty_key != null &&
                                     LastName.text != '' &&
                                     day.text != '' &&
                                     month.text != '' &&
                                     year.text != ''&&
                                     selectedBEHALF_key !=null &&
                                     selectedReseller_key !=null&&
                                     mbbMsisdn.text != '') {
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
                               if(on_BEHALF==false && reseller==false){
                                 if (
                                 buildingCode.text !='' &&
                                     img64Passport != null &&
                                     img64PassportBack != null &&
                                     referenceNumber.text != '' &&

                                     referenceNumber2.text != '' &&
                                     FirstName.text != '' &&
                                     selectedCounrty_key != null &&
                                     LastName.text != '' &&
                                     day.text != '' &&
                                     month.text != '' &&
                                     year.text != ''&&
                                     mbbMsisdn.text != '') {
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

                            if(isMigrate==false){
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
                              if(recontract==false ){
                                if(on_BEHALF==true && reseller==true){
                                  if (
                                  buildingCode.text !='' &&
                                      img64Passport != null &&
                                      img64PassportBack != null &&
                                      referenceNumber.text != '' &&
                                      UserName.text != '' &&
                                      Password.text != '' &&
                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
                                      selectedCounrty_key != null &&
                                      LastName.text != '' &&
                                      day.text != '' &&
                                      month.text != '' &&
                                      year.text != ''&&
                                      selectedBEHALF_key !=null &&
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
                                          'Are you sure you want to save data');

                                    }
                                  }else{
                                    showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }
                                }

                                if(on_BEHALF==false && reseller==false){
                                  if (
                                  buildingCode.text !='' &&
                                      img64Passport != null &&
                                      img64PassportBack != null &&
                                      referenceNumber.text != '' &&
                                      UserName.text != '' &&
                                      Password.text != '' &&
                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
                                      selectedCounrty_key != null &&
                                      LastName.text != '' &&
                                      day.text != '' &&
                                      month.text != '' &&
                                      year.text != '') {
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

                              if(recontract==true ){
                                if(on_BEHALF==true && reseller==true){
                                  if (
                                  buildingCode.text !='' &&
                                      img64Passport != null &&
                                      img64PassportBack != null &&
                                      referenceNumber.text != '' &&
                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
                                      selectedCounrty_key != null &&
                                      LastName.text != '' &&
                                      day.text != '' &&
                                      month.text != '' &&
                                      year.text != ''&&
                                      selectedBEHALF_key !=null &&
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
                                          'Are you sure you want to save data');

                                    }
                                  }else{
                                    showToast("Notifications_Form.notifications_required_fields".tr().toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }
                                }

                                if(on_BEHALF==false && reseller==false){
                                  if (
                                  buildingCode.text !='' &&
                                      img64Passport != null &&
                                      img64PassportBack != null &&
                                      referenceNumber.text != '' &&
                                      referenceNumber2.text != '' &&
                                      FirstName.text != '' &&
                                      selectedCounrty_key != null &&
                                      LastName.text != '' &&
                                      day.text != '' &&
                                      month.text != '' &&
                                      year.text != '') {
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





                          },
                          style: TextButton.styleFrom(
                            backgroundColor: isDisabled==true?Colors.transparent:Color(0xFF4f2565),
                            shape: const BeveledRectangleBorder(
                                borderRadius: BorderRadius.all(Radius.circular(24))),
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
        ),onWillPop:onWillPop )
    );
  }
}


