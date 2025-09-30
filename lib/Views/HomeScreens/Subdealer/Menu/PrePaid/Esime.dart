import 'dart:async';
import 'dart:convert';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_view/photo_view.dart';
import 'package:provider/provider.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:dropdown_search/dropdown_search.dart';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as Io;
import 'dart:io';
import '../../../../../../../../Shared/BaseUrl.dart';
import '../../../../../blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_bloc.dart';
import '../../../../../blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import '../../../../../blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';




class Esime  extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;

  Esime({this.Permessions, this.role, this.outDoorUserName});


  @override
  State<Esime> createState() => _EsimeState(this.Permessions, this.role, this.outDoorUserName);
}



class _EsimeState extends State<Esime> {
  _EsimeState(this.Permessions, this.role, this.outDoorUserName);
  APP_URLS urls = new APP_URLS();
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  TextEditingController msisdn = TextEditingController();
  TextEditingController nationalNo=TextEditingController();
  TextEditingController passportNo=TextEditingController();

  bool emptyMAISDN = false;
  bool errorMAISDN = false;

  bool emptyNationalNo = false;
  bool errorNationalNo = false;

  bool emptyPassportNo = false;
  bool errorPassportNo = false;

  var price_valid_package;
  // price_valid_package=result["data"]["price"].toString();
////Q@Team*2023
  var options_MSISDN = [];
  bool emptyselectedMSISDN = false;
  List <String> MSISDN_Value=[];
  var selectedMSISDN_Value=null;
  var msisdn_select;


  bool checkPackagesValidity = false;
  bool checkMSISDNList = false;

  bool hideCheekButton=false;
  TextEditingController referenceNumber = TextEditingController();
  bool emptyReferenceNumber=false;
  bool errorReferenceNumber = false;
  int clearSucssesFlag=0;
  bool successFlag = false;
  /*...............................................Package  Variables................................................*/
  var Package_options = ["Generic Prepaid BB","Generic0JDc"];
  bool emptyPackage = false;
  var selectedPackage="Generic Prepaid BB";
  var packageCode="LTEA1";

  /*...............................................Nationality Variables................................................*/
  var nationality_options = ["Jordanian","non-Jordanian"];
  bool emptyNationality = false;
  var selectedNationality="Jordanian";
  bool isJordanian=true;

  /*..........................................variable for non-Jordanian................................................*/
  TextEditingController FirstName = TextEditingController();
  TextEditingController SecondName = TextEditingController();
  TextEditingController ThirdName = TextEditingController();
  TextEditingController LastName = TextEditingController();

  bool emptyFirstName = false;
  bool emptySecondName = false;
  bool emptyThirdName = false;
  bool emptyLastName = false;


  /*..........................................variable date of birth................................................*/
  bool emptyDay = false;
  bool emptyMonth = false;
  bool emptyYear = false;

  bool errorDayMonthe = false;
  bool errorDay = false;
  bool errorMonthe = false;
  bool birthDateValid = true;
  bool errorYear = false;

  var givenDate = '';
  int d, m, y;
  int days1, month1, year1;
  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();

  /*..........................................variable for Email Address................................................*/
  TextEditingController email = TextEditingController();
  bool emptyEmail = false;

  /*.....................................variable for function initialPayment...........................................*/
  TextEditingController merchantID = TextEditingController();
  TextEditingController terminalID = TextEditingController();
  TextEditingController otp = TextEditingController();

  bool emptyMerchantID = false;
  bool emptyTerminalID = false;
  bool emptyOTP = false;
  bool showSecondStep=false;
  bool showNextButton=false;
  bool showThirdStep=false;


  var operationReference;
  bool checkinitiatePaymentValidity = false;
  bool checkSubmitValidity = false;


  /*............................................variable for Passport Image...............................................*/
  int imageWidth = 200;
  int imageHeight = 200;
  String img64FrontPassport;
  var pickedFileFrontPassport;
  File imageFileFrontPassport;
  File imageFileFrontPathPassport = File('');
  bool imageFrontRequiredPassport = false;
  bool _loadPassport = false;

  /*............................................variable for ID Front Image...............................................*/
  String img64FrontID;
  var pickedFileFrontID;
  File imageFileFrontID;
  File imageFileFrontPathID= File('');
  bool imageFrontRequiredID = false;
  bool _loadFrontID = false;


  /*............................................variable for ID Back Image...............................................*/
  String img64BackID;
  var pickedFileBackID;
  File imageFileBackID;
  File imageFileBackPathID= File('');
  bool imageRequiredBackID = false;
  bool _loadBackID = false;

  final _picker = ImagePicker();

