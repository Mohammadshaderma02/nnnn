import 'dart:convert';
import 'dart:io';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:sales_app/Views/HomeScreens/ZainOutdoorHeads/AgentsDetails.dart';
import 'package:sales_app/Views/HomeScreens/ZainOutdoorHeads/Settings/MainSetting.dart';
import 'package:sales_app/Views/ReusableComponents/appBar.dart';
import 'package:sales_app/blocs/Login/logout_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import '../../../Shared/BaseUrl.dart';
import '../../../blocs/Login/logout_bloc.dart';
import '../../../blocs/Login/logout_events.dart';
import '../../LoginScreens/SignInScreen.dart';
import '../Subdealer/Menu/Recontracting/Recontracting.dart';

class ZainOutdoorHeads_Dashboard extends StatefulWidget {
  var PermessionZainOutdoorHeads=[];
  var role;
  var outDoorUserName;
  ZainOutdoorHeads_Dashboard({this.PermessionZainOutdoorHeads,this.role,this.outDoorUserName});
  @override
  _ZainOutdoorHeads_DashboardState createState() => _ZainOutdoorHeads_DashboardState(this.PermessionZainOutdoorHeads,this.role,this.outDoorUserName);
}

APP_URLS FirstPart = new APP_URLS();

class _ZainOutdoorHeads_DashboardState extends State<ZainOutdoorHeads_Dashboard> {

  /***********************************************************************************************************************/
  /*                                             New Cycle Dashboard for Zain Heads                                   */
  /*                                                    created on 15-Dec-2024                                           */
  /***********************************************************************************************************************/
  bool isLoading =false;
  bool emtyResult=false;
  bool emtyResultAgent=false;
  String statusReult;

  bool click_Reporting=false;
  bool click_SearchAgint=false;



  int gsm=0;
  int mbb=0;
  int ftth=0;
  int pretopost=0;
  int activeMember=0;

  var Agent_options = [];
  List<Map<String, dynamic>> filteredAgents = [];
  var bestThree = [];
  bool emptySelectedAgent=false;
  List<String> selectAgents = [];


  List selectMarketType=[{"type":"FTTH"},{"type":"MBB"},{"type":"GSM"},];
  var defultSelectedType;
  int marketID;
  /*................................................From Date Variables.................................................*/
  TextEditingController fromDate = TextEditingController();
  bool emptyFromDate=false;
  DateTime from_Date = DateTime.now();

  /*....................................................................................................................*/

  /*................................................To Date Variables...................................................*/
  TextEditingController toDate = TextEditingController();
  bool emptyToDate=false;
  DateTime to_Date = DateTime.now();



  /*....................................................................................................................*/

  /***********************************************************************************************************************/
  /*                                          End New Cycle Dashboard for Zain Heads                                  */
  /***********************************************************************************************************************/

  Response response;


  var PermessionZainOutdoorHeads = [];
  var role;
  var outDoorUserName;

  DateTime backButtonPressedTime;
  LogoutBloc logoutBloc;


  _ZainOutdoorHeads_DashboardState(this.PermessionZainOutdoorHeads, this.role, this.outDoorUserName);

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

  void initState() {
    print("I am in PermessionZainOutdoorHeads");
    print("PermessionZainOutdoorHeads");
    print(this.PermessionZainOutdoorHeads);
    print("this.outDoorUserName");
    print(this.outDoorUserName);

    logoutBloc = BlocProvider.of<LogoutBloc>(context);
    getOutDoorUsers_API();

    getMainTeamMemberDetails_API();

    super.initState();
    getPrefs();
  }

