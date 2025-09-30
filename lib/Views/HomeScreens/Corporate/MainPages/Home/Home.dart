import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/360View.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/newAccountsDocumentsChecking.dart';

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
import 'package:flutter_windowmanager/flutter_windowmanager.dart';

class Home extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  // String PermessionCorporate;
  String role;



  Home(this.PermessionCorporate, this.role);
  @override
  _HomeState createState() =>
      _HomeState(this.PermessionCorporate, this.role);
}

class Item {
  const Item(this.key,this.code,this.value, this.valueAr);
  final key;
  final code;
  final String value;
  final String valueAr;

}
List<Item> SearchCriteria = <Item>[];

class _HomeState extends State<Home> {
  List data=[];
  BuildContext dcontext;

  dismissDailog(){
    if(dcontext != null){
      Navigator.pop(dcontext);
    }
  }

// Declare your method channel varibale here
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');
  bool serchByEmptyFlag = false;
  bool criteriaEmptyFlag = false;
  bool select=false;
  bool checkMobileNumber=false;
  bool checkCustomerNumber = false;
  bool loading=false;
  String selectedSearchCriteria;
  String selectedSearchCriteria1;
  String selectedSearchCriteria2;

  int searchID;
  String searchValue;

  String msisdn;
  String customerNumber;

  DateTime backButtonPressedTime;
  bool isLoading = false;

  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;
  APP_URLS urls = new APP_URLS();


  TextEditingController valueOfCriteria = TextEditingController();
  TextEditingController Mobile_number = TextEditingController();

  _HomeState(this.PermessionCorporate, this.role);
  LookupSearchCriteriaBloc lookupSearchCriteriaBloc;
  SearchCriteriaBloc searchCriteriaBloc;


/*********************NEW*********************/
  String newSellec;
  bool SellectCheck=false;
  int idddd;
  String kkkkkk;
  bool showGo360Viwe=false;
  String _customerName;
  String _subscriberName;
  String _customerID;
/******************************************/


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
    print("role Of Corporate");
    print(role);
    newFunction();

    if(PermessionCorporate==null){
      UnotherizedError();
    }else{
      searchCriteriaBloc = BlocProvider.of<SearchCriteriaBloc>(context);
    }


    LookUpSearchCrateria_API();
    //disableCapture();
    // this method to user can't take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");
    checkIndexPage ();
    super.initState();
  }


  @override
  void dispose() {

    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    // TODO: implement dispose
    super.dispose();
  }


  void newFunction()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();


    if(prefs.containsKey("selectedSearchCriteria2save")){
      print(">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
       setState(() {
         newSellec = prefs.getString('selectedSearchCriteria2save');
         idddd=prefs.getInt('searchIDd');
         SellectCheck=true;
         kkkkkk=prefs.getString('searchValuenew');
         showGo360Viwe=true;
         _customerName=prefs.getString("customerName");
         _subscriberName=prefs.getString("subscriberName");
         _customerID=prefs.getString("customerID");
       });

    }
  }
  void checkIndexPage () async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    await preferences.remove('SavePageIndex');
  }
   disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
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
    print("*****************************************Body************************************************");
    print(body);
    print("******************************************Response******************************************");
    //print(json.decode(response.body));
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }else{
      print("wrong responce");
    }

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      print('iam hetee');
      UnotherizedError();
    }

     if (statusCode == 200) {

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
          setState(() {
            isLoading =false;
            data=result["data"];
            msisdn=result["data"][0]['msisdn'];
            customerNumber= result["data"][0]['highestCustomerID'];
          });
          _AgreementdialogBuilder(context);

        }

      }
      else{
        setState(() {
          isLoading=false;
        });
        print('hello');
        showAlertDialogERROR(context,result["messageAr"], result["message"]);


        print("/*********************************");
        print(urls.BASE_URL + '/Customer360/search');
        print(result);


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



  SearchCrateria_API_SAVE()async{


    print('called');
    setState(() {
      isLoading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();


    print("/////////////////////////////////////////////////////////////");
    print(prefs.getString('selectedSearchCriteria2save'));
    print(prefs.getInt('searchIDd'));
    print( prefs.getString('customerNumbernew'));
    print("/////////////////////////////////////////////////////////////");
    Map test = {
      "searchID": idddd,
      "searchValue": kkkkkk
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
    print("*****************************************Body************************************************");
    print(body);
    print(response.body);
    print(response);
    print("******************************************Response******************************************");



    print("/*********************************************************************************/");


    //print(json.decode(response.body));
    if(response.body.isNotEmpty) {
      json.decode(response.body);
    }else{
      print("0000000000000000000000000000000");
    }

    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');
      print('iam hetee');
      UnotherizedError();
    }

    if (statusCode == 200) {

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
          setState(() {
            isLoading =false;
            data=result["data"];
            msisdn=result["data"][0]['msisdn'];
            customerNumber= result["data"][0]['highestCustomerID'];
          });


          Navigator.push(
            context,
            MaterialPageRoute(

              builder: (context) => Screen360view(PermessionCorporate,role,prefs.getInt('searchIDd'),prefs.getString('searchValuenew'),prefs.getString('customerNumbernew'),msisdn,result["data"],prefs.getString('selectedSearchCriteria2save')),
            ),
          );
        }

      }
      else{
        setState(() {
          isLoading=false;
        });
        print('hello');
        showAlertDialogERROR(context,result["messageAr"], result["message"]);


        print("/*********************************");
        print(urls.BASE_URL + '/Customer360/search');
        print(result);


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
        print("/*********************************");
        print(result);
        print(result["messageAr"]);
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



  Widget buildSearchCriteria() {
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
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color:serchByEmptyFlag == true
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
                  icon: Icon(Icons.keyboard_arrow_down_rounded),
                  iconSize: 30,
                  iconEnabledColor: Colors.grey,
                  underline: SizedBox(),
                  isExpanded: true,
                  style: TextStyle(
                    color: Color(0xff11120e),
                    fontSize: 14,
                  ),
                  items: SearchCriteria.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? valueItem.key+valueItem.value
                          : valueItem.key+valueItem.valueAr,
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem.value)
                          : Text(valueItem.valueAr),
                    );
                  }).toList(),
                  value: selectedSearchCriteria,
                  onChanged: (String newValue) {
                    setState(() {
                      showGo360Viwe=false;
                      selectedSearchCriteria = newValue;
                      selectedSearchCriteria1= selectedSearchCriteria.replaceAll(RegExp('[^0-9]'), '');
                      selectedSearchCriteria2= selectedSearchCriteria.replaceAll(RegExp('[^A-Za-z ]+(?:\s[a-zA-Z ]+)*'), '');
                      select=true;
                      valueOfCriteria.text='';
                      // voucheramountBloc .add(VoucherAmountFetchEvent(msisdn.text, selectedRechargeType));
                    });

                  },
                ),
              ),
            ))
      ],
    );
  }


  Widget buildCriteria() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: selectedSearchCriteria2,
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
              color: criteriaEmptyFlag
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: criteriaEmptyFlag || checkMobileNumber || checkCustomerNumber? Color(0xFFb10000) : Color(0xFFD1D7E0),
                width: criteriaEmptyFlag ? 1 : 1,
              )),
          height: 58,
          child: TextField(
            controller: valueOfCriteria,
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

  Widget buildSearchBtn() {

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

        ):Text("corporetUser.search".tr().toString()),

        onPressed: () async {

          if(selectedSearchCriteria ==null){
            setState(() {
              serchByEmptyFlag=true;
            });
          }
          if(selectedSearchCriteria !=null){
            setState(() {
              serchByEmptyFlag=false;
            });
          }
          if(valueOfCriteria.text==""){
            setState(() {
              criteriaEmptyFlag=true;
            });
          }
          if(valueOfCriteria.text!=""){
            setState(() {
              criteriaEmptyFlag=false;
            });

            if(selectedSearchCriteria2 == "Mobile Number"){
              print("Mobile Number");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });
                SearchCrateria_API();

              }
            /*  if(valueOfCriteria.text.length == 10 ){
                if( valueOfCriteria.text.substring(0, 3) == '079'){
                  setState(() {
                    checkMobileNumber = false;
                  });
                  if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                    if(isLoading) return;
                    setState(() {
                      isLoading =true;
                      searchID=int.parse(selectedSearchCriteria1);
                      searchValue=valueOfCriteria.text.toString();
                    });
                    SearchCrateria_API();

                  }
                } else  if( valueOfCriteria.text.substring(0, 3) != '079'){
                  setState(() {
                    checkMobileNumber = true;
                  });
                }
              }else{
                setState(() {
                  checkMobileNumber = true;
                });
              }*/
            }
            if(selectedSearchCriteria2 == "Customer Number"){
              print("Customer Number");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
                /*searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "FTTH Username"){
              print("FTTH Username");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });
                SearchCrateria_API();

               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "National Number"){
              print("National Number");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "SIM Number"){
              print("SIM Number");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "IMSI Number"){
              print("SIM Number");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }  if(selectedSearchCriteria2 == "Customer Name"){
              print("Customer Name");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "Contract Number"){
              print("Contract Number");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
                /*searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "FTTH Serial Number"){
              print("FTTH Serial Number");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "ETTH Username"){
              print("ETTH Username");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "ADSL Username"){
              print("ADSL Username");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
                /*searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "Refrence Number"){
              print("Refrence Number");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "Case Reference"){
              print("Case Reference");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
               /* searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
            if(selectedSearchCriteria2 == "DID"){
              print("DID");
              print(valueOfCriteria.text);
              if(valueOfCriteria.text!="" && selectedSearchCriteria !=null){
                if(isLoading) return;
                setState(() {
                  checkCustomerNumber=false;
                  isLoading =true;
                  searchID=int.parse(selectedSearchCriteria1);
                  searchValue=valueOfCriteria.text.toString();
                });

                SearchCrateria_API();
                /*searchCriteriaBloc.add(SubmitButtonSearchPressed(
                    searchID: int.parse(selectedSearchCriteria1) ,
                    searchValue: valueOfCriteria.text.toString()
                ),);*/
              }else{
                setState(() {
                  checkCustomerNumber = true;
                });
              }
            }
           else if(selectedSearchCriteria2 != "Mobile Number" &&
                selectedSearchCriteria2!="Customer Number" &&
                selectedSearchCriteria2!="FTTH Username"&&
                selectedSearchCriteria2!="National Number"&&
                selectedSearchCriteria2!="SIM Number"&&
                selectedSearchCriteria2!="IMSI Number"&&
                selectedSearchCriteria2!="Customer Name"&&
                selectedSearchCriteria2!="Contract Number"&&
                selectedSearchCriteria2!="FTTH Serial Number"&&
                selectedSearchCriteria2!="ETTH Username"&&
                selectedSearchCriteria2!="ADSL Username"&&
                selectedSearchCriteria2!="Refrence Number"&&
                selectedSearchCriteria2!="DID" &&
            selectedSearchCriteria2 !="Case Reference"){
              print("valueOfCriteria.text");
              print(valueOfCriteria.text);
               showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "This service not available now "
                   : "هذه الخدمة غير متوفرة الآن",
                   context: context,
                   animation: StyledToastAnimation.scale,
                  fullWidth: true);
            }
          }


        },
      )

    );
  }

  Widget buildGO360ViewBtn() {

    return Container(
        margin: EdgeInsets.only(
            top: 18, bottom: 0, left: 25, right: 25),
        padding: EdgeInsets.symmetric(vertical: 5.0),

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
          child: Text("360Views.GO360Views".tr().toString()),
          onPressed: () async {
            SearchCrateria_API_SAVE();
          },
        )

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
            exit(0);
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

  showAlertDialogError(BuildContext context,arabicMessage,englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text("alert.tryAgain".tr().toString() ,
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
          color: Color(0xFF392156),
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

  /*_____________________________________**************************______________________________________*/
  /*______________________________________**For Agreement Dialog**_______________________________________*/
  /*_____________________________________**************************______________________________________*/
  Future<void> _AgreementdialogBuilder(BuildContext context) {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,

      builder: (BuildContext context) {

        return AlertDialog(
          content:
          EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ?
          Text(
              'You declare that You are (a) at-least 18 years old. (b) That You are of age to sign a contract. (c) That You are not a person restricted from contracting. (d) That You are the owner of the account, or that You are licenced to use it.\n'
                  '\n'
                  'You are required to uphold and use Your account on the website to purchase the products available on ZainJo’s website in a compliance with these terms and conditions and all regulations and rules within them.\n'
                  '\n'
                  'You vow and promise to the website according to the effective terms and conditions.\n')
              : Text('أنت تتعهد وتتعهد للموقع وفقًا للشروط والأحكام السارية.'+'\n'+'أنت مطالب بدعم واستخدام حسابك على موقع الويب لشراء المنتجات المتاحة على موقع ZainJo على الويب بما يتوافق مع هذه الشروط والأحكام وجميع اللوائح والقواعد بداخلها.'"\n"+'تقر بأن عمرك (أ) لا يقل عن 18 عامًا.(ب) أنك بلغت سن التوقيع على العقد.(ج) أنك لست شخصًا ممنوعًا من التعاقد. (د) أنك مالك الحساب ، أو أنك مرخص لك باستخدامه.'),

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
                          width: 120,
                          height: 40,
                          margin: EdgeInsets.only(left: 5, right: 15,bottom: 20),
                          child: ElevatedButton(
                            onPressed: () async{
                                if(customerNumber==null){
                                  print("<<<<<<<<<<<<<<<<<<<<<<<>>>>>>>>>>>>>>>>>>>>>>>");

                                  Navigator.pop(context);
                                  showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                                      ? "You can't complete request with null customer Number"
                                      : "لا يمكنك إكمال الطلب برقم عميل فارغ",
                                      context: context,
                                      animation: StyledToastAnimation.scale,
                                      fullWidth: true);
                                } else if(customerNumber!=null){
                                  print("<<<<<<<<<<<<<<<<<<<<<<<");

                                  SharedPreferences prefs = await SharedPreferences.getInstance();
                                  prefs.setString('selectedSearchCriteria2save',selectedSearchCriteria2);
                                  prefs.setInt('searchIDd', searchID);
                                  prefs.setString('searchValuenew', searchValue);
                                  prefs.setString('customerNumbernew', customerNumber);
                                  prefs.setString('msisdnmsisdn', msisdn);
                                  prefs.setString('SellectCheckSave','yes');


                                  Navigator.pop(context);
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Screen360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,selectedSearchCriteria2),
                                    ),
                                  );
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
                            child: Text("corpAlert.Accept".tr().toString()),
                          ))
                      // button 2
                    ])),
          ],
        );
      },
    );
  }
  /*_____________________________________**************************______________________________________*/
  /*______________________________________**End Agreement Dialog**______________________________________*/
  /*_____________________________________**************************______________________________________*/



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
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            backgroundColor: Color(0xFFEBECF1),
            appBar:AppBar(

              title: Text("DashBoard_Form.home".tr().toString()),
              //<Widget>[]
              backgroundColor: Color(0xFF392156),
                actions: <Widget>[
                  /*********************************************************************New 27-2-2025********************************************************************/
                  /*****************************************************************New Account Documents Checking screen******************************************************************/
                  PermessionCorporate.contains('05.20')? IconButton(
                      icon: Icon(Icons.upload_file),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => NewAccountDocumnetChecking(PermessionCorporate,role)
                          ),
                        )
                      }):Container(),

                ]
            ),


            body: role == "Corporate"
                ? SellectCheck==true && showGo360Viwe==true?   Column(
                  children: [
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
                                    "SubscriberView.CustomerNumber".tr().toString(),
                                  ),
                                  SizedBox(height: 1),
                                  Text(_customerID.toString(),
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
                    ),
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
                              Text(_customerName.toString(),
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
            ),
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
                                    "SubscriberView.SubscriberName".tr().toString(),
                                  ),
                                  SizedBox(height: 1),
                                  Text(_subscriberName,
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
                    ),
                    SizedBox(
                      height: 15,
                    ),

                  /*  SellectCheck==true && showGo360Viwe==true?  buildGO360ViewBtn():Container(),
                    TextButton.icon(
                      onPressed: () {setState(() {
                        showGo360Viwe=false;
                      }); },
                      label: Text("360Views.NewSearch".tr().toString()
                        , style: TextStyle(
                          color: Color(0xFF0E7074),
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                        ),),
                      icon: Icon(
                        Icons.search,
                        size: 24.0,
                        color: Color(0xFF0E7074),
                      ),

                    )*/
                  ],
                ): Center(
              child: ListView(
                shrinkWrap: true,
                padding: EdgeInsets.only(
                    top: 0, bottom: 20, left: 32, right: 32),
                children: <Widget>[
                  Center(
                    child: Image(
                        image: AssetImage('assets/images/SearchIcon.png'),
                        width: 184,
                        height: 184),
                  ),
                  SizedBox(height: 40),
                  buildSearchCriteria(),
                  serchByEmptyFlag == true
                      ? RequiredFeild(
                      text: "corporetUser.Required"
                          .tr()
                          .toString())
                      : Container(),
                  SizedBox(height: 25),
                  select==true?
                  buildCriteria():Container(),
                  criteriaEmptyFlag== true ? RequiredFeild(
                      text: "corporetUser.Required"
                          .tr()
                          .toString())
                      : Container(),

                  checkMobileNumber == true
                      ? RequiredFeild(
                      text: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? "Mobile Number shoud be 10 digits & start with 079"
                          : "رقم الهاتف يجب أن يتكون من 10 أرقام ويبدأ ب 079"): Container(),

                  checkCustomerNumber == true? RequiredFeild(
                      text: "corporetUser.Required"
                          .tr()
                          .toString())
                      : Container(),
                  SizedBox(height: 30),
                  msg,
                  select==true ?
                  buildSearchBtn():Container(),



                ],
              ),
            )
                : Center(
              child: Text(role),
            ),


             floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
            floatingActionButton: Container(
                padding: EdgeInsets.only(
                    left: 8, right: 8),
// padding: EdgeInsets.only(bottom: 0),
                child: SingleChildScrollView(
                  child:Column(
                    children: [


                      SizedBox(height: 8,),
                      SellectCheck==true && showGo360Viwe==true?  buildGO360ViewBtn():Container(),
                      SellectCheck==true && showGo360Viwe==true?   TextButton.icon(
                      onPressed: () {setState(() {
                        showGo360Viwe=false;
                      }); },
                      label: Text("360Views.NewSearch".tr().toString()
                        , style: TextStyle(
                          color: Color(0xFF0E7074),
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0,
                        ),),
                      icon: Icon(
                        Icons.search,
                        size: 24.0,
                        color: Color(0xFF0E7074),
                      ),

                    ):Container()
                    ],
                  ),
                )
            ),


          ),
        ));
  }
}
