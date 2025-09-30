import 'dart:io';

import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/Notifications/Notifications_bloc.dart';
import 'package:sales_app/blocs/Notifications/Notifications_events.dart';
import 'package:sales_app/blocs/Notifications/Notifications_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

// class NotificationsScreen extends StatefulWidget {
//   //const NotificationsScreen({Key? key}) : super(key: key);
//   @override
//   _NotificationsScreenState createState() => _NotificationsScreenState();
// }
class NotificationsScreen extends StatelessWidget {
  final List<dynamic> Permessions ;
  var role;
  var  outDoorUserName;
  GetNotificationsListBloc getNotificationsListBloc;

  NotificationsScreen({this.Permessions,this.role,this.outDoorUserName}) ;

  // @override
  // void initState() {
  //   getNotificationsListBloc = BlocProvider.of<GetNotificationsListBloc>(context);
  //   getNotificationsListBloc.add(GetNotificationsListFetchEvent());
  //   super.initState();
  // }
  //
  // @override
  // void dispose(){
  //   getNotificationsListBloc.close();
  //
  //   super.dispose();
  // }


  @override
  Widget build(BuildContext context) {

    getNotificationsListBloc = BlocProvider.of<GetNotificationsListBloc>(context);
    getNotificationsListBloc.add(GetNotificationsListFetchEvent());
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
          TextButton(
            onPressed: ()  {
              //   logoutBloc.add(LogoutButtonPressed(
              //   ));
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
    UnotherizedError() async {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setBool('is_logged_in', false);
      prefs.setBool('biomitric_is_logged_in', false);
      prefs.setBool('TokenError', true);
      prefs.remove("accessToken");
      ////prefs.remove("userName");
      prefs.remove('counter');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => SignInScreen(),
        ),
      );
    }
    return BlocListener<GetNotificationsListBloc,GetNotificationsListState>(
      listener: (context, state) {
        if (state is GetNotificationsListErrorState) {
          showAlertDialog(context, state.arabicMessage, state.englishMessage);

          }
        else if(state is GetNotificationsListTokenErrorState )
          {UnotherizedError();
          }
      },
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
            title: Text(
              "Notifications_Form.notifications".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: 8),
              children: <Widget>[

                BlocBuilder<GetNotificationsListBloc,GetNotificationsListState>(
                    builder: (context,state){
                      // ignore: missing_return
                      if(state is GetNotificationsListLoadingState){
                        return Container();
                      }else if(state is GetNotificationsListInitState){
                        return Container();
                      }
                      else if(state is GetNotificationsListSuccessState){
                        return ListView.builder(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount : state.data.length,
                            itemBuilder:(context,index){
                              return Container(
                                child: Column(
                                    children:[
                                      Card (
                                        elevation:0,
                                        child:
                                       ListTile(
                                          title: Text(
                                        state.data[index]['title'],
                                        style: TextStyle(
                                            fontSize: 18,
                                            color: Color(0xff11120e),
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.right,
                                      ),
                                      subtitle: Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Text(
                                          state.data[index]['summary'],
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0xff11120e),
                                              fontWeight: FontWeight.normal)

                                          ,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),),
                                    ]
                                ),


                              );}
                        );

                      }
                      else{
                      }return Container();
                    }

                ),
              ])),
    );
  }
}




