import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/BroadBand/BroadBand_SelectNationality.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/NationalityList.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/LineDocumentation.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_block.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_state.dart';

import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

import '../../../CustomBottomNavigationBar.dart';

class BroadBandpackage extends StatefulWidget {
  final List<dynamic> Permessions;
  var marketType;
  final String connectionTypes;

  var role;
  var outDoorUserName;
  String packageCode;
  String isParentEligible;
  bool MADA_Activat;
  BroadBandpackage({this.connectionTypes,this.Permessions,this.marketType,this.role,this.outDoorUserName,this.MADA_Activat});
  @override
  _BroadBandpackageState createState() => _BroadBandpackageState(this.connectionTypes,this.Permessions,this.marketType,this.role,this.outDoorUserName,this.MADA_Activat);
}

class _BroadBandpackageState extends State<BroadBandpackage> {

  final List<dynamic> Permessions;
  var marketType;
  final String connectionTypes;
  var role;
  var outDoorUserName;
  _BroadBandpackageState(this.connectionTypes,this.Permessions,this.marketType,this.role,this.outDoorUserName,this.MADA_Activat);
  final Dialog dialog = Dialog(elevation: 0,);
  APP_URLS urls = new APP_URLS();
  Map data = new Map();
  ScrollController scrollController = ScrollController();
  List<dynamic> UserList =[];
  bool isLoading = false;
  bool allLoaded =false;
  bool isInitLoading = true;
  bool ErrorFlag = false;
  String arabicMessage = '';
  String englishMessage ='';
  int page =1;
  var loooding;

  bool Packages_4G=false;
  bool Packages_5G = false;
  bool MADA_Activat;
//////////////////////////////////////////////////////////////
  PostpaidEligiblePackagesBlock postpaidEligiblePackages;
  PostpaidEligiblePackagesBlock postpaidEligiblePackagesBlock;

  List<dynamic> EligiblePackages =[];

  bool _simLockedEligible=false;
  bool _simUnlockedEligible =false;
  bool _isLockedFalge = false;
/////////////////////////////////////////////////////////////
  void initState() {
    print("MADA_Activat");
    print(MADA_Activat);
    print("widget.marketType");
    print(widget.marketType);

    //callApi();
    postpaidEligiblePackagesBlock = BlocProvider.of<PostpaidEligiblePackagesBlock>(context);
    //postpaidEligiblePackages.add(PostpaidEligiblePackagesSelect());
    //  postpaidEligiblePackagesBlock.add(PostpaidEligiblePackagesSelect(marketType:marketType,isMada:MADA_Activat));
    //setupScrollController(context);
    super.initState();
  }

  final msg = BlocBuilder<PostpaidEligiblePackagesBlock,
      PostpaidEligiblePackagesState>(builder: (context, state) {
    if (state is PostpaidEligiblePackagesStateLoadingState) {
      return Center(child: Container(
        padding: EdgeInsets.only(bottom: 10),
        child: CircularProgressIndicator(
          valueColor:AlwaysStoppedAnimation<Color>(Color(0xFF4F2565)),
        ),
      ));
    } else {
      return Container();
    }
  });

