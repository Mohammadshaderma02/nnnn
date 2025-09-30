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
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';

import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../Multi_Use_Components/RequiredField.dart';
import '../MainPromotions/CustomerEligibleLines.dart';
import '../MainPromotions/LineActiveSubsidy.dart';





class IVRPassword extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  IVRPassword(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _IVRPasswordState createState() =>
      _IVRPasswordState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

APP_URLS urls = new APP_URLS();

class _IVRPasswordState extends State<IVRPassword> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  DateTime backButtonPressedTime;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  bool isLoading = false;
  bool isListed=true;


  bool emptyPassword=false;
  TextEditingController Password = TextEditingController();

  _IVRPasswordState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


  //*******************   List Item for First Menu    ****************/
  List litemsFirst = [
    ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),
    ListContentFirst(name:"corpMenu.Kurmalek".tr().toString()),
    ListContentFirst(name:"corpMenu.Balance".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_Services".tr().toString()),

  ];
  //*******************   End List Item for First Menu    ****************/


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
    print(data);
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{

    }

   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    //disableCapture();
    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }

  showAlertDialogERROR(BuildContext context, arabicMessage, englishMessage) {
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
        TextButton(
          onPressed: () {
            Navigator.pop(context, 'OK');
          },
          child: Text(
            "alert.cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialogUnotherizedERROR(BuildContext context, arabicMessage, englishMessage) {
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
        TextButton(
          onPressed: () {
            UnotherizedError();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialogOtherERROR(BuildContext context, arabicMessage, englishMessage) {
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  showAlertDialogNoData(BuildContext context, arabicMessage, englishMessage) {
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
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text(
            "corpAlert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        )
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  changeIVRPassword_API() async{



    if(Password.text==''){
      setState(() {
        emptyPassword=true;
      });
    }else if(Password.text!=''){
      setState(() {
        emptyPassword=false;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var apiArea = urls.BASE_URL + '/Customer360/changeIVRPassword';
      setState(() {
        isLoading=true;
      });
      final Uri url = Uri.parse(apiArea);

      Map body = {
        "customerID": customerNumber,

        "msisdn":msisdn,

        "newPassword": Password.text


      };
      final response = await http.post(url, headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },body: json.encode(body),);
      int statusCode = response.statusCode;
      print(statusCode);
      if (statusCode == 500) {
        print('500  error ');

      }
      if(statusCode==401 ){
        print('401  error ');
        UnotherizedError();
        //showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

      }
      if (statusCode == 200) {


        setState(() {

          isLoading=false;
        });
        var result = json.decode(response.body);



        if( result["status"]==0){
          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? result["message"]
                  : result["messageAr"],
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

        }else{
          showAlertDialogERROR(context,result["messageAr"], result["message"]);

          setState(() {

            isLoading=false;
          });

        }


      }
      else{
        showAlertDialogOtherERROR(context,statusCode.toString(), statusCode.toString());
        setState(() {

          isLoading=false;
        });
      }
    }



  }

  resetIVRPassword_API()async{


  SharedPreferences prefs = await SharedPreferences.getInstance();

  var apiArea = urls.BASE_URL + '/Customer360/resetIVRPassword';

  final Uri url = Uri.parse(apiArea);

  Map body = {
    "customerID": customerNumber,

    "msisdn": msisdn

  };
  final response = await http.post(url, headers: {
  "content-type": "application/json",
  "Authorization": prefs.getString("accessToken")
  },body: json.encode(body),);
  int statusCode = response.statusCode;
  print(statusCode);
  if (statusCode == 500) {
  print('500  error ');

  }
  if(statusCode==401 ){
  print('401  error ');
  UnotherizedError();
  //showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

  }
  if (statusCode == 200) {


  setState(() {

  isLoading=false;
  });
  var result = json.decode(response.body);



  if( result["status"]==0){

    showToast(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? result["message"]
            : result["messageAr"],
        context: context,
        animation: StyledToastAnimation.scale,
        fullWidth: true);
  }else{
  showAlertDialogERROR(context,result["messageAr"], result["message"]);


  }



  }
  else{
  showAlertDialogOtherERROR(context,statusCode.toString(), statusCode.toString());

  }
  }

  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberServices.ivr_password".tr().toString(),
            style: TextStyle(
              color: Color(0xFF11120E),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          // margin: EdgeInsets.symmetric(horizontal: 30),
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: emptyPassword==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyPassword ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: Password,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "SubscriberServices.enter_password".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyPassword  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }



  Future<bool> onWillPop() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Subscriber360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
        ),

      );
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF392156),
            title: Text("SubscriberServices.ivr_password".tr().toString(),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async{
                Navigator.pop(context);
              },
            ), //<Widget>[]

            /* actions: <Widget>[
                IconButton(
                  icon:  Icon(Icons.more_vert,color: Colors.white,),
                  onPressed: ( _showMoreOptionDialog) ,
                ), //IconButton//IconButton
              ],*/
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
          body: Container(
            color: Colors.white,
            padding: EdgeInsets.only(top:20,left: 26,right: 26),
            child: role == "Corporate"
                ? Column(

                 mainAxisAlignment: MainAxisAlignment.start,

                 children: [
                ///////////////////////////////////Second Content//////////////////////////////////////////////////////////

                  buildPassword(),
                  SizedBox(height: 20,),
                   GestureDetector(
                     onTap: (){
                       resetIVRPassword_API();
                     },
                     child: Row(
                       children:[

                         Text("SubscriberServices.reset_password".tr().toString(),
                         textAlign: TextAlign.start,
                         style: TextStyle(
                           decoration: TextDecoration.underline,
                         ),
                       ),]
                     ),
                   )





              ],
            ):Container(),
          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          floatingActionButton: Container(
            height:48,
            width:360,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.transparent),
            child:FloatingActionButton.extended(
              label: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  isLoading==true?SizedBox(
                    child: CircularProgressIndicator(color: Colors.white ),
                    height: 20.0,
                    width: 20.0,
                  )
                      :Container(),
                  SizedBox(width: 10,),
                  Text(
                    "SubscriberServices.submit".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              backgroundColor: Color(0xFF0E7074), //child widget inside this button

              onPressed: isLoading==true?null: (){

                changeIVRPassword_API();
              },
            ),
          ),

        ),
      ),

      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////




    );
  }
}