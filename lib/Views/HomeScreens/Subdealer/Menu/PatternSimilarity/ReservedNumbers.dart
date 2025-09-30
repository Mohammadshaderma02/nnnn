import 'package:flutter/cupertino.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PatternSimilarity/MSISDNcategory.dart';
import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class ReservedNumbers extends StatefulWidget {
 // const ReservedNumbers({Key? key}) : super(key: key);

  @override
  State<ReservedNumbers> createState() => _ReservedNumbersState();
}
APP_URLS urls = new APP_URLS();

class _ReservedNumbersState extends State<ReservedNumbers> {
  DateTime backButtonPressedTime;
  List listOfReservedMSISDN = [];
  var number;
  List<String> substrings;

  @override
  void initState() {

    getReservedMSISDNsAPI ();
   }


  Future<void> _CancelReserved(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(EasyLocalization.of(context).locale == Locale("en", "US")
              ? 'Cancel Reserve'
              : "إلغاء الحجز"),
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Are you sure to cancel reserved this ${number} ?'
                : "هل أنت متأكد من إلغاء حجز هذا الرقم ${number}؟",
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'No'
                    : "لا",
                style: TextStyle(
                    color: Color(0xFF4f2565),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'Yes'
                    : "نعم",
                style: TextStyle(
                    color: Color(0xFF4f2565),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
               cancelReservedAPI();
              },
            ),
          ],
        );
      },
    );
  }
  void cancelReservedAPI() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Lines/msisdn/cancel';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    Map body = {
      "msisdn":number,

    };
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(json.encode(body));
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
    }
    if (statusCode == 401) {
      print('401  error ');

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      setState(() {
        // isLoading=false;

      });
      if( result["status"]==0){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));
      /*  Timer(
          Duration(seconds: 1),
              () =>   Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservedNumbers(),
            ),
          ),
        );*/
        getReservedMSISDNsAPI ();

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text( EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));

        //  showAlertDialogERROR(context,result["messageAr"], result["message"]);


      }




      return result;
    }else{
      //   showAlertDialogOtherERROR(context,statusCode, statusCode);


    }
  }

  getReservedMSISDNsAPI ()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lines/msisdn/reserved/list';
    final Uri url = Uri.parse(apiArea);
    print(url);
    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;
    print('TOKEN');
    print(prefs.getString("accessToken"));

    print("statusCode");
    print(statusCode);
    print('body: [${response.body}]');

    if (statusCode == 500) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

    }
    if(statusCode==401 ){
      print('401  error ');

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

    }
    if (statusCode == 200) {


      var result = json.decode(response.body);



      if( result["status"]==0){
        if(result["data"]==null||result["data"].length==0){
          prefs.setString('isThereReserved', 'False');
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.EmptyData".tr().toString())));

          setState(() {
            listOfReservedMSISDN=[];
          });
        }else{
          prefs.setString('isThereReserved', 'True');

          //  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("PatternSimilarity.Success".tr().toString())));
          print(result["data"]);
          setState(() {
            listOfReservedMSISDN=result["data"];
          });


        }

      }else{
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?result["message"]:result["messageAr"])));
      }
      return result;
    }else{
     // showAlertDialogOtherERROR(context,statusCode, statusCode);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString())));

    }
  }


  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);
    /*  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) {
          return MSISDN_Category();
        }),
      );*/
     /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MSISDN_Category(),
        ),
      );*/
      /*  Navigator.push(context, MaterialPageRoute(builder: (context) => MSISDN_Category())).then((value) {
        setState(() {
        msisdn='';
        type=null;});
      });*/

      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MSISDN_Category(),
        ),
      );*/
      /*Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MSISDN_Category()),
      );*/

      /*  Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => OrdersScreen()),
      );*/

      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(Icons.arrow_back),
                  //tooltip: 'Menu Icon',

                  onPressed: () async {
                  Navigator.pop(context);
                    /*Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) {
                        return MSISDN_Category();
                      }),
                    );*/
                 /*   Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MSISDN_Category(),
                      ),
                    );*/

                  },
                ),
                centerTitle: false,
                title: Text( EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'Reserved Numbers'
                    : "الأرقام المحجوزة",
                ),
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body:listOfReservedMSISDN.length==0?Center(
                child: Text(
                  "No Reserved Numbers",
                  textAlign: TextAlign.center,
                ),
              ): Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: listOfReservedMSISDN.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white,
                          child: Column(children: [
                            SizedBox(
                              height:
                              index != listOfReservedMSISDN.length - 1 ? 50 : 60,
                              child: ListTile(
                                  title: Text(
                                    listOfReservedMSISDN[index]['msisdn'],
                                    style: TextStyle(
                                        fontSize: 16,
                                        letterSpacing: 0,
                                        color: Color(0xff11120e),
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(  EasyLocalization.of(context).locale == Locale("en", "US")?
                                  "Expiry Date "+  listOfReservedMSISDN[index]['expiryDate'].substring(0,  listOfReservedMSISDN[index]['expiryDate'].lastIndexOf('T') + 0):
                                  "تاريخ الانتهاء  "+  listOfReservedMSISDN[index]['expiryDate'].substring(0,  listOfReservedMSISDN[index]['expiryDate'].lastIndexOf('T') + 0),
                                    style: TextStyle(
                                      fontSize: 14,
                                      color: Color(0xff11120e),

                                    ),
                                  ),
                                  trailing:Wrap(
                                      spacing: 1, // space between two icons
                                      children: <Widget>[
                                        TextButton.icon(
                                            onPressed: ()async {
                                              await Clipboard.setData(ClipboardData(text:  listOfReservedMSISDN[index]['msisdn']));
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                                  content: Text(
                                                      EasyLocalization.of(context).locale == Locale("en", "US")
                                                          ? "Copy"
                                                          : "نسخ")));

                                            },
                                            style: TextButton.styleFrom(
                                                primary: Colors.white,

                                                //backgroundColor: Colors.green,
                                                textStyle: const TextStyle(
                                                    fontSize: 24,
                                                    fontStyle: FontStyle.normal)),
                                            icon: Icon(
                                              Icons.copy_sharp,
                                              color: Color(0xFF0070c9),
                                              size: 20,
                                            ),
                                            label: Text(
                                              '',
                                              style: TextStyle(
                                                color: Color(0xFF0070c9),
                                                letterSpacing: 0,
                                                fontSize: 16,
                                              ),
                                            )),
                                        TextButton(
                                          child:  listOfReservedMSISDN[index]['canCancel']==true?Text(
                                            EasyLocalization.of(context).locale ==
                                                Locale("en", "US")
                                                ? 'CANCEL'
                                                : "إلغاء",
                                            style: TextStyle(
                                              color: Color(0xFF0070c9),
                                              letterSpacing: 0,
                                              fontSize: 16,
                                            ),
                                          ):null,
                                          onPressed: () {
                                            _CancelReserved(context);
                                            setState(() {
                                              number = listOfReservedMSISDN[index]['msisdn'];
                                              // price = listOfNumbers[index]['price'];
                                            });
                                            /*   Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => NationalityList(
                                                Permessions:Permessions,
                                                role:role,
                                                outDoorUserName:outDoorUserName,
                                                marketType:marketType,
                                                packageCode:state.data[index]['packageCode'],


                                              ),
                                            ),
                                          );*/
                                          },
                                        )
                                      ]) ),
                            ),
                            index != listOfReservedMSISDN.length - 1
                                ? Divider(
                              thickness: 1,
                              color: Color(0xFFedeff3),
                            )
                                : Container(),
                          ]),
                        );
                      }))),
        ),
        onWillPop: onWillPop);
  }
}
