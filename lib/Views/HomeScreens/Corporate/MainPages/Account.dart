
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';




class Account extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;

  Account(this.PermessionCorporate, this.role);
  @override
  _AccountState createState() => _AccountState(this.PermessionCorporate, this.role);
}

class _AccountState extends State<Account> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  // String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;


  TextEditingController tawasol_number = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();


  _AccountState(this.PermessionCorporate, this.role);


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
    print("role role role role role");
    print(role);
    //disableCapture();
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    // TODO: implement dispose
    super.dispose();
  }

 void disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
 }


  Widget buildUserName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[

        RichText(
          text: TextSpan(
            text: "corporetUser.Search_by".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
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
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color:  serchByEmptyFlag ?  Color(0xFFB10000).withOpacity(0.1)  :Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: serchByEmptyFlag ?  Color(0xFFaf9090) : Color(0xFFD1D7E0),
                width:  serchByEmptyFlag ?  1: 1,
              )
          ),
          height: 58,
          child: TextField(
            controller: tawasol_number,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,

            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "Login_Form.userName".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildMobileNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "corporetUser.Mobile_Number".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
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
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color:  serchByEmptyFlag ?  Color(0xFFB10000).withOpacity(0.1)  :Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: serchByEmptyFlag ?  Color(0xFFaf9090) : Color(0xFFD1D7E0),
                width:  serchByEmptyFlag ?  1: 1,
              )
          ),
          height: 58,
          child: TextField(
            controller: tawasol_number,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,

            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "corporetUser.Enter_mobile".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }

  Widget buildSearchBtn() {
    return  Container(
      height: 48,
      width: 500,
      //margin: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xFF0E7074),
      ),


      child: TextButton(
        style: TextButton.styleFrom(
          backgroundColor:Color(0xFF0E7074),
          shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
        ),
        child: Text(
          "corporetUser.search".tr().toString(),
          style: TextStyle(
              color: Colors.white,
              letterSpacing: 0,
              fontSize: 16,
              fontWeight: FontWeight.bold),
        ),
        onPressed: () async {
          /* if (imageFileContract == null) {
                setState(() {
                  imageContractRequired = true;
                });
              }

              if (imageFileID == null) {
                setState(() {
                  imageIDRequired = true;
                });
              }

              if (imageFileID != null && imageFileContract != null) {
                print("hayaaaaaaaaaa");
                reservedLineBloc.add(PressReservedLineEvent(
                    kitCode: data['kitCode'].toString()));
              }*/
        },



      ),
    );
  }




  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
        onWillPop: () async {
      final pop = await onWillPopDialog(context);
      return pop?? true;
      //return true;
    },child:GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xFFEBECF1),
        appBar: AppBarSectionCorporate(appBar : AppBar(),
          title: Text(
              "corpNavBar.Account".tr().toString()
          ),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.notifications_none),
              onPressed: () {},
            ), //IconButton//IconButton
          ],
          PermessionCorporate: PermessionCorporate,
          role: role,

        ),
        body:role=="Corporate"?Center(
          child: ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top:0,bottom: 20,left: 32,right: 32),
            children: <Widget>[
              Center(

              ),

            ],
          ),
        )  :Container(),


      ),
    ));
  }
}

Future<bool> onWillPopDialog(context) => showDialog(
    barrierDismissible: false,
    context: context,
    builder: ((context) => AlertDialog(
      title:Text("corpAlert.msg1".tr().toString(),
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF11120E),
              fontWeight: FontWeight.normal)),
      actions: [
        TextButton(onPressed: (){
          Navigator.pop(context,true);

        }, child: Text("corpAlert.close".tr().toString(),
            style: TextStyle(
                fontSize: 16,
                color: Color(0xFF392156),
                )),),
        TextButton(onPressed: (){
          Navigator.pop(context,false);
        }, child: Text("corpAlert.cancel".tr().toString(),
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF392156),
              ),),),


      ],)));