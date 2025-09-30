import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/FOCReport/FOCReportDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/RaiseTicket/TicketHistory.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';

import 'package:sales_app/Shared/BaseUrl.dart';



class FOCReport extends StatefulWidget {
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  FOCReport(this.PermessionCorporate, this.role);
  @override
  _FOCReportState createState() => _FOCReportState(this.PermessionCorporate, this.role);
}
APP_URLS urls = new APP_URLS();

class _FOCReportState extends State<FOCReport> {
  // Declare your method channel varibale here
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');
  bool serchByEmptyFlag = false;
  // String PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  String role;
  String customerName;
  String SubscriberNumber;
  String customerID;
  bool FirstContentFlag=false;
  bool checkData =false;
  bool isLoading = false;
  bool emptyfromDate = false;
  bool emptytoDate = false;

  List MenaTracks=[];


  int searchID;
  String searchCraretia;
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool emptymsisdn=false;
  bool errormsisdn=false;
  TextEditingController MSISDN = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();


  DateTime backButtonPressedTime;

  _FOCReportState(this.PermessionCorporate, this.role);


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
    checkPrefs ();
    print("__________________________________________________________________");
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

   // disableCapture();
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

  void checkPrefs ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (prefs.containsKey("customerName")) {
      setState(() {
        customerName=prefs.getString("customerName");
        FirstContentFlag=true;
      });

    }
    if (prefs.containsKey("SubscriberNumber")) {
      setState(() {
        SubscriberNumber=prefs.getString("SubscriberNumber");
        FirstContentFlag=true;
      });
      print("prefs.getString");
      print(prefs.getString("SubscriberNumber"));
    }
    if (prefs.containsKey("customerID")) {
      setState(() {
        customerID=prefs.getString("customerID");
        //FirstContentFlag=true;
      });
      print("prefs.getString");
      print(prefs.getString("customerID"));
    }
  }




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
              MenaTracks_API();

              setState(() {
                MenaTracks=[];
              });
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


  MenaTracks_API ()async{
    print('caled');
    if(fromDate.text!=''  && toDate.text!='') {

      setState(() {
        isLoading=true;
      });
      print('called');
      if (fromDate.text != '' && toDate.text != '' ) {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL+'/Customer360/getCustomerFOCDiscountHistory';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);

        Map body = {
          "customerID":customerID,
          "msisdn": prefs.getString("SubscriberNumber"),
          "fromDate": from.toIso8601String(),
          "toDate": to.toIso8601String(),

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
                MenaTracks=result["data"];
                print("******************************************");
                print(MenaTracks.length);
                print("******************************************");

                isLoading=false;
                checkData=true;
                emptyfromDate=false;
                emptytoDate=false;
              });

            }
            print("GetCustomersCreditNotes");
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
          emptyfromDate=false;
          emptytoDate=false;
          MenaTracks=[];
          fromDate.text = '';
          toDate.text = '';
          isLoading = false;
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
              emptyfromDate=false;
              emptytoDate=false;
              MenaTracks=[];
              fromDate.text = '';
              toDate.text = '';
              isLoading = false;
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
          emptyfromDate=false;
          emptytoDate=false;
          MenaTracks=[];
          fromDate.text = '';
          toDate.text = '';
          isLoading = false;
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
            emptyfromDate=false;
            emptytoDate=false;
            MenaTracks=[];
            fromDate.text = '';
            toDate.text = '';
            isLoading = false;
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

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);

      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return   WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color(0xFF392156),
            title: Text("AccountManager.FOCReport".tr().toString(),),
            leading: IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () async{
                SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.pop(context);
              },
            ), //<Widget>[]

          ),
          body:role=="Corporate"? ListView(
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 0, left: 0, right: 0),
            children: <Widget>[
              ///////////////////////////////////First Content//////////////////////////////////////////////////////////
              FirstContentFlag==true?
              Container(
                color: Colors.white,
                width: double.infinity,
                // margin: EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 18, bottom: 5, left: 25, right: 25),
                      color: Color(0xff392156),
                      width: 5,
                      height: 38,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(

                              "SubscriberView.CustomerName"
                                  .tr()
                                  .toString(),
                            ),
                            SizedBox(height: 1),
                            Text(customerName,
                              // this.data[0]['customerName'],
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
              ):Container(),

              FirstContentFlag==true? Container(
                color: Colors.white,
                width: double.infinity,
                // margin: EdgeInsets.all(12),
                margin: EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.only(
                          top: 18, bottom: 5, left: 25, right: 25),
                      color: Color(0xff392156),
                      width: 5,
                      height: 38,
                    ),
                    SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(top: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "SubscriberView.SubscriberNumber"
                                  .tr()
                                  .toString(),
                            ),
                            SizedBox(height: 1),
                            Text(SubscriberNumber,
                              //this.data[0]['msisdn'],
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
              ):Container(),

              ///////////////////////////////////End First Content//////////////////////////////////////////////////////////



              ListView(
                shrinkWrap: true,
                physics: ClampingScrollPhysics(),
                padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                children: [

                  Container(

                    color:Color(0xFFEBECF1) ,
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height/3 *1.9,

                    // margin: EdgeInsets.all(12),
                    child: isLoading==true?
                    Container(
                        color:Color(0xFFEBECF1) ,
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
                    checkData==true?




                    Container(
                      color: Color(0xFFEBECF1),
                      padding: EdgeInsets.only(left: 10, right: 10),
                      child:
                      ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                        itemCount: MenaTracks.length,
                        itemBuilder: (BuildContext context, int index) {
                          //   itemCount :  UserList.length,
                          return  Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                color: Colors.white
                            ),
                            margin: EdgeInsets.only(bottom: 15),
                            padding: EdgeInsets.only(left: 10, right: 10,bottom: 15),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                      child: Container(
                                        padding: EdgeInsets.only(left: 10, right: 10),

                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.center,
                                          children: [
                                            SizedBox(
                                              height: 10,
                                            ),
                                            Text("AccountManager.focDate".tr().toString(),),

                                            SizedBox(height: 1),
                                            Text(
                                              MenaTracks[index]['focDate']!=null|| MenaTracks[index]['focDate'].length==0?MenaTracks[index]['focDate']:'--',

                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text("AccountManager.DiscountType".tr().toString(),),

                                            SizedBox(height: 1),
                                            Text(MenaTracks[index]['discountType']!=null|| MenaTracks[index]['discountType'].length==0?MenaTracks[index]['discountType']:'--',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14.0,
                                              ),
                                            ),
                                            SizedBox(
                                              height: 15,
                                            ),
                                            Text("AccountManager.ItemDescription".tr().toString(),),

                                            SizedBox(height: 1),
                                            Text(MenaTracks[index]['itemDescription']!=null|| MenaTracks[index]['itemDescription'].length==0?MenaTracks[index]['itemDescription']:'--',

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


                                    //Spacer(),
                                    Column(
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.navigate_next,color: Color(0xFFA1A1A1),),
                                            onPressed: () async{
                                              SharedPreferences prefs = await SharedPreferences.getInstance();

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => FOCReportDetails(PermessionCorporate, role,MenaTracks,index),
                                                ),
                                              );
                                            },
                                          ),
                                        ]),

                                    /* Expanded(
                                child: Container(
                                  width: 10,
                                  color: Colors.green,

                                  child: Column(
                                    crossAxisAlignment:
                                    CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                    MainAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        height: 15,
                                      ),

                                      Container(
                                        color: Colors.yellow,
                                        width: 30,
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Container(
                                                //  width: double.infinity,
                                                  child: IconButton(
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
                                                  ),/*ElevatedButton(
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
                                                     /* Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                          builder: (context) => SubscriberList(PermessionCorporate,role,searchID,searchValue,NationalNumberList[index]['highestCustomerID'],NationalNumberList[index]['msisdn'],this.data,searchCraretia),
                                                        ),
                                                      );*/



                                                    },
                                                  )*/

                                              )
                                            ]),),
                                    ],
                                  ),
                                ),
                              ),*/

                                  ],
                                )

                              ],
                            ),
                          );


                        },
                      ),

                    )  :
                    Container(
                        color: Colors.transparent
                    ),
                  ),


                ],
              )
            ],
          )
              :Container(),
          bottomNavigationBar: BottomAppBar(
            child: Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                  color: Color(0xFFEBECF1),

                ),
                child: SingleChildScrollView(
                  child:Column(
                    children: [
                      SizedBox(height: 15),

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
                fontWeight: FontWeight.normal)),),
        TextButton(onPressed: (){
          Navigator.pop(context,false);
        }, child: Text("corpAlert.cancel".tr().toString(),
          style: TextStyle(
              fontSize: 16,
              color: Color(0xFF392156),
              fontWeight: FontWeight.normal),),),


      ],)));
