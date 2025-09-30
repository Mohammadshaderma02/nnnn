import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/TawasolServices.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Recharge/Recharge.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/UpgradePackage/CheckMSISDN_Bulk.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/UpgradePackage/EnterMSSIDNumber.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/UnotherizedError.dart';
import 'package:sales_app/blocs/ChangePackageEligibilityRq/changePackageEligibilityRq_bloc.dart';
import 'package:sales_app/blocs/ChangePackageEligibilityRq/changePackageEligibilityRq_events.dart';
import 'package:sales_app/blocs/ChangePackageEligibilityRq/changePackageEligibilityRq_state.dart';
import 'package:sales_app/blocs/ChangePackagePreToPreRq/changePackagePreToPreRq_bloc.dart';
import 'package:sales_app/blocs/ChangePackagePreToPreRq/changePackagePreToPreRq_events.dart';
import 'package:sales_app/blocs/ChangePackagePreToPreRq/changePackagePreToPreRq_state.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ActiveAndEligiblePackages_Bulk extends StatelessWidget {
  var  refresh=0;
  bool enableMsisdn;
  String  preMSISDN;
  String ActivePackage ;
  String mssid;
  List bulkNumbers;
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  bool NoActiveFlag =false;
  bool disable= false;
  ActiveAndEligiblePackages_Bulk(this.ActivePackage,this.bulkNumbers,this.enableMsisdn,this.Permessions,this.role,this.outDoorUserName);
  DateTime backButtonPressedTime;
  ChangePackageEligibilityRqBloc changePackageEligibilityRqBloc;
  ChangePackagePreToPreRqBloc changePackagePreToPreRqBloc;


  showAlertDialogLoadingState(BuildContext context, arabicMessage) {
    AlertDialog alert = AlertDialog(
      content: Text( EasyLocalization.of(context).locale == Locale("en", "US")
          ? "please wait to get response"
          : "يرجى الانتظار للحصول على رد",
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),

    );
    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
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
            Navigator.pop(context, true);
          },
          child: Text("alert.close".tr().toString(),
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
  showAlertDialogAdd(BuildContext context, packege,pakgeCode) {
    AlertDialog alert = AlertDialog(
      title: Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? 'Confirm Upgrade Pakage'
            : 'تأكيد ترقية الحزم',
        style: TextStyle(
          color: Colors.black,
          fontSize: 20,
        ),
      ),
      content:Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? 'Are you sure you want to Upgrade to ' +packege  + ' ?'
            :"هل أنت متأكد من الترقية لحزمة " + packege+ ' ؟',
        style: TextStyle(
          color: Colors.black,
          fontSize: 16,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
          },
          child: Text(
            "SubscriberServices.no".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),

        TextButton(
          onPressed:() {
           // changePackagePreToPreRqBloc.add(ChangePackagePreToPreRqFetchEvent(bulkNumbers[0]['msisdn'].toString(),pakgeCode,true));
            // Navigator.pop(context, true);

            Navigator.of(context).push(MaterialPageRoute(
                builder:(context)=>CheckMSISDN_Bulk(
                   bulkNumbers,pakgeCode,enableMsisdn,ActivePackage,packege,this.Permessions,this.role,this.outDoorUserName)));

          },
          child: Text(
            "SubscriberServices.yes".tr().toString(),
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
  @override
  Widget build(BuildContext context) {
    changePackageEligibilityRqBloc = BlocProvider.of<ChangePackageEligibilityRqBloc>(context);
    changePackagePreToPreRqBloc = BlocProvider.of<ChangePackagePreToPreRqBloc>(context);
    changePackageEligibilityRqBloc.add(ChangePackageEligibilityRqFetchEvent(bulkNumbers[0]['msisdn'].toString(),'false'));
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
    if(ActivePackage=='No active packege found' ||ActivePackage=='لا يوجد حزم نشطة') {
      NoActiveFlag = true;
    }
    return  BlocListener<ChangePackagePreToPreRqBloc,ChangePackagePreToPreRqState>(
      listener:  (context, state) async {

        if(state is ChangePackagePreToPreRqLoadingState){

          Navigator.pop(context, true);
          showAlertDialogLoadingState(context, 'please wait to get response');


        }
        if(state is ChangePackagePreToPreRqSuccessState){
          print("test one");
          Navigator.pop(context, true);

          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? state.englishMessage
                  : state.arabicMessage,
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);
          // sleep(const Duration(seconds: 5));

          await Future.delayed(const Duration(seconds: 3), (){  Navigator.pop(context, true);});





        }
        if(state is ChangePackagePreToPreRqErrorState ){
          print("test two");

          Navigator.pop(context, true);
          showAlertDialog(context, state.arabicMessage, state.englishMessage);
        }
        if(state is ChangePackagePreToPreRqTokenErrorState){
          UnotherizedError();
        }
      },
      child:  BlocListener<ChangePackageEligibilityRqBloc,ChangePackageEligibilityRqState>(
        listener:  (context, state) async {
          if(state is ChangePackageEligibilityRqNoDataState){
            if(refresh==0){
              if(state.englishMessage=='No Eligible Packages'){
                changePackageEligibilityRqBloc.add(ChangePackageEligibilityRqFetchEvent(bulkNumbers[0]['msisdn'].toString(),'false'));
                refresh=1;
              }
            }
          }

        },
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),

          child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                  /*  Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EnterMSSIDNumber(enableMsisdn,preMSISDN),
                  ),
                );*/
                },
              ),
              centerTitle:false,
              title: Text(
                "SubscriberList.packages".tr().toString(),
              ),
              backgroundColor: Color(0xFF4f2565),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body:  RefreshIndicator(
              color: Color(0xFF4f2565),
              onRefresh: () async{
                changePackageEligibilityRqBloc.add(ChangePackageEligibilityRqFetchEvent(bulkNumbers[0]['msisdn'].toString(),'false'));
              },
              child: ListView(
                  physics: ClampingScrollPhysics(),
                  shrinkWrap: true,
                  padding: EdgeInsets.only(top: 8),
                  children: <Widget>[
                    Container(
                      padding:
                      EdgeInsets.only(left: 16, right: 10, top: 8, bottom: 15),
                      //margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "Menu_Form.Active_Pakeges".tr().toString(),
                        style: TextStyle(
                          color: Color(0xFF11120e),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,

                        ),
                      ),
                    ),
                    Container(
                      child:
                      SizedBox(
                        height: 55,
                        child: ListTile(
                          tileColor: Colors.white ,
                          title: Text(
                            ActivePackage,
                            style: TextStyle(
                                fontSize: 16,
                                color: NoActiveFlag==false ? Color(0xff11120e) : Color(0xff778ca2),
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ),
                    ),

                    Container(
                      padding:
                      EdgeInsets.only(left: 16, right: 10, top: 16, bottom: 15),
                      //margin: EdgeInsets.only(top: 20),
                      child: Text(
                        "Menu_Form.Eligable_Pakeges".tr().toString(),
                        style: TextStyle(
                          color: Color(0xFF11120e),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

                    BlocBuilder<ChangePackageEligibilityRqBloc,ChangePackageEligibilityRqState>(
                      builder: (context,state){
                        if(state is ChangePackageEligibilityRqLoadingState){
                          print("how are you");
                          return Container(
                            child: Center(
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
                              ),
                            ),
                          );
                        }
                        else if(state is ChangePackageEligibilityRqSuccessState){
                          return RefreshIndicator(
                            color: Color(0xFF4f2565),
                            onRefresh: () async{
                              changePackageEligibilityRqBloc.add(ChangePackageEligibilityRqFetchEvent(bulkNumbers[0]['msisdn'].toString(),'false'));
                            },
                            child: Container(
                              color: Colors.white,
                              child: Center(
                                  child: state.data.length!=0?
                                  ListView.builder(
                                      shrinkWrap: true,
                                      physics: ClampingScrollPhysics(),
                                      itemCount : state.data.length,
                                      itemBuilder:(context,index){
                                        return Container(
                                          color: Colors.white,
                                          child: Column(
                                              children:[
                                                Container(
                                                  child: ListTile(
                                                      title: Text(
                                                        EasyLocalization.of(context).locale == Locale("en", "US")
                                                            ? state.data[index]['englishDescription']
                                                            : state.data[index]['arabicDescription'],
                                                        style: TextStyle(
                                                            fontSize: 16,
                                                            color: Color(0xff11120e),
                                                            fontWeight: FontWeight.normal),
                                                      ),
                                                      trailing:
                                                      TextButton(
                                                        child: Text(
                                                          "Menu_Form.select".tr().toString(),
                                                          style: TextStyle(
                                                            color: Color(0xFF0070c9),
                                                            letterSpacing: 0,
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          showAlertDialogAdd(context,  EasyLocalization.of(context).locale == Locale("en", "US")
                                                              ? state.data[index]['englishDescription']
                                                              : state.data[index]['arabicDescription'],
                                                              state.data[index]['packageCode']
                                                          );
                                                        },
                                                      )
                                                  ),
                                                ),
                                                index != state.data.length-1 ?
                                                Divider(
                                                  thickness: 1,
                                                  color: Color(0xFFedeff3),
                                                ):Container(),
                                              ]
                                          ),

                                        );
                                      }
                                  ):''

                              ),
                            ),
                          );
                        }
                        else  if(state is ChangePackageEligibilityRqNoDataState ){
                          return  Container(
                            child:
                            SizedBox(
                              height: 50,
                              child: ListTile(
                                tileColor: Colors.white,
                                title: Text(
                                  EasyLocalization.of(context).locale == Locale("en", "US")
                                      ? state.englishMessage
                                      : state.arabicMessage,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF778ca2),
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),

                          );
                        }
                        else if(state is ChangePackageEligibilityRqTokenErrorState ){
                          return  Container(
                            child:
                            SizedBox(
                              height: 50,
                              child: ListTile(
                                tileColor:Colors.white,
                                title: Text(
                                  EasyLocalization.of(context).locale == Locale("en", "US")
                                      ? state.englishMessage
                                      : state.arabicMessage,
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Color(0xFF778ca2),
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ),

                          );
                        }
                        else{
                          return  Container();
                        }
                      },
                    ),

                  ]),
            ),
          ),
        ),
      ),
    );
  }
}
