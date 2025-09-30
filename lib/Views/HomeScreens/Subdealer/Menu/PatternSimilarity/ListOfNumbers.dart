import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PatternSimilarity/MSISDNcategory.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PatternSimilarity/ReservedNumbers.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListOfNumbers extends StatefulWidget {
  List listOfNumbers = [];
  String msisdn;
  var type;
  //const ListOfNumbers({Key? key}) : super(key: key);
  ListOfNumbers(this.listOfNumbers, this.msisdn, this.type);
  @override
  State<ListOfNumbers> createState() =>
      _ListOfNumbersState(this.listOfNumbers, this.msisdn, this.type);
}

APP_URLS urls = new APP_URLS();

class _ListOfNumbersState extends State<ListOfNumbers> {
  DateTime backButtonPressedTime;

  List listOfNumbers = [];
  var number;
  var price;
  String msisdn;
  var type;
  var reserveTime;
  _ListOfNumbersState(this.listOfNumbers, this.msisdn, this.type);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _reserved(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'Choose and reserve the number?'
                : "اختيار و حجز الرقم؟",
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
                    ? 'Reserve'
                    : "حجز",
                style: TextStyle(
                    color: Color(0xFF4f2565),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                reservedAPI();

              },
            ),

          ],
        );
      },
    );
  }

  Future<void> _confirmReserved(BuildContext context) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(EasyLocalization.of(context).locale == Locale("en", "US")
              ? 'Confirmed Details'
              : "تفاصيل التأكيد"),
          content: Text(
            EasyLocalization.of(context).locale == Locale("en", "US")
                ? 'The number ${number} was reserved and the package price is ${price}  the number will be reserved for ${reserveTime}. '
                : "تم حجز الرقم  ${number} و سعر الحزمة التي يمكن بيعها عليه هي ${price}دينار , سيبقى الرقم محجوزاً لمدة ${reserveTime}.",
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? 'Cancel'
                    : "إلغاء",
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
                    ? 'Go To Reserve List'
                    : "انتقل إلى قائمة الحجز",
                style: TextStyle(
                    color: Color(0xFF4f2565),
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>ReservedNumbers(),),
                );
               // reservedAPI();
              },
            ),
          ],
        );
      },
    );
  }

  /********************************************** APIS  **********************************************/
  void reservedAPI() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/Lines/msisdn/reserve';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    Map body = {
      "msisdn": number,
    };
    final response = await http.post(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },
      body: json.encode(body),
    );
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(json.encode(body));
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? statusCode.toString()
                  : statusCode.toString())));
    }
    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? statusCode.toString()
                  : statusCode.toString())));
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      setState(() {
        // isLoading=false;
      });
      if (result["status"] == 0) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        _confirmReserved(context);

       /* Timer(
          Duration(seconds: 1),
          () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ReservedNumbers(),
            ),
          ),
        );*/
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        //  showAlertDialogERROR(context,result["messageAr"], result["message"]);
      }
      return result;
    } else {
      //   showAlertDialogOtherERROR(context,statusCode, statusCode);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? statusCode.toString()
                  : statusCode.toString())));
    }
  }
  /******************************************** End APIS ********************************************/

  /******** for back button on mobile tap ******/
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Navigator.pop(context);
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
                    /* Navigator.push(context, MaterialPageRoute(builder: (context) => MSISDN_Category())).then((value) {
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
                    /*  Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MSISDN_Category()),
                    );*/

                    /*  Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );  */
                  },
                ),
                centerTitle: false,
                title: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'List of Numbers'
                      : "قائمة الأرقام",
                ),
                backgroundColor: Color(0xFF4f2565),
              ),
              backgroundColor: Color(0xFFEBECF1),
              body: Container(
                  padding: EdgeInsets.only(bottom: 8),
                  child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      itemCount: listOfNumbers.length,
                      itemBuilder: (context, index) {
                        return Container(
                          color: Colors.white,
                          child: Column(children: [
                            SizedBox(
                              height:
                                  index != listOfNumbers.length - 1 ? 50 : 55,
                              child: ListTile(
                                title: Text(
                                  listOfNumbers[index]['msisdn'],
                                  style: TextStyle(
                                      fontSize: 16,
                                      letterSpacing: 0,
                                      color: Color(0xff11120e),
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      listOfNumbers[index]['category'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff11120e),
                                      ),
                                    ),

                                    Text(
                                      listOfNumbers[index]['price'],
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Color(0xff11120e),
                                      ),
                                    ),
                                  ],
                                ),
                                trailing: Wrap(
                                  spacing: 1, // space between two icons
                                  children: <Widget>[
                                    TextButton.icon(
                                        onPressed: ()async {
                                          await Clipboard.setData(ClipboardData(text:  listOfNumbers[index]['msisdn']));
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
                                      child: Text(
                                        EasyLocalization.of(context).locale ==
                                                Locale("en", "US")
                                            ? 'SELECT'
                                            : "اختر",
                                        style: TextStyle(
                                          color: Color(0xFF0070c9),
                                          letterSpacing: 0,
                                          fontSize: 16,
                                        ),
                                      ),
                                      onPressed: () {
                                        _reserved(context);
                                        setState(() {
                                          number = listOfNumbers[index]['msisdn'];
                                          price = listOfNumbers[index]['price'];
                                          reserveTime=  EasyLocalization.of(context).locale ==
                                              Locale("en", "US")
                                              ? listOfNumbers[index]['reserve']
                                              : listOfNumbers[index]['reserveAr'];
                                        });
                                      },
                                    ), // icon-2
                                  ],
                                ),
                              ),
                            ),
                            index != listOfNumbers.length - 1
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
