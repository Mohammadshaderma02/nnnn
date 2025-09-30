import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Settings/Settings.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sales_app/blocs/ChangePassword/changePassword_bloc.dart';
import 'package:sales_app/blocs/ChangePassword/changePassword_events.dart';
import 'package:sales_app/blocs/ChangePassword/changePassword_state.dart';

import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangePassword extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;

  ChangePassword(this.PermessionCorporate, this.role);
  @override
  _ChangePasswordState createState() => _ChangePasswordState(
      this.PermessionCorporate, this.role);
}

class _ChangePasswordState extends State<ChangePassword> {
  bool serchByEmptyFlag = false;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;


  TextEditingController tawasol_number = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();

  _ChangePasswordState(
      this.PermessionCorporate, this.role);
  int selectedLanguage = 2;
  bool showPassword = true;
  bool showConfirmPassword = true;
  bool emptyOldPassword = false;
  bool emptyNewPassword = false;
  bool emptyConfirmPassword = false;

  FocusNode passwordFocusNode;
  FocusNode confirmPasswordFocusNode;
  TextEditingController old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();

  ChangePasswordBloc changePasswordBloc;
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

  @override
  void initState() {

    print(role);
    changePasswordBloc = BlocProvider.of<ChangePasswordBloc>(context);

    super.initState();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }

  final msg = BlocBuilder<ChangePasswordBloc, ChangePasswordState>(
      builder: (context, state) {
    if (state is ChangePasswordLoadingState) {
      return Center(
          child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF392156)),
        ),
      ));
    } else {
      return Container();
    }
  });

  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }

  Widget buildOldPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Settings_Form.old_password".tr().toString(),
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
            controller: old_password,
            focusNode: passwordFocusNode,
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(passwordFocusNode);
              });
            },
            obscureText: showPassword,
            //  textInputAction: TextInputAction.next,
          //  keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

           // keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder: emptyOldPassword == true
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
                    icon: new Image.asset(showPassword == true
                        ? "assets/images/icon-show.png"
                        : "assets/images/icon-hide.png"),
                    onPressed: () => setState(() {
                          showPassword = !showPassword;
                        })),
              ),
              hintText: "Settings_Form.enter_old_password".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildNewPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Settings_Form.new_password".tr().toString(),
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
            controller: new_password,
            obscureText: true,
           // keyboardType: TextInputType.name,
           // keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              enabledBorder: emptyNewPassword == true
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
              hintText: "Settings_Form.enter_new_password".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildConfirmPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Settings_Form.confirm_new_password".tr().toString(),
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
            controller: confirm_password,
            obscureText: true,
           // keyboardType: TextInputType.name,
           // keyboardType: TextInputType.numberWithOptions(signed: true, decimal: true),

            style: TextStyle(color: Colors.grey),
            decoration: InputDecoration(
              enabledBorder: emptyConfirmPassword == true
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
              hintText: "Settings_Form.enter_new_password".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildCancelButton() {
    return Container(
      height: 48,
      width: 140,
      //margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFF0E9E9E9),
      ),
      child: TextButton(
        onPressed: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();

          role=="Corporate" ?
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CorpNavigationBar(
                PermessionCorporate: prefs.getStringList('PermessionCorporate'),
                role: prefs.getString('role'),

              ),
            ),
          ):   Navigator.of(context).pop();

        },
        style: TextButton.styleFrom(
          backgroundColor: Color(0xFFE9E9E9),
          shape: const BeveledRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
        child: Text(
          "corpMenu.cancel".tr().toString(),
          style: TextStyle(
              color: Color(0xFF343434),
              letterSpacing: 0,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
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
        tryAgainButton,
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
    return BlocListener<ChangePasswordBloc, ChangePasswordState>(
        listener: (context, state) {
          if (state is ChangePasswordErrorState) {
            showAlertDialog(context, state.arabicMessage, state.englishMessage);
          }
          if (state is ChangePasswordSuccessState) {
            Navigator.pop(context);
            showToast(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Password changed successfully"
                    : "تم تغيير كلمة السر بنجاح",
                context: context,
                animation: StyledToastAnimation.scale,
                fullWidth: true);
          }
        },
        child: WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text("corpMenu.Change_Password".tr().toString()),
              //<Widget>[]
              backgroundColor: Color(0xFF392156),
              leading: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();




                role=="Corporate" ?
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CorpNavigationBar(
                        PermessionCorporate:
                            prefs.getStringList('PermessionCorporate'),
                        role: prefs.getString('role'),

                      ),
                    ),
                  ):   Navigator.of(context).pop();
                },
              ),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: role == "Corporate" || role=="Reseller"
                ? ListView(padding: EdgeInsets.only(top: 10), children: <
                    Widget>[
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
                                buildOldPassword(),
                                emptyOldPassword == true
                                    ? ReusableRequiredText(
                                        text:
                                            "Change_Password.oldPassword_required"
                                                .tr()
                                                .toString())
                                    : Container(),
                                SizedBox(height: 20),
                                buildNewPassword(),
                                emptyNewPassword == true
                                    ? ReusableRequiredText(
                                        text:
                                            "Change_Password.newPassword_required"
                                                .tr()
                                                .toString())
                                    : Container(),
                                confirm_password.text != new_password.text
                                    ? ReusableRequiredText(
                                        text:
                                            "Change_Password.confirmNewPassword_newPassword_not_match"
                                                .tr()
                                                .toString())
                                    : Container(),
                                SizedBox(height: 20),
                                buildConfirmPassword(),
                                emptyConfirmPassword == true
                                    ? ReusableRequiredText(
                                        text:
                                            "Change_Password.confirmNewPassword_required"
                                                .tr()
                                                .toString())
                                    : Container(),
                                SizedBox(height: 10),
                              ],
                            ),
                          ),
                          SizedBox(height: 20),
                          msg,
                          SizedBox(height: 10),
                          Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                buildCancelButton(),
                                Container(
                                  height: 48,
                                  width: 205,
                                 // margin: EdgeInsets.symmetric(horizontal: 10),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(50),
                                    color: Color(0xFF0E7074),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      if (old_password.text == '') {
                                        setState(() {
                                          emptyOldPassword = true;
                                        });
                                      }
                                      if (old_password.text != '') {
                                        setState(() {
                                          emptyOldPassword = false;
                                        });
                                      }
                                      if (new_password.text == '') {
                                        setState(() {
                                          emptyNewPassword = true;
                                        });
                                      }
                                      if (new_password.text != '') {
                                        setState(() {
                                          emptyNewPassword = false;
                                        });
                                      }
                                      if (confirm_password.text == "") {
                                        setState(() {
                                          emptyConfirmPassword = true;
                                        });
                                      }
                                      if (confirm_password.text != "" &&
                                          new_password.text != '' &&
                                          (confirm_password.text !=
                                              new_password.text)) {
                                        setState(() {
                                          emptyConfirmPassword = true;
                                        });
                                      }

                                      if (confirm_password.text != "" &&
                                          (confirm_password.text ==
                                              new_password.text)) {
                                        setState(() {
                                          emptyConfirmPassword = false;
                                        });
                                      }

                                      if (confirm_password.text != "" &&
                                          (confirm_password.text ==
                                              new_password.text) &&
                                          (old_password.text != '')) {
                                        changePasswordBloc.add(
                                          SubmitChangeButtonPressed(
                                              currentPassword:
                                              old_password.text,
                                              newPassword: new_password.text),
                                        );
                                      }
                                    },
                                    style: TextButton.styleFrom(
                                      backgroundColor: Color(0xFF0E7074),
                                      shape: const BeveledRectangleBorder(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(24))),
                                    ),
                                    child: Text(
                                      "Settings_Form.change_password"
                                          .tr()
                                          .toString(),
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



                          SizedBox(height: 20),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    SizedBox(height: 20),
                  ])
                : Container(),
          ),
        ));
  }
}
