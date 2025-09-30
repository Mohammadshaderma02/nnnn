import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/CustomBottomNavigationBar.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Profile/Profile.dart';

import 'Profile.dart';
class PersonalInformationEdit extends StatefulWidget {
  @override
  _PersonalInformationEditState createState() => _PersonalInformationEditState();
}
class Item {
  const Item(this.value, this.text);
  final String value;
  final String text;
}

List<Item> users = <Item>[
  const Item('1', "subdealer"),
  const Item('3', "corporate"),
];
class _PersonalInformationEditState extends State<PersonalInformationEdit> {
  TextEditingController old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();
  Item userType;

  Widget buildGender() {
    return Column(
        crossAxisAlignment : CrossAxisAlignment.start,
        children: <Widget> [
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
          Container(
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  //color: Color(0xFFB10000), red color
                  color:Colors.grey,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<Item>(
                    hint: Text(
                      "Personal_Info_Edit.select_an_option".tr().toString(),
                      style: TextStyle(
                        color: Colors.grey,
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
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                    value: userType,
                    onChanged: (Item newValue) {
                      setState(() {
                        userType = newValue;
                      });
                    },
                    items: users.map((valueItem) {
                      return DropdownMenuItem<Item>(
                        value: valueItem,
                        child: Text(valueItem.text),
                      );
                    }).toList(),
                  ),
                ),
              )
          ),
          SizedBox(height: 10),
        ]
    );
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
        Container(
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color:Colors.grey,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<Item>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Colors.grey,
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
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  value: userType,
                  onChanged: (Item newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                  items: users.map((valueItem) {
                    return DropdownMenuItem<Item>(
                      value: valueItem,
                      child: Text(valueItem.text),
                    );
                  }).toList(),
                ),
              ),
            )
        ),
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
        Container(
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color:Colors.grey,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<Item>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Colors.grey,
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
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  value: userType,
                  onChanged: (Item newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                  items: users.map((valueItem) {
                    return DropdownMenuItem<Item>(
                      value: valueItem,
                      child: Text(valueItem.text),
                    );
                  }).toList(),
                ),
              ),
            )
        ),
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
        Container(
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color:Colors.grey,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<Item>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Colors.grey,
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
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  value: userType,
                  onChanged: (Item newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                  items: users.map((valueItem) {
                    return DropdownMenuItem<Item>(
                      value: valueItem,
                      child: Text(valueItem.text),
                    );
                  }).toList(),
                ),
              ),
            )
        ),
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
        Container(
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color:Colors.grey,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<Item>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Colors.grey,
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
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  value: userType,
                  onChanged: (Item newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                  items: users.map((valueItem) {
                    return DropdownMenuItem<Item>(
                      value: valueItem,
                      child: Text(valueItem.text),
                    );
                  }).toList(),
                ),
              ),
            )
        ),
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
        Container(
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color:Colors.grey,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<Item>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Colors.grey,
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
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  value: userType,
                  onChanged: (Item newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                  items: users.map((valueItem) {
                    return DropdownMenuItem<Item>(
                      value: valueItem,
                      child: Text(valueItem.text),
                    );
                  }).toList(),
                ),
              ),
            )
        ),
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
        Container(
            decoration: BoxDecoration(
              color:Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color:Colors.grey,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<Item>(
                  hint: Text(
                    "Personal_Info_Edit.select_an_option".tr().toString(),
                    style: TextStyle(
                      color: Colors.grey,
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
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                  value: userType,
                  onChanged: (Item newValue) {
                    setState(() {
                      userType = newValue;
                    });
                  },
                  items: users.map((valueItem) {
                    return DropdownMenuItem<Item>(
                      value: valueItem,
                      child: Text(valueItem.text),
                    );
                  }).toList(),
                ),
              ),
            )
        ),
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
          child:Container(
            child:TextField(
              controller: confirm_password,
              keyboardType: TextInputType.name,
              style: TextStyle(color: Colors.grey),
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderSide: const BorderSide(color: Colors.grey, width: 1.0)
                  ,
                ),
                focusedBorder:OutlineInputBorder(
                  borderSide: const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                ),
                contentPadding: EdgeInsets.all(16),
                hintText: "Personal_Info_Edit.enter_email".tr().toString(),
                hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
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
          child:Row(
            children: [
              Container(
                width:90,
                child: TextField(
                  controller: old_password,
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    hintText: "Personal_Info_Edit.dd".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width:90,
                child: TextField(
                  controller: old_password,
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    hintText: "Personal_Info_Edit.mm".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              Spacer(),
              Container(
                width:160,
                child: TextField(
                  controller: old_password,
                  keyboardType: TextInputType.datetime,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
                    ),
                    focusedBorder:OutlineInputBorder(
                      borderSide: const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                    ),
                    contentPadding: EdgeInsets.all(16),
                    hintText: "Personal_Info_Edit.yyyy".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          //tooltip: 'Menu Icon',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Profile(),
              ),
            );
          },
        ),
        centerTitle:false,
        title: Text(
          "Profile_Form.basic_information".tr().toString(),
        ),
        backgroundColor: Color(0xFF4f2565),
      ),
      backgroundColor: Color(0xFFEBECF1),
      body: ListView(
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
                    buildGender(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,
                    SizedBox(height: 20),
                    buildNationality(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,
                    SizedBox(height: 20),
                    buildProfession(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,
                    SizedBox(height: 20),
                    buildLevelOfEducation(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,
                    SizedBox(height: 20),
                    buildMaritalStatus(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,
                    SizedBox(height: 20),
                    buildPreferredLanguage(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,
                    SizedBox(height: 20),
                    buildPreferredModeOfCommunication(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,
                    SizedBox(height: 20),
                    buildEmail(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,
                    SizedBox(height: 20),
                    buildDateOfBirth(),
                    ReusableRequiredText(text: "Basic_Info_Edit.this_feild_is_required"
                        .tr()
                        .toString()) ,


                  ],
                ),
              ),

            ],
          ),

        ),
        SizedBox(height: 20),
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
            onPressed: (){
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
    );
  }
}