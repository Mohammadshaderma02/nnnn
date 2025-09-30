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




class Item {
  const Item(this.id, this.name);
  final String id;
  final String name;
}

class IVRLanguage extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  IVRLanguage(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _IVRLanguageState createState() =>
      _IVRLanguageState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

APP_URLS urls = new APP_URLS();

class _IVRLanguageState extends State<IVRLanguage> {
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
  var language="1";

  List<Item> LANGUAGE=<Item>[
    Item(
      '1',"English"
    ),
    Item(
        '2',"Arabic"
    ),
  ];

  bool emptyLanguage=false;
  TextEditingController Language = TextEditingController();

  _IVRLanguageState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


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
  //  iosSecureScreenShotChannel.invokeMethod("secureiOS");

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



  submitIVRLanguage_API() async{

   print(language);

    if(language==null){
      setState(() {
        emptyLanguage=true;
      });
    }else if(language!=''){
      setState(() {
        emptyLanguage=false;
      });



      SharedPreferences prefs = await SharedPreferences.getInstance();

      var apiArea = urls.BASE_URL + '/Customer360/changeIVRLanguage';
      setState(() {
        isLoading=true;
      });
      final Uri url = Uri.parse(apiArea);
      print(url);
      Map body = {
        "customerID": customerNumber,

        "msisdn": msisdn,

        "newLangText": language=="1"?"English":"Arabic",

        "newLangValue": language

      };
      final response = await http.post(url, headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },body: json.encode(body),);
      int statusCode = response.statusCode;
      print(statusCode);
      print(json.encode(body));

      if (statusCode == 500) {
        print('500  error ');

      }
      if(statusCode==401 ){
        print('401  error ');
        UnotherizedError();
      //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

      }
      if (statusCode == 200) {


        setState(() {

          isLoading=false;
        });
        var result = json.decode(response.body);

print(result);

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



  Widget buildLanguage() {
    return Container(
      height: 100,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          RichText(
            text: TextSpan(
              text: "SubscriberServices.ivr_language".tr().toString(),
              style: TextStyle(
                color: Color(0xFF11120E),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),

            ),
          ),
          SizedBox(height: 10),
          Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  //color: Color(0xFFB10000), red color
                  color:emptyLanguage== true
                      ? Color(0xFFB10000)
                      : Color(0xFFD1D7E0),
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    hint: Text(
                      "Personal_Info_Edit.select_an_option".tr().toString(),
                      style: TextStyle(
                        color: Color(0xFFA4B0C1),
                        fontSize: 14,
                      ),
                    ),

                    dropdownColor: Colors.white,
                    icon:  Icon(Icons.keyboard_arrow_down_rounded),
                    iconSize: 30,
                    iconEnabledColor: Colors.grey,
                    underline: SizedBox(),
                    isExpanded: true,
                    style: TextStyle(
                      color: Color(0xff11120e),
                      fontSize: 14,
                    ),
                    items:[
                    DropdownMenuItem<String>(
                    value: "1" ,
                    child: Text("English"),
                      ), DropdownMenuItem<String>(
                      value: "2",
                      child: Text("Arabic"),
                      )
                    ].toList()

                    ,
                    value: language,
                    onChanged: (String newValue) {

                      setState(() {
                        language = newValue;

                      });




                    },
                  ),
                ),
              )),
          emptyLanguage==true? RequiredFeild(
              text: "Menu_Form.msisdn_required".tr().toString())
              : Container(),
        ],
      ),
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
            title: Text("SubscriberServices.ivr_language".tr().toString(),),
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

                 Container(

                   child: Row(children: [

                     Text(
                       "corpMenu.Language".tr().toString(),
                       style: TextStyle(
                         color: Color(0xFF2F2F2F),
                         fontSize: 14,
                         fontWeight: FontWeight.normal,
                       ),
                     ),
                     Spacer(),
                     EasyLocalization.of(context).locale == Locale("en", "US")
                         ? Container(
                       width: 80,
                       height: 40,
                       margin: EdgeInsets.only(left: 70),

                       decoration: BoxDecoration(
                         color:  language=="1" ?   Color(0xff392156) :Colors.white,

                         border: Border.all(
                             color: language=="1" ? const Color(0xff392156):Color(0xFFD6D6D6),
                             width: 1.0,
                             style:
                             BorderStyle.solid), //Border.all
                         /*** The BorderRadius widget  is here ***/
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(30),
                           topRight: Radius.circular(0),
                           bottomLeft: Radius.circular(30),
                           bottomRight: Radius.circular(0),
                         ), //BorderRadius.all
                       ),
                       child: Row(
                         children: [
                           SizedBox(
                             width: 5,
                           ),
                           Icon(
                             Icons.check,
                             color: Colors.white,
                             size: 20,
                           ),
                           SizedBox(
                             width: 3,
                           ),
                           InkWell(
                             child: Text(
                               "English",
                               style: TextStyle(
                                 color: language=="1"? Colors.white:Color(0xFF1C1B1F),
                                 fontSize: 12,
                                 fontWeight: FontWeight.normal,
                               ),
                             ),
                             onTap: () async {

                               print('hei dafii clcke');
                               setState(() {
                                 language="1";
                               });
                               },
                           ),
                         ],
                       ), //BoxDecoration
                     )
                         : Container(
                       width: 80,
                       height: 40,
                       margin: EdgeInsets.only(right: 108),

                       decoration: BoxDecoration(
                         color: language=="2"? Color(0xff392156):Colors.white,
                         /*  image: const DecorationImage(
                                  image: NetworkImage(
                                      'https://media.geeksforgeeks.org/wp-content/cdn-uploads/logo.png'),
                                ),*/
                         border: Border.all(
                             color:  language=="2" ? const Color(0xff392156):Color(0xFFD6D6D6),
                             width: 1.0,
                             style:
                             BorderStyle.solid), //Border.all
                         /*** The BorderRadius widget  is here ***/
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(0),
                           topRight: Radius.circular(30),
                           bottomLeft: Radius.circular(0),
                           bottomRight: Radius.circular(30),
                         ), //BorderRadius.all
                       ),
                       child: Row(
                         children: [
                           SizedBox(
                             width: 5,
                           ),
                           Icon(
                             Icons.check,
                             color: Colors.white,
                             size: 20,
                           ),
                           SizedBox(
                             width: 3,
                           ),
                           InkWell(
                             child: Text(
                               "العربية",
                               style: TextStyle(
                                 color:  language=="2" ? Colors.white:Color(0xFF1C1B1F),
                                 fontSize: 14,
                                 fontWeight: FontWeight.normal,
                               ),
                             ),

                             onTap: () async {
                             print('hee ');
                               setState(() {
                                 language="2";
                               });
                             },
                           ),
                         ],
                       ),

                       //BoxDecoration
                     ),

                     EasyLocalization.of(context).locale == Locale("en", "US")
                         ? Container(
                       width: 80,
                       height: 40,

                       decoration: BoxDecoration(
                         color:  language=="2" ?   Color(0xff392156) :Colors.white,
                         /*  image: const DecorationImage(
                                  image: NetworkImage(
                                      'https://media.geeksforgeeks.org/wp-content/cdn-uploads/logo.png'),
                                ),*/
                         border: Border.all(
                             color: language=="2" ? const Color(0xff392156):Color(0xFFD6D6D6),
                             width: 1.0,
                             style:
                             BorderStyle.solid), //Border.all
                         /*** The BorderRadius widget  is here ***/
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(0),
                           topRight: Radius.circular(30),
                           bottomLeft: Radius.circular(0),
                           bottomRight: Radius.circular(30),
                         ), //BorderRadius.all
                       ),
                       child: Center(
                         child: Row(
                           children: [
                             SizedBox(
                               width: 5,
                             ),
                             Icon(
                               Icons.check,
                               color: Colors.white,
                               size: 20,
                             ),
                             SizedBox(
                               width: 3,
                             ),
                             InkWell(

                             child: Text(
                               "العربية",
                               style: TextStyle(
                                 color: language=="2"? Colors.white:Color(0xFF1C1B1F),
                                 fontSize: 14,
                                 fontWeight: FontWeight.normal,
                               ),
                             ),
                             onTap: () async {

                               print('its me arabic in english mode');
                               setState(() {
                                 language="2";
                               });
                             },
                           ),
                       ]
                         ),
                       ), //BoxDecoration
                     )
                         : Container(
                       width: 80,
                       height: 40,

                       decoration: BoxDecoration(
                         color:  language=="1" ?   Color(0xff392156) :Colors.white,

                         border: Border.all(
                             color: language=="1" ? const Color(0xff392156):Color(0xFFD6D6D6),
                             width: 1.0,
                             style:
                             BorderStyle.solid), //Border.all
                         /*** The BorderRadius widget  is here ***/
                         borderRadius: BorderRadius.only(
                           topLeft: Radius.circular(30),
                           topRight: Radius.circular(0),
                           bottomLeft: Radius.circular(30),
                           bottomRight: Radius.circular(0),
                         ), //BorderRadius.all
                       ),
                       child: Center(

                         child: Row(
                           children:[
                             SizedBox(
                               width: 5,
                             ),
                             Icon(
                               Icons.check,
                               color: Colors.white,
                               size: 20,
                             ),
                             SizedBox(
                               width: 3,
                             ),

                             InkWell(
                             child: Text(
                               "English",
                               style: TextStyle(
                                 color:  language=="1" ?  Colors.white: Color(0xFF1C1B1F),
                                 fontSize: 13,
                                 fontWeight: FontWeight.normal,
                               ),
                             ),
                             onTap: () async {
                               Navigator.pushReplacement(
                                 context,
                                 MaterialPageRoute(
                                   builder: (context) => IVRLanguage(PermessionCorporate, role, searchID, searchValue, customerNumber, msisdn, data, searchCraretia),
                                 ),
                               );
                               setState(() {
                                 language="1";
                               });
                             },
                           ),

                           ]

                         ),
                       ), //BoxDecoration
                     ),
                   ]),
                 ),

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

                submitIVRLanguage_API();
              },
            ),
          ),

        ),
      ),

      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////




    );
  }
}