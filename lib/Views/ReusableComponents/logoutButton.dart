
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/Login/logout_bloc.dart';
import 'package:sales_app/blocs/Login/logout_events.dart';
import 'package:sales_app/blocs/Login/logout_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math' as math;
class LogoutButton  extends StatefulWidget {
  @override
  _LogoutButtonState createState() => _LogoutButtonState();
}
class _LogoutButtonState  extends State<LogoutButton> {
  LogoutBloc logoutBloc;
  void initState() {
    logoutBloc = BlocProvider.of<LogoutBloc>(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return
      BlocListener <LogoutBloc, LogoutState>(
        listener: (context, state) {
          if (state is LogoutSuccessState) {
            Navigator.pushAndRemoveUntil<void>(
              context,
              MaterialPageRoute<void>(builder: (context) => SignInScreen()),
              ModalRoute.withName('/SignInScreen'),
            );
          }
        },
       child: Transform.rotate(
         angle: EasyLocalization.of(context).locale == Locale("en", "US") ? 180 * math.pi / 1 :180 * math.pi / 180,
         child: IconButton(
              icon: Icon(Icons.logout),
              onPressed: ()  {
                showDialog(
                    context: context,
                    builder: (_) =>
                        AlertDialog(
                          content: Text(
                            "alert.content_logout_alart".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                            ),
                          ),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                              child: Text(
                                "alert.cancel".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xFF4f2565),
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: ()  {
                                logoutBloc.add(LogoutButtonPressed());
                              },
                              child: Text(
                                "alert.logout".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xFF4f2565),
                                  fontSize: 14,
                                ),
                              ),
                            ),

                          ],
                        ));
              }),
       ),
     );

  }
  }