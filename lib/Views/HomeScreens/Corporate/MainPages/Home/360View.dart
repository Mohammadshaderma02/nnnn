import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/Account.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/LogVisit/LogVisitMenu.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/SubscriberList.dart';

import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/RaiseTicket/RaiseTicket.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Settings/Settings.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria.block.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_events.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/VPNDetails.dart';

import 'Subscriber360Menu/BillShock.dart';


class Screen360view extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  String searchCraretia;
  String role;
  int searchID;
  String searchValue;
  String msisdn;
  String customerNumber;

  List data=[];

  Screen360view(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _Screen360viewState createState() =>
      _Screen360viewState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}



class _Screen360viewState extends State<Screen360view> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  DateTime backButtonPressedTime;
  String msisdn;
  String customerNumber;
  String customerName;
  String searchCraretia;
  List data=[];
  String activeDate;
  bool isLoading = false;
  final List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  List NationalNumberList=[];
  List CustomerNameList=[];
  List ReferanceNumberList=[];
  SearchCriteriaBloc searchCriteriaBloc;
  _Screen360viewState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


  int _selectedIndex = 0;
  void _onItemTapped(int index) async{

    SharedPreferences prefs = await SharedPreferences.getInstance();
    /*setState(() {
      _selectedIndex = index;
    });*/
    if(index==0){
      setState(() {
        _selectedIndex = index;
      });
      prefs.setInt('SavePageIndex', _selectedIndex);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorpNavigationBar(PermessionCorporate:
          prefs.getStringList('PermessionCorporate'),role:prefs.getString('role'),

          ),
        ),
      );
    }
    if(index==1){
      setState(() {
        _selectedIndex = index;
      });
      prefs.setInt('SavePageIndex', _selectedIndex);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorpNavigationBar(PermessionCorporate:
          prefs.getStringList('PermessionCorporate'),role:prefs.getString('role'),

          ),
        ),
      );
    } if(index==2){
      setState(() {
        _selectedIndex = index;
      });
      prefs.setInt('SavePageIndex', _selectedIndex);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorpNavigationBar(PermessionCorporate:
          prefs.getStringList('PermessionCorporate'),role:prefs.getString('role'),

          ),
        ),
      );
    } if(index==3){
      setState(() {
        _selectedIndex = index;
      });
      prefs.setInt('SavePageIndex', _selectedIndex);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorpNavigationBar(PermessionCorporate:
          prefs.getStringList('PermessionCorporate'),role:prefs.getString('role'),

          ),
        ),
      );
    } if(index==4){
      setState(() {
        _selectedIndex = index;
      });
      prefs.setInt('SavePageIndex', _selectedIndex);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorpNavigationBar(PermessionCorporate:
          prefs.getStringList('PermessionCorporate'),role:prefs.getString('role'),

          ),
        ),
      );
    }
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

  @override
  void initState() {
    print("UnotherizedError");
    print("role role role role role");
    print(searchValue);
    print(searchCraretia);
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{
      print('--------------------------');
      print("PRINT Data");
      print(this.data);
      print('--------------------------');

      if( searchCraretia=="National Number"){
        setState(() {
          NationalNumberList=this.data;
        });

      }
      if( searchCraretia=="Customer Name"){
        setState(() {
          CustomerNameList=this.data;
        });

      }
      if( searchCraretia=="Refrence Number"){
        setState(() {
          ReferanceNumberList=this.data;
        });

      }
      getData();
    //  iosSecureScreenShotChannel.invokeMethod("secureiOS");

    }

    //disableCapture();
    super.initState();
  }

  @override
  void dispose() {

    // this method to the user can take screenshots of your application
  //  iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }
  void getData()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setString('customerName',  this.data[0]['customerName']);
    prefs.setString('SubscriberNumber',   this.data[0]['msisdn']);
    prefs.setString('customerID',   this.data[0]['highestCustomerID']);
    prefs.setString('subscriberName',  this.data[0]['subscriberName']);


    print("********************************");
    print(prefs.getString("SubscriberNumber"));
    print("********************************");
    print(prefs.getString("customerID"));
    print(prefs.getString("subscriberName"));

    print("********************************");

  }

  Widget buildSearchBtn() {

    return Container(
        padding: EdgeInsets.symmetric(vertical: 25.0),
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF0E7074),
            padding: EdgeInsets.all(15.0),
            shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0),
            ),
            textStyle: TextStyle(
                color: Colors.white,
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.bold
            ),
            // minimumSize: Size.fromHeight(50),

          ),
          child: isLoading? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                child: CircularProgressIndicator(color: Colors.white ),
                height: 20.0,
                width: 20.0,
              ),
              SizedBox(width: 24),
              Text("corporetUser.PleaseWait".tr().toString())],

          ):
          searchCraretia=="Mobile Number"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="Customer Number"?
          Text("SubscriberList.view_subscriber_list".tr().toString()):
          searchCraretia=="FTTH Username"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="SIM Number"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="Contract Number"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="FTTH Serial Number"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="ETTH Username"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="ADSL Username"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="Case Reference"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="IMSI Number"?
          Text("360Views.Subscriber360View".tr().toString()):
          searchCraretia=="DID"?
          Text("360Views.Subscriber360View".tr().toString()):
          Text("TEXT IF NOT MOBILE NUMBER OR CUSTOMER NUMBER"),


          onPressed: () async {

            if(isLoading) return;
            setState(() {
              isLoading =true;});
            if(searchCraretia=="Mobile Number"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
            }else if(searchCraretia=="IMSI Number"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
            }else if(searchCraretia=="DID"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
            }else if(searchCraretia=="Customer Number"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => SubscriberList(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
            }else if(searchCraretia=="SIM Number"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
            }else if(searchCraretia=="Contract Number"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
            }else  if(searchCraretia=="FTTH Username"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
              /* showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "This service not available now "
                  : "هذه الخدمة غير متوفرة الآن",
                  context: context,
                  animation: StyledToastAnimation.scale,
                  fullWidth: true);*/
              setState(() {
                isLoading=false;
              });
            } else  if(searchCraretia=="FTTH Serial Number"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );

              /* showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "This service not available now "
                  : "هذه الخدمة غير متوفرة الآن",
                  context: context,
                  animation: StyledToastAnimation.scale,
                  fullWidth: true);*/
              setState(() {
                isLoading=false;
              });
            }
            else  if(searchCraretia=="ETTH Username"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
              /* showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                ? "This service not available now "
                : "هذه الخدمة غير متوفرة الآن",
                context: context,
                animation: StyledToastAnimation.scale,
                fullWidth: true);*/
              setState(() {
                isLoading=false;
              });

            } else  if(searchCraretia=="ADSL Username"){
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
              /*showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "This service not available now "
                  : "هذه الخدمة غير متوفرة الآن",
                  context: context,
                  animation: StyledToastAnimation.scale,
                  fullWidth: true);*/
              setState(() {
                isLoading=false;
              });

            }else if(searchCraretia=="Case Reference"){

              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,searchCraretia),
                ),
              );
            }


          },
        )

    );
  }

  showAlertDialogError(BuildContext context,arabicMessage,englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text("alert.tryAgain".tr().toString() ,
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



  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      SharedPreferences prefs = await SharedPreferences.getInstance();

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => CorpNavigationBar(
            PermessionCorporate: prefs.getStringList('Permessions'),
            role: prefs.get('role'),

          ),
        ),
      );
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {

    return BlocListener<SearchCriteriaBloc, SearchCriteriaState>(
        listener: (context, state) {
          if(state is SearchCriteriaErrorState ) {
            showAlertDialogError(context,state.arabicMessage,state.englishMessage);
            setState(() {
              isLoading =false;
            });

          }
          if (state is SearchCriteriaSuccessState) {
            setState(() {
              isLoading =false;
            });
            setState(() {
              data=state.data;
              msisdn=state.msisdn;
              customerNumber=state.customerNumber;


            });




          }
        },child:WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF392156),
              title: Text("360Views.360Views".tr().toString()),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async{
                  // Navigator.pop(context);
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CorpNavigationBar(
                        PermessionCorporate: prefs.getStringList('Permessions'),
                        role: prefs.get('role'),

                      ),
                    ),
                  );
                },
              ), //<Widget>[]


            ),
            backgroundColor: Color(0xFFEBECF1),
            /* appBar: AppBarSectionCorporate(
              appBar: AppBar(),
              title: Text("DashBoard_Form.home".tr().toString()),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.notifications_none),
                  onPressed: () {},
                ), //IconButton//IconButton
              ],
              PermessionCorporate: PermessionCorporate,
              role: role,
              outDoorUserName: outDoorUserName,
            ),*/
            body: role == "Corporate"
                ? Column(
                  children: [
                    ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: 8, left: 0, right: 0),
              children: [
                    SingleChildScrollView(
                        child: Column(
                            children: [
                              searchCraretia=="Mobile Number"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID']!=null?this.data[0]['highestCustomerID']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['customerName']!=null?this.data[0]['customerName']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.SubscriberName".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName']!=null?this.data[0]['subscriberName']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerTotalBalance".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['balance'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.Package".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(EasyLocalization.of(context).locale == Locale("en", "US")?
                                        this.data[0]['packageName']!=null?this.data[0]['packageName']:'-': this.data[0]['packageNameAr']!=null?this.data[0]['packageNameAr']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),

                                        Text(
                                          "SubscriberView.BillingStatus"
                                              .tr()
                                              .toString() +
                                              "   ",
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['contractStatus']!=null?this.data[0]['contractStatus']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text( "SubscriberView.ActivationDate".tr().toString(),

                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['activeDate']!=null?  this.data[0]['activeDate'].toString().substring(0,this.data[0]['activeDate'].indexOf(" ")):'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),])):
                              searchCraretia=="DID"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID']!=null?this.data[0]['highestCustomerID']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['customerName']!=null?this.data[0]['customerName']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.SubscriberName".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName']!=null? this.data[0]['subscriberName']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerTotalBalance".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['balance'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.Package".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          EasyLocalization.of(context).locale == Locale("en", "US")?
                                          this.data[0]['packageName']!=null?this.data[0]['packageName']:'-':
                                          this.data[0]['packageNameAr']!=null?this.data[0]['packageNameAr']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),

                                        Text(
                                          "SubscriberView.BillingStatus"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['contractStatus']!=null?this.data[0]['contractStatus']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text( "SubscriberView.ActivationDate".tr().toString(),

                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['activeDate']!=null?  this.data[0]['activeDate'].toString().substring(0,this.data[0]['activeDate'].indexOf(" ")):'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),])):    searchCraretia=="IMSI Number"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID']!=null?this.data[0]['highestCustomerID']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['customerName']!=null?this.data[0]['customerName']:"-",
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.SubscriberName".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName']!=null?this.data[0]['subscriberName']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerTotalBalance".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['balance']!=null? this.data[0]['balance'].toString():'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.Package".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          EasyLocalization.of(context).locale == Locale("en", "US")?
                                          this.data[0]['packageName']!=null?this.data[0]['packageName']:'-':
                                          this.data[0]['packageNameAr']!=null?this.data[0]['packageNameAr']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),

                                        Text(
                                          "SubscriberView.BillingStatus"
                                              .tr()
                                              .toString() +
                                              "   ",
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['contractStatus']!=null?this.data[0]['contractStatus']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text( "SubscriberView.ActivationDate".tr().toString(),

                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['activeDate']!=null?  this.data[0]['activeDate'].toString().substring(0,this.data[0]['activeDate'].indexOf(" ")):'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),])):searchCraretia=="Customer Number"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),

                                        Text(
                                          "SubscriberView.CustomerName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['customerName']!=null?this.data[0]['customerName']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerTotalBalance".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['balance']!=null? this.data[0]['balance'].toString():'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),

                                      ])):searchCraretia=="FTTH Username"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),

                                        Text(
                                          "SubscriberView.CustomerNumber"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID']!=null?this.data[0]['highestCustomerID']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerName".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['customerName']!=null?this.data[0]['customerName']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.msisdn".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['msisdn']!=null?this.data[0]['msisdn']:'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ])) :searchCraretia=="National Number"?

                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child:
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                                  itemCount: NationalNumberList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    //   itemCount :  UserList.length,
                                    return  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white
                                      ),
                                      margin: EdgeInsets.only(bottom: 15),
                                      padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text("SubscriberView.SubscriberName".tr().toString(),),

                                                      SizedBox(height: 1),
                                                      Text(
                                                        NationalNumberList[index]['subscriberName']??'-',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text("SubscriberView.CustomerNumber".tr().toString(),),

                                                      SizedBox(height: 1),
                                                      Text(
                                                        NationalNumberList[index]['highestCustomerID']??'-',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 5),
                                              //Spacer(),


                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 2, right: 2),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 15,
                                                      ),

                                                      Container(
                                                        color: Colors.transparent,
                                                        width: double.infinity,
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                  width: double.infinity,
                                                                  child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Color(0xFF0E7074),
                                                                      padding: EdgeInsets.all(10.0),
                                                                      shape: new RoundedRectangleBorder(
                                                                        borderRadius: new BorderRadius.circular(10.0),
                                                                      ),
                                                                      textStyle: TextStyle(
                                                                          color: Colors.white,
                                                                          letterSpacing: 0,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold
                                                                      ),


                                                                    ), child: isLoading? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        child: CircularProgressIndicator(color: Colors.white ),
                                                                        height: 10.0,
                                                                        width: 10.0,
                                                                      ),
                                                                      SizedBox(width: 16),
                                                                      Text("corporetUser.PleaseWait".tr().toString())],

                                                                  ):

                                                                  Text("SubscriberList.view_subscriber_list".tr().toString()),


                                                                    onPressed: () async {

                                                                      if(isLoading) return;
                                                                      setState(() {
                                                                        isLoading =true;});
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => SubscriberList(PermessionCorporate,role,searchID,searchValue,NationalNumberList[index]['highestCustomerID'],NationalNumberList[index]['msisdn'],this.data,searchCraretia),
                                                                        ),
                                                                      );



                                                                    },
                                                                  )

                                                              )
                                                            ]),),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          )

                                        ],
                                      ),
                                    );


                                  },
                                ),

                              ) :searchCraretia=="SIM Number"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['customerName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.SubscriberName".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.CustomerTotalBalance".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['balance'].toString(),
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.Package".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          EasyLocalization.of(context).locale == Locale("en", "US")? this.data[0]['packageName']: this.data[0]['packageNameAr:'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),

                                        Text(
                                          "SubscriberView.BillingStatus"
                                              .tr()
                                              .toString() +
                                              "   ",
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['contractStatus'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),),

                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text( "SubscriberView.ActivationDate".tr().toString(),

                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['activeDate']!=null?  this.data[0]['activeDate'].toString().substring(0,this.data[0]['activeDate'].indexOf(" ")):'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),])):searchCraretia=="Customer Name"?

                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child:
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                                  itemCount: CustomerNameList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    //   itemCount :  UserList.length,
                                    return  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white
                                      ),
                                      margin: EdgeInsets.only(bottom: 15),
                                      padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),


                                                      Text("SubscriberView.SubscriberName".tr().toString(),),

                                                      SizedBox(height: 1),
                                                      Text(
                                                        CustomerNameList[index]['subscriberName']??'-',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),),

                                                      SizedBox(
                                                        height: 15,
                                                      ),

                                                      Text("SubscriberView.CustomerNumber".tr().toString(),),

                                                      SizedBox(height: 1),
                                                      Text(
                                                        CustomerNameList[index]['highestCustomerID']??'-',
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),)



                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 5),
                                              //Spacer(),

                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 2, right: 2),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 15,
                                                      ),

                                                      Container(
                                                        color: Colors.transparent,
                                                        width: double.infinity,
                                                        // padding: EdgeInsets.only(left: 26, right: 26),
                                                        // margin: EdgeInsets.all(12),
                                                        // margin: EdgeInsets.only(bottom: 5),
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                // padding: EdgeInsets.symmetric(vertical: 25.0),
                                                                  width: double.infinity,
                                                                  child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Color(0xFF0E7074),
                                                                      padding: EdgeInsets.all(10.0),
                                                                      shape: new RoundedRectangleBorder(
                                                                        borderRadius: new BorderRadius.circular(10.0),
                                                                      ),
                                                                      textStyle: TextStyle(
                                                                          color: Colors.white,
                                                                          letterSpacing: 0,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold
                                                                      ),
                                                                      // minimumSize: Size.fromHeight(50),

                                                                    ), child: isLoading? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        child: CircularProgressIndicator(color: Colors.white ),
                                                                        height: 10.0,
                                                                        width: 10.0,
                                                                      ),
                                                                      SizedBox(width: 16),
                                                                      Text("corporetUser.PleaseWait".tr().toString())],

                                                                  ):

                                                                  Text("SubscriberList.view_subscriber_list".tr().toString()),


                                                                    onPressed: () async {

                                                                      if(isLoading) return;
                                                                      setState(() {
                                                                        isLoading =true;});
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => SubscriberList(PermessionCorporate,role,searchID,searchValue,CustomerNameList[index]['highestCustomerID'],CustomerNameList[index]['msisdn'],this.data,searchCraretia),
                                                                        ),
                                                                      );

                                                                    },
                                                                  )

                                                              )
                                                            ]),),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )

                                        ],
                                      ),
                                    );


                                  },
                                ),

                              ) : searchCraretia=="Contract Number"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.SubscriberName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.msisdn".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['msisdn'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),


                                      ])):searchCraretia=="FTTH Serial Number"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.SubscriberName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.msisdn".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['msisdn'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),


                                      ])): searchCraretia=="ETTH Username"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.SubscriberName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.msisdn".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['msisdn'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),


                                      ])):searchCraretia=="ADSL Username"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.SubscriberName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.msisdn".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['msisdn'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),


                                      ])):searchCraretia=="Refrence Number"?
                              Container(
                                padding: EdgeInsets.only(left: 10, right: 10),
                                child:
                                ListView.builder(
                                  shrinkWrap: true,
                                  physics: ClampingScrollPhysics(),
                                  padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                                  itemCount: ReferanceNumberList.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    //   itemCount :  UserList.length,
                                    return  Container(
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(5),
                                          color: Colors.white
                                      ),
                                      margin: EdgeInsets.only(bottom: 15),
                                      padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Expanded(
                                                child: Container(
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 10,
                                                      ),
                                                      Text(
                                                        "SubscriberView.CustomerNumber"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        this.data[index]['customerNumber'],
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                      SizedBox(
                                                        height: 15,
                                                      ),
                                                      Text(
                                                        "SubscriberView.CustomerName"
                                                            .tr()
                                                            .toString(),
                                                      ),
                                                      SizedBox(height: 1),
                                                      Text(
                                                        this.data[index]['customerName'],
                                                        style: TextStyle(
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 14.0,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                              SizedBox(width: 5),
                                              //Spacer(),


                                              Expanded(
                                                child: Container(
                                                  margin: EdgeInsets.only(left: 2, right: 2),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                    mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                    children: [
                                                      SizedBox(
                                                        height: 15,
                                                      ),

                                                      Container(
                                                        color: Colors.transparent,
                                                        width: double.infinity,
                                                        child: Column(
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Container(
                                                                  width: double.infinity,
                                                                  child: ElevatedButton(
                                                                    style: ElevatedButton.styleFrom(
                                                                      backgroundColor: Color(0xFF0E7074),
                                                                      padding: EdgeInsets.all(10.0),
                                                                      shape: new RoundedRectangleBorder(
                                                                        borderRadius: new BorderRadius.circular(10.0),
                                                                      ),
                                                                      textStyle: TextStyle(
                                                                          color: Colors.white,
                                                                          letterSpacing: 0,
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold
                                                                      ),


                                                                    ), child: isLoading? Row(
                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                    children: [
                                                                      SizedBox(
                                                                        child: CircularProgressIndicator(color: Colors.white ),
                                                                        height: 10.0,
                                                                        width: 10.0,
                                                                      ),
                                                                      SizedBox(width: 16),
                                                                      Text("corporetUser.PleaseWait".tr().toString())],

                                                                  ):

                                                                  Text("360Views.Subscriber360View".tr().toString()),


                                                                    onPressed: () async {

                                                                      if(isLoading) return;
                                                                      setState(() {
                                                                        isLoading =true;});
                                                                      Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) => Subscriber360view(PermessionCorporate,role,searchID,searchValue,ReferanceNumberList[index]['highestCustomerID'],ReferanceNumberList[index]['msisdn'],this.data,searchCraretia),
                                                                        ),
                                                                      );

                                                                    },
                                                                  )

                                                              )
                                                            ]),),
                                                    ],
                                                  ),
                                                ),
                                              ),

                                            ],
                                          )

                                        ],
                                      ),
                                    );


                                  },
                                ),

                              )

                                  : searchCraretia=="Case Reference"?
                              Container(
                                  color: Colors.white,
                                  width: double.infinity,
                                  padding: EdgeInsets.only(left: 26, right: 26),
                                  // margin: EdgeInsets.all(12),
                                  margin: EdgeInsets.only(bottom: 5),
                                  child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.CustomerNumber".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['highestCustomerID'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,

                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text(
                                          "SubscriberView.SubscriberName"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['subscriberName'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        Text(
                                          "SubscriberView.msisdn".tr().toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          this.data[0]['msisdn'],
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),


                                      ])):Container(),
                              searchCraretia!="National Number" && searchCraretia!="Customer Name" && searchCraretia!="Refrence Number"? SizedBox(height: 20,):Container(),
                              searchCraretia!="National Number" && searchCraretia!="Customer Name"&& searchCraretia!="Refrence Number"?
                              Container(
                                color: Colors.transparent,
                                width: double.infinity,
                                padding: EdgeInsets.only(left: 26, right: 26),
                                // margin: EdgeInsets.all(12),
                                margin: EdgeInsets.only(bottom: 5),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      buildSearchBtn(),
                                    ]),):Container()




                            ])),
                    ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
              ],
            ),
                  ],
                )
                : Center(
              child: Text(role),
            ),
            bottomNavigationBar: BottomNavigationBar(
              items:  <BottomNavigationBarItem>[

                BottomNavigationBarItem(
                    icon: _selectedIndex == 0
                        ? Icon(
                      Icons.home,
                    ) : Icon(
                      Icons.home_outlined,
                    ),

                    label: "corpNavBar.Home".tr().toString()
                ),
                BottomNavigationBarItem(
                    icon: _selectedIndex == 1
                        ? Icon(
                      Icons.note_add,
                    )
                        : Icon(
                      Icons.note_add_outlined,
                    ),
                    label: "corpNavBar.Raise_Ticket".tr().toString()),

                BottomNavigationBarItem(
                    icon: _selectedIndex == 1
                        ? Icon(
                      Icons.person_pin_circle,
                    )
                        : Icon(
                      Icons.person_pin_circle,

                    ),
                    label: "corpNavBar.Log_Visit".tr().toString()),

                BottomNavigationBarItem(
                    icon: _selectedIndex == 3
                        ? Icon(
                        Icons.account_circle
                    )
                        : Icon(
                      Icons.account_circle_outlined,
                    ),
                    label: "corpNavBar.Account".tr().toString()),
                BottomNavigationBarItem(
                    icon: _selectedIndex == 4
                        ? Icon(
                        Icons.settings
                    )
                        : Icon(
                        Icons.settings
                    ),
                    label:"corpNavBar.Settings".tr().toString()),

              ],
              type: BottomNavigationBarType.fixed,
              currentIndex: _selectedIndex,
              onTap: _onItemTapped,
              selectedItemColor: Color(0xFF392156),
              unselectedItemColor: Color(0xFF778ca2),
              selectedLabelStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
            ),
          ),
        )));
  }
}