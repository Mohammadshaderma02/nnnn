import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Multi_Use_Components/RequiredField.dart';





class InterNationalPresetRisk extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  InterNationalPresetRisk(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _InterNationalPresetRiskState createState() =>
      _InterNationalPresetRiskState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _InterNationalPresetRiskState extends State<InterNationalPresetRisk> {
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
  bool isLoadingRemove=false;
  bool isLoadingAdd=false;
  bool isLoadingHistory=false;

  ///////////////////////variable from API//////////////////////////////////////

  bool emptySIM=false;
  var simType="";
  bool isFOC =false;
  bool submitEnabled=false;
  bool emptyEmployeeName =false;
  bool emptyEmployeeNumber=false;
  bool emptyFOCNote=false;

  var selectedEmployeeName;

  var presetRiskDetails={};
  var PremiumPresetRiskHistory=[];


  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool emptyfromDate = false;
  bool emptytoDate = false;

  ///////////////////////End variable from API/////////////////////////////////


  TextEditingController NewSIM = TextEditingController();
  TextEditingController EmployeeNumber = TextEditingController();
  TextEditingController FOCNote = TextEditingController();
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  _InterNationalPresetRiskState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


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
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{

    }
    getPresetRiskDetails_API();
    //disableCapture();
  //  iosSecureScreenShotChannel.invokeMethod("secureiOS");

    super.initState();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  getPresetRiskDetails_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      isLoading=true;
    });
    Map body = {
      "msisdn": msisdn,
      "customerNumber":customerNumber

    };
    var apiArea = urls.BASE_URL + '/Customer360/presetRiskDetails';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body: json.encode(body),);
    int statusCode = response.statusCode;
    print('TOKEN');
    print(prefs.getString("accessToken"));

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);



      if( result["status"]==0){
        setState(() {
          isLoading=false;
        });
        if(result["data"]==null||result["data"].length==0){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{
          setState(() {
            isLoading=false;
          });
          print('HII SAFII');
          print(result["data"]["internationalPresetLimitDetails"]);

          setState(() {
            presetRiskDetails=result["data"]["internationalPresetLimitDetails"];
          });


        }

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);



      }




      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);
      setState(() {
        isLoading=false;
      });
    }
  }
  addPremiumPostpaidPresetRisk_API() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Customer360/addPremiumPostpaidPresetRisk';
    setState(() {
      isLoadingAdd=true;
    });
    final Uri url = Uri.parse(apiArea);

    Map body = {
      "msisdn": msisdn,

      "amount": "10000"

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

        isLoadingAdd=false;
      });
      var result = json.decode(response.body);

      print(json.decode(response.body));

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

          isLoadingAdd=false;
        });

      }





    }
    else{
      showAlertDialogOtherERROR(context,statusCode.toString(), statusCode.toString());
      setState(() {

        isLoadingAdd=false;
      });
    }
  }
  removePremiumPostpaidPresetRisk_API() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Customer360/removePremiumPostpaidPresetRisk';
    setState(() {
      isLoadingRemove=true;
    });
    final Uri url = Uri.parse(apiArea);

    Map body = {
      "msisdn": msisdn,

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
     // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      setState(() {

        isLoadingRemove=false;
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

          isLoadingRemove=false;
        });

      }





    }
    else{
      showAlertDialogOtherERROR(context,statusCode.toString(), statusCode.toString());
      setState(() {

        isLoadingRemove=false;
      });
    }
  }
  getPremiumPresetRiskHistory_API ()async{

    if(fromDate.text!=''  && toDate.text!='') {

      if(fromDate.text != ''){
        setState(() {
          emptyfromDate=false;
        });
      }

      if(toDate.text != ''){
        setState(() {
          emptytoDate=false;
        });
      }

      setState(() {
        isLoadingHistory=true;
      });
      print('called');
      if (fromDate.text != '' && toDate.text != '') {
        SharedPreferences prefs = await SharedPreferences.getInstance();

        var apiArea = urls.BASE_URL +
            '/Customer360/getPremiumPresetRiskHistory';
        final Uri url = Uri.parse(apiArea);
        prefs.getString("accessToken");
        final access = prefs.getString("accessToken");
        print(url);
        Map body = {
          "msisdn":msisdn,
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
        print(data);
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
            isLoadingHistory=false;

          });
          if( result["status"]==0){
            if(result["data"]==null||result["data"].length==0){
              showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


            }else{

              setState(() {
                PremiumPresetRiskHistory=result["data"];
                isLoadingHistory=false;

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
    }
    else{
      if(fromDate.text == ''){
        setState(() {
          emptyfromDate=true;
        });
      }else if(fromDate.text != ''){
        setState(() {
          emptyfromDate=false;
        });
      }
      if(toDate.text == ''){
        setState(() {
          emptytoDate=true;
        });
      }else if(toDate.text != ''){
        setState(() {
          emptytoDate=false;
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

  Widget buildNewSIM() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberServices.new_sim".tr().toString(),
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
              color: emptySIM==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptySIM ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: NewSIM,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "SubscriberServices.enter_new_sim".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptySIM  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }

  Widget buildRemoveBtn() {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 48,
        width: 170,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: Color(0xFF9D1C1C),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF9D1C1C),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: isLoadingRemove==true?null: (){

              removePremiumPostpaidPresetRisk_API();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoadingRemove==true?SizedBox(
                  child: CircularProgressIndicator(color: Colors.white ),
                  height: 20.0,
                  width: 20.0,
                ):  Icon(Icons.close,color: Colors.white,),
                SizedBox(width: 10,),

                Text(
                  "SubscriberServices.remove".tr().toString(),
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
  Widget buildAddBtn() {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 48,
        width: 170,
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
            onPressed: isLoadingAdd==true?null: (){

              addPremiumPostpaidPresetRisk_API();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoadingAdd ?
                SizedBox(
                  child: CircularProgressIndicator(color: Colors.white ),
                  height: 20.0,
                  width: 20.0,
                ):Icon(Icons.add, color: Colors.white,

                ),
                SizedBox(width: 10,),

                Text(
                  "SubscriberServices.add".tr().toString(),
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

  Widget buildSearchBtn() {

    return Container(
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

             getPremiumPresetRiskHistory_API();
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
            title: Text("SubscriberServices.international_preset_risk".tr().toString(),),
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
          body: role == "Corporate"
              ?  Container(
                  child: isLoading==true?Container(
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

                      )): ListView(
                    children: [
                        Container(

                        padding: EdgeInsets.only(top: 20, left: 26,right: 26,bottom: 20),
                        color: Colors.white,
                        height: 300,
                        child:
                        Column
                          (
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Container(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SubscriberServices.type"
                                          .tr()
                                          .toString(),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      presetRiskDetails['type']=='' || presetRiskDetails['type']==null?'-':presetRiskDetails['type'] ,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Expanded(
                              child: Container(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SubscriberServices.status"
                                          .tr()
                                          .toString(),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      presetRiskDetails['status']=='' || presetRiskDetails['status']==null?'-':presetRiskDetails['status'] ,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Expanded(
                              child: Container(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SubscriberServices.international_limit_value"
                                          .tr()
                                          .toString(),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      presetRiskDetails['limitValue']=='' || presetRiskDetails['limitValue']==null?'-':presetRiskDetails['limitValue'] ,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 5,),
                            Expanded(
                              child: Container(

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SubscriberServices.international_used_value"
                                          .tr()
                                          .toString(),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      presetRiskDetails['usedValue']=='' || presetRiskDetails['usedValue']==null?'-':presetRiskDetails['usedValue'] ,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(height: 10,),
                            Row(
                              children: [
                                buildRemoveBtn(),
                                Spacer(),
                                buildAddBtn()
                              ],
                            )


                          ],
                        ),
                      ),
                        Container(
                        padding: EdgeInsets.only(top: 20, left: 26,right: 26,bottom: 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                              child:  Text(
                                "SubscriberServices.request".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xFF11120E),
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                ),

                              ),
                            ),
                            SizedBox(height:20),

                            Row(children: [
                              SizedBox(
                                  width: 165,
                                  child: buildFromDate()),
                              Spacer(),
                              SizedBox(
                                  width: 165,
                                  child: buildToDate()),
                            ],),
                            SizedBox(height:10),


                            buildSearchBtn()
                          ],
                        )
                        ,
                      ),
                      isLoadingHistory==true?
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
                      Container(

                          padding: EdgeInsets.only(top: 20, left: 26,right: 26,bottom: 20),
                          color: isLoadingHistory==true? Colors.white:Colors.transparent,
                          child:
                          ListView.builder(
                            padding: EdgeInsets.only(top:8,bottom: 8,left: 0,right: 0),
                            shrinkWrap: true,
                            itemCount: PremiumPresetRiskHistory.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(

                                width: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(color:Color(0xffE9E9E9)),
                                    color: Colors.white

                                ),
                                padding: EdgeInsets.only(left: 16, right: 16,bottom: 20),
                                // margin: EdgeInsets.all(12),

                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Text(
                                      "SubscriberServices.user".tr().toString(),
                                    ),
                                    SizedBox(height: 1),

                                    Text(
                                      PremiumPresetRiskHistory[index]['user'],
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),

                                    SizedBox(
                                      height: 20,
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
                                                  "SubscriberServices.entry_date"
                                                      .tr()
                                                      .toString(),
                                                ),
                                                SizedBox(height: 1),
                                                Text(
                                                  PremiumPresetRiskHistory[index]['enrtyDate'].toString().substring(0,PremiumPresetRiskHistory[index]['enrtyDate'].indexOf(' ')),
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        SizedBox(width: 8),
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
                                                  "SubscriberServices.request_status"
                                                      .tr()
                                                      .toString(),
                                                ),
                                                SizedBox(height: 1),
                                                Text(
                                                  PremiumPresetRiskHistory[index]['status'],
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
                                  ],
                                ),
                              );


                            },
                          )
                      ),


                    ],
                  ),
          )
              :Container(),
        ),
      ),

      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////




    );
  }
}