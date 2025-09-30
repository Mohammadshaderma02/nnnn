import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';


import '../../../../../../blocs/CorpPart/SearchCriteria/SearchCriteria.block.dart';
import '../../../../../LoginScreens/SignInScreen.dart';
import '../../../Multi_Use_Components/RequiredField.dart';
import '../Customer360view.dart';


class UpdateCustomer extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  String searchCraretia;
  String msisdn;
  String customerNumber;
  List data=[];
  UpdateCustomer(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _UpdateCustomerState createState() => _UpdateCustomerState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class Item {
  const Item(this.value, this.text);
  final String value;
  final String text;
}


class _UpdateCustomerState extends State<UpdateCustomer> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  DateTime backButtonPressedTime;
  String msisdn;
  String customerNumber;
  List data=[];
  String messageEn;
  String messageAr;
  String activeDate;
  String searchCraretia;
  final List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  SearchCriteriaBloc searchCriteriaBloc;
  _UpdateCustomerState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


  TextEditingController email = TextEditingController();
  TextEditingController street = TextEditingController();
  TextEditingController homeNO = TextEditingController();
  TextEditingController justification = TextEditingController();
  TextEditingController officeNo = TextEditingController();
  TextEditingController POBox = TextEditingController();
  TextEditingController postalCode = TextEditingController();
  TextEditingController InvoiceDelivery = TextEditingController();


  bool emptyEmail =false;
  bool emptyState =false ;
  bool emptyCity=false;
  bool emptyArea=false;
  bool emptyStreet=false;
  bool emptyHomeNO =false;
  bool emptyOfficeNo  =false;
  bool emptyPOBox=false;
  bool emptyPostalCode=false;
  bool emptyInvoiceDelivery=false;
  bool emptyAccountType=false;
  bool emptyMonth=false;
  bool emptyYear=false;
  bool emptyJustification=false;

  bool showInvoiceDeliveryField=false;

  var STATE= [];
  var CITIES= [];
  var AREAS=[];
  var INVOICE_DELIVERY=[];
  var ACCOUNT_TYPE=[];
  var MONTHS=[];
  var YEARS=[];

  var selectedStateValue;
  var selectedCityValue;
  var selectedAreaValue;
  var selectedAreaText;
  var selectedMonthValue;
  var selectedYearValue;
  var selectedInvoiceDeliveryValue;
  var selectedAccountTypeValue;
  var imsi ='';


  String buildingNumber='';
  bool isLoading=false;
  bool isLoadingSubmit=false;
  bool isLoadingInvoice=false;
  bool isLoadingStatement=false;

  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.email".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyEmail==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyEmail ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: email,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
               hintText: "UpdateCustomer.enter_email".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyEmail  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }
  Widget buildJustification() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.justification".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyJustification==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyEmail ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: justification   ,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "UpdateCustomer.enter_justification".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyJustification  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }
  Widget buildState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.state".tr().toString(),
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
                color:emptyState == true
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
                  icon:  Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: STATE.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem['value'] ,
                      child:  Text(valueItem["value"]),
                    );
                  }).toList(),
                  value: selectedStateValue,
                  onChanged: (String newValue) {

                    setState(() {
                      selectedStateValue =newValue ;
                      selectedCityValue=null;
                      selectedAreaValue=null;

                    });


                    getCities_API();

                  },
                ),
              ),
            )),
        emptyState==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }
  Widget buildCity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.city".tr().toString(),
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
                color:emptyCity == true
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
                  icon:  Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: CITIES.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["value"] ,
                      child: Text(valueItem["value"]),
                    );
                  }).toList(),
                  value: selectedCityValue,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedCityValue = newValue;
                      selectedAreaValue=null;


                    });


                     getArea_API();

                  },
                ),
              ),
            )),
        emptyCity==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }
  Widget buildArea() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.area".tr().toString(),
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
                color:emptyArea == true
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
                  icon:  Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: AREAS.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:    valueItem["value"],
                      child:  Text(valueItem["value"])
                    );
                  }).toList(),
                  value: selectedAreaValue,
                  onChanged: (String newValue) {
                    setState(() {

                      selectedAreaValue=newValue;


                    });


                  },
                ),
              ),
            )),
        emptyArea==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }
  Widget buildStreet() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.street".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyStreet==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyStreet ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: street,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "UpdateCustomer.enter_street".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyStreet  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }
  Widget buildHomeNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.home_no".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyHomeNO==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyHomeNO ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: homeNO,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "UpdateCustomer.enter_home_no".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyHomeNO  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }
  Widget buildOfficeNo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.office_no".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyOfficeNo==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyOfficeNo ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: officeNo,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "UpdateCustomer.enter_office_no".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyOfficeNo  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }

  Widget buildPBox() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.p_o_box".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyPOBox==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyPOBox ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: POBox,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "UpdateCustomer.p_o_box".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyPOBox  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }
  Widget buildPostalCode() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.postal_code".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyPostalCode==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyPostalCode ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: postalCode,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "UpdateCustomer.enter_postal_code".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyPostalCode  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }

  Widget buildInvoiceDelivery() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.invoice_delivery".tr().toString(),
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
                color:emptyInvoiceDelivery == true
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
                  icon:  Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: INVOICE_DELIVERY.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:  valueItem,
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem)
                          : Text(valueItem),
                    );
                  }).toList(),
                  value: selectedInvoiceDeliveryValue,
                  onChanged: (String newValue) {
                    setState(() {
                     selectedInvoiceDeliveryValue = newValue;

                    });


                  },
                ),
              ),
            )),

        emptyInvoiceDelivery==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }
  Widget buildInvoiceDeliveryFeild() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
            RichText(
            text: TextSpan(
                text: EasyLocalization.of(context).locale == Locale("en", "US")?"Your Delivery Method Value Not included In Delivery Method List ":
            " طريقة التسليم الخاصة بك غير مدرجة في قائمة طرق التسليم"
            ,style: TextStyle(
            color: Color(0xFF11120E),
            fontSize: 14,
            fontWeight: FontWeight.normal,
            ),

            ),
            ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyPOBox==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Color(0xFFD1D7E0).withOpacity(0.4),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyPOBox ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            enabled: false,

            controller: InvoiceDelivery,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              fillColor: Color(0xFFA4B0C1),
              hintText: "UpdateCustomer.p_o_box".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),


      ],
    );
  }

  Widget buildAccountType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.account_type".tr().toString(),
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
                color:emptyAccountType == true
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
                  icon:  Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: ACCOUNT_TYPE.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:  valueItem["value"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["name"])
                          : Text(valueItem["name"]),
                    );
                  }).toList(),
                  value: selectedAccountTypeValue,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedAccountTypeValue = newValue;

                    });


                  },
                ),
              ),
            )),
        emptyAccountType==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildUpdateBtn() {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: isLoadingSubmit==true?null: () {

              updateCustomerInfoAndAddressDetailsZainService_API();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoadingSubmit?SizedBox(
                  child: CircularProgressIndicator(color: Colors.white ),
                  height: 20.0,
                  width: 20.0,
                ):
                Icon(Icons.save_outlined,color: Colors.white,),

                SizedBox(width: 10,),
                Text(
                  "UpdateCustomer.update".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
        ),
      ),
    );
  }
  Widget buildResendInvoiceBtn() {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: () {

              _showResendInvoiceDialog();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(width: 10,),
                Text(
                  "UpdateCustomer.resend_invoice_statement_btn".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget buildResendInvoice() {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed:isLoadingInvoice?null: () {

              ResendInvoiceOrStatement_API(false);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoadingInvoice==true?SizedBox(
                  child: CircularProgressIndicator(color: Colors.white ),
                  height: 20.0,
                  width: 20.0,
                ):Container(),
                SizedBox(width: 10,),
                Text(
                  "UpdateCustomer.resend_invoice".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
        ),
      ),
    );
  }
  Widget buildResendStatement() {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: isLoadingStatement?null: () {

              ResendInvoiceOrStatement_API(true);
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoadingStatement?SizedBox(
                  child: CircularProgressIndicator(color: Colors.white ),
                  height: 20.0,
                  width: 20.0,
                ):Container(),
                SizedBox(width: 10,),
                Text(
                  "UpdateCustomer.resend_statement".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
        ),
      ),
    );
  }
  Widget buildCancelbtn() {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xffE9E9E9),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xffE9E9E9),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: () {

             Navigator.pop(context);
             setState(() {
               selectedYearValue=null;
               selectedMonthValue=null;
               emptyYear=false;
               emptyMonth=false;
               isLoadingStatement=false;
               isLoadingInvoice=false;
             });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                SizedBox(width: 10,),
                Text(
                  "corpAlert.cancel".tr().toString(),
                  style: TextStyle(
                      color: Colors.black,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
        ),
      ),
    );
  }



  Widget buildMonth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.month".tr().toString(),
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
                color:emptyMonth == true
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
                  icon:  Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: MONTHS.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["value"] ,
                      child: Text(valueItem["name"]),
                    );
                  }).toList(),
                  value: selectedMonthValue,
                  onChanged: (String newValue) {

                    print(newValue);
                    Navigator.pop(context);
                    _showResendInvoiceDialog();
                    setState(() {
                      selectedMonthValue = newValue;


                    });




                  },
                ),
              ),
            )),
        emptyMonth==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }
  Widget buildYear() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "UpdateCustomer.year".tr().toString(),
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
                color:emptyYear== true
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
                  icon:  Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: YEARS.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["value"] ,
                      child: Text(valueItem["name"]),
                    );
                  }).toList(),
                  value: selectedYearValue,
                  onChanged: (String newValue) {
                    Navigator.pop(context);
                    _showResendInvoiceDialog();
                    setState(() {
                      selectedYearValue = newValue;



                    });




                  },
                ),
              ),
            )),
        emptyYear==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }

  UnotherizedError() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('is_logged_in', false);
    prefs.setBool('biomitric_is_logged_in', false);
    prefs.setBool('TokenError', true);
    prefs.remove("accessToken");
    //prefs.remove("userName");
    prefs.remove('counter');

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => SignInScreen(),
      ),
    );

  }


  getCustomerInfoAndAddressDetailsZainService_API() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading=true;
    });
    var apiArea = urls.BASE_URL + '/Customer360/getCustomerInfoAndAddressDetailsZainService';
    final Uri url = Uri.parse(apiArea);

    Map body = {
      "customerId": customerNumber,
      "msisdn":msisdn
    };

    print('services');
    print(json.encode(body));
    print(prefs.getString("accessToken"));
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body: json.encode(body),);
    int statusCode = response.statusCode;

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
     // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);



      if( result["status"]==0){
        if(result["data"]==null){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{


          print('deliveryMethod');
          print( selectedInvoiceDeliveryValue=result["data"]["deliveryMethod"]);
          print(selectedInvoiceDeliveryValue=result["data"]["deliveryMethodItemsList"]);
          if(result["data"]["deliveryMethodItemsList"].contains(result["data"]["deliveryMethod"])){
            print('includded');
            setState(() {
              selectedInvoiceDeliveryValue=result["data"]["deliveryMethod"];
              INVOICE_DELIVERY=result['data']["deliveryMethodItemsList"];
            });
          }else{
            print('notincludded');
            setState(() {
              showInvoiceDeliveryField=true;
              InvoiceDelivery.text=result["data"]["deliveryMethod"].toString();
              selectedInvoiceDeliveryValue=null;
              INVOICE_DELIVERY=result['data']["deliveryMethodItemsList"];
            });
          }

          setState(() {
            ACCOUNT_TYPE=result["data"]["accountTypeList"];
            selectedAccountTypeValue=result["data"]["accountType"];
            selectedStateValue=result['data']['stateAddress'];
            selectedCityValue=result['data']['city'];
            selectedAreaValue=result['data']['area'];
            street.text=result['data']["streetAddress"];
            homeNO.text=result['data']["referenceNumber"];
            officeNo.text=result['data']["officeNumber"];
            email.text=result['data']["email"];
            POBox.text=result['data']["poBox"];
            postalCode.text=result['data']["postalCode"];
            buildingNumber=result['data']["buildingNumber"];
            MONTHS=result['data']['monthsList'];
            YEARS=result['data']['yearsList'];
            justification.text=result['data']['changeRefComments'];
          });


          setState(() {
            isLoading=false;
          });

          getState_API();
          getCities_API();
          getArea_API();


        }

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);


      }


      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }
  getState_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lookup/GOVERNORATE';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;
    print('TOKEN');
    print(prefs.getString("accessToken"));

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
    //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);

      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{
          setState(() {

            STATE=result["data"];
          });


        }

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);



      }




      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }
  getCities_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lookup/CITIES/'+selectedStateValue;
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;
    print('TOKEN');
    print(prefs.getString("accessToken"));

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
     // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);



      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
       //   showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{
          print("cITIRES");
          print(result["data"]);
          setState(() {

           CITIES=result["data"];
          });


        }

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);



      }




      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }
  getArea_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lookup/AREAS/'+selectedCityValue;
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;
    print('TOKEN');
    print(prefs.getString("accessToken"));

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
    //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);



      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
        //  showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{
          setState(() {

            AREAS=result["data"];
          });


        }

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);



      }




      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }

  updateCustomerInfoAndAddressDetailsZainService_API() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoadingSubmit=true;
    });

   var innerDeliveryMethod='';
   if( showInvoiceDeliveryField==true){
     innerDeliveryMethod=InvoiceDelivery.text;
   }else{
     if(selectedInvoiceDeliveryValue==null){
       innerDeliveryMethod=InvoiceDelivery.text;
     }else{
       innerDeliveryMethod=selectedInvoiceDeliveryValue;
     }
   }

    var apiArea = urls.BASE_URL + '/Customer360/updateCustomerAddressZainService';
    final Uri url = Uri.parse(apiArea);
    print(url);
    Map body = {
      "customerId": customerNumber,
      "msisdn": msisdn,
      "accountTypeValue": selectedAccountTypeValue,
      "areaText": selectedAreaValue,
      "areaValue": '',
      "buildingNumber": buildingNumber,
      "changeRefComments": justification.text,
      "cityText": selectedCityValue,
      "cityValue": '',
      "deliveryMethod":innerDeliveryMethod

     , "email": email.text,
      "homeNumber": homeNO.text,
      "officeNumber": officeNo.text,
      "pinCode": '',
      "poBox":POBox.text ,
      "postalCode": postalCode.text,
      "referenceNumber": homeNO.text,
      "stateText": selectedStateValue,
      "stateValue": '',
      "streetAddress": street.text
    };


    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body: json.encode(body),);
    print(json.encode(body));
    int statusCode = response.statusCode;

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
    //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);
      if( result["status"]==0){


          setState(() {
            isLoadingSubmit=false;
          });

          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? result["message"]
                  : result["messageAr"],
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);


          getCustomerInfoAndAddressDetailsZainService_API();




        }

      else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoadingSubmit=false;
        });


      }




      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }

  ResendInvoiceOrStatement_API(  isStatement ) async{
    if(selectedYearValue==null){
      Navigator.pop(context);
      _showResendInvoiceDialog();
      setState(() {
        emptyYear=true;
      });
    }else if(selectedYearValue!=null){
      setState(() {
        emptyYear=false;
      });
    }
    if(selectedMonthValue==null){
      Navigator.pop(context);
      _showResendInvoiceDialog();
      setState(() {
        emptyMonth=true;
      });
    }else if(selectedMonthValue!=null){
      setState(() {
        emptyMonth=false;
      });
    }

    if(emptyMonth==false && emptyYear==false){

      setState(() {

        isLoadingInvoice= isStatement==true ? false:true;
        isLoadingStatement=isStatement==true ? true:false;
      });

      Navigator.pop(context);
      _showResendInvoiceDialog();
      SharedPreferences prefs = await SharedPreferences.getInstance();

      var apiArea = urls.BASE_URL + '/Customer360/resendInvoiceOrStatementZainService';

      final Uri url = Uri.parse(apiArea);
      print(url);
      Map body = {
        "customerId": customerNumber,
        "msisdn": msisdn,
        "imsi": imsi,

        "email": email.text,

        "month": selectedMonthValue,
        "year": selectedYearValue,

        "sendStatment": isStatement
      };


      final response = await http.post(url, headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },body: json.encode(body),);
      print(json.encode(body));
      int statusCode = response.statusCode;

      print("statusCode");
      print(statusCode);
      print('body: [${response.body}]');

      if (statusCode == 500) {
        print('500  error ');

      }
      if(statusCode==401 ){
        print('401  error ');
        UnotherizedError();
       // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

      }
      if (statusCode == 200) {


        var result = json.decode(response.body);
        if( result["status"]==0){

          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? result["message"]
                  : result["messageAr"],
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          Navigator.pop(context);
          setState(() {
            isLoadingInvoice=false;
            isLoadingStatement=false;
            selectedYearValue=null;
            selectedMonthValue=null;
            emptyMonth=false;
            emptyYear=false;
          });

        }

        else{
          Navigator.pop(context);
          showAlertDialogERROR(context,result["messageAr"], result["message"]);
          setState(() {

            isLoadingInvoice= false;
            isLoadingStatement=false;
            selectedMonthValue=null;
            selectedYearValue=null;
            emptyMonth=false;
            emptyYear=false;
          });

        }




        return result;
      }else{
        showAlertDialogOtherERROR(context,statusCode, statusCode);

      }
    }

  }


  void initState() {

    print("role role role role role");
    print('imsi');
    print(data[0]['imsi']);

    setState(() {
      imsi=data[0]['imsi'];
    });
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{
      // getPackagesListUnderCustomer_API ();
    }


    getCustomerInfoAndAddressDetailsZainService_API();
    //getSubscriberDetails_API();
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    //disableCapture();
    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }
  showAlertDialogERROR(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: Text(
            "alert.cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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
  showAlertDialogUnotherizedERROR(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            UnotherizedError();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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
  showAlertDialogOtherERROR(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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
  showAlertDialogNoData(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.of(context).pop();
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
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

  Future<void> _showResendInvoiceDialog( ) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,


      builder: (BuildContext context) {

        return AlertDialog(
          title: Text(
            "UpdateCustomer.resend_invoice_statement_title".tr().toString(),
          ),
          content:
          Container(

            padding: EdgeInsets.only(bottom: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(height: 20,),
                buildMonth(),
                SizedBox(height: 10,),
                buildYear(),


              ],
            ),
          ),
          actions: <Widget>[
            Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.only(left: 16,right: 16),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      buildResendInvoice(),
                      SizedBox(height: 20,),
                      buildResendStatement(),
                      SizedBox(height: 20,),

                      buildCancelbtn(),
                      SizedBox(height: 10,),
                      // button 2
                    ])),
          ],
        );
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
              Navigator.pop(context);
            },
          ),

          title: Text(
            "corpMenu.UpdateCustomer​".tr().toString(),
          ),
          backgroundColor: Color(0xFF392156),
        ),
        backgroundColor: Color(0xFFEBECF1),
        body: isLoading==true?Container(
            width: double.infinity,
            padding: EdgeInsets.only(left: 26, right: 26,top: 30),
            // margin: EdgeInsets.all(12),
            margin: EdgeInsets.only(top: 60),
            child:Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  child: CircularProgressIndicator(color: Color(0xFF392156) ),
                  height: 20.0,
                  width: 20.0,
                ),
                SizedBox(width: 24),
                Text("corporetUser.PleaseWait".tr().toString(),
                  style: TextStyle(fontWeight: FontWeight.bold, color:Color(0xFF392156),fontSize: 16 ),)],

            )): ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: 10), children: <Widget>[
          Container(
            color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: <Widget>[
                      SizedBox(height: 20),
                      buildState(),
                      SizedBox(height: 20),
                      buildCity(),
                      SizedBox(height: 20),
                      buildArea(),
                      SizedBox(height: 20),
                      buildStreet(),
                      SizedBox(height: 20),
                       Row(

                          children: [
                            Container(

                                child: buildHomeNo(),
                               width:MediaQuery.of(context).size.width/3 *1.3,

                            ),
                          Spacer(),
                            Container(child: buildOfficeNo(),
                                width:MediaQuery.of(context).size.width/3 *1.3,
                            )
                          ],
                        ),

                      SizedBox(height: 20),
                      buildPBox(),
                      SizedBox(height: 20),
                      buildPostalCode(),
                      showInvoiceDeliveryField==true?SizedBox(height: 20):Container(),
                      showInvoiceDeliveryField==true?buildInvoiceDeliveryFeild():Container(),
                      SizedBox(height: 20),
                      buildInvoiceDelivery(),
                      SizedBox(height: 20),
                      buildAccountType(),
                      SizedBox(height: 20),
                      buildEmail(),
                      SizedBox(height: 20),
                      buildJustification(),
                      SizedBox(height: 20),
                      buildUpdateBtn(),
                      SizedBox(height: 20),
                      buildResendInvoiceBtn(),
                      SizedBox(height: 20),





                    ],
                  ),
                ),

              ],
            ),

          ),

        ]),
      ),
    );
  }
}