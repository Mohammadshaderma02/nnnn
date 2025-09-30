import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/RejectedContracts/EditRejectedContractDetails.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/GetPendingLineDocQueue/getPendingLineDocQueue_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../CustomBottomNavigationBar.dart';


class RejectedContracts extends StatefulWidget {
  var Permessions=[];
  var role;
  var outDoorUserName;
  RejectedContracts({this.Permessions,this.role,this.outDoorUserName});
  @override
  _RejectedContractsState createState() => _RejectedContractsState(this.Permessions,this.role,this.outDoorUserName);
}

class _RejectedContractsState extends State<RejectedContracts> {
  ScrollController scrollController = ScrollController();
  APP_URLS urls = new APP_URLS();

  GetPendingLineDocQueueBloc getPendingLineDocQueueBloc;
  var Permessions=[];
  var role;
  var outDoorUserName;
  _RejectedContractsState(this.Permessions,this.role,this.outDoorUserName);
  List<dynamic> UserList =[];
  bool isLoading = false;
  bool allLoaded =false;
  bool isInitLoading = true;
  bool ErrorFlag = false;
  String arabicMessage = '';
  String englishMessage ='';
  int page =1;
  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !isLoading) {
          page++;
          print(page);
          //BlocProvider.of<GetPendingLineDocQueueBloc>(context);
          callApi(page);
        }
      }
    });
  }
  @override
  void initState() {
    callApi(page);
    setupScrollController(context);
    getPrefs();
    //getPendingLineDocQueueBloc.add(GetPendingLineDocQueueFetchEvent(0));
    super.initState();
  }


  getPrefs () async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // read
    Permessions = prefs.getStringList('Permessions') ?? [];
    print(' hello ${Permessions}');

  }

  void callApi (int page) async{
    if(allLoaded){
      return ;
    }setState(() {
      isLoading=true;
    });
    var url =  urls.BASE_URL+'LineDocumentation/pending?Limit=15&Page=${page}&Status=2';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    if(statusCode ==200) {
      var result = json.decode(response.body);
      print(result['data']['items'][0]);
      if(result['status']==0){
        List<dynamic> list =  result['data']['items'];
        if(list.isNotEmpty){
          list.map((data) => UserList.add(data)).toList();
          print(UserList);
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
  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
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
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => CustomBottomNavigationBar(Permessions: Permessions,role:role,outDoorUserName: outDoorUserName,),
                ),
              );
            },

          ),
          centerTitle:false,
          title: Text("DashBoard_Form.rejected_contracts".tr().toString()),
          backgroundColor: Color(0xFF4f2565),
        ),
        backgroundColor: Color(0xFFEBECF1),
        body: isInitLoading ? Container(
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
        ):  ErrorFlag == true ?
        AlertDialog(
          content: Text(EasyLocalization.of(context).locale == Locale("en", "US") ? englishMessage : arabicMessage,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  ErrorFlag=false;
                });
                Navigator.pop(
                  context,
                );
              },

              child: Text(
                "alert.close".tr().toString(),
                style: TextStyle(
                  color: Color(0xFF4f2565),
                  fontSize: 16,
                ),
              ),
            ),
          ],
        ) :  RefreshIndicator(
          color: Color(0xFF4f2565),
          onRefresh: () async{
            //  getPendingLineDocQueueBloc.add(GetPendingLineDocQueueFetchEvent(0));
          },
          child: Container(
              padding: allLoaded ? EdgeInsets.only(bottom: 16) : EdgeInsets.only(bottom: 0),
              child: Stack(
                  children :[ ListView.builder(
              scrollDirection: Axis.vertical,
                  controller: scrollController,
                  shrinkWrap: true,
                  itemCount :  UserList.length,
                  itemBuilder:(context,index){
                    return Container(
                      color: Colors.white,
                      child: Column(
                          children:[
                            SizedBox(
                              height:index  !=  UserList.length-1 ? 50 :55,
                              child:  ListTile(
                                leading: Container(
                                  width: 160,
                                  child: Text(

                                    UserList[index]['statusDesc'],

                                    style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff11120e),
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                title: Text(
                                  UserList[index]['msisdn'] ,
                                  style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff11120e),
                                      fontWeight: FontWeight.normal),
                                ),
                                trailing: GestureDetector(
                                  onTap :UserList[index]['isEditable']==false ?null :Permessions.contains('01.01.02')==true? () => Navigator.of(context).push(MaterialPageRoute(builder:(context)=>EditRejectedContractDetails(data:UserList[index],Permessions:Permessions,role:role,outDoorUserName:outDoorUserName))):null,

                                  child: new Text(
                                    "DashBoard_Form.edit".tr().toString(),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color:  UserList[index]['isEditable']? Permessions.contains('01.01.02')==true?
                                        Color(0xff0070c9):
                                        // permissio denied
                                        Color(0xFFA4B0C1):
                                        //not editibale
                                        Color(0xFFA4B0C1),
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ),
                            ),
                            index!= UserList.length-1 ?
                            Divider(
                              thickness: 1,
                              color: Color(0xFFedeff3),
                            ):Container(),
                          ]
                      ),

                    );

                  }
              ),
              if(isLoading)...[
          Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            height: 100,
            child: Padding(
                padding: const EdgeInsets.only(bottom: 13),
                child:  Center(
                  child: Container(
                    child: Center(
                        child:    CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),)
                    ),
                  ),
                )),
          ),
        )

        ]
        ]
    ),
    ),
    )

    );
  }
}

