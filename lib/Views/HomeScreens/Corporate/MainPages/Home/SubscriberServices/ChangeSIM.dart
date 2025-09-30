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





class ChangeSIM extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  ChangeSIM(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _ChangeSIMState createState() =>
      _ChangeSIMState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();

class _ChangeSIMState extends State<ChangeSIM> {
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
  bool isLoadingCheckSIM=false;
  ///////////////////////variable from API//////////////////////////////////////

  bool emptySIM=false;
  var simType="";
  bool isFOC =false;
  bool submitEnabled=false;
  bool emptyEmployeeName =false;
  bool emptyEmployeeNumber=false;
  bool emptyFOCNote=false;
  var oldSim='';

  var selectedEmployeeName;

  var EMPLOYEENAMES=[];
  bool LoadingF0C=false;

  ///////////////////////End variable from API/////////////////////////////////


  TextEditingController NewSIM = TextEditingController();
  TextEditingController EmployeeNumber = TextEditingController();
  TextEditingController FOCNote = TextEditingController();
  _ChangeSIMState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


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
    SearchCrateria_API();
    getEmplyeeNames_API();
    //disableCapture();
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

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

  SearchCrateria_API() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {"searchID": searchID, "searchValue": searchValue};

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/search';
    final Uri url = Uri.parse(apiArea);
    print(url);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: body,
    );
    print(body);
    int statusCode = response.statusCode;
    print('muy status coed');
    print(statusCode);

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);

      if (result["status"] == 0) {
        print('look up');
        print(result['data']);

        print('saffiiiiiiii');


        setState(() {
          oldSim = result["data"][0]['sim'];
        });
      } else {
        print('hello');
        showAlertDialogERROR(context, result["messageAr"], result["message"]);
      }

      return result;
    } else {
      showAlertDialogOtherERROR(context, statusCode, statusCode);
    }
  }
  void checkSIMInfo_API () async{
    if(NewSIM.text==''){
      setState(() {
        emptySIM=true;
      });
    }
    else{
      setState(() {
        emptySIM=false;
        isLoadingCheckSIM=true;
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();

      var apiArea = urls.BASE_URL + '/Customer360/getSIMInfo';



      final Uri url = Uri.parse(apiArea);

      Map body = {
        "sim": NewSIM.text,

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

        print(result["data"]);

        if( result["status"]==0){
          if(result["data"]==null){
            showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


          }else{


            print(result["data"]);

            if(result['data']['simType']!='') {
              setState(() {
                simType = result['data']['simType'];
                isLoadingCheckSIM = false;
                submitEnabled=true;
              });
            }else{
              showAlertDialogNoData(context,"لا يوجد SIM نوع متاح الآن.", "No SIM type available now .");
              setState(() {

                submitEnabled=false;
                isLoadingCheckSIM=false;
              });
            }




          }

        }else{
          setState(() {

            submitEnabled=false;
            isLoadingCheckSIM=false;
          });
          showAlertDialogERROR(context,result["messageAr"], result["message"]);



        }

      }else{
        setState(() {

          submitEnabled=false;
          isLoadingCheckSIM=false;
        });
        showAlertDialogOtherERROR(context,statusCode, statusCode);

      }
    }
  }

  getEmplyeeNames_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lookup/ACTIVE_USERS';
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
          print('emplo');
          print(result["data"]);
          setState(() {

            EMPLOYEENAMES=result["data"];
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

  changeSimValidateZainService_API() async{

    if(isFOC==true){

      if(selectedEmployeeName==null){
        setState(() {
          emptyEmployeeName=true;
        });
      }else if(selectedEmployeeName!=null){
        setState(() {
          emptyEmployeeName=false;
        });
      }

      if(EmployeeNumber.text==''){
        setState(() {
          emptyEmployeeNumber=true;
        });
      }else if(EmployeeNumber.text!=''){
        setState(() {
          emptyEmployeeNumber=false;
        });
      }

      if(emptyEmployeeNumber==false && emptyEmployeeName==false ){
        submit();
      }}
    else{
      submit();
    }

  }

  submit() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Customer360/changeSimValidateZainService';
    setState(() {
      isLoading=true;
    });
    final Uri url = Uri.parse(apiArea);

    print(url);
    Map body = {
      "mobileNo": msisdn,
      "addDualSIMService": "false",
      "isFromDualSIM": simType=="DUAL" ? "true":"false",
      "employeeId": selectedEmployeeName,
      "employeeMsisdn": EmployeeNumber.text,
      "isFocException": isFOC,
      "newMSISDN": "",
      "newSimCardSerial":NewSIM.text ,
      "notes": FOCNote.text,
      "selectedUserId": "0",
      "isESim": false,
      "email": "",
      "simType": 0

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
  //    showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");

    }
    if (statusCode == 200) {


      setState(() {

        isLoading=false;
      });
      var result = json.decode(response.body);

      print(result["data"]);
      print(result);


      if( result["status"]==0){
        if(result["data"]==null){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{
          showToast(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? result["message"]
                  : result["messageAr"],
              context: context,
              animation: StyledToastAnimation.scale,
              fullWidth: true);

          Navigator.pop(context);




        }

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
  Widget buildCheckSIM() {

    return Padding(
      padding: const EdgeInsets.all(0),
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
            onPressed: (){

              checkSIMInfo_API();
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoadingCheckSIM==true?SizedBox(
                  child: CircularProgressIndicator(color: Colors.white ),
                  height: 20.0,
                  width: 20.0,
                ):
                Container(),
                SizedBox(width: 10,),

                Text(
                  "SubscriberServices.check_sim".tr().toString(),
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
  Widget buildSubmitSIM() {

    return Padding(
      padding: const EdgeInsets.all(0),
      child: Container(
        height: 48,
        //margin: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
          color: submitEnabled==false?Color(0xFF0E7074).withOpacity(0.6): Color(0xFF0E7074),
        ),
        child: TextButton(
            style: TextButton.styleFrom(

              shape: const BeveledRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(24))),
            ),
            onPressed: submitEnabled==false ?null: isLoading==true?null: (){

              changeSimValidateZainService_API();
            },
            child: Row(
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
            )
        ),
      ),
    );
  }


  Widget buildEmployeeName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberServices.employee_name".tr().toString(),
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
                color:emptyEmployeeName == true
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
                  items: EMPLOYEENAMES.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["code"] ,
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")?Text(valueItem["value"]):Text(valueItem["valueAr"]),
                    );
                  }).toList(),
                  value: selectedEmployeeName,
                  onChanged: (String newValue) {


                    setState(() {
                      selectedEmployeeName = newValue;


                    });




                  },
                ),
              ),
            )),
        emptyEmployeeName==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }
  Widget buildEmployeeNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberServices.employee_number".tr().toString(),
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
              color: emptyEmployeeNumber==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyEmployeeNumber ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 58,
          child: TextField(
            controller: EmployeeNumber,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "SubscriberServices.enter_employee_name".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyEmployeeNumber  == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }
  Widget buildFOCNote() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberServices.foc_notes".tr().toString(),
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
              color: emptyFOCNote==true
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: emptyFOCNote ? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width:  1,
              )),
          height: 200,
          child: TextField(
            maxLines: 6,
            controller: FOCNote,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xFF11120E)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              //   hintText: "SubscriberServices.enter_new_sim".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),
        emptyFOCNote  == true
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
            title: Text("SubscriberServices.change_sim".tr().toString(),),
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
              ? SingleChildScrollView(
            child: Column(
              children: [
                Container(

                  padding: EdgeInsets.only(top: 20,
                      left: 26,right: 26,bottom: 20),
                  color: Colors.white,
                  child:
                  Column
                    (
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        // margin: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SubscriberServices.subscriber_number"
                                          .tr()
                                          .toString(),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      msisdn ,
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
                      ),
                      SizedBox(height: 10,),
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        // margin: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SubscriberServices.old_sim"
                                          .tr()
                                          .toString(),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      oldSim,
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
                      ),
                      SizedBox(height: 10,),
                      buildNewSIM(),
                      SizedBox(height: 15,),
                      buildCheckSIM()
                    ],
                  ),
                ),
                SizedBox(height: 10,),
                submitEnabled==true? Container(

                  padding: EdgeInsets.only(top: 20, left: 26,right: 26,bottom: 20),
                  color: Colors.white,
                  child:
                  Column
                    (
                    children: [
                      Container(
                        color: Colors.white,
                        width: double.infinity,
                        // margin: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [

                            Expanded(
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "SubscriberServices.sim_type"
                                          .tr()
                                          .toString(),
                                    ),
                                    SizedBox(height: 1),
                                    Text(
                                      simType,
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14.0,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Spacer(),
                            GestureDetector(
                              onTap: () async {
                                print('called');
                                setState(() {
                                  isFOC = !isFOC;
                                   LoadingF0C=true;
                                });

                                await Future.delayed(const Duration(seconds: 2), (){
                                  setState(() {

                                    LoadingF0C=false;
                                  });
                                });
                              },
                              child: Container(

                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(

                                      decoration:
                                      BoxDecoration(
                                          border: Border.all(
                                            color: isFOC?Color(0xFF0E7074): Colors.grey,
                                            width: 1,
                                          ),
                                          shape: BoxShape.circle,
                                          color: isFOC==false?Colors.white: Color(0xFF0E7074)

                                      ),

                                      padding: EdgeInsets.all(1),
                                      child: isFOC
                                          ? Icon(
                                        Icons.check,
                                        size:   15.0,
                                        color: Colors.white,
                                      )
                                          : Icon(
                                        Icons.check,
                                        size: 15.0,
                                        color:Colors.white,
                                      ),
                                    ),


                                    SizedBox(width: 10,),
                                    Text(
                                      "SubscriberServices.is_foc"
                                          .tr()
                                          .toString(),
                                    ),


                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20,),


                      LoadingF0C==true? Row(
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

                      ):  isFOC==true?
                      Column(
                        children: [
                          buildEmployeeName(),
                          SizedBox(height: 15,),
                          buildEmployeeNumber(),
                          SizedBox(height: 15,),
                          buildFOCNote(),

                          SizedBox(height: 15,),
                          buildSubmitSIM(),

                          SizedBox(height: 20,),
                        ],
                      ):buildSubmitSIM(),
                    ],
                  ),
                ):Container(),




              ],
            ),
          ):Container(),
        ),
      ),

      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////




    );
  }
}