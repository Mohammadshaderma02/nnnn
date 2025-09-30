import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/ChangePackage/ChangePackage_ContractDetails.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../../Shared/BaseUrl.dart';
import '../../../../ReusableComponents/requiredText.dart';

class changePackage extends StatefulWidget {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
   changePackage(this.Permessions, this.role, this.outDoorUserName) ;

  @override
  State<changePackage> createState() => _changePackageState(this.Permessions, this.role, this.outDoorUserName);
}

APP_URLS urls = new APP_URLS();
class _changePackageState extends State<changePackage> {
  List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _changePackageState(this.Permessions, this.role, this.outDoorUserName);

  TextEditingController msisdn = TextEditingController();
  bool emptyMAISDN = false;
  bool errorMAISDN = false;
  List EligiblePackages = [];
  bool checkPackagesList = false;
  bool listEmpty=false;
  bool onSpot = true;
  bool nextBill = false;
  bool changePackage=false;
  String amount;

  int actionTime;
  String packageId;
  bool confirm;

  String getContract;



  @override
  void initState() {
    super.initState();
  }

  Widget MSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "changePackage.enter_msisdn".tr().toString(),
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
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
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            controller: msisdn,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,

            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMAISDN== true || errorMAISDN==true
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
                const BorderSide(color: Color(0xFF4F2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(8),
              hintText: "xxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: ()=>{
            setState(() {
           emptyMAISDN=false;
           errorMAISDN=false;
            })
            },

          ),
        )
      ],
    );
  }

  getEligiblePackages_API() async {
    setState(() {
      EligiblePackages=[];
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/ChangePackage/postpaid/eligible/${msisdn.text}';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);

    final response = await http.get(
      url,
      headers: {
        "content-type": "application/json",
        "Authorization": prefs.getString("accessToken")
      },

    );

    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);

    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      setState(() {
        checkPackagesList=false;
        emptyMAISDN=false;
      });
      print('401  error ');
     // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

          if(result["status"]== 0 ){

            if (result["data"] == null || result["data"].length == 0) {
              setState(() {
                listEmpty=true;
                checkPackagesList=false;
                emptyMAISDN=false;
              });
              print(apiArea);
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                      EasyLocalization.of(context).locale == Locale("en", "US")
                          ? "There is no packages available"
                          : "لا توجد حزم متاحة")));
            }

            if (result["data"] != null ) {
              setState(() {
                checkPackagesList=false;
                listEmpty=false;
                emptyMAISDN=false;
              });
              setState(() {
                EligiblePackages = result["data"];
              });
              print("******start****");
              print(result["data"].length);
              print(EligiblePackages);
            }

          }else{
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                    EasyLocalization.of(context).locale == Locale("en", "US")
                        ? result["message"]
                        : result["messageAr"])));
            setState(() {
              listEmpty=true;
              checkPackagesList=false;
              emptyMAISDN=false;
            });
          }

      print('Sucses API');
      return result;
    } else {
      setState(() {
        checkPackagesList=false;
        listEmpty=true;
        emptyMAISDN=false;

      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  changePackagesWithZeroamount_API() async {
    print("changePackagesWithZeroamount_API()");
    setState(() {
      changePackage=true;
    });
    FocusScope.of(context).unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/ChangePackage/postpaid/change';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn.text,
      "actionTime": actionTime,
      "packageId": packageId,
      "confirm": confirm
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

    if (statusCode == 401) {
      setState(() {
        changePackage=false;
      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){

        if (result["data"] == null || result["data"].length == 0) {
          setState(() {

          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no packages available"
                      : "لا توجد حزم متاحة")));
        }

        if (result["data"] != null ) {
          setState(() {
            amount=result["data"]["amount"].toString();
            changePackage=false;
          });


          _showAlertDialogSucss(context,result["message"],result["messageAr"]);


        }

      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          changePackage=false;
        });
      }



      print('Sucses API');
      return result;
    } else {
      setState(() {
        changePackage=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  changePackages_API() async {
    print("changePackages_API()");
    setState(() {
      changePackage=true;
    });
    FocusScope.of(context).unfocus();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = urls.BASE_URL + '/ChangePackage/postpaid/change';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");
    print(url);
    Map body={
      "msisdn": msisdn.text,
      "actionTime": actionTime,
      "packageId": packageId,
      "confirm": confirm
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

    if (statusCode == 401) {
      setState(() {
        changePackage=false;
      });
      print('401  error ');
      // UnotherizedError();
    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      if(result["status"]== 0 ){

        if (result["data"] == null || result["data"].length == 0) {
          setState(() {

          });
          print(apiArea);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "There is no packages available"
                      : "لا توجد حزم متاحة")));
        }

        if (result["data"] != null ) {
          setState(() {
            amount=result["data"]["amount"].toString();
            changePackage=false;
          });


          if(confirm==false && amount !="0"){
            showAlertDialogToConfirmChangePackage(context);
          }
          if(confirm==true && amount !="0"){
            _showAlertDialogSucss(context,result["message"],result["messageAr"]);
          }
          if(confirm==false && amount =="0"){

            changePackagesWithZeroamount_API();
            setState(() {
              confirm=true;
              changePackage=true;
            });
          }

        }

      }else{
        _showAlertDialogErorr(context,result["message"],result["messageAr"]);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
                EasyLocalization.of(context).locale == Locale("en", "US")
                    ? result["message"]
                    : result["messageAr"])));
        setState(() {
          changePackage=false;
        });
      }
         print('Sucses API');
      return result;
    } else {
      setState(() {
        changePackage=false;
      });


      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(EasyLocalization.of(context).locale ==
              Locale("en", "US")
              ? statusCode.toString()
              : statusCode.toString())));
    }
  }

  Future<void> _showAlertDialogErorr(BuildContext context,valuEnglish,valuArabaic) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // AlertDialog widget
        return AlertDialog(
          title:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
              ?"Warning"
              : "تنبيه",style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4f2565),
              fontWeight: FontWeight.bold)),
          content: Text( EasyLocalization.of(context).locale == Locale("en", "US")
              ?valuEnglish
              : valuArabaic),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                // Close the AlertDialog
                Navigator.of(context).pop();
              },
              child: Text("Postpaid.Cancel".tr().toString(),style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4f2565),
                  fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialogCheckContract(BuildContext context,valuEnglish,valuArabaic) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // AlertDialog widget
        return AlertDialog(
          title:  Text( EasyLocalization.of(context).locale == Locale("en", "US")
              ?"Warning"
              : "تنبيه",style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4f2565),
              fontWeight: FontWeight.bold)),
          content: Text( EasyLocalization.of(context).locale == Locale("en", "US")
              ?valuEnglish
              : valuArabaic),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                changePackages_API();
                Navigator.of(context).pop();
              },
              child: Text(EasyLocalization.of(context).locale == Locale("en", "US")
                  ?"Next"
                  : "التالي",style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4f2565),
                  fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showAlertDialogSucss(BuildContext context,valuEnglish,valuArabaic) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        // AlertDialog widget
        return AlertDialog(

          content: Text( EasyLocalization.of(context).locale == Locale("en", "US")
              ?valuEnglish
              : valuArabaic),
          actions: <Widget>[
            TextButton(
              onPressed: () {
              //  check_contract_API();2024
                Navigator.of(context).pop();
              },
              child: Text( EasyLocalization.of(context).locale == Locale("en", "US")
                  ?"Close"
                  : "اغلاق",style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF4f2565),
                  fontWeight: FontWeight.bold),),
            ),
          ],
        );
      },
    );
  }


  void showAlertDialogToConfirmChangePackage(BuildContext context) {
    // Create AlertDialog
    AlertDialog alert = AlertDialog(
      content: Text(
        EasyLocalization.of(context).locale ==
            Locale("en", "US")
            ?"The amount is " +amount +" "+"JD"
            :  " "+"المبلغ المطلوب هو"+amount+"د.أ" ,
        style: TextStyle(
            fontSize: 16,
            color: Colors.black,
            fontWeight: FontWeight.bold),),
      actions: [
        // You can add buttons here
        TextButton(
          onPressed: () {
            Navigator.pop(context);
          },
          child: Text("Postpaid.Cancel".tr().toString(),style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4f2565),
              fontWeight: FontWeight.bold),),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            setState(() {
              confirm=true;
              changePackage=true;
            });
            changePackages_API();
          },
          child: Text("changePackage.Confirm".tr().toString(),style: TextStyle(
              fontSize: 16,
              color: Color(0xFF4f2565),
              fontWeight: FontWeight.bold),),
        ),
      ],
    );

    // Show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }



  /*..........................New change in 22 sep 2024........................*/
  /*this is for check if MSISDN has a package or not */
  check_contract_API() async{
    setState(() {
      changePackage=true;
    });
    print("-------------------------------------------Haya hazaimeh----------------------------------------");
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL + '/ChangePackage/postpaid/jopacc-disclaimer/${msisdn.text}';

    final Uri url = Uri.parse(apiArea);

    print(url);

    final response = await http.get(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    print(statusCode);


    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      print('401  error ');


    }
    if (statusCode == 200) {

      var result = json.decode(response.body);

      print(result["data"]);
      print(result);


      if( result["status"]==0){
        setState(() {
          changePackage=false;
        });
        if(result["data"]==null){


        }

        if(result['data']!=null){
          if(result['data']['contractBase64']!= null || result['data']['contractBase64'].length!=0){
            setState(() {
              getContract=result['data']['contractBase64'];
            });


            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => ChangePackage_ContractDetails(
                    Permessions: Permessions,
                    role:role,
                    outDoorUserName:outDoorUserName,
                    FileEPath: getContract,
                    msisdn:msisdn.text,
                    packageId:packageId,
                    actionTime:actionTime,
                    confirm:confirm,
                    changePackagee:changePackage,
                ),
              ),
            );
          }else{
            changePackages_API();
          }
        }

        }
       if(result["status"]!=-1 && result["status"]!=0){
         _showAlertDialogErorr(context,result["message"],result["messageAr"]);

       }
      if(result["status"]==-1){
        changePackages_API();
        setState(() {
          changePackage=true;
        });
      }
      }
    else{
      setState(() {
        changePackage=false;
      });
      var result = json.decode(response.body);

      _showAlertDialogErorr(context,result["message"]+" "+statusCode.toString(),result["messageAr"]+" "+statusCode.toString());


    }

  }


  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
        onTap: ()=>FocusScope.of(context).unfocus(),
    child: Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          //tooltip: 'Menu Icon',
          onPressed: ()async {
           // Navigator.pop(context);
              SharedPreferences prefs = await SharedPreferences.getInstance();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        Menu(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName
                           ),
                  ),
                );
          },
        ),
        centerTitle:false,
        title: Text(
          "changePackage.changePackage".tr().toString(),
        ),
        backgroundColor: Color(0xFF4f2565),
      ),
      backgroundColor: Color(0xFFEBECF1),
    body:Stack(
      children: [
        // Your existing Column
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            /**************************************************************First Container for Enter MSISDN**********************************************/
            Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: MSISDN(),
                        ),
                      ),
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(top: 24.0), // Adjust the margin as needed
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4f2565), // Set the desired background color
                          ),
                          onPressed: () {
                            if(msisdn.text.length<1){
                              FocusScope.of(context).unfocus();
                              setState(() {
                                emptyMAISDN=true;
                                EligiblePackages=[];
                              });
                            }else{
                              FocusScope.of(context).unfocus();
                              getEligiblePackages_API();
                              setState(() {
                                checkPackagesList = true;
                              });
                            }

                          },
                          child: Text("changePackage.submit".tr().toString()),
                        ),
                      ),
                    ],
                  ),
                  emptyMAISDN == true
                      ? ReusableRequiredText(
                      text: "Menu_Form.serial_numbe_required"
                          .tr()
                          .toString())
                      : Container(),
                  SizedBox(height: 10),
                ],
              ),
            ),
            /***********************************************************************************************************************************************/
            SizedBox(height: 15),

             Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 2),
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: EligiblePackages.length,
                  itemBuilder: (context, index) {
                    return Container(
                      color: Colors.white,
                      child: Column(
                        children: [
                          SizedBox(
                            height: index != EligiblePackages.length - 1 ? 50 : 55,
                            child: ListTile(
                              title: Text(
                                EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? EligiblePackages[index]['packageName']
                                    : EligiblePackages[index]['packageName'],
                                style: TextStyle(
                                  fontSize: 16,
                                  letterSpacing: 0,
                                  color: Color(0xff11120e),
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                              trailing: TextButton(
                                child: Text(
                                  "Menu_Form.select".tr().toString(),
                                  style: TextStyle(
                                    color: Color(0xFF0070c9),
                                    letterSpacing: 0,
                                    fontSize: 16,
                                  ),
                                ),
                                onPressed: () {

                                  showDialog(
                                    context: context,
                                    builder: (context) {

                                      return StatefulBuilder(
                                        builder: (context, setState) {
                                          return AlertDialog(
                                            title: Text("changePackage.ChangePackageAction".tr().toString(),),
                                            content:  Container(
                                              alignment: Alignment.topLeft,
                                              height: 110,
                                              child: Column(
                                                children: [

                                                  Expanded(
                                                    child: Align(
                                                      alignment:EasyLocalization.of(context).locale == Locale("en", "US")?
                                                      Alignment.centerLeft:Alignment.centerRight,
                                                      child: Container(
                                                        color: Colors.white,
                                                        child:        ElevatedButton.icon(
                                                          // <-- ElevatedButton
                                                          onPressed: () {  if (nextBill == true) {
                                                            setState(() {
                                                              nextBill = false;
                                                              onSpot = true;
                                                            });
                                                          }
                                                          },
                                                          style: onSpot == true
                                                              ? ElevatedButton.styleFrom(
                                                            primary: Colors.white,
                                                            onPrimary: Color(0xFF4f2565),

                                                            shadowColor: Colors.transparent,
                                                          )
                                                              : ElevatedButton.styleFrom(
                                                            primary: Colors.white,
                                                            onPrimary: Colors.black87,

                                                            shadowColor: Colors.transparent,
                                                          ),
                                                          icon: onSpot == true
                                                              ? Icon(
                                                            Icons.check_circle,
                                                            size: 24.0,
                                                          )
                                                              : Icon(
                                                            Icons.circle_outlined,
                                                            size: 24.0,
                                                          ),
                                                          label: Text("changePackage.OnSpot".tr().toString(),style:TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.normal)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Expanded(
                                                    child: Align(
                                                      alignment:EasyLocalization.of(context).locale == Locale("en", "US")?
                                                      Alignment.centerLeft:Alignment.centerRight,
                                                      child: Container(
                                                        color: Colors.white,
                                                        child:        ElevatedButton.icon(
                                                          // <-- ElevatedButton
                                                          onPressed: () {  if (onSpot == true) {
                                                            setState(() {
                                                              onSpot = false;
                                                              nextBill = true;
                                                            });
                                                          }
                                                          },
                                                          style: nextBill == true
                                                              ? ElevatedButton.styleFrom(
                                                            primary: Colors.white,
                                                            onPrimary: Color(0xFF4f2565),

                                                            shadowColor: Colors.transparent,
                                                          )
                                                              : ElevatedButton.styleFrom(
                                                            primary: Colors.white,
                                                            onPrimary: Colors.black87,

                                                            shadowColor: Colors.transparent,
                                                          ),
                                                          icon: nextBill == true
                                                              ? Icon(
                                                            Icons.check_circle,
                                                            size: 24.0,
                                                          )
                                                              : Icon(
                                                            Icons.circle_outlined,
                                                            size: 24.0,
                                                          ),
                                                          label: Text("changePackage.NextBill".tr().toString(),style:TextStyle(
                                                              fontSize: 16,
                                                              color: Colors.black87,
                                                              fontWeight: FontWeight.normal)),
                                                        ),
                                                      ),
                                                    ),
                                                  ),


                                                ],
                                              ),
                                            ),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () =>
                                                    Navigator.pop(context),
                                                child: Text("Postpaid.Cancel".tr().toString(),style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFF4f2565),
                                                    fontWeight: FontWeight.bold),),
                                              ),
                                              TextButton(
                                                onPressed: () async{
                                                  if(onSpot==true){
                                                    setState(() {
                                                      actionTime=1;
                                                      packageId=EligiblePackages[index]['packageID'];
                                                      confirm=false;
                                                      changePackage=true;
                                                    });

                                                    check_contract_API();


                                                  }
                                                  if(nextBill==true){
                                                    setState(() {
                                                      actionTime=2;
                                                      packageId=EligiblePackages[index]['packageID'];
                                                      confirm=false;
                                                      changePackage=true;
                                                    });

                                                    check_contract_API();


                                                  }
                                                  Navigator.pop(context);
                                                },
                                                child: Text("Postpaid.Next".tr().toString(),style: TextStyle(
                                                    fontSize: 16,
                                                    color: Color(0xFF4f2565),
                                                    fontWeight: FontWeight.bold),),
                                              ),
                                            ],
                                          );
                                        },
                                      );
                                    },
                                  );

                                },
                              ),
                            ),
                          ),
                          index != EligiblePackages.length - 1
                              ? Divider(
                            thickness: 1,
                            color: Color(0xFFedeff3),
                          )
                              : Container(),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),

        // Transparent overlay
        Visibility(
          visible: checkPackagesList, // Adjust the condition based on when you want to show the overlay
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
          visible: changePackage, // Adjust the condition based on when you want to show the overlay
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
    )


    ));
  }
}
