import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/AdjustmentLogs.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillShock.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillingDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/BlineLedger.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/OnlineChargingvalues.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/PresetRisk.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Promotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/VPNDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';


class AuthorizedContractors extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  AuthorizedContractors(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _AuthorizedContractorsState createState() =>
      _AuthorizedContractorsState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

APP_URLS urls = new APP_URLS();

class _AuthorizedContractorsState extends State<AuthorizedContractors> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  DateTime backButtonPressedTime;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  var CustomerContactsData=[];

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  bool isLoading = true;
  ///////////////////////variable from API//////////////////////////////////////
  bool checkData=false;
  String customerUnbillidAirTime;
  String subscriberUnbillidAirTime;
  String unbillidCustomerHSPATopupView;
  String unbilledSubscriberHSPATopUpView;
  String unbilledFeaturesAmount;
  String blineCreditBalance;
  String dataBalance;

  bool emptymsisdn=false;
  bool errormsisdn=false;

  bool emptyContactName=false;
  bool errorContactName=false;

  bool emptyContactType=false;
  bool errorContactType=false;

  bool emptyOnlyContact=false;
  bool errorOnlyContact=false;
  ///////////////////////End variable from API/////////////////////////////////

  TextEditingController tawasol_number = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();
  TextEditingController MSISDN = TextEditingController();
  TextEditingController ContactName = TextEditingController();
  TextEditingController ContactType = TextEditingController();
  TextEditingController OnlyContact = TextEditingController();


  _AuthorizedContractorsState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);





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
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{
      CustomerAuthorityContacts_API ();
    }
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    //disableCapture();
    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }


  CustomerAuthorityContacts_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": customerNumber,
      "msisdn": "",
      "authorizeClassificationCode": ""
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getCustomerAuthorityContacts';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
      //showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
      setState(() {
        isLoading =false;
      });

    }
    if (statusCode == 200) {

      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('-------------------------------');
      print(result["data"]);
      if(result["data"]==null){
        showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

        setState(() {
          checkData=true;
        });
      }
      if( result["status"]==0){
        CustomerContactsData=result["data"]["authorizedInfo"];
        print(CustomerContactsData.length);
        setState(() {
          isLoading =false;
        });

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoading =false;
        });

      }


      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL +'/Customer360/getCustomerAuthorityContacts');

      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }


  createContactPerson_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerNumber": this.customerNumber,
      "contactMSISDN": MSISDN.text,
      "contactName": ContactName.text,
      "type":int.parse(ContactType.text) ,
      "onlyContact": int.parse(OnlyContact.text),
      "remarks": ""
    };





    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/createContactPerson';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
     // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
      setState(() {
        isLoading =false;
      });
      CustomerAuthorityContacts_API();
    }
    if (statusCode == 200) {

      print("yes");
      var result = json.decode(response.body);
      print(result);
      print('-------------------------------');
      print(result["data"]);
      if(result["data"]==null){
       // showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

        setState(() {
          checkData=true;
        });
      }
      if (result["status"] == 0) {
        if (result["data"] == null || result["data"].length == 0) {
          showAlertDialogNoData(context, "لا توجد بيانات متاحة الآن.",
              "No data available now .");
          setState(() {
            isLoading =false;
          });
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => AuthorizedContractors(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
            ),
          );
        } else {
          CustomerContactsData=result["data"]["authorizedInfo"];
          print(CustomerContactsData.length);
            setState(() {
              isLoading =false;
          });
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AuthorizedContractors(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
              ),
            );
        }

      }
 else{
        showAlertDialogAddContactERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoading =false;
        });
       // CustomerAuthorityContacts_API();

      }


      print('-------------------------------');
      print('Sucses API');
      print(urls.BASE_URL +'/Customer360/createContactPerson');

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
            CustomerAuthorityContacts_API();
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

  showAlertDialogAddContactERROR(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF392156),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        //Navigator.of(context).pop();
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
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AuthorizedContractors(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
              ),
            );
           // CustomerAuthorityContacts_API();
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
/*****************************************Content of add contact dialog ********************************/
  Widget buildContactMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Authorized.ContactMSISDN".tr().toString(),
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
              color: emptymsisdn==true || errormsisdn==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptymsisdn || errormsisdn? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: MSISDN,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptymsisdn  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
        errormsisdn == true
            ? RequiredFeild(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? "Mobile Number shoud be 10 digits"+'\n'+"start with 079"
                : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),
      ],
    );
  }

  Widget buildContactName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Authorized.ContactName".tr().toString(),
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
              color: emptyContactName==true || errorContactName==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyContactName || errorContactName? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: ContactName,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyContactName == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
       /* errorContactName == true
            ? RequiredFeild(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? "Mobile Number shoud be 10 digits"+'\n'+"start with 079"
                : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),*/
      ],
    );
  }

  Widget buildContactType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Authorized.ContactType".tr().toString(),
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
              color: emptyContactType==true || errorContactType==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyContactType || errorContactType? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: ContactType,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyContactType == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
        /* errorContactType == true
            ? RequiredFeild(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? "Mobile Number shoud be 10 digits"+'\n'+"start with 079"
                : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),*/
      ],
    );
  }

  Widget buildOnlyContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Authorized.OnlyContact".tr().toString(),
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
              color: emptyOnlyContact==true || errorOnlyContact==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyOnlyContact || errorOnlyContact? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: OnlyContact,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyOnlyContact == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
        /* errorContactType == true
            ? RequiredFeild(
            text: EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? "Mobile Number shoud be 10 digits"+'\n'+"start with 079"
                : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),*/
      ],
    );
  }

  /*****************************************Content of add contact dialog ********************************/
  Future<void> _showFilterDialog() async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,

      builder: (BuildContext context) {

        return AlertDialog(
          content:
          Container(

           // padding: EdgeInsets.only(bottom: 0),
            child: SingleChildScrollView(
              child:Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text("Authorized.CreateContactPerson".tr().toString(),
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0,
                      )),
                  SizedBox(height: 20,),
                  buildContactMSISDN(),
                  SizedBox(height: 10,),
                  buildContactName(),
                  SizedBox(height: 10,),
                  buildContactType(),
                  SizedBox(height: 10,),
                  buildOnlyContact(),
                  SizedBox(height: 15,),



                ],
              ) ,
            )
          ),
          actions: <Widget>[
            SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 5,bottom: 20),
                        width: 110,
                        height: 40,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              MSISDN.text='';
                              ContactName.text='';
                              ContactType.text='';
                              OnlyContact.text='';

                              emptymsisdn=false;
                              errormsisdn=false;
                              emptyContactName=false;
                              errorContactName=false;
                              emptyContactType=false;
                              errorContactType=false;
                              emptyOnlyContact=false;
                              errorOnlyContact=false;

                              isLoading=false;

                            });
                          //  CustomerAuthorityContacts_API();
                            //Navigator.of(context).pop();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStatePropertyAll<Color>(
                                Color(0xffE9E9E9)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                                side: BorderSide(
                                  width: 1,
                                  color: Color(0xffE9E9E9),
                                ),
                              ),
                            ),
                          ),
                          child: Text("corpAlert.cancel".tr().toString(),
                              style: TextStyle(
                                color: Colors.black,
                              )),
                        ),
                      ),

                      //SizedBox(width: 4.0),

                      Container(
                          width: 125,
                          height: 40,
                          margin: EdgeInsets.only(left: 5, right: 15,bottom: 20),
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color(0xFF0E7074),
                              padding: EdgeInsets.all(10.0),
                              shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(30.0),
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

                          Text("Authorized.Add".tr().toString()),


                            onPressed: () async {

                              if(isLoading) return;
                              setState(() {
                                isLoading =true;});
                              //Navigator.pop(context);
                              //getSubscriberList_API(page);
                              if (MSISDN.text == "") {
                                setState(() {
                                  emptymsisdn = true;
                                });
                                Navigator.pop(context);
                                _showFilterDialog();
                              }
                              if (MSISDN.text != "") {
                                if (MSISDN.text.length == 10) {
                                  if (MSISDN.text.substring(0, 3) == '079') {
                                    setState(() {
                                      errormsisdn = false;
                                      emptymsisdn = false;
                                    });

                                  }
                                  else {
                                    setState(() {
                                      errormsisdn = true;
                                      emptymsisdn = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    errormsisdn = true;
                                    emptymsisdn = false;
                                  });
                                }
                              }
                              if (ContactName.text == "") {
                                setState(() {
                                  emptyContactName = true;
                                });

                              }
                              if (ContactType.text == "") {
                                setState(() {
                                  emptyContactType = true;
                                });

                              }
                              if (OnlyContact.text == "") {
                                setState(() {
                                  emptyOnlyContact = true;
                                });

                              }
                              if (OnlyContact.text != ""&& ContactType.text != "" && ContactName.text != "" && (MSISDN.text != ""&& MSISDN.text.length == 10 &&MSISDN.text.substring(0, 3) == '079')) {

                                setState(() {
                                  emptymsisdn = false;
                                  emptyContactName=false;
                                  emptyContactType = false;
                                  emptyOnlyContact = false;
                                });
                                createContactPerson_API();
                                Navigator.pop(context);
                              }



                            },
                          )

                      )


                    /*  Container(
                          width: 125,
                          height: 40,
                          margin: EdgeInsets.only(left: 5, right: 15,bottom: 20),
                          child: ElevatedButton(
                            onPressed: () {
                              //Navigator.pop(context);
                              //getSubscriberList_API(page);
                              if (MSISDN.text == "") {
                                setState(() {
                                  emptymsisdn = true;
                                });
                                Navigator.pop(context);
                                _showFilterDialog();
                              }
                              if (MSISDN.text != "") {
                                if (MSISDN.text.length == 10) {
                                  if (MSISDN.text.substring(0, 3) == '079') {
                                    setState(() {
                                      errormsisdn = false;
                                      emptymsisdn = false;
                                    });

                                  }
                                  else {
                                    setState(() {
                                      errormsisdn = true;
                                      emptymsisdn = false;
                                    });
                                  }
                                } else {
                                  setState(() {
                                    errormsisdn = true;
                                    emptymsisdn = false;
                                  });
                                }
                              }
                              if (ContactName.text == "") {
                                setState(() {
                                  emptyContactName = true;
                                });

                              }
                                if (ContactType.text == "") {
                                setState(() {
                                  emptyContactType = true;
                                });

                              }
                                if (OnlyContact.text == "") {
                                setState(() {
                                  emptyOnlyContact = true;
                                });

                              }
                                if (OnlyContact.text != ""&& ContactType.text != "" && ContactName.text != "" && (MSISDN.text != ""&& MSISDN.text.length == 10 &&MSISDN.text.substring(0, 3) == '079')) {

                                setState(() {
                                  emptymsisdn = false;
                                  emptyContactName=false;
                                  emptyContactType = false;
                                  emptyOnlyContact = false;
                                });
                                createContactPerson_API();
                                Navigator.pop(context);
                              }
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  Color(0xff0E7074)),
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30.0),
                                  side: BorderSide(
                                      width: 1, color: Color(0xff0E7074)),
                                ),
                              ),
                            ),
                            child: Text("Authorized.Add".tr().toString()),
                          ))*/
                      // button 2
                    ])),
          ],
        );
      },
    );
  }



  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BlineLedger(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
              title: Text("Authorized.AuthorizedContractors".tr().toString()),
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
              ), //<Widget>[]


            ),
            backgroundColor: Color(0xFFEBECF1),

            body: role == "Corporate"
                ? ListView(
              shrinkWrap: true,
              physics: ClampingScrollPhysics(),
              padding: EdgeInsets.only(top: 8, left: 0, right: 0),
              children: [
                isLoading==true?    Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 26, right: 26,top: 60),
                    // margin: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 60),
                    child:Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          child: CircularProgressIndicator(color: Color(0xFF392156) ),
                          height: 20.0,
                          width: 20.0,
                        ),
                        SizedBox(width: 24),
                        Text("corporetUser.PleaseWait".tr().toString(),
                          style: TextStyle(fontWeight: FontWeight.bold, color:Color(0xFF392156),fontSize: 16 ),)],

                    )): checkData==true?Container():
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child:
                  ListView.builder(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                    itemCount: CustomerContactsData.length,
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
                                          height: 20,
                                        ),
                                        Text("Authorized.MSISDN".tr().toString()),
                                        SizedBox(height: 1),
                                        Text(
                                          CustomerContactsData[index]['msisdn'].toString().substring(0,10)??'-',
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
                                    margin: EdgeInsets.only(left: 5, right: 5),
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: 20,
                                        ),
                                        Text("Authorized.EntryDate".tr().toString()),

                                        SizedBox(height: 1),
                                        Text(CustomerContactsData[index]['entryDate'] ??'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),


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
                                          height: 20,
                                        ),
                                        Text("Authorized.EntryUser".tr().toString()),

                                        SizedBox(height: 1),
                                        Text(CustomerContactsData[index]['entryUser']??'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),


                              ],
                            )
                            ,
                            SizedBox(
                              height: 5,
                            ),


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
                                          height: 20,
                                        ),
                                        Text("Authorized.AuthorizedName".tr().toString()),

                                        SizedBox(height: 1),
                                        Text(CustomerContactsData[index]['authorizedName']??'-',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      SizedBox(
                      height: 5,
                      ),


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
                      height: 20,
                      ),
                      Text("Authorized.AuthorizedClassification".tr().toString()),

                      SizedBox(height: 1),
                      Text(CustomerContactsData[index]['authorizeClassification']??'-',
                      style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0,
                      ),
                      ),
                      ],
                      ),
                      ),
                      ),
                      ],
                      ),
                            SizedBox(
                              height: 5,
                            ),
                          ],
                        ),
                      );


                    },
                  ),

                ),

               /* Stack(children: [
                  Positioned(
                    bottom: ,
                    child:Text("haya hazaimeh") ,
                  )
                ],),*/


               /* Container(
                  width: 200,
                  height: 90,
                  child: FittedBox(
                    child: FloatingActionButton(
                      onPressed: () { },
                      child: Icon(Icons.edit),
                    ),
                  ),
                )*/
                ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
              ],

            )
                : Center(
              child: Text(role),
            ),

            floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
              height:60,
              width:320,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent),
              child:FloatingActionButton.extended(
                label:  Text("Authorized.AddContact".tr().toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14.0,
                  ),),
                icon: const Icon(Icons.add),
                backgroundColor: Color(0xFF0E7074), //child widget inside this button
               /* shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10))
                ),*/
                onPressed: (){
                  _showFilterDialog();
                  setState(() {
                    MSISDN.text='';
                    ContactName.text='';
                    ContactType.text='';
                    OnlyContact.text='';

                    emptymsisdn=false;
                    errormsisdn=false;
                    emptyContactName=false;
                    errorContactName=false;
                    emptyContactType=false;
                    errorContactType=false;
                    emptyOnlyContact=false;
                    errorOnlyContact=false;

                    isLoading=false;

                  });
                  //task to execute when this button is pressed
                },
              ),
            ),





          ),
        ));
  }
}
