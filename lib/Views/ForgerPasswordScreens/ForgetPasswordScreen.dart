import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sales_app/Animation/FadeAnimation.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/erroreLabel.dart';
import 'package:sales_app/Views/ReusableComponents/headerSection.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/ForgetPassword/forgetPasssword_bloc.dart';
import 'package:sales_app/blocs/ForgetPassword/forgetPasssword_events.dart';
import 'package:sales_app/blocs/ForgetPassword/forgetPasssword_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgetPassword extends StatefulWidget {
  String userName;
  String userType;
  @override
  ForgetPassword(this.userName,this.userType);
  _ForgetPassword createState() => _ForgetPassword(this.userName,this.userType);

}

class Item {
  const Item(this.value, this.text);
  final String value;
  final String text;
}

List<Item> users = <Item>[
  const Item('4', "subdealer"),
  const Item('3', "corporate"),
];
class _ForgetPassword extends State<ForgetPassword> {
  String userName;
  String userType;
  bool userTypeEmptyFlag = false;
  bool userNameEmptyFlag = false;
  TextEditingController tawasol_number = TextEditingController();
  _ForgetPassword(this.userName, this.userType);
  ForgetPasswordBloc forgetPasswordBloc;
  @override
  void initState() {
    forgetPasswordBloc = BlocProvider.of<ForgetPasswordBloc>(context);
    if(userName!=null){
      tawasol_number.text=userName;
    }
    super.initState();
    /* if(userType!=null && userType=='4'){
      userType='4';
    }else if(userType!=null && userType=='3'){
      userType='3';
    }*/

    print('forget password');
    print(userType);
    print(userName);
  }
  // ignore: missing_retur
  final msg = BlocBuilder<ForgetPasswordBloc, ForgetPasswordState>(builder: (context, state) {
    if (state is ForgetPasswordLoadingState) {
      return Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF348A98)),
            ),
          ));
    } else {
      return Container();
    }
  });
  Widget buildUserNameError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color:  Color(0xFF9C0101),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Color(0xFFFF0000),

                width: 1,
              )),
          height: 30,
          child: ErroreLabel(
              text: "Login_Form.userName_required"
                  .tr()
                  .toString()),
        )
      ],
    );
  }
  Widget buildUserName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Forget_password_Form.tawasol_number".tr().toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color:  userNameEmptyFlag ?  Color(0xFFB10000).withOpacity(0.1)  :Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: userNameEmptyFlag ?  Color(0xFFaf9090) : Colors.white,
                width:  userNameEmptyFlag ?  1: 0,
              )
          ),
          height: 58,
          child: TextField(
            controller: tawasol_number,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,
            inputFormatters: [
              FilteringTextInputFormatter.deny(RegExp('[a-z A-Z á-ú Á-Ú]')),
            ],
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "Login_Form.userName".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFF99B7C3), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }
  Widget buildUserType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Login_Form.user_type".tr().toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: userTypeEmptyFlag
                ? Color(0xFFB10000).withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: userTypeEmptyFlag
                  ? Color(0xFFaf9090)
                  : Colors.white.withOpacity(0.1),
              width: userTypeEmptyFlag ? 1 : 0,
            ),
          ),
          height: 58,

          child: Container(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child:DropdownButton<String>(
                    hint: Text(
                      "Login_Form.select_userType".tr().toString(),
                      style: TextStyle(
                        color: Color(0xFF99B7C3),
                        fontSize: 14,
                      ),
                    ),
                    dropdownColor: Color(0xFF1f5f7b),
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    iconSize: 30,
                    iconEnabledColor: Colors.white,
                    underline: SizedBox(),
                    isExpanded: true,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                    ),
                    items:[
                      DropdownMenuItem(
                        child: Text( "Login_Form.subdealer".tr().toString(),),
                        value: '4',
                      ),
                      DropdownMenuItem(
                          child: Text( "Login_Form.corporate".tr().toString(),),
                          value: '3'
                      ),
                      DropdownMenuItem(
                        child: Text( "Login_Form.outdoor".tr().toString(),),
                        value: '2',
                      ),
                    ],
                    onChanged: (String value) {
                      setState(() {
                        userType  = value;
                      });
                    },

                    value: userType,

                  ),
                ),
              )
          ),
        ),
      ],
    );
  }

  Widget buildSubmitBtn() {
    return Column(
        children :[
          Container(
            height: 48,
            width:400,
            margin: EdgeInsets.symmetric(horizontal: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50), color: Colors.white),
            child: TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
              ),
              onPressed: () {
                if(tawasol_number.text=='')
                {setState(() {
                  userNameEmptyFlag=true;
                });}
                /* if(userType==null){
                  setState(() {
                    userTypeEmptyFlag = true;
                  });
                }*/
                if(tawasol_number.text!='')
                {setState(() {
                  userNameEmptyFlag=false;
                });}
                /*if(userType!=null){
                  setState(() {
                    userTypeEmptyFlag = false;
                  });
                }*/

                var tawasolNumberLeft =tawasol_number.text.trimLeft();
                var TawasolNumberRight =tawasolNumberLeft.trimRight();
                // Navigator.pushNamed(context, '/ForgetPasswordSuccess');
                if (tawasol_number.text!='' ) {
                  forgetPasswordBloc.add(SubmitButtonPressed(
                      userName: TawasolNumberRight,
                      userType: "0"
                  ),);
                }
              },

              child: Text(
                "Forget_password_Form.submit".tr().toString(),
                style: TextStyle(
                    color: Color(0xFF4f2565),
                    letterSpacing: 0,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),]
    );
  }
  showAlertDialog(BuildContext context,arabicMessage,englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text("alert.tryAgain".tr().toString() ,
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
      content: Text(EasyLocalization.of(context).locale == Locale("en", "US") ? englishMessage : arabicMessage,
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
  //
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
        listener: (context, state) {
          if(state is ForgetPasswordErrorState ) {
            showAlertDialog(context,state.arabicMessage,state.englishMessage);
          }
          if (state is ForgetPasswordSuccessState) {
            Navigator.pushNamed(context, '/ForgetPasswordSuccess');
          }
        },
        child: Scaffold(
          body: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xFF008388), Color(0xFF4f2565)],
              ),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 40, //*
                ),
                HeaderSection(text:"Login_Form.language".tr().toString(),),
                SizedBox(
                  height: 30,
                ),
                Center(
                  child: Image(image:
                  AssetImage('assets/images/ForgetPassword.png'),
                      width: 184,
                      height: 184
                  ),),
                Container(
                  padding:EdgeInsets.all(25),
                  alignment: EasyLocalization.of(context).locale == Locale("en", "US") ? Alignment.centerLeft :Alignment.centerRight,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:[
                        Center(
                          child:  Text(
                            "Forget_password_Form.reset_password".tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold),
                          ),
                        ),

                        SizedBox(
                          height: 16,
                        ),
                        Center(
                          child: Text(
                            "Forget_password_Form.reset_password_message".tr().toString(),
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white, fontSize: 14,),
                          ),
                        ),

                      ]
                  ),
                ),
                Expanded(
                  child: Container(
                    padding:EdgeInsets.only(top:30,left:25,right:25),
                    child: SingleChildScrollView(
                      child: Column(
                        children: <Widget>[
                          Container(
                            child: Column(
                              children: <Widget>[
                                /* buildUserType()
                                  SizedBox(height: 10),
                                  userTypeEmptyFlag==true ? ReusableRequiredText(text: "Login_Form.userType_required".tr().toString()): Container(),
                                  SizedBox(height: 30),*/
                                buildUserName(),
                                SizedBox(height: 10),
                                userNameEmptyFlag == true ?buildUserNameError() : Container() ,
                                SizedBox(height: 30),
                              ],
                            ),
                          ),

                          msg,
                          buildSubmitBtn(),
                          SizedBox(height: 15,),
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                GestureDetector(
                                  onTap: ()   async {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => SignInScreen(),
                                      ),
                                    );
                                  },
                                  child: new Text(
                                    "alert.cancel".tr().toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),

                              ]
                          ),

                        ],
                      ),

                    ),
                  ),
                ),
                /*  Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      onTap: ()   async {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SignInScreen(),
                          ),
                        );
                      },
                      child: new Text(
                        "alert.cancel".tr().toString(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),

                  ],
                ),*/


              ],
            ),
          ),
        ));
  }
}