  void callApi () async{
    if(allLoaded){
      return ;
    }setState(() {
      isLoading=true;
    });

    var url = urls.BASE_URL+'/Postpaid/eligible-packages';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: jsonEncode({"marketType": widget.marketType,"isMada":MADA_Activat}),);
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
      var result = json.decode(response.body);
      print(result['data']);
      if(result['status']==0){
        List<dynamic> list =  result['data'];
        if(list.isNotEmpty){
          list.map((data) => UserList.add(data)).toList();
        }
        await Future.delayed(Duration(milliseconds:500 ));
        setState(() {
          isLoading=false;
          allLoaded = list.isEmpty;
          //
          // UserList =UserList;
        });
        setState(() {
          isInitLoading=false;
        });
      }else{
        setState(() {
          arabicMessage =result['messageAr'];
          englishMessage= result['message'];
          ErrorFlag=true;
        });
      }

    }
    if(statusCode==401){
      UnotherizedError();
    }

  }

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

  void _clickPackages_4G() async{
    print("_clickPackages_4G");
    setState(() {
      Packages_4G=true;
      Packages_5G=false;
      marketType="MBB";
    });
    if( Permessions.contains('05.02.01.07')==true && Packages_4G==true){
      setState(() {
        marketType="MBB";
      });
      postpaidEligiblePackagesBlock.add(PostpaidEligiblePackagesSelect(marketType:marketType,isMada:MADA_Activat));
    }

  }

  void _clickPackages_5G() async{
    print("_clickPackages_5G");
    setState(() {
      Packages_4G=false;
      Packages_5G=true;
      marketType="HOME5G";
    });

    if( Permessions.contains('05.02.01.08')==true && Packages_5G==true){
      setState(() {
        marketType="HOME5G";
      });
      postpaidEligiblePackagesBlock.add(PostpaidEligiblePackagesSelect(marketType:marketType,isMada:MADA_Activat));
    }

  }




  @override
  Widget build(BuildContext context) {
    return GestureDetector(
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
            centerTitle:false,
            title: Text(
              "Postpaid.SelectPackages".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body: Stack(
            children: [
              Column(children: [
                /*...............This Container Have Tow buttons one for 4G-Packages  and the second for 5G-Packages................*/
                Permessions.contains('05.02.01.07')==true ||  Permessions.contains('05.02.01.08')==true ?Container(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  height: 100,
                  color: Colors.white,
                  child: Row(
                    children: [
                      Permessions.contains('05.02.01.07')==true? Expanded(child: SizedBox(
                        width: 175, // <-- match_parent
                        height: 50, // <-- match-parent
                        child:SizedBox(
                          child: ElevatedButton.icon(   // <-- ElevatedButton
                            onPressed: () {
                              _clickPackages_4G();
                            },
                            style:Packages_4G==true? ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary:Color(0xFF4f2565),
                              side: BorderSide(color:Color(0xFF4f2565), width: 1),
                              shadowColor: Colors.transparent,
                            ): ElevatedButton.styleFrom(
                              primary: Colors.white,
                              onPrimary: Color(0xff636f7b),
                              side: BorderSide(color:Color(0xffe4e5eb), width: 1),
                              shadowColor: Colors.transparent,
                            ),
                            icon: Packages_4G==true?Icon(
                              Icons.check_circle,
                              size: 24.0,
                            ):Icon(
                              Icons.circle_outlined,
                              size: 24.0,
                            ),
                            label: Text(EasyLocalization.of(context).locale ==
                                Locale("en", "US") ?"4G Packages": " حزم "+"4G",style: TextStyle(fontSize: 16),),
                          ),

                        ),
                      ),):Container(),
                      Permessions.contains('05.02.01.07')==true&& Permessions.contains('05.02.01.08')==true?  SizedBox(width: 10,):Container(),
                      Permessions.contains('05.02.01.08')==true? Expanded(child: SizedBox(
                        width: 175, // <-- match_parent
                        height: 50, // <-- match-parent
                        child:SizedBox(
                          child: ElevatedButton.icon(   // <-- ElevatedButton
                            onPressed: () {
                              _clickPackages_5G();
                            },
                            style: ElevatedButton.styleFrom(
                              shadowColor: Colors.transparent,
                              primary: Colors.white,
                              onPrimary: Packages_5G==true?Color(0xFF4f2565):Color(0xff636f7b),
                              side: BorderSide(color:Packages_5G==true? Color(0xFF4f2565):Color(0xffe4e5eb), width: 1),

                            ),
                            icon: Packages_5G==true?Icon(
                              Icons.check_circle,
                              size: 24.0,
                            ):Icon(
                              Icons.circle_outlined,
                              size: 24.0,
                            ),
                            label:  Text(EasyLocalization.of(context).locale ==
                                Locale("en", "US") ?"5G Packages": " حزم "+"5G",style: TextStyle(fontSize: 16),),
                          ),
                        ),
                      ),):Container()
                    ],
                  ),
                ):Container(),
                SizedBox(height: 15),
                /*...............This Expanded Have To Lists one for 4G-Packages  and the second for 5G-Packages....................*/
                Expanded(
                    child: Container(
                        padding: EdgeInsets.only(bottom: 2),
                        child:ListView(
                            physics: ClampingScrollPhysics(),
                            shrinkWrap: true,
                            padding: EdgeInsets.only(top: 5),
                            children: <Widget>[
                              BlocBuilder<PostpaidEligiblePackagesBlock,PostpaidEligiblePackagesState>(
                                  builder: (context,state){
                                    // ignore: missing_return
                                    if(state is PostpaidEligiblePackagesStateLoadingState){
                                      return Container(
                                        padding: EdgeInsets.only(top: 10),
                                        child: Center(
                                          child: Column(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                CircularProgressIndicator(
                                                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
                                                ),SizedBox(height: 20,),
                                                Text("DashBoard_Form.loading".tr().toString(),
                                                  style: TextStyle(
                                                    color:Colors.grey,
                                                    fontSize: 16,
                                                  ),
                                                )

                                              ]
                                          ),
                                        ),
                                      );

                                    }else if(state is PostpaidEligiblePackagesStateInitState){
                                      return Container();
                                    }
                                    else if(state is PostpaidEligiblePackagesStateSuccessState && Permessions.contains('05.02.01.07')==true && Packages_4G==true){

                                      List<dynamic> test =[];
                                      test=state.data
                                          .where((element) =>
                                      element["subGroup"] == connectionTypes) .toList();

                                      // var distinctIds = ids.toSet().toList();
                                      return Container(
                                          padding: EdgeInsets.only(bottom: 8),
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemCount : test.length,
                                              itemBuilder:(context,index){
                                                return Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                      children:[
                                                        SizedBox(
                                                          height:index  !=  test.length-1 ? 50 :55,
                                                          child: ListTile(
                                                              title: Text(
                                                                EasyLocalization.of(context).locale ==
                                                                    Locale("en", "US")
                                                                    ? test[index]['descEn']
                                                                    : test[index]['descAr'],
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    letterSpacing: 0,
                                                                    color: Color(0xff11120e),
                                                                    fontWeight: FontWeight.normal),
                                                              ),
                                                              trailing:
                                                              TextButton(
                                                                child: Text(
                                                                  "Menu_Form.select".tr().toString(),
                                                                  style: TextStyle(
                                                                    color: Color(0xFF0070c9),
                                                                    letterSpacing: 0,
                                                                    fontSize: 16,
                                                                  ),
                                                                ),
                                                                onPressed: () {
                                                                  if (test[index]['simLockedEligible'] == true && test[index]['simUnlockedEligible'] == true) {
                                                                    showDialog(
                                                                      context: context,
                                                                      builder:  (BuildContext dialogContext)  {
                                                                        return StatefulBuilder(
                                                                          builder: (BuildContext context, StateSetter setState) {
                                                                            return AlertDialog(
                                                                              title: Text(
                                                                                EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                    ? "Sim Locked Eligible"
                                                                                    : "مؤهل لقفل الشريحة",
                                                                              ),
                                                                              content: SingleChildScrollView(
                                                                                child: ListBody(
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 15),
                                                                                      height: 20,
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Switch(
                                                                                            value: _simLockedEligible,
                                                                                            onChanged: (value) {
                                                                                              setState(() {
                                                                                                _simLockedEligible = true;
                                                                                                _simUnlockedEligible = false;
                                                                                                _isLockedFalge = true;
                                                                                              });
                                                                                            },
                                                                                            activeTrackColor: Color(0xFF767699),
                                                                                            activeColor: Color(0xFF392156),
                                                                                            inactiveTrackColor: Color(0xFFEBECF1),
                                                                                          ),
                                                                                          Text(
                                                                                            EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                                ? "Sim Locked"
                                                                                                : "قفل الشريحة",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xff11120e),
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 15),
                                                                                      height: 20,
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Switch(
                                                                                            value: _simUnlockedEligible,
                                                                                            onChanged: (value) {
                                                                                              setState(() {
                                                                                                _simUnlockedEligible = true;
                                                                                                _simLockedEligible = false;
                                                                                                _isLockedFalge = false;
                                                                                              });
                                                                                            },
                                                                                            activeTrackColor: Color(0xFF767699),
                                                                                            activeColor: Color(0xFF392156),
                                                                                            inactiveTrackColor: Color(0xFFEBECF1),
                                                                                          ),
                                                                                          Text(
                                                                                            EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                                ? "Sim Unlocked"
                                                                                                : "فتح الشريحة",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xff11120e),
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();

                                                                                  },
                                                                                  child: Text(
                                                                                    "Postpaid.Cancel".tr().toString(),
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF4f2565),
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    if (!_simLockedEligible && !_simUnlockedEligible) {
                                                                                      // Show a message or toast to prompt user to select one
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(
                                                                                          content: Text(
                                                                                            EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                                ? "Please select SIM Locked or SIM Unlocked"
                                                                                                : "يرجى اختيار قفل الشريحة أو فتح الشريحة",
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                      return; // Prevent closing the dialog
                                                                                    }

                                                                                    // Close the dialog and navigate if a selection is made
                                                                                    Navigator.of(dialogContext).pop();
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) => BroadBandNationalityList(
                                                                                          Permessions: Permessions,
                                                                                          role: role,
                                                                                          outDoorUserName: outDoorUserName,
                                                                                          marketType: marketType,
                                                                                          packageCode: test[index]['packageCode'],
                                                                                          isParentEligible: test[index]['isParentEligible'],
                                                                                          Packages_5G: Packages_5G,
                                                                                          simLockedEligible: test[index]['simLockedEligible'],
                                                                                          simUnlockedEligible: test[index]['simUnlockedEligible'],
                                                                                          isLockedFalge: _isLockedFalge,
                                                                                        ),
                                                                                      ),
                                                                                    );
                                                                                  },
                                                                                  child: Text(
                                                                                    "Postpaid.Next".tr().toString(),
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF4f2565),
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),


                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    );

                                                                  }
                                                                  if(test[index]['simLockedEligible'] == false && test[index]['simUnlockedEligible'] == false){
                                                                    Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                        builder: (context) => BroadBandNationalityList(
                                                                            Permessions: Permessions,
                                                                            role: role,
                                                                            outDoorUserName: outDoorUserName,
                                                                            marketType: marketType,
                                                                            packageCode: test[index]['packageCode'],
                                                                            isParentEligible: test[index]['isParentEligible'],
                                                                            Packages_5G: Packages_5G,
                                                                            simLockedEligible: test[index]['simLockedEligible'],
                                                                            simUnlockedEligible: test[index]['simUnlockedEligible'],
                                                                            isLockedFalge: _isLockedFalge
                                                                        ),
                                                                      ),
                                                                    );
                                                                  }
                                                                  if(test[index]['simLockedEligible'] == false && test[index]['simUnlockedEligible'] == true){
                                                                    showDialog(
                                                                      context: context,
                                                                      builder:  (BuildContext dialogContext)  {
                                                                        return StatefulBuilder(
                                                                          builder: (BuildContext context, StateSetter setState) {
                                                                            return AlertDialog(
                                                                              title: Text(
                                                                                EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                    ? "Sim Locked Eligible"
                                                                                    : "مؤهل لقفل الشريحة",
                                                                              ),
                                                                              content: SingleChildScrollView(
                                                                                child: ListBody(
                                                                                  children: <Widget>[

                                                                                    Container(
                                                                                      margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 15),
                                                                                      height: 20,
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Switch(
                                                                                            value: _simUnlockedEligible,
                                                                                            onChanged: (value) {
                                                                                              setState(() {
                                                                                                _simUnlockedEligible = true;
                                                                                                _simLockedEligible = false;
                                                                                                _isLockedFalge = false;
                                                                                              });
                                                                                            },
                                                                                            activeTrackColor: Color(0xFF767699),
                                                                                            activeColor: Color(0xFF392156),
                                                                                            inactiveTrackColor: Color(0xFFEBECF1),
                                                                                          ),
                                                                                          Text(
                                                                                            EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                                ? "Sim Unlocked"
                                                                                                : "فتح الشريحة",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xff11120e),
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Text(
                                                                                    "Postpaid.Cancel".tr().toString(),
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF4f2565),
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    if ( !_simUnlockedEligible) {
                                                                                      // Show a message or toast to prompt user to select one
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(
                                                                                          content: Text(
                                                                                            EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                                ? "Please select SIM Unlocked"
                                                                                                : "يرجى اختيار  فتح الشريحة",
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                      return; // Prevent closing the dialog
                                                                                    }

                                                                                    // Close the dialog and navigate if a selection is made
                                                                                    Navigator.of(dialogContext).pop();
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) => BroadBandNationalityList(
                                                                                          Permessions: Permessions,
                                                                                          role: role,
                                                                                          outDoorUserName: outDoorUserName,
                                                                                          marketType: marketType,
                                                                                          packageCode: test[index]['packageCode'],
                                                                                          isParentEligible: test[index]['isParentEligible'],
                                                                                          Packages_5G: Packages_5G,
                                                                                          simLockedEligible: test[index]['simLockedEligible'],
                                                                                          simUnlockedEligible: test[index]['simUnlockedEligible'],
                                                                                          isLockedFalge: _isLockedFalge,
                                                                                        ),
                                                                                      ),
                                                                                    );

                                                                                  },
                                                                                  child: Text(
                                                                                    "Postpaid.Next".tr().toString(),
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF4f2565),
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),


                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    );
                                                                  }
                                                                  if(test[index]['simLockedEligible'] == true && test[index]['simUnlockedEligible'] == false){
                                                                    showDialog(
                                                                      context: context,
                                                                      builder:  (BuildContext dialogContext)  {
                                                                        return StatefulBuilder(
                                                                          builder: (BuildContext context, StateSetter setState) {
                                                                            return AlertDialog(
                                                                              title: Text(
                                                                                EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                    ? "Sim Locked Eligible"
                                                                                    : "مؤهل لقفل الشريحة",
                                                                              ),
                                                                              content: SingleChildScrollView(
                                                                                child: ListBody(
                                                                                  children: <Widget>[
                                                                                    Container(
                                                                                      margin: EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 15),
                                                                                      height: 20,
                                                                                      child: Row(
                                                                                        children: <Widget>[
                                                                                          Switch(
                                                                                            value: _simLockedEligible,
                                                                                            onChanged: (value) {
                                                                                              setState(() {
                                                                                                _simLockedEligible = true;
                                                                                                _simUnlockedEligible = false;
                                                                                                _isLockedFalge = true;
                                                                                              });
                                                                                            },
                                                                                            activeTrackColor: Color(0xFF767699),
                                                                                            activeColor: Color(0xFF392156),
                                                                                            inactiveTrackColor: Color(0xFFEBECF1),
                                                                                          ),
                                                                                          Text(
                                                                                            EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                                ? "Sim Locked"
                                                                                                : "قفل الشريحة",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xff11120e),
                                                                                              fontWeight: FontWeight.bold,
                                                                                            ),
                                                                                          ),
                                                                                        ],
                                                                                      ),
                                                                                    ),

                                                                                  ],
                                                                                ),
                                                                              ),
                                                                              actions: <Widget>[
                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    Navigator.of(context).pop();
                                                                                  },
                                                                                  child: Text(
                                                                                    "Postpaid.Cancel".tr().toString(),
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF4f2565),
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),

                                                                                TextButton(
                                                                                  onPressed: () {
                                                                                    if (!_simLockedEligible ) {
                                                                                      // Show a message or toast to prompt user to select one
                                                                                      ScaffoldMessenger.of(context).showSnackBar(
                                                                                        SnackBar(
                                                                                          content: Text(
                                                                                            EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                                ? "Please select SIM Locked or SIM Unlocked"
                                                                                                : "يرجى اختيار قفل الشريحة ",
                                                                                          ),
                                                                                        ),
                                                                                      );
                                                                                      return; // Prevent closing the dialog
                                                                                    }

                                                                                    // Close the dialog and navigate if a selection is made
                                                                                    Navigator.of(dialogContext).pop();
                                                                                    Navigator.push(
                                                                                      context,
                                                                                      MaterialPageRoute(
                                                                                        builder: (context) => BroadBandNationalityList(
                                                                                          Permessions: Permessions,
                                                                                          role: role,
                                                                                          outDoorUserName: outDoorUserName,
                                                                                          marketType: marketType,
                                                                                          packageCode: test[index]['packageCode'],
                                                                                          isParentEligible: test[index]['isParentEligible'],
                                                                                          Packages_5G: Packages_5G,
                                                                                          simLockedEligible: test[index]['simLockedEligible'],
                                                                                          simUnlockedEligible: test[index]['simUnlockedEligible'],
                                                                                          isLockedFalge: _isLockedFalge,
                                                                                        ),
                                                                                      ),
                                                                                    );

                                                                                  },
                                                                                  child: Text(
                                                                                    "Postpaid.Next".tr().toString(),
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF4f2565),
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),
                                                                                ),


                                                                              ],
                                                                            );
                                                                          },
                                                                        );
                                                                      },
                                                                    );
                                                                  }

                                                                },
                                                              )



                                                          ),
                                                        ),
                                                        index!= test.length-1 ?
                                                        Divider(
                                                          thickness: 1,
                                                          color: Color(0xFFedeff3),
                                                        ):Container(),
                                                      ]
                                                  ),

                                                );

                                              }
                                          )

                                      );

                                    }
                                    else if(state is PostpaidEligiblePackagesStateSuccessState && Permessions.contains('05.02.01.08')==true && Packages_5G==true){
                                      List<dynamic> test =[];
                                      test=state.data
                                          .where((element) =>
                                      element["subGroup"] == connectionTypes) .toList();

                                      // var distinctIds = ids.toSet().toList();
                                      return Container(
                                          padding: EdgeInsets.only(bottom: 8),
                                          child: ListView.builder(
                                              scrollDirection: Axis.vertical,
                                              shrinkWrap: true,
                                              physics: ClampingScrollPhysics(),
                                              itemCount : test.length,
                                              itemBuilder:(context,index){
                                                return Container(
                                                  color: Colors.white,
                                                  child: Column(
                                                      children:[
                                                        SizedBox(
                                                          height:index  !=  test.length-1 ? 50 :55,
                                                          child: ListTile(
                                                              title: Text(
                                                                EasyLocalization.of(context).locale ==
                                                                    Locale("en", "US")
                                                                    ? test[index]['descEn']
                                                                    : test[index]['descAr'],
                                                                style: TextStyle(
                                                                    fontSize: 16,
                                                                    letterSpacing: 0,
                                                                    color: Color(0xff11120e),
                                                                    fontWeight: FontWeight.normal),
                                                              ),
                                                              trailing:
                                                              TextButton(
                                                                child: Text(
                                                                  "Menu_Form.select".tr().toString(),
                                                                  style: TextStyle(
                                                                    color: Color(0xFF0070c9
                                                                    ),
                                                                    letterSpacing: 0,
                                                                    fontSize: 16,
                                                                  ),
                                                                  //Test@2025
                                                                ),
                                                                onPressed: () {
                                                                  Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                      builder: (context) => BroadBandNationalityList(
                                                                          Permessions:Permessions,
                                                                          role:role,
                                                                          outDoorUserName:outDoorUserName,
                                                                          marketType:marketType,
                                                                          packageCode:test[index]['packageCode'],
                                                                          isParentEligible:test[index]['isParentEligible'],
                                                                          Packages_5G:Packages_5G,
                                                                          isLockedFalge: _isLockedFalge


                                                                      ),
                                                                    ),
                                                                  );
                                                                },
                                                              )


                                                          ),
                                                        ),
                                                        index!= test.length-1 ?
                                                        Divider(
                                                          thickness: 1,
                                                          color: Color(0xFFedeff3),
                                                        ):Container(),
                                                      ]
                                                  ),

                                                );

                                              }
                                          )

                                      );

                                    }
                                    else{
                                    }return Container();
                                  }

                              ),
                            ])))
                /*.................................................................................................................*/
              ],),
              /*  Permessions.contains('05.02.01.07')==false ||  Permessions.contains('05.02.01.08')==false ?  Center(
                child: Text(
                  'No security ID open to this user',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              ):Container(),*/

            ],
          )

      ),
    );
  }
}