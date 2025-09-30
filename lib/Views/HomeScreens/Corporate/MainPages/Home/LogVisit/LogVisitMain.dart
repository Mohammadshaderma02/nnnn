import 'dart:async';
import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/LogVisit/SelectUser.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../Multi_Use_Components/RequiredField.dart';


class LogVisitMain extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  LogVisitMain(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _LogVisitMainState createState() =>
      _LogVisitMainState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _LogVisitMainState extends State<LogVisitMain> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  DateTime backButtonPressedTime;
  //String PermessionCorporate; Test@2025
  final List<dynamic> PermessionCorporate;
  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  bool isLoading = false;
  bool FirstContentFlag=false;
  var SubscriberNumber;
  var customerName;
  bool isLoadingCheckSIM=false;
  bool SubmitLoading=false;
  ///////////////////////variable from API//////////////////////////////////////

  bool emptySIM=false;
  var simType="";
  bool isFOC =false;
  bool submitEnabled=false;
  bool emptySubject =false;
  bool emptyContactMSISDN=false;

  bool addContactLoading=false;
  var SuccessMSG;
  bool continueNewUserCycle=false;
  var selectedEmployeeName;
  var selectedSubjectValue;
  var selectedContactNameNValue;

  var EMPLOYEENAMES=[];
  var SUBJECTS=[];
  var CONTACT_MSISDN=[];
  ///////////////////////End variable from API/////////////////////////////////



  // var formatterTime = DateFormat('kk:mm:ss a');



  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  bool emptyfromDate = false;
  bool emptytoDate = false;
  bool emptyCustomerId=false;
  bool emptyDescription=false;




  bool emptyFirstName=false;
  bool emptyLastName=false;

  bool emptyJobTitle=false;
  bool emptycustomerIdDialog=false;
  bool emptyContactMSISDNDialog=false;
  bool contactNumberValidation=false;


  /******************************New Vaeiable******************************/
  bool switchManualVisit = false;

  bool emptyStartTime = false;
  bool emptyEndTime = false;

  String getFormatterStartTime ;
  String getFormatterEndTime ;

  TextEditingController startTime = TextEditingController();
  TextEditingController endTime = TextEditingController();

  var CONTACT_NAME=[];
  var CONTACT_Full_Info=[];

  var selectedContactMSISDNValue;

  bool newUser=false;

  String en_am_pm;
  String am_pm;


  /****************************End New Vaeiable****************************/



  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  TextEditingController CustomerID = TextEditingController();
  TextEditingController EmployeeNumber = TextEditingController();
  TextEditingController Description = TextEditingController();


  TextEditingController FirstName = TextEditingController();
  TextEditingController LastName = TextEditingController();
  TextEditingController JobTitle = TextEditingController();
  TextEditingController CustomerIDDialog = TextEditingController();
  TextEditingController ContactMSISDNDialog = TextEditingController();

  TextEditingController newContact =TextEditingController();


  String location ='Null, Press Button';
  String Address = 'search';
  Position position;

  bool serviceEnabled;

  bool emptyMAISDNTest = false;
  bool errorMAISDNTest = false;


  _LogVisitMainState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


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
  String msisdnError ;
  String customerFirstNameError ;
  bool customerFirstNameValidation=false;
  String customerSecondNameError ;
  bool customerSecondNameValidation=false;

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
    _getGeoLocationPosition();
    print("UnotherizedError");
    print("role role role role role");
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{

      /******************************New work******************************/
      //set the initial value of text field Time
      startTime.text='';
      endTime.text='';


      checkPrefs();
      _getGeoLocationPosition();
      getSubjects_API();

      //disableCapture();
      /****************************End New work****************************/


    }
    //iosSecureScreenShotChannel.invokeMethod("secureiOS");

    super.initState();
  }
  @override
  void dispose() {

    // this method to the user can take screenshots of your application
    // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }
  /******************************New work******************************/
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }
  /****************************End New work****************************/


  Future<Position> _getGeoLocationPosition() async {
    // bool serviceEnabled;
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showAlertDialogLocation(context,"Location services are disabled.","خدمات الموقع معطلة.");
      print("Location services are disabled");

      return Future.error('Location services are disabled.');
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {

        return Future.error('Location permissions are denied');
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

/*I was stop it on 21-nov-2023*/
    position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high,forceAndroidLocationManager: true);
    print("position");
    print ("----------------------position.latitude && position.longitude--------------------------");

    print(position.latitude);
    print(position.longitude);

    /* Geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high, forceAndroidLocationManager: true)
        .then((Position position) {
      setState(() {
        position = position;
      });
      print ("----------------------position.latitude && position.longitude--------------------------");
      print(position.latitude);
      print(position.longitude);

    }).catchError((e) {
      print(e);
    });*/




  }

  Future<void> GetAddressFromLatLong(Position position)async {
    print('latitude');
    print(position.latitude);
    print(position.longitude);
    setState(()  {
      location =position.latitude.toString()+','+position.longitude.toString();
    });
    List<Placemark> placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    print(placemarks);
    Placemark place = placemarks[0];
    Address = '${place.street}, ${place.subLocality}, ${place.locality}, ${place.postalCode}, ${place.country}';
    setState(()  {
      location =position.latitude.toString()+','+position.longitude.toString();
    });
  }



  showAlertDialogLocation(BuildContext context, arabicMessage, englishMessage) {
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
          onPressed: () async {

            Navigator.of(context).pop();
            await Geolocator.openLocationSettings();


          },
          child: Text(
            "corpAlert.enable_location".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        ),

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

  returnContactInfoByCustNumberCRM_API (value) async{
    print("haya_____");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/Customer360/returnContactInfoByCustNumberCRM';
    final Uri url = Uri.parse(apiArea);
    print(url);
    Map body = {
      "customerId":value

    };
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body: json.encode(body),);
    int statusCode = response.statusCode;

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
      //   showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);
      print(json.encode(body));
      print('helle result');
      print(result);


      if( result["status"]==0){
        setState(() {
          CONTACT_MSISDN=[];
          CONTACT_NAME=[];
          CONTACT_Full_Info=[];
        });
        if(result['data']!=null) {
          print('list');
          print(result['data']);
          for (var i = 0; i < result['data'].length; i++) {
            if(CONTACT_MSISDN.contains(result['data'][i]['mobilePhone'])==false){
              CONTACT_MSISDN.add(result['data'][i]['mobilePhone']);
            }else{
              continue;
            }

          }
          for (var i = 0; i < result['data'].length; i++) {
            if(CONTACT_NAME.contains(result['data'][i]['fullName'])==false){
              CONTACT_NAME.add(result['data'][i]['fullName']);
            }else{
              continue;
            }

          }
          for (var i = 0; i < result['data'].length; i++) {
            if(CONTACT_Full_Info.contains(result['data'][i])==false){
              CONTACT_Full_Info.add(result['data'][i]);

            }else{
              continue;
            }

          }

        }
        //CONTACT_MSISDN=result['data'];

      }else{
        print("I AM HER");
        //  showAlertDialogERROR(context,result["messageAr"], result["message"]);

      }

    }
  }

  returnContactInfoByCustNumberCRMbyCustomerId_API () async {

    if (CustomerID.text == '') {
      setState(() {
        emptyCustomerId=true;
      });

    } else {
      setState(() {
        emptyCustomerId=false;
      });
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var apiArea = urls.BASE_URL +
          '/Customer360/returnContactInfoByCustNumberCRM';
      final Uri url = Uri.parse(apiArea);

      Map body = {
        "customerId": CustomerID.text
      };
      final response = await http.post(url, headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      }, body: json.encode(body),);
      int statusCode = response.statusCode;

      if (statusCode == 500) {
        print('500  error ');
      }
      if (statusCode == 401) {
        print('401  error ');
        UnotherizedError();
        //   showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

      }
      if (statusCode == 200) {
        var result = json.decode(response.body);
        print('helle result');
        print(result);


        var innerList=[];
        var innerList2=[];
        var innerList3=[];

        if (result["status"] == 0) {
          print("::::::::::::::::::::::::::::::::::::");
          print(CONTACT_NAME);
          setState(() {
            selectedContactNameNValue=null;
            CONTACT_MSISDN=[];
            CONTACT_NAME=[];
            CONTACT_Full_Info=[];
          });
          print(CONTACT_NAME);
          for (var i = 0; i < result['data'].length; i++) {
            innerList.add(result['data'][i]['mobilePhone']);
          }
          for (var i = 0; i < result['data'].length; i++) {
            innerList2.add(result['data'][i]['fullName']);
          }

          for (var i = 0; i < result['data'].length; i++) {
            innerList3.add(result['data'][i]);
            print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^111");
            print(innerList3);
            print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^11");
          }
          //CONTACT_MSISDN=result['data'];
          setState(() {
            CONTACT_MSISDN=innerList;
            CONTACT_NAME=innerList2;
            CONTACT_Full_Info=innerList3;

          });
          print(CONTACT_NAME);
          print("::::::::::::::::::::::::::::::::::::");

          print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^*****");
          print(CONTACT_Full_Info.length);
          print("^^^^^^^^^^^^^^^^^^^^^^^^^^^^^****");

        } else {
          showAlertDialogERROR(context, result["messageAr"], result["message"]);
        }
      }
    }
  }

  getSubjects_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lookup/GET_LOGVISIT_LIST';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
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
      UnotherizedError();
      //  showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);



      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{


          setState(() {

            SUBJECTS=result["data"];
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

  /*******************was change on 2023*******************/
  addContact_API () async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print("/Customer360/createContactDynamicsCRM");
    var apiArea = urls.BASE_URL + '/Customer360/createContactDynamicsCRM';
    final Uri url = Uri.parse(apiArea);

    Map body = {
      "firstName": FirstName.text,

      "lastName": LastName.text,

      "contactMSISDN": ContactMSISDNDialog.text,

      "jobTitle": JobTitle.text,

      "accountNumber": newUser==true?"":CustomerIDDialog.text,

      "message": ""

    };

    setState(() {
      addContactLoading=true;
    });
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body: json.encode(body),);
    int statusCode = response.statusCode;

    if (statusCode == 500) {
      print('500  error ');

    }
    print(json.encode(body));
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
      //   showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {
      setState(() {
        addContactLoading=false;
      });

      var result = json.decode(response.body);
      print('helle result');
      print(result);
      /**********************************************************new 2023***************************************************/
      FocusScope.of(context).unfocus();
      /**********************************************************end 2023***************************************************/



      if( result["status"]==0){
        /**********************************************************new 2023***************************************************/
        Navigator.pop(context);
        setState(() {
          addContactLoading=false;
        });
        /**********************************************************end 2023***************************************************/

        showToast(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? result["message"]
                : result["messageAr"],
            context: context,
            animation: StyledToastAnimation.scale,
            fullWidth: true);
        String firstName = json.encode(body["firstName"]);
        final values1 = firstName.split('"');
        print(values1[1]);
        String lastName = json.encode(body["lastName"]);
        final values2 = lastName.split('"');
        print(values2[1]);
        setState(() {
          SuccessMSG=result["message"];
          addContactLoading=false;
          newContact.text=values1[1]+" "+values2[1];

        });

      }else{
        Navigator.pop(context);
        setState(() {
          addContactLoading=false;
        });

        showAlertDialogERROR(context,result["messageAr"], result["message"]);

      }

    }
  }


  createAppointmentDynamicsCRM_API() async{
    LocationPermission permission;
    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      showAlertDialogLocation(context,"Location services are disabled.","خدمات الموقع معطلة.");
      print("Location services are disabled");

      return Future.error('Location services are disabled.');
    }else{

      _getGeoLocationPosition();
      // _getCurrentPosition();
      if(selectedSubjectValue==null){
        setState(() {
          emptySubject=true;
        });
      }else if(selectedSubjectValue!=null){
        setState(() {
          emptySubject=false;
        });
      }
      /*****2023****/

      if(newUser==true){
        if(CustomerID.text==''){
          setState(() {
            emptyCustomerId=false;
          });
        }
        if(selectedContactNameNValue==null){
          setState(() {
            emptyContactMSISDN=false;
          });
        }
        if(ContactMSISDNDialog.text== ''){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Need to add contact "
                      : "تحتاج إلى إضافة جهة اتصال")));

        }
        if(newContact.text== ''){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Need to add contact "
                      : "تحتاج إلى إضافة جهة اتصال")));

        }
        if(SuccessMSG != 'Success' && ContactMSISDNDialog.text != ''){
          print(ContactMSISDNDialog.text);
          print("ContactMSISDNDialog.text");
          print(ContactMSISDNDialog.text);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? SuccessMSG
                      : SuccessMSG)));

        }
        if(SuccessMSG == 'Success' && ContactMSISDNDialog.text != ''){
          setState(() {
            continueNewUserCycle=true;
          });
        }
        if(SuccessMSG != 'Success' && newContact.text != ''){
          print(newContact.text);
          print("newContact.text");
          print(newContact.text);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? SuccessMSG
                      : SuccessMSG)));

        }
        if(SuccessMSG == 'Success' && newContact.text != ''){
          setState(() {
            continueNewUserCycle=true;
          });
        }
      }
      else if(newUser!=true) {
        if(selectedContactNameNValue==null){
          setState(() {
            emptyContactMSISDN=true;
          });
        }else if(selectedContactNameNValue!=null){

          setState(() {
            emptyContactMSISDN=false;
          });
        }

        if(CustomerID.text==''){
          setState(() {
            emptyCustomerId=true;
          });
        }else if(CustomerID.text!=''){
          setState(() {
            emptyCustomerId=false;
          });
        }
      }
      /*****end new******/

      /* if(selectedContactNameNValue==null){
      setState(() {
        emptyContactMSISDN=true;
      });
    }else if(selectedContactNameNValue!=null){

      setState(() {
        emptyContactMSISDN=false;
      });
    }*/

      if(fromDate.text=='' ){
        setState(() {
          emptyfromDate=true;
        });
      }else if(fromDate.text!=''){
        setState(() {
          emptyfromDate=false;
        });
      }

      if(switchManualVisit==true){
        if(startTime.text==''|| endTime.text==''){
          setState(() {
            emptyStartTime=true;
            emptyEndTime=true;
          });
        }

      }else if(switchManualVisit==false){
        setState(() {
          emptyStartTime=false;
          emptyEndTime=false;
        });
      }
      /* if(toDate.text=='' ){
      setState(() {
        emptytoDate=true;
      });
    }else if(toDate.text!=''){
      setState(() {
        emptytoDate=false;
      });
    }*/

      /* if(CustomerID.text==''){
      setState(() {
        emptyCustomerId=true;
      });
    }else if(CustomerID.text!=''){
      setState(() {
        emptyCustomerId=false;
      });
    }*/
      /********************************************************New User Appoitment Cycle********************************************************/


      if(switchManualVisit==true && continueNewUserCycle==true && newUser==true){
        print("switchManualVisit-continueNewUserCycle");
        if(emptyCustomerId==false && emptytoDate==false && emptyfromDate==false&&
            emptyContactMSISDN==false &&emptySubject==false && startTime.text.length!=0 && endTime.text.length!=0
        ) {
          setState(() {
            emptyStartTime=false;
            emptyEndTime=false;
          });

          /************** To get Contact Name and search for his Mobile Number ***************/
         /* for (var i = 0; i < CONTACT_Full_Info.length; i++) {

            if(CONTACT_Full_Info[i]['fullName'].contains(selectedContactNameNValue)){
              print(CONTACT_Full_Info[i]['mobilePhone']);
              setState(() {
                selectedContactMSISDNValue = CONTACT_Full_Info[i]['mobilePhone'];

              });

            }
          }*/
          /************************************************************************************/
          var now = new DateTime.now();
          String formattedTime = DateFormat('kk:mm:ss').format(now);

/*Change From Date With Curent Time*/
          var formatedDate = from.toIso8601String().split(new RegExp(r"[T\.]"));

          print("/**********************automatic*********************/");
          print(formatedDate[0]);
          var FromWithDate= "${formatedDate[0]} ${formattedTime}";
          DateTime dFrom1 = DateTime.parse(FromWithDate);
          print(dFrom1);
          print(dFrom1.toIso8601String());



/*Change To Date With Curent Time*/
          print("/********* ************* ******* **************/");
          var add30Minutes=DateTime.now().add(Duration(hours: 0,minutes: 30, seconds: 00));;
          print(add30Minutes);
          print("/******** ************ ********* ************/");
          String formattedTime30 = DateFormat('kk:mm:ss').format(add30Minutes);


          var formatedTimeTo = to.toIso8601String().split(new RegExp(r"[T\.]"));
          print(formatedTimeTo[0]);
          var FromWithTime= "${formatedTimeTo[0]} ${formattedTime30}";
          DateTime dTo1 = DateTime.parse(FromWithTime);
          print(dTo1);
          print(dTo1.toIso8601String());

          print("/******** ************ ********* ************************************************************************************/");



          /******************************FOR MANUAL PART***********************************/
          if(getFormatterStartTime== null){
            setState(() {
              getFormatterStartTime=formattedTime;
            });
          }

          var ManualDateStartTime ="${formatedDate[0]} ${getFormatterStartTime}";
          DateTime dManualStartTime = DateTime.parse(ManualDateStartTime);
          print("/**********************Manual Start Time*********************/");
          print(dManualStartTime);
          print(dManualStartTime.toIso8601String());



          if(getFormatterEndTime== null){
            setState(() {
              getFormatterEndTime=formattedTime;
            });
          }
          var ManualDateEndTime ="${formatedDate[0]} ${getFormatterEndTime}";
          DateTime dManualEndTime = DateTime.parse(ManualDateEndTime);
          print("/**********************Manual End Time*********************/");
          print(dManualEndTime);
          print(dManualEndTime.toIso8601String());
          /*****************************************************************/

          SharedPreferences prefs = await SharedPreferences.getInstance();
          var apiArea = urls.BASE_URL + '/Customer360/createAppointmentDynamicsCRM';
          final Uri url = Uri.parse(apiArea);


          Map body = {
            "sSubject": selectedSubjectValue,
            "sDescription": Description.text,
            "sLocation":(position.latitude).toString() + ',' +(position.longitude).toString(),
            "dtStartDate": switchManualVisit==false? dFrom1.toIso8601String():dManualStartTime.toIso8601String(),
            "dtEndDate": switchManualVisit==false?dTo1.toIso8601String():dManualEndTime.toIso8601String(),
            "contactMSISDN":  ContactMSISDNDialog.text,
            "accountRegarding": CustomerID.text,
            "message": ""
          };

          setState(() {
            SubmitLoading = true;
          });
          final response = await http.post(url, headers: {
            "content-type": "application/json",
            "Authorization": prefs.getString("accessToken")
          }, body: json.encode(body),);
          int statusCode = response.statusCode;

          if (statusCode == 500) {
            print('500  error ');
          }
          if (statusCode == 401) {
            print('401  error ');
            UnotherizedError();
            //   showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

          }
          if (statusCode == 200) {
            setState(() {
              SubmitLoading = false;
            });

            var result = json.decode(response.body);
            print(json.encode(body));
            print('helle result');
            print(result);


            if (result["status"] == 0) {

              Navigator.pop(context);
              showToast(
                  EasyLocalization
                      .of(context)
                      .locale == Locale("en", "US")
                      ? result["message"]
                      : result["messageAr"],
                  context: context,
                  animation: StyledToastAnimation.scale,
                  fullWidth: true);


              setState(() {
                SubmitLoading = false;
              });
            } else {
              setState(() {
                SubmitLoading = false;
              });
              showAlertDialogERROR(context, result["messageAr"], result["message"]);
            }
          }
        }
      }
      else if(switchManualVisit==false && continueNewUserCycle==true && newUser==true) {
        print("NotswitchManualVisit-continueNewUserCycle");
        if(emptyCustomerId==false && emptytoDate==false && emptyfromDate==false&&
            emptyContactMSISDN==false &&emptySubject==false
        ) {
          print('inside if');
          print(CONTACT_Full_Info);
          /************** To get Contact Name and search for his Mobile Number ***************/
        /*  for (var i = 0; i < CONTACT_Full_Info.length; i++) {

            if(CONTACT_Full_Info[i]['fullName'].contains(selectedContactNameNValue)){
              print(CONTACT_Full_Info[i]['mobilePhone']);
              setState(() {
                selectedContactMSISDNValue = CONTACT_Full_Info[i]['mobilePhone'];

              });

            }
          }*/
          /************************************************************************************/
          var now = new DateTime.now();
          String formattedTime = DateFormat('kk:mm:ss').format(now);

/*Change From Date With Curent Time*/
          var formatedDate = from.toIso8601String().split(new RegExp(r"[T\.]"));

          print("/**********************automatic*********************/");
          print(formatedDate[0]);
          var FromWithDate= "${formatedDate[0]} ${formattedTime}";
          DateTime dFrom1 = DateTime.parse(FromWithDate);
          print(dFrom1);
          print(dFrom1.toIso8601String());



/*Change To Date With Curent Time*/
          print("/********* ************* ******* **************/");
          var add30Minutes=DateTime.now().add(Duration(hours: 0,minutes: 30, seconds: 00));;
          print(add30Minutes);
          print("/******** ************ ********* ************/");
          String formattedTime30 = DateFormat('kk:mm:ss').format(add30Minutes);


          var formatedTimeTo = to.toIso8601String().split(new RegExp(r"[T\.]"));
          print(formatedTimeTo[0]);
          var FromWithTime= "${formatedTimeTo[0]} ${formattedTime30}";
          DateTime dTo1 = DateTime.parse(FromWithTime);
          print(dTo1);
          print(dTo1.toIso8601String());

          print("/******** ************ ********* ************************************************************************************/");



          /******************************FOR MANUAL PART***********************************/
          if(getFormatterStartTime== null){
            setState(() {
              getFormatterStartTime=formattedTime;
            });
          }

          var ManualDateStartTime ="${formatedDate[0]} ${getFormatterStartTime}";
          DateTime dManualStartTime = DateTime.parse(ManualDateStartTime);
          print("/**********************Manual Start Time*********************/");
          print(dManualStartTime);
          print(dManualStartTime.toIso8601String());



          if(getFormatterEndTime== null){
            setState(() {
              getFormatterEndTime=formattedTime;
            });
          }
          var ManualDateEndTime ="${formatedDate[0]} ${getFormatterEndTime}";
          DateTime dManualEndTime = DateTime.parse(ManualDateEndTime);
          print("/**********************Manual End Time*********************/");
          print(dManualEndTime);
          print(dManualEndTime.toIso8601String());
          /*****************************************************************/

          SharedPreferences prefs = await SharedPreferences.getInstance();
          var apiArea = urls.BASE_URL + '/Customer360/createAppointmentDynamicsCRM';
          final Uri url = Uri.parse(apiArea);


          Map body = {
            "sSubject": selectedSubjectValue,
            "sDescription": Description.text,
            "sLocation":(position.latitude).toString() + ',' +(position.longitude).toString(),
            "dtStartDate": switchManualVisit==false? dFrom1.toIso8601String():dManualStartTime.toIso8601String(),
            "dtEndDate": switchManualVisit==false?dTo1.toIso8601String():dManualEndTime.toIso8601String(),
            "contactMSISDN": ContactMSISDNDialog.text,
            "accountRegarding": CustomerID.text,
            "message": ""
          };

          setState(() {
            SubmitLoading = true;
          });
          final response = await http.post(url, headers: {
            "content-type": "application/json",
            "Authorization": prefs.getString("accessToken")
          }, body: json.encode(body),);
          int statusCode = response.statusCode;

          if (statusCode == 500) {
            print('500  error ');
          }
          if (statusCode == 401) {
            print('401  error ');
            UnotherizedError();
            //   showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

          }
          if (statusCode == 200) {
            print('/Customer360/createAppointmentDynamicsCRM');
            setState(() {
              SubmitLoading = false;
            });

            var result = json.decode(response.body);
            print(json.encode(body));
            print('helle result');
            print(result);


            if (result["status"] == 0) {


              Navigator.pop(context);
              showToast(
                  EasyLocalization
                      .of(context)
                      .locale == Locale("en", "US")
                      ? result["message"]
                      : result["messageAr"],
                  context: context,
                  animation: StyledToastAnimation.scale,
                  fullWidth: true);


              setState(() {
                SubmitLoading = false;
              });
            } else {
              setState(() {
                SubmitLoading = false;
              });
              showAlertDialogERROR(context, result["messageAr"], result["message"]);
            }
          }
        }
      }
      /**************************************************************************************************************************************/

      /********************************************************Exist User Appoitment Cycle********************************************************/

      if(switchManualVisit==true && continueNewUserCycle==false && newUser==false){
        print("switchManualVisit");
        if(emptyCustomerId==false && emptytoDate==false && emptyfromDate==false&&
            emptyContactMSISDN==false &&emptySubject==false && startTime.text.length!=0 && endTime.text.length!=0
        ) {
          setState(() {
            emptyStartTime=false;
            emptyEndTime=false;
          });

          /************** To get Contact Name and search for his Mobile Number ***************/
          for (var i = 0; i < CONTACT_Full_Info.length; i++) {

            if(CONTACT_Full_Info[i]['fullName'].contains(selectedContactNameNValue)){
              print(CONTACT_Full_Info[i]['mobilePhone']);
              setState(() {
                selectedContactMSISDNValue = CONTACT_Full_Info[i]['mobilePhone'];

              });

            }
          }
          /************************************************************************************/
          var now = new DateTime.now();
          String formattedTime = DateFormat('kk:mm:ss').format(now);

/*Change From Date With Curent Time*/
          var formatedDate = from.toIso8601String().split(new RegExp(r"[T\.]"));

          print("/**********************automatic*********************/");
          print(formatedDate[0]);
          var FromWithDate= "${formatedDate[0]} ${formattedTime}";
          DateTime dFrom1 = DateTime.parse(FromWithDate);
          print(dFrom1);
          print(dFrom1.toIso8601String());



/*Change To Date With Curent Time*/
          print("/********* ************* ******* **************/");
          var add30Minutes=DateTime.now().add(Duration(hours: 0,minutes: 30, seconds: 00));;
          print(add30Minutes);
          print("/******** ************ ********* ************/");
          String formattedTime30 = DateFormat('kk:mm:ss').format(add30Minutes);


          var formatedTimeTo = to.toIso8601String().split(new RegExp(r"[T\.]"));
          print(formatedTimeTo[0]);
          var FromWithTime= "${formatedTimeTo[0]} ${formattedTime30}";
          DateTime dTo1 = DateTime.parse(FromWithTime);
          print(dTo1);
          print(dTo1.toIso8601String());

          print("/******** ************ ********* ************************************************************************************/");



          /******************************FOR MANUAL PART***********************************/
          if(getFormatterStartTime== null){
            setState(() {
              getFormatterStartTime=formattedTime;
            });
          }

          var ManualDateStartTime ="${formatedDate[0]} ${getFormatterStartTime}";
          DateTime dManualStartTime = DateTime.parse(ManualDateStartTime);
          print("/**********************Manual Start Time*********************/");
          print(dManualStartTime);
          print(dManualStartTime.toIso8601String());



          if(getFormatterEndTime== null){
            setState(() {
              getFormatterEndTime=formattedTime;
            });
          }
          var ManualDateEndTime ="${formatedDate[0]} ${getFormatterEndTime}";
          DateTime dManualEndTime = DateTime.parse(ManualDateEndTime);
          print("/**********************Manual End Time*********************/");
          print(dManualEndTime);
          print(dManualEndTime.toIso8601String());
          /*****************************************************************/

          SharedPreferences prefs = await SharedPreferences.getInstance();
          var apiArea = urls.BASE_URL + '/Customer360/createAppointmentDynamicsCRM';
          final Uri url = Uri.parse(apiArea);


          Map body = {
            "sSubject": selectedSubjectValue,
            "sDescription": Description.text,
            "sLocation":(position.latitude).toString() + ',' +(position.longitude).toString(),
            "dtStartDate": switchManualVisit==false? dFrom1.toIso8601String():dManualStartTime.toIso8601String(),
            "dtEndDate": switchManualVisit==false?dTo1.toIso8601String():dManualEndTime.toIso8601String(),
            "contactMSISDN":  selectedContactMSISDNValue,
            "accountRegarding": CustomerID.text,
            "message": ""
          };
          print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
          print(body);
          print("hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");


          setState(() {
            SubmitLoading = true;
          });
          final response = await http.post(url, headers: {
            "content-type": "application/json",
            "Authorization": prefs.getString("accessToken")
          }, body: json.encode(body),);
          int statusCode = response.statusCode;

          if (statusCode == 500) {
            print('500  error ');
          }
          if (statusCode == 401) {
            print('401  error ');
            UnotherizedError();
            //   showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

          }
          if (statusCode == 200) {
            setState(() {
              SubmitLoading = false;
            });

            var result = json.decode(response.body);
            print(json.encode(body));
            print('helle result');
            print(result);


            if (result["status"] == 0) {
              Navigator.pop(context);
              showToast(
                  EasyLocalization
                      .of(context)
                      .locale == Locale("en", "US")
                      ? result["message"]
                      : result["messageAr"],
                  context: context,
                  animation: StyledToastAnimation.scale,
                  fullWidth: true);


              setState(() {
                SubmitLoading = false;
              });
            } else {
              setState(() {
                SubmitLoading = false;
              });
              showAlertDialogERROR(context, result["messageAr"], result["message"]);
            }
          }
        }
      }
      else if(switchManualVisit==false && continueNewUserCycle==false && newUser==false) {
        print("NotswitchManualVisit");
        if(emptyCustomerId==false && emptytoDate==false && emptyfromDate==false&&
            emptyContactMSISDN==false &&emptySubject==false
        ) {

          /************** To get Contact Name and search for his Mobile Number ***************/
          for (var i = 0; i < CONTACT_Full_Info.length; i++) {

            if(CONTACT_Full_Info[i]['fullName'].contains(selectedContactNameNValue)){
              print(CONTACT_Full_Info[i]['mobilePhone']);
              setState(() {
                selectedContactMSISDNValue = CONTACT_Full_Info[i]['mobilePhone'];

              });

            }
          }
          /************************************************************************************/
          var now = new DateTime.now();
          String formattedTime = DateFormat('kk:mm:ss').format(now);

/*Change From Date With Curent Time*/
          var formatedDate = from.toIso8601String().split(new RegExp(r"[T\.]"));

          print("/**********************automatic*********************/");
          print(formatedDate[0]);
          var FromWithDate= "${formatedDate[0]} ${formattedTime}";
          DateTime dFrom1 = DateTime.parse(FromWithDate);
          print(dFrom1);
          print(dFrom1.toIso8601String());



/*Change To Date With Curent Time*/
          print("/********* ************* ******* **************/");
          var add30Minutes=DateTime.now().add(Duration(hours: 0,minutes: 30, seconds: 00));;
          print(add30Minutes);
          print("/******** ************ ********* ************/");
          String formattedTime30 = DateFormat('kk:mm:ss').format(add30Minutes);


          var formatedTimeTo = to.toIso8601String().split(new RegExp(r"[T\.]"));
          print(formatedTimeTo[0]);
          var FromWithTime= "${formatedTimeTo[0]} ${formattedTime30}";
          DateTime dTo1 = DateTime.parse(FromWithTime);
          print(dTo1);
          print(dTo1.toIso8601String());

          print("/******** ************ ********* ************************************************************************************/");



          /******************************FOR MANUAL PART***********************************/
          if(getFormatterStartTime== null){
            setState(() {
              getFormatterStartTime=formattedTime;
            });
          }

          var ManualDateStartTime ="${formatedDate[0]} ${getFormatterStartTime}";
          DateTime dManualStartTime = DateTime.parse(ManualDateStartTime);
          print("/**********************Manual Start Time*********************/");
          print(dManualStartTime);
          print(dManualStartTime.toIso8601String());



          if(getFormatterEndTime== null){
            setState(() {
              getFormatterEndTime=formattedTime;
            });
          }
          var ManualDateEndTime ="${formatedDate[0]} ${getFormatterEndTime}";
          DateTime dManualEndTime = DateTime.parse(ManualDateEndTime);
          print("/**********************Manual End Time*********************/");
          print(dManualEndTime);
          print(dManualEndTime.toIso8601String());
          /*****************************************************************/

          SharedPreferences prefs = await SharedPreferences.getInstance();
          var apiArea = urls.BASE_URL + '/Customer360/createAppointmentDynamicsCRM';
          final Uri url = Uri.parse(apiArea);


          Map body = {
            "sSubject": selectedSubjectValue,
            "sDescription": Description.text,
            "sLocation":(position.latitude).toString() + ',' +(position.longitude).toString(),
            "dtStartDate": switchManualVisit==false? dFrom1.toIso8601String():dManualStartTime.toIso8601String(),
            "dtEndDate": switchManualVisit==false?dTo1.toIso8601String():dManualEndTime.toIso8601String(),
            "contactMSISDN": selectedContactMSISDNValue,
            "accountRegarding": CustomerID.text,
            "message": ""
          };
          print("hhhhhhhhhhhhhhhhhhhhhhhhhhh-----hhhhhhhhhhhhhhhhhhhhhhhhhhhh----hhhhhhhhhhhhhhhhhhhhhhh");
          print(body);
          print("hhhhhhhhhhhhhhhhhhhhhhhhhhh-----hhhhhhhhhhhhhhhhhhhhhhhhhhh----hhhhhhhhhhhhhhhhhhhhhhhh");
          setState(() {
            SubmitLoading = true;
          });
          final response = await http.post(url, headers: {
            "content-type": "application/json",
            "Authorization": prefs.getString("accessToken")
          }, body: json.encode(body),);
          int statusCode = response.statusCode;

          if (statusCode == 500) {
            print('500  error ');
          }
          if (statusCode == 401) {
            print('401  error ');
            UnotherizedError();
            //   showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

          }
          if (statusCode == 200) {
            print('/Customer360/createAppointmentDynamicsCRM');
            setState(() {
              SubmitLoading = false;
            });

            var result = json.decode(response.body);
            print(json.encode(body));
            print('helle result');
            print(result);


            if (result["status"] == 0) {
              Navigator.pop(context);
              showToast(
                  EasyLocalization
                      .of(context)
                      .locale == Locale("en", "US")
                      ? result["message"]
                      : result["messageAr"],
                  context: context,
                  animation: StyledToastAnimation.scale,
                  fullWidth: true);


              setState(() {
                SubmitLoading = false;
              });
            } else {
              setState(() {
                SubmitLoading = false;
              });
              showAlertDialogERROR(context, result["messageAr"], result["message"]);
            }
          }
        }
      }

      /**************************************************************************************************************************************/
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
            Navigator.pop(context);
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

  void checkPrefs ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();


    if(prefs.containsKey("newUser")){
      setState(() {
        newUser=true;
        CustomerIDDialog.text='';

      });
      print("111111 111111 111111 111111 111111");

    }else{
      setState(() {
        newUser=false;

      });

      print("000000000000    0000000    000000   000000");
    }




    if(prefs.containsKey("customerID")==false){

      setState(() {
        CustomerID.text='';
        CustomerIDDialog.text='';
        ContactMSISDNDialog.text='';


      });
      returnContactInfoByCustNumberCRM_API('');

    }else{
      setState(() {
        CustomerID.text=customerNumber;
        CustomerIDDialog.text=customerNumber;
        ContactMSISDNDialog.text=prefs.getString("SubscriberNumber");
      });
      returnContactInfoByCustNumberCRM_API(customerNumber);
    }

    if (prefs.containsKey("customerID")) {
      setState(() {
        customerNumber = prefs.getString("customerID");
        FirstContentFlag = true;
      });
    }
    if (prefs.containsKey("customerID")) {
      setState(() {
        customerNumber = prefs.getString("customerID");
        FirstContentFlag = true;
      });
    }
    if (prefs.containsKey("customerName")) {
      setState(() {
        customerName = prefs.getString("customerName");
        FirstContentFlag = true;
      });
    }
    if (prefs.containsKey("SubscriberNumber")) {
      setState(() {
        SubscriberNumber = prefs.getString("SubscriberNumber");
        FirstContentFlag = true;
      });
      print("prefs.getString");
      print(prefs.getString("SubscriberNumber"));
    }
  }


  Widget buildCustomerID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.customerid".tr().toString(),
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
              color: emptyCustomerId==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyCustomerId ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: CustomerID,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "LogVisit.enter_customerid".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyCustomerId  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }

  Widget buildSubject() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.subject".tr().toString(),
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
                color:emptySubject == true
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
                  items:SUBJECTS.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["code"] ,
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")?Text(valueItem["value"]):Text(valueItem["valueAr"]),
                    );
                  }).toList(),
                  value: selectedSubjectValue,
                  onChanged: (String newValue) {


                    setState(() {
                      selectedSubjectValue = newValue;


                    });

print(selectedSubjectValue);


                  },
                ),
              ),
            )),
        emptySubject==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildDescription() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.description".tr().toString(),
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
              color: emptyDescription==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyDescription ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 120,
          child: TextField(
            maxLines: 6,
            controller: Description,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "LogVisit.enter_description".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyDescription  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }

  Widget buildFromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.DateVisite".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 10),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,

          // width:MediaQuery.of(context).size.width/2,
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
                    icon: Icon(Icons.calendar_month),
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

  /*.................................................new..............................................................*/
  void todayDate() {
    var now = new DateTime.now();
    String formattedTime = DateFormat('kk:mm:ss').format(now);
    var formatedTime = from.toIso8601String().split(new RegExp(r"[T\.]"));
    print("/*9999999999999*/");
    print(formatedTime[0]);
    print(formattedTime);
    var hayaHazaimeh= "${formatedTime[0]} ${formattedTime}";
    DateTime dt1 = DateTime.parse(hayaHazaimeh);
    print(dt1);
    print(dt1.toIso8601String());
    print("/*9999999999999*/");






  }

  void manualVisit(value) async {
    setState(() {
      switchManualVisit = !switchManualVisit;
      //startTime.text='';
      // endTime.text='';
    });

    if(switchManualVisit==false){
      setState(() {

        startTime.text='';
        endTime.text='';
      });
    }
    print(switchManualVisit);
    print(startTime.text); print(endTime.text);
  }

  Widget buildManualVisit() {
    return Container(
      padding: EdgeInsets.only(left: 0),
      // color: Colors.cyan,
      height: 20,
      child: Row(

        children: <Widget>[
          Switch(
            value: switchManualVisit,
            onChanged: (value) {
              manualVisit(value);
            },
            activeTrackColor: Color(0xFF767699),
            activeColor: Color(0xFF392156),
            inactiveTrackColor: Color(0xFFEBECF1),
          ),
          Text(
            "LogVisit.ManualVisit".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }

  Widget buildStartTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.StartTime".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,

          width:MediaQuery.of(context).size.width/2,
          child: TextField(
            controller: startTime,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color:  Color(0xFF656565),fontSize: 14 ),
            decoration: new InputDecoration(
              enabledBorder: emptyStartTime == true
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
              contentPadding: EdgeInsets.only(top: 3,bottom: 3,left: 3,right: 3),
              suffixIcon: Container(

                child: IconButton(
                    icon: Icon(Icons.alarm_outlined),
                    onPressed: () async {
                      TimeOfDay pickedTime= await
                      showTimePicker(

                        context: context,
                        initialTime: TimeOfDay.now(),

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
                      );
                      if(pickedTime != null ){


                        Intl.defaultLocale = 'en';
                        // EasyLocalization.of(context).locale == Locale("en", "US")


                        print(context.locale.toString());
                        print(pickedTime.format(context)); //output 10:51 PM


                        String getTime= pickedTime.format(context);
                        print(getTime);
                        //split string
                        var arr = getTime.split(' ');
                        print("length");
                        print(arr.length);
                        if(arr.length>=2){
                          setState(() {
                            am_pm=arr[1];
                          });
                        }else{
                          setState(() {
                            am_pm=arr[0];
                          });
                        }
                        // String am_pm=arr[1];
                        print(arr);
                        print(am_pm);

                        if(am_pm=='ص'){
                          setState(() {
                            en_am_pm='AM';
                          });
                        } else
                        if(am_pm=='م'){
                          setState(() {
                            en_am_pm='PM';
                          });
                        }else{
                          en_am_pm=am_pm;
                        }

                        print(en_am_pm);
                        DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context));

                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000

                        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);

                        getFormatterStartTime=formattedTime;
                        print(getFormatterStartTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.



                        /*******************************************************/

                        /****************This Part to Convert from 12 to 24 houre*****************/


                        var arrTwo=getFormatterStartTime.split(':');
                        String arrTwo_1=arrTwo[0];
                        print(arrTwo);
                        print(arrTwo_1);
                        String first=arrTwo[0];


                        if(first=="01" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="13"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="02" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="14"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="03" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="15"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="04" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="16"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="05" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="17"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="06" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="18"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="07" &&(am_pm=='م' || am_pm=='PM')){
                          String finalresult="19"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="08" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="20"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="09" &&(am_pm=='م' || am_pm=='PM')){
                          String finalresult="21"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="10" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="22"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }

                        if(first=="11" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="23"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }
                        if(first=="12" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="12"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }


                        /*******************************************************/

                        setState(() {
                          startTime.text = formattedTime; //set the value of text field.
                        });
                      }else{
                        print("Time is not selected");
                      }
                    }),
              ),
              hintText: "HH:mm:ss",
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        emptyStartTime
            ? RequiredFeild(
            text: "Reports.this_feild_is_required"
                .tr()
                .toString())
            : Container(),
      ],
    );
  }

  Widget buildEndTime() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.EndTime".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14.0,
              fontWeight: FontWeight.normal,
            ),

          ),
        ),
        SizedBox(height: 5),
        Container(
          color: Colors.white,
          alignment: Alignment.centerLeft,

          width:MediaQuery.of(context).size.width/2,
          child: TextField(
            controller: endTime,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xFF656565),fontSize: 14 ),
            decoration: new InputDecoration(
              enabledBorder: emptyEndTime == true
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
              contentPadding: EdgeInsets.only(top: 3,bottom: 3,left: 3,right: 3),

              suffixIcon: Container(

                child: IconButton(
                    icon: Icon(Icons.alarm_outlined),
                    onPressed: () async {
                      TimeOfDay pickedTime= await
                      showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),

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
                      );
                      if(pickedTime != null ){
                        print(pickedTime.format(context));

                        String getTime= pickedTime.format(context);
                        print(getTime);
                        //split string
                        var arr = getTime.split(' ');
                        if(arr.length>=2){
                          setState(() {
                            am_pm=arr[1];
                          });
                        }else{
                          setState(() {
                            am_pm=arr[0];
                          });
                        }
                        // String am_pm=arr[1];
                        print(arr);
                        print(am_pm);

                        if(am_pm=='ص'){
                          setState(() {
                            en_am_pm='AM';
                          });
                        } else
                        if(am_pm=='م'){
                          setState(() {
                            en_am_pm='PM';
                          });
                        }else{
                          en_am_pm=am_pm;
                        }//output 10:51 PM
                        DateTime parsedTime = DateFormat.Hm().parse(pickedTime.format(context).toString());
                        //converting to DateTime so that we can further format on different pattern.
                        print(parsedTime); //output 1970-01-01 22:53:00.000
                        String formattedTime = DateFormat('HH:mm:ss').format(parsedTime);
                        print(formattedTime); //output 14:59:00
                        //DateFormat() is from intl package, you can format the time on any pattern you need.
                        getFormatterEndTime=formattedTime;
                        print('/**************/');
                        print(getFormatterEndTime);
                        print('/**************/');




                        /****************This Part to Convert from 12 to 24 houre*****************/


                        var arrTwo=getFormatterEndTime.split(':');
                        String arrTwo_1=arrTwo[0];
                        print(arrTwo);
                        print(arrTwo_1);
                        String first=arrTwo[0];

                        if(first=="01" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="13"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="02" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="14"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="03" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="15"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="04" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="16"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="05" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="17"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="06" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="18"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="07" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="19"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="08" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="20"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="09" &&(am_pm=='م' || am_pm=='PM')){
                          String finalresult="21"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="10" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="22"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }

                        if(first=="11" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="23"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterEndTime=finalresult;
                          });
                        }
                        if(first=="12" && (am_pm=='م' || am_pm=='PM')){
                          String finalresult="12"+":"+arrTwo[1]+":"+arrTwo[2];
                          print("*****Final*******");
                          print(finalresult);
                          print("*****Final*******");
                          setState(() {
                            getFormatterStartTime=finalresult;
                          });
                        }

                        /*******************************************************/

                        setState(() {
                          endTime.text = formattedTime; //set the value of text field.
                        });


                      }else{
                        print("Time is not selected");
                      }
                    }),
              ),
              hintText: "HH:mm:ss",
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        SizedBox(height: 5),
        emptyEndTime
            ? RequiredFeild(
            text: "Reports.this_feild_is_required"
                .tr()
                .toString())
            : Container(),
      ],
    );
  }


  /*...............................................End new............................................................*/


  Widget buildGetContactListhBtn() {

    return Padding(
      padding: const EdgeInsets.only(top: 10.0,bottom: 10),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3))),
            ),
            onPressed: () {

              returnContactInfoByCustNumberCRMbyCustomerId_API();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search,color: Colors.white,),
                SizedBox(width: 10,),
                Text(
                  "LogVisit.getcontactList".tr().toString(),
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

  Widget buildContactMSISDN() {
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.contact_name".tr().toString(),
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
                color:emptyContactMSISDN == true
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
                  items: CONTACT_NAME.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem ,
                      child: Text(valueItem.toString()),

                    );
                  }).toList(),
                  value: selectedContactNameNValue,
                  onChanged: (String newValue) {
                    print(newValue);

                    print(selectedContactNameNValue);
                    setState(() {
                      selectedContactNameNValue = newValue;


                    });
                    print(selectedContactNameNValue);





                  },
                ),
              ),
            )),
        emptyContactMSISDN==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );

  }
  Widget buildAddContactBtn() {

    return Padding(
      padding: const EdgeInsets.only(top: 35.0,bottom: 10),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
          color: Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(3))),
            ),
            onPressed: () {
              if(newUser==true){
                CustomerIDDialog.text='';
              }
              /***************************************************New 2023*********************************************************************/
              setState(() {
                FirstName.text='';
                LastName.text='';
                JobTitle.text='';
                ContactMSISDNDialog.text='';
              });
              /******************************************************End New 2023******************************************************************/

              //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
              _showAddContactDialog();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.person_add,color: Colors.white,),
                SizedBox(width: 10,),
                Text(
                  "LogVisit.add_contact".tr().toString(),
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

  Widget buildSubmitBtn() {

    return Padding(
      padding: const EdgeInsets.only(top: 10.0,bottom: 10),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: SubmitLoading?Color(0xFF0E7074).withOpacity(0.3): Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(
              // backgroundColor: Color(0xFF0E7074),
              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: SubmitLoading==true?null: () {

              createAppointmentDynamicsCRM_API();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "LogVisit.submit".tr().toString(),
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



  /*****************************************Content of add contact dialog ********************************/
  Widget buildFirstName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.first_name".tr().toString(),
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
              color: emptyFirstName==true ||customerFirstNameValidation==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyFirstName ||customerFirstNameValidation?Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: FirstName,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
              onChanged: (value){
              if(value.length<4){
                setState(() {
                  customerFirstNameError=EasyLocalization.of(context).locale == const Locale("en", "US")? "You must be insert valid customer name": "يجب عليك إدخال اسم العميل الصحيح";
                  customerFirstNameValidation=true;
                });
              }else{
                setState(() {
                  customerFirstNameError="";
                  customerFirstNameValidation=false;
                });
              }

              }
          ),

        ),
        customerFirstNameValidation==true?   RequiredFeild(
            text:customerFirstNameError)
            : Container(),
        emptyFirstName  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }
  Widget buildLastName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.last_name".tr().toString(),
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
              color: emptyLastName==true ||customerSecondNameValidation==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyLastName ||customerFirstNameValidation?Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: LastName,
            keyboardType: TextInputType.text,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              // hintText: "corporetUser.Enter".tr().toString()+' '+"${this.selectedSearchCriteria}",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
              onChanged: (value){
                if(value.length<4){
                  setState(() {
                    customerSecondNameError=EasyLocalization.of(context).locale == const Locale("en", "US")? "You must be insert valid customer name": "يجب عليك إدخال اسم العميل الصحيح";
                    customerSecondNameValidation=true;
                  });
                }else{
                  setState(() {
                    customerSecondNameError="";
                    customerSecondNameValidation=false;
                  });
                }

              }
          ),
        ),
        customerSecondNameValidation==true?   RequiredFeild(
            text:customerSecondNameError)
            : Container(),
        emptyLastName  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }

  Widget buildJobTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.job_title".tr().toString(),
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
              color: emptyJobTitle==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyJobTitle ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: JobTitle,
            inputFormatters: [
              FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
            ],
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
        emptyJobTitle == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }

  Widget buildCustomerIDDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.customerid".tr().toString(),
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
              color: emptycustomerIdDialog==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptycustomerIdDialog ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: CustomerIDDialog,
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
        emptycustomerIdDialog == true
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

  Widget buildContactMSISDINDialog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.ContactMSISDN".tr().toString(),
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
              color: emptyContactMSISDNDialog==true || contactNumberValidation==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyContactMSISDNDialog || contactNumberValidation==true? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 50,
          child: TextField(
            controller: ContactMSISDNDialog,
            keyboardType: TextInputType.number,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onChanged: (value) {

              if(value.length < 9 || value.length > 10){
                setState(() {
                  msisdnError= EasyLocalization.of(context).locale == const Locale("en", "US")? "Number must be 9 or 10 digits": "يجب أن يتكون الرقم من 9 أو 10 أرقام";
                  contactNumberValidation=true;
                });
              }
              if(value.length ==10){
                if(value.startsWith('079') ||value.startsWith('077') ||value.startsWith('078')){
                  setState(() {
                    contactNumberValidation=false;
                  });
                }else{
                  setState(() {
                    msisdnError= EasyLocalization.of(context).locale == const Locale("en", "US")? "Mobile number must be 10 digits \n and start with there code": "يجب أن يكون رقم الهاتف المحمول مكونًا من 10 أرقام ويبدأ بالرمز الخاص به";
                    contactNumberValidation=true;
                  });
                }
              }
             if(value.length ==9){
               if(value.startsWith('06') ||value.startsWith('02') ||value.startsWith('03')||ContactMSISDNDialog.text.startsWith('05')&&(!value.startsWith('079') ||!value.startsWith('077') ||!value.startsWith('078'))){
                 setState(() {
                   contactNumberValidation=false;
                 });
               }else{
                 setState(() {
                   msisdnError= EasyLocalization.of(context).locale == const Locale("en", "US")?  "Landline number must be 9 digits \n and start with there code": "يجب أن يكون رقم الهاتف الأرضي مكونًا من 9 أرقام ويبدأ بالرمز الخاص به";
                   contactNumberValidation=true;
                 });
               }
             }

            },
          ),

        ),

    contactNumberValidation==true?   RequiredFeild(
    text:msisdnError)
        : Container(),
        emptyContactMSISDNDialog == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

        SizedBox(height: 20),
      ],
    );
  }





  /*****************************************Content of add contact dialog ********************************/
  Future<void> _showAddContactDialog() async {
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

                    buildFirstName(),
                    SizedBox(height: 10,),
                    buildLastName(),
                    SizedBox(height: 10,),
                    buildJobTitle(),
                    SizedBox(height: 10,),
                    buildCustomerIDDialog(),
                    SizedBox(height: 15,),
                    buildContactMSISDINDialog(),
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
                              FirstName.text='';
                              LastName.text='';
                              JobTitle.text='';
                              CustomerIDDialog.text='';
                              ContactMSISDNDialog.text='';


                              emptyFirstName=false;
                              emptyLastName=false;
                              emptyJobTitle=false;
                              emptycustomerIdDialog=false;
                              emptyContactMSISDNDialog=false;
                              contactNumberValidation=false;
                              addContactLoading=false;


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


                            ), child:

                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              addContactLoading==true? SizedBox(
                                child: CircularProgressIndicator(color: Colors.white ),
                                height: 10.0,
                                width: 10.0,
                              ):Container(),
                              addContactLoading==true?  SizedBox(width: 16):Container(),
                              Text("Authorized.Add".tr().toString())],

                          ),


                            onPressed: addContactLoading==true?null:() async {

                              //Navigator.pop(context);
                              //getSubscriberList_API(page);
                              if (FirstName.text == "") {
                                setState(() {
                                  emptyFirstName = true;
                                });
                                Navigator.pop(context);
                                _showAddContactDialog();
                              }
                              else if (FirstName.text != "") {
                                setState(() {
                                  emptyFirstName = false;
                                });
                                if(FirstName.text.length < 4 ){
                                  setState(() {
                                    customerFirstNameError=EasyLocalization.of(context).locale == const Locale("en", "US")? "You must be insert valid customer name": "يجب عليك إدخال اسم العميل الصحيح";
                                    customerFirstNameValidation=true;
                                  });
                                }
                                else{
                                  setState(() {
                                    customerFirstNameError="";
                                    customerFirstNameValidation=false;
                                  });
                                }
                              }

                              if (LastName.text == "") {
                                setState(() {
                                  emptyLastName = true;
                                });
                                Navigator.pop(context);
                                _showAddContactDialog();

                              }
                              else if (LastName.text != "") {
                                setState(() {
                                  emptyLastName = false;
                                });
                                if(LastName.text.length < 4 ){
                                  setState(() {
                                    customerSecondNameError=EasyLocalization.of(context).locale == const Locale("en", "US")? "You must be insert valid customer name": "يجب عليك إدخال اسم العميل الصحيح";
                                    customerSecondNameValidation=true;
                                  });
                                }else{
                                  setState(() {
                                    customerSecondNameError="";
                                    customerSecondNameValidation=false;
                                  });
                                }

                              }

                              if (JobTitle.text == "") {
                                setState(() {
                                  emptyJobTitle = true;
                                });
                                Navigator.pop(context);
                                _showAddContactDialog();

                              }else if(JobTitle.text != ""){
                                setState(() {
                                  emptyJobTitle = false;
                                });
                              }




                              if (ContactMSISDNDialog.text == "") {
                                setState(() {
                                  emptyContactMSISDNDialog = true;
                                });
                                Navigator.pop(context);
                                _showAddContactDialog();

                              }else if(ContactMSISDNDialog.text != ""){
                                setState(() {
                                  emptyContactMSISDNDialog = false;
                                });
                                //ContactMSISDNDialog  msisdnError
                                if(ContactMSISDNDialog.text.length < 9 || ContactMSISDNDialog.text.length > 10){
                                  setState(() {
                                    contactNumberValidation=true;
                                  });
                                }
                                if(ContactMSISDNDialog.text.length == 9 || ContactMSISDNDialog.text.length == 10){

                                  setState(() {
                                    contactNumberValidation=false;
                                  });
                                }
                              }

                              if (ContactMSISDNDialog.text != "" && JobTitle.text != ""
                                  && LastName.text!='' && FirstName.text!=''  && FirstName.text.length>=4 && LastName.text.length>=4) {
                                FocusScope.of(context).unfocus();
                                if(ContactMSISDNDialog.text.length == 9 || ContactMSISDNDialog.text.length == 10){
                                  if(ContactMSISDNDialog.text.length ==10){
                                    if(ContactMSISDNDialog.text.startsWith('079') ||ContactMSISDNDialog.text.startsWith('077') ||ContactMSISDNDialog.text.startsWith('078')){
                                      setState(() {
                                        contactNumberValidation=false;
                                      });
                                      addContact_API();
                                    }else{
                                      setState(() {
                                        msisdnError= EasyLocalization.of(context).locale == const Locale("en", "US")?  "Mobile number must be 10 digits \n and start with there code": "يجب أن يكون رقم الهاتف المحمول مكونًا من 10 أرقام ويبدأ بالرمز الخاص به";
                                        contactNumberValidation=true;
                                      });
                                    }
                                  }
                                  if(ContactMSISDNDialog.text.length ==9){
                                    if(ContactMSISDNDialog.text.startsWith('06') ||ContactMSISDNDialog.text.startsWith('02') ||ContactMSISDNDialog.text.startsWith('03') ||ContactMSISDNDialog.text.startsWith('05')&& (!ContactMSISDNDialog.text.startsWith('079') ||!ContactMSISDNDialog.text.startsWith('077') ||!ContactMSISDNDialog.text.startsWith('078'))){
                                      setState(() {
                                        contactNumberValidation=false;
                                      });
                                      addContact_API();
                                    }else{
                                      setState(() {
                                        msisdnError= EasyLocalization.of(context).locale == const Locale("en", "US")? "Landline number must be 9 digits \n and start with there code": "يجب أن يكون رقم الهاتف الأرضي مكونًا من 9 أرقام ويبدأ بالرمز الخاص به";
                                        contactNumberValidation=true;
                                      });
                                    }
                                  }

                                }

                                //  Navigator.pop(context);
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

  Widget showNewContact() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "LogVisit.contact_name".tr().toString(),
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
          child: TextField(

            enabled: false,
            controller: newContact,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.text,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMAISDNTest== true || errorMAISDNTest==true
                  ? const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFB10000), width: 1.0),
              )
                  : const OutlineInputBorder(
                // width: 0.0 produces a thin "hairline" border
                borderSide: const BorderSide(
                    color: Color(0xFFD1D7E0), width: 1.0),
              ),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4F2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: EasyLocalization
                  .of(context)
                  .locale == Locale("en", "US")?"add contect":"اضافة جهة اتصال",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: ()=>{
              setState(() {

              })
            },

          ),
        )
      ],
    );
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
              title: Text("LogVisit.Log_Visit".tr().toString(),),

              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async{

                  Navigator.pop(context);
                },
              ),
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings_backup_restore),
                  tooltip: 'Show Snackbar',
                  onPressed: () async{
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    prefs.setInt('SavePageIndex', 2);
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CorpNavigationBar(PermessionCorporate:
                        prefs.getStringList('PermessionCorporate'),role:prefs.getString('role'),

                        ),
                      ),
                    );
                    /*     Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectUser(PermessionCorporate, role),
              ),

            );*/

                  },
                ),]//<Widget>[]

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
              ? ListView(
            shrinkWrap: true,
            physics: ClampingScrollPhysics(),
            padding: EdgeInsets.only(top: 0, left: 0, right: 0),
            children: <Widget>[

              FirstContentFlag==true &&newUser==false
                  ?
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

              FirstContentFlag==true &&newUser==false? Container(
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


              Container(

                padding: EdgeInsets.only(top: 20, left: 26,right: 26,),
                color: Colors.white,
                child:
                Column
                  (
                  children: [
                    buildSubject(),
                    SizedBox(height: 15,),
                    buildDescription(),
                    SizedBox(height: 15,),
                    buildFromDate(),
                    /*  Container(
                      child:
                      Row(children: [
                        Expanded(child: buildFromDate()),
                        SizedBox(width: 20,),
                        Expanded(child: buildToDate())
                      ],),
                    ),*/

                    SizedBox(height: 10,),
                    switchManualVisit== true?SizedBox(height: 10,):Container(),
                    switchManualVisit== true?
                    Container(
                      child:
                      Row(children: [
                        Expanded(child: buildStartTime()),
                        SizedBox(width: 20,),
                        Expanded(child: buildEndTime())
                      ],),
                    ):Container(),
                    SizedBox(height: 10,),
                    buildManualVisit(),
                    switchManualVisit== true?
                    SizedBox(height: 20,):Container(),
                    switchManualVisit== false?
                    SizedBox(height: 20,):Container(),
                    FirstContentFlag==true &&newUser==false?
                    buildCustomerID():Container(),
                    SizedBox(height: 10,),
                    FirstContentFlag==true &&newUser==false?
                    buildGetContactListhBtn():Container(),
                    newUser!=true? SizedBox(height: 10,):Container(),



                    newUser!=true?

                    Row(children: [
                      Expanded(child: buildContactMSISDN()),
                      SizedBox(width: 20,),
                      Expanded(child: buildAddContactBtn())
                    ],):Container(),
                    newUser!=true? SizedBox(height: 20,):Container(),



                    //////////////////////////////////////////FOR TESTING 2024//////////////////////////////////////////
                    newUser==true?
                    Container(
                      color: Colors.white,
                      //padding: EdgeInsets.only(left: 15, right: 15),
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 3,right: 3),
                                  child: showNewContact(),
                                ),
                              ),
                              Container(
                                height: 45,
                                margin: EasyLocalization
                                    .of(context)
                                    .locale == Locale("en", "US")? EdgeInsets.only(top: 24.0):EdgeInsets.only(top: 32.0), // Adjust the margin as needed
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Color(0xFF0E7074), // Set the desired background color
                                  ),
                                  onPressed: () {
                                    if(newUser==true){
                                      CustomerIDDialog.text='';
                                    }
                                    /***************************************************New 2023*********************************************************************/
                                    setState(() {
                                      FirstName.text='';
                                      LastName.text='';
                                      JobTitle.text='';
                                      ContactMSISDNDialog.text='';
                                    });
                                    /******************************************************End New 2023******************************************************************/

                                    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
                                    _showAddContactDialog();

                                  },
                                  child: Icon(Icons.person_add),
                                ),
                              ),
                            ],
                          ),

                          SizedBox(height: 10),
                        ],
                      ),
                    ):Container(),

                  ],
                ),
              ),

              /* Container(
                padding: EdgeInsets.only(top:10, left: 26,right: 26,bottom: 10),
                child:
                Row(children: [
                  Expanded(child: buildContactMSISDN()),
                  SizedBox(width: 20,),
                  Expanded(child: buildAddContactBtn())
                ],),
              ),*/
              Container(
                padding: EdgeInsets.only(top:10, left: 26,right: 26,bottom: 10),

                child: buildSubmitBtn(),
              ),




            ],
          ):Container(),
        ),
      ),

      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////




    );
  }
}
