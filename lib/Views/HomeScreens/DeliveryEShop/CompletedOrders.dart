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

class CompletedOrders extends StatefulWidget {
  //const CompletedOrders({Key? key}) : super(key: key);

  @override
  State<CompletedOrders> createState() => _CompletedOrdersState();
}

APP_URLS urls = new APP_URLS();

class _CompletedOrdersState extends State<CompletedOrders> {
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

  bool checkGetListOrderDriver =false;
  bool orderListEmptyOrderDriver = false;
  List DriverList =[];

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

    getSharedPrefernece();
    OrderDriverList();
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


  /*............................................... Prepaid Flow On Eshop Layer ..............................................*/
  void OrderDriverList() async {
    setState(() {
      checkUnauthorized=true;
      checkGetListOrderDriver=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL + '/Dashboard/GetOrderDriver';
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
          orderListEmptyOrderDriver = true;
          checkUnauthorized=false;
          checkGetListOrderDriver=false;

        });
      } else if (result["data"] != null || result["data"].length != 0) {
        setState(() {
          DriverList = result["data"];



          orderListEmptyOrderDriver = false;
          checkUnauthorized=false;
          checkGetListOrderDriver=false;
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
          checkGetListOrderDriver=false;
        });
      }else{
        setState(() {
          status = statusCode.toString();
          checkGetListOrderDriver=false;
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(EasyLocalization.of(context).locale ==
                Locale("en", "US")
                ? 'No Order List status is ' + ' ' + statusCode.toString()
                : statusCode.toString() + " " + "لا توجد قائمة طلبات الحالة")));
      }

    }
  }

/*........................................................................................................................*/


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
              title: Text( EasyLocalization
                  .of(context)
                  .locale ==
                  Locale("en", "US")?"Completed orders":"الطلبات المكتملة",),
              automaticallyImplyLeading: false,

              //<Widget>[]
              backgroundColor: Color(0xFF392156),
            ),
            backgroundColor: Color(0xFFEBECF1),
            body: Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [

                    Expanded(
                        child: new ListView.builder(
                            shrinkWrap: true,
                            itemCount: DriverList.length,
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
                                      title: Align(
                                        alignment: Alignment.centerLeft, // Adjust alignment as needed
                                        child: SelectableText(
                                          "DeliveryEShop.orderID".tr().toString() + " " + DriverList[index]['orderId'].toString(),
                                          style: TextStyle(
                                            color: Color(0xFF392156),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
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
                                                      Container()
                                                      ),

                                                    ]),
                                                    Row(
                                                        children: <
                                                            Widget>[
                                                          Expanded(
                                                            flex: 2,
                                                            child: Container(
                                                                child: Text(
                                                                  DriverList[index]
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
                                                                  DriverList[index]['packageCode']
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
                                                                DriverList[index]['packageType']
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
                                                                    ? "Order Total":"مجموع الطلب",
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
                                                                DriverList[index]['orderTotal'].toString(),
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
                                                              Text(DriverList[index]['address'].toString(),
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
                                                                DriverList[index]['msisdn']
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
                                                                DriverList[index]['orderDate'].substring(0, DriverList[index]['orderDate'].lastIndexOf('T') + 0),
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

                                      ]));
                            })),

                    SizedBox(height: 20,)
                  ],
                ),

                Visibility(
                  visible: checkGetListOrderDriver, // Adjust the condition based on when you want to show the overlay
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