  getPrefs() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      PermessionZainOutdoorHeads=  prefs.getStringList('PermessionZainOutdoorHeads');
    });

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

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization
            .of(context)
            .locale == Locale("en", "US")
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
            Navigator.pop(context, true);
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
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  /***********************************************************************************************************************/
  /*                                             New Cycle Dashboard for Zain Heads                                   */
  /*                                                    created on 15-Dec-2024                                           */
  /***********************************************************************************************************************/

  /**1.Wellcome Username_________________________________________________________________________________________________*/
  Widget build_UserName()  {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap:  () async {
              setState(() {

              });
            },
            child: Container(
              margin:EdgeInsets.only(left:8, right: 8,top: 10,bottom: 0) ,
              padding: EdgeInsets.only(left: 20, right: 10,top: 15,bottom: 10),
              width: double.infinity,
              decoration: BoxDecoration(
                color:Color(0xFFF4F1F5),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xFFF4F1F5)), // Specify your border color here


              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'Hello, '+ outDoorUserName
                      : "أهلا، "+outDoorUserName,
                    style: TextStyle(
                      color: Color(0xFF212020),
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),),
                  SizedBox(height: 5,),
                  Text( EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'You have full main information about this system.'
                      : "لديك المعلومات الرئيسية الكاملة حول هذا النظام.",
                    style: TextStyle(
                        color: Color(0xFF212020),
                        fontSize: 12,
                        fontWeight: FontWeight.normal
                    ),),
                ],
              ),
            ),
          )
        ]);
  }

  Widget build_listAgentTitle()  {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          GestureDetector(
            onTap:  () async {
              setState(() {

              });
            },
            child: Container(
              margin:EdgeInsets.only(left:10, right: 10,top: 8,bottom: 8) ,
              // padding: EdgeInsets.only(left: 20, right: 10,top: 15,bottom: 10),
              width: double.infinity,
              //height: 65,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.white), // Specify your border color here

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        EasyLocalization.of(context).locale ==
                            Locale("en", "US")
                            ? 'List of Agents'
                            : "قائمة الوكلاء",
                        style: TextStyle(
                          color: Color(0xff11120e),
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ]);

  }


  /*Main Bord_________________________________________________________________________________________________*/
  Widget build_TopPerformers() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              // Handle tap action
            });
          },
          child: Container(
              margin:EdgeInsets.only(left:8, right: 8,top: 10,bottom: 0) ,
              padding: EdgeInsets.all(15),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Color(0xFF006494),
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xFF006494)),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // First Container with Icon
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.brightness_high,
                          color: Colors.white,
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 15), // Add spacing between the icon and text

                      // Second Container with Column of Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? 'Top 3 Performers'
                                  : "أفضل 3 أداءً",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 12),
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US")
                                  ? 'Based on total count of sales for an agent.'
                                  : "أفضل 3 أداءً بناءً على إجمالي عدد المبيعات للوكيل.",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 10),
                          ],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // First Container with Icon
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          //  color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.brightness_high,
                          color: Color(0xFF006494),
                          size: 30,
                        ),
                      ),
                      SizedBox(width: 15), // Add spacing between the icon and text

                      // Second Container with Column of Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 10),
                            bestThree.length==0?
                            Text("No agents found",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                                :
                              ListView.builder(
                              shrinkWrap: true,
                              itemCount: bestThree.length,
                              itemBuilder: (BuildContext context, int index){
                              return  Text("-  "+bestThree[index]["name"],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              );})


                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              )
          ),
        ),
      ],
    );
  }

  Widget build_ActiveAgents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              // Handle tap action
            });
          },
          child: Container(
            margin:EdgeInsets.only(left:8, right: 8,top: 10,bottom: 0) ,
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF361044),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Color(0xFF361044)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First Container with Icon
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.people_alt,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 15), // Add spacing between the icon and text

                // Second Container with Column of Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Active Agents'
                            : "الوكلاء النشطون",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? activeMember.toString()
                            : activeMember.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Number of agents currently active under the head'
                            : "عدد العملاء النشطين حاليًا تحت المسؤول",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget build_SearchAgent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            if(click_SearchAgint==false){
              setState(() {
                click_SearchAgint=true;
                click_Reporting=false;
                emtyResult=false;
              });
            }
            else{
              setState(() {
                click_SearchAgint=false;
                click_Reporting=false;
                emtyResult=false;
              });
            }
          },
          child: Container(
            margin:EdgeInsets.only(left:8, right: 8,top: 10,bottom: 0) ,
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF004a4b),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Color(0xFF004a4b)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First Container with Icon
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.search,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 15), // Add spacing between the icon and text

                // Second Container with Column of Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text( EasyLocalization.of(context).locale == Locale("en", "US")
                          ? 'Search Agents'
                          : "البحث عن وكلاء",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text( EasyLocalization.of(context).locale == Locale("en", "US")
                          ? 'Search outdoor agents’ names'
                          : "ابحث عن أسماء الوكلاء الخارجيين",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    click_SearchAgint==true?Icons.keyboard_arrow_down_outlined: Icons.arrow_forward_ios_outlined,
                    color: Colors.white,
                    size: 14,
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }


  /**2.List of Agent_______________________________________________________________________________________________________*/
 /* Widget build_ListAgents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () async {

          },
          child: Agent_options.length==0?
                Text("No agents found",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  ),
              ):ListView.builder(
          shrinkWrap: true,
           itemCount: Agent_options.length,
          itemBuilder: (BuildContext context, int index){
            return  Container(
              margin:EdgeInsets.only(left:8, right: 8,top: 10,bottom: 0) ,
              padding: EdgeInsets.all(8),
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Color(0xFF5e5e5e)),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // First Container with Icon
                  Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person,
                      color: Color(0xFF5e5e5e),
                      size: 18,
                    ),
                  ),
                  SizedBox(width: 15), // Add spacing between the icon and text

                  // Second Container with Column of Text
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(Agent_options[index]["userName"],
                          style: TextStyle(
                            color: Color(0xFF5e5e5e),
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                      ],
                    ),
                  ),

                  Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.0),
                      shape: BoxShape.circle,
                    ),
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          emtyResult=false;
                        });
                      //  Agent_options[index]["userName"]
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AgentsDetails(PermessionZainOutdoorHeads:this.PermessionZainOutdoorHeads, role:this.role,outDoorUserName: Agent_options[index]["userName"],AgentID:Agent_options[index]["id"]),
                          ),
                        );
                      },
                      child: Icon(
                        Icons.arrow_forward_ios_outlined,
                        color: Color(0xFF5e5e5e),
                        size: 14,
                      ),
                    ),
                  ),

                ],
              ),
            );
    })


        ),
      ],
    );
  }*/

  Widget build_ListAgents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            // Your onTap logic here
          },
          child: filteredAgents.isEmpty
              ? Text(
            "No agents found",
            style: TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          )
              : ListView.builder(
            shrinkWrap: true,
            itemCount: filteredAgents.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: EdgeInsets.only(left: 8, right: 8, top: 10, bottom: 0),
                padding: EdgeInsets.all(8),
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5),
                  border: Border.all(color: Color(0xFF5e5e5e)),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // First Container with Icon
                    Container(
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.person,
                        color: Color(0xFF5e5e5e),
                        size: 18,
                      ),
                    ),
                    SizedBox(width: 15), // Add spacing between the icon and text

                    // Second Container with Column of Text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            filteredAgents[index]["userName"],
                            style: TextStyle(
                              color: Color(0xFF5e5e5e),
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),

                    Container(
                      padding: EdgeInsets.all(0),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.0),
                        shape: BoxShape.circle,
                      ),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            emtyResult = false;
                          });
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AgentsDetails(
                                PermessionZainOutdoorHeads: this.PermessionZainOutdoorHeads,
                                role: this.role,
                                outDoorUserName: filteredAgents[index]["userName"],
                                AgentID: filteredAgents[index]["id"],
                              ),
                            ),
                          );
                        },
                        child: Icon(
                          Icons.arrow_forward_ios_outlined,
                          color: Color(0xFF5e5e5e),
                          size: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }


  /*....................................................................................................................*/
  /*...................................................API For Filtration..............................................*/

 /* void getOutDoorUsers_API()async{
    setState(() {
      gsm=0;
      mbb=0;
      ftth=0;
      pretopost=0;
      emtyResult=false;
      isLoading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/GetOutDoorUsers";
    final Uri url = Uri.parse(apiArea);
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    print(statusCode);

    if (statusCode == 401){
      setState(() {
        isLoading=false;
      });
      _Unauthorized(context);
    }

    if (statusCode == 200) {

      setState(() {
        isLoading=false;
      });
      var result = json.decode(response.body);
      print(result);

      if( result["status"]==0){
        if(result["data"] != null){
          setState(() {
            Agent_options=result["data"];
          });

          print("...........................GetAgentUsers..............................");
          print(result["data"]);
          print("...........................GetAgentUsers..............................");
        }

      }
      else{
        setState(() {
          statusReult=EasyLocalization.of(context).locale == Locale("en", "US")
              ? "No data found to view agent"
              : "لم يتم العثور على بيانات لعرض الوكلاء";
          isLoading=false;
          emtyResult=true;
        });

      }

    }else{
      setState(() {
        statusReult=EasyLocalization.of(context).locale == Locale("en", "US")
            ?statusCode.toString()
            : statusCode.toString();

        emtyResult=true;
        isLoading=false;
      });
    }
  }*/

  void getOutDoorUsers_API() async {
    setState(() {
      gsm = 0;
      mbb = 0;
      ftth = 0;
      pretopost = 0;
      emtyResult = false;
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/GetOutDoorUsers";
    final Uri url = Uri.parse(apiArea);
    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    print(statusCode);

    if (statusCode == 401) {
      setState(() {
        isLoading = false;
      });
      _Unauthorized(context);
    }

    if (statusCode == 200) {
      setState(() {
        isLoading = false;
      });
      var result = json.decode(response.body);
      print(result);

      if (result["status"] == 0) {
        if (result["data"] != null) {
          setState(() {
            // Cast the data to List<Map<String, dynamic>>
            Agent_options = List<Map<String, dynamic>>.from(result["data"]);
            filteredAgents=List<Map<String, dynamic>>.from(result["data"]);
          });

          print("...........................GetAgentUsers..............................");
          print(Agent_options);
          print("...........................GetAgentUsers..............................");
        }
      } else {
        setState(() {
          statusReult = EasyLocalization.of(context).locale == Locale("en", "US")
              ? "No data found to view agent"
              : "لم يتم العثور على بيانات لعرض الوكلاء";
          isLoading = false;
          emtyResult = true;
        });
      }
    } else {
      setState(() {
        statusReult = EasyLocalization.of(context).locale == Locale("en", "US")
            ? statusCode.toString()
            : statusCode.toString();

        emtyResult = true;
        isLoading = false;
      });
    }
  }


  Widget buildSearchOutdoorAgents() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       Container(
         margin: EdgeInsets.only(left: 10,right: 10),
         child:  RichText(
           text: TextSpan(
             text: EasyLocalization.of(context).locale == Locale("en", "US")
                 ? "Search Outdoor Agents"
                 : "البحث عن وكلاء خارجيين",

             style: TextStyle(
               color: Color(0xff11120e),
               fontSize: 14,
               fontWeight: FontWeight.w500,
             ),
             children: <TextSpan>[
               TextSpan(
                 text: ' * ',
                 style: TextStyle(
                   color: Colors.white,
                   fontSize: 14,
                   fontWeight: FontWeight.normal,
                 ),
               ),
             ],
           ),
         ),
       ),
        SizedBox(height: 10),
        Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          padding: EdgeInsets.only(left: 10, right: 5),
          decoration: BoxDecoration(
            color:  Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: emptySelectedAgent ? Color(0xFFB10000) : Color(0xFFD1D7E0),
            ),
          ),
          child: DropdownSearch<String>.multiSelection(
           //enabled: selectedCommissionType != "All", // Disable dropdown when "All" is selected

            popupProps: PopupPropsMultiSelection.menu(
              showSelectedItems: true,
              showSearchBox: true,
              searchFieldProps: TextFieldProps(
                cursorColor: Color(0xFF392156),
              ),
            ),

            items: Agent_options.map<String>((item) =>
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? item['userName']
                : item['userName']
            ).toList(),

            dropdownDecoratorProps: DropDownDecoratorProps(
              dropdownSearchDecoration: InputDecoration(
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD1D7E0)),
                ),
                hintText: EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Select agent"
                    : "اختر العميل",
                hintStyle: TextStyle(
                  color: Color(0xFFD1D7E0),
                  fontSize: 14,
                ),
              ),
            ),

            // Handle multiple selected values

            onChanged: (List<String> selectedValues) {
           /*   setState(() {
                selectAgents = selectedValues;


              });*/
              setState(() {
                selectAgents = selectedValues;
                if(selectAgents.length==0){
                  filteredAgents=Agent_options;
                }
                if(selectAgents.length!=0){
                  // Filter the agents based on selected values
                  filteredAgents = Agent_options.where((agent) {
                    return selectedValues.contains(agent['userName']);
                  }).toList();
                }


              });

            },
            selectedItems: selectAgents,

          ),
        ),


      ],
    );
  }


  void getMainTeamMemberDetails_API()async{
    setState(() {

      emtyResult=false;
      isLoading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/GetTeamMemberDetails";
    final Uri url = Uri.parse(apiArea);
    print(url);
    Map body ={
      "fromDate": null,
      "toDate": null
    };
    print(body);
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;

    print("____________________________________________");
    print(statusCode);
    print("____________________________________________");
    if (statusCode == 200) {

      setState(() {
        isLoading=false;
      });
      var result = json.decode(response.body);
      print(result);

      if( result["status"]==0){
        if(result["data"] != null){
          setState(() {
            activeMember=result["data"]["activeMember"];

            bestThree=result["data"]["bestThree"] != null?result["data"]["bestThree"]:[];

          });

          print(".......................getMainTeamMemberDetails_API..........................");
          print(result["data"]);
          print("...........................getMainTeamMemberDetails_API......................");
        }

      }
      else{
        print(url);
        print(result);
        setState(() {
          statusReult=EasyLocalization.of(context).locale == Locale("en", "US")
              ? result["message"]
              : result["messageAr"];
          isLoading=false;
          emtyResult=true;
        });

      }

    }else{
      setState(() {
        statusReult=EasyLocalization.of(context).locale == Locale("en", "US")
            ?statusCode.toString()
            : statusCode.toString();

        emtyResult=true;
        isLoading=false;
      });
    }
  }
  /*....................................................................................................................*/
  /*...................................................API error response..............................................*/
  Widget buildErorrStatus(){
    return Container(
      width: double.infinity, // Make the container expand to fill available horizontal space.
      margin: EdgeInsets.only(left: 12,right: 12,bottom: 0,top: 0),
      padding: EdgeInsets.only(left: 10,right: 10,top: 15,bottom: 15),// Adjust padding as needed.
      decoration: BoxDecoration(
        color: Color(0xFFffe5e5),
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        border: Border.all(
          color: Color(0xFFcc0000), // Set the color of the border
          width: 1.0, // Set the width of the border
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children horizontally with space between them
        children: [
          Text(
            statusReult,
            style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal, color:Color(0xFFcc0000)),
          ),

        ],
      ),
    );
  }

  /***********************************************************************************************************************/
  /*                                          End New Cycle Dashboard for Zain Heads                                  */
  /***********************************************************************************************************************/

  Future<bool> _onWillPop() async {
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

  /**3.Filtration ______________________________________________________________________________________________________*/
  Widget build_Reporting() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        GestureDetector(
          onTap: () async {
            setState(() {
              emtyResult = false;
            });
            if(click_Reporting==false){
              setState(() {
                click_Reporting=true;
                click_SearchAgint=false;
              });
            }
            else{
              setState(() {
                click_Reporting=false;
                click_SearchAgint=false;
              });
            }

          },
          child: Container(
            margin:EdgeInsets.only(left:8, right: 8,top: 10,bottom: 0) ,
            padding: EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(
              color: Color(0xFF9a0658),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Color(0xFF9a0658)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // First Container with Icon
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.article_rounded,
                    color: Colors.white,
                    size: 30,
                  ),
                ),
                SizedBox(width: 15), // Add spacing between the icon and text

                // Second Container with Column of Text
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Text( EasyLocalization.of(context).locale == Locale("en", "US")
                          ? 'Reporting'
                          : "التقارير",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 10,),
                      Text( EasyLocalization.of(context).locale == Locale("en", "US")
                          ? 'Export the report as a excel file'
                          : "تصدير التقرير كملف excel",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                    ],
                  ),
                ),

                Container(
                  padding: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.0),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    click_Reporting==true?Icons.keyboard_arrow_down_outlined: Icons.arrow_forward_ios_outlined,

                    color: Colors.white,
                    size: 14,
                  ),
                ),

              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget build_FilterButton(){
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 10,),
          GestureDetector(
            onTap:  () async {

              if(fromDate.text==""){
                setState(() {
                  emptyFromDate=true;
                });
              }
              if(fromDate.text!=""){
                setState(() {
                  emptyFromDate=false;
                });
              }
              if(toDate.text==""){
                setState(() {
                  emptyToDate=true;
                });
              }
              if(toDate.text!=""){
                setState(() {
                  emptyToDate=false;
                });
              }
              if(fromDate.text!="" && toDate.text!=""){
                setState(() {
                  emptyFromDate=false;
                  emptyToDate=false;

                  emtyResult = false;
                });
                exportExcel_API();
              }
            },
            child: Container(
              margin: EdgeInsets.only(left:10, right: 10,),
              width: double.infinity,
              height: 40,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color:Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(color:Color(0xFF4f2565)),
              ),
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? 'Export excel'
                        : "تصدير ملف excel",
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      letterSpacing: 0,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),

                ],
              ),

            ),
          ),
          SizedBox(height: 30,)
        ]);

  }

  /*....................................................................................................................*/
  /*.........................................................Export Button..............................................*/
//Disable on 31 Dec
 /*Future<void> exportExcel_API() async {
    setState(() {
      emtyResult = false;
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/OutDoorMembersExcelReport";
    final Uri url = Uri.parse(apiArea);

    Map body = {
      "fromDate": fromDate.text,
      "toDate": toDate.text,
      "market": marketID,
      "agentName": null,
    };

    print(body);

    try {
      final response = await http.post(
        url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken") ?? "",
        },
        body: json.encode(body),
      );

      int statusCode = response.statusCode;
      print(statusCode);

      if (statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        var result = json.decode(response.body);

        if (result["status"] == 0) {
          if (result["data"] == null || result["data"].isEmpty) {
            setState(() {
              statusReult = EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "No data found to download excel file"
                  : "لم يتم العثور على بيانات لتنزيل ملف excel";
              emtyResult = true;
            });
          } else {


            try{
              // Decode the Base64 string into bytes
              final bytes = base64Decode(result["data"]);


              // Get the directory to save the file
              final directory = await getExternalStorageDirectory();
              if (directory == null) throw Exception("No directory available");

              // Define file path (e.g., saving it as 'sample.xlsx')
              final filePath = "${directory.path}/sample.xlsx";

              // Write the decoded bytes to a file
              final file = File(filePath);
              await file.writeAsBytes(bytes);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download completed: $filePath')),
              );

              // Open the downloaded file
              OpenFile.open(filePath);
            }
            catch(e){

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download failed: $e')),
              );
            }

          }
        } else {
          setState(() {
            statusReult = EasyLocalization.of(context).locale == Locale("en", "US")
                ? result["message"]
                : result["messageAr"];
            emtyResult = true;
          });
        }
      } else {
        setState(() {
          statusReult = "Error: $statusCode";
          emtyResult = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        statusReult = "An error occurred: $e";
        emtyResult = true;
        isLoading = false;
      });
      print("Error: $e");
    }
  }*/

  Future<void> exportExcel_API() async {
    setState(() {
      emtyResult = false;
      isLoading = true;
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/OutDoorMembersExcelReport";
    final Uri url = Uri.parse(apiArea);

    Map body = {
      "fromDate": fromDate.text,
      "toDate": toDate.text,
      "market": marketID,
      "agentName": null,
    };

    print(body);

    try {
      final response = await http.post(
        url,
        headers: {
          "content-type": "application/json",
          "Authorization": prefs.getString("accessToken") ?? "",
        },
        body: json.encode(body),
      );

      int statusCode = response.statusCode;
      print(statusCode);

      if (statusCode == 200) {
        setState(() {
          isLoading = false;
        });

        var result = json.decode(response.body);

        if (result["status"] == 0) {
          if (result["data"] == null || result["data"].isEmpty) {
            setState(() {
              statusReult = EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "No data found to download excel file"
                  : "لم يتم العثور على بيانات لتنزيل ملف excel";
              emtyResult = true;
            });
          } else {
            try {
              // Decode the Base64 string into bytes
              final bytes = base64Decode(result["data"]);

              // Get the directory to save the file
              Directory directory;
              if (Platform.isAndroid) {
                directory = await getExternalStorageDirectory();
              } else if (Platform.isIOS) {
                directory = await getApplicationDocumentsDirectory();
              }

              if (directory == null) throw Exception("No directory available");

              // Define file path (e.g., saving it as 'sample.xlsx')
              final filePath = "${directory.path}/sample.xlsx";

              // Write the decoded bytes to a file
              final file = File(filePath);
              await file.writeAsBytes(bytes);

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download completed: $filePath')),
              );

              // Open the downloaded file
              OpenFile.open(filePath);
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Download failed: $e')),
              );
            }
          }
        } else {
          setState(() {
            statusReult = EasyLocalization.of(context).locale == Locale("en", "US")
                ? result["message"]
                : result["messageAr"];
            emtyResult = true;
          });
        }
      } else {
        setState(() {
          statusReult = "Error: $statusCode";
          emtyResult = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        statusReult = "An error occurred: $e";
        emtyResult = true;
        isLoading = false;
      });
      print("Error: $e");
    }
  }

  /*....................................................................................................................*/
  /*...................................................From Date Functions..............................................*/
  Widget buildFromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15,left: 10 ,right: 10),
          child:  RichText(
            text: TextSpan(
              text:  EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'From Date'
                  : "من تاريخ",
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
        ),
        Container(
          margin: EdgeInsets.only(top: 0,left: 10 ,right: 10),
          alignment: Alignment.centerLeft,
          height: 60,
          child: TextField(
            controller: fromDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder: emptyFromDate == true
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(12),
              suffixIcon: Container(
                child: IconButton(
                    icon: Icon(Icons.calendar_month),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF4f2565), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary:
                                  Color(0xFF4f2565), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((fromData) => {
                        setState(() {
                          from_Date = fromData;
                          fromDate.text =
                          "${fromData.year.toString()}-${fromData.month.toString().padLeft(2, '0')}-${fromData.day.toString().padLeft(2, '0')}";
                        }),
                      });
                    }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  /*....................................................................................................................*/
  /*....................................................To Date Functions...............................................*/
  Widget buildToDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15,left: 10 ,right: 10),
          child:  RichText(
            text: TextSpan(
              text:  EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'To Date'
                  : "إلى تاريخ",
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.w500,
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
        ),
        Container(
          margin: EdgeInsets.only(top: 0,left: 10 ,right: 10),
          alignment: Alignment.centerLeft,
          height: 60,
          child: TextField(
            controller: toDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder: emptyToDate == true
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
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(12),
              suffixIcon: Container(
                child: IconButton(
                    icon: Icon(Icons.calendar_month),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF4f2565), // header background color
                                onPrimary: Colors.white, // header text color
                                onSurface: Colors.black, // body text color
                              ),
                              textButtonTheme: TextButtonThemeData(
                                style: TextButton.styleFrom(
                                  primary:
                                  Color(0xFF4f2565), // button text color
                                ),
                              ),
                            ),
                            child: child,
                          );
                        },
                      ).then((fromData) => {
                        setState(() {
                          to_Date = fromData;
                          toDate.text =
                          "${fromData.year.toString()}-${fromData.month.toString().padLeft(2, '0')}-${fromData.day.toString().padLeft(2, '0')}";
                        }),
                      });
                    }),
              ),
              hintText: "Reports.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }

  /**2.Market Type_______________________________________________________________________________________________________*/
  Widget buildMarketType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(left: 10,right: 10),
          child: RichText(
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
        ),
        SizedBox(height: 10),
        Container(
            margin: EdgeInsets.only(left: 10,right: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                //color: Color(0xFFB10000), red color
                color: Color(0xFFD1D7E0),
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
                      setState(() {
                        marketID=10;
                      });

                    }
                    if(defultSelectedType=="MBB"){
                      setState(() {
                        marketID=2;
                      });

                    }
                    if(defultSelectedType=="GSM"){
                      setState(() {
                        marketID=1;
                      });
                    }
                    print(marketID);
                  },
                ),
              ),
            )),

      ],
    );
  }



  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              centerTitle: false,
              title: Text( EasyLocalization
                  .of(context)
                  .locale ==
                  Locale("en", "US")?"Dashboard":"الرئيسية",),
              automaticallyImplyLeading: false,
              actions: <Widget>[
                IconButton(
                  icon: const Icon(Icons.settings),
                  tooltip: 'Settings',
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainSetting(PermessionZainOutdoorHeads:this.PermessionZainOutdoorHeads,role:this.role,outDoorUserName:this.outDoorUserName),
                      ),
                    );
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
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                build_UserName(),
                SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: emtyResult == true ? buildErorrStatus() : Container(),
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(child: build_Reporting()),
                  ],
                ),
                SizedBox(height: 5),
                click_Reporting==true?   Row(
                  children: <Widget>[
                    Expanded(child: buildFromDate()),
                  ],
                ):Container(),

                click_Reporting==true?  Row(
                  children: <Widget>[
                    Expanded(child: buildToDate()),
                  ],
                ):Container(),

                /*click_Reporting==true? Row(
                  children: <Widget>[
                    Expanded(child: enterAgentName()),
                  ],
                ):Container(),*/
                click_Reporting==true? SizedBox(height: 5):Container(),
                click_Reporting==true? Row(
                  children: <Widget>[
                    Expanded(child: buildMarketType()),
                  ],
                ):Container(),
                click_Reporting==true? SizedBox(height: 10):Container(),
                click_Reporting==true? Row(
                  children: <Widget>[
                    Expanded(child: build_FilterButton()),
                  ],
                ):Container(),
                Row(
                  children: <Widget>[
                    Expanded(child:  build_ActiveAgents()),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(child: build_TopPerformers()),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    Expanded(child: build_SearchAgent()),
                  ],
                ),

                click_SearchAgint==true?    SizedBox(height: 20):Container(),
                click_SearchAgint==true?  buildSearchOutdoorAgents():Container(),
                SizedBox(height: 30),
                build_listAgentTitle(),
                build_ListAgents(),
                SizedBox(height: 30),
              ],
            ),
          ),

          // Overlay layer
          if (isLoading) // Replace 'isLoading' with your actual condition
            Positioned.fill(
              child: Container(
                color: Colors.black54, // Semi-transparent background
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF4f2565),
                  ), // You can customize this widget
                ),
              ),
            ),
        ],

      ),

    );
  }

}