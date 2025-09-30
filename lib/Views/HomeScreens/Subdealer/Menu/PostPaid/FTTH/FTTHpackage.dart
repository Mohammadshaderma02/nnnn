import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
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

class FTTHpackage extends StatefulWidget {
  final List<dynamic> Permessions;
  String marketType;
  final String connectionTypes;

  var role;
  var outDoorUserName;
  String packageCode;
  bool MADA_Activat;
  FTTHpackage({this.connectionTypes,this.Permessions,this.marketType,this.role,this.outDoorUserName,this.MADA_Activat});
  @override
  _FTTHpackageState createState() => _FTTHpackageState(this.connectionTypes,this.Permessions,this.marketType,this.role,this.outDoorUserName,this.MADA_Activat);
}

class _FTTHpackageState extends State<FTTHpackage> {

  final List<dynamic> Permessions;
  final String marketType;
  final String connectionTypes;
  var role;
  var outDoorUserName;
  _FTTHpackageState(this.connectionTypes,this.Permessions,this.marketType,this.role,this.outDoorUserName,this.MADA_Activat);
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
  bool MADA_Activat;
//////////////////////////////////////////////////////////////
  PostpaidEligiblePackagesBlock postpaidEligiblePackages;
  PostpaidEligiblePackagesBlock postpaidEligiblePackagesBlock;

  List<dynamic> EligiblePackages =[];
/////////////////////////////////////////////////////////////
  void initState() {
    print(widget.marketType);
    print("..................MADA_Activat..........");
    print(MADA_Activat);
    //callApi();
    postpaidEligiblePackagesBlock = BlocProvider.of<PostpaidEligiblePackagesBlock>(context);
    //postpaidEligiblePackages.add(PostpaidEligiblePackagesSelect());
    postpaidEligiblePackagesBlock.add(PostpaidEligiblePackagesSelect(marketType:marketType,isMada:MADA_Activat));
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
    print("haya");
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
    }, body: jsonEncode({"marketType": widget.marketType,"isMada": MADA_Activat}),);
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
      print("TESTING HAYA HAZAIMEH");
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
        body: ListView(
            physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 8),
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
                    else if(state is PostpaidEligiblePackagesStateSuccessState){
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
                                              // subtitle:  Text(
                                              //   EasyLocalization.of(context).locale ==
                                              //       Locale("en", "US")
                                              //       ? state.data[index]['descEn']
                                              //       : state.data[index]['descAr'],
                                              //   style: TextStyle(
                                              //       fontSize: 14,
                                              //       color: Color(0xff11120e),
                                              //       fontWeight: FontWeight.normal),
                                              // ),
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
                                                ),
                                                onPressed: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) => NationalityList(
                                                        Permessions:Permessions,
                                                        role:role,
                                                        outDoorUserName:outDoorUserName,
                                                        marketType:marketType,
                                                        packageCode:test[index]['packageCode'],


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
            ])

    );
  }
}