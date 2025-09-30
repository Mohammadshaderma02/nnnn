import 'package:easy_localization/easy_localization.dart';
import 'package:expansion_tile_card/expansion_tile_card.dart';
import 'package:flutter/material.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/RequiredField.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/FTTH/Nationality/NationalityList.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/GSM/Nationality/GSM_JordainianCustomerInformation.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/GSM/Nationality/GSM_NonJordainianCustomerInformation.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/MBB/Nationality/BroadBand_SelectNationality.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PrePaid/JordanianInformation.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PrePaid/nonJordanianInformation.dart';
import 'dart:convert';
import 'dart:io';

import 'package:sales_app/Views/HomeScreens/DeliveryEShop/Settings/Settings_Screen.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/Login/logout_bloc.dart';
import 'package:sales_app/blocs/Login/logout_events.dart';
import 'package:sales_app/blocs/Login/logout_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/services.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import 'PostPaid/GSM/Contract/Recontracting.dart';

class OrdersScreen extends StatefulWidget {
  //const OrdersScreen({Key? key}) : super(key: key);

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

APP_URLS urls = new APP_URLS();

class _OrdersScreenState extends State<OrdersScreen> {
  final GlobalKey<ExpansionTileCardState> cardA = new GlobalKey();

  bool orderListEmpty = false;
  bool _isExpanded = false;
  LogoutBloc logoutBloc;
  List orderList = [];
  var PermessionDeliveryEShop = [];
  var role = '';
  String packageName ;
  var packageCode = '';
  var orderID ;
  var marketType = '';
  var status;
  var customerName;
  var PaymentMethodSystemName;
  bool isParentEligible=false;


  var orderList_MBB_FTTH_GSM;

  bool checkGetListPrepaid =false;
  bool orderListEmptyPrepaid = false;
  List orderListPrepaid =[];

  var birthdate="";
  bool Order_Prepaid=true;
  bool Order_PostPaid=false;

  List selectMarketType=[{"type":"FTTH"},{"type":"MBB"},{"type":"GSM"},];
  var defultSelectedType;



  bool checkGetListMBBFTTH = false;
  bool orderListEmptyMBBFTTH =false;
  bool checkUnauthorized=false;
  bool Order_MBBFTTH=true;
  List orderListMBBFTTH = [];

  List orderListMBB = [];
  bool checkGetListMBB = false;
  bool orderListEmptyMBB =false;

  List orderListFTTH = [];
  bool checkGetListFTTH = false;
  bool orderListEmptyFTTH =false;


  bool checkGetListGSM = false;
  bool orderListEmptyGSM =false;
  bool Order_GSM = false;
  List orderListGSM = [];

  var driverName;
  var paymentMethodName;
  var selectedNimber;
  var referanceNumber;
  var passportNumber;
  var nationalNumber;
  var commitment;
  var email;
  var orderTotal;
  bool isEsim;
  var Esim;
  bool add_note = false;
  bool getReasons = false;
  List getReasonList=[];
  var reasonDefultSelected;
  List dropdownValues = []; // Define the list here
  int itemCount;

  bool emptyReasonList = false;


  Map<int, String> selectedValuesNote = {};
  Map<int, bool> switchValues = {};
  bool checkSubmitOrderNote= false;
  var getOrderId;
  TextEditingController notes = TextEditingController();
  bool maximumcharacter=false;
  List<TextEditingController> _controllers = [];
  List<bool> _maximumCharacterFlags = [];
  List<String> _items = List.generate(10, (index) => 'Item $index');

  @override
  void initState() {
    GetReasons_API();
    getSharedPrefernece();
    driverPrepaidOrdersList();
    print("defultSelectedTypedefultSelectedTypedefultSelectedType");
    print(defultSelectedType);
    removd();
    logoutBloc = BlocProvider.of<LogoutBloc>(context);
    _controllers = List.generate(_items.length, (index) => TextEditingController());
    _maximumCharacterFlags = List.generate(_items.length, (index) => false);
    super.initState();
  }

  void getSharedPrefernece() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    PermessionDeliveryEShop =
        prefs.getStringList('PermessionDeliveryEShop') ?? [];
    role = prefs.get('role');
    print('PermessionDeliveryEShop${PermessionDeliveryEShop}');
  }

  void removd() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove("selectedSearchCriteria2save");
  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

/*............................................ To git all driver MBB/FTTH Order ............................................*/
  void driverMBBFTTHOrdersList() async {
    setState(() {
     // checkUnauthorized=true;
      checkGetListMBBFTTH=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL + '/Postpaid/Eshop/DriverOrders';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');



    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no orders available"
                    : "لا توجد طلبات متاحة")));
        setState(() {
          orderListEmptyMBBFTTH = true;
          checkUnauthorized=false;
          checkGetListMBBFTTH=false;
        });
      } else if (result["data"] != null || result["data"].length != 0) {
        setState(() {
          orderListMBBFTTH = result["data"];
          orderListEmptyMBBFTTH = false;
          checkUnauthorized=false;
          checkGetListMBBFTTH=false;
        });
      }
      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
        _Unauthorized(context);
        setState(() {
          checkUnauthorized=false;
        });
      }
      setState(() {
        status = statusCode.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
                  Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }

  void driverMBBOrdersList() async {
    setState(() {
      // checkUnauthorized=true;
      checkGetListMBB=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL + '/Postpaid/Eshop/DriverOrders';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');



    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no orders available"
                    : "لا توجد طلبات متاحة")));
        setState(() {
          orderListEmptyMBB= true;
          checkUnauthorized=false;
          checkGetListMBB=false;
        });
      } else if (result["data"] != null || result["data"].length != 0) {
        for(var i=0; i< result["data"].length;i++){
          if(result["data"]["market"]=='MBB'){
            setState(() {
              orderListMBB.add(result['data'][i]);
            });
          }

        }
        setState(() {
          orderListEmptyMBB = false;
          checkUnauthorized=false;
          checkGetListMBB=false;
        });
      }
      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
        _Unauthorized(context);
        setState(() {
          checkUnauthorized=false;
        });
      }
      setState(() {
        status = statusCode.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }

  void driverFTTHOrdersList() async {
    setState(() {
      // checkUnauthorized=true;
      checkGetListFTTH=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL + '/Postpaid/Eshop/DriverOrders';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');



    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no orders available"
                    : "لا توجد طلبات متاحة")));
        setState(() {
          orderListEmptyMBBFTTH = true;
          checkUnauthorized=false;
          checkGetListFTTH=false;
        });
      } else if (result["data"] != null || result["data"].length != 0) {

        for(var i=0; i< result["data"].length;i++){
          if(result["data"]["market"]=='FTTH'){
            setState(() {
              orderListFTTH.add(result['data'][i]);
            });
          }

        }
        setState(() {
          orderListEmptyFTTH = false;
          checkUnauthorized=false;
          checkGetListFTTH=false;
        });
      }
      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
        _Unauthorized(context);
        setState(() {
          checkUnauthorized=false;
        });
      }
      setState(() {
        status = statusCode.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }
/*..........................................................................................................................*/
/*............................................... To git all driver GSM Order ..............................................*/
  void driverGSMOrdersList() async {

    setState(() {
      // checkUnauthorized=true;
      checkGetListGSM=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL + '/Postpaid/Eshop/PostpaidDriverOrders';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');



    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no orders available"
                    : "لا توجد طلبات  متاحة")));
        setState(() {
          orderListEmptyGSM = true;
          checkUnauthorized=false;
          checkGetListGSM=false;
        });
      } else if (result["data"] != null || result["data"].length != 0) {
        setState(() {
          orderListGSM = result["data"];
          orderListEmptyGSM = false;
          checkUnauthorized=false;
          checkGetListGSM=false;
        });
        print("-------------------- orderList_MBB_FTTH_GSM=orderList_MBB_FTTH_GSM----------------------------");
        orderList_MBB_FTTH_GSM= orderListGSM+orderListMBBFTTH;
        print(orderList_MBB_FTTH_GSM.length);


      }
      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
        _Unauthorized(context);
        setState(() {
          checkUnauthorized=false;
        });
      }
      setState(() {
        status = statusCode.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Order List status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
    }
  }
/*........................................................................................................................*/
  void GetReasons_API() async {

    setState(() {
      getReasons = true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL + '/Postpaid/Eshop/GetReasons';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no orders available"
                    : "لا توجد طلبات  متاحة")));
        setState(() {
          getReasons=false;
        });
      } else if (result["data"] != null || result["data"].length != 0) {

        setState(() {
          itemCount=result["data"].length;
          getReasonList=result["data"];
          dropdownValues=result["data"];
          getReasons=false;
          reasonDefultSelected = result["data"][0]['reason'];


        });

      }
      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Data Found status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد معلومات متاحة الحالة")));
        _Unauthorized(context);
        setState(() {
          checkUnauthorized=false;
          getReasons=false;
        });
      }
      setState(() {
        status = statusCode.toString();
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? 'No Data Found status is ' + ' ' + statusCode.toString()
              : statusCode.toString() + " " + "لا توجد معلومات متاحة الحالة")));
    }
  }

  void  submitOrderNote(orderId,note) async{
    print(note);
    print(orderId);

    setState(() {
      checkUnauthorized=true;
      checkSubmitOrderNote=true;
    });
    var url = urls.BASE_URL+'/Postpaid/Eshop/SubmitOrderNote';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: jsonEncode({"orderId": orderId,"note":note}),);

    int statusCode = response.statusCode;
    print('body: [${response.body}]');
    if(response.body.isNotEmpty) {
      var result= json.decode(response.body);
      print(result['data']);
    } else{
      print("error body is Empty");
      print('body: [${response.body}]');
    }

    if(statusCode ==200) {
      setState(() {
        checkUnauthorized=false;
        checkSubmitOrderNote=false;
      });
      var result = json.decode(response.body);
      print(result['data']);
      if(result['status']==0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ?  result['message']
                :  result['messageAr'])));

      setState(() {
        defultSelectedType=null;
      });

      }else{
        setState(() {
          checkUnauthorized=false;
          checkSubmitOrderNote=false;
        });

      }
    }
    if(statusCode==401){
      _Unauthorized(context);
      setState(() {
        checkUnauthorized=false;
        checkSubmitOrderNote=false;
      });

    }if(statusCode ==200 && statusCode==401){
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ?  "Some thing wrong"
              :  "حدث خطأ ")));
      setState(() {
        checkUnauthorized=false;
        checkSubmitOrderNote=false;
      });
    }

  }
  /*............................................... Prepaid Flow On Eshop Layer ..............................................*/
  void driverPrepaidOrdersList() async {
    setState(() {
       checkUnauthorized=true;
      checkGetListPrepaid=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL + '/Prepaid/Eshop/PrepaidDriverOrders';
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var data = response.request;
   // print(statusCode);
   // print(data);
   // print(response);
   // print('body: [${response.body}]');



    if (statusCode == 200) {
      var result = json.decode(response.body);
     // print(result);
   //   print(result["data"]);
   //   print('-------------------------------');

      if (result["data"] == null || result["data"].length == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no orders available"
                    : "لا توجد طلبات متاحة")));
        setState(() {
          orderListEmptyPrepaid = true;
          checkUnauthorized=false;
          checkGetListPrepaid=false;

        });
      } else if (result["data"] != null || result["data"].length != 0) {
        setState(() {
          orderListPrepaid = result["data"];
          print("orderListPrepaid");
          print(result["data"]);







          orderListEmptyPrepaid = false;
          checkUnauthorized=false;
          checkGetListPrepaid=false;
        });
      }
      return result;
    } else {
      if (statusCode == 401) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
        _Unauthorized(context);
        setState(() {
          checkUnauthorized=false;
          checkGetListPrepaid=false;
        });
      }else{
        setState(() {
          status = statusCode.toString();
          checkGetListPrepaid=false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
      }

    }
  }
  /*.....................................................switch Prepaid-PostPaid Buttons  ....................................*/
  void _clickOrders_Prepaid() async{
    setState(() {
      Order_Prepaid=true;
      Order_PostPaid=false;
    //  checkGetListMBBFTTH=true;
    });
    driverPrepaidOrdersList();

  }

  void _clickOrders_PostPaid() async{
    setState(() {
      Order_Prepaid=false;
      Order_PostPaid=true;
    });
  }
/*........................................................................................................................*/

  Widget buildMarketType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 30,),//
        RichText(
          text: TextSpan(
            text:  EasyLocalization.of(context).locale == Locale("en", "US") ? "Market Type": "نوع السوق",
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.w500,

            ),
            children: <TextSpan>[
              TextSpan(
                text: ' * ',
                style: TextStyle(
                  color: Colors.transparent,
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
                color: emptyReasonList == true
                    ? Color(0xFFB10000)
                    : Color(0xFFD1D7E0),
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: ButtonTheme(
                alignedDropdown: true,
                child: DropdownButton<String>(
                  hint: Text(
                    EasyLocalization.of(context).locale == Locale("en", "US") ? "Select market": "اختر النوع",
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
                  items: selectMarketType.map((valueItem) {
                    return DropdownMenuItem<String>(
                      value: valueItem["type"],
                      child: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? Text(valueItem["type"])
                          : Text(valueItem["type"]),
                    );
                  }).toList(),
                  value: defultSelectedType,
                  onChanged: (String newValue) {
                    setState(() {
                      defultSelectedType = newValue;
                    });
                    if(defultSelectedType=="FTTH"){
                      driverFTTHOrdersList();
                    }
                    if(defultSelectedType=="MBB"){
                      driverMBBOrdersList();
                    }
                    if(defultSelectedType=="GSM"){
                      driverGSMOrdersList();
                    }
                  },
                ),
              ),
            )),
        SizedBox(height: 20,),
        emptyReasonList == true
            ? RequiredFeild(text:  EasyLocalization.of(context).locale == Locale("en", "US")
            ? 'This feild is required'
            : "هذا الحقل مطلوب",)
            : Container(),
      ],
    );
  }

  Future<void> _onLogout(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccessState) {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(builder: (context) => SignInScreen()),
                  ModalRoute.withName('/SignInScreen'),
                );
              }
            },
            child: AlertDialog(
              title: Text("DeliveryEShop.LogoutRegistration".tr().toString()),
              content: Text("DeliveryEShop.Message_one".tr().toString()),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.cancel".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    Navigator.of(context).pop(false);
                  },
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.Logout".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    //Navigator.of(context).pop(true);
                    logoutBloc.add(LogoutButtonPressed());
                  },
                ),
              ],
            ));
      },
    );
  }


  Future<void> _Unauthorized(BuildContext context) async {
    return showDialog<void>(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return BlocListener<LogoutBloc, LogoutState>(
            listener: (context, state) {
              if (state is LogoutSuccessState) {
                Navigator.pushAndRemoveUntil<void>(
                  context,
                  MaterialPageRoute<void>(builder: (context) => SignInScreen()),
                  ModalRoute.withName('/SignInScreen'),
                );
              }
            },
            child: AlertDialog(
              title: Text(EasyLocalization.of(context).locale ==
                  Locale("en", "US")
                  ? 'Unauthorized'
                  : 'غير مصرح'),
              content: Text(EasyLocalization.of(context).locale ==
                  Locale("en", "US")
                  ? 'You need to logout and login again'
                  : 'تحتاج إلى تسجيل الخروج وتسجيل الدخول مرة أخرى'),
              actions: <Widget>[

                TextButton(
                  style: TextButton.styleFrom(
                    textStyle: Theme.of(context).textTheme.labelLarge,
                  ),
                  child: Text("DeliveryEShop.Logout".tr().toString(),
                      style: TextStyle(
                          color: Color(0xFF392156),
                          fontWeight: FontWeight.bold)),
                  onPressed: () {
                    //Navigator.of(context).pop();
                    //Navigator.of(context).pop(true);
                    logoutBloc.add(LogoutButtonPressed());
                  },
                ),
              ],
            ));
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                //tooltip: 'Menu Icon',
                onPressed: () {
                  Navigator.pop(
                    context,
                  );
                },
              ),
              centerTitle: false,
              title: Text("DeliveryEShop.Orders_List".tr().toString()),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Settings_Screen(),
                      ),
                    );
                   /* ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('This is a snackbar')));*/
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.logout),
                  tooltip: 'Go to the next page',
                  onPressed: () => _onLogout(context),
                ),
              ],
              //<Widget>[]
              backgroundColor: Color(0xFF392156),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    /*...............This Container Have Tow buttons one for Prepaid-Orders  && the second for Postpaid-Orders................*/
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      height: Order_PostPaid == true ? 200 : 90,
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _clickOrders_PostPaid();
                                    },
                                    style: Order_PostPaid == true
                                        ? ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Color(0xFF4f2565),
                                      side: BorderSide(color: Color(0xFF4f2565), width: 1),
                                      shadowColor: Colors.transparent,
                                    )
                                        : ElevatedButton.styleFrom(
                                      primary: Colors.white,
                                      onPrimary: Color(0xff636f7b),
                                      side: BorderSide(color: Color(0xffe4e5eb), width: 1),
                                      shadowColor: Colors.transparent,
                                    ),
                                    icon: Order_PostPaid == true
                                        ? Icon(
                                      Icons.check_circle,
                                      size: 24.0,
                                    )
                                        : Icon(
                                      Icons.circle_outlined,
                                      size: 24.0,
                                    ),
                                    label: Text(
                                      EasyLocalization.of(context).locale == Locale("en", "US")
                                          ? "PostPaid"
                                          : "PostPaid",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(width: 10), // Add some space between buttons
                              Expanded(
                                child: SizedBox(
                                  height: 50,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      _clickOrders_Prepaid();
                                    },
                                    style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.transparent,
                                      primary: Colors.white,
                                      onPrimary: Order_Prepaid == true
                                          ? Color(0xFF4f2565)
                                          : Color(0xff636f7b),
                                      side: BorderSide(
                                          color: Order_Prepaid == true
                                              ? Color(0xFF4f2565)
                                              : Color(0xffe4e5eb),
                                          width: 1),
                                    ),
                                    icon: Order_Prepaid == true
                                        ? Icon(
                                      Icons.check_circle,
                                      size: 24.0,
                                    )
                                        : Icon(
                                      Icons.circle_outlined,
                                      size: 24.0,
                                    ),
                                    label: Text(
                                      EasyLocalization.of(context).locale == Locale("en", "US")
                                          ? "PrePaid"
                                          : "PrePaid",
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Order_PostPaid == true ? buildMarketType() : Container(),
                        ],
                      ),
                    ),

                    SizedBox(height: 10,),
/*....................................................This part to check Market Type and Navigation to page............................................*/
/*..................................................................Prepaid Driver Orders List.........................................................*/
                    orderListEmptyPrepaid == false && Order_Prepaid == true?
                    Expanded(
                        child: new ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderListPrepaid.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8),
                                  child: ExpansionTileCard(
                                      onExpansionChanged: (value) {
                                        setState(() {
                                          _isExpanded = value;
                                        });
                                      },
                                      baseColor: Colors.white,
                                      expandedColor: Colors.white,
                                      title: Text(
                                        "DeliveryEShop.orderID".tr().toString()+" "+ orderListPrepaid[index]['orderId'].toString(),
                                        style: TextStyle(
                                            color: Color(0xFF392156),
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      trailing: AnimatedRotation(
                                        turns: _isExpanded ? 0 : 0,
                                        duration:
                                        Duration(seconds: 1),
                                        child: _isExpanded
                                            ? Icon(
                                          Icons
                                              .arrow_drop_up_sharp,
                                          color: _isExpanded
                                              ? Color(
                                              0xFF392156)
                                              : Color(
                                              0xFF818589),
                                          size: 24,
                                        )
                                            : Icon(
                                          Icons.arrow_drop_down,
                                          color: _isExpanded
                                              ? Color(
                                              0xFF392156)
                                              : Color(
                                              0xFF818589),
                                          size: 24,
                                        ),
                                      ),
                                      children: <Widget>[
                                        Divider(
                                          thickness: 1.0,
                                          height: 1.0,
                                        ),
                                        Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0,
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                                  children: <Widget>[
                                                    Row(children: <
                                                        Widget>[
                                                      Expanded(
                                                        flex: 2,
                                                        child: Container(
                                                          child: Text(
                                                            "DeliveryEShop.packageName".tr().toString(),
                                                            style:
                                                            TextStyle(
                                                              fontSize:
                                                              14,
                                                              color: Color(
                                                                  0xFF392156),
                                                            ),
                                                          ),
                                                        )
                                                      ),
                                                      Expanded(
                                                        flex: 2,
                                                        child:
                                                        Container(
                                                          child:
                                                          Text(
                                                            EasyLocalization.of(context).locale ==
                                                                Locale("en", "US")
                                                                ? "Esim"
                                                                : "الشريحة الإلكترونية",

                                                            style:
                                                            TextStyle(
                                                              fontSize:
                                                              14,
                                                              color:
                                                              Color(0xFF392156),
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                    ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                    orderListPrepaid[index]
                                                                    ['packageName'],
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      color:
                                                                      Color(0xFF392156),
                                                                      fontWeight: FontWeight.bold),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListPrepaid[index]['isEsim']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156),
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),

                                                    SizedBox(height: 10),
                                                    /**********************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  "DeliveryEShop.PackageCode".tr().toString(),
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    color:
                                                                    Color(0xFF392156),
                                                                  ),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                EasyLocalization.of(context).locale ==
                                                                    Locale("en", "US")
                                                                    ? "Package Type"
                                                                    : "نوع الحزمة",

                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  color:
                                                                  Color(0xFF392156),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  orderListPrepaid[index]['packageCode']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      color:
                                                                      Color(0xFF392156),
                                                                      fontWeight: FontWeight.bold),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListPrepaid[index]['market']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156),
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(height: 10),
                                                    /************************************************************************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                EasyLocalization.of(context).locale ==
                                                                    Locale("en", "US")
                                                                    ? "Amount":"المبلغ",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                EasyLocalization.of(context).locale ==
                                                                    Locale("en", "US")
                                                                    ? "Adress":"العنوان",

                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListPrepaid[index]['paymentStatus']=="Paid"?"0":orderListPrepaid[index]['orderTotal'].toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(orderListPrepaid[index]['address'].toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(height: 10),
                                                    /************************************************************************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                EasyLocalization.of(context).locale ==
                                                                    Locale("en", "US")
                                                                    ? "MSISDN":"MSISDN",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.OrderDate".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListPrepaid[index]['msisdn']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListPrepaid[index]['orderDate'].substring(0, orderListPrepaid[index]['orderDate'].lastIndexOf('T') + 0),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(height: 10),
                                                    /************************************************************************************************************************************/
                                                  ])),
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                primary:
                                                Color(0xFF392156),
                                                minimumSize:
                                                Size.fromHeight(
                                                    48), // NEW
                                              ),
                                              onPressed: () {
                                               setState(() {
                                                  orderID = orderListPrepaid[index]['orderId'].toString();
                                                  packageName =orderListPrepaid[index]['packageName'].toString();
                                                  packageCode =orderListPrepaid[index]['packageCode'].toString();
                                                  marketType =orderListPrepaid[index]['market'].toString();
                                                  driverName= orderListPrepaid[index]['name'].toString();
                                                  selectedNimber=orderListPrepaid[index]['msisdn'].toString();
                                                  referanceNumber=orderListPrepaid[index]['phoneNumber'].toString();
                                                  passportNumber=orderListPrepaid[index]['passportNumber'].toString();
                                                  nationalNumber=orderListPrepaid[index]['nationalNumber'].toString();
                                                  PaymentMethodSystemName=orderListPrepaid[index]['paymentMethodSystemName'].toString();
                                                  paymentMethodName=orderListPrepaid[index]['paymentMethodName'].toString();

                                                  commitment=orderListPrepaid[index]['duration'].toString();
                                                  email=orderListPrepaid[index]['email'].toString();

                                                  orderTotal= orderListPrepaid[index]['paymentStatus']=="Paid"?"0":orderListPrepaid[index]['orderTotal'].toString();
                                                  Esim=orderListPrepaid[index]['isEsim'];
                                                  birthdate = orderListPrepaid[index]["birthdate"].toString() != null? orderListPrepaid[index]["birthdate"].toString():"-";
                                                });
                                               if(orderListPrepaid[index]['nationalityTypeId']==1){
                                                 Navigator.push(
                                                   context,
                                                   MaterialPageRoute(
                                                     builder: (context) => JordanianInformation(
                                                         this.PermessionDeliveryEShop,
                                                         this.role,
                                                         this.orderID,
                                                         this.packageName,
                                                         this.packageCode,
                                                         this.marketType,
                                                         this.driverName,
                                                         this.selectedNimber,
                                                         this.referanceNumber,
                                                         this.passportNumber,
                                                         this.nationalNumber,
                                                         this.PaymentMethodSystemName,
                                                         this.paymentMethodName,
                                                         this.commitment,
                                                         this.email,
                                                         this.orderTotal,
                                                       this.Esim
                                                     ),
                                                   ),
                                                 );
                                               }
                                               if(orderListPrepaid[index]['nationalityTypeId']==2){
                                                 print("this.PaymentMethodSystemName");
                                                 print(this.PaymentMethodSystemName);
                                                 print("this.paymentMethodName");
                                                 print(this.paymentMethodName);
                                                 Navigator.push(
                                                   context,
                                                   MaterialPageRoute(
                                                     builder: (context) => nonJordanianInformation(
                                                         this.PermessionDeliveryEShop,
                                                         this.role,
                                                         this.orderID,
                                                         this.packageName,
                                                         this.packageCode,
                                                         this.marketType,
                                                         this.driverName,
                                                         this.selectedNimber,
                                                         this.referanceNumber,
                                                         this.passportNumber,
                                                         this.nationalNumber,
                                                         this.PaymentMethodSystemName,
                                                         this.paymentMethodName,
                                                         this.commitment,
                                                         this.email,
                                                         this.orderTotal,
                                                         this.Esim,
                                                         this.birthdate

                                                     ),
                                                   ),
                                                 );
                                               }
                                              },

                                              child:  Text(
                                                  EasyLocalization
                                                      .of(context)
                                                      .locale == Locale("en", "US")
                                                      ? 'Next'
                                                      : "التالي",
                                                style: TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]));
                            }))
                        :
                    Container(),
 /*....................................................This part to check Market Type and Navigation to page...........................................*/
/*..................................................................Postpaid Driver Orders List........................................................*/
/*.........................................................................FTTH Orders.................................................................*/
                    orderListEmptyFTTH == false && defultSelectedType=="FTTH" && Order_PostPaid==true?

                    Expanded(
                        child: new ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderListFTTH.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8),
                                  child: ExpansionTileCard(
                                      onExpansionChanged: (value) {
                                        setState(() {
                                          _isExpanded = value;
                                        });
                                      },
                                      baseColor: Colors.white,
                                      expandedColor: Colors.white,
                                      title: Text(
                                        "DeliveryEShop.orderID".tr().toString()+" "+
                                            orderListFTTH[index]
                                            ['orderId']
                                                .toString(),
                                        style: TextStyle(
                                            color: Color(0xFF392156),
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      trailing: AnimatedRotation(
                                        turns: _isExpanded ? 0 : 0,
                                        duration:
                                        Duration(seconds: 1),
                                        child: _isExpanded
                                            ? Icon(
                                          Icons
                                              .arrow_drop_up_sharp,
                                          color: _isExpanded
                                              ? Color(
                                              0xFF392156)
                                              : Color(
                                              0xFF818589),
                                          size: 24,
                                        )
                                            : Icon(
                                          Icons.arrow_drop_down,
                                          color: _isExpanded
                                              ? Color(
                                              0xFF392156)
                                              : Color(
                                              0xFF818589),
                                          size: 24,
                                        ),
                                      ),
                                      children: <Widget>[
                                        Divider(
                                          thickness: 1.0,
                                          height: 1.0,
                                        ),
                                        Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0,
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .stretch,
                                                  children: <Widget>[
                                                    Row(children: <
                                                        Widget>[
                                                      Container(
                                                        child: Text(
                                                          "DeliveryEShop.packageName".tr().toString(),
                                                          style:
                                                          TextStyle(
                                                            fontSize:
                                                            14,
                                                            color: Color(
                                                                0xFF392156),
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Text(
                                                            orderListFTTH[index]
                                                            [
                                                            'packageName']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                14,
                                                                color: Color(
                                                                    0xFF392156),
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          )
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /**********************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  "DeliveryEShop.PackageCode".tr().toString(),
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    color:
                                                                    Color(0xFF392156),
                                                                  ),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.Market".tr().toString(),
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  color:
                                                                  Color(0xFF392156),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  orderListFTTH[index]['packageCode']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      color:
                                                                      Color(0xFF392156),
                                                                      fontWeight: FontWeight.bold),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListFTTH[index]['market']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156),
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /************************************************************************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.OrderTotal".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.Commitment".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListFTTH[index]['orderTotal']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListFTTH[index]['duration'] == null
                                                                    ? '--'
                                                                    : orderListFTTH[index]['duration'].toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /************************************************************************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.PhoneNumber".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.OrderDate".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListFTTH[index]['phoneNumber']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListFTTH[index]['orderDate'].substring(0, orderListFTTH[index]['orderDate'].lastIndexOf('T') + 0),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /************************************************************************************************************************************/
                                                  ])),
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                primary:
                                                Color(0xFF392156),
                                                minimumSize:
                                                Size.fromHeight(
                                                    48), // NEW
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  orderID = orderListFTTH[index]['orderId'].toString();
                                                  packageName = orderListFTTH[index]['packageName'].toString();
                                                  packageCode = orderListFTTH[index]['packageCode'].toString();
                                                  marketType = orderListFTTH[index]['market'].toString();
                                                  isParentEligible=false;
                                                });
                                                /*........................This part to check Market Type and Navigation to page.............................*/
                                                /*......................................Navigation to page FTTH............................................*/
                                                if (orderListFTTH[index]
                                                ['market'].toString() == 'FTTH') {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => NationalityList(
                                                          this.PermessionDeliveryEShop,
                                                          this.role,
                                                          this.orderID,
                                                          this.packageName,
                                                          this.packageCode,
                                                          this.marketType),
                                                    ),
                                                  );
                                                }

                                              },

                                              child: const Text(
                                                'Next',
                                                style: TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]));
                            }))
                    :
                    Container(),

/*.........................................................................MBB Orders.................................................................*/

                    orderListEmptyMBB == false && defultSelectedType=="MBB" && Order_PostPaid==true?

                    Expanded(
                        child: new ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderListMBB.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8),
                                  child: ExpansionTileCard(
                                      onExpansionChanged: (value) {
                                        setState(() {
                                          _isExpanded = value;
                                        });
                                      },
                                      baseColor: Colors.white,
                                      expandedColor: Colors.white,
                                      title: Text(
                                        "DeliveryEShop.orderID".tr().toString()+" "+
                                            orderListMBB[index]
                                            ['orderId']
                                                .toString(),
                                        style: TextStyle(
                                            color: Color(0xFF392156),
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      trailing: AnimatedRotation(
                                        turns: _isExpanded ? 0 : 0,
                                        duration:
                                        Duration(seconds: 1),
                                        child: _isExpanded
                                            ? Icon(
                                          Icons
                                              .arrow_drop_up_sharp,
                                          color: _isExpanded
                                              ? Color(
                                              0xFF392156)
                                              : Color(
                                              0xFF818589),
                                          size: 24,
                                        )
                                            : Icon(
                                          Icons.arrow_drop_down,
                                          color: _isExpanded
                                              ? Color(
                                              0xFF392156)
                                              : Color(
                                              0xFF818589),
                                          size: 24,
                                        ),
                                      ),
                                      children: <Widget>[
                                        Divider(
                                          thickness: 1.0,
                                          height: 1.0,
                                        ),
                                        Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0,
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .stretch,
                                                  children: <Widget>[
                                                    Row(children: <
                                                        Widget>[
                                                      Container(
                                                        child: Text(
                                                          "DeliveryEShop.packageName".tr().toString(),
                                                          style:
                                                          TextStyle(
                                                            fontSize:
                                                            14,
                                                            color: Color(
                                                                0xFF392156),
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Text(
                                                            orderListMBB[index]
                                                            [
                                                            'packageName']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                14,
                                                                color: Color(
                                                                    0xFF392156),
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          )
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /**********************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  "DeliveryEShop.PackageCode".tr().toString(),
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    color:
                                                                    Color(0xFF392156),
                                                                  ),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.Market".tr().toString(),
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  color:
                                                                  Color(0xFF392156),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  orderListMBB[index]['packageCode']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      color:
                                                                      Color(0xFF392156),
                                                                      fontWeight: FontWeight.bold),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListMBB[index]['market']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156),
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /************************************************************************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.OrderTotal".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.Commitment".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListMBB[index]['orderTotal']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListMBB[index]['duration'] == null
                                                                    ? '--'
                                                                    : orderListMBB[index]['duration'].toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /************************************************************************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.PhoneNumber".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.OrderDate".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListMBB[index]['phoneNumber']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListMBB[index]['orderDate'].substring(0, orderListMBB[index]['orderDate'].lastIndexOf('T') + 0),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /************************************************************************************************************************************/
                                                  ])),
                                        ),
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                primary:
                                                Color(0xFF392156),
                                                minimumSize:
                                                Size.fromHeight(
                                                    48), // NEW
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  orderID = orderListMBB[
                                                  index]
                                                  ['orderId']
                                                      .toString();
                                                  packageName =
                                                      orderListMBB[index]
                                                      [
                                                      'packageName']
                                                          .toString();
                                                  packageCode =
                                                      orderListMBB[index]
                                                      [
                                                      'packageCode']
                                                          .toString();
                                                  marketType =
                                                      orderListMBB[index]
                                                      [
                                                      'market']
                                                          .toString();
                                                  isParentEligible=false;
                                                });
                                                /*........................This part to check Market Type and Navigation to page.............................*/

                                                /*......................................Navigation to page MBB............................................*/
                                                if (orderListMBB[index]
                                                ['market']
                                                    .toString() ==
                                                    'MBB') {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => BroadBandNationalityList(
                                                              this.PermessionDeliveryEShop,
                                                              this.role,
                                                              this.orderID,
                                                              this.packageName,
                                                              this.packageCode,
                                                              this.marketType,
                                                              this.isParentEligible
                                                          )
                                                      )
                                                  );
                                                }

                                              },

                                              child: const Text(
                                                'Next',
                                                style: TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]));
                            }))
                    :
                    Container(),
/*.....................................................................GSM Orders....................................................................*/

                    orderListEmptyGSM == false && defultSelectedType=="GSM" && Order_PostPaid==true?
                    Expanded(
                        child: new ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderListGSM.length,
                            itemBuilder:
                                (BuildContext context, int index) {
                                  // Ensure the lists are correctly sized
                                  if (index >= _controllers.length) {
                                    _controllers.add(TextEditingController());
                                  }
                                  if (index >= _maximumCharacterFlags.length) {
                                    _maximumCharacterFlags.add(false);
                                  }
                              return Padding(
                                  padding: const EdgeInsets.only(
                                      left: 12, right: 12, top: 8),
                                  child: ExpansionTileCard(
                                      onExpansionChanged: (value) {
                                        setState(() {
                                          _isExpanded = value;
                                          getOrderId=  orderListGSM[index]['orderId'];
                                        });
                                      },
                                      baseColor: Colors.white,
                                      expandedColor: Colors.white,
                                      title: Text(
                                        "DeliveryEShop.orderID".tr().toString()+" "+
                                            orderListGSM[index]
                                            ['orderId']
                                                .toString(),
                                        style: TextStyle(
                                            color: Color(0xFF392156),
                                            fontWeight:
                                            FontWeight.bold,
                                            fontSize: 16),
                                      ),
                                      trailing: AnimatedRotation(
                                        turns: _isExpanded ? 0 : 0,
                                        duration:
                                        Duration(seconds: 1),
                                        child: _isExpanded
                                            ? Icon(
                                          Icons
                                              .arrow_drop_up_sharp,
                                          color: _isExpanded
                                              ? Color(
                                              0xFF392156)
                                              : Color(
                                              0xFF818589),
                                          size: 24,
                                        )
                                            : Icon(
                                          Icons.arrow_drop_down,
                                          color: _isExpanded
                                              ? Color(
                                              0xFF392156)
                                              : Color(
                                              0xFF818589),
                                          size: 24,
                                        ),
                                      ),
                                      children: <Widget>[
                                        Divider(
                                          thickness: 1.0,
                                          height: 1.0,
                                        ),
                                        Align(
                                          alignment:
                                          Alignment.centerLeft,
                                          child: Padding(
                                              padding:
                                              const EdgeInsets
                                                  .symmetric(
                                                horizontal: 16.0,
                                                vertical: 8.0,
                                              ),
                                              child: Column(
                                                  crossAxisAlignment:
                                                  CrossAxisAlignment
                                                      .stretch,
                                                  children: <Widget>[
                                                    Row(children: <
                                                        Widget>[
                                                      Container(
                                                        child: Text(
                                                          "DeliveryEShop.packageName".tr().toString(),
                                                          style:
                                                          TextStyle(
                                                            fontSize:
                                                            14,
                                                            color: Color(
                                                                0xFF392156),
                                                          ),
                                                        ),
                                                      )
                                                    ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Text(
                                                            orderListGSM[index]
                                                            [
                                                            'packageName']
                                                                .toString(),
                                                            style: TextStyle(
                                                                fontSize:
                                                                14,
                                                                color: Color(
                                                                    0xFF392156),
                                                                fontWeight:
                                                                FontWeight.bold),
                                                          )
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /**********************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  "DeliveryEShop.PackageCode".tr().toString(),
                                                                  style:
                                                                  TextStyle(
                                                                    fontSize:
                                                                    14,
                                                                    color:
                                                                    Color(0xFF392156),
                                                                  ),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.Market".tr().toString(),
                                                                style:
                                                                TextStyle(
                                                                  fontSize:
                                                                  14,
                                                                  color:
                                                                  Color(0xFF392156),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  orderListGSM[index]['packageCode']
                                                                      .toString(),
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                      14,
                                                                      color:
                                                                      Color(0xFF392156),
                                                                      fontWeight: FontWeight.bold),
                                                                )),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListGSM[index]['market']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156),
                                                                    fontWeight: FontWeight.bold),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /************************************************************************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.OrderTotal".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                EasyLocalization.of(context).locale ==
                                                                    Locale("en", "US")?"Esim":"الشريحة الإلكترونية",
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),

                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListGSM[index]['orderTotal']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListGSM[index]['isEsim']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),

                                                        ]),
                                                    SizedBox(
                                                        height: 10),
                                                    /************************************************************************************************************************************/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.PhoneNumber".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                "DeliveryEShop.OrderDate".tr().toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListGSM[index]['phoneNumber']
                                                                    .toString(),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Text(
                                                                orderListGSM[index]['orderDate'].substring(0, orderListGSM[index]['orderDate'].lastIndexOf('T') + 0),
                                                                style: TextStyle(
                                                                    fontSize: 14,
                                                                    fontWeight: FontWeight.bold,
                                                                    color: Color(0xFF392156)),
                                                              ),
                                                            ),
                                                          ),
                                                        ]),
                                                    SizedBox(height: 20),
                                                    /************************************************************************************************************************************/
                                                    /*......................................................Switch Button and List resone..............................................*/
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                              child:
                                                              Column(
                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                children: <Widget>[//
                                                                  RichText(
                                                                    text: TextSpan(
                                                                      text:  EasyLocalization.of(context).locale == Locale("en", "US") ? "Note": "ملاحظات",
                                                                      style: TextStyle(
                                                                          fontSize: 14,
                                                                          fontWeight: FontWeight.bold,
                                                                          color: Color(0xFF392156)),
                                                                      children: <TextSpan>[
                                                                        TextSpan(
                                                                          text: ' * ',
                                                                          style: TextStyle(
                                                                            color: Colors.transparent,
                                                                            fontSize: 14,
                                                                            fontWeight: FontWeight.normal,
                                                                          ),
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(height: 0),
                                                                ],
                                                              )
                                                            ),
                                                          ),

                                                          Container(child: Switch(
                                                            value: switchValues[index] ?? false, // Current switch state
                                                            onChanged: (newValue) {
                                                              if( switchValues[index]== false){
                                                                _controllers[index].text="";
                                                              }
                                                              setState(() {
                                                                switchValues[index] = newValue; // Update switch state
                                                              });
                                                            },
                                                            activeTrackColor: Color(0xFF767699),
                                                            activeColor: Color(0xFF4f2565),
                                                            inactiveTrackColor: Color(0xFFEBECF1),
                                                          ),)
                                                        ]),
                                                    SizedBox(height: 10),
                                                    switchValues[index]==true?
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child:
                                                            Container(
                                                                child:
                                                                Column(
                                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                                  children: <Widget>[//

                                                                      Container(
                                                                          decoration: BoxDecoration(
                                                                        color: Colors.white,
                                                                        borderRadius: BorderRadius.circular(4),
                                                                        border: Border.all(
                                                                          //color: Color(0xFFB10000), red color
                                                                          color: emptyReasonList == true
                                                                              ? Color(0xFFB10000)
                                                                              : Color(0xFFD1D7E0),
                                                                        ),
                                                                      ),
                                                                          child: DropdownButtonHideUnderline(
                                                                            child: ButtonTheme(
                                                                              alignedDropdown: true,
                                                                              child: DropdownButton<String>(
                                                                                hint: Text(
                                                                                  EasyLocalization.of(context).locale ==
                                                                                      Locale("en", "US")
                                                                                      ? "Select option"
                                                                                      : "حدد من القائمة",
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
                                                                                items: getReasonList.map((valueItem) {
                                                                                  return DropdownMenuItem<String>(
                                                                                    value: valueItem["reason"],
                                                                                    child: EasyLocalization.of(context).locale ==
                                                                                        Locale("en", "US")
                                                                                        ? Text(valueItem["reason"])
                                                                                        : Text(valueItem["reason"]),
                                                                                  );
                                                                                }).toList(),
                                                                                value:selectedValuesNote[index],
                                                                                onChanged: (String newValue) {
                                                                                  setState(() {
                                                                                    selectedValuesNote[index]=newValue;
                                                                                  });
                                                                                  print("selectedValues[index]");
                                                                                  print(selectedValuesNote[index]);
                                                                                },
                                                                              ),
                                                                            ),
                                                                          )),
                                                                    SizedBox(height: 20),
                                                                    selectedValuesNote[index]=="Others"?  Container(
                                                                      color: Colors.white,
                                                                      padding: EdgeInsets.all(3),
                                                                      child: SizedBox(
                                                                        child: Column(
                                                                          crossAxisAlignment: CrossAxisAlignment.start,
                                                                          children: <Widget>[
                                                                            RichText(
                                                                              text: TextSpan(
                                                                                text:    EasyLocalization.of(context).locale ==
                                                                            Locale("en", "US")
                                                                            ? "Other Reason"
                                                                            : "سبب آخر",
                                                                                style: TextStyle(
                                                                                  color: Color(0xFF392156),
                                                                                  fontSize: 14,
                                                                                  fontWeight: FontWeight.bold,
                                                                                ),

                                                                              ),
                                                                            ),
                                                                            SizedBox(height: 10),
                                                                            Container(
                                                                              alignment: Alignment.centerLeft,
                                                                              height: 100,
                                                                              child: TextField(
                                                                                enabled: true,
                                                                                keyboardType: TextInputType.multiline,
                                                                                maxLines: 3, // <-- SEE HERE
                                                                                minLines: 3,
                                                                                // <-- SEE HERE
                                                                                inputFormatters: [
                                                                                  new LengthLimitingTextInputFormatter(101), /// here char limit is 5
                                                                                ],
                                                                                controller: _controllers[index],
                                                                                style: TextStyle(color: Colors.black),
                                                                                decoration: InputDecoration(
                                                                                  border: OutlineInputBorder(
                                                                                      borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
                                                                                  disabledBorder: OutlineInputBorder(
                                                                                      borderSide: BorderSide(width: 1, color: Color(0xFFD1D7E0))),
                                                                                  focusedBorder: OutlineInputBorder(
                                                                                    borderSide:
                                                                                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
                                                                                  ),
                                                                                  fillColor: Colors.white,
                                                                                  filled: true,
                                                                                  contentPadding: EdgeInsets.all(16),
                                                                                ),
                                                                                onChanged: (value){
                                                                                  print('Text for item $index: ${_controllers[index].text}');


                                                                                },
                                                                              ),
                                                                            ),

                                                                            SizedBox(height: 5),

                                                                          ],
                                                                        ),
                                                                      ),):Container()

                                                                  ],
                                                                )
                                                            ),
                                                          ),
                                                        ]):Container(),
                                                    /************************************************************************************************************************************/
                                                  ])),
                                        ),
                                              /*..........if condition is null will navigate to Jordanian-nonJordanian Screen else will submit the value of note without routto any screen..........*/
                                        //selectedValuesNote[index]!=null
                                        switchValues[index]==true?
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                primary:
                                                Color(0xFF392156),
                                                minimumSize:
                                                Size.fromHeight(
                                                    48), // NEW
                                              ),
                                              onPressed: () {
                                                selectedValuesNote[index]!="Others"?
                                                submitOrderNote(getOrderId,selectedValuesNote[index]):submitOrderNote(getOrderId,_controllers[index].text);
                                              },
                                              child:  Text(
                                                EasyLocalization
                                                    .of(context)
                                                    .locale == Locale("en", "US")
                                                    ? 'Submit Order Note'
                                                    : "إرسال ملاحظة الطلب",
                                                style: TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        )
                                        :
                                        Column(
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton
                                                  .styleFrom(
                                                primary:
                                                Color(0xFF392156),
                                                minimumSize:
                                                Size.fromHeight(
                                                    48), // NEW
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  orderID = orderListGSM[index]['orderId'].toString();
                                                  packageName = orderListGSM[index]['packageName'].toString();
                                                  packageCode = orderListGSM[index]['packageCode'].toString();
                                                  marketType = orderListGSM[index]['market'].toString();
                                                  driverName= orderListGSM[index]['name'].toString();
                                                  paymentMethodName=orderListGSM[index]['paymentMethodName'].toString();
                                                  selectedNimber=orderListGSM[index]['msisdn'].toString();
                                                  referanceNumber=orderListGSM[index]['phoneNumber'].toString();
                                                  passportNumber=orderListGSM[index]['passportNumber'].toString();
                                                  nationalNumber=orderListGSM[index]['nationalNumber'].toString();
                                                  PaymentMethodSystemName=orderListGSM[index]['paymentMethodSystemName'].toString();
                                                  commitment=orderListGSM[index]['commitment'].toString();
                                                  isEsim=orderListGSM[index]['isEsim'];
                                                });
                                                /***********************to check Market Type**********************/
                                                /*......................................Navigation to page GSM............................................*/
                                                if (orderListGSM[index]['market'].toString() == 'GSM' &&  orderListGSM[index]['nationalNumber'].toString() != '') {
                                                  Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => GSM_JordainianCustomerInformation(
                                                                this.PermessionDeliveryEShop,
                                                              this.role,
                                                              this.orderID,
                                                              this.packageName,
                                                              this.packageCode,
                                                              this.marketType,
                                                              this.driverName,
                                                              this.paymentMethodName,
                                                              this.selectedNimber,
                                                              this.referanceNumber,
                                                              this.passportNumber,
                                                              this.nationalNumber,
                                                              this.PaymentMethodSystemName,
                                                              this.commitment,
                                                              this.isEsim


                                                          )
                                                      )
                                                  );
                                                }
                                                if (orderListGSM[index]['market'].toString() == 'GSM' &&  orderListGSM[index]['nationalNumber'].toString() == '') {
                                                  print(orderListGSM[index]['orderId'].toString());
                                                     Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => GSM_NonJordainianCustomerInformation(
                                                              this.PermessionDeliveryEShop,
                                                              this.role,
                                                              this.orderID,
                                                              this.packageName,
                                                              this.packageCode,
                                                              this.marketType,
                                                              this.driverName,
                                                              this.paymentMethodName,
                                                              this.selectedNimber,
                                                              this.referanceNumber,
                                                              this.passportNumber,
                                                              this.nationalNumber,
                                                              this.PaymentMethodSystemName,
                                                              this.commitment,
                                                              this.isEsim
                                                          )
                                                      )
                                                  );
                                                }

                                              },
                                              child:  Text(
                                                  EasyLocalization
                                                      .of(context)
                                                      .locale == Locale("en", "US")
                                                      ? 'Next'
                                                      : "التالي",
                                                style: TextStyle(
                                                    fontSize: 14),
                                              ),
                                            ),
                                          ],
                                        )
                                      ]));
                            }))
                        :
                    Container(),

                    SizedBox(height: 20,)
                  ],
                ),

                Visibility(
                  visible: checkGetListPrepaid, // Adjust the condition based on when you want to show the overlay
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF392156),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: checkGetListMBB, // Adjust the condition based on when you want to show the overlay
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF392156),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: checkGetListMBB, // Adjust the condition based on when you want to show the overlay
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF392156),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: checkSubmitOrderNote, // Adjust the condition based on when you want to show the overlay
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF392156),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: checkGetListGSM, // Adjust the condition based on when you want to show the overlay
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF392156),
                      ),
                    ),
                  ),
                ),
                Visibility(
                  visible: getReasons, // Adjust the condition based on when you want to show the overlay
                  child: Container(
                    color: Colors.black.withOpacity(0.5), // Adjust the opacity as needed
                    width: double.infinity,
                    height: double.infinity,
                    child: Center(
                      child: CircularProgressIndicator(
                        color: Color(0xFF392156),
                      ),
                    ),
                  ),
                ),
              ],
            )),
        onWillPop: _onWillPop);
  }
}



