
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';

import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:sales_app/Views/HomeScreens/ZainOutdoorHeads/ZainOutdoorHeads_Dashboard.dart';
import 'package:sales_app/Views/ReusableComponents/appBar.dart';
import 'package:sales_app/blocs/Login/logout_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PrePaid/PrePaidSales.dart';
import 'package:dio/dio.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/Settings/Settings_Screen.dart';
import 'package:http/http.dart' as http;
import '../../../Shared/BaseUrl.dart';
import '../../../blocs/Login/logout_bloc.dart';
import '../../../blocs/Login/logout_events.dart';
import '../../LoginScreens/SignInScreen.dart';
import '../Subdealer/Menu/Recontracting/Recontracting.dart';


class AgentsDetails extends StatefulWidget {
  var PermessionZainOutdoorHeads=[];
  var role;
  var outDoorUserName;
  var AgentID;
  AgentsDetails({this.PermessionZainOutdoorHeads,this.role,this.outDoorUserName,this.AgentID});
  @override
  _AgentsDetailsState createState() => _AgentsDetailsState(this.PermessionZainOutdoorHeads,this.role,this.outDoorUserName,this.AgentID);
}

APP_URLS FirstPart = new APP_URLS();

class _AgentsDetailsState extends State<AgentsDetails> {

  String hayaBase;

  /***********************************************************************************************************************/
  /*                                             New Cycle Dashboard for Zain Heads                                   */
  /*                                                    created on 15-Dec-2024                                           */
  /***********************************************************************************************************************/
  bool isLoading =false;
  bool emtyResult=false;
  String statusReult;

  bool click_Reporting=false;
  bool click_SearchAgint=false;

  int gsm=0;
  int mbb=0;
  int ftth=0;
  int pretopost=0;
  int totalSales=0;

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


  /*..........................................Agent Variables...................................................*/
  TextEditingController Agent = TextEditingController();
  bool emptyAgent = false;
  bool errorAgent = false;
  /***********************************************************************************************************************/
  /*                                          End New Cycle Dashboard for Zain Heads                                  */
  /***********************************************************************************************************************/

  Response response;


  var PermessionZainOutdoorHeads = [];
  var role;
  var outDoorUserName;
  var AgentID;

  DateTime backButtonPressedTime;
  LogoutBloc logoutBloc;


  _AgentsDetailsState(this.PermessionZainOutdoorHeads, this.role, this.outDoorUserName,this.AgentID);

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
    agentDetailes_API();
    logoutBloc = BlocProvider.of<LogoutBloc>(context);


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
  /*                                             New Cycle Dashboard for Zain Heads                                      */
  /*                                                    created on 15-Dec-2024                                           */
  /***********************************************************************************************************************/
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

  /*....................................................................................................................*/
  /*.........................................................Export Button..............................................*/


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
      "agentName": this.AgentID,
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


  Future<String> _createFileFromString() async {
    final encodedStr = hayaBase;
    Uint8List bytes = base64.decode(encodedStr);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = File(
        "$dir/" + DateTime.now().millisecondsSinceEpoch.toString() + ".xlsx");
    await file.writeAsBytes(bytes);
    return file.path;
  }


