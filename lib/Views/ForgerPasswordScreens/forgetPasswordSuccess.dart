import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:sales_app/Animation/FadeAnimation.dart';
import 'package:sales_app/Views/ReusableComponents/headerSection.dart';
import 'package:sales_app/blocs/ForgetPassword/forgetPasssword_bloc.dart';
import 'package:sales_app/blocs/ForgetPassword/forgetPasssword_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../LoginScreens/SignInScreen.dart';
class ForgetPasswordSuccess extends StatefulWidget {
  @override
  _ForgetPasswordSuccess createState() => _ForgetPasswordSuccess();
}

class _ForgetPasswordSuccess extends State<ForgetPasswordSuccess> {

  @override
  void initState() {
    super.initState();
  }
  // ignore: missing_retur
  @override
  Widget build(BuildContext context) {
    return BlocListener<ForgetPasswordBloc, ForgetPasswordState>(
        // listener: (context, state) {
        //   if(state is ForgetPasswordErrorState ) {
        //     showAlertDialog(context,state.arabicMessage,state.englishMessage);
        //   }
        //   if (state is ForgetPasswordSuccessState) {
        //     Navigator.pushNamed(context, '/SubdealerHome');
        //   }
        // },
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 40, //*
                ),
                HeaderSection(text:"Login_Form.language".tr().toString(),),
                Container(
                  padding:EdgeInsets.all(25),
                  child:  Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children:[
                        Text(
                          "Forget_password_Form_success.reset_password_success_message".tr().toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white, fontSize: 24,fontWeight: FontWeight.bold, ),
                        ),
                        SizedBox(
                          height: 40,
                        ),

                        Image(image:
                        AssetImage('assets/images/icon-sent.png'),
                            width:184,
                            height:184
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("Forget_password_Form_success.reset_password_success_message2".tr().toString(),
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.white, fontSize: 16,),
                            ),

                            RichText(
                              text: TextSpan(
                                children: <TextSpan>[
                                  TextSpan(
                                    text:  "  " + "Login_Form.registration".tr().toString(),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(builder: (context) => SignInScreen()),
                                        );
                                      },
                                    style: TextStyle(fontSize: 16, color: Colors.white,fontWeight: FontWeight.bold),)
                                ],
                              ),
                            ),

                          ],
                        )

                      ]
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}
