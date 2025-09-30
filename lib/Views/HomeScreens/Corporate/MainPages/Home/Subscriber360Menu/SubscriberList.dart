import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/AdjustmentLogs.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillShock.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillingDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/BlineLedger.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/OnlineChargingvalues.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/PresetRisk.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Promotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Unbilled.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Balance.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

import 'package:shared_preferences/shared_preferences.dart';


import '../360View.dart';
import '../KurmalekView/Kurmalek.dart';
import '../MainPromotions/MainPromotions.dart';
import '../SubscriberServices/subscriberservices.dart';
import 'VPNDetails.dart';


class SubscriberList extends StatefulWidget {
  List<dynamic> PermessionCorporate;

  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;

  List data=[];

  SubscriberList(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _SubscriberListState createState() =>
      _SubscriberListState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}
class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}
APP_URLS urls = new APP_URLS();


class Item {
  const Item(this.key,this.code,this.value, this.valueAr);
  final key;
  final code;
  final String value;
  final String valueAr;

}


class _SubscriberListState extends State<SubscriberList> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  DateTime backButtonPressedTime;
  ScrollController scrollController = ScrollController();
  int page =1;
  //String PermessionCorporate;
  final List<dynamic> PermessionCorporate;
  String role;
  String customerNumber;
  String msisdn;
  int searchID;
  String searchValue;
  String searchCraretia;
  List data=[];
  bool isLoading1 = false;
  bool isInitLoading = true;
  bool isLoading = false;
  bool allLoaded =false;
  bool isLazyLoading=true;
  bool filterByEmptyFlag =false;
  String selectedFiltervalue ='1';
  String selectedPackageValue;
  String selectedPStatusValue;
  ///////////////////////variable from API//////////////////////////////////////
  bool checkData=false;
  String shortCode;
  String status;
  String networkId;
  String level;

  String customerId="3003757";
  var SUBSCRIBER_PAKAGES=[];
  var STATUS=[];
  var FilterData=[];
  var SUBSCRIBER_LIST=[];
  var DataSubscriberList=[];


  bool msisdnEmptyFlag=false;
  bool msisdnErrorFlag=false;
  bool isPackagingLoading=false;
  bool isStatusLoading=false;
  var totalRecords;
  var totalPages=0;

  bool emptymsisdn=false;
  bool errormsisdn=false;
  bool emptyStatus=false;
  bool emptyPackage=false;

  String customerName='';
  String subscriberNumber='';
  String SavedSearchValue='';



  ///////////////////////End variable from API/////////////////////////////////

  TextEditingController MSISDN = TextEditingController();

  _SubscriberListState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);

  //*******************   List Item for First Menu    ****************/
  List litemsFirst = [
    ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Subscriber_360_View".tr().toString()),
    ListContentFirst(name:"corpMenu.Promotions".tr().toString()),
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

    setupScrollController(context);
    print("UnotherizedError");
    print(FilterData.length);
    print("role role role role role");
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{
      // getPackagesListUnderCustomer_API ();
    }
    getFilterOption_API();
    getSubscriberInfo_API();
    DataSubscriberList=this.data;
    //disableCapture();
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    super.initState();
  }


  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !isLoading) {
          page++;
          //BlocProvider.of<GetPendingLineDocQueueBloc>(context);
          print("page Number");
          print('called here');

          getSubscriberList_API();
        }
      }
    });
  }


  @override
  void dispose(){
    scrollController.dispose();
   // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    super.dispose();
  }

  getSubscriberInfo_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();


    setState(() {
      isLoading1=true;
    });

    Map body = {
      "customerId": customerNumber,
      "searchId": 5,
      "searchValue":null,
      "withPendingContractsFlag": "0",
      "pageIndex": 0,
      "pageSize": 0
    };


    var apiArea = urls.BASE_URL + '/Customer360/getSubscribersListByCustomerNo';
    final Uri url = Uri.parse(apiArea);

    print(url);
    print(json.encode(body));
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
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
     // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
    }
    if (statusCode == 200) {



      var result = json.decode(response.body);


      if( result["status"]==0){
        setState(() {
          isLoading1=false;
        });

        setState(() {

          //customerName=result["data"]["subscribersList"].length!=0?result["data"]["subscribersList"][0]['subscriberName']:'-';
          subscriberNumber=result["data"]["subscribersList"].length!=0?result["data"]["subscribersList"][0]['msisdn']:'-';

        });

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoading1=false;
        });

      }


      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);
      setState(() {
        isLoading1=false;
      });

    }
  }
  getFilterOption_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();



    var apiArea = urls.BASE_URL + '/Lookup/GETFILTER';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;

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

            FilterData=result["data"];
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

  getPackagesListUnderCustomer_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map body = {
      "customerId": customerNumber,
    };
    setState(() {
      isPackagingLoading=true;
    });

    var apiArea = urls.BASE_URL + '/Customer360/getPackagesListUnderCustomer';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);
    int statusCode = response.statusCode;

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
     // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
      setState(() {
        isPackagingLoading=false;
      });
    }
    if (statusCode == 200) {
      print("yes");
      setState(() {
        isPackagingLoading=false;
      });

      Navigator.pop(context);
      _showFilterDialog();

      var result = json.decode(response.body);
      print(result);
      print(result["data"]);


      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

        }else{
          setState(() {

            SUBSCRIBER_PAKAGES=result["data"];
          });

          print("SUBSCRIBER_PAKAGES.length");
          print(SUBSCRIBER_PAKAGES.length);
        }

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);

      }

      return result;
    }else{
      showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
  }

  getStausListUnderCustomer_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      isPackagingLoading=true;
    });

    var apiArea = urls.BASE_URL + '/Lookup/CONTRACTSTATUS';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
     // showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
      setState(() {
        isStatusLoading=false;
      });
    }
    if (statusCode == 200) {
      print("yes");
      setState(() {
        isStatusLoading=false;
      });

      Navigator.pop(context);
      _showFilterDialog();

      var result = json.decode(response.body);
      print(result);
      print(result["data"]);


      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
          showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");


        }else{
          setState(() {

            STATUS=result["data"];
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


  getSubscriberList_API ( )async {
    print('inside 1');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    print(selectedFiltervalue);
    if (selectedFiltervalue == null) {
      setState(() {
        filterByEmptyFlag=true;
      });
      Navigator.pop(context);
      _showFilterDialog();
    }
    else {
      setState(() {
        filterByEmptyFlag=false;
      });

      if (selectedFiltervalue == "1") {
        searchValue = null;
        rquestGetSubscriberList_API(page, searchValue);
        setState(() {
          isLoading = true;
          SavedSearchValue=null;
        });
        Navigator.pop(context);
      }

      if (selectedFiltervalue == "2") {
        searchValue = MSISDN.text;
        setState(() {
          SavedSearchValue=MSISDN.text;
          page=1;
        });
        if (MSISDN.text == "") {
          setState(() {
            emptymsisdn = true;
          });
          Navigator.pop(context);
          _showFilterDialog();
        } else if (MSISDN.text != "") {
          if (MSISDN.text.length == 10) {
            if (MSISDN.text.substring(0, 3) == '079') {
              setState(() {
                errormsisdn = false;
                emptymsisdn = false;
              });
              rquestGetSubscriberList_API(1, searchValue);
              setState(() {
                isLoading = true;
              });
              Navigator.pop(context);
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
      }

      if (selectedFiltervalue == "3") {
        searchValue = selectedPStatusValue;
        setState(() {
          SavedSearchValue=selectedPStatusValue;
        });
        if (selectedPStatusValue == null) {
          setState(() {
            emptyStatus = true;
          });
          Navigator.pop(context);
          _showFilterDialog();
        }
        else {
          setState(() {
            emptyStatus = false;
          });
          rquestGetSubscriberList_API(page, searchValue);
          setState(() {
            isLoading = true;
          });
          Navigator.pop(context);
        }
      }

      if (selectedFiltervalue == "4") {
        setState(() {
          SavedSearchValue=selectedPackageValue;
        });
        searchValue = selectedPackageValue;
        if (selectedPackageValue == null) {
          setState(() {
            emptyPackage = true;
          });
          Navigator.pop(context);
          _showFilterDialog();
        }
        else {
          setState(() {
            emptyPackage = false;
          });
          rquestGetSubscriberList_API(page, searchValue);
          setState(() {
            isLoading = true;
          });
          Navigator.pop(context);
        }
      }
    }


  }
  rquestGetSubscriberList_API( int page, String searchValue) async{
    print('inside 2');

    print('iam here 2');
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map body = {
      "customerId": customerNumber,
      "searchId": selectedFiltervalue,
      "searchValue":searchValue,
      "withPendingContractsFlag": "1",
      "pageIndex": page,
      "pageSize": 20
    };


    var apiArea = urls.BASE_URL + '/Customer360/getSubscribersListByCustomerNo';
    final Uri url = Uri.parse(apiArea);

    print(url);
    print(json.encode(body));
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);
    print(prefs.getString("accessToken"));
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
      setState(() {
        isLoading =false;
      });
    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if( result["status"]==0){

        print(result["data"]['totalRecords']);
        List<dynamic> list =  result['data']['subscribersList'];
        if(list.isNotEmpty){
          list.map((data) => SUBSCRIBER_LIST.add(data)).toList();
          for(var i=0;i<SUBSCRIBER_LIST.length;i++){
            print(SUBSCRIBER_LIST[i]);
          }

        }
        setState(() {

          isLazyLoading=false;


        });
        await Future.delayed(Duration(milliseconds:500 ));
        setState(() {
          isLoading=false;
          allLoaded = list.isEmpty;
          totalRecords=result["data"]['totalRecords'];
          checkData=true;
          totalPages=result["data"]['totalPages'];
          //
          // UserList =UserList;
        });
        setState(() {
          isInitLoading=false;
        });

      }else{
        showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoading =false;
        });

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



  Widget buildFilterTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberList.filter_by".tr().toString(),
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
                color:filterByEmptyFlag == true
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
                  items: FilterData.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:  valueItem["code"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["value"])
                          : Text(valueItem["valueAr"]),
                    );
                  }).toList(),
                  value: selectedFiltervalue,
                  onChanged: (String newValue) {
                    setState(() {
                      selectedFiltervalue = newValue;

                    });

                    if(selectedFiltervalue=="4"){
                      getPackagesListUnderCustomer_API();
                      setState(() {

                        selectedPStatusValue=null;
                      });
                    }
                    if(selectedFiltervalue=="3"){
                      getStausListUnderCustomer_API();
                      setState(() {

                        selectedPackageValue=null;
                      });
                    }
                    print(selectedFiltervalue);
                    Navigator.pop(context);
                    _showFilterDialog();
                    setState(() {
                      SUBSCRIBER_LIST=[];
                      page=1;
                    });
                  },
                ),
              ),
            )),
        filterByEmptyFlag==true? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildStatusTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberList.status".tr().toString(),
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
                color:emptyStatus == true
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
                  items: STATUS.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:  valueItem["code"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["value"])
                          : Text(valueItem["valueAr"]),
                    );
                  }).toList(),
                  value: selectedPStatusValue,
                  onChanged: isStatusLoading==true?null: (String newValue) {
                    setState(() {
                      selectedPStatusValue = newValue;

                    });

                    print(selectedPStatusValue);
                    Navigator.pop(context);
                    _showFilterDialog();
                    setState(() {
                      SUBSCRIBER_LIST=[];
                      page=1;
                    });
                  },
                ),
              ),
            )),
        emptyStatus == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),

      ],
    );
  }

  Widget buildPackagesTypes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberList.package".tr().toString(),
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
              color:  Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color:emptyPackage == true
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
                  items: SUBSCRIBER_PAKAGES.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value:  valueItem["packageBillCode"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["englishPackageDesc"])
                          : Text(valueItem["arabicPackageDesc"]),
                    );
                  }).toList(),
                  value: selectedPackageValue,
                  onChanged: isPackagingLoading==true?null: (String newValue) {
                    setState(() {
                      selectedPackageValue = newValue;

                    });

                    print(selectedPackageValue);
                    Navigator.pop(context);
                    _showFilterDialog();
                    setState(() {
                      SUBSCRIBER_LIST=[];
                      page=1;
                    });
                  },
                ),
              ),
            )),
        emptyPackage == true
            ? RequiredFeild(
            text: "Menu_Form.msisdn_required".tr().toString())
            : Container(),
      ],
    );
  }

  Widget buildMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "SubscriberList.msisdn".tr().toString(),
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
          height: 58,
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

//////////////////////////// This Function Contains Two menus ////////////////////////////
  Future<void> _showMoreOptionDialog() async {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Scaffold(
          backgroundColor: Colors.transparent,
          body: Center(
            child: Container(

              padding: EdgeInsets.only(top: 12,bottom: 12,left: 8,right: 8),
              // color: Color(0xFFF3F4F7),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Color(0xFFF3F4F7),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                      child:Container(
                        padding: EdgeInsets.only(top:5,bottom: 5,left: 0,right: 0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10),
                          ),
                        ),
                        child: ListView.builder(
                          padding: EdgeInsets.only(top:8,bottom: 8,left: 0,right: 0),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: litemsFirst.length,
                          itemBuilder: (BuildContext context, int index) {
                            //   itemCount :  UserList.length,
                            return  Container(
                                color: Colors.white,
                                child: Column(
                                    children:[
                                      SizedBox(
                                        child:
                                        litemsFirst[index].name=="-"?
                                        Container(
                                          color: Color(0xFFF3F4F7),
                                          height: 10,):
                                        ListTile(
                                          dense: true,
                                          title: Text(
                                            litemsFirst[index].name,
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF2F2F2F),
                                                fontWeight: FontWeight.normal),
                                          ),
                                          trailing: IconButton(
                                            icon: EasyLocalization.of(context).locale ==
                                                Locale("en", "US")
                                                ? Icon(Icons.keyboard_arrow_right)
                                                : Icon(Icons.keyboard_arrow_left),
                                          ),
                                          onTap: () {
                                            Navigator.pop(context);


                                            if(litemsFirst[index].name=="corpMenu.Subscriber_360_View".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Subscriber360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),

                                              );


                                            }

                                            if(litemsFirst[index].name=="corpMenu.Customer_360_View".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Customer360view(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );


                                            }
                                            if(litemsFirst[index].name=="corpMenu.Kurmalek".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Kurmalek(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );


                                            }
                                            if(litemsFirst[index].name=="corpMenu.Promotions".tr().toString()){

                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => MainPromotions(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );


                                            }
                                            if(litemsFirst[index].name=="corpMenu.Balance".tr().toString()){



                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => Balance(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );

                                            }

                                            if(litemsFirst[index].name=="corpMenu.Subscriber_Services".tr().toString()){



                                              Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (context) => SubscriberServices(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                                ),
                                              );

                                            }

                                          },

                                        ),


                                      )
                                      /* index!= UserList.length-1 ?
                                  Divider(
                                    thickness: 1,
                                    color: Color(0xFFedeff3),
                                  ):Container(),*/
                                    ]
                                )
                            );


                          },
                        ),
                      ) ),

                  SizedBox(height: 10,),
                  SizedBox(
                    width: 40,
                    height: 40,
                    child: FittedBox(
                      child: FloatingActionButton(
                        backgroundColor: Color(0xFF0E7074),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.close,
                          size: 35,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),

                ],

              ),
            ),

          ),

        );



      },
    );
  }