  Future<void> downloadFile() async {
    setState(() {
      isLoading = true;
    });

    try {
      // Example Excel file URL
      const fileUrl = "https://example.com/sample.xlsx";
      final dio = Dio();

      // Get the directory to save the file
      final directory = await getExternalStorageDirectory();
      if (directory == null) throw Exception("No directory available");

      final filePath = "${directory.path}/sample.xlsx";

      // Download the file
      await dio.download(fileUrl, filePath);

      setState(() {
        isLoading = false;
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download completed: $filePath')),
      );

      // Open the downloaded file
      OpenFile.open(filePath);
    } catch (e) {
      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Download failed: $e')),
      );
    }
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
                  emptyAgent=false;
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

  /*....................................................................................................................*/
  /*....................................................Agent  Functions...............................................*/
  Widget enterAgentName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15,left: 10 ,right: 10),
          child:  RichText(
            text: TextSpan(
              text:  EasyLocalization.of(context).locale == Locale("en", "US")?
              'Agent Name' : "اسم الوكيل",
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: ' * ',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top:0,left: 10 ,right: 10),
          alignment: Alignment.centerLeft,
          height: 70,
          child: TextField(
            // maxLength: 10,
            controller: Agent,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyAgent == true
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
              contentPadding: EdgeInsets.all(12),
              hintText: "xxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onChanged: (tawasol){
              if(tawasol.isEmpty){
                setState(() {
                  emptyAgent=true;
                });
              }
              if(tawasol.isNotEmpty){
                setState(() {
                  emptyAgent=false;
                });
              }

            },
          ),
        ),

      ],
    );
  }

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

  /**2.Market Type_______________________________________________________________________________________________________*/

  Widget build_TotalSales() {
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
              color: Color(0xFF004a4b),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color: Color(0xFF004a4b)),
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
                        Icons.bar_chart,
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
                                ? 'Total Sales'
                                : "إجمالي المبيعات",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.normal,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? totalSales.toString()
                                : totalSales.toString(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 12),
                          Text(
                            EasyLocalization.of(context).locale == Locale("en", "US")
                                ? 'Total sales per market (GSM - FTTH - MBB)'
                                : "إجمالي المبيعات لكل سوق(GSM - FTTH - MBB)",
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
                SizedBox(height: 10),
                Divider(color: Colors.white,),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children horizontally with space between them
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US") ? 'FTTH' : "FTTH",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(height: 8),
                            Text(
                              ftth.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US") ? 'Total sales' : "إجمالي المبيعات",
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US") ? 'MBB' : "MBB",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(height: 8),
                            Text(
                              mbb.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US") ? 'Total sales' : "إجمالي المبيعات",
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Aligns the children horizontally with space between them
                  children: [

                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US") ? 'GSM' : "GSM",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(height: 8),
                            Text(
                              gsm.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US") ? 'Total sales' : "إجمالي المبيعات",
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: 5),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.rectangle,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US") ? 'Pre to post' : "Pre to post",
                              style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.normal),
                            ),
                            SizedBox(height: 8),
                            Text(
                              pretopost.toString(),
                              style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 12),
                            Text(
                              EasyLocalization.of(context).locale == Locale("en", "US") ? 'Total sales' : "إجمالي المبيعات",
                              style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
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


  void agentDetailes_API()async{
    setState(() {
      gsm=0;
      mbb=0;
      ftth=0;
      pretopost=0;
      emtyResult=false;
      isLoading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/GetOutDoorUsersById";
    final Uri url = Uri.parse(apiArea);
    print(url);
    Map body ={
      "userId":this.AgentID,
      "fromDate": null,
      "toDate": null
    };
    print(body);
    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 200) {

      setState(() {
        isLoading=false;
      });
      var result = json.decode(response.body);

      if( result["status"]==0){
        if(result["data"].length != 0){
          setState(() {
            gsm=result["data"]["gsm"];
            mbb=result["data"]["mbb"];
            ftth=result["data"]["ftth"];
            pretopost=result["data"]["preToPost"];
            totalSales=gsm+mbb+ftth+pretopost;
          });

          print("...........................Agent Detailes..............................");
          print(result["data"]);
          print("...........................Agent Detailes..............................");
        }

      }
      else{
        setState(() {
          statusReult=EasyLocalization.of(context).locale == Locale("en", "US")
              ? "No data found to view"
              : "لم يتم العثور على بيانات لعرضها";
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

  /***********************************************************************************************************************/
  /*                                          End New Cycle Dashboard for Zain Heads                                  */
  /***********************************************************************************************************************/

  Future<bool> _onWillPop() async {
    //disable back button on 31 DEC
 /*   DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;
      showAlertDialog(context, "هل انت متاكد من إغلاق التطبيق",
          "Are you sure to close the application?");
      return true;
    }
    return true;*/

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard(PermessionZainOutdoorHeads:this.PermessionZainOutdoorHeads,role:this.role,outDoorUserName:this.outDoorUserName)),
    );
    return false;
  }


  @override
  Widget build(BuildContext context) {
    return  WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: Icon(Icons.arrow_back),
                //tooltip: 'Menu Icon',
                onPressed: () {
                   Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard(PermessionZainOutdoorHeads:this.PermessionZainOutdoorHeads,role:this.role,outDoorUserName:this.outDoorUserName)),
                    );
                 /* Navigator.pop(
                    context,
                  );*/

                },
              ),
              centerTitle: false,
              title: Text( EasyLocalization
                  .of(context)
                  .locale ==
                  Locale("en", "US")?"Agent Details":"تفاصيل الوكيل",),
              automaticallyImplyLeading: false,
              //<Widget>[]
              backgroundColor: Color(0xFF392156),
            ),
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                build_UserName(),
                SizedBox(height: 25),
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



                SizedBox(height: 5),
                build_TotalSales(),
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