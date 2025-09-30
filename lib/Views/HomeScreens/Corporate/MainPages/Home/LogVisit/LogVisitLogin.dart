/*
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/360View.dart';

import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';

import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria.block.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_events.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/blocs/CorpPart/LookupSearchCriteria/LookupSearchCriteria_events.dart';
import 'package:sales_app/blocs/CorpPart/LookupSearchCriteria/LookupSearchCriteria_state.dart';
import '../../../../../blocs/CorpPart/LookupSearchCriteria/LookupSearchCriteria_block.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'LogVisitMenu.dart';

class LogVisitLogin extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  // String PermessionCorporate;
  String role;

  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];


  LogVisitLogin(this.PermessionCorporate, this.role);
  @override
  _LogVisitLoginState createState() =>
      _LogVisitLoginState(this.PermessionCorporate, this.role);
}

class Item {
  const Item(this.key,this.code,this.value, this.valueAr);
  final key;
  final code;
  final String value;
  final String valueAr;

}
List<Item> SearchCriteria = <Item>[];

class _LogVisitLoginState extends State<LogVisitLogin> {
  List data=[];
  BuildContext dcontext;

  dismissDailog(){
    if(dcontext != null){
      Navigator.pop(dcontext);
    }
  }

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;

  bool emptyUserID=false;
  DateTime backButtonPressedTime;
  bool isLoading = false;
  FocusNode passwordFocusNode;
  bool showPassword = true;
  bool emptyPassword =false;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;

  APP_URLS urls = new APP_URLS();


  TextEditingController UserID = TextEditingController();
  TextEditingController Password = TextEditingController();

  _LogVisitLoginState(this.PermessionCorporate, this.role);
  LookupSearchCriteriaBloc lookupSearchCriteriaBloc;
  SearchCriteriaBloc searchCriteriaBloc;

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
    print(role);


    if(PermessionCorporate==null){
      UnotherizedError();

    }else{


      searchCriteriaBloc = BlocProvider.of<SearchCriteriaBloc>(context);


    }


    LookUpSearchCrateria_API();

    super.initState();
  }

  SearchCrateria_API()async{


    print('called');
    setState(() {
      isLoading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "searchID": searchID,
      "searchValue": searchValue
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/search';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    print('muy status coed');
    print(statusCode);

    if (statusCode == 500) {
      print('500  error ');
    }
    else if (statusCode == 401) {
      print('401  error ');
      print('iam hetee');
      UnotherizedError();
    }

    else if (statusCode == 200) {

      print("iaaaam her");
      var result = json.decode(response.body);

      if( result["status"]==0){
        print('look up');
        print(result['data']);
        if(result["data"]==null ||result["data"].length==0 ){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");
          setState(() {
            isLoading =false;

          });
        }else{





        }

      }
      else{
        setState(() {
          isLoading=false;
        });
        print('hello');
        showAlertDialogERROR(context,result["messageAr"], result["message"]);


      }


      return result;
    }

    else{
      showAlertDialogOtherERROR(context,statusCode.toString(), statusCode.toString());
      setState(() {
        isLoading =false;
      });


    }
  }


  LookUpSearchCrateria_API() async{

    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL +
        '/Lookup/SearchCriteria';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;

    if (statusCode == 500) {
      print('500  error ');
    }
    else if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
    }

    else if (statusCode == 200) {

      var result = json.decode(response.body);

      if( result["status"]==0){
        print('look up');
        print(result);
        if(result["data"]==null||result["data"].length==0){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

        }else{
          setState(() {
            SearchCriteria=[];
          });
          for (var obj in result["data"]) {
            SearchCriteria.add(Item(obj['key'],obj['code'], obj['value'].toString(),
                obj['valueAr'].toString()));
            // emptyVoucherAmount = true;
          }

          setState(() {
            SearchCriteria=SearchCriteria;
          });

        }

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);


      }




      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);


    }
  }


  showAlertDialogERROR(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
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
              color: Color(0xFF4f2565),
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
              color: Color(0xFF4f2565),
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
              color: Color(0xFF4f2565),
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
              color: Color(0xFF4f2565),
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




  Widget buildUserId() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
          text:  "LogVisit.userId".tr().toString(),
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
              color: emptyUserID
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyUserID ?Color(0xFFb10000) : Color(0xFFD1D7E0),
                width: 1,
              )),
          height: 58,
          child: TextField(
            controller: UserID,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }
  Widget buildPassword() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.password".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
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
          alignment: Alignment.centerLeft,
          height: 58,
          decoration: BoxDecoration(
              color: emptyUserID
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyUserID ?Color(0xFFb10000) : Color(0xFFD1D7E0),
                width: 1,
              )),
          child: TextField(
            controller: Password,
            focusNode: passwordFocusNode,
            onTap: () {
              setState(() {
                FocusScope.of(context).unfocus();
                FocusScope.of(context).requestFocus(passwordFocusNode);
              });
            },
            obscureText: showPassword,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),

            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
                suffixIcon: Container(
                  child: IconButton(
                      icon: new Image.asset(showPassword == false
                          ? "assets/images/icon-show.png"
                          : "assets/images/icon-hide.png"),
                      onPressed: () => setState(() {
                        showPassword = !showPassword;
                      })),
                ),
             //   hintText: "Settings_Form.enter_old_password".tr().toString(),

            ),

          ),
        ),
      ],
    );
  }


  Widget buildLoginBtn() {

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

          ):Text("LogVisit.login".tr().toString()),

          onPressed: () async {


            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LogVisitMenu(PermessionCorporate, role, searchID, searchValue, customerNumber, msisdn, data, searchCraretia),
              ),
            );
          },
        )

    );
  }

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {

    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
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
            Navigator.pop(context, 'OK');
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
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showAlertDialogError(BuildContext context,arabicMessage,englishMessage) {
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
  showAlertDialogDataEmpty(BuildContext context,arabicMessage,englishMessage) {
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

  showAlertDialogTokenError(BuildContext context,arabicMessage,englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text("corpAlert.close".tr().toString() ,
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: ()async {

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


  final msg = BlocBuilder<SearchCriteriaBloc, SearchCriteriaState>(builder: (context, state) {
    if (state is SearchCriteriaLoadingState) {
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




  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      showAlertDialog(context, "هل انت متاكد من إغلاق التطبيق",
          "Are you sure to close the application?");
      return true;
    }
    return true;
  }


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          backgroundColor: Color(0xFFEBECF1),


          appBar: AppBar(
            title: Text("LogVisit.Log_Visit".tr().toString()),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.notifications_none),
                onPressed: () {},
              ), //IconButton//IconButton
            ], //<Widget>[]
            backgroundColor: Color(0xFF4f2565),



          ),
          */
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
          ),*//*

          body: role == "Corporate"
              ? Center(
            child: ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: 0, bottom: 20, left: 32, right: 32),
              children: <Widget>[
                Center(
                  child: Image(
                      image: AssetImage('assets/images/login icon.png'),
                      width: 184,
                      height: 184),
                ),
                SizedBox(height: 40),
                buildUserId(),
                emptyUserID == true
                    ? RequiredFeild(
                    text: "corporetUser.Required"
                        .tr()
                        .toString())
                    : Container(),
                SizedBox(height: 25),

                buildPassword(),
                emptyPassword == true
                    ? RequiredFeild(
                    text: "corporetUser.Required"
                        .tr()
                        .toString())
                    : Container(),

                SizedBox(height: 30),
                msg,

                buildLoginBtn(),

                SizedBox(
                  height: 15,
                ),
              ],
            ),
          )
              : Center(
            child: Text(role),
          ),
        ));
  }
}
*/
