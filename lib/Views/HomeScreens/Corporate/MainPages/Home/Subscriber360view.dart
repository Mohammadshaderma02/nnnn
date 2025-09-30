import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_windowmanager/flutter_windowmanager.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Dashboard.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/360View.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Customer360view.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/KurmalekView/Kurmalek.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/AdjustmentLogs.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/BillingDetails.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Bline/BlineLedger.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/OnlineChargingvalues.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/PresetRisk.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Promotions.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/SubscriberClientMessages.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/SubscriberList.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/Unbilled.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/SubscriberServices/subscriberservices.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/MainMenu/Balance/Balance.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/AppBarSectionCorporate.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria.block.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_events.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Subscriber360Menu/VPNDetails.dart';

import 'MainPromotions/MainPromotions.dart';
import 'Subscriber360Menu/BillShock.dart';
import 'package:sales_app/Shared/BaseUrl.dart';


class Subscriber360view extends StatefulWidget {
  List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  String searchCraretia;
  String msisdn;
  String customerNumber;
  List data=[];

  Subscriber360view(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
  @override
  _Subscriber360viewState createState() =>
      _Subscriber360viewState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);
}

class ListContentFirst {
  String name;
  ListContentFirst({this.name});
}

APP_URLS urls = new APP_URLS();


class _Subscriber360viewState extends State<Subscriber360view> {
  var iosSecureScreenShotChannel = const MethodChannel('secureScreenshotChannel');

  bool serchByEmptyFlag = false;
  DateTime backButtonPressedTime;
  String msisdn;
  String customerNumber;
  List data=[];
  List ClientMessages=[];
  String messageEn;
  String messageAr;
  String activeDate;
String searchCraretia;
  final List<dynamic> PermessionCorporate;
  String role;
  int searchID;
  String searchValue;
  SearchCriteriaBloc searchCriteriaBloc;
  _Subscriber360viewState(this.PermessionCorporate, this.role,this.searchID,this.searchValue,this.customerNumber,this.msisdn,this.data,this.searchCraretia);


  //*******************   List Item for First Menu    ****************/
    List litemsFirst = [
      ListContentFirst(name:"SubscriberView.VPNDetails".tr().toString()),
      ListContentFirst(name:"billShockView.BillShock".tr().toString()),
      ListContentFirst(name:"billingDetailsView.BillingDetails".tr().toString()),
      ListContentFirst(name:"adjustmentLogsViews.AdjustmentLOG".tr().toString()),
      ListContentFirst(name:"OnlineChargingValuesViews.OnlineChargingvalues".tr().toString()),
      ListContentFirst(name:"SubscriberView.PresetRisk".tr().toString()),
      ListContentFirst(name:"PromotionsView.PromotionsDetails".tr().toString()),
      ListContentFirst(name:"Bline Ledger"),
      ListContentFirst(name:"UnbilledView.Unbilled".tr().toString()),
      ListContentFirst(name:"corpMenu.Customer_360_View".tr().toString()),
      ListContentFirst(name:"corpMenu.Subscriber_List".tr().toString()),
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
    print("UnotherizedError");
    print("role role role role role");
    print(role);
    if (PermessionCorporate == null) {
      UnotherizedError();
    }else{

      print("PRINT Data");
      print(this.data[0]['activeDate']);


      getClientMessages_API();

     // Navigator.pop(context, 'OK');
      /*searchCriteriaBloc = BlocProvider.of<SearchCriteriaBloc>(context);
       searchCriteriaBloc.add(SubmitButtonSearchPressed(
          searchID: this.searchID,
          searchValue: this.searchValue
      ));*/

     // iosSecureScreenShotChannel.invokeMethod("secureiOS");

    }

    //disableCapture();
    super.initState();
  }

  @override
  void dispose() {

    // this method to the user can take screenshots of your application
   // iosSecureScreenShotChannel.invokeMethod("unSecureiOS");
  //  iosSecureScreenShotChannel.invokeMethod("secureiOS");


    // TODO: implement dispose
    super.dispose();
  }
  disableCapture() async{
    await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
    print("____________________________________________");
  }



  getClientMessages_API ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "customerId": customerNumber,
      "msisdn": msisdn,
      "clientTypeId": "2"
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/getClientMessages';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print('360 views subscriber');
print(body);

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
    if (statusCode == 404) {
      ClientMessages=[];
      print("I'm here");

    }
    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');
      UnotherizedError();
      /*showAlertDialogUnotherizedERROR(context,"تحتاج إلى إعادة تسجيل الدخول", "Need to re-registration");
      setState(() {
        isLoading =false;
      });*/
    }
    if (statusCode == 200) {

      print("yes");
      var result = json.decode(response.body);
      print(result);
      print(result["data"]);
      print('-------------------------------');

      if(result["data"]==null||result["data"].length==0){
        setState(() {
          ClientMessages=[];
          messageEn=result["message"];
          messageAr=result["messageAr"];
        });
       /* showAlertDialogNoData(context,"لا توجد بيانات متاحة الآن.", "No data available now .");

        setState(() {
          checkData=true;
        });*/
      }else if(result["data"]!=null||result["data"].length!=0){
        setState(() {
          ClientMessages=result["data"];
        });
      }
    else{
       /* showAlertDialogERROR(context,result["messageAr"], result["message"]);
        setState(() {
          isLoading =false;
        });*/

      }



      print('Sucses API');
      print(urls.BASE_URL +'/getClientMessages');


      return result;
    }else{
      //showAlertDialogOtherERROR(context,statusCode, statusCode);

    }
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

              padding: EdgeInsets.only(top: 12,bottom: 12,left:8,right: 8),
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
                                        if(litemsFirst[index].name=="SubscriberView.VPNDetails".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => VPNDetails(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),

                                          );


                                        }
                                        if(litemsFirst[index].name=="billShockView.BillShock".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BillShock(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),

                                          );


                                        }
                                        if(litemsFirst[index].name=="billingDetailsView.BillingDetails".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BillingDetails(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),

                                          );


                                        }
                                        if(litemsFirst[index].name=="adjustmentLogsViews.AdjustmentLOG".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AdjustmentLogs(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),

                                          );


                                        }
                                        if(litemsFirst[index].name=="OnlineChargingValuesViews.OnlineChargingvalues".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OnlineChargingValues(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),

                                          );


                                        }
                                        if(litemsFirst[index].name=="SubscriberView.PresetRisk".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => PresetRisk(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),

                                          );


                                        }
                                        if(litemsFirst[index].name=="PromotionsView.PromotionsDetails".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Promotions(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),

                                          );


                                        }
                                        if(litemsFirst[index].name=="UnbilledView.Unbilled".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => Unbilled(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),
                                          );


                                        }
                                        if(litemsFirst[index].name=="Bline Ledger"){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => BlineLedger(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                                            ),

                                          );


                                        }
                                        if(litemsFirst[index].name=="SubscriberList.Subscriber_List".tr().toString()){

                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => SubscriberList(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
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
                  )),
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

  Future<bool> onWillPop() async {
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
    return BlocListener<SearchCriteriaBloc, SearchCriteriaState>(
    listener: (context, state) {
    if(state is SearchCriteriaErrorState ) {
    showAlertDialogError(context,state.arabicMessage,state.englishMessage);

    }
    if (state is SearchCriteriaSuccessState) {

      setState(() {
        data=state.data;
          msisdn=state.msisdn;
          customerNumber=state.customerNumber;

      });
      print("DATA DATA DATA");
      print(state.data);


    }
    },child:WillPopScope(
        onWillPop: onWillPop,
        child: GestureDetector(
          onTap: ()=>FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Color(0xFF392156),
              title: Text("SubscriberView.Subscriber360View".tr().toString()),
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
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



              new Padding(padding: const EdgeInsets.all(10.0),

                child: new Container(
                    height: 150.0,
                    width: 30.0,
                    child: new GestureDetector(
                      onTap: () {
                        ClientMessages.length ==0?  showToast(  EasyLocalization.of(context).locale == Locale("en", "US")
                            ? messageEn
                            : messageAr,
                            context: context,
                            animation: StyledToastAnimation.scale,
                            fullWidth: true):

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SubscriberClientMessages(PermessionCorporate, role,searchID,searchValue,customerNumber,msisdn,data,searchCraretia),
                          ),

                        );
                      },

                      child: new Stack(

                        children: <Widget>[
                          new IconButton(icon: new Icon(Icons.email_outlined,
                            color: Colors.white,),
                            onPressed: null,
                          ),
                          ClientMessages.length ==0 ? new Container() :
                          new Positioned(

                              child: new Stack(
                                children: <Widget>[
                                  new Icon(
                                      Icons.brightness_1,
                                      size: 20.0, color: Color(0xffFB0404)),
                                  new Positioned(
                                      top: 1.0,
                                      right: 1.0,
                                      left: 1.0,
                                      bottom: 1.0,
                                      child: new Center(
                                        child: new Text(
                                          ClientMessages.length.toString(),
                                          style: new TextStyle(
                                              color: Colors.white,
                                              fontSize: 11.0,
                                              fontWeight: FontWeight.w500
                                          ),
                                        ),
                                      )),


                                ],
                              )),

                        ],
                      ),
                    )
                )

                ,),

                IconButton(
                  icon:  Icon(Icons.more_vert,color: Colors.white,),
                  onPressed:(){
                    _showMoreOptionDialog();

                  }  ,
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
                ? ListView(
                    shrinkWrap: true,
                    physics: ClampingScrollPhysics(),
                    padding: EdgeInsets.only(top: 8, left: 0, right: 0),
                    children: [
                      ///////////////////////////////////First Content//////////////////////////////////////////////////////////
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
                                    Text(
                                      this.data[0]['customerName'],
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
                                      this.data[0]['msisdn'],
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

                      ///////////////////////////////////End First Content//////////////////////////////////////////////////////////

                      ///////////////////////////////////Second Content//////////////////////////////////////////////////////////
            SingleChildScrollView(
                child: Column(
                  children: [
                    //////////////////////// Befor click Button Subscriber 369 view/////////////////////////////////////

                    Container(
                        color: Colors.white,
                        width: double.infinity,
                        padding: EdgeInsets.only(left: 26, right: 26,bottom:20),
                        // margin: EdgeInsets.all(12),
                        margin: EdgeInsets.only(bottom: 5),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [

                              this.data[0]['highestCustomerID']==null?Container(): Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.AccountNumber".tr().toString(),
                                ),
                              ),

                              this.data[0]['highestCustomerID']==null?Container(): Text(
                                this.data[0]['highestCustomerID']==''?'-':this.data[0]['highestCustomerID'].length==0?'-':this.data[0]['highestCustomerID'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 14.0,
                                ),
                              ),

                              this.data[0]['contractStatus']==null?Container(): Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.SubscriberStatus"
                                      .tr()
                                      .toString(),
                                ),
                              ),
                              this.data[0]['contractStatus']==null?Container():Text(
                                this.data[0]['contractStatus']==''?'-':this.data[0]['contractStatus'].length==0?'-':this.data[0]['contractStatus'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: this.data[0]['contractStatus'] =="Active"?Colors.green:Colors.yellow,
                                  fontSize: 14.0,
                                ),
                              ),

                              this.data[0]['customerName']==null?Container():  Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.username".tr().toString(),
                                ),
                              ),

                              this.data[0]['customerName']==null?Container(): Text(
                                this.data[0]['customerName']==''?'-': this.data[0]['customerName'].length==0?'-': this.data[0]['customerName'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ),

                              this.data[0]['activeDate']==null?Container():  Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.ActivationDate".tr().toString(),
                                ),
                              ),

                              this.data[0]['activeDate']==null?Container(): Text(
                                  this.data[0]['activeDate']==''?'-':this.data[0]['activeDate'].toString().substring(0,this.data[0]['activeDate'].indexOf(' ')),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 14.0,
                                ),
                              ),


                              this.data[0]['packageNameAr']==null?Container():  Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.PackageDescription"
                                      .tr()
                                      .toString(),
                                ),
                              ),

                               EasyLocalization.of(context).locale == Locale("en", "US")?
                               this.data[0]['packageNameAr']==null?Container():  Text(
                                  this.data[0]['packageName']==null?'-':this.data[0]['packageName'],

                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14.0,
                                ),
                              ):
                               this.data[0]['packageNameAr']==null?Container(): Text(
                                  this.data[0]['packageNameAr']==''?'-':this.data[0]['packageNameAr'],

                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14.0,
                              ),
                            ),

                              this.data[0]['pukNumber']==null?Container(): Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.PUKNumber".tr().toString(),
                                ),
                              ),

                              this.data[0]['pukNumber']==null?Container():    Text(
                                this.data[0]['pukNumber']==''?'-': this.data[0]['pukNumber'].length==0?'-':this.data[0]['pukNumber'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 14.0,
                                ),
                              ),

                              this.data[0]['sim']==null?Container():Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.SimNumber".tr().toString()
                                ),
                              ),

                              this.data[0]['sim']==null?Container(): Text(
                                this.data[0]['sim']==''?'-':this.data[0]['sim'].length==0?'-':this.data[0]['sim'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 14.0,
                                ),
                              ),


                              this.data[0]['deviceType']==null?Container(): Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.DeviceType".tr().toString(),
                                ),
                              ),

                              this.data[0]['deviceType']==null?Container():Text(
                                this.data[0]['deviceType']==''? '-': this.data[0]['deviceType'].length==0?'-':this.data[0]['deviceType'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 14.0,
                                ),
                              ),


                              this.data[0]['blineCreditBalance']==null?Container():   Padding(
                                padding: const EdgeInsets.only(top:20.0,bottom: 1),
                                child: Text(
                                  "SubscriberView.BlineCreditBalance".tr().toString(),
                                ),
                              ),

                              this.data[0]['blineCreditBalance']==null?Container():Text(
                                  this.data[0]['blineCreditBalance']==''?'-': this.data[0]['blineCreditBalance'].toString(),
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,

                                  fontSize: 14.0,
                                ),
                              ),








                            ])),



                  ])),

                      ///////////////////////////////////End Second Content//////////////////////////////////////////////////////////
                    ],
                  )
                : Center(
                    child: Text(role),
                  ),
         /*   floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Dashboard(),
                  ),
                );
              },
              backgroundColor: Color(0xFF392156),
              child: const Icon(Icons.dashboard),
            ),*/
          ),

        )));
  }
}
