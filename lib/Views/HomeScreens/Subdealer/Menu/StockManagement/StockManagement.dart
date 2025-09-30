import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/BuyNumber/BuyNumber_block.dart';

import '../../CustomBottomNavigationBar.dart';


class StockManagement extends StatefulWidget {


  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  StockManagement({this.Permessions,this.role,this.outDoorUserName});

  @override
  _StockManagementState createState() => _StockManagementState(this.Permessions,this.role,this.outDoorUserName);
}

class _StockManagementState extends State<StockManagement> {

  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _StockManagementState(this.Permessions,this.role,this.outDoorUserName);

  APP_URLS urls = new APP_URLS();
  Map data = new Map();
  ScrollController scrollController = ScrollController();
  List<dynamic> UserList =[];
  bool isLoading = false;

  var serial = [];


  @override
  void initState() {

    callApi();
    //setupScrollController(context);
    super.initState();
  }


  void callApi () async{
   setState(() {
      isLoading=true;
    });
    var url = urls.BASE_URL+'/Stock/GetStockByOutDoor';


    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    print('body: [${response.body}]');



    if(statusCode ==200) {
      var result = json.decode(response.body);
      print(url);


      if (result["data"] == null || result["data"].length == 0) {
        setState(() {
          isLoading=false;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "There is no data available"
                    : "لا توجد بيانات متاحة")));
      }

      if (result["data"] != null ) {
        if(result['status']==0){
          setState(() {
            serial=result['data'];
            isLoading=false;
          });


        }
        else{
          setState(() {
            isLoading=false;
          });
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? result["message"]
                      : result["messageAr"])));
        }


      }


    }
    if(statusCode==401){
      UnotherizedError();
      setState(() {
        isLoading=false;
      });
    }if(statusCode!=401 && statusCode!=200){
      setState(() {
        isLoading=false;
      });
      showToast(statusCode.toString(),
          context: context,
          animation: StyledToastAnimation.scale,
          fullWidth: true);
    }

  }


  void stampConfirmApi (serialIndex) async{
    print("serialIndex");
    print(serialIndex);
  setState(() {
      isLoading=true;
    });
    var url = urls.BASE_URL+'/Stock/UpdateStockStatus';
    Map body ={
      "stockSerial": serialIndex,
      "status": 1
    };

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.put(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
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
      print(url);
      print(result['data']);
      if(result['status']==0){
        setState(() {
          isLoading=false;
        });

        callApi ();

      }else{
        setState(() {
          isLoading=false;
        });
        showToast(EasyLocalization.of(context).locale == Locale("en", "US")
            ?result['data']['message']:result['data']['messageAr'],
            context: context,
            animation: StyledToastAnimation.scale,
            fullWidth: true);
      }
     // callApi ();
    }
    if(statusCode==401){
      setState(() {
        isLoading=false;
      });
      UnotherizedError();
    }

    if(statusCode!=401 &&statusCode !=200 ){
      setState(() {
        isLoading=false;
      });
      showToast(statusCode.toString(),
          context: context,
          animation: StyledToastAnimation.scale,
          fullWidth: true);
     // callApi ();
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        centerTitle: false,
        title: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
              ? "New Serials"
              : "المسلسلات الجديدة",
        ),
        backgroundColor: Color(0xFF4f2565),
      ),
      body: serial.isEmpty
          ? Center(
        child: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
              ? "No Serials Available"
              : "لا توجد مسلسلات متاحة",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      )
          : Stack(
        children: [
          ListView.builder(
            itemCount: serial.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: Text(serial[index]['serials']),
                    subtitle: serial[index]['serialsstatus']=="Stamped "?
                    Text(serial[index]['serialsstatus'],
                      style: TextStyle(color: Colors.green,fontWeight: FontWeight.bold),):
                    Text(serial[index]['serialsstatus'],
                      style: TextStyle(color: Colors.red,fontWeight: FontWeight.bold),),
                    trailing: serial[index]['serialsstatus']=="Stamped "?Text("") :TextButton(
                      onPressed: () {
                        stampConfirmApi(serial[index]['serials']);
                      },
                      child: serial[index]['serialsstatus']=="Stamped "?Text(""):Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? "Confirm Stamped"
                            : "تأكيد الختم",
                        style: TextStyle(color: Color(0xFF4f2565)),
                      ),
                    ),
                   /* onTap: () {
                   //   stampConfirmApi(serial[index]['serials']);
                    },*/
                  ),
                  Divider(),
                ],
              );
            },
          ),

          // Loading overlay
          if (isLoading)
            Positioned.fill(
              child: Container(
                color: Colors.black.withOpacity(0.5), // Semi-transparent background
                child: Center(
                  child: CircularProgressIndicator(
                    color: Color(0xFF392156),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }



}

