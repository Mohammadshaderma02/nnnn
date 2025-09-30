import 'dart:io';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/logoutButton.dart';
import 'package:sales_app/blocs/LookUpList/LokkUpList_state.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_bloc.dart';
import 'package:sales_app/blocs/LookUpList/LookUpList_events.dart';
import 'package:sales_app/blocs/SaveProfileInfo/SaveProfileInfo_bloc.dart';
import 'package:sales_app/blocs/SaveProfileInfo/SaveProfileInfo_events.dart';
import 'package:sales_app/blocs/SaveProfileInfo/SaveProfileInfo_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Setting/SettingsScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/NotificationsScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:liquid_pull_to_refresh/liquid_pull_to_refresh.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class Item {
  const Item(this.value, this.textEn, this.textAr);
  final String value;
  final String textEn;
  final String textAr;
}

List<Item> GENDER = <Item>[];
List<Item> NATIONALITY = <Item>[];
List<Item> PROFESSION = <Item>[];
List<Item> EDUCATION = <Item>[];
List<Item> MARITAL_STATUS = <Item>[];
List<Item> LANGUAGE = <Item>[];
List<Item> COMTYPE = <Item>[];
List<Item> GIFTS = <Item>[];
bool isEnabled =false;
//subdealerTawasolNumber
class _ProfileState extends State<Profile> {
  TextEditingController MobileNumber = TextEditingController();
  TextEditingController MobileNumber1 = TextEditingController();
  TextEditingController MobileNumber2 = TextEditingController();
  TextEditingController MobileNumber3 = TextEditingController();
  TextEditingController FirstName = TextEditingController();
  TextEditingController SecondName = TextEditingController();
  TextEditingController ThirdName = TextEditingController();
  TextEditingController FamilyName = TextEditingController();
  String gender;
  String nationality;
  String profession;
  String education;
  String marital_status;
  String language;
  String comtype;
  String gift;
  TextEditingController email = TextEditingController();
  TextEditingController day = TextEditingController();
  TextEditingController month = TextEditingController();
  TextEditingController year = TextEditingController();
  bool emptyMobileNumber1 = false;
  bool emptyFirstName = false;
  bool emptyFamilyName = false;
  bool SecondView = false;

  bool emptyGender = false;
  bool emptyNationality = false;
  bool emptyProfession = false;
  bool emptyEducation = false;
  bool emptyMaterialStatus = false;
  bool emptyLanguage = false;
  bool emptypreferredComunication = false;
  bool emptyEmail = false;
  bool emptyGifts = false;
  bool emptyDay = false;
  bool emptyMonth = false;
  bool emptyYear = false;

  GetLookUpListBloc getLookUpListBloc;
  DateTime backButtonPressedTime;
  String mobileNumber = '';

  TextEditingController old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();

  SaveProfileInfoBloc saveProfileInfoBloc;

  void getSharedPrefernece() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      mobileNumber = prefs.getString('subdealerTawasolNumber');
    });
    MobileNumber.text = mobileNumber;
  }

  @override
  void initState() {
    super.initState();
    getLookUpListBloc = BlocProvider.of<GetLookUpListBloc>(context);
    saveProfileInfoBloc = BlocProvider.of<SaveProfileInfoBloc>(context);
    getLookUpListBloc.add(GetLookUpListFetchEvent());
    getSharedPrefernece();
  }

  Future<void> _pullRefresh() async {
    setState(() {});
    // why use freshWords var? https://stackoverflow.com/a/52992836/2301224
  }

  Widget buildMobileNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.mobile_number".tr().toString(),
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
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: MobileNumber,
            enabled: isEnabled,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              disabledBorder: OutlineInputBorder(borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              fillColor: Color(0xFFEBECF1),
              filled: true,
              contentPadding: EdgeInsets.all(16),
              hintText: "Basic_Info_Edit.enter_mobile_number".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
  Widget buildMobileNumber1() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.mobile_no1".tr().toString(),
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
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: MobileNumber1,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            decoration: InputDecoration(
              enabledBorder: emptyMobileNumber1 == true
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
              hintText: "Basic_Info_Edit.enter_mobile_no1".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildMobileNumber2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.mobile_no2".tr().toString(),
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
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: MobileNumber2,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:
                    const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Basic_Info_Edit.enter_mobile_no2".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildMobileNumber3() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.mobile_no3".tr().toString(),
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
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            controller: MobileNumber3,
            keyboardType: TextInputType.phone,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly
            ],
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:
                    const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Basic_Info_Edit.enter_mobile_no3".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }
  Widget buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.first_name".tr().toString(),
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
              hintText: "Basic_Info_Edit.enter_first_name".tr().toString(),
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
            text: "Profile_Form.second_name".tr().toString(),
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
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:
                    const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Basic_Info_Edit.enter_second_name".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildThirdName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.third_name".tr().toString(),
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
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide:
                    const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Basic_Info_Edit.enter_third_name".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildFamilyName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.last_name".tr().toString(),
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
            controller: FamilyName,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyFamilyName == true
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
              hintText: "Basic_Info_Edit.enter_last_name".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }
  Widget buildGender() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "Profile_Form.gender".tr().toString(),
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
          BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
              builder: (context, state) {
            if (state is GetLookUpListSuccessState ||
                state is GetLookUpListLoadingState ||
                state is GetLookUpListListErrorState) {
              GENDER = [];
              if (state is GetLookUpListSuccessState) {
                GENDER = [];
                 for (var obj in state.data[0]['value']['data']) {
                   GENDER.add(Item(obj['key'], obj['value'].toString(),
                       obj['valueAr'].toString()));
                 }

              }
              return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      //color: Color(0xFFB10000), red color
                      color: emptyGender == true
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
                        value: gender,
                        onChanged: (String newValue) {
                          setState(() {
                            gender = newValue;
                          });
                        },
                        items: GENDER.map((valueItem) {
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
  Widget buildNationality() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.nationality".tr().toString(),
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
        BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
            builder: (context, state) {
          if (state is GetLookUpListSuccessState ||
              state is GetLookUpListLoadingState ||
              state is GetLookUpListListErrorState) {
            NATIONALITY = [Item('', '', '')];
            if (state is GetLookUpListSuccessState) {
              NATIONALITY = [];
              for (var obj in state.data[1]['value']['data']) {
                NATIONALITY.add(Item(obj['key'], obj['value'].toString(),
                    obj['valueAr'].toString()));
              }
            }
            return Container(
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
                      value: nationality,
                      onChanged: (String newValue) {
                        setState(() {
                          nationality = newValue;
                        });
                      },
                      items: NATIONALITY.map((valueItem) {
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
      ],
    );
  }
  Widget buildProfession() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.profession".tr().toString(),
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
        BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
            builder: (context, state) {
          if (state is GetLookUpListSuccessState ||
              state is GetLookUpListLoadingState ||
              state is GetLookUpListListErrorState) {
            PROFESSION = [Item('', '', '')];
            if (state is GetLookUpListSuccessState) {
              PROFESSION = [];
              for (var obj in state.data[2]['value']['data']) {
                PROFESSION.add(Item(obj['key'], obj['value'].toString(),
                    obj['valueAr'].toString()));
              }
            }

            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptyProfession == true
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
                      value: profession,
                      onChanged: (String newValue) {
                        setState(() {
                          profession = newValue;
                        });
                      },
                      items: PROFESSION.map((valueItem) {
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
      ],
    );
  }
  Widget buildLevelOfEducation() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.level_of_education".tr().toString(),
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
        BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
            builder: (context, state) {
          if (state is GetLookUpListSuccessState ||
              state is GetLookUpListLoadingState ||
              state is GetLookUpListListErrorState) {
            EDUCATION = [Item('', '', '')];
            if (state is GetLookUpListSuccessState) {
              EDUCATION = [];
              for (var obj in state.data[3]['value']['data']) {
                EDUCATION.add(Item(obj['key'], obj['value'].toString(),
                    obj['valueAr'].toString()));
              }
            }
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptyEducation == true
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
                      value: education,
                      onChanged: (String newValue) {
                        setState(() {
                          education = newValue;
                        });
                      },
                      items: EDUCATION.map((valueItem) {
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
      ],
    );
  }
  Widget buildMaritalStatus() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.marital_status".tr().toString(),
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
        BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
            builder: (context, state) {
          if (state is GetLookUpListSuccessState ||
              state is GetLookUpListLoadingState ||
              state is GetLookUpListListErrorState) {
            MARITAL_STATUS = [Item('', '', '')];
            if (state is GetLookUpListSuccessState) {
              MARITAL_STATUS = [];
              for (var obj in state.data[4]['value']['data']) {
                MARITAL_STATUS.add(Item(obj['key'], obj['value'].toString(),
                    obj['valueAr'].toString()));
              }
            }
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptyMaterialStatus == true
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
                      value: marital_status,
                      onChanged: (String newValue) {
                        setState(() {
                          marital_status = newValue;
                        });
                      },
                      items: MARITAL_STATUS.map((valueItem) {
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
      ],
    );
  }
  Widget buildGifts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.gifts".tr().toString(),
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
        BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
            builder: (context, state) {
          if (state is GetLookUpListSuccessState ||
              state is GetLookUpListInitState ||
              state is GetLookUpListListErrorState) {
            GIFTS = [Item('', '', '')];
            if (state is GetLookUpListSuccessState) {
              GIFTS = [];
              for (var obj in state.data[7]['value']['data']) {
                GIFTS.add(Item(obj['key'], obj['value'].toString(),
                    obj['valueAr'].toString()));
              }
            }
            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptyGifts == true
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
                      value: gift,
                      onChanged: (String newValue) {
                        setState(() {
                          gift = newValue;
                        });
                      },
                      items: GIFTS.map((valueItem) {
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
      ],
    );
  }
  Widget buildPreferredLanguage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.preferred_language".tr().toString(),
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
        BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
            builder: (context, state) {
          if (state is GetLookUpListSuccessState ||
              state is GetLookUpListInitState ||
              state is GetLookUpListListErrorState) {
            LANGUAGE = [Item('', '', '')];
            if (state is GetLookUpListSuccessState) {
              LANGUAGE = [];
              for (var obj in state.data[5]['value']['data']) {
                LANGUAGE.add(Item(obj['key'], obj['value'].toString(),
                    obj['valueAr'].toString()));
              }
            }

            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptyLanguage == true
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
                      value: language,
                      onChanged: (String newValue) {
                        setState(() {
                          language = newValue;
                        });
                      },
                      items: LANGUAGE.map((valueItem) {
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
      ],
    );
  }
  Widget buildPreferredModeOfCommunication() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text:
                "Profile_Form.preferred_mode_of_communication".tr().toString(),
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
        BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
            builder: (context, state) {
          if (state is GetLookUpListSuccessState ||
              state is GetLookUpListInitState ||
              state is GetLookUpListListErrorState) {
            COMTYPE = [Item('', '', '')];
            if (state is GetLookUpListSuccessState) {
              COMTYPE = [];
              for (var obj in state.data[6]['value']['data']) {
                COMTYPE.add(Item(obj['key'], obj['value'].toString(),
                    obj['valueAr'].toString()));
              }
            }

            return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    //color: Color(0xFFB10000), red color
                    color: emptypreferredComunication == true
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
                      value: comtype,
                      onChanged: (String newValue) {
                        setState(() {
                          comtype = newValue;
                        });
                      },
                      items: COMTYPE.map((valueItem) {
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
      ],
    );
  }
  Widget buildEmail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.email".tr().toString(),
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
          child: Container(
            child: TextField(
              controller: email,
              keyboardType: TextInputType.emailAddress,
              style: TextStyle(color: Color(0xFF11120e)),
              decoration: InputDecoration(
                enabledBorder: emptyEmail == true
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
                hintText: "Personal_Info_Edit.enter_email".tr().toString(),
                hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDateOfBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Profile_Form.date_of_birth".tr().toString(),
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
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyDay == true
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
                    hintText: "Personal_Info_Edit.dd".tr().toString(),
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
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMonth == true
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
                    hintText: "Personal_Info_Edit.mm".tr().toString(),
                    hintStyle:
                        TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width: 160,
                child: TextField(
                  controller: year,
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyYear == true
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
                    hintText: "Personal_Info_Edit.yyyy".tr().toString(),
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
    );
  }
  final msg = BlocBuilder<SaveProfileInfoBloc, SaveProfileInfoState>(builder: (context, state) {
    if (state is SaveProfileInfoLoadingState   ) {
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
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      showAlertDialog(context, "هل انت متاكد من إغلاق التطبيق",
          "Are you sure to close the application?");
      return true;
    }
    return true;
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
  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
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
            exit(0);
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            "alert.cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        )
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
  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
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
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
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
  @override
  Widget build(BuildContext context) {
    return BlocListener<SaveProfileInfoBloc, SaveProfileInfoState>(
      listener: (context, state) {
        if (state is SaveProfileInfoErrorState) {
          showAlertDialogError(
              context, state.arabicMessage, state.englishMessage);
        }
        if (state is SaveProfileInfoSuccessState) {
          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? state.englishMessage
                  : state.arabicMessage,
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          setState(() {
            MobileNumber1.text = '';
            MobileNumber2.text = '';
            MobileNumber3.text = '';
            FirstName.text = '';
            SecondName.text = '';
            ThirdName.text = '';
            FamilyName.text = '';
            gender = null;
            education = null;
            nationality = null;
            profession = null;
            comtype = null;
            language = null;
            marital_status = null;
            gift = null;
            email.text = '';
            day.text = '';
            month.text = '';
            year.text = '';
          });
        }
      },
      child: WillPopScope(
        onWillPop: onWillPop,
        child: BlocListener<GetLookUpListBloc, GetLookUpListState>(
          listener: (context, state) {
            if (state is GetLookUpListListErrorState) {
              UnotherizedError();
            }
          },
          child: Scaffold(
            appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text(
                  "Profile_Form.profile".tr().toString(),
                ),
                backgroundColor: Color(0xFF4f2565),
                actions: <Widget>[
                  IconButton(
                      icon: Icon(Icons.notifications_none),
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => NotificationsScreen(),
                              ),
                            )
                          }),
                  IconButton(
                      icon: Icon(Icons.settings_outlined),
                      onPressed: () => {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => SettingsScreen(),
                              ),
                            )
                          }),
                  LogoutButton()
                ]),
            backgroundColor: Color(0xFFEBECF1),
            body: Container(
              child: RefreshIndicator(
                color: Color(0xFF4f2565),
                onRefresh: () async {
                  getLookUpListBloc.add(GetLookUpListFetchEvent());
                  this.setState(() {});
                },
                child: ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          color: Color(0xFFEBECF1),
                          padding: EdgeInsets.only(
                              left: 16, right: 10, top: 8, bottom: 15),
                          child: Text(
                            "Profile_Form.basic_information".tr().toString(),
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
                                    height: 20,
                                  ),
                                  buildMobileNumber(),
                                  SizedBox(height: 20),
                                  buildMobileNumber1(),
                                  emptyMobileNumber1
                                      ? ReusableRequiredText(
                                          text:
                                              "Basic_Info_Edit.this_feild_is_required"
                                                  .tr()
                                                  .toString())
                                      : Container(),
                                  SizedBox(height: 20),
                                  buildMobileNumber2(),
                                  SizedBox(height: 25),
                                  buildMobileNumber3(),
                                  SizedBox(height: 25),
                                  buildFirstName(),
                                  emptyFirstName
                                      ? ReusableRequiredText(
                                          text:
                                              "Basic_Info_Edit.this_feild_is_required"
                                                  .tr()
                                                  .toString())
                                      : Container(),
                                  SizedBox(height: 25),
                                  buildSecondName(),
                                  SizedBox(height: 25),
                                  buildThirdName(),
                                  SizedBox(height: 25),
                                  buildFamilyName(),
                                  emptyFamilyName
                                      ? ReusableRequiredText(
                                          text:
                                              "Basic_Info_Edit.this_feild_is_required"
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
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                          color: Color(0xFFEBECF1),
                          padding: EdgeInsets.only(
                              left: 16, right: 10, top: 8, bottom: 15),
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
                            BlocBuilder<GetLookUpListBloc, GetLookUpListState>(
                                builder: (context, state) {
                              if (state is GetLookUpListInitState ||
                                  state is GetLookUpListLoadingState) {
                                return Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 10,
                                      ),
                                      CircularProgressIndicator(
                                        valueColor:
                                            AlwaysStoppedAnimation<Color>(
                                                Color(0xFF4f2565)),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                    ]);
                                //return DotsIndicator(
                                // dotsCount: 5,
                                // position: 0.0,
                                // decorator: DotsDecorator(
                                //color: Colors.grey, // Inactive color
                                //activeColor: Color(0xFF4f2565),
                                // ),
                                //);
                              } else {
                                return Container(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    children: <Widget>[
                                      SizedBox(height: 20),
                                      buildGender(),
                                      emptyGender == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      SizedBox(height: 20),
                                      buildNationality(),
                                      emptyNationality == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      SizedBox(height: 20),
                                      buildProfession(),
                                      emptyProfession == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      SizedBox(height: 20),
                                      buildLevelOfEducation(),
                                      emptyEducation == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      SizedBox(height: 20),
                                      buildMaritalStatus(),
                                      emptyMaterialStatus == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      SizedBox(height: 20),
                                      buildPreferredLanguage(),
                                      emptyLanguage == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      SizedBox(height: 20),
                                      buildPreferredModeOfCommunication(),
                                      emptypreferredComunication == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      buildGifts(),
                                      emptyGifts == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      SizedBox(height: 20),
                                      buildEmail(),
                                      emptyEmail == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                      SizedBox(height: 20),
                                      buildDateOfBirth(),
                                      emptyDay == true ||
                                              emptyMonth == true ||
                                              emptyYear == true
                                          ? ReusableRequiredText(
                                              text:
                                                  "Basic_Info_Edit.this_feild_is_required"
                                                      .tr()
                                                      .toString())
                                          : Container(),
                                    ],
                                  ),
                                );
                              }
                            }),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      msg,
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
                            backgroundColor:Color(0xFF4f2565),
                            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                          ),
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (MobileNumber1.text == '') {
                              setState(() {
                                emptyMobileNumber1 = true;
                              });
                            }
                            if (MobileNumber1.text != '') {
                              setState(() {
                                emptyMobileNumber1 = false;
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
                            if (FamilyName.text == '') {
                              setState(() {
                                emptyFamilyName = true;
                              });
                            }
                            if (FamilyName.text != '') {
                              setState(() {
                                emptyFamilyName = false;
                              });
                            }
                            if (gender == null) {
                              setState(() {
                                emptyGender = true;
                              });
                            }
                            if (gender != null) {
                              setState(() {
                                emptyGender = false;
                              });
                            }
                            if (nationality == null) {
                              setState(() {
                                emptyNationality = true;
                              });
                            }
                            if (nationality != null) {
                              setState(() {
                                emptyNationality = false;
                              });
                            }
                            if (profession == null) {
                              setState(() {
                                emptyProfession = true;
                              });
                            }
                            if (profession != null) {
                              setState(() {
                                emptyProfession = false;
                              });
                            }
                            if (education == null) {
                              setState(() {
                                emptyEducation = true;
                              });
                            }
                            if (education != null) {
                              setState(() {
                                emptyEducation = false;
                              });
                            }
                            if (marital_status == null) {
                              setState(() {
                                emptyMaterialStatus = true;
                              });
                            }
                            if (marital_status != null) {
                              setState(() {
                                emptyMaterialStatus = false;
                              });
                            }
                            if (language == null) {
                              setState(() {
                                emptyLanguage = true;
                              });
                            }
                            if (language != null) {
                              setState(() {
                                emptyLanguage = false;
                              });
                            }
                            if (comtype == null) {
                              setState(() {
                                emptypreferredComunication = true;
                              });
                            }
                            if (comtype != null) {
                              setState(() {
                                emptypreferredComunication = false;
                              });
                            }
                            if (gift == null) {
                              setState(() {
                                emptyGifts = true;
                              });
                            }
                            if (gift != null) {
                              setState(() {
                                emptyGifts = false;
                              });
                            }
                            if (email.text == '') {
                              setState(() {
                                emptyEmail = true;
                              });
                            }
                            if (email.text != '' ) {
                              setState(() {
                                emptyEmail = false;
                              });
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
                            if (month.text == '' ) {
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
                            }
                            if (gender != '' &&
                                nationality != '' &&
                                profession != '' &&
                                language != '' &&
                                comtype != '' &&
                                marital_status != '' &&
                                education != '' &&
                                gift != '' &&
                                email.text != '' &&
                                day.text != '' &&
                                month.text != '' &&
                                year.text != '' &&
                                FamilyName.text != '' &&
                                MobileNumber1.text != '' &&
                                FirstName.text != '') {
                              saveProfileInfoBloc
                                  .add(SaveProfileInfoButtonPressed(
                                gender: gender,
                                nationality: nationality,
                                profession: profession,
                                language: language,
                                comtype: comtype,
                                marital_status: marital_status,
                                education: education,
                                gift: gift,
                                email: email.text,
                                day: day.text,
                                month: month.text,
                                year: year.text,
                                MobileNumber: MobileNumber.text,
                                MobileNumber1: MobileNumber1.text,
                                MobileNumber2: MobileNumber2.text,
                                MobileNumber3: MobileNumber3.text,
                                FirstName: FirstName.text,
                                SecondName: SecondName.text,
                                ThirdName: ThirdName.text,
                                FamilytName: FamilyName.text,
                              ));
                            }
                          },


                          child: Text(
                            "Basic_Info_Edit.save_changes".tr().toString(),
                            style: TextStyle(
                                color: Colors.white,
                                letterSpacing: 0,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                    ]),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