  /*...........................................Document Expiry Date.........................................*/
  bool emptyDocumentExpiryDate=false;
  TextEditingController documentExpiryDate = TextEditingController();
  DateTime Expiry_Date = DateTime.now();
  VerifyOTPSCheckMSISDNBloc verifyOTPSCheckMSISDNBloc;
  bool showCircular = false;
  /*....................................................................................................................*/
  /*....................................................Report Type Functions............................................*/
  Widget buildPackage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ?"Package Name":"اسم الحزمة",
            style: TextStyle(
              color: Color(0xFF11120E),
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
        SizedBox(height: 15),
        Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0), // Adjust vertical padding here
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyPackage == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child:DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  disabledHint:Text(
                    "Test.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  hint: Text(
                    "Test.select_an_option".tr().toString(),
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
                  value: selectedPackage,
                  onChanged: (  String newValue) {
                    Lookup_MSISDN();
                    setState(() {

                      showSecondStep=false;
                      showNextButton=false;
                      hideCheekButton=false;
                      msisdn_select ='';
                      msisdn.text='';
                      nationalNo.text='';
                      passportNo.text='';
                      selectedPackage = newValue;
                      merchantID.text='';
                      terminalID.text='';

                    });

                    if(newValue=='Generic Prepaid BB'){
                      setState(() {
                        packageCode="LTEA1";
                        checkMSISDNList=false;
                      });

                    }
                    if(newValue=='Generic0JDc'){
                      setState(() {
                        Lookup_MSISDN();
                        packageCode="GECHP";
                        checkMSISDNList=true;
                        emptyReferenceNumber=false;
                        errorReferenceNumber = false;
                        clearSucssesFlag=0;
                        successFlag = false;
                        referenceNumber.text='';
                      });
                    }
                    print(selectedPackage);
                    print(packageCode);
                  },
                  items: Package_options.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            )),

      ],
    );
  }

  Widget buildNationality() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ?"Nationality":"الجنسية",
            style: TextStyle(
              color: Color(0xFF11120E),
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
        SizedBox(height: 15),
        Container(
            padding: EdgeInsets.symmetric(vertical: 0, horizontal: 0), // Adjust vertical padding here
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyNationality == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child:DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  disabledHint:Text(
                    "Test.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Color(0xFFA4B0C1),
                      fontSize: 14,
                    ),
                  ),
                  hint: Text(
                    "Test.select_an_option".tr().toString(),
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
                  value: selectedNationality,
                  onChanged: (  String newValue) {

                    setState(() {
                      showSecondStep=false;
                      showNextButton=false;
                      hideCheekButton=false;
                      msisdn_select ='';
                      msisdn.text='';
                      nationalNo.text='';
                      passportNo.text='';
                      selectedNationality = newValue;
                      merchantID.text='';
                      terminalID.text='';

                    });
                    if(newValue=="Jordanian"){
                      setState(() {
                        isJordanian=true;
                      });
                    }
                    if(newValue=="non-Jordanian"){
                      setState(() {
                        isJordanian=false;
                      });
                    }
                    print(selectedNationality);
                  },
                  items: nationality_options.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:valueItem,
                      child: Text(valueItem),
                    );
                  }).toList(),
                ),
              ),
            )),

      ],
    );
  }

  Widget _nationalNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:  EasyLocalization.of(context).locale ==
                Locale("en", "US")?"National Number":"الرقم الوطني",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color:Colors.white,
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
            controller: nationalNo,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.text,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyNationalNo== true || errorNationalNo==true
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
              contentPadding: EdgeInsets.all(8),
              hintText: "xxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: ()=>{

              setState(() {
                showSecondStep=false;
                showNextButton=false;
                hideCheekButton=false;
                merchantID.text='';
                terminalID.text='';
                msisdn.text='';

              })
            },
            onChanged: (text){

            },
          ),
        )
      ],
    );
  }

  Widget _passportNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:  EasyLocalization.of(context).locale ==
                Locale("en", "US")?"Passport Number":"رقم الجواز",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color:Colors.white,
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
            controller: passportNo,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.text,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyPassportNo== true || errorPassportNo==true
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
              contentPadding: EdgeInsets.all(8),
              hintText: "xxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: ()=>{
              Lookup_MSISDN(),

              setState(() {
                showSecondStep=false;
                showNextButton=false;
                hideCheekButton=false;
                merchantID.text='';
                terminalID.text='';
                msisdn.text='';



              })
            },
            onChanged: (text){

            },
          ),
        )
      ],
    );
  }

  Widget MSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")?"MSISDN":"الرقم",
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
            enabled: false,
            controller: msisdn,
            maxLength: 10,
            buildCounter: (BuildContext context, {int currentLength, int maxLength, bool isFocused}) => null,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              // Set to true to apply fillColor
              filled: true,
              // Define the background color here
              fillColor: Color(0xFFEBECF1),
              enabledBorder: emptyMAISDN == true || errorMAISDN == true
                  ? const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFB10000), width: 1.0),
              )
                  : const OutlineInputBorder(
                borderSide: BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: const BorderSide(color: Color(0xFF4F2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: "xxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: () {
              setState(() {
                emptyMAISDN = false;
                errorMAISDN = false;
              });
            },
            onChanged: (text) {
              if (text.length == 0) {
                // Your logic here
              }
              if (text.length > 1) {
                // Your logic here
              }
            },
          ),
        )

      ],
    );
  }

  Widget buildSelect_MSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
              text:  EasyLocalization.of(context).locale ==
                  Locale("en", "US")?"Select MSISDN":"اختر رقم",
              style: TextStyle(
                color: Color(0xFF11120E),
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
            padding: EdgeInsets.only(left: 10,right: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: emptyselectedMSISDN == true
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
              items: MSISDN_Value,
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
                setState(() {
                  showSecondStep=false;
                  showNextButton=false;
                  hideCheekButton=false;
                  msisdn_select=val;
                  merchantID.text='';
                  terminalID.text='';

                });
                print("msisdn_select");
                print(msisdn_select);
              },

              selectedItem: selectedMSISDN_Value,
            )),
        emptyselectedMSISDN == true
            ? ReusableRequiredText(
            text: "Postpaid.this_feild_is_required"
                .tr()
                .toString()) : Container(),
      ],
    );
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

  /*...........................................................................................*/
  /*...................................Validate Package API....................................*/
  void ValidatePackage_API() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/validate';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    var  boody={
      "msisdn": selectedPackage=="Generic Prepaid BB"?"":msisdn_select,
      "isJordanian": isJordanian,
      "nationalNo": nationalNo.text,
      "passportNo": passportNo.text,
      "packageCode": packageCode
    };

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body:jsonEncode({
        "msisdn": selectedPackage=="Generic Prepaid BB"?"":msisdn_select,
        "isJordanian": isJordanian,
        "nationalNo": nationalNo.text,
        "passportNo": passportNo.text,
        "packageCode": packageCode
      }),
    );
    print(boody);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      //showErroreAlertDialog(context,"401","401");
      setState(() {
        checkPackagesValidity=false;
      });

    }
    if (statusCode == 200) {
      setState(() {
        checkPackagesValidity=false;
      });
      var result = json.decode(response.body);
      print(result["data"]);
      if (result["data"] == null) {}
      if (result["status"] == 0) {
        // retrieve_updated_price_API();Fyour age less than

        setState(() {
          msisdn.text=result["data"]["msisdn"];
        });

        if(result['message']=="The Operation has been Successfully Completed"){
          // showSuccessAlertDialog(context,"The total amount required is ${result["data"]["price"].toString()} JD are you sure you want to continue (Merchant Number ${merchantID.text}) ? ","المبلغ الإجمالي المطلوب هو ${result["data"]["price"].toString()} د.أ \n(Merchant Number ${merchantID.text})\n هل أنت متأكد أنك تريد الاستمرار؟");
          setState(() {
            showSecondStep=true;
            showNextButton=true;
            hideCheekButton=true;
            price_valid_package=result["data"]["price"].toString();
            //2024  hideCheekButton=true;
          });
        }
      } else {
        showErroreAlertDialog(context,result["messageAr"],result["message"]);
        setState(() {
          hideCheekButton=false;
        });
      }

      return result;
    } else {
      showErroreAlertDialog(context,statusCode.toString(),statusCode.toString());
      setState(() {
        checkPackagesValidity=false;
        hideCheekButton=false;
      });
    }
  }

  /*...........................................................................................*/
  /*......................................MSISDN list API....................................*/
  void Lookup_MSISDN() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/msisdn/list';
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
    print(data);
    print(statusCode);

    if (statusCode == 401) {
      print('401  error ');

    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);
      print(result);


      if (result["status"] == 0) {

        setState(() {
          checkMSISDNList=false;
          options_MSISDN = result["data"];
        });
        for (var i = 0; i < result['data'].length; i++) {

          MSISDN_Value.add(result['data'][i].toString());

        }
        print("/********************************************************************/");
        print(options_MSISDN);
        print("/********************************************************************/");

      } else {
        showErroreAlertDialog(context, result["messageAr"], result["message"]);
        setState(() {
          checkMSISDNList=false;
        });
      }



      return result;
    }
    else {
      setState(() {
        checkMSISDNList=false;

      });
      showErroreAlertDialog(context,statusCode, statusCode);

    }

  }

  /*...........................................................................................*/
  /*...................................Validate Package API....................................*/
  void initiatePayment_API() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/initiatePayment';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    var  boody={
      "msisdn": selectedPackage=="Generic Prepaid BB"?msisdn.text:msisdn_select,
      "isJordanian": isJordanian,
      "nationalNo": nationalNo.text,
      "passportNo": passportNo.text,
      "packageCode":  packageCode,
      "merchantID": merchantID.text,
      "terminalID": terminalID.text
    };

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body:jsonEncode({
        "msisdn": selectedPackage=="Generic Prepaid BB"?msisdn.text:msisdn_select,
        "isJordanian": isJordanian,
        "nationalNo": nationalNo.text,
        "passportNo": passportNo.text,
        "packageCode":  packageCode,
        "merchantID": merchantID.text,
        "terminalID": terminalID.text
      }),
    );
    print(boody);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      //showErroreAlertDialog(context,"401","401");
      setState(() {
        checkinitiatePaymentValidity=false;
        showThirdStep=false;
      });

    }
    if (statusCode == 200) {
      setState(() {
        checkinitiatePaymentValidity=false;
      });
      var result = json.decode(response.body);
      print(result["data"]);
      if (result["data"] == null) {}
      if (result["status"] == 0) {

        if(result['message']=="The Operation has been Successfully Completed"){


          setState(() {
            operationReference=result["data"]["operationReference"];
            hideCheekButton=true;
            showThirdStep=true;

          });
        }
      } else {
        showErroreAlertDialog(context,result["messageAr"],result["message"]);
        setState(() {
          hideCheekButton=true;
          showThirdStep=false;

        });
      }

      return result;
    } else {
      showErroreAlertDialog(context,statusCode.toString(),statusCode.toString());
      setState(() {
        hideCheekButton=true;
        checkinitiatePaymentValidity=false;
        showThirdStep=false;

      });
    }
  }

  /*...........................................................................................*/
  /*.............................................Submit API....................................*/



  void submit_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Prepaid/submit';
    final Uri url = Uri.parse(apiArea);

    var body = {
      "msisdn": selectedPackage == "Generic Prepaid BB" ? msisdn.text : msisdn_select,
      "isJordanian": isJordanian,
      "nationalNo": nationalNo.text,
      "passportNo": passportNo.text,
      "packageCode": packageCode,
      "firstName": FirstName.text,
      "secondName": SecondName.text,
      "thirdName": ThirdName.text,
      "lastName": LastName.text,
      "birthDate": day.text + '-' + month.text + '-' + year.text,
      "eshopOrderId": "",
      "authCode": "",
      "last4Digits": "",
      "email": email.text,
      "isEsim": true,
      "simCard": "",
      "frontIdImageBase64": img64FrontID,
      "backIdImageBase64": img64BackID,
      "passportImageBase64": img64FrontPassport,
      "backPassportImageBase64": "",
      "signatureImageBase64": "",
      "receiptImageBase64": "",
      "documentExpiryDate": "",
      "operationReference": operationReference,
      "otp": otp.text,
      "referenceNumber":referenceNumber.text
    };
    print(body);

    /* try {
      final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body),
      )
          .timeout(Duration(seconds: 10));  // Timeout duration

      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print(result["data"]);
        if (result["status"] == 0 && result['message'] == "The Operation has been Successfully Completed") {
          showCompleteSubmitAlertDialog(context, result['message'], result['messageAr']);
          setState(() {
            checkSubmitValidity = false;
          });
        } else {
          showErroreAlertDialog(context, result["messageAr"], result["message"]);
          setState(() {
            checkSubmitValidity = false;
          });
        }

      } else {
        showErroreAlertDialog(context, response.statusCode.toString(), response.statusCode.toString());
        setState(() {
          checkSubmitValidity = false;
        });
      }
    } catch (e) {
      print("Error during API call: $e");
      showErroreAlertDialog(context, "Error", "Failed to submit the request. Please try again later.");

    }*/

    try {
      final response = await http.post(url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        },
        body: jsonEncode(body),
      );


      print("Response status code: ${response.statusCode}");
      print("Response body: ${response.body}");

      if (response.statusCode == 200) {
        var result = json.decode(response.body);
        print(result["data"]);
        if (result["status"] == 0 && result['message'] == "The Operation has been Successfully Completed") {
          showCompleteSubmitAlertDialog(context, result['message'], result['messageAr']);
          setState(() {
            checkSubmitValidity = false;
          });
        } else {
          showErroreAlertDialog(context, result["messageAr"], result["message"]);
          setState(() {
            checkSubmitValidity = false;
          });
        }

      } else {
        showErroreAlertDialog(context, response.statusCode.toString(), response.statusCode.toString());
        setState(() {
          checkSubmitValidity = false;
        });
      }
    } catch (e) {
      print("Error during API call: $e");
      showErroreAlertDialog(context, "Error", "Failed to submit the request. Please try again later.");

    }

  }
  /*...........................................................................................*/
  /*.............................................SendOtp API....................................*/
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
  /*...........................................................................................*/
  /*....................................function non-Jordanian.................................*/
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
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
                const BorderSide(color: Color(0xFF392156), width: 1.0),
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

  /*...........................................................................................*/
  /*..........................................function date of birth...........................*/

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
                                color: Color(0xFF392156), width: 1.0),
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
                                color: Color(0xFF392156), width: 1.0),
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
                                color: Color(0xFF392156), width: 1.0),
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

  /*...........................................................................................*/
  /*..........................................function initialPayment..........................*/
  Widget enterMerchantID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "merchantID",
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
          height: 70,
          child: TextField(
            // maxLength: 10,
            // enabled: checkLine==true?false:true,
            controller: merchantID,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyMerchantID == true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){
              setState(() {
                emptyMerchantID=false;

              });
            },
            onChanged: (MerchantID){
              setState(() {
                showNextButton=true;
                showThirdStep=false;

              });

              if (MerchantID.length != 0) {
                setState(() {
                  emptyMerchantID=false;

                });


              }
              else {
                setState(() {
                  emptyMerchantID=true;
                });
              }
            },
          ),
        ),


      ],
    );
  }

  Widget enterTerminalID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "terminalID",
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
          height: 70,
          child: TextField(
            // maxLength: 10,
            // enabled: checkLine==true?false:true,
            controller: terminalID,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyTerminalID == true
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
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){
              setState(() {
                showNextButton=true;
                showThirdStep=false;

              });
              setState(() {
                emptyTerminalID=false;
              });
            },
            onChanged: (MerchantID){

              if (MerchantID.length != 0) {
                setState(() {
                  emptyTerminalID=false;
                });
              }
              else {
                setState(() {
                  emptyTerminalID=true;
                });
              }
            },
          ),
        ),


      ],
    );
  }

  /*...........................................................................................*/
  /*..........................................function Email Adress............................*/
  Widget buildEmailAddress() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")?"Email":"ﺍﻟﺒﺮﺑﺪﺍﻻﻟﻜﺘﺮﻭﻧﻲ",
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
            controller: email,
            enabled: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: email == true
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
              hintText: "",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")?
            "Please make sure that the entered e-mail is correct. If you wish to change it, you must visit the shope."
                :
            "الرﺟﺎﺀ ﺍﻟﺘﺎﻛﺪ ﻣﻦ ﺻﺤﺔ ﺍﻟﺒﺮﺑﺪﺍﻻﻟﻜﺘﺮﻭﻧﻲ ﺍﻟﻤﺪﺧﻞ ﻋﻠﻤﺎ ﺍﻧﻪ ﻓﻲ ﺣﺎﻝ ﺍﻟﺮﻏﺒﺔ ﻓﻲ ﺗﻐﻴﺮﻩ ﻳﺠﺐ ﺯﻳﺎﺭﺓ ﺍﻟﻤﻌﺮﺽ",
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[

            ],
          ),
        ),
      ],
    );
  }


  /*...........................................................................................*/
  /*..........................................  function OTP ..................................*/
  Widget buildOTP() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")?"OTP":"رمز التحقق",
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
            controller: otp,
            enabled: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyOTP == true
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
              hintText: "",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        RichText(
          text: TextSpan(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")?
            "Please insert the OTP that you received."
                :
            "الرجاد ادخال رمز التحقق المرسل",
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 12,
              fontWeight: FontWeight.normal,
            ),
            children: <TextSpan>[

            ],
          ),
        ),
      ],
    );
  }

  /*...........................................................................................*/
  /*..........................................function Alert  Dialog...........................*/
  showErroreAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(

        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Cancel'
            : "الغاء",
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        setState(() {
          showSecondStep=false;
          showNextButton=false;
          hideCheekButton=false;
          checkSubmitValidity = false;
        });
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

  showSuccessAlertDialog(BuildContext context, englishMessage,arabicMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Cancel'
            : "الغاء",
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pop(
          context,
        );
        setState(() {
          hideCheekButton=false;
          showSecondStep=false;
          showNextButton=false;
        });
      },
    );
    Widget completeButton = TextButton(
      child: Text(

        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Accept'
            : "أوافق",
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        initiatePayment_API();
        setState(() {
          // showSecondStep=true;
          //  showNextButton=true;
          //   hideCheekButton=true;
        });
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
        completeButton
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

  showCompleteSubmitAlertDialog(BuildContext context, englishMessage,arabicMessage) {

    Widget completeButton = TextButton(
      child: Text(

        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
            ? 'Close'
            : "انهاء",
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {

        setState(() {
          showSecondStep=false;
          showNextButton=false;
          hideCheekButton=true;
          showThirdStep=false;
        });
        Navigator.pop(
          context,
        );
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PrePaidSales(Permessions: Permessions,
                    role: role,
                    outDoorUserName: outDoorUserName),
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

        completeButton
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



  /*.................................................................................................*/
  /*.........................................Passport Information....................................*/
  Widget buildDashedBorderPassport({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

  Widget buildImageFrontPassport() {

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
                child:_loadPassport == true
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
                                image: FileImage(imageFileFrontPassport),
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
                                                        imageFileFrontPassport),
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
                              _showPickerFrontPassport(context);
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
                  buildDashedBorderPassport(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showPickerFrontPassport(context);
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
          imageFrontRequiredPassport == true
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
    pickedFileFrontPassport = await _picker.pickImage(
      source: ImageSource.camera,
    );


    if (pickedFileFrontPassport != null) {
      imageFileFrontPassport = File(pickedFileFrontPassport.path);
      _loadPassport = true;
      var imageName = pickedFileFrontPassport.path.split('/').last;

      calculateImageSize(pickedFileFrontPassport.path);

      if (pickedFileFrontPassport != null) {
        _cropImageFrontPassport(File(pickedFileFrontPassport.path));
      }
    }
  }

  void pickImageGalleryFront() async {
    pickedFileFrontPassport = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileFrontPassport != null) {
      imageFileFrontPassport = File(pickedFileFrontPassport.path);
      _loadPassport= true;
      var imageName = pickedFileFrontPassport.path.split('/').last;
      calculateImageSize(pickedFileFrontPassport.path);
      if (pickedFileFrontPassport != null) {
        _cropImageFrontPassport(File(pickedFileFrontPassport.path));
      }
    }
  }

  _cropImageFrontPassport(Io.File picture) async {
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
            _loadPassport= false;
            pickedFileFrontPassport = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64FrontPassport = base64Encode(base64Image);
          print('img64Crop after crop:');
          printLongStringPassport(img64FrontPassport);
          imageFileFrontPathPassport = File(cropped.path);

        }
      });
    } else {
      this.setState(() {
        _loadPassport= false;
        pickedFileFrontPassport = null;
      });
    }
  }

  void clearImageFrontPassport() {
    this.setState(() {
      _loadPassport = false;
      pickedFileFrontPassport = null;
    });
  }

  void printLongStringPassport(String text) {
    final RegExp pattern =
    RegExp('.{1,10000}'); // 100000 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  void _showPickerFrontPassport(context) {
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




  /*.................................................................................................*/
  /*.........................................Front ID Information....................................*/
  Widget buildDashedBorderFrontID({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

  Widget buildImageFrontID() {

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
                child:_loadFrontID == true
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
                                image: FileImage(imageFileFrontID),
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
                                                        imageFileFrontID),
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
                              _showPickerFrontID(context);
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
                  buildDashedBorderFrontID(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showPickerFrontID(context);
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
          imageFrontRequiredID == true
              ? ReusableRequiredText(
            text:EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'This feild is required'
                : "هذا الحقل مطلوب",)
              : Container(),
        ]),
      ),
    );
  }

  void pickImageCameraFrontID() async {
    pickedFileFrontID = await _picker.pickImage(
      source: ImageSource.camera,
    );


    if (pickedFileFrontID != null) {
      imageFileFrontID = File(pickedFileFrontID.path);
      _loadFrontID = true;
      var imageName = pickedFileFrontID.path.split('/').last;

      calculateImageSizeFrontID(pickedFileFrontID.path);

      if (pickedFileFrontID != null) {
        _cropImageFrontID(File(pickedFileFrontID.path));
      }
    }
  }

  void pickImageGalleryFrontID() async {
    pickedFileFrontID = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileFrontID != null) {
      imageFileFrontID = File(pickedFileFrontID.path);
      _loadFrontID= true;
      var imageName = pickedFileFrontID.path.split('/').last;
      calculateImageSizeFrontID(pickedFileFrontID.path);
      if (pickedFileFrontID != null) {
        _cropImageFrontID(File(pickedFileFrontID.path));
      }
    }
  }

  _cropImageFrontID(Io.File picture) async {
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
            _loadFrontID= false;
            pickedFileFrontID = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64FrontID = base64Encode(base64Image);
          print('img64Crop after crop:');
          printLongStringID(img64FrontID);
          imageFileFrontPathID = File(cropped.path);

        }
      });
    } else {
      this.setState(() {
        _loadFrontID= false;
        pickedFileFrontID = null;
      });
    }
  }

  void clearImageFrontID() {
    this.setState(() {
      _loadFrontID = false;
      pickedFileFrontID = null;
    });
  }

  void printLongStringID(String text) {
    final RegExp pattern =
    RegExp('.{1,10000}'); // 100000 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  void _showPickerFrontID(context) {
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
                      pickImageCameraFrontID();
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
                      pickImageGalleryFrontID();
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

  void calculateImageSizeFrontID(String path) {
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


  /*.................................................................................................*/
  /*.......................................Front Back Information....................................*/
  Widget buildDashedBorderBackID({Widget child}) => DottedBorder(
      color: Color(0xffd5d8dc),
      borderType: BorderType.RRect,
      radius: Radius.circular(4),
      dashPattern: [8, 4],
      strokeWidth: 1,
      child: (child));

  Widget buildImageBackID() {

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
                child:_loadBackID == true
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
                                image: FileImage(imageFileBackID),
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
                                                        imageFileBackID),
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
                              _showPickerBackID(context);
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
                  buildDashedBorderBackID(
                    child: InkWell(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        _showPickerBackID(context);
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
          imageRequiredBackID == true
              ? ReusableRequiredText(
            text:EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'This feild is required'
                : "هذا الحقل مطلوب",)
              : Container(),
        ]),
      ),
    );
  }

  void pickImageCameraBackID() async {
    pickedFileBackID = await _picker.pickImage(
      source: ImageSource.camera,
    );


    if (pickedFileBackID != null) {
      imageFileBackID = File(pickedFileBackID.path);
      _loadBackID = true;
      var imageName = pickedFileBackID.path.split('/').last;

      calculateImageSizeBackID(pickedFileBackID.path);

      if (pickedFileBackID != null) {
        _cropImageBackID(File(pickedFileBackID.path));
      }
    }
  }

  void pickImageGalleryBackID() async {
    pickedFileBackID = await _picker.pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFileBackID != null) {
      imageFileBackID = File(pickedFileBackID.path);
      _loadBackID= true;
      var imageName = pickedFileBackID.path.split('/').last;
      calculateImageSizeBackID(pickedFileBackID.path);
      if (pickedFileBackID != null) {
        _cropImageBackID(File(pickedFileBackID.path));
      }
    }
  }

  _cropImageBackID(Io.File picture) async {
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
            _loadBackID= false;
            pickedFileBackID = null;
          });
        } else {
          final base64Image = Io.File(cropped.path).readAsBytesSync();
          img64BackID = base64Encode(base64Image);
          print('img64Crop after crop:');
          printLongStringIDBack(img64BackID);
          imageFileBackPathID = File(cropped.path);

        }
      });
    } else {
      this.setState(() {
        _loadBackID= false;
        pickedFileBackID = null;
      });
    }
  }

  void clearImageBackID() {
    this.setState(() {
      _loadBackID = false;
      pickedFileBackID = null;
    });
  }

  void printLongStringIDBack(String text) {
    final RegExp pattern =
    RegExp('.{1,10000}'); // 100000 is the size of each chunk
    pattern
        .allMatches(text)
        .forEach((RegExpMatch match) => print(match.group(0)));
  }

  void _showPickerBackID(context) {
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
                      pickImageCameraBackID();
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
                      pickImageGalleryBackID();
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

  void calculateImageSizeBackID(String path) {
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


  @override
  void initState() {
    verifyOTPSCheckMSISDNBloc =
        BlocProvider.of<VerifyOTPSCheckMSISDNBloc>(context);
    // TODO: implement initState
    super.initState();

  }
  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
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
                "E-SIM",
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body:Stack(
              children: [
                showThirdStep==false?
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      /*********************************************************First Step to check validity of package***********************************************/
                      Container(
                        color: Colors.white,
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            buildPackage(),
                            SizedBox(height: 20,),
                            buildNationality(),
                            SizedBox(height: 20,),
                            selectedPackage=="Generic Prepaid BB"?  buildReferenceNumber():Container(),
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

                            SizedBox(height: 20,),
                            selectedNationality=="Jordanian"?
                            _nationalNo()
                                :
                            _passportNo() ,
                            SizedBox(height: 15,),
                            selectedPackage=="Generic Prepaid BB"?
                            MSISDN():buildSelect_MSISDN(),


                            /*...............................................................................................*/
                            /*.........................Call API to check validity of package and get MSISDN .................*/
                            /*...............................................................................................*/
                            SizedBox(height: 20),
                            hideCheekButton==false?
                            Container(
                                height: 48,
                                width: 300,
                                margin: EdgeInsets.symmetric(horizontal: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xFF4f2565),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:Color(0xFF4f2565),
                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                  ),
                                  onPressed: () async {
                                    //check Generic0JDc with Jordanian
                                    if(selectedPackage=="Generic0JDc" && selectedNationality=="Jordanian"){

                                      if(nationalNo.text != ''){
                                        setState(() {
                                          emptyNationalNo=false;
                                        });
                                      }
                                      if(nationalNo.text == ''){
                                        setState(() {
                                          emptyNationalNo=true;
                                        });
                                      }
                                      if(msisdn_select!=''){
                                        setState(() {
                                          emptyselectedMSISDN=false;
                                        });
                                      }
                                      if(msisdn_select==''){
                                        setState(() {
                                          emptyselectedMSISDN=true;
                                        });
                                      }
                                      if(nationalNo.text != '' &&  msisdn_select!=''){
                                        setState(() {
                                          checkPackagesValidity=true;
                                        });
                                        ValidatePackage_API();
                                      }

                                    }
                                    //check Generic0JDc with non-Jordanian
                                    if(selectedPackage=="Generic0JDc" && selectedNationality=="non-Jordanian"){

                                      if(passportNo.text != ''){
                                        setState(() {
                                          emptyPassportNo=false;
                                        });
                                      }
                                      if(passportNo.text == ''){
                                        setState(() {
                                          emptyPassportNo=true;
                                        });
                                      }
                                      if(msisdn_select!=''){

                                        setState(() {
                                          emptyselectedMSISDN=false;
                                        });
                                      }
                                      if(msisdn_select==''){
                                        print("...msisdn_select.....");
                                        print(selectedMSISDN_Value);
                                        setState(() {
                                          emptyselectedMSISDN=true;
                                        });
                                      }
                                      if(passportNo.text != '' &&  msisdn_select!=''){

                                        setState(() {
                                          checkPackagesValidity=true;
                                        });
                                        ValidatePackage_API();
                                      }

                                    }
                                    //check Generic Prepaid BB with Jordanian
                                    if(selectedPackage=="Generic Prepaid BB" && selectedNationality=="Jordanian"){
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



                                      if(nationalNo.text != '' && referenceNumber.text != '' && referenceNumber.text.length == 10){
                                        setState(() {
                                          emptyNationalNo=false;
                                          checkPackagesValidity=true;
                                        });
                                        ValidatePackage_API();
                                      }
                                      if(nationalNo.text == ''){
                                        setState(() {
                                          emptyNationalNo=true;
                                        });
                                      }

                                    }
                                    //check Generic Prepaid BB with non-Jordanian
                                    if(selectedPackage=="Generic Prepaid BB" && selectedNationality=="non-Jordanian"){
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


                                      if(passportNo.text != '' && referenceNumber.text != '' && referenceNumber.text.length == 10){
                                        setState(() {
                                          emptyPassportNo=false;
                                          checkPackagesValidity=true;
                                        });
                                        ValidatePackage_API();
                                      }
                                      if(passportNo.text == ''){
                                        setState(() {
                                          emptyPassportNo=true;
                                        });
                                      }

                                    }

                                  },

                                  child: Text(
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Check'
                                        : "تحقق",
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                            )
                                :
                            Container(),
                            hideCheekButton==false? SizedBox(height: 20): SizedBox(height: 0),
                            /**************************************************************Second Step to initiatePayment********************************************************/
                            showSecondStep==true?
                            Container(
                              color: Colors.white,
                              child: Column(
                                children: [
                                  SizedBox(height: 20),
                                  enterMerchantID(),
                                  SizedBox(height: 20,),
                                  enterTerminalID(),
                                  SizedBox(height: 20),
                                  /*...............................................................................................*/
                                  /*.................................Call API to check initiatePayment ............................*/
                                  /*...............................................................................................*/
                                  showNextButton==true?
                                  Container(
                                      height: 48,
                                      width: 300,
                                      margin: EdgeInsets.symmetric(horizontal: 20),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(50),
                                        color: Color(0xFF4f2565),
                                      ),
                                      child: TextButton(
                                        style: TextButton.styleFrom(
                                          backgroundColor:Color(0xFF4f2565),
                                          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                        ),
                                        onPressed: () async {

                                          if(merchantID.text ==''){
                                            setState(() {
                                              emptyMerchantID=true;
                                            });
                                          }
                                          if(merchantID.text !=''){
                                            setState(() {
                                              emptyMerchantID=false;
                                            });
                                          }

                                          if(terminalID.text==''){
                                            setState(() {
                                              emptyTerminalID=true;
                                            });
                                          }

                                          if(terminalID.text!=''){
                                            setState(() {
                                              emptyTerminalID=false;
                                            });
                                          }

                                          if(terminalID.text!='' && merchantID.text !=''){
                                            setState(() {
                                              emptyTerminalID=false;
                                              emptyMerchantID=false;
                                              checkinitiatePaymentValidity=true;
                                            });
                                            showSuccessAlertDialog(context,"The total amount required is ${price_valid_package} JD are you sure you want to continue (Merchant Number ${merchantID.text}) ? ","المبلغ الإجمالي المطلوب هو ${price_valid_package} د.أ \n(Merchant Number ${merchantID.text})\n هل أنت متأكد أنك تريد الاستمرار؟");

                                            //2024  initiatePayment_API();
                                          }

                                        },

                                        child: Text(
                                          EasyLocalization
                                              .of(context)
                                              .locale == Locale("en", "US")
                                              ? 'Next'
                                              : "التالي",
                                          style: TextStyle(
                                              color: Colors.white,
                                              letterSpacing: 0,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      )
                                  )
                                      :
                                  Container(),
                                  showSecondStep==true? SizedBox(height: 20): SizedBox(height: 0),
                                ],
                              ),
                            ):
                            Container(),
                            /***********************************************************************************************************************************************/


                          ],
                        ),
                      ),
                      /***********************************************************************************************************************************************/
                      SizedBox(height: 20,),


                    ],
                  ),

                )
                    :
                SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[

                      /**************************************************************Third Step to ********************************************************/
                      Container(
                        height: 55,
                        padding: EdgeInsets.only(top: 5,bottom: 10),
                        child: ListTile(
                          leading: Container(
                            width: 280,
                            child: Text(
                              EasyLocalization
                                  .of(context)
                                  .locale == Locale("en", "US")
                                  ? 'Customer Information'
                                  : "معلومات المستخدم",
                              style: TextStyle(
                                  fontSize: 16,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        color: Colors.white,
                        child: Column(
                          children: [
                            SizedBox(height: 20),
                            buildOTP(),
                            isJordanian==false?
                            Column(
                              children: [
                                SizedBox(height: 20),
                                buildFirstName(),
                                SizedBox(height: 20,),
                                buildSecondName(),
                                SizedBox(height: 20),
                                buildThirdName(),
                                SizedBox(height: 20),
                                buildLastName(),
                              ],
                            ):Container(),

                            SizedBox(height: 20),
                            buildBirthDate(),
                            buildEmailAddress(),
                            SizedBox(height: 20),
                            buildDocumentExpiryDate(),
                            SizedBox(height: 30,),


                          ],
                        ),
                      ),

                      /*..........................................................................................................*/
                      /*.................................Passport Information for non-Jordanian...................................*/
                      /*..........................................................................................................*/
                      isJordanian==false?
                      Container(
                        child: Column(
                          children: [
                            Container(
                              height: 55,
                              padding: EdgeInsets.only(top: 5,bottom: 10),
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
                                      onPressed: () => {clearImageFrontPassport()}),
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
                                        buildImageFrontPassport(),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ):Container(),
                      /*..........................................................................................................*/
                      /*..............................................ID Information..............................................*/
                      /*..........................................................................................................*/
                      isJordanian==true?
                      Container(
                        child: Column(
                          children: [
                            /*..........................................................................................................*/
                            /*...................................ID Front Information for Jordanian.....................................*/
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(top: 5,bottom: 10),
                                    child: ListTile(
                                      leading: Container(

                                        width: 280,
                                        child: Text(
                                          EasyLocalization
                                              .of(context)
                                              .locale == Locale("en", "US")
                                              ? 'ID Photo Front'
                                              : "صورة الهوية الأمامية",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff11120e),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      trailing: _loadFrontID == true
                                          ? Container(
                                        child: IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Color(0xff0070c9),
                                            onPressed: () => {clearImageFrontID()}),
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
                                              buildImageFrontID(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            /*..........................................................................................................*/
                            /*...................................ID Back Information for Jordanian......................................*/
                            Container(
                              child: Column(
                                children: [
                                  Container(
                                    height: 55,
                                    padding: EdgeInsets.only(top: 5,bottom: 10),
                                    child: ListTile(
                                      leading: Container(

                                        width: 280,
                                        child: Text(
                                          EasyLocalization
                                              .of(context)
                                              .locale == Locale("en", "US")
                                              ? 'ID Photo Back'
                                              : "صورة الهوية الخلفية",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff11120e),
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      trailing: _loadBackID == true
                                          ? Container(
                                        child: IconButton(
                                            icon: Icon(Icons.delete),
                                            color: Color(0xff0070c9),
                                            onPressed: () => {clearImageBackID()}),
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
                                              buildImageBackID(),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ):Container(),


                      /*...............................................................................................*/
                      /*..........................................Call API to check Submit ............................*/
                      /*...............................................................................................*/

                      Container(
                        padding: EdgeInsets.only(left: 15, right: 15),
                        child: Column(
                          children: [
                            SizedBox(height: 15,),
                            Container(
                                height: 48,
                                width: double.infinity,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50),
                                  color: Color(0xFF4f2565),
                                ),
                                child: TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor:Color(0xFF4f2565),
                                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                                  ),
                                  onPressed: () async {
                                    /*...........................................Check Birth Day.......................................*/
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
                                    if(otp.text==''){
                                      setState(() {
                                        emptyOTP=true;
                                      });
                                    }
                                    if(otp.text!=''){
                                      setState(() {
                                        emptyOTP=false;
                                      });
                                    }
                                    /*If isJordainian = false will check front passport image */
                                    if(isJordanian==false){
                                      setState(() {
                                        img64FrontID=null;
                                        img64BackID=null
                                        ;                                        });
                                      if (img64FrontPassport == null) {
                                        setState(() {
                                          imageFrontRequiredPassport = true;
                                        });

                                      }
                                      if (img64FrontPassport != null) {
                                        setState(() {
                                          imageFrontRequiredPassport = false;
                                        });
                                      }

                                      if(FirstName.text==''){
                                        setState(() {
                                          emptyFirstName=true;
                                        });
                                      }
                                      if(FirstName.text!=''){
                                        setState(() {
                                          emptyFirstName=false;
                                        });
                                      }

                                      if(LastName.text == ''){
                                        setState(() {
                                          emptyLastName=true;
                                        });
                                      }
                                      if(LastName.text != ''){
                                        setState(() {
                                          emptyLastName=false;
                                        });
                                      }

                                      if(img64FrontPassport != null &&
                                          FirstName.text!='' &&
                                          LastName.text != '' &&
                                          otp.text!='' &&
                                          documentExpiryDate.text !="" &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' && birthDateValid==true){
                                        submit_API();
                                        setState(() {
                                          checkSubmitValidity=true;
                                        });

                                      }else{

                                        showToast( EasyLocalization
                                            .of(context)
                                            .locale == Locale("en", "US")
                                            ? 'Please fill all required field'
                                            : "يرجى ملء كافة الحقول المطلوبة",
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);

                                      }
                                    }
                                    /*......................................*/
                                    /*If isJordainian = true will check front ID  & back ID images */
                                    if(isJordanian==true){
                                      setState(() {
                                        img64FrontPassport=null;
                                      });
                                      if (img64FrontID== null) {
                                        setState(() {
                                          imageFrontRequiredID = true;
                                        });

                                      }
                                      if (img64FrontID != null) {
                                        setState(() {
                                          imageFrontRequiredID = false;
                                        });
                                      }
                                      if (img64BackID== null) {
                                        setState(() {
                                          imageRequiredBackID = true;
                                        });

                                      }
                                      if (img64BackID != null) {
                                        setState(() {
                                          imageRequiredBackID = false;
                                        });
                                      }
                                      if(img64FrontID != null &&
                                          img64BackID != null &&
                                          otp.text!=''&&
                                          documentExpiryDate.text !="" &&
                                          day.text != '' &&
                                          month.text != '' &&
                                          year.text != '' && birthDateValid==true){

                                        setState(() {
                                          checkSubmitValidity=true;
                                        });

                                        submit_API();

                                      }else{
                                        showToast( EasyLocalization
                                            .of(context)
                                            .locale == Locale("en", "US")
                                            ? 'Please fill all required field'
                                            : "يرجى ملء كافة الحقول المطلوبة",
                                            context: context,
                                            animation: StyledToastAnimation.scale,
                                            fullWidth: true);
                                      }

                                    }
                                    /*...................................*/



                                  },

                                  child: Text(
                                    EasyLocalization
                                        .of(context)
                                        .locale == Locale("en", "US")
                                        ? 'Submit'
                                        : "ارسال",
                                    style: TextStyle(
                                        color: Colors.white,
                                        letterSpacing: 0,
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold),
                                  ),
                                )
                            ),
                            SizedBox(height: 15,),
                            Container(
                              height: 48,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.transparent, // Background color
                                borderRadius: BorderRadius.circular(50),
                                border: Border.all(
                                  color: Color(0xFF4f2565), // Border color
                                  width: 2.0, // Border width
                                ),
                              ),
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  shape: BeveledRectangleBorder(
                                    borderRadius: BorderRadius.all(Radius.circular(24)),
                                  ),
                                  backgroundColor: Colors.transparent, // Make the background of the button transparent to show the container's background
                                ),
                                onPressed: () async {
                                  setState(() {
                                    showThirdStep = false;
                                    showSecondStep = false;
                                    showNextButton = false;
                                    msisdn.text="";
                                    otp.text='';
                                    nationalNo.text='';
                                    passportNo.text='';
                                    selectedMSISDN_Value='';
                                    hideCheekButton=false;
                                  });
                                },
                                child: Text(
                                  EasyLocalization.of(context).locale == Locale("en", "US") ? 'Cancel' : "الغاء",
                                  style: TextStyle(
                                    color: Color(0xFF4f2565), // Text color
                                    letterSpacing: 0,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 15,),
                          ],
                        ),
                      )



                      /***********************************************************************************************************************************************/
                    ],
                  ),

                ),


                // Transparent overlay
                Visibility(
                  visible: checkPackagesValidity, // Adjust the condition based on when you want to show the overlay
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

                Visibility(
                  visible: checkMSISDNList, // Adjust the condition based on when you want to show the overlay
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

                Visibility(
                  visible: checkinitiatePaymentValidity, // Adjust the condition based on when you want to show the overlay
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

                Visibility(
                  visible: checkSubmitValidity, // Adjust the condition based on when you want to show the overlay
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