///////////////////////////////////// End Two menus /////////////////////////////////////

  //////  Show filter Dialog ///////////
  Future<void> _showFilterDialog() async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,

      builder: (BuildContext context) {

        return AlertDialog(
          content:
          Container(
            padding: EdgeInsets.only(bottom: 0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildFilterTypes(),
                SizedBox(height: 10,),
                selectedFiltervalue!='1'?SizedBox(height: 5,):SizedBox(height: 0,),
                selectedFiltervalue=='2' ? buildMSISDN():
                selectedFiltervalue=='3' ?buildStatusTypes():
                selectedFiltervalue=='4'? buildPackagesTypes():
                Container()

              ],
            ),
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
                              selectedFiltervalue=null;
                              selectedPStatusValue=null;
                              selectedPackageValue=null;
                              MSISDN.text='';
                              emptymsisdn=false;
                              errormsisdn=false;
                              emptyPackage=false;
                              emptyStatus=false;
                              isLoading=false;
                              filterByEmptyFlag=false;
                            });
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
                            onPressed: () {
                              //Navigator.pop(context);
                              getSubscriberList_API();

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
                            child: Text("SubscriberList.filter".tr().toString()),
                          ))
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Screen360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
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
              title: Text("SubscriberList.Subscriber_List".tr().toString()),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () async{
                  SharedPreferences prefs = await SharedPreferences.getInstance();

                  // Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Screen360view(PermessionCorporate,role,searchID,searchValue,customerNumber,msisdn,this.data,this.searchCraretia),
                    ),
                  );


                },
              ), //<Widget>[]

              actions: <Widget>[
                IconButton(
                  icon:  Icon(Icons.filter_list,color: Colors.white,),
                  onPressed: (  _showFilterDialog) ,
                ),

                IconButton(
                  icon:  Icon(Icons.more_vert,color: Colors.white,),
                  onPressed: ( _showMoreOptionDialog) ,
                ), //IconButton//IconButton
              ],
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
                ? LazyLoadScrollView(
                  onEndOfPage: () =>
                  {

                    print('page Number ${page}' ),
                    if(page < totalPages)
                    {
                      page++ ,
                      rquestGetSubscriberList_API(page, SavedSearchValue),
                      setState(() {

                        isLazyLoading=true;


                      })
                    }else{
                      print('stop +++++++++++ stop')
                    }
                  },
                  child: ListView
                  (
                  children: [
                    ///////////////////////////////////First Content//////////////////////////////////////////////////////////
                    isLoading1==false?    Container(
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
                                  Text(
                                    this.data[0]['customerName']==null?"-": this.data[0]['customerName'].length==0?'-':this.data[0]['customerName'],
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

                    isLoading1==false?Container(
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
                                  Text(
                                    subscriberNumber,
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
                    ):Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 26, right: 26,top: 30),
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

                        )),

                    ///////////////////////////////////End First Content//////////////////////////////////////////////////////////

                    isLoading==true?
                    Container():
                    checkData==true?
                    Container(
                        padding: EdgeInsets.only(left:24,right:24,top:10,bottom: 10),
                        child:
                        Row(
                          children: [
                            Text("SubscriberList.total_records".tr().toString()),
                            Text( " " + totalRecords.toString(),style:
                            TextStyle(fontWeight: FontWeight.bold)
                              ,)
                          ],)



                    ):Container(),
                    ///////////////////////////////////Second Content//////////////////////////////////////////////////////////
                    isLoading==true ?
                    Container(
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 26, right: 26,top: 30),
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

                        )):
                    checkData==true?Container(
                      padding: allLoaded ? EdgeInsets.only(bottom: 16) : EdgeInsets.only(bottom: 0),
                      child:  Stack(
                        children: [ListView.builder(
                          padding: EdgeInsets.only(
                              top: 8, bottom: 8, left: 0, right: 0),
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,

                          physics: ClampingScrollPhysics(),
                          itemCount: SUBSCRIBER_LIST.length,
                          itemBuilder:(context,index){
                            //   itemCount :  UserList.length,
                            return Container(
                                color: Colors.white,
                                padding: EdgeInsets.only(left: 8,right: 8),
                                child: Column(
                                    children: [
                                      SizedBox(
                                        child:
                                        ListTile(
                                          dense: true,
                                          title: Text(
                                            SUBSCRIBER_LIST[index]['msisdn']!=null?SUBSCRIBER_LIST[index]['msisdn']:'-',
                                            style: TextStyle(
                                                fontSize: 14,
                                                color: Color(0xFF2F2F2F),
                                                fontWeight: FontWeight
                                                    .normal),
                                          ),
                                          trailing:   Text(
                                            SUBSCRIBER_LIST[index]['contractStatus']!=null?SUBSCRIBER_LIST[index]['contractStatus']:"-",
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Color(0xff22AD51),
                                              fontSize: 14.0,
                                            ),
                                          ),



                                        ),



                                      ),
                                      index!= SUBSCRIBER_LIST.length-1 ?
                                      Divider(
                                        thickness: 1,
                                        color: Color(0xFFedeff3),
                                      ):Container(),
                                    ]
                                )
                            );
                          },
                        ),
                          if(isLazyLoading)...[
                            Positioned(
                              left: 0,
                              right: 0,
                              bottom: 0,
                              child:Container(
                                padding: EdgeInsets.only(bottom: 15),
                                child: Row(
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

                                ),
                              ),
                            )
                          ]
                        ],
                      ),
                    ):
                    Container()
                    ,
                    ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
                  ],
                )
                )
                : Center(
              child: Text(role),
            ),

          ),
        ));
  }
}