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
import 'package:get/utils.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/GSM/Contract/GSM_ContractDetails.dart';

import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';

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

import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';


class nonJordanianInformation extends StatefulWidget {

  final List<dynamic> Permessions;
  var role;
  var orderID;
  var packageName ;
  var packageCode;
  var marketType;
  var driverName;
  var selectedNumber;
  final String refrenceNumber;
  final String passportNumber;
  final String nationalNumber;
  var PaymentMethodSystemName;
  var paymentMethodName;
  var commitment;
  var email;
  var orderTotal;
  var Esim;
  var birthdate;

  final bool sendOtp=true;
  var userName;
  var password;
  bool showSimCard;

  final bool isArmy =false;
  final bool showCommitmentList=false;

  nonJordanianInformation(
      this.Permessions,
      this.role,
      this.orderID,
      this.packageName,
      this.packageCode,
      this.marketType,
      this.driverName,
      this.selectedNumber,
      this.refrenceNumber,
      this.passportNumber,
      this.nationalNumber,
      this.PaymentMethodSystemName,
      this.paymentMethodName,
      this.commitment,
      this.email,
      this.orderTotal,
      this.Esim,
      this.birthdate
      );

  @override
  _nonJordanianInformationState createState() =>
      _nonJordanianInformationState(
          this.Permessions,
          this.role,
          this.orderID,
          this.packageName,
          this.packageCode,
          this.marketType,
          this.driverName,
          this.selectedNumber,
          this.refrenceNumber,
          this.passportNumber,
          this.nationalNumber,
          this.PaymentMethodSystemName,
          this.paymentMethodName,
          this.commitment,
          this.email,
           this.orderTotal,
      this.Esim,
      this.birthdate);
}

class Item {
  const Item(this.value, this.textEn, this.textAr);
  final String value;
  final String textEn;
  final String textAr;
}

class _nonJordanianInformationState
    extends State<nonJordanianInformation> {

  final List<dynamic> Permessions;
  var role;
  var orderID;
  var packageName;
  var packageCode;
  var marketType;
  var driverName;
  var selectedNumber;
  final String refrenceNumber;
  final String passportNumber;
  final String nationalNumber;
  var PaymentMethodSystemName;
  var paymentMethodName;
  var commitment;
  var email;
  var orderTotal;
var Esim;
var birthdate;
  final bool sendOtp=true;
  final bool showSimCard=false;

  var userName;
  String _dataKitCode = "";
  final picker = ImagePicker();
  File imageFile;

  String img64Passport;
  String img64Location;
  String img64Contract;
  bool imageIDFrontRequired = false;
  bool imageIDBackRequired = false;


  String img64Front;
  String img64Back;
  var pickedFileFrontId;
  var pickedFileBackId;
  File imageFileIDFront;
  File imageFileIDBack;
  bool _loadIdFront = false;
  bool _loadIdBack = false;
  File imageFileFrontID = File('');
  File imageFileBackID = File('');
/*............................................Receipt attachment.................................................*/
  var pickedFileSignature;
  bool _loadIdSignature = false;
  File imageFileSignaturet = File('');
  File imageFileSignature;
  String img64Signature;
  bool imageSignature = false;

  bool emptyAuthcode =false;
  bool emptyLastDigits=false;

  bool imageSignatureRequired =false;
/*..............................................................................................................*/
  var givenDate = '';
  var password;

  bool isJordainian = false;
  final bool isArmy=false;
  final bool showCommitmentList=false;
  APP_URLS urls = new APP_URLS();

  _nonJordanianInformationState(
      this.Permessions,
      this.role,
      this.orderID,
      this.packageName,
      this.packageCode,
      this.marketType,
      this.driverName,
      this.selectedNumber,

      this.refrenceNumber,
      this.passportNumber,
      this.nationalNumber,
      this.PaymentMethodSystemName,
      this.paymentMethodName,
      this.commitment,
      this.email,
      this.orderTotal,
      this.Esim,
      this.birthdate);



  /*.................................Package Information........................................*/
  TextEditingController order_ID = TextEditingController();
  TextEditingController MarketType = TextEditingController();
  TextEditingController PackageName = TextEditingController();
  TextEditingController PackageCode = TextEditingController();
  TextEditingController selectNumber = TextEditingController();
  TextEditingController paymentMethod_Name = TextEditingController();
  TextEditingController GETcommitment = TextEditingController();


  /*................................Customer Information........................................*/
  List<String> fullName;
  TextEditingController FirstName = TextEditingController();
  TextEditingController SecondName = TextEditingController();
  TextEditingController ThirdName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController NationalNumber = TextEditingController();
  TextEditingController passport_Number = TextEditingController();
  TextEditingController refrence_Number = TextEditingController();
  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  TextEditingController Birthdate = TextEditingController();


  /*..........................................................................................*/


  TextEditingController otp = TextEditingController();
  TextEditingController simCard = TextEditingController();
  TextEditingController authCode = TextEditingController();
  TextEditingController lastDigits= TextEditingController();


  VerifyOTPSCheckMSISDNBloc verifyOTPSCheckMSISDNBloc;
  SendOTPSCheckMSISDNBloc sendOTPSCheckMSISDNBloc;
  PostpaidGenerateContractBloc postpaidGenerateContractBloc;

  /*........................................Receipt attachment....................................................*/
  var pickedFileReceipt;
  bool _loadReceipt = false;
  File imageFileSReceipt = File('');
  File imageFileReceipt;
  String img64Receipt;
  bool imageReceipt = false;
  bool imageReceiptRequired =false;
/*............................................................................................................*/

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


  bool _loadPassport = false;

  final _picker = ImagePicker();
  bool emptyCommitmentList = false;
  var commitmentList = [];

  var commitmentDefultSelected;
  var rentalPrice;
  var General_price;
  bool e_Sim = false;

  bool activeSubmitButton = true;
  bool checkSubmitResponce = false;

  /*...........................................Document Expiry Date.........................................*/
  bool emptyDocumentExpiryDate=false;
  TextEditingController documentExpiryDate = TextEditingController();
  DateTime Expiry_Date = DateTime.now();

  String referenceNumberValidation_en;
  String referenceNumberValidation_ar;

  void initState() {
    print(this.PaymentMethodSystemName);

    if(Esim==true){
      setState(() {
        e_Sim=true;
        simCard.text="ESIM";
      });
    }
    if(Esim==false){
      setState(() {
        e_Sim=false;
        simCard.text="";
      });
    }
    ValidatePackage_API();
    super.initState();

    /*.........................................For Split Full Name for Customer.......................*/
    fullName = driverName.split(" ");

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
        ThirdName.text ='-';
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

    /*...............................................................................................*/
    /*...............................Get Package Information........................................*/
    setState(() {
      order_ID.text= orderID;
      PackageName.text= packageName;
      PackageCode.text= packageCode;
      MarketType.text=marketType;
      selectNumber.text=selectedNumber;
      paymentMethod_Name.text=paymentMethodName;
      GETcommitment.text = commitment;
      Birthdate.text = birthdate.split('T')[0];

    });
    /*............................................................................................*/
    /*...............................Get Customer Information.....................................*/
    setState(() {
      refrence_Number.text= refrenceNumber;
      passport_Number.text = passportNumber;

    });

    /*............................................................................................*/



    print("______________------------_________________");
    verifyOTPSCheckMSISDNBloc = BlocProvider.of<VerifyOTPSCheckMSISDNBloc>(context);
  }

  Widget buildDashedBorder({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Cancel'
            : "الغاء",
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

  showAlertDialogSaveData(BuildContext context, arabicMessage, englishMessage) {
    Widget close = TextButton(
      child: Text(
        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Close'
            : "اغلاق",

        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pop(context, true);
        otp.clear();
      },
    );
    Widget save = TextButton(
      child: Text(

        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Save'
            : "حفظ",

        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pop(context, true);
        setState(() {
          activeSubmitButton = false;
        });
        Submit_API();

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

  showErroreAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(

        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Cancel'
            : "الغاء",
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

  showSucsessAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? 'Close'
            : "اغلاق",
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pop(
          context,
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => OrdersScreen()),
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

  /*.................................Package Information........................................*/

  Widget buildOrderID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Order ID'
                : "رقم الطلب",
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
            controller: order_ID,
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
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Market Type'
                : "نوع الحزمة",
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
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Package Name'
                : "اسم الحزمة",
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
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Package Code'
                : "رمز الحزمة",
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

  Widget buildSelectedNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:  EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Selected Number'
                : "الرقم المطلوب",
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
            controller: selectNumber,
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

  Widget buildpaymentMethodSystemName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:   EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Payment Method'
                : "طريقة الدفع",
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
            controller: paymentMethod_Name,
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

  Widget buildCommitment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Commitment'
                : "الالتزام",
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
            controller: GETcommitment,
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

  /*...........................................................................................*/

  /*...................................Customer Information....................................*/
  /*Widget buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'First Name'
                : "الاسم الأول",
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          /*2024  style: TextStyle(color: Color(0xff11120e)),
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter first name'
                  : "ادخل الاسم الاول",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),*/
          ),
        ),
      ],
    );
  }*/
  Widget buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'First Name'
                : "الاسم الأول",
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
            controller: FirstName,
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),/*TextField(
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter first name'
                  : "ادخل الاسم الاول",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),*/
        ),
      ],
    );
  }

  /*Widget buildSecondName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Second Name'
                : "الاسم الثاني",
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
        /*    style: TextStyle(color: Color(0xff11120e)),
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter second name'
                  : "ادخل الاسم الثاني",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),*/
          ),
        ),
      ],
    );
  }*/
  Widget buildSecondName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Second Name'
                : "الاسم الثاني",
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
          child:TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: SecondName,
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ), /*TextField(
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter second name'
                  : "ادخل الاسم الثاني",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          )*/
        ),
      ],
    );
  }

  /*Widget buildThirdName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Third Name'
                : "الاسم الثالث",
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          /*  style: TextStyle(color: Color(0xff11120e)),
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter third name'
                  : "ادخل الاسم الثالث",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),*/
          ),
        ),
      ],
    );
  }*/
  Widget buildThirdName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Third Name'
                : "الاسم الثالث",
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
            controller: ThirdName,
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),
          /*TextField(
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter third name'
                  : "ادخل الاسم الثالث",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),*/
        ),
      ],
    );
  }

 /* Widget buildLastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Last Name'
                : "الاسم الأخير",
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
            //2024 enabled: true,
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),



        /*2024    style: TextStyle(color: Color(0xff11120e)),
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter last name'
                  : "ادخل الاسم الاخير",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),*/
          ),
        ),
      ],
    );
  }*/
  Widget buildLastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Last Name'
                : "الاسم الأخير",
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
          child:  TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: LastName,
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
            ),
          ),/*TextField(
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter last name'
                  : "ادخل الاسم الاخير",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),*/
        ),
      ],
    );
  }

  Widget buildBirthDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Birth Date'
                : "تاريخ الميلاد",
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
            controller: Birthdate,
            //2024 enabled: true,
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
  /*Widget buildBirthDate() {
    return Column(
      children: [
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: EasyLocalization
                      .of(context)
                      .locale == Locale("en", "US")
                      ? 'Birth Date'
                      : "تاريخ الميلاد",
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
                                color: Color(0xFF392156), width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText: EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'dd'
                              : "اليوم",
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
                          hintText: EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'mm'
                              : "الشهر",
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
                          EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'yyyy'
                              : "السنة",
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
          text:  EasyLocalization.of(context).locale == Locale("en", "US")
              ? 'This feild is required'
              : "هذا الحقل مطلوب",)
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
  }*/

 /* Widget buildBirthDate() {
    return Column(
      children: [
        SizedBox(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              RichText(
                text: TextSpan(
                  text: EasyLocalization
                      .of(context)
                      .locale == Locale("en", "US")
                      ? 'Birth Date'
                      : "تاريخ الميلاد",
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
                                color: Color(0xFF392156), width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText: EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'dd'
                              : "اليوم",
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
                                color: Color(0xFF392156), width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText: EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'mm'
                              : "الشهر",
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
                                color: Color(0xFF392156), width: 1.0),
                          ),
                          contentPadding: EdgeInsets.all(16),
                          hintText:
                          EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'yyyy'
                              : "السنة",
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
          text:  EasyLocalization.of(context).locale == Locale("en", "US")
              ? 'This feild is required'
              : "هذا الحقل مطلوب",)
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
  }*/

  Widget buildPassportNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Passport Number'
                : "رقم جواز السفر",
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
            controller: passport_Number,
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

  Widget buildReferenceNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Reference Number'
                : "رقم المرجعي",
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
            controller: refrence_Number,
           // maxLength: 10,
            onChanged: (text) {
              sendOtp == true ? SendOtp() : null;
              setState(() {
                errorReferenceNumber = false;
              });
            /*  if (text.length == 10) {
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
              }*/
            },
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            keyboardType: TextInputType.phone,

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
              hintText:EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Enter reference number': "ادخل رقم المرجعي",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
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
      body: jsonEncode({"msisdn": refrence_Number.text}),
    );

    print('called');

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
              EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Verify Code'
                  : "رقم التحقق",
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
                                EasyLocalization
                                    .of(context)
                                    .locale == Locale("en", "US")
                                    ? 'Enter OTP'
                                    : "ادخل الرمز",
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
                                  EasyLocalization
                                      .of(context)
                                      .locale == Locale("en", "US")
                                      ? 'enter otp'
                                      : "ادخل رمز التحقق",
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
                  // referenceNumber.clear();
                  // Navigator.of(context).pop();
                  setState(() {
                    otp.text = '';
                    refrence_Number.text="";
                  });
                  Navigator.pop(context, true);
                },
                child: Text(
                  EasyLocalization
                      .of(context)
                      .locale == Locale("en", "US")
                      ? 'Cancel'
                      : "إلغاء",
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
                    });
                    Navigator.pop(context, true);
                  }
                },
                child: TextButton(
                  onPressed: () {
                    // Navigator.of(ctx).pop();
                    verifyOTPSCheckMSISDNBloc.add(VerifyOTPSCheckMSISDNPressed(
                        msisdn: refrence_Number.text, otp: otp.text));
                    //Navigator.of(ctx).pop();
                  },
                  child: Text(
                    EasyLocalization
                        .of(context)
                        .locale == Locale("en", "US")
                        ? 'Verify'
                        : "تحقق",
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
          referenceNumberValidation_en=result["message"];
          referenceNumberValidation_ar=result["messageAr"];

        });
      }
    }
  }

  showAlertDialogVerify(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".toString(),
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

  /*...........................................................................................*/
  /*.........................................Passport Information....................................*/
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
                                          EasyLocalization
                                              .of(context)
                                              .locale == Locale("en", "US")
                                              ? 'Preview Photo'
                                              : "عرض الصورة",
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
                                EasyLocalization
                                    .of(context)
                                    .locale == Locale("en", "US")
                                    ? 'Retake Photo'
                                    : "اعادة التقاط",
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
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Take Photo'
                                        : "التقاط صورة",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  /* Text(
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Retake Photo+hh'
                                        : "اعادة التقاط",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Color(0xFF0070c9),
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),*/
                                ],
                              )
                                  : Column(
                                mainAxisAlignment:
                                MainAxisAlignment.center,
                                children: [
                                  Text(
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Take Photo'
                                        : "التقاط صورة",
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
            text:EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'This feild is required'
                : "هذا الحقل مطلوب",)
              : Container(),
        ]),
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
          showToast("Notifications_Form.size_mb".toString(),
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
      });
    }
  }

  void clearImageIDFront() {
    this.setState(() {
      _loadIdFront = false;
      pickedFileFrontId = null;
    });
  }

  void printLongString(String text) {
    final RegExp pattern =
    RegExp('.{1,10000}'); // 100000 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
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
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Select Option'
                            : "حدد مكان الصورة",
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
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Open Camera'
                              : "افتح الكاميرا",
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
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Open Gallery'
                              : "افتح المعرض",
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


  /*...........................................................................................*/
  /*...................................SimCard Information....................................*/
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
    setState(() {
      simCard.text = _dataKitCode;
    });
  }

  Widget _SIMCARD() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'SimCard'
                : "شريحة الجوال",
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: IconButton(
                onPressed: clearSimCard,
                icon: Icon(Icons.close),
                color: Color(0xFFA4B0C1),
              ),
              hintText: EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Enter simcard'
                  : "أدخل رقم الشريحة ",
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  /*void changeEsim(value) async {
    setState(() {
      e_Sim = !e_Sim;
    });
    if(e_Sim == true){
      setState(() {
        simCard.text="ESIM";
      });
    }
    if(e_Sim == false){
      setState(() {
        simCard.text="";
      });
    }
  }

  Widget buildEsim() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: e_Sim,
            onChanged:null /*(value) {
              changeEsim(value);
            }*/,
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'CLAIM'
                : "المطالبة",
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }*/

  void changeEsim(value) async {
    setState(() {
      e_Sim = !e_Sim;
    });
    if(e_Sim == true){
      setState(() {
        simCard.text="ESIM";
      });
    }
    if(e_Sim == false){
      setState(() {
        simCard.text="";
      });
    }
  }

  Widget buildEsim() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: e_Sim,
            onChanged: (value) {
              changeEsim(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'CLAIM'
                : "المطالبة",
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  /*..........................................................................................*/
  /*.....................................Signature attachment...................................*/
  Widget buildImageSignature() {
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
                child: _loadIdSignature== true
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
                                image: FileImage(imageFileSignature),
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
                                                        imageFileSignature),
                                                  ),
                                                  // A simplified version of dialog.
                                                  width: 300.0,
                                                  height: 350.0,
                                                )));
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          EasyLocalization
                                              .of(context)
                                              .locale == Locale("en", "US")
                                              ? 'Preview Photo'
                                              : "عرض الصورة",
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
                              _showPickerSignature(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                EasyLocalization
                                    .of(context)
                                    .locale == Locale("en", "US")
                                    ? 'Retake Photo'
                                    : "اعادة التقاط",
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
                        _showPickerSignature(context);
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
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Take Photo'
                                        : "التقاط صورة",
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
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Take Photo'
                                        : "التقاط صورة",
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
          imageSignatureRequired == true
              ? ReusableRequiredText(
            text:EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'This feild is required'
                : "هذا الحقل مطلوب",)
              : Container(),
        ]),
      ),
    );
  }

  void pickImageSignatureCamera() async {
    pickedFileSignature = await _picker.pickImage(
      source: ImageSource.camera,
    );


    if (pickedFileSignature != null) {
      imageFileSignature = File(pickedFileSignature.path);
      _loadIdSignature = true;
      var imageName = pickedFileSignature.path.split('/').last;

      calculateImageSize(pickedFileSignature.path);

      if (pickedFileSignature != null) {
        _cropImageSignature(File(pickedFileSignature.path));
      }
    }
  }

  void pickImageSignatureGallery() async {
    pickedFileSignature = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileSignature != null) {
      imageFileSignature = File(pickedFileSignature.path);
      _loadIdSignature = true;
      var imageName = pickedFileSignature.path.split('/').last;
      calculateImageSize(pickedFileSignature.path);
      if (pickedFileSignature != null) {
        _cropImageSignature(File(pickedFileSignature.path));
      }
    }
  }

  _cropImageSignature(Io.File picture) async {
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
          showToast("Notifications_Form.size_mb".toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadIdSignature = false;
            pickedFileSignature = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Signature = base64Encode(base64Image);
          print('img64Crop after crop:');
          printSignatureLongString(img64Signature);
          imageFileSignaturet = File(cropped.path);

        }
      });
    } else {
      this.setState(() {
        _loadIdSignature = false;
        pickedFileSignature = null;

        ///here
      });
    }
  }

  void clearImageSignature() {
    this.setState(() {
      _loadIdSignature = false;
      pickedFileSignature = null;

    });
  }

  void printSignatureLongString(String text) {
    final RegExp pattern =
    RegExp('.{1,10000}'); // 100000 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  void _showPickerSignature(context) {
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
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Select Option'
                            : "حدد مكان الصورة",
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
                      pickImageSignatureCamera();
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
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Open Camera'
                              : "افتح الكاميرا",
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
                      pickImageSignatureGallery();
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
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Open Gallery'
                              : "افتح المعرض",
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

  void calculateSignatureImageSize(String path) {
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

  /*...........................................................................................*/
  /*..................................Receipt Information....................................*/
  Widget buildImageIdReceipt() {
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
                child: _loadReceipt == true
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
                                image: FileImage(imageFileReceipt),
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
                                                        imageFileReceipt),
                                                  ),
                                                  // A simplified version of dialog.
                                                  width: 300.0,
                                                  height: 350.0,
                                                )));
                                      },
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Text(
                                          EasyLocalization
                                              .of(context)
                                              .locale == Locale("en", "US")
                                              ? 'Preview Photo'
                                              : "عرض الصورة",
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
                              _showPickerReceipt(context);
                            },
                            child: Align(
                              alignment: Alignment.center,
                              child: Text(
                                EasyLocalization
                                    .of(context)
                                    .locale == Locale("en", "US")
                                    ? 'Retake Photo'
                                    : "اعادة التقاط",
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
                        _showPickerReceipt(context);
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
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Take Photo'
                                        : "التقاط صورة",
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
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Take Photo'
                                        : "التقاط صورة",
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
          imageReceiptRequired == true
              ? ReusableRequiredText(
            text:EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'This feild is required'
                : "هذا الحقل مطلوب",)
              : Container(),
        ]),
      ),
    );
  }

  void pickImageCameraReceipt() async {
    pickedFileReceipt = await _picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFileReceipt != null) {
      imageFileReceipt = File(pickedFileReceipt.path);
      _loadReceipt = true;

      var imageName = pickedFileReceipt.path.split('/').last;
      calculateReceiptImageSize(pickedFileReceipt.path);

      if (pickedFileReceipt != null) {
        _cropImageReceipt(File(pickedFileReceipt.path));
      }
    }
  }

  void pickImageGalleryReceipt() async {
    pickedFileReceipt= await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileReceipt != null) {
      imageFileReceipt = File(pickedFileReceipt.path);
      _loadReceipt = true;
      var imageName = pickedFileReceipt.path.split('/').last;
      calculateReceiptImageSize(pickedFileReceipt.path);

      if (pickedFileReceipt != null) {
        _cropImageReceipt(File(pickedFileReceipt.path));
      }
    }
  }

  _cropImageReceipt(Io.File picture) async {
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
          showToast("Notifications_Form.size_mb".toString(),
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          this.setState(() {
            _loadReceipt = false;
            pickedFileReceipt = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64Receipt = base64Encode(base64Image);
          print('img64CropReceipt after crop:');
          printReceiptLongString(img64Receipt);
          imageFileReceipt = File(cropped.path);

        }
      });
    } else {
      this.setState(() {
        _loadReceipt = false;
        pickedFileReceipt = null;
      });
    }
  }

  void clearImageReceipt() {
    this.setState(() {
      _loadReceipt = false;
      pickedFileReceipt = null;
    });
  }

  void printReceiptLongString(String text) {
    final RegExp pattern =
    RegExp('.{1,10000}'); // 100000 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  void _showPickerReceipt(context) {
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
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Select Option'
                            : "حدد مكان الصورة",
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
                      pickImageCameraReceipt();
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
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Open Camera'
                              : "افتح الكاميرا",
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
                      pickImageGalleryReceipt();
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
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'Open Gallery'
                              : "افتح المعرض",
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

  void calculateReceiptImageSize(String path) {
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
          showToast("Notifications_Form.size_mb".toString(),
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
  /*..........................................................................................*/
  /*..........................................................................................*/
  /*....................................Other Information.....................................*/
  Widget buildAuthcode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Auth code'
                : "رمز المصادقة",
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
            controller: authCode,
            enabled: true,
            maxLength: 6,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyAuthcode == true
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? '6 digits'
                  : "6 أرقام",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildLast4digits() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization
                .of(context)
                .locale == Locale("en", "US")
                ? 'Last 4 digits'
                : "آخر 4 أرقام",
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
            controller: lastDigits,
            enabled: true,
            keyboardType: TextInputType.name,
            maxLength: 4,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyLastDigits == true
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
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")
                  ? 'Last 4 digits'
                  : "آخر 4 أرقام",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
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
                                    0xFF392156), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary:
                                  Color(0xFF392156), // button text color
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


  /*..........................................................................................*/
  /*...................................Updated Price API......................................*/

  void retrieve_updated_price_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map test = {
      "MarketType": this.marketType,
      "IsJordanian": false,
      "NationalNo":"",
      "PassportNo": this.passportNumber,
      "PackageCode": this.packageCode,
      "Msisdn": selectNumber.text,
      "isClaimed": false
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
          rentalPrice=result["data"]["rentalPrice"];
        });


      } else {}

      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL + '/Postpaid/preSubmitValidation');

      return result;
    } else {}
  }

  /*...........................................................................................*/
  /*.................................Validate Package API....................................*/

  void ValidatePackage_API() async {
    setState(() {
      activeSubmitButton=false;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/validate';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body:jsonEncode({
        "msisdn": selectNumber.text,
        "isJordanian": false,
        "nationalNo": this.passportNumber,
        "passportNo": "",
        "packageCode": packageCode}),
    );
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      showErroreAlertDialog(context,"401","401");
      setState(() {
        activeSubmitButton=false;
      });

    }
    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result["data"]);
      if (result["data"] == null) {}
      if (result["status"] == 0) {
       // retrieve_updated_price_API();
        setState(() {
          activeSubmitButton=true;
        });
      } else {
        showErroreAlertDialog(context,result["messageAr"],result["message"]);
        setState(() {
          activeSubmitButton=false;
        });
      }

      print(urls.BASE_URL + '/Prepaid/validate');

      return result;
    } else {
      showErroreAlertDialog(context,statusCode.toString(),statusCode.toString());
      setState(() {
        activeSubmitButton=false;
      });
    }
  }

  /*...........................................................................................*/
  /*.................................Submit Information API....................................*/

  void Submit_API() async {
    setState(() {
      activeSubmitButton=false;
      checkSubmitResponce=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();

    Map test = {
      "msisdn": selectNumber.text,
      "isJordanian": false,
      "nationalNo": "",
      "passportNo": this.passportNumber,
      "packageCode": packageCode,
      "firstName": FirstName.text,
      "secondName": SecondName.text,
      "thirdName": ThirdName.text,
      "lastName": LastName.text,
      "birthDate": Birthdate.text,//givenDate,
      "eshopOrderId": orderID,
      "authCode": authCode.text,
      "last4Digits": lastDigits.text,
      "email": email,
      "isEsim": e_Sim,
      "simCard": e_Sim==true?"ESIM":simCard.text,
      "frontIdImageBase64": null,
      "backIdImageBase64": null,
      "passportImageBase64": img64Front,
      "backPassportImageBase64": null,
      "signatureImageBase64":img64Signature,// img64Signature,
      "receiptImageBase64": img64Receipt,
      "documentExpiryDate":documentExpiryDate.text
    };


    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Prepaid/submit';
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
      showErroreAlertDialog(context,"401","401");
      setState(() {
        activeSubmitButton=true;
        checkSubmitResponce=false;
      });

    }
    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result["data"]);

      if (result["status"] == 0) {
        setState(() {
          activeSubmitButton=true;
          checkSubmitResponce=false;
        });
        showSucsessAlertDialog(context,result["messageAr"],result["message"]);

      } else {
        showErroreAlertDialog(context,result["messageAr"],result["message"]);
        setState(() {
          activeSubmitButton=true;
          checkSubmitResponce=false;
        });

      }

      print('-------------------------------');
      print(urls.BASE_URL + '/Prepaid/submit');

      return result;
    } else {
      showErroreAlertDialog(context,statusCode.toString(),statusCode.toString());
      setState(() {
        activeSubmitButton=true;
        checkSubmitResponce=false;
      });

    }
  }

  /*...........................................................................................*/

  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
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

              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Customer Information'
                  : "معلومات العميل",
            ),
            backgroundColor: Color(0xFF392156),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: Stack(
            children: [
              ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
                /*...........................................Package Information............................................*/
                Container(
                  color: Color(0xFFEBECF1),
                  padding:
                  EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 15),
                  child: Text(
                    EasyLocalization
                        .of(context)
                        .locale == Locale("en", "US")
                        ? 'Package Information'
                        : "معلومات الحزمة",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.bold),
                  ),),
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
                            SizedBox(
                              height: 10,
                            ),
                            buildMarketType(),
                            SizedBox(
                              height: 10,
                            ),
                            buildPackageName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildPackageCode(),
                            SizedBox(
                              height: 10,
                            ),
                            buildSelectedNumber(),
                            SizedBox(
                              height: 10,
                            ),
                            buildpaymentMethodSystemName(),
                            /*   SizedBox(
                              height: 10,
                            ),
                              buildCommitment(),

                            SizedBox(
                              height: 10,
                            ),*/



                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*..........................................................................................................*/
                /*..........................................Customer Information............................................*/
                Container(
                  color: Color(0xFFEBECF1),
                  padding:
                  EdgeInsets.only(left: 16, right: 10, top: 15, bottom: 15),
                  child:  Text(
                    EasyLocalization
                        .of(context)
                        .locale == Locale("en", "US")
                        ? 'Customer Information'
                        : "معلومات شخصية",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.bold),
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
                            buildFirstName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildSecondName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildThirdName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildLastName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildBirthDate(),

                            buildPassportNumber(),
                            SizedBox(
                              height: 10,
                            ),
                            buildReferenceNumber(),
                            emptyReferenceNumber == true
                                ? ReusableRequiredText(
                              text:  EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? 'This feild is required'
                                  : "هذا الحقل مطلوب",)
                                : Container(),

                            errorReferenceNumber == true
                                ? ReusableRequiredText(
                                text: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? referenceNumberValidation_en
                                    :referenceNumberValidation_ar)
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
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*..........................................................................................................*/
                /*..............................................Passport Information..............................................*/
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Container(
                      width: 280,
                      child: Text(
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Passport Photo'
                            : "صورة جواز السفر",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: _loadPassport == true
                        ? Container(
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Color(0xff0070c9),
                          onPressed: () => {clearImageIDFront()}),
                    )
                        : null,
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
                            buildImageIdFront(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /*..........................................................................................................*/
                /*.........................................................................................................*/
                /*..........................................Signature attachment...........................................*/
              /*  Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Container(
                      width: 280,
                      child: Text(
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Signature Photo'
                            : "صورة التوقيع",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: _loadPassport == true
                        ? Container(
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Color(0xff0070c9),
                          onPressed: () => {clearImageSignature()}),
                    )
                        : null,
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
                            buildImageSignature(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),*/
                /*..........................................................................................................*/
                /*..........................................receiptImage Information........................................*/
                PaymentMethodSystemName=="Payments.CardOnDelivery"?
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Container(
                      width: 280,
                      child: Text(
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Receipt Image'
                            : "صورة الإيصال",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: _loadPassport == true
                        ? Container(
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Color(0xff0070c9),
                          onPressed: () => {clearImageReceipt()}),
                    )
                        : null,
                  ),
                ):Container(),
                PaymentMethodSystemName=="Payments.CardOnDelivery"? Container(
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
                            buildImageIdReceipt(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):Container(),
                /*.........................................................................................................*/
                /*...............Auth code & Last 4 digits will appear if PaymentMethodSystemName=card on delivery.........*/
                /*...........................................Other Information.............................................*/
                PaymentMethodSystemName=="Payments.CardOnDelivery" ? Container(
                  color: Color(0xFFEBECF1),
                  padding:
                  EdgeInsets.only(left: 16, right: 10, top: 15, bottom: 15),
                  child:  Text(
                    EasyLocalization
                        .of(context)
                        .locale == Locale("en", "US")
                        ? 'Other Information'
                        : "معلومات أخرى",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.bold),
                  ),

                ):Container(),
                PaymentMethodSystemName=="Payments.CardOnDelivery" ?Container(
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
                            buildAuthcode(),
                            SizedBox(
                              height: 10,
                            ),
                            buildLast4digits(),
                            /*.............................Document Expiry Date 12/6/2024.......................*/
                               SizedBox(
                              height: 10,
                            ),

                            buildDocumentExpiryDate(),
                            /*..................................................................................*/
                            SizedBox(
                              height: 10,
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ):Container(),
                /*....................................................End Condition.........................................*/
                /*..........................................................................................................*/
                /*...........................................SIMcard Information............................................*/
                Container(
                  color: Color(0xFFEBECF1),
                  padding:
                  EdgeInsets.only( top: 5, bottom: 0),
                  child: ListTile(
                    leading: Container(
                      // width: 270,
                      child: Text(
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'e-Sim Option'
                            : "خيار الشريحة الإلكترونية",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: Container(
                      child:  Switch(
                        value: e_Sim,
                        onChanged:null /*(value) {
                          changeEsim(value);
                        }*/,
                        activeTrackColor: Color(0xFF767699),
                        activeColor: Color(0xFF392156),
                        inactiveTrackColor: Colors.grey,
                      ),
                    ),
                  ),

                ),
                e_Sim==false?
                Column(
                  children: [
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
                                    EasyLocalization.of(context).locale == Locale("en", "US")
                                        ? 'Scan Barcode'
                                        : "مسح الرمز الشريطى",
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
                              color: Color(0xFF392156),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF392156),
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                              ),
                              onPressed: () => _ScanKitCode(),
                              child: Text(
                                EasyLocalization.of(context).locale == Locale("en", "US")
                                    ? 'Start Scan'
                                    : "ابدأ المسح",
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
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'OR'
                              : "أو",
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
                                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                                      ? 'This feild is required'
                                      : "هذا الحقل مطلوب",)
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
                ):Container(),
                /*.........................................................................................................*/
                /*.............................................Submit Button..............................................*/

                SizedBox(height: 20,),
                Container(
                    height: 48,
                    width: 300,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:activeSubmitButton == false? Color(0xFF636f7b):Color(0xFF392156),
                    ),
                    child: TextButton(
                      onPressed: activeSubmitButton == false
                          ? null
                          :
                          () async {

                        /*...........................................Check Name.......................................*/
                        if (FirstName.text != "") {
                          setState(() {
                            emptyFirstName=false;
                          });
                        }
                        if (FirstName.text == "") {
                          setState(() {
                            emptyFirstName=true;
                          });
                        }

                        if (SecondName.text != "") {
                          setState(() {
                            emptySecondName=false;
                          });
                        }
                        if (SecondName.text == "") {
                          setState(() {
                            emptySecondName=true;
                          });
                        }
                        /*  if (ThirdName.text != "") {
                              setState(() {
                                emptyThirdName=false;
                              });
                            }
                            if (ThirdName.text  == "") {
                              setState(() {
                                emptyThirdName=true;
                              });
                            }*/

                        if (LastName.text != "") {
                          setState(() {
                            emptyLastName=false;
                          });
                        }
                        if (LastName.text  == "") {
                          setState(() {
                            emptyLastName=true;
                          });
                        }

                        /*................................... Check All field Signature attachment ................................*/

                       /* if (img64Signature == null) {
                          setState(() {
                            imageSignatureRequired = true;
                          });
                        }
                        if (img64Signature != null) {
                          setState(() {
                            imageSignatureRequired = false;
                          });
                        }*/
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

                        /*..................... Check All field AuthCode && Last4digits && Receipt attachment ....................*/
                        if(PaymentMethodSystemName=="Payments.CardOnDelivery" ){
                          if (img64Receipt == null) {
                            setState(() {
                              imageReceiptRequired = true;
                            });
                            showToast( EasyLocalization
                                .of(context)
                                .locale == Locale("en", "US")
                                ? 'Please fill all required field'
                                : "يرجى ملء كافة الحقول المطلوبة",
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }
                          if (img64Receipt != null) {
                            setState(() {
                              imageReceiptRequired = false;
                            });
                          }

                          if(authCode.text ==''){
                            setState(() {
                              emptyAuthcode =true;
                            });
                            showToast( EasyLocalization
                                .of(context)
                                .locale == Locale("en", "US")
                                ? 'Please fill all required field'
                                : "يرجى ملء كافة الحقول المطلوبة",
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }
                          if(authCode.text !=''){
                            setState(() {
                              emptyAuthcode =false;
                            });
                          }
                          if(authCode.text.length<6){
                            setState(() {
                              emptyAuthcode=true;
                            });
                          }
                          if(authCode.text.length==6){
                            setState(() {
                              emptyAuthcode=false;
                            });
                          }

                          if(lastDigits.text==''){
                            setState(() {
                              emptyLastDigits=true;
                            });
                            showToast( EasyLocalization
                                .of(context)
                                .locale == Locale("en", "US")
                                ? 'Please fill all required field'
                                : "يرجى ملء كافة الحقول المطلوبة",
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }
                          if(lastDigits.text!=''){
                            setState(() {
                              emptyLastDigits=false;
                            });
                          }
                          if(lastDigits.text.length<4){
                            setState(() {
                              emptyLastDigits=true;
                            });
                          }
                          if(lastDigits.text.length==4){
                            setState(() {
                              emptyLastDigits=false;
                            });
                          }
                        }

                        /*..........................................Check Referance Number.....................................*/
                        if (refrence_Number.text == '') {
                          setState(() {
                            emptyReferenceNumber = true;
                          });
                          showToast( EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'Please fill all required field'
                              : "يرجى ملء كافة الحقول المطلوبة",
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);
                        }
                        if (refrence_Number.text != '') {
                          setState(() {
                            emptyReferenceNumber = false;
                          });
                          if (refrence_Number.text.length != 10) {
                            setState(() {
                              errorReferenceNumber = true;
                            });
                          } else {
                            setState(() {
                              errorReferenceNumber = false;
                            });
                          }
                        }
                        /*............................................Check Sim Card........................................*/
                        if(e_Sim==false){
                          if (simCard.text == '') {
                            setState(() {
                              emptySimCard = true;
                            });
                            showToast( EasyLocalization
                                .of(context)
                                .locale == Locale("en", "US")
                                ? 'Please fill all required field'
                                : "يرجى ملء كافة الحقول المطلوبة",
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }
                          if (simCard.text != '') {
                            setState(() {
                              emptySimCard = false;
                            });
                          }
                        }

                        /*...........................................Check passport ID.......................................*/
                        if (img64Front == null) {
                          setState(() {
                            imageIDFrontRequired = true;
                          });
                          showToast( EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'Please fill all required field'
                              : "يرجى ملء كافة الحقول المطلوبة",
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);
                        }
                        if (img64Front != null) {
                          setState(() {
                            imageIDFrontRequired = false;
                          });
                        }

                        /*...........................................Check Birth Day.......................................*/
                       /* if (day.text == '') {
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
                        }*/

                        /*....................................Check All field to Generate Contract................................*/
                        if(PaymentMethodSystemName=="Payments.CardOnDelivery"){
                          if (img64Front != null &&
                              refrence_Number.text != '' &&
                              simCard.text != '' &&
                              img64Receipt !=null &&
                            //  img64Signature != null &&
                              documentExpiryDate.text !=""&&
                              authCode.text!= "" &&
                              authCode.text.length == 6 &&
                              lastDigits.text!=''&&
                              lastDigits.text.length==4 &&
                              FirstName.text != '' &&
                              LastName.text != ''
                             // day.text != '' &&
                             // month.text != '' &&
                             // year.text != ''

                          ) {

                            showAlertDialogSaveData(
                                context,
                                ' المبلغ الكلي المطلوب هو  ${orderTotal}  دينار، هل انت متأكد؟  ',
                                'The total amount required is ${orderTotal}JD are you sure you want to continue?');
                          }
                        }

                        if(PaymentMethodSystemName!="Payments.CardOnDelivery"){
                          if (img64Front != null &&
                             // img64Signature != null&&
                             // documentExpiryDate.text !=""&&
                              refrence_Number.text != '' &&
                              simCard.text != ''  &&
                              FirstName.text != '' &&
                              LastName.text != ''
                             // day.text != '' &&
                            //  month.text != '' &&
                            //  year.text != ''

                          ) {
                            showAlertDialogSaveData(
                                context,
                                ' المبلغ الكلي المطلوب هو  ${orderTotal}  دينار، هل انت متأكد؟  ',
                                'The total amount required is ${orderTotal} JD are you sure you want to continue?');
                          }
                        }

                      },
                      style: TextButton.styleFrom(
                        backgroundColor:activeSubmitButton == false? Color(0xFF636f7b):Color(0xFF392156),
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24))),
                      ),
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Next'
                            : "التالي",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )),

                SizedBox(height: 20,)

              ]),

              Visibility(
                visible: checkSubmitResponce, // Adjust the condition based on when you want to show the overlay
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
          )),
    );/*GestureDetector(
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

              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Customer Information'
                  : "معلومات العميل",
            ),
            backgroundColor: Color(0xFF392156),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: Stack(
            children: [
              ListView(padding: EdgeInsets.only(top: 8), children: <Widget>[
                /*...........................................Package Information............................................*/
                Container(
                  color: Color(0xFFEBECF1),
                  padding:
                  EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 15),
                  child: Text(
                    EasyLocalization
                        .of(context)
                        .locale == Locale("en", "US")
                        ? 'Package Information'
                        : "معلومات الحزمة",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.bold),
                  ),),
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
                            SizedBox(
                              height: 10,
                            ),
                            buildMarketType(),
                            SizedBox(
                              height: 10,
                            ),
                            buildPackageName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildPackageCode(),
                            SizedBox(
                              height: 10,
                            ),
                            buildSelectedNumber(),
                            SizedBox(
                              height: 10,
                            ),
                            buildpaymentMethodSystemName(),
                        /*   SizedBox(
                              height: 10,
                            ),
                              buildCommitment(),

                            SizedBox(
                              height: 10,
                            ),*/



                            SizedBox(
                              height: 15,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*..........................................................................................................*/
                /*..........................................Customer Information............................................*/
                Container(
                  color: Color(0xFFEBECF1),
                  padding:
                  EdgeInsets.only(left: 16, right: 10, top: 15, bottom: 15),
                  child:  Text(
                    EasyLocalization
                        .of(context)
                        .locale == Locale("en", "US")
                        ? 'Customer Information'
                        : "معلومات شخصية",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.bold),
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
                            buildFirstName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildSecondName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildThirdName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildLastName(),
                            SizedBox(
                              height: 10,
                            ),
                            buildBirthDate(),

                            buildPassportNumber(),
                            SizedBox(
                              height: 10,
                            ),
                            f(),
                            emptyReferenceNumber == true
                                ? ReusableRequiredText(
                              text:  EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? 'This feild is required'
                                  : "هذا الحقل مطلوب",)
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
                              height: 15,
                            ),
                            /*.............................Document Expiry Date 12/6/2024.......................*/

                            buildDocumentExpiryDate(),
                            SizedBox(
                              height: 15,
                            ),
                            /*..................................................................................*/
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                /*..........................................................................................................*/
                /*..............................................Passport Information..............................................*/
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Container(
                      width: 280,
                      child: Text(
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Passport Photo'
                            : "صورة جواز السفر",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: _loadPassport == true
                        ? Container(
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Color(0xff0070c9),
                          onPressed: () => {clearImageIDFront()}),
                    )
                        : null,
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
                            buildImageIdFront(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                /*..........................................................................................................*/
                /*.........................................................................................................*/
                /*..........................................Signature attachment...........................................*/
              /*2024  Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Container(
                      width: 280,
                      child: Text(
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Signature Photo'
                            : "صورة التوقيع",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: _loadPassport == true
                        ? Container(
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Color(0xff0070c9),
                          onPressed: () => {clearImageSignature()}),
                    )
                        : null,
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
                            buildImageSignature(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),*/
                /*..........................................................................................................*/
                /*..........................................receiptImage Information........................................*/
                PaymentMethodSystemName=="Card On Delivery"?
                Container(
                  height: 60,
                  padding: EdgeInsets.only(top: 8),
                  child: ListTile(
                    leading: Container(
                      width: 280,
                      child: Text(
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'Receipt Image'
                            : "صورة الإيصال",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: _loadPassport == true
                        ? Container(
                      child: IconButton(
                          icon: Icon(Icons.delete),
                          color: Color(0xff0070c9),
                          onPressed: () => {clearImageReceipt()}),
                    )
                        : null,
                  ),
                ):Container(),
                PaymentMethodSystemName=="Card On Delivery"? Container(
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
                            buildImageIdReceipt(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ):Container(),
                /*.........................................................................................................*/
                /*...............Auth code & Last 4 digits will appear if PaymentMethodSystemName=card on delivery.........*/
                /*...........................................Other Information.............................................*/
                PaymentMethodSystemName=="Card On Delivery"? Container(
                  color: Color(0xFFEBECF1),
                  padding:
                  EdgeInsets.only(left: 16, right: 10, top: 15, bottom: 15),
                  child:  Text(
                    EasyLocalization
                        .of(context)
                        .locale == Locale("en", "US")
                        ? 'Other Information'
                        : "معلومات أخرى",
                    style: TextStyle(
                        fontSize: 16,
                        color: Color(0xff11120e),
                        fontWeight: FontWeight.bold),
                  ),

                ):Container(),

                PaymentMethodSystemName=="Card On Delivery"?Container(
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
                            buildAuthcode(),
                            SizedBox(
                              height: 10,
                            ),
                            buildLast4digits(),
                            SizedBox(
                              height: 10,
                            ),

                            SizedBox(
                              height: 10,
                            ),


                          ],
                        ),
                      ),
                    ],
                  ),
                ):Container(),
                /*....................................................End Condition.........................................*/
                /*..........................................................................................................*/
                /*...........................................SIMcard Information............................................*/
                Container(
                  color: Color(0xFFEBECF1),
                  padding:
                  EdgeInsets.only( top: 5, bottom: 0),
                  child: ListTile(
                    leading: Container(
                      // width: 270,
                      child: Text(
                        EasyLocalization
                            .of(context)
                            .locale == Locale("en", "US")
                            ? 'e-Sim Option'
                            : "خيار الشريحة الإلكترونية",
                        style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    trailing: Container(
                      child:  Switch(
                        value: e_Sim,
                        onChanged: null/*(value) {
                          changeEsim(value);
                        }*/,
                        activeTrackColor: Color(0xFF767699),
                        activeColor: Color(0xFF392156),
                        inactiveTrackColor: Colors.grey,
                      ),
                    ),
                  ),

                ),
                e_Sim==false?
                Column(
                  children: [
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
                                    EasyLocalization.of(context).locale == Locale("en", "US")
                                        ? 'Scan Barcode'
                                        : "مسح الرمز الشريطى",
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
                              color: Color(0xFF392156),
                            ),
                            child: TextButton(
                              style: TextButton.styleFrom(
                                backgroundColor: Color(0xFF392156),
                                shape: const BeveledRectangleBorder(
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(24))),
                              ),
                              onPressed: () => _ScanKitCode(),
                              child: Text(
                                EasyLocalization.of(context).locale == Locale("en", "US")
                                    ? 'Start Scan'
                                    : "ابدأ المسح",
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
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? 'OR'
                              : "أو",
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
                                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                                      ? 'This feild is required'
                                      : "هذا الحقل مطلوب",)
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
                ):Container(),
                /*.........................................................................................................*/
                /*.............................................Submit Button..............................................*/

                SizedBox(height: 20,),
                Container(
                    height: 48,
                    width: 300,
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color:activeSubmitButton == false? Color(0xFF636f7b):Color(0xFF392156),
                    ),
                    child: TextButton(
                      onPressed: activeSubmitButton == false
                          ? ()async{
                        print("Please wait");
                      }
                          :
                          () async {

                            /*...........................................Check Name.......................................*/
                            if (FirstName.text != "") {
                              setState(() {
                                emptyFirstName=false;
                              });
                            }
                            if (FirstName.text == "") {
                              setState(() {
                                emptyFirstName=true;
                              });
                            }

                           /* if (SecondName.text != "") {
                              setState(() {
                                emptySecondName=false;
                              });
                            }
                            if (SecondName.text == "") {
                              setState(() {
                                emptySecondName=true;
                              });
                            }*/
                          /*  if (ThirdName.text != "") {
                              setState(() {
                                emptyThirdName=false;
                              });
                            }
                            if (ThirdName.text  == "") {
                              setState(() {
                                emptyThirdName=true;
                              });
                            }*/

                            if (LastName.text != "") {
                              setState(() {
                                emptyLastName=false;
                              });
                            }
                            if (LastName.text  == "") {
                              setState(() {
                                emptyLastName=true;
                              });
                            }

                            /*................................... Check All field Signature attachment ................................*/

                       /*2024 if (img64Signature == null) {
                          setState(() {
                            imageSignatureRequired = true;
                          });
                        }
                        if (img64Signature != null) {
                          setState(() {
                            imageSignatureRequired = false;
                          });
                        }*/
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
                        /*..................... Check All field AuthCode && La
                        st4digits && Receipt attachment ....................*/
                        if(PaymentMethodSystemName=="Card On Delivery"){
                          if (img64Receipt == null) {
                            setState(() {
                              imageReceiptRequired = true;
                            });
                            showToast( EasyLocalization
                                .of(context)
                                .locale == Locale("en", "US")
                                ? 'Please fill all required field'
                                : "يرجى ملء كافة الحقول المطلوبة",
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }
                          if (img64Receipt != null) {
                            setState(() {
                              imageReceiptRequired = false;
                            });
                          }

                          if(authCode.text ==''){
                            setState(() {
                              emptyAuthcode =true;
                            });
                            showToast( EasyLocalization
                                .of(context)
                                .locale == Locale("en", "US")
                                ? 'Please fill all required field'
                                : "يرجى ملء كافة الحقول المطلوبة",
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }
                          if(authCode.text !=''){
                            setState(() {
                              emptyAuthcode =false;
                            });
                          }
                          if(authCode.text.length<6){
                            setState(() {
                              emptyAuthcode=true;
                            });
                          }
                          if(authCode.text.length==6){
                            setState(() {
                              emptyAuthcode=false;
                            });
                          }

                          if(lastDigits.text==''){
                            setState(() {
                              emptyLastDigits=true;
                            });
                            showToast( EasyLocalization
                                .of(context)
                                .locale == Locale("en", "US")
                                ? 'Please fill all required field'
                                : "يرجى ملء كافة الحقول المطلوبة",
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }

                          if(lastDigits.text!=''){
                            setState(() {
                              emptyLastDigits=false;
                            });
                          }

                          if(lastDigits.text.length<4){
                            setState(() {
                              emptyLastDigits=true;
                            });
                          }

                          if(lastDigits.text.length==4){
                            setState(() {
                              emptyLastDigits=false;
                            });
                          }
                        }

                        /*..........................................Check Referance Number.....................................*/
                        if (refrence_Number.text == '') {
                          setState(() {
                            emptyReferenceNumber = true;
                          });
                          showToast( EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'Please fill all required field'
                              : "يرجى ملء كافة الحقول المطلوبة",
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);
                        }

                        if (refrence_Number.text != '') {
                          setState(() {
                            emptyReferenceNumber = false;
                          });
                          if (refrence_Number.text.length != 10) {
                            setState(() {
                              errorReferenceNumber = true;
                            });
                          } else {
                            setState(() {
                              errorReferenceNumber = false;
                            });
                          }
                        }
                        /*............................................Check Sim Card........................................*/
                        if(e_Sim==false){
                          if (simCard.text == '') {
                            setState(() {
                              emptySimCard = true;
                            });
                            showToast( EasyLocalization
                                .of(context)
                                .locale == Locale("en", "US")
                                ? 'Please fill all required field'
                                : "يرجى ملء كافة الحقول المطلوبة",
                                context: context,
                                animation: StyledToastAnimation.scale,
                                fullWidth: true);
                          }
                          if (simCard.text != '') {
                            setState(() {
                              emptySimCard = false;
                            });
                          }
                        }

                        /*...........................................Check passport ID.......................................*/
                        if (img64Front == null) {
                          setState(() {
                            imageIDFrontRequired = true;
                          });
                          showToast( EasyLocalization
                              .of(context)
                              .locale == Locale("en", "US")
                              ? 'Please fill all required field'
                              : "يرجى ملء كافة الحقول المطلوبة",
                              context: context,
                              animation: StyledToastAnimation.scale,
                              fullWidth: true);
                        }

                        if (img64Front != null) {
                          setState(() {
                            imageIDFrontRequired = false;
                          });
                        }

                        /*...........................................Check Birth Day.......................................*/
                       /* if (day.text == '') {
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

                        */
                        /*....................................Check All field to Generate Contract................................*/
                        if(PaymentMethodSystemName=="Card On Delivery"){
                          print("........................haya4");
                          if (img64Front != null &&
                              refrence_Number.text != '' &&
                            //  simCard.text != '' &&
                              img64Receipt !=null &&
                            //  img64Signature != null &&
                              authCode.text!= "" &&
                              authCode.text.length == 6 &&
                              lastDigits.text!=''&&
                              lastDigits.text.length==4 &&
                              FirstName.text != '' &&
                              LastName.text != '' &&
                            //  day.text != '' &&
                            //  month.text != '' &&
                            //  year.text != '' &&
                              documentExpiryDate.text !=""
                          ) {

                            showAlertDialogSaveData(
                                context,
                                ' المبلغ الكلي المطلوب هو  ${orderTotal}  دينار، هل انت متأكد؟  ',
                                'The total amount required is ${orderTotal}JD are you sure you want to continue?');
                          }
                        }

                        if(PaymentMethodSystemName!="Card On Delivery"){
                          print("........................haya44");

print(refrence_Number.text);
print(FirstName.text);
print(LastName.text);
print(documentExpiryDate.text);
                          if (img64Front != null &&
                            //  img64Signature != null&&
                              refrence_Number.text != '' &&
                             // simCard.text != ''  &&
                              FirstName.text != '' &&
                              LastName.text != '' &&
                            //  day.text != '' &&
                            //  month.text != '' &&
                           //   year.text != '' &&
                              documentExpiryDate.text !="") {
                            showAlertDialogSaveData(
                                context,
                                ' المبلغ الكلي المطلوب هو  ${orderTotal}  دينار، هل انت متأكد؟  ',
                                'The total amount required is ${orderTotal} JD are you sure you want to continue?');
                          }
                        }

                      },
                      style: TextButton.styleFrom(
                        backgroundColor:activeSubmitButton == false? Color(0xFF636f7b):Color(0xFF392156),
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24))),
                      ),
                      child: Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Next'
                            : "التالي",
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    )),

                SizedBox(height: 20,)

              ]),

              Visibility(
                visible: checkSubmitResponce, // Adjust the condition based on when you want to show the overlay
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
          )),
    );*/
  }
}

//////
/**/

