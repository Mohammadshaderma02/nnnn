import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';

//import '/../360View.dart';




class Ledger extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  Ledger(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _LedgerState createState() =>
      _LedgerState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _LedgerState extends State<Ledger> {
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
  bool checkData =false;
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool emptyfromDate = false;
  bool emptytoDate = false;
  bool isLoading =false;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  String value =null;
  bool emptyOption=false;
  List InvoicesList=[];
  List AllTransactions=[];
  List OnlinePayments=[];
  List BillingPayments=[];
  _LedgerState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);

  var FreeUnitsHistory=[];


  final items =[
    "Balance.BillingPayments".tr().toString(),
    "Balance.OnlinePayments".tr().toString(),
    "Balance.CustomerInvoices".tr().toString(),
    "Balance.AllTransactions".tr().toString()];



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


    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }

    //disableCapture();
   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
    //iosSecureScreenShotChannel.invokeMethod("unSecureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }

  Widget PaymentMethodOptions(){
    return
      Expanded(child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10,vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            //color: Color(0xFFB10000), red color
            color:emptyOption == true
                ? Color(0xFFB10000)
                : Color(0xFFD1D7E0),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            hint: Text(
              "Personal_Info_Edit.select_an_option".tr().toString(),
              style: TextStyle(
                color: Color(0xFFA4B0C1),
                fontSize: 14,
              ),
            ),
            //dropdownColor: Colors.white,
            //icon: Icon(Icons.keyboard_arrow_down_rounded),
            //  iconSize: 30,
            // isExpanded: true,
            value: value,
            items: items.map(buildMenuItem).toList(),
            onChanged: (value)=>setState(()=>this.value=value),
          ),
        )
    ))

    ;
  }

  DropdownMenuItem<String> buildMenuItem(String item) => DropdownMenuItem(
    value: item,
    child: Text(
      item,
      style: TextStyle(fontSize: 16),
    ),
  );

  Widget buildSearchBtn() {

    return Padding(
      padding: const EdgeInsets.only(left:16.0,right: 16.0,top: 16.0,bottom: 8),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: () {
              if(fromDate.text!=''  && toDate.text!=''&& value!=null ) {
                if(value== "Balance.BillingPayments".tr().toString()){
                  print(value);
                  getCustomersBillingPayments_API();
                }
                if(value=="Balance.OnlinePayments".tr().toString()){
                  print(value);
                  getCustomersOnlinePayments_API ();

                }
                if(value=="Balance.CustomerInvoices".tr().toString()){
                  print(value);
                  getCustomerInvoicesList_API ();
                }
                if(value=="Balance.AllTransactions".tr().toString()){
                  print(value);
                  getCustomerBillingAllTransactions_API ();
                }
              }else{
                if(fromDate.text == ''){
                  setState(() {
                    emptyfromDate=true;
                  });
                }
                if(toDate.text == ''){
                  setState(() {
                    emptytoDate=true;
                  });
                }
                if( value==null){
                  setState(() {
                    emptyOption=true;
                  });
                }
              }

            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search,color: Colors.white,),
                SizedBox(width: 10,),
                Text(
                  "adjustmentLogsViews.search".tr().toString(),
                  style: TextStyle(
                      color: Colors.white,
                      letterSpacing: 0,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ],
            )
        ),
      ),
    );
  }

  Widget buildFromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "adjustmentLogsViews.from".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),

          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,

          width:MediaQuery.of(context).size.width/2,
          child: TextField(
            controller: fromDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color:     Color(0xFF656565), ),
            decoration: new InputDecoration(
              enabledBorder: emptyfromDate == true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              ): const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),

              suffixIcon: Container(

                child: IconButton(
                    icon: new Image.asset("assets/images/calendar_month.png"),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year-25,),
                        lastDate:DateTime(DateTime.now().year+25,),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF392156), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface:     Color(0xFF656565), // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary:
                                  Color(0xFF392156), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((fromData) => {

                          setState(() {
                        from = fromData;
                        fromDate.text =
                        "${fromData.day.toString().padLeft(2, '0')}/${fromData.month.toString().padLeft(2, '0')}/${fromData.year.toString()}";
                      }
                      ),
                    });
                    }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        emptytoDate
            ? RequiredFeild(
            text: "Reports.this_feild_is_required"
                .tr()
                .toString())
            : Container(),
      ],
    );
  }

  Widget buildToDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "adjustmentLogsViews.to".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),

          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,

          width:MediaQuery.of(context).size.width/2,
          child: TextField(
            controller: toDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color:     Color(0xFF656565), ),
            decoration: new InputDecoration(
              enabledBorder: emptytoDate == true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              ):const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF392156), width: 1.0),
              ),

              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/calendar_month.png"),
                    onPressed: fromDate == ''
                        ? null
                        : () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year-25,),
                        lastDate:DateTime(DateTime.now().year+25,),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF392156), // header background color
                                onPrimary:
                                Colors.white, // header text color
                                onSurface:
                                Color(0xFF656565), // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary: Color(
                                      0xFF392156), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((toData) => {
                          setState(() {
                        to = toData;
                        toDate.text =
                        "${toData.day.toString().padLeft(2, '0')}/${toData.month.toString().padLeft(2, '0')}/${toData.year.toString()}";
                      }),
                    });
                    }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),

        emptyfromDate
            ? RequiredFeild(
            text: "Reports.this_feild_is_required"
                .tr()
                .toString())
            : Container(),
      ],
    );
  }

  getCustomersBillingPayments_API ()async{
    print('caled');
    if(fromDate.text!=''  && toDate.text!=''&& value!=null ) {

      setState(() {
        isLoading=true;
      });
      print('called');
      if (fromDate.text != '' && toDate.text != '' && value!=null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL +
            '/Customer360/getCustomersBillingPayments';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);
        Map body = {
          "customerID": customerNumber,
          //customerNumber,
          "fromDate": from.toIso8601String(),
          "toDate": to.toIso8601String()
        };
        final response = await http.post(url, headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        }, body: json.encode(body),);

        int statusCode = response.statusCode;
        var data = response.request;
        print(statusCode);
        print(json.encode(body));
        print(response);
        print('body: [${response.body}]');
        if (statusCode == 500) {
          print('500  error ');
        }
        if (statusCode == 401) {
          print('401  error ');
          UnotherizedError();
        }

        if (statusCode == 200) {


          var result = json.decode(response.body);
          print('heelo');
          print(result);
          print('heelo');


          setState(() {
            isLoading=false;

          });
          if( result["status"]==0){
            if(result["data"]==null||result["data"].length==0){
              showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

            }else{

              setState(() {
                BillingPayments=result["data"];
                isLoading=false;
                checkData=true;
                emptyfromDate=false;
                emptytoDate=false;
                emptyOption=false;
              });

            }
          print("getCustomersBillingPayments");
          }else{
            showAlertDialogERROR(context,result["messageAr"], result["message"]);


          }




          return result;
        }else{
          showAlertDialogOtherERROR(context,statusCode, statusCode);


        }

      }
    }
    else{
      if(fromDate.text == ''){
        setState(() {
          emptyfromDate=true;
        });
      }
      if(toDate.text == ''){
        setState(() {
          emptytoDate=true;
        });
      }
      if( value==null){
        setState(() {
          emptyOption=true;
        });
      }
    }
  }

  getCustomersOnlinePayments_API ()async{
    print('caled');
    if(fromDate.text!=''  && toDate.text!=''&& value!=null ) {

      setState(() {
        isLoading=true;
      });
      print('called');
      if (fromDate.text != '' && toDate.text != '' && value!=null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL +
            '/Customer360/getCustomersOnlinePayments';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);
        Map body = {

          "customerIDA":customerNumber,

          "customerIDB":"",

          "msisdnA":"",

          "msisdnB":"",

          //customerNumber,
          "fromDate": from.toIso8601String(),
          "toDate": to.toIso8601String()
        };
        final response = await http.post(url, headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        }, body: json.encode(body),);

        int statusCode = response.statusCode;
        var data = response.request;
        print(statusCode);
        print(json.encode(body));
        print(response);
        print('body: [${response.body}]');
        if (statusCode == 500) {
          print('500  error ');
        }
        if (statusCode == 401) {
          print('401  error ');
          UnotherizedError();
        }

        if (statusCode == 200) {


          var result = json.decode(response.body);
          print('heelo');
          print(result);
          print('heelo');


          setState(() {
            isLoading=false;

          });
          if( result["status"]==0){
            if(result["data"]==null||result["data"].length==0){
              showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

            }else{

              setState(() {
                OnlinePayments=result["data"];
                isLoading=false;
                checkData=true;
              });

            }
            print("getCustomersOnlinePayments");
          }else{
            showAlertDialogERROR(context,result["messageAr"], result["message"]);


          }




          return result;
        }else{
          showAlertDialogOtherERROR(context,statusCode, statusCode);


        }

      }
    }
    else{
      if(fromDate.text == ''){
        setState(() {
          emptyfromDate=true;
        });
      }
      if(toDate.text == ''){
        setState(() {
          emptytoDate=true;
        });
      }
      if( value==null){
        setState(() {
          emptyOption=true;
        });
      }
    }
  }

  getCustomerBillingAllTransactions_API ()async{
    print('caled');
    if(fromDate.text!=''  && toDate.text!=''&& value!=null ) {

      setState(() {
        isLoading=true;
      });
      print('called');
      if (fromDate.text != '' && toDate.text != '' && value!=null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL +
            '/Customer360/getCustomerBillingAllTransactions';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);
        Map body = {




          "customerID": customerNumber,
          //customerNumber,
          "msisdn":"",
          "fromDate": from.toIso8601String(),
          "toDate": to.toIso8601String()
        };
        final response = await http.post(url, headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        }, body: json.encode(body),);

        int statusCode = response.statusCode;
        var data = response.request;
        print(statusCode);
        print(json.encode(body));
        print(response);
        print('body: [${response.body}]');
        if (statusCode == 500) {
          print('500  error ');
        }
        if (statusCode == 401) {
          print('401  error ');
          UnotherizedError();
        }

        if (statusCode == 200) {


          var result = json.decode(response.body);
          print('heelo');
          print(result);
          print('heelo');


          setState(() {
            isLoading=false;

          });
          if( result["status"]==0){
            if(result["data"]==null||result["data"].length==0){
              showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

            }else{

              setState(() {
                AllTransactions=result["data"];
                isLoading=false;
                checkData=true;
                emptyfromDate=false;
                emptytoDate=false;
                emptyOption=false;
              });

            }
            print("getCustomerBillingAllTransactions");
          }else{
            showAlertDialogERROR(context,result["messageAr"], result["message"]);


          }




          return result;
        }else{
          showAlertDialogOtherERROR(context,statusCode, statusCode);


        }

      }
    }
    else{
      if(fromDate.text == ''){
        setState(() {
          emptyfromDate=true;
        });
      }
      if(toDate.text == ''){
        setState(() {
          emptytoDate=true;
        });
      }
      if( value==null){
        setState(() {
          emptyOption=true;
        });
      }
    }
  }

  getCustomerInvoicesList_API ()async{
    print('caled');
    if(fromDate.text!=''  && toDate.text!=''&& value!=null ) {
     
      setState(() {
        isLoading=true;
      });
      print('called');
      if (fromDate.text != '' && toDate.text != '' && value!=null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL +
            '/Customer360/getCustomerInvoicesList';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);
        Map body = {

          "customerID": customerNumber,
          "msisdn": msisdn,
          //customerNumber,
          "fromDate": from.toIso8601String(),
          "toDate": to.toIso8601String()
        };
        final response = await http.post(url, headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken")
        }, body: json.encode(body),);

        int statusCode = response.statusCode;
        var data = response.request;
        print(statusCode);
        print(json.encode(body));
        print(response);
        print('body: [${response.body}]');
        if (statusCode == 500) {
          print('500  error ');
        }
        if (statusCode == 401) {
          print('401  error ');
          UnotherizedError();
        }

        if (statusCode == 200) {


          var result = json.decode(response.body);
          print('heelo');
          print(result);
          print('heelo');


          setState(() {
            isLoading=false;

          });
          if( result["status"]==0){
            if(result["data"]==null||result["data"].length==0){
              showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

            }else{

              setState(() {
                InvoicesList=result["data"];
                isLoading=false;
                checkData=true;
                emptyfromDate=false;
                emptytoDate=false;
                emptyOption=false;
              });

            }
            print("getCustomerInvoicesList");
          }else{
            showAlertDialogERROR(context,result["messageAr"], result["message"]);


          }




          return result;
        }else{
          showAlertDialogOtherERROR(context,statusCode, statusCode);


        }

      }
    }
    else{
      if(fromDate.text == ''){
        setState(() {
          emptyfromDate=true;
        });
      }
      if(toDate.text == ''){
        setState(() {
          emptytoDate=true;
        });
      }
      if( value==null){
        setState(() {
          emptyOption=true;
        });
      }
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
        setState(() {
          checkData=false;
          InvoicesList=[];
          AllTransactions=[];
          OnlinePayments=[];
          BillingPayments=[];
          emptyfromDate=false;
          emptytoDate=false;
          emptyOption=false;
        });
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
            setState(() {
              checkData=false;
              InvoicesList=[];
              AllTransactions=[];
              OnlinePayments=[];
              BillingPayments=[];
              emptyfromDate=false;
              emptytoDate=false;
              emptyOption=false;
            });
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
        setState(() {
          InvoicesList=[];
          AllTransactions=[];
          OnlinePayments=[];
          BillingPayments=[];
        });
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
            setState(() {

              InvoicesList=[];
              AllTransactions=[];
              OnlinePayments=[];
              BillingPayments=[];
            });
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


  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
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
            //   logoutBloc.add(LogoutButtonPressed(
            //   ));
            Navigator.pop(context);
          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
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




  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);

      /* Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Customer360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,"Customer Number"),
        ),
      );*/
      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: onWillPop,
      child: GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF392156),
            title: Text("Balance.Ledger".tr().toString()),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.pop(context);
                /*Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Customer360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,"Customer Number"),
                  ),
                );*/
              },
            ),
          ),
          backgroundColor: Color(0xFFEBECF1),

          body: role == "Corporate"
              ? ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: 8, left: 0, right: 0),
            children: [

              Container(
                color: Colors.transparent ,
                width: double.infinity,
                height: MediaQuery.of(context).size.height/3 *1.9,

                // margin: EdgeInsets.all(12),
                child: isLoading==true?
                Container(
                    width: double.infinity,
                    padding: EdgeInsets.only(left: 26, right: 26,top: 30),
                    // margin: EdgeInsets.all(12),
                    margin: EdgeInsets.only(top: 20),
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

                    )):
                checkData==true? value=="Balance.CustomerInvoices".tr().toString()?
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child:

                  ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                    itemCount: InvoicesList.length,
                    itemBuilder: (BuildContext context, int index) {
                      //   itemCount :  UserList.length,
                      return  Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                        // margin: EdgeInsets.all(12),

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
                                        Text(
                                          "Balance.Date"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text("Not Receved",
                                          //InvoicesList[index]['entryDate']!=null|| InvoicesList[index]['entryDate'].length==0?InvoicesList[index]['entryDate']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
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
                                        Text(
                                          "Balance.Amount"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          InvoicesList[index]['amount']!=null|| InvoicesList[index]['amount'].length==0?InvoicesList[index]['amount']:'-',

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
                                        Text(
                                          "Balance.transactionType"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          InvoicesList[index]['transactionType']!=null|| InvoicesList[index]['transactionType'].length==0?InvoicesList[index]['transactionType']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
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
                                        Text(
                                          "Balance.InvoiceNumber"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          InvoicesList[index]['invoiceNumber']!=null|| InvoicesList[index]['invoiceNumber'].length==0?InvoicesList[index]['invoiceNumber']:'-',

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

                ):value=="Balance.BillingPayments".tr().toString()?
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child:

                  ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                    itemCount: BillingPayments.length,
                    itemBuilder: (BuildContext context, int index) {
                      //   itemCount :  UserList.length,
                      return  Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                        // margin: EdgeInsets.all(12),

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
                                        Text(
                                          "Balance.paymentDate"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          BillingPayments[index]['paymentDate']!=null|| BillingPayments[index]['paymentDate'].length==0?BillingPayments[index]['paymentDate']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
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
                                        Text(
                                          "Balance.paymentAmount"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          BillingPayments[index]['paymentAmount']!=null|| BillingPayments[index]['paymentAmount'].length==0?BillingPayments[index]['paymentAmount']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
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
                                        Text(
                                          "Balance.paymentTransactionType"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          BillingPayments[index]['paymentTransactionType']!=null|| BillingPayments[index]['paymentTransactionType'].length==0?BillingPayments[index]['paymentTransactionType']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
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
                                        Text(
                                          "Balance.paymentReference"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          BillingPayments[index]['paymentReference']!=null|| BillingPayments[index]['paymentReference'].length==0?BillingPayments[index]['paymentReference']:'-',

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

                )
                    :value=="Balance.OnlinePayments".tr().toString()?  Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child:

                  ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                    itemCount: OnlinePayments.length,
                    itemBuilder: (BuildContext context, int index) {
                      //   itemCount :  UserList.length,
                      return  Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                        // margin: EdgeInsets.all(12),

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
                                        Text(
                                          "Balance.paymentDate"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          OnlinePayments[index]['paymentDate']!=null|| OnlinePayments[index]['paymentDate'].length==0?OnlinePayments[index]['paymentDate']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
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
                                        Text(
                                          "Balance.paymentAmount"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          OnlinePayments[index]['paymentAmount']!=null|| OnlinePayments[index]['paymentAmount'].length==0?OnlinePayments[index]['paymentAmount']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
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
                                        Text(
                                          "Balance.paymentTransactionType"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          OnlinePayments[index]['paymentTransactionType']!=null|| OnlinePayments[index]['paymentTransactionType'].length==0?OnlinePayments[index]['paymentTransactionType']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
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
                                        Text(
                                          "Balance.paymentReference"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          OnlinePayments[index]['paymentReference']!=null|| OnlinePayments[index]['paymentReference'].length==0?OnlinePayments[index]['paymentReference']:'-',

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

                ):
                value=="Balance.AllTransactions".tr().toString()?
                Container(
                  padding: EdgeInsets.only(left: 10, right: 10),
                  child:

                  ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                    itemCount: AllTransactions.length,
                    itemBuilder: (BuildContext context, int index) {
                      //   itemCount :  UserList.length,
                      return  Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white
                        ),
                        margin: EdgeInsets.only(bottom: 15),
                        padding: EdgeInsets.only(left: 26, right: 26,bottom: 20),
                        // margin: EdgeInsets.all(12),

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
                                        Text(
                                          "Balance.paymentDate"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          AllTransactions[index]['paymentDate']!=null|| AllTransactions[index]['paymentDate'].length==0?AllTransactions[index]['paymentDate']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
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
                                        Text(
                                          "Balance.paymentAmount"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          AllTransactions[index]['paymentAmount']!=null|| AllTransactions[index]['paymentAmount'].length==0?AllTransactions[index]['paymentAmount']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
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
                                        Text(
                                          "Balance.paymentTransactionType"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          AllTransactions[index]['paymentTransactionType']!=null|| AllTransactions[index]['paymentTransactionType'].length==0?AllTransactions[index]['paymentTransactionType']:'-',

                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14.0,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(width: 10),
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
                                        Text(
                                          "Balance.paymentReference"
                                              .tr()
                                              .toString(),
                                        ),
                                        SizedBox(height: 1),
                                        Text(
                                          AllTransactions[index]['paymentReference']!=null|| AllTransactions[index]['paymentReference'].length==0?AllTransactions[index]['paymentReference']:'-',

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

                ):
                Container(
                    color: Colors.transparent
                ):Container(
                    color: Colors.transparent
                ),
              ),









              ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
            ],
          )
              : Center(
            child: Text(role),
          ),


          bottomNavigationBar: BottomAppBar(
            child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Color(0xFFEBECF1),

                ),
                child: SingleChildScrollView(
                  child:Column(
                    children: [
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.only(left: 20,right: 20,bottom: 10),
                        child:
                        Row(children: [
                          RichText(
                            text: TextSpan(
                              text:
                              "Balance.SelectPaymentMethod".tr().toString(),
                              style: TextStyle(
                                color: Color(0xff11120e),
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),


                        ],),
                      ),

                      Container(
                        padding: EdgeInsets.only(left: 20,right: 20,bottom: 5),
                        child:
                        Row(children: [
                          PaymentMethodOptions()

                        ],),
                      ),
                      Container(
                        padding: EdgeInsets.only(left: 20,right: 20,bottom: 5),
                        child:
                        Row(children: [
                          emptyOption? RequiredFeild(
                              text: "Reports.this_feild_is_required"
                                  .tr()
                                  .toString())
                              : Container(),

                        ],),
                      ),
                      Container(

                        padding: EdgeInsets.only(left: 20,right: 20,top: 10),

                        child:
                        Row(children: [
                          Expanded(child: buildFromDate()),
                          SizedBox(width: 20,),
                          Expanded(child: buildToDate())
                        ],),
                      ),
                      SizedBox(height: 8,),
                      buildSearchBtn()
                    ],
                  ),
                )
            ),
          ),


        ),
      ),
    );

  }
}




