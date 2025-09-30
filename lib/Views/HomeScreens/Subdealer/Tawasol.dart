import 'dart:core';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/appBar.dart';
import 'package:sales_app/Views/ReusableComponents/logoutButton.dart';
import 'package:sales_app/blocs/GetTawasolInfo/getTawasoInfo_state.dart';
import 'package:sales_app/blocs/GetTawasolInfo/getTawasolInfo_bloc.dart';
import 'package:sales_app/blocs/GetTawasolInfo/getTawasolInfo_events.dart';
import 'package:sales_app/blocs/GetTawasolList/gerTawasolList_bloc.dart';
import 'package:sales_app/blocs/GetTawasolList/getTawasolList_events.dart';
import 'package:sales_app/blocs/GetTawasolList/getTawasolList_state.dart';
import 'package:sales_app/repository/getTawasolNumber_repo.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Setting/SettingsScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/NotificationsScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class Tawasol extends StatelessWidget{
  GetTawasolInfoBloc getTawasolInfoBloc;
  GetTawasolListBloc getTawasolListBloc;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  Tawasol( {Key key,  @required this.Permessions,this.role,this.outDoorUserName}) : super(key: key);
  DateTime backButtonPressedTime;

  Future getPrefs () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // read
    Permessions = prefs.getStringList('Permessions') ?? [];


  }
  @override
  Widget build(BuildContext context) {
    //getPrefs();
    print('Permessions in tawasol');
    print(Permessions);
    print(role);
    getTawasolInfoBloc = BlocProvider.of<GetTawasolInfoBloc>(context);
    getTawasolListBloc = BlocProvider.of<GetTawasolListBloc>(context);
     if(role=='Subdealer'){
       getTawasolInfoBloc.add(GetTawasolInfoFetchEvent());
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
    Future<bool> onWillPop() async {
      DateTime currentTime = DateTime.now();
      bool backButton = backButtonPressedTime == null ||
          currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
      if (backButton) {
        backButtonPressedTime = currentTime;
        showAlertDialog(context,"هل انت متاكد من إغلاق التطبيق","Are you sure to close the application?");
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
    return BlocListener<GetTawasolInfoBloc,GetTawasolInfoState>(
      listener: (context, state) {
        if (state is GetTawasolInfoTokenErrorState) {
          UnotherizedError();
      } else  if (state is GetTawasolInfoErrorState) {
         showAlertDialog(context, state.arabicMessage, state.englishMessage);}
      },
      child:  WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),

          child: Scaffold(
                appBar: appBarSection(appBar : AppBar(),
                title: Text(
                  "Tawasol_Form.tawasol".tr().toString(),
                ),
                Permessions: Permessions,
                  role: role,
                  outDoorUserName: outDoorUserName,
                ),
                backgroundColor: Color(0xFFEBECF1),
                body:
                RefreshIndicator(
                  color: Color(0xFF4f2565),
                  onRefresh: () async{
                    getTawasolInfoBloc.add(GetTawasolInfoFetchEvent());
                    //getTawasolListBloc.add(GetTawasolListFetchEvent());
                    },
                  child: ListView(
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      padding: EdgeInsets.only(top: 8),
                      children: <Widget>[
                        Permessions.contains('04.01')?Container(
                          padding:
                              EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 15),
                          //margin: EdgeInsets.only(top: 20),
                          child: Text(
                            "Tawasol_Form.general_information".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ):Container(),
                        Permessions.contains('04.01')?BlocBuilder<GetTawasolInfoBloc,GetTawasolInfoState>(
                          builder: (context,state){
                            // ignore: missing_return
                         if(state is GetTawasolInfoSuccessState || state is GetTawasolInfoErrorState || state is GetTawasolInfoLoadingState || state is GetTawasolInfoInitState ){
                           var subdealerTawasolNumber= '';
                           var  subdealerCategorization ='';
                           var channelName ='';
                           var subdealerStatus  ='';
                           var channelCity ='';
                           var channelArea ='';
                           var supervisorName ='';
                           var  subdealerSupervisor='';
                           var managerName  ='';
                           var subdealerManager ='';

                           if(state is GetTawasolInfoSuccessState){
                             getTawasolListBloc.add(GetTawasolListFetchEvent());
                             subdealerTawasolNumber= state.data['data']['tawasol']['subdealerTawasolNumber'];
                             subdealerCategorization= state.data['data']['tawasol']['subdealerCategorization'];
                            subdealerStatus= state.data['data']['tawasol']['subdealerStatus'];
                             channelName=  state.data['data']['channel']['channelName'];
                             channelCity= state.data['data']['channel']['channelCity'];
                             channelArea= state.data['data']['channel']['channelArea'];
                             supervisorName= state.data['data']['tawasol']['supervisorName'];
                            subdealerSupervisor= state.data['data']['tawasol']['subdealerSupervisor'];
                             managerName= state.data['data']['tawasol']['managerName'];
                             subdealerManager= state.data['data']['tawasol']['subdealerManager'];
                             subdealerSupervisor= state.data['data']['tawasol']['subdealerSupervisor'];
                             managerName= state.data['data']['tawasol']['managerName'];
                            }

                            return Container(
                              color: Colors.white,
                              child: Center(
                                child: ListView(
                                    shrinkWrap: true,
                                    physics: ClampingScrollPhysics(),
                                    children: [
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                            width: 160,
                                            child: Text(
                                              "Tawasol_Form.tawasol_number".tr().toString(),
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  color: Color(0xff11120e),
                                                  fontWeight: FontWeight.normal),
                                            ),
                                          ),
                                          title: Text(
                                            subdealerTawasolNumber ,
                                            style: TextStyle(
                                                fontSize: 16,
                                                color: Color(0xff11120e),
                                                fontWeight: FontWeight.normal),
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.category".tr().toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                      subdealerCategorization,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.tawasol_status".tr().toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                            subdealerStatus,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.channel_name".tr().toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                            channelName,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.city".tr().toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                            channelCity,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.area".tr().toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                            channelArea,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.sales_developer".tr().toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                            supervisorName,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.sales_developer_No"
                                                    .tr()
                                                    .toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                            subdealerSupervisor ,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:50,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.area_manager".tr().toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                            managerName,
                                          ),
                                        ),
                                      ),
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ),
                                      SizedBox(
                                        height:55,
                                        child: ListTile(
                                          leading: Container(
                                              width: 160,
                                              child: Text(
                                                "Tawasol_Form.area_manager_no".tr().toString(),
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xff11120e),
                                                    fontWeight: FontWeight.normal),
                                              )),
                                          title: Text(
                                            subdealerManager,
                                          ),
                                        ),
                                      ),
                                    ]),
                              ),
                            );
                            }
                          else if(state is GetTawasolInfoInitState){
                             return Container();
                          }else{
                             return Container();
                          }
                          },
                        ):Container(),
                        Permessions.contains('04.02')?Container(
                          padding:
                              EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 15),
                          margin: EdgeInsets.only(top: 10),
                          child: Text(
                            "Tawasol_Form.salesmen".tr().toString(),
                            style: TextStyle(
                              color: Color(0xFF11120e),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ):Container(),
                        Permessions.contains('04.02')?BlocBuilder<GetTawasolListBloc,GetTawasolListState>(
                        builder: (context,state){
                        // ignore: missing_return
                        if(state is GetTawasolInfoLoadingState){
                          return Container();
                        }else if(state is GetTawasolListSuccessState){
                          return Container(
                         child: ListView.builder(
                          shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount : state.data.length,
                            itemBuilder:(context,index){
                            return Container(
                            color: Colors.white,
                            child: Column(
                            children:[
                            SizedBox(
                            height:index  != state.data.length-1 ?  50 :55,
                            child: ListTile(
                            leading: Container(
                            width: 160,
                            child: Text(
                            "Tawasol_Form.phone_number".tr().toString(),
                            style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),

                            fontWeight: FontWeight.normal),
                            ),
                            ),
                            title: Text(
                            state.data[index]['subdealerTawasulNumber'],
                            style: TextStyle(
                            fontSize: 16,
                            color: Color(0xff11120e),
                            fontWeight: FontWeight.normal),
                            ),
                            ),
                            ),
                            index
                            != state.data.length-1 ?
                            Divider(
                            thickness: 1,
                            color: Color(0xFFedeff3),
                            ):Container(),
                            ]
                            ),

                            );
                            }
                            )
                          );
                        }
                        else{
                         }return Container();
                      }
                        ):Container(),
                        SizedBox(height: 10,)
                      ]),
                )),
        ),
      ),
    );
  }
}
