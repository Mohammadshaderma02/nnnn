import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:io' as Io;
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/EKYC/GlobalVariables/global_variables.dart';
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
import 'package:camera/camera.dart';

import '../../../../Corporate/Multi_Use_Components/RequiredField.dart';
import 'GSM_contract_details.dart';
import '../PostpaidIdentificationSelfRecording.dart';

class JordainianCustomerInformation extends StatefulWidget {
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
  final bool sendOtp;
  final bool showSimCard;
  final String price;
  final bool isArmy;
  final bool showCommitmentList;

  JordainianCustomerInformation(
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
  _JordainianCustomerInformationState createState() =>
      _JordainianCustomerInformationState(
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

class _JordainianCustomerInformationState
    extends State<JordainianCustomerInformation> {
  var role;
  var outDoorUserName;
  final List<dynamic> Permessions;
  final String msisdn;
  final String passportNumber;
  final String nationalNumber;
  final String packageCode;
  final sendOtp;
  final showSimCard;
  final price;
  var userName;

  final picker = ImagePicker();
  File imageFile;
  File imageFileIDFront;
  File imageFileIDBack;

  String img64Front;
  String img64Back;
  String img64Contract;

  String localPath;
  bool isAgree = false;

  var password;
  String marketType;
  String _dataKitCode = "";
  bool isJordainian = true;
  bool show_SendOTP = true;
  final bool isArmy;
  final bool showCommitmentList;
  var commitmentList = [];
  var selectedCommitment;
  APP_URLS urls = new APP_URLS();

  _JordainianCustomerInformationState(
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

  TextEditingController NationalNumber = TextEditingController();

  TextEditingController MSISDN = TextEditingController();

  TextEditingController MarketType = TextEditingController();
  TextEditingController PackageName = TextEditingController();

  TextEditingController referenceNumber = TextEditingController();

  TextEditingController otp = TextEditingController();

  TextEditingController kitCode = TextEditingController();
  TextEditingController simCard = TextEditingController();
  TextEditingController MilitaryNumber = TextEditingController();

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

  bool successFlag = false;
  bool imageIDFrontRequired = false;
  bool imageIDBackRequired = false;

  bool imageContractRequired = false;

  bool showCircular = false;
  String packagesSelect;

  bool emptySimCard = false;
  bool errorSimCard = false;

  bool emptyMilitaryNumber = false;

  File imageFileFrontID;
  bool _loadIdFront = false;
  var pickedFileFrontId;

  File imageFileBackID;
  bool _loadIdBack = false;
  var pickedFileBackId;

  File imageFileContract;
  bool _loadContract = false;
  var pickedFileContract;

  bool isDisabled = false;

  int imageWidth = 200;
  int imageHeight = 200;

  final _picker = ImagePicker();
  String New_price;
  String General_price;
  String Old_price;
  bool emptyCommitmentList = false;

  TextEditingController scheduledDate = TextEditingController();
  bool emptyScheduledDate = false;
  DateTime from = DateTime.now();

  bool claim = false;
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

/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
/*...........................................Document Expiry Date.........................................*/
  bool emptyDocumentExpiryDate=false;
  TextEditingController documentExpiryDate = TextEditingController();
  DateTime Expiry_Date = DateTime.now();

/*........................................................................................................*/

  ValidateKitCodeRqBloc validateKitCodeRqBloc;
  bool isloading = false;

  void initState() {
    LookupON_BEHALF();
    LookupON_Reseller();
    print("____________ShowSimCard__________________");
    print(showSimCard);
    print("____________------------__________________");

    print("------------showCommitmentList-------------");
    if (showCommitmentList == true) {
      commitmentlist_API();
    }
    print("______________------------_________________");

    super.initState();
    referenceNumber.text = this.msisdn;
    /*setState(() {
      New_price = this.price;
    });*/
    // retrieve_updated_price_API();
    setState(() {
      Old_price = price;
      General_price = price;
    });
    print(price);
    print(Old_price);
    print(General_price);
    print(this.price);
    print("price");
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
    NationalNumber.text = nationalNumber;
    MSISDN.text = msisdn;
  }


  /*********************************************New 4-SEP-2023******************************************/
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
  /*****************************************************************************************************/

  /*..............................................New CLAIM 13-SEP-2023.......................................*/
  void changeCLAIM(value) async {
    setState(() {
      claim = !claim;
    });
    //  Update_Price();
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

  //**----> This Function will be called before generet contract regardes the value of claim
  /*void Update_Price() async {
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
  }*/
  void Update_Price() async {
    retrieve_updated_price_API();
  }

  /*................................................End New................................................*/
  /*.......................................................................................................*/
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
      "IsJordanian": true,
      "NationalNo": this.nationalNumber,
      "PassportNo": null,
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
      print('----------------HAYA HAZAIMEH---------------');
      print(result["data"]);
      if (result["data"] == null) {}
      if (result["status"] == 0) {
        print(result["data"]);
        setState(() {
          General_price = result["data"]["price"].toString();
        });
        print(price);
        print(General_price);

        if (globalVars.SanadPassed){
          _showPriceConfirmationDialog();
        }else{
          // Navigate to video recording screen instead of showing dialog
          _navigateToVideoRecording();
        }

      } else {}

      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL + '/Postpaid/preSubmitValidation');

      return result;
    } else {}
  }
  /*****************************************************************************************************/
  
  // Navigate to video recording screen for eKYC
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
      
      // Navigate to shared video recording screen
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
              
              // Show confirmation dialog with price
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
  
  // Show price confirmation dialog after video recording
  void _showPriceConfirmationDialog() {
    showAlertDialogSaveData(
        context,
        ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
        'The total amount required is ${General_price}JD are you sure you want to continue?');
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
    final bytes = File(pickedFileFrontId.path).readAsBytesSync().lengthInBytes;

    final kb = bytes / 1024;
    final mb = kb / 1024;

    print('size in mb before crop ${mb}');

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

  _cropImageFront(Io.File picture) async {
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
          print('img64Crop: ${img64Front}');
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

  _cropImageContract(Io.File picture) async {
    CroppedFile cropped = await ImageCropper().cropImage(
      sourcePath: picture.path,
      /* aspectRatioPresets: [
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

  void clearImageIDFront() {
    /* this.setState(()=>
    imageFileID = null );*/

    this.setState(() {
      img64Front=null;
      _loadIdFront = false;
      pickedFileFrontId = null;

      ///here
    });
  }

  void clearImageIDBack() {
    this.setState(() {
      img64Back = null;
      _loadIdBack = false;
      pickedFileBackId = null;

      ///here
    });
  }

  void clearImageContract() {
    /* this.setState(()=>
    imageFileID = null );*/

    this.setState(() {
      img64Contract = null;
      _loadContract = false;
      pickedFileContract = null;

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
                  role=="MadaOutdoor"?Container():   GestureDetector(
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
                  role=="MadaOutdoor"?Container():  GestureDetector(
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
          isloading = true;
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
            buildingCode: null,
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
            ContractImageBase64: img64Contract,
            locationScreenshotImageBase64: null,
            extraFreeMonths: null,
            extraExtender: null,
            simCard: marketType == "GSM"
                ? simCard.text
                : showSimCard == true
                ? simCard.text
                : null,
            contractImageBase64: img64Contract,
            isClaimed: claim,
            note: selectedCommitment,
            militaryID: MilitaryNumber.text,
            scheduledDate: scheduledDate.text,
            onBehalfUser: selectedBEHALF_key == null ? "" : selectedBEHALF_key,
            resellerID: selectedReseller_key == null ? "" : selectedReseller_key));
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
    setState(() {
      isloading = true;
    });
    print(referenceNumber.text);
    print(msisdn);
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
      setState(() {
        isloading = false;
      });
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

                        ]))
              ]),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  //  referenceNumber.clear();
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
                      isloading = true;
                    });
                  }
                  if (state is VerifyOTPSCheckMSISDNErrorState) {
                    setState(() {
                      showCircular = false;
                      isloading = false;
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
                      isloading = false;
                    });
                    //Navigator.of(context).pop();
                    setState(() {
                      otp.text = '';
                      successFlag = true;
                      show_SendOTP = false;
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
      /* else{
        Widget tryAgainButton = FlatButton(
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
                ? result['message']
                : result['messageAr'],
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
      }*/
    }
    else{
      setState(() {
        isloading = false;
      });
    }
  }

  /********************************************************4-Sep-2023******************************************************************/
  Widget buildMilitaryNumber() {
    return SizedBox(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "Postpaid.MilitaryNumber".tr().toString(),
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
              controller: MilitaryNumber,
              keyboardType: TextInputType.phone,
              style: TextStyle(color: Color(0xff11120e)),
              decoration: InputDecoration(
                enabledBorder: emptyMilitaryNumber == true
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
                hintText: "Enter_MilitaryNumber".tr().toString(),
                hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
              ),
            ),
          ),
        ],
      ),
    );
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
                  value: selectedCommitment,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedCommitment = newValue;
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

  /************************************************************************************************************************************/
  /***************************************************************12-Sep-2023***********************************************************/
  Widget buildScheduledDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.ScheduledDate".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          //  alignment: Alignment.centerLeft,

          width: MediaQuery.of(context).size.width / 1.1,
          child: TextField(
            controller: scheduledDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(
              color: Color(0xFF656565),
            ),
            decoration: new InputDecoration(
              enabledBorder: emptyScheduledDate == true
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
              suffixIcon: Container(
                child: IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      color: Color(0xffa4b0c1),
                    ),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        //firstDate: DateTime(DateTime.now().year,),
                        firstDate: DateTime.now().subtract(Duration(days: 0)),
                        // lastDate:DateTime(DateTime.now().year+25,),
                        // lastDate:DateTime(2023, 10, 30),
                        lastDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day + 30),

                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF4f2565), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Color(0xFF656565), // body text color
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
                          from = fromData;
                          scheduledDate.text =
                          "${fromData.year.toString()}-${fromData.month.toString().padLeft(2, '0')}-${fromData.day.toString().padLeft(2, '0')}";
                        }),
                        print(scheduledDate.text)
                      });
                    }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  /************************************************************************************************************************************/
  // ✅ Disabled field for Full Name from EKYC
  Widget buildFullName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Full Name"
                : "الاسم الكامل",
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
            controller: TextEditingController(text: globalVars.fullNameAr ?? ''),
            enabled: false,
            keyboardType: TextInputType.name,
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

  // ✅ Disabled field for Birthdate from EKYC
  Widget buildBirthdate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Date of Birth"
                : "تاريخ الميلاد",
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
            controller: TextEditingController(text: globalVars.birthdate ?? ''),
            enabled: false,
            keyboardType: TextInputType.datetime,
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

  // ✅ Disabled field for Document Expiry Date from EKYC
  Widget buildDocumentExpiryDateFromEKYC() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Document Expiry Date"
                : "تاريخ انتهاء الوثيقة",
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
            controller: TextEditingController(text: globalVars.expirayDate ?? ''),
            enabled: false,
            keyboardType: TextInputType.datetime,
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
          child: showSimCard == true
              ? TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: referenceNumber,
            enabled: false,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                  borderSide:
                  BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(
                  borderSide:
                  BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(
                    color: Color(0xFF4f2565), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          )
              : TextField(
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
                  if (Permessions.contains('05.02.03.02.01') == true) {
                    print(
                        "**************************Darak Flow**************************");
                    print(sendOtp);

                    /*1.To check if MSISDN === Reference Number  ----> SEND OTP optional */
                    /*2.To check if MSISDN !== Reference Number  ----> SEND OTP Automatic */

                    if (referenceNumber.text == this.msisdn) {
                      print("yes");
                      setState(() {
                        errorReferenceNumber = false;
                        show_SendOTP = true;
                      });
                    } else {
                      setState(() {
                        show_SendOTP = false;
                        errorReferenceNumber = false;
                      });
                      SendOtp();
                    }
                    print(
                        "**********************End Darak Flow************************");
                  } else {
                    sendOtp == true ? SendOtp() : null;
                    setState(() {
                      errorReferenceNumber = false;
                    });
                  }
                }
              }
              if (text.length == 0) {
                setState(() {
                  errorReferenceNumber = false;
                  successFlag = false;
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
              enabledBorder: emptyReferenceNumber == true ||
                  errorReferenceNumber == true
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
                    color: Color(0xFF4F2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Postpaid.enter_reference_number".tr().toString(),
              hintStyle:
              TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
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
                              _showPickerContract(context);
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

  void clearKITCODE() {
    setState(() {
      kitCode.text = '';
    });
  }

  void clearSimCard() {
    setState(() {
      simCard.text = '';

      errorSimCard = false;
    });
  }

  _ScanKitCode() async {
    await FlutterBarcodeScanner.scanBarcode(
        "#ff6666", "Cancel", true, ScanMode.BARCODE)
        .then((value) => setState(() => _dataKitCode = value));
    print("haya");
    print(_dataKitCode);
    setState(() {
      simCard.text = _dataKitCode;
    });
    print("ICCID.text");
    print(simCard.text.length);
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
            isloading = false;
          });
          //unReservedLineBloc.add(UnPressReservedLineEvent(kitCode:data['kitCode'].toString()));
        }
        if (state is PostpaidGenerateContractSuccessState) {
          setState(() {
            isDisabled = false;
            isloading = false;
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
                  passportNumber: null,
                  userName: null,
                  password: null,
                  firstName: null,
                  secondName: null,
                  lastName: null,
                  birthdate: null,
                  referenceNumber: referenceNumber.text,
                  referenceNumber2: null,
                  isMigrate: false,
                  mbbMsisdn: null,
                  frontImg: img64Front,
                  backImg: img64Back,
                  passprotImg: null,
                  locationImg: img64Contract,
                  buildingCode: null,
                  extraFreeMonths: null,
                  extraExtender: null,
                  simCard: sendOtp == true ? simCard.text : null,
                  contractImageBase64: img64Contract,
                  note: selectedCommitment,
                  militaryID: MilitaryNumber.text,
                  scheduledDate: scheduledDate.text,
                  isClaimed: claim,
                  onBehalfUser:
                  selectedBEHALF_key == null ? "" : selectedBEHALF_key,
                  resellerID: selectedReseller_key == null ? "" : selectedReseller_key,
                  documentExpiryDate:documentExpiryDate.text
              ),
            ),
          );
        }
      },
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Stack(
            children: [
              Scaffold(
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
                                isArmy == true ? buildMilitaryNumber() : Container(),
                                emptyMilitaryNumber == true
                                    ? ReusableRequiredText(
                                    text: "Postpaid.this_feild_is_required"
                                        .tr()
                                        .toString())
                                    : Container(),
                                SizedBox(height: 10),
                                showCommitmentList == true
                                    ? buildCommitmentlist()
                                    : Container(),

                                // ✅ EKYC captured fields (disabled)
                                SizedBox(height: 10),
                                buildFullName(),
                                SizedBox(height: 10),
                                buildBirthdate(),
                                SizedBox(height: 10),
                                buildDocumentExpiryDateFromEKYC(),
                                
                                SizedBox(height: 10),
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

                                successFlag == true
                                    ? Container(
                                    padding: EdgeInsets.only(top: 2),
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
                                /********************************************** New for Darak Flow 23-May-2023 *****************************************/
                                // show_SendOTP && Permessions.contains('05.02.03.02.01')== true

                                show_SendOTP == true && showSimCard == false
                                    ? Container(
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
                                )
                                    : Container(),
                                SizedBox(
                                  height: 10,
                                ),
                                /********************************************** End Darak Flow 23-May-2023 *****************************************/
                                /*****************************************New 13-Sep-2023**********************************************************/
                                /****************************************************************************************************************/
                                marketType == 'PRETOPOST'
                                    ? buildScheduledDate()
                                    : Container(),
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

                                // reference number 2
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          )
                        ],
                      ),
                    ),
                    // ✅ Removed image capture sections (buildImageIdFront and buildImageIdBack) - images now captured in GSM_NationalityList
                    /* Permessions.contains('05.02.03.01') == true
                  ? Container(
                height: 60,
                padding: EdgeInsets.only(top: 8),
                child: ListTile(
                  leading: Container(
                    width: 280,
                    child: Text(
                      "Handset Contract",
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
                  : Container(),*/
                    showSimCard == true || marketType == 'GSM'
                        ? Column(
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
                          padding:
                          EdgeInsets.only(left: 15, right: 15, bottom: 10),
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(24))),
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
                        marketType == 'GSM' || showSimCard == true
                            ? Container(
                          height: 55,
                          width: 420,
                          margin: const EdgeInsets.only(
                              left: 20.0, right: 20.0),
                          decoration: BoxDecoration(),
                          child: Row(children: <Widget>[
                            Expanded(
                              child: new Container(
                                  margin: const EdgeInsets.only(
                                      left: 10.0, right: 20.0),
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
                                  margin: const EdgeInsets.only(
                                      left: 20.0, right: 10.0),
                                  child: Divider(
                                    color: Colors.black,
                                    height: 36,
                                  )),
                            ),
                          ]),
                        )
                            : Container(),
                        marketType == 'GSM' ||
                            simCard.text != '' ||
                            showSimCard == true
                            ? Container(
                          color: Colors.white,
                          padding: EdgeInsets.only(
                              left: 15, right: 15, top: 10),
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
                                        text:
                                        "Menu_Form.msisdn_required"
                                            .tr()
                                            .toString())
                                        : Container(),
                                    errorSimCard == true
                                        ? ReusableRequiredText(
                                        text: EasyLocalization.of(
                                            context)
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
                        )
                            : Container(),
                      ],
                    )
                        : Container(),

                    SizedBox(
                      height: 20,
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

                            print(price);
                            print(General_price);
                            print('hi');
                            print(img64Front);
                            documentExpiryDate.text=globalVars.expirayDate;
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
                            if(documentExpiryDate.text =="" &&globalVars.expirayDate==""){
                              setState(() {
                                emptyDocumentExpiryDate = true;
                              });
                            }
                            if(documentExpiryDate.text !=""&&globalVars.expirayDate!=""){
                              setState(() {
                                emptyDocumentExpiryDate = false;
                              });
                            }



                            if ((showSimCard == true &&
                                marketType == 'PRETOPOST') ||
                                marketType == 'GSM') {
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
                            }

                            /******************************************** New 4-Sep-2023 ***********************************/
                            if (isArmy == true) {
                              if (MilitaryNumber.text == '') {
                                setState(() {
                                  emptyMilitaryNumber = true;
                                });
                              }
                              if (MilitaryNumber.text != '') {
                                setState(() {
                                  emptyMilitaryNumber = false;
                                });
                              }
                            }
                            if (showCommitmentList == true) {
                              if (selectedCommitment == null) {
                                setState(() {
                                  emptyCommitmentList = true;
                                });
                              }
                              if (selectedCommitment != null) {
                                setState(() {
                                  emptyCommitmentList = false;
                                });
                              }
                            }
                            /***********************************************************************************************/
                            /* if (Permessions.contains('05.02.03.01') == true) {
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
                      }*/
                            /***********************************************************************************************/

                            if (isArmy == true && showCommitmentList == true) {
                              if ((showSimCard == true &&
                                  marketType == 'PRETOPOST') ||
                                  marketType == 'GSM') {
                                if (Permessions.contains('05.02.03.01') ==
                                    true) {
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
                                    if (
                                        //   img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /*showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        //  img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        simCard.text != '' &&
                                        MilitaryNumber.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
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
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }

                                  if (role != "ZainTelesales") {
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        simCard.text != '' &&
                                        MilitaryNumber.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /*  showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                }
                              } else if (showSimCard == false &&
                                  marketType == 'PRETOPOST') {
                                if (Permessions.contains('05.02.03.01') ==
                                    true) {
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
                                    if (
                                        // img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        //  img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
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
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }

                                  if (role != "ZainTelesales") {
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /*  showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                }
                              }
                            }

                            if (isArmy == true && showCommitmentList == false) {
                              if ((showSimCard == true &&
                                  marketType == 'PRETOPOST') ||
                                  marketType == 'GSM') {
                                if (Permessions.contains('05.02.03.01') ==
                                    true) {
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
                                    if (
                                        // img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '') {
                                      Update_Price();
                                      /*    showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        //  img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        simCard.text != '' &&
                                        MilitaryNumber.text != '') {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
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
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '') {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        simCard.text != '' &&
                                        MilitaryNumber.text != '') {
                                      Update_Price();
                                      /*  showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                }
                              } else if (showSimCard == false &&
                                  marketType == 'PRETOPOST') {
                                if (Permessions.contains('05.02.03.01') ==
                                    true) {
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
                                    if (
                                        //  img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '') {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        // img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '') {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
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
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '') {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }

                                  if (role != "ZainTelesales") {
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        MilitaryNumber.text != '') {
                                      Update_Price();
                                      /*showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                }
                              }
                            }

                            if (isArmy == false && showCommitmentList == true) {
                              if ((showSimCard == true &&
                                  marketType == 'PRETOPOST') ||
                                  marketType == 'GSM') {
                                if (Permessions.contains('05.02.03.01') ==
                                    true) {
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
                                    if (
                                        //  img64Contract != null &&
                                        referenceNumber.text != '' &&

                                        documentExpiryDate.text != ''&&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /*showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        //  img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        simCard.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
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
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        simCard.text != '' &&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /*  showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                }
                              } else if (showSimCard == false &&
                                  marketType == 'PRETOPOST') {
                                if (Permessions.contains('05.02.03.01') ==
                                    true) {
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
                                    if (
                                        // img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        // img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
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
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /*  showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        selectedCommitment != null) {
                                      Update_Price();
                                      /*  showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                }
                              }
                            }

                            if (isArmy == false &&
                                showCommitmentList == false) {
                              if ((showSimCard == true &&
                                  marketType == 'PRETOPOST') ||
                                  marketType == 'GSM') {
                                if (Permessions.contains('05.02.03.01') ==
                                    true) {
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
                                    if (
                                        //  img64Contract != null &&
                                        documentExpiryDate.text != ''&&
                                        referenceNumber.text != ''

                                    ) {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        //  img64Contract != null &&
                                        referenceNumber.text != '' &&
                                        documentExpiryDate.text != ''&&
                                        simCard.text != '') {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                } else {
                                  if (
                                      referenceNumber.text != '' &&
                                      documentExpiryDate.text != ''&&
                                      simCard.text != '') {
                                    Update_Price();
                                    /*showAlertDialogSaveData(
                                  context,
                                  ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                  'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                  } else {
                                    showToast(
                                        "Notifications_Form.notifications_required_fields"
                                            .tr()
                                            .toString(),
                                        context: context,
                                        animation: StyledToastAnimation.scale,
                                        fullWidth: true);
                                  }
                                }
                              } else if (showSimCard == false &&
                                  marketType == 'PRETOPOST') {
                                if (Permessions.contains('05.02.03.01') ==
                                    true) {
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
                                    if (
                                        // img64Contract != null &&
                                        documentExpiryDate.text != ''&&
                                        referenceNumber.text != '') {
                                      Update_Price();
                                      /*  showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        // img64Contract != null &&
                                        documentExpiryDate.text != ''&&
                                        referenceNumber.text != '') {
                                      Update_Price();
                                      /* showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
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
                                    if (
                                        documentExpiryDate.text != ''&&
                                        referenceNumber.text != ''  ) {
                                      Update_Price();
                                      /*  showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
                                    }
                                  }
                                  if (role != "ZainTelesales") {
                                    if (
                                        documentExpiryDate.text != ''&&
                                        referenceNumber.text != ''  ) {
                                      Update_Price();
                                      /*    showAlertDialogSaveData(
                                    context,
                                    ' المبلغ الكلي المطلوب هو  ${General_price}  دينار، هل انت متأكد؟  ',
                                    'The total amount required is ${General_price} JD are you sure you want to continue?');*/
                                    } else {
                                      showToast(
                                          "Notifications_Form.notifications_required_fields"
                                              .tr()
                                              .toString(),
                                          context: context,
                                          animation: StyledToastAnimation.scale,
                                          fullWidth: true);
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
              if (isloading)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF4f2565),
                      ),
                    ),
                  ),
                ),
            ],
          )
      ),
    );
  }
}

//////
/**/