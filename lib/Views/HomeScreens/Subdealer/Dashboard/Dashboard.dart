import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/appBar.dart';
import 'package:sales_app/Views/ReusableComponents/logoutButton.dart';
import 'package:sales_app/blocs/GetSubdealerLineDocProgressCurrentCountRq/getSubdealerLineDocProgressCurrentCountRq_bloc.dart';
import 'package:sales_app/blocs/GetSubdealerLineDocProgressCurrentCountRq/getSubdealerLineDocProgressCurrentCountRq_events.dart';
import 'package:sales_app/blocs/GetSubdealerLineDocProgressCurrentCountRq/getSubdealerLineDocProgressCurrentCountRq_state.dart';
import 'package:sales_app/blocs/GetTawasolInfo/getTawasoInfo_state.dart';
import 'package:sales_app/blocs/GetTawasolInfo/getTawasolInfo_bloc.dart';
import 'package:sales_app/blocs/GetTawasolInfo/getTawasolInfo_events.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/RejectedContracts/RejectedContracts.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/PendingContracts/PendingContracts.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Setting/SettingsScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/NotificationsScreen.dart';

import 'package:http/http.dart' as http;
import 'package:sales_app/blocs/PostPaid/PostpaidStatistics/PostpaidStatistics_block.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidStatistics/PostpaidStatistics_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidStatistics/PostpaidStatistics_state.dart';

import '../../../../Shared/BaseUrl.dart';
import '../../../../blocs/Login/logout_bloc.dart';
import '../../../../blocs/Login/logout_events.dart';
import '../../../../blocs/Login/logout_state.dart';



class Dashboard extends StatefulWidget {
  List<dynamic> Permessions;
  String role;
  String outDoorUserName;

  Dashboard( {Key key,  @required this.Permessions,this.role,this.outDoorUserName}) : super(key: key);

  @override
  State<Dashboard> createState() => _DashboardState();
}
APP_URLS FirstPart = new APP_URLS();

class _DashboardState extends State<Dashboard> {


  /***********************************************************************************************************************/
  /*                                             New Cycle Dashboard for Zain out Door                                   */
  /*                                                    created on 15-Dec-2024                                           */
  /***********************************************************************************************************************/
  LogoutBloc logoutBloc;
  bool isLoading =false;
  bool emtyResult=false;
  String statusReult;

  bool isFilterDate = true;
  bool isFilterMSISDN = false;

  int gsm=0;
  int mbb=0;
  int ftth=0;
  int pretopost=0;
  /*................................................From Date Variables.................................................*/
  TextEditingController fromDate = TextEditingController();
  bool emptyFromDate=false;
  DateTime from_Date = DateTime.now();

  /*....................................................................................................................*/

  /*................................................To Date Variables...................................................*/
  TextEditingController toDate = TextEditingController();
  bool emptyToDate=false;
  DateTime to_Date = DateTime.now();


  /*..........................................MSISDN Variables...................................................*/
  TextEditingController MSISDN = TextEditingController();
  bool emptyMSISDN = false;
  bool errorMSISDN = false;

  /***********************************************************************************************************************/
  /*                                          End New Cycle Dashboard for Zain out Door                                  */
  /***********************************************************************************************************************/
  var Accepted;

  var Rejected;

  var Pending;

  var GSM_PEN_N =0;

  var GSM_ACC_N=0;

  var GSM_REJ_N=0;

  var DATA_ACC_N=0;

  var DATA_PEN_N=0;

  var DATA_REJ_N=0;

  Map data = new Map();

  DateTime backButtonPressedTime;

  GetTawasolInfoBloc getTawasolInfoBloc;

  GetSubdealerLineDocProgressCurrentCountRqBloc getSubdealerLineDocProgressCurrentCountRqBloc;

  PostpaidStatisticsBlock postpaidStatisticsBlock;


  /***********************************************************************************************************************/
  /*                                             New Cycle Dashboard for Zain out Door                                   */
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
                      ? 'Hello, '+ widget.outDoorUserName
                      : "أهلا، "+widget.outDoorUserName,
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


  /**1.Total Sales Title_________________________________________________________________________________________________*/
  Widget build_TotalSalesTitle()  {
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
                            ? 'Total Sales'
                            : "حالة العقود",
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


  /**2.Market Type_______________________________________________________________________________________________________*/
  Widget build_FTTHContracts() {
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
                    Icons.show_chart,
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
                            ? 'FTTH'
                            : "FTTH",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? ftth.toString()
                            : ftth.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'FTTH sales count upon the status (Dumped/ not dumped)'
                            : "سيتم عرض عدد مبيعات FTTH حسب الحالة (مُلْغَى/ غير مُلْغَى)",
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

  Widget build_MBBContracts() {
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
              color: Color(0xFF9a0658),
              borderRadius: BorderRadius.circular(5),
              border: Border.all(color:Color(0xFF9a0658)),
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
                    Icons.show_chart,
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
                            ? 'MBB'
                            : "MBB",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? mbb.toString()
                            : mbb.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Total sales'
                            : "اجمالي المبيعات",
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

  Widget build_GSMContracts() {
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
                    Icons.show_chart,
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
                            ? 'GSM'
                            : "GSM",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? gsm.toString()
                            : gsm.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Total sales'
                            : "اجمالي المبيعات",
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

  Widget build_PretopostContracts() {
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
                    Icons.show_chart,
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
                            ? 'Pre to post'
                            : "مدفوع مسبقا",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? pretopost.toString()
                            : pretopost.toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        EasyLocalization.of(context).locale == Locale("en", "US")
                            ? 'Total sales'
                            : "اجمالي المبيعات",
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


  /**3.Filtration ______________________________________________________________________________________________________*/

  Widget buildSearchDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child:    GestureDetector(
            onTap: () async {
              if(isFilterDate==false){
                setState(() {
                  MSISDN.text="";
                  isFilterDate=true;
                  isFilterMSISDN=false;
                  emptyMSISDN=false;
                  emptyFromDate=false;
                  emptyToDate=false;
                });
              }
            },
            child: Text(

              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Search By Date'
                  : "البحث حسب التاريخ",
              style: TextStyle(
                color: isFilterDate==true ?Color(0xFF4f2565):Color(0xffa4b0c1),
                  fontWeight: isFilterDate ==true ? FontWeight.bold:FontWeight.normal

                // decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),

        GestureDetector(
          onTap: () async {
            if(isFilterDate==false){
              setState(() {
                MSISDN.text="";
                isFilterDate=true;
                isFilterMSISDN=false;
                emptyMSISDN=false;
                emptyFromDate=false;
                emptyToDate=false;
              });
            }
          },
          child: Container(
            margin:EasyLocalization.of(context).locale == Locale("en", "US")
                ?EdgeInsets.only(left:10, right: 0,top: 10) :EdgeInsets.only(left:0, right: 10,top: 10),

            width: double.infinity,
            height:isFilterDate==true ?3: 2,
            decoration: BoxDecoration(
              color:isFilterDate==true ?Color(0xFF4f2565):Color(0xffa4b0c1),
              borderRadius: BorderRadius.circular(0),
              border: Border.all(color:isFilterDate==true ?Color(0xFF4f2565):Color(0xffa4b0c1),),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildSearchMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Center(
          child: GestureDetector(
            onTap: () async {
              if(isFilterMSISDN==false){
                setState(() {
                  fromDate.text="";
                  toDate.text="";
                  isFilterMSISDN=true;
                  isFilterDate=false;
                  emptyMSISDN=false;
                  emptyFromDate=false;
                  emptyToDate=false;
                });
              }
            },
            child: Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? 'Search By MSISDN'
                  : "البحث حسب الرقم",
              style: TextStyle(
                color: isFilterMSISDN ==true ?Color(0xFF4f2565):Color(0xffa4b0c1),
                fontWeight: isFilterMSISDN ==true ? FontWeight.bold:FontWeight.normal
                // decoration: TextDecoration.underline,
              ),
            ),
          ),
        ),
        GestureDetector(
          onTap: () async {
            if(isFilterMSISDN==false){
              setState(() {
                fromDate.text="";
                toDate.text="";
                isFilterMSISDN=true;
                isFilterDate=false;
                emptyMSISDN=false;
              });
            }
          },
          child: Container(
            margin:EasyLocalization.of(context).locale == Locale("en", "US")
                ?EdgeInsets.only(left:0, right: 10,top: 10) :EdgeInsets.only(left:10, right: 0,top: 10),
            width: double.infinity,
            height:isFilterMSISDN ==true?3: 2,
            decoration: BoxDecoration(
              color:isFilterMSISDN ==true ?Color(0xFF4f2565):Color(0xffa4b0c1),
              borderRadius: BorderRadius.circular(0),
              border: Border.all(color:isFilterMSISDN ==true ?Color(0xFF4f2565):Color(0xffa4b0c1),),
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

              if(isFilterDate==true){
                setState(() {
                  MSISDN.text="";
                  emptyMSISDN=false;
                });
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
                  });
                  outDoorDetailsDate_API();
                }
              }



                if(isFilterMSISDN==true){
                    setState(() {
                      fromDate.text="";
                      toDate.text="";
                      emptyFromDate=false;
                      emptyToDate=false;
                    });

                    if(MSISDN.text ==""){
                      setState(() {
                        emptyMSISDN=true;
                      });
                    }
                    if(MSISDN.text !=""){
                      setState(() {
                        emptyMSISDN=false;
                      });
                      outDoorDetailsMSISDN_API();
                    }
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
                        ? 'Search'
                        : "بحث",
                    style: TextStyle(
                      color: Color(0xFF4f2565),
                      letterSpacing: 0,
                      fontSize: 14,
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  SizedBox(width: 8), // Add some space between icon and text
                  Icon(
                    Icons.search, // Add your desired icon here
                    color:Color(0xFF4f2565),
                    size: 20,// Set the icon color
                  ),
                ],
              ),
            ),
          )
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
  /*....................................................Tawasol Functions...............................................*/
  Widget enterMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          margin: EdgeInsets.only(top: 15,left: 10 ,right: 10),
          child:  RichText(
            text: TextSpan(
              text:  EasyLocalization.of(context).locale == Locale("en", "US")?
              'MSISDN' : "الرقم",
              style: TextStyle(
                color: Color(0xff11120e),
                fontSize: 14,
                fontWeight: FontWeight.normal,
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
            controller: MSISDN,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyMSISDN == true
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
                  emptyMSISDN=true;
                });
              }
              if(tawasol.isNotEmpty){
                setState(() {
                  emptyMSISDN=false;
                });
              }

            },
          ),
        ),

      ],
    );
  }

  /*....................................................................................................................*/
  /*...................................................API For Filtration..............................................*/
  void outDoorDetailsInit_API()async{
    setState(() {
      gsm=0;
      mbb=0;
      ftth=0;
      pretopost=0;
      emtyResult=false;
      isLoading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/GetOutDoorDetails";
    final Uri url = Uri.parse(apiArea);
    print(url);
    Map body ={
      "msisdn": null,
      "fromDate": null,
      "toDate": null
    };

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;
    print(statusCode);
    if (statusCode == 401){
      _Unauthorized(context);
    }
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
          });

          print("...........................Zain Outdoor Data..............................");
          print(result["data"]);
          print("...........................Zain Outdoor Data..............................");
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

  void outDoorDetailsDate_API()async{
    setState(() {
      gsm=0;
      mbb=0;
      ftth=0;
      pretopost=0;
      emtyResult=false;
      isLoading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/GetOutDoorDetails";
    final Uri url = Uri.parse(apiArea);
    print(url);
    Map body ={
      "msisdn": null,
      "fromDate": fromDate.text,
      "toDate": toDate.text
    };

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
          });

          print("...........................Zain Outdoor Based on Date..............................");
          print(result["data"]);
          print("...........................Zain Outdoor Based on Date..............................");
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

  void outDoorDetailsMSISDN_API()async{
    setState(() {
      gsm=0;
      mbb=0;
      ftth=0;
      pretopost=0;
      emtyResult=false;
      isLoading=true;
    });
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var apiArea = FirstPart.BASE_URL + "/Dashboard/GetOutDoorDetails";
    final Uri url = Uri.parse(apiArea);
    print(url);
    Map body ={
      "msisdn": MSISDN.text,
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
          });

          print("...........................Zain Outdoor Data Based on MSISDN..............................");
          print(result["data"]);
          print("...........................Zain Outdoor Data Based on MSISDN..............................");
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
  /*                                          End New Cycle Dashboard for Zain out Door                                  */
  /***********************************************************************************************************************/
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
              title: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? 'Unauthorized'
                      : 'غير مصرح'),
              content: Text(
                  EasyLocalization.of(context).locale == Locale("en", "US")
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

  @override
  void initState() {
    logoutBloc = BlocProvider.of<LogoutBloc>(context);

    outDoorDetailsInit_API();
    // TODO: implement initState
    super.initState();

  }

  Future<bool> _onWillPop() async {
    return false; //<-- SEE HERE
  }

  // show the dialog
  @override
  Widget build(BuildContext context) {
    print('permession dashbord');

    print(widget.Permessions);
    print('role ${widget.role}');
    print('userName ${widget.outDoorUserName}');

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

    if(widget.Permessions==null){
      UnotherizedError();
    }
    getTawasolInfoBloc = BlocProvider.of<GetTawasolInfoBloc>(context);
    //getTawasolInfoBloc.add(GetTawasolInfoFetchEvent());
    if(widget.role=='Subdealer'){
      getTawasolInfoBloc.add(GetTawasolInfoFetchEvent());
    }
    getSubdealerLineDocProgressCurrentCountRqBloc =
        BlocProvider.of<GetSubdealerLineDocProgressCurrentCountRqBloc>(context);
    getSubdealerLineDocProgressCurrentCountRqBloc
        .add(GetSubdealerLineDocProgressCurrentCountRqFetchEvent());

    postpaidStatisticsBlock = BlocProvider.of<PostpaidStatisticsBlock>(context);
    postpaidStatisticsBlock.add(GetPostpaidStatisticsEventsFetchEvent());
    showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
      Widget tryAgainButton = TextButton(
        child: Text(
          "alert.tryAgain".tr().toString(),
          style: TextStyle(
            color: Color(0xFF4f2565),
            fontSize: 16,
          ),
        ),
        onPressed: () {
          Navigator.of(context).pop();
        },
      );
      // Create AlertDialog
      AlertDialog alert = AlertDialog(
        content: Text(
          EasyLocalization.of(context).locale == Locale("en", "US")
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
              //   logoutBloc.add(LogoutButtonPressed(
              //   ));
              exit(0);
            },
            child: Text(
              "alert.close".tr().toString(),
              style: TextStyle(
                color: Color(0xFF4f2565),
                fontSize: 16,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              //Navigator.pop(context, true);
              Navigator.pop(context, 'OK');
            },
            child: Text(
              "alert.cancel".tr().toString(),
              style: TextStyle(
                color: Color(0xFF4f2565),
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



    return widget.role=="ZainOutdoor" && widget.Permessions.contains('01.05') ?
    WillPopScope(
      onWillPop: _onWillPop,
      child: Stack(
        children: [
          Scaffold(
            appBar: appBarSection(
              appBar: AppBar(),
              title: Text("DashBoard_Form.home".tr().toString()),
              Permessions: widget.Permessions,
              role: widget.role,
              outDoorUserName: widget.outDoorUserName,
            ),
            backgroundColor: Colors.white,
            body: ListView(
              children: [
                build_UserName(),
                SizedBox(height: 30),
                Row(
                  children: <Widget>[
                    Expanded(child: buildSearchDate()),
                    SizedBox(width: 0),
                    Expanded(child: buildSearchMSISDN()),
                  ],
                ),
                SizedBox(height: 10),

                /* Filtration Part */
                isFilterDate == true
                    ? Row(
                  children: <Widget>[
                    Expanded(child: buildFromDate()),
                    Expanded(child: buildToDate()),
                  ],
                )
                    : Row(
                  children: <Widget>[
                    Expanded(child: enterMSISDN()),
                  ],
                ),

                Row(
                  children: <Widget>[
                    Expanded(child: build_FilterButton()),
                  ],
                ),

                Row(
                  children: [
                    Expanded(
                      child: emtyResult == true ? buildErorrStatus() : Container(),
                    ),
                  ],
                ),
                SizedBox(height: 30),

                /* Contract Status Part */
                build_TotalSalesTitle(),
                build_GSMContracts(),
                build_FTTHContracts(),
                build_MBBContracts(),
                build_PretopostContracts(),
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

    )


        :BlocListener<GetSubdealerLineDocProgressCurrentCountRqBloc,
        GetSubdealerLineDocProgressCurrentCountRqState>(
      listener: (context, state) {
        if (state is GetSubdealerLineDocProgressCurrentCountRqTokenErrorState) {
          UnotherizedError();
        } else if (state
        is GetSubdealerLineDocProgressCurrentCountRqErrorState) {
          showAlertDialog(context, state.arabicMessage, state.englishMessage);
        } else if (state
        is GetSubdealerLineDocProgressCurrentCountRqSuccessState) {
          //   getTawasolInfoBloc.add(GetTawasolInfoFetchEvent());
        }
      },
      child: WillPopScope(
        onWillPop: onWillPop,
        child: Scaffold(
            backgroundColor: Color(0xFFEBECF1),
            appBar: appBarSection(appBar : AppBar(),
                title: Text(
                  "DashBoard_Form.home".tr().toString()
                ),
              Permessions: widget.Permessions,
              role: widget.role,
              outDoorUserName: widget.outDoorUserName,
            ),

            body:
            BlocBuilder<GetSubdealerLineDocProgressCurrentCountRqBloc,
                GetSubdealerLineDocProgressCurrentCountRqState>(
                builder: (context, state) {
                  if (state is GetSubdealerLineDocProgressCurrentCountRqInitState ||
                      state
                      is GetSubdealerLineDocProgressCurrentCountRqLoadingState) {
                    return Center(
                      child: Container(
                        child: Center(
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Color(0xFF4f2565)),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text(
                                  "DashBoard_Form.loading".tr().toString(),
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                )
                              ]),
                        ),
                      ),
                    );
                  } else {
                    return RefreshIndicator(
                      color: Color(0xFF4f2565),
                      onRefresh: () async {
                        getSubdealerLineDocProgressCurrentCountRqBloc.add(
                            GetSubdealerLineDocProgressCurrentCountRqFetchEvent());
                        getTawasolInfoBloc.add(GetTawasolInfoFetchEvent());
                      },
                      child: ListView(
                          physics: ClampingScrollPhysics(),
                          padding: EdgeInsets.only(top: 8, bottom: 8),
                          children: <Widget>[
                            widget.role=="Subdealer"?Container(
                              color: Colors.white,
                              child: Center(
                                  child: ListView(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/imageprofile.png'),
                                          ),
                                          title: BlocBuilder<GetTawasolInfoBloc,
                                              GetTawasolInfoState>(
                                            builder: (context, state) {
                                              if (state is GetTawasolInfoLoadingState) {
                                                return Container();
                                              } else if (state
                                              is GetTawasolInfoSuccessState) {
                                                return Text(
                                                  state.data["data"]["channel"]
                                                  ["channelName"],
                                                  style: TextStyle(
                                                    color: Color(0xFF11120e),
                                                    fontSize: 16,
                                                  ),
                                                );
                                              } else if (state
                                              is GetTawasolInfoInitState) {
                                                return Container();
                                              } else {
                                                return Container();
                                              }
                                            },
                                          ),
                                        ),
                                      ])),
                            ):
                            Container(
                              color: Colors.white,
                              child: Center(
                                  child: ListView(
                                      physics: ClampingScrollPhysics(),
                                      shrinkWrap: true,
                                      children: [
                                        ListTile(
                                          leading: CircleAvatar(
                                            backgroundImage: AssetImage(
                                                'assets/images/imageprofile.png'),
                                          ),
                                          title: Text(
                                            widget.outDoorUserName,
                                            style: TextStyle(
                                              color: Color(0xFF11120e),
                                              fontSize: 16,
                                            ),
                                          )
                                          ),

                                      ])),
                            ),
                            widget.Permessions.contains('01.01')?Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 10, top: 3, bottom: 15),
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "DashBoard_Form.contracts_status".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xFF11120e),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ):Container(),
                            widget.Permessions.contains('01.01')?
                            BlocBuilder<
                                GetSubdealerLineDocProgressCurrentCountRqBloc,
                                GetSubdealerLineDocProgressCurrentCountRqState>(
                              builder: (context, state) {
                                var totalAccepted = '0';
                                var totalRejected = '0';
                                var totalPending = '0';
                                if (state is GetSubdealerLineDocProgressCurrentCountRqSuccessState ||
                                    state
                                    is GetSubdealerLineDocProgressCurrentCountRqLoadingState ||
                                    state
                                    is GetSubdealerLineDocProgressCurrentCountRqErrorState) {
                                  if (state
                                  is GetSubdealerLineDocProgressCurrentCountRqSuccessState) {
                                    totalAccepted =
                                    state.data['data']['totalHelloJoApproved'];
                                    totalRejected =
                                    state.data['data']['totalDealerRejected'];
                                    totalPending =
                                    state.data['data']['totalPending'];
                                  }
                                  return Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: ListView(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: ListTile(
                                                leading: Container(
                                                  width: 160,
                                                  child: Text(
                                                    "DashBoard_Form.accepted_contracts"
                                                        .tr()
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color(0xff11120e),
                                                        fontWeight:
                                                        FontWeight.normal),
                                                  ),
                                                ),
                                                title: Text(
                                                  totalAccepted,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff11120e),
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                                // trailing: IconButton(
                                                //   icon: EasyLocalization.of(context).locale ==
                                                //       Locale("en", "US")
                                                //       ? Icon(Icons.keyboard_arrow_right)
                                                //       : Icon(Icons.keyboard_arrow_left),
                                                //
                                                // ),
                                                // onTap: ( ) {
                                                //       Navigator.push(
                                                //       context,
                                                //       MaterialPageRoute(
                                                //       builder: (context) =>
                                                //       AcceptedContracts()),
                                                //       );
                                                //       },
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Color(0xFFedeff3),
                                            ),
                                            widget.Permessions.contains('01.01.01')?SizedBox(
                                              height: 50,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 160,
                                                    child: Text(
                                                      "DashBoard_Form.rejected_contracts"
                                                          .tr()
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff11120e),
                                                          fontWeight:
                                                          FontWeight.normal),
                                                    )),
                                                title: Text(
                                                  totalRejected,
                                                ),
                                                trailing:  IconButton(
                                                  icon: EasyLocalization.of(context)
                                                      .locale ==
                                                      Locale("en", "US")
                                                      ? Icon(Icons
                                                      .keyboard_arrow_right)
                                                      : Icon(Icons
                                                      .keyboard_arrow_left),
                                                ),
                                                onTap: totalRejected == '0'
                                                    ? null
                                                    : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            RejectedContracts(Permessions:widget.Permessions,role:widget.role,outDoorUserName:widget.outDoorUserName)),
                                                  );
                                                },
                                              ),
                                            ):Container(),
                                            widget.Permessions.contains('01.01.01')?Divider(
                                              thickness: 1,
                                              color: Color(0xFFedeff3),
                                            ):Container(),
                                            widget.Permessions.contains('01.01.03')?SizedBox(
                                              height: 55,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 160,
                                                    child: Text(
                                                      "DashBoard_Form.pending_contracts"
                                                          .tr()
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff11120e),
                                                          fontWeight:
                                                          FontWeight.normal),
                                                    )),
                                                title: Text(
                                                  totalPending,
                                                ),
                                                trailing: IconButton(
                                                  icon: EasyLocalization.of(context)
                                                      .locale ==
                                                      Locale("en", "US")
                                                      ? Icon(Icons
                                                      .keyboard_arrow_right)
                                                      : Icon(Icons
                                                      .keyboard_arrow_left),
                                                ),
                                                onTap: totalPending == '0'
                                                    ? null
                                                    : () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            PendingContracts(Permessions:widget.Permessions,role:widget.role,outDoorUserName:widget.outDoorUserName)),
                                                  );
                                                },
                                              ),
                                            ):Container(),
                                          ]),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ):
                            Container(),
                            widget.Permessions.contains('01.02')?Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 10, top: 3, bottom: 15),
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "DashBoard_Form.tawasol_balances".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xFF11120e),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ):Container(),
                            widget.Permessions.contains('01.02')?BlocBuilder<GetTawasolInfoBloc, GetTawasolInfoState>(
                              builder: (context, state) {
                                var subdealerCurrentHSPABalance = '0';
                                var subdealerCurrentBalance = '0';
                                if (state is GetTawasolInfoSuccessState ||
                                    state is GetTawasolInfoInitState ||
                                    state is GetTawasolInfoLoadingState ||
                                    state is GetTawasolInfoErrorState) {
                                  if (state is GetTawasolInfoSuccessState) {
                                    subdealerCurrentHSPABalance = state.data['data']
                                    ['tawasol']['subdealerCurrentHSPABalance'];
                                    subdealerCurrentBalance = state.data['data']
                                    ['tawasol']['subdealerCurrentBalance'];
                                  }

                                  return Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: ListView(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: ListTile(
                                                leading: Container(
                                                  width: 160,
                                                  child: Text(
                                                    "DashBoard_Form.data"
                                                        .tr()
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color(0xff11120e),
                                                        fontWeight:
                                                        FontWeight.normal),
                                                  ),
                                                ),
                                                title: Text(
                                                  subdealerCurrentHSPABalance,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff11120e),
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Color(0xFFedeff3),
                                            ),
                                            SizedBox(
                                              height: 55,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 160,
                                                    child: Text(
                                                      "DashBoard_Form.gsm"
                                                          .tr()
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff11120e),
                                                          fontWeight:
                                                          FontWeight.normal),
                                                    )),
                                                title: Text(
                                                  subdealerCurrentBalance,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  );
                                } else if (state is GetTawasolInfoInitState) {
                                  return Container();
                                } else {
                                  return Container();
                                  ;
                                }
                              },
                            ):Container(),
                            widget.Permessions.contains('01.03')?Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 10, top: 3, bottom: 15),
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "DashBoard_Form.Current_month_sales"
                                    .tr()
                                    .toString(),
                                style: TextStyle(
                                  color: Color(0xFF11120e),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ):Container(),
                            widget.Permessions.contains('01.03')?BlocBuilder<GetTawasolInfoBloc, GetTawasolInfoState>(
                              builder: (context, state) {
                                var gsmAcc = '0';
                                var gsmPen = '0';
                                var gsmRej = '0';
                                var dataPen = '0';
                                var dataAcc = '0';
                                var dataRej = '0';

                                if (state is GetTawasolInfoSuccessState ||
                                    state is GetTawasolInfoLoadingState ||
                                    state is GetTawasolInfoInitState ||
                                    state is GetTawasolInfoErrorState) {
                                  if (state is GetTawasolInfoSuccessState) {
                                    print('dashboard');
                                    print(state.data['data']
                                    ['registered']);
                                    for (var obj in state.data['data']
                                    ['registered']) {
                                      if (obj['subMarket'] == "GSM") {
                                        if (obj['statusId'] == '0') {
                                          gsmPen = obj["total"];
                                         // GSM_PEN_N=  int.parse(GSM_PEN.toString());
                                          GSM_PEN_N = gsmPen!=null? int.parse(gsmPen):0;
                                        } else if (obj['statusId'] == '1') {
                                          gsmAcc = obj["total"];
                                        //  GSM_ACC_N =int.parse(GSM_ACC.toString());
                                          GSM_ACC_N = gsmAcc!=null? int.parse(gsmAcc):0;
                                        } else if (obj['statusId'] == '2') {
                                          gsmRej = obj["total"];
                                          GSM_REJ_N = gsmRej!=null? int.parse(gsmRej):0;
                                          print("GSM_REJ_N");
                                          print(GSM_REJ_N);
                                        }
                                      } else if (obj['subMarket'] == "HSPA") {
                                        if (obj['statusId'] == '0') {
                                          dataPen = obj["total"];
                                          DATA_PEN_N= dataPen!=null?int.parse(dataPen):0;
                                        }
                                        else if (obj['statusId'] == '1') {
                                          dataAcc = obj["total"];
                                          DATA_ACC_N= dataAcc !=null?int.parse(dataAcc):0;
                                        }
                                        else if (obj['statusId'] == '2') {
                                          dataRej = obj["total"];
                                          DATA_REJ_N= dataRej!=null?int.parse(dataRej):0;
                                          print("DATA_REJ_N");
                                          print(DATA_REJ_N);

                                        }
                                      }
                                    }
                                  }
                                  return Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: ListView(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: ListTile(
                                                leading: Container(
                                                  width: 160,
                                                  child: Text(
                                                    "DashBoard_Form.accepted"
                                                        .tr()
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color(0xff11120e),
                                                        fontWeight:
                                                        FontWeight.normal),
                                                  ),
                                                ),
                                                title: Text(
                                                  (GSM_ACC_N+DATA_ACC_N).toString()
                                                  ,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff11120e),
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Color(0xFFedeff3),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 160,
                                                    child: Text(
                                                      "DashBoard_Form.rejected"
                                                          .tr()
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff11120e),
                                                          fontWeight:
                                                          FontWeight.normal),
                                                    )),
                                                title: Text(
                                                    (GSM_REJ_N+DATA_REJ_N).toString()

                                                ),
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Color(0xFFedeff3),
                                            ),
                                            SizedBox(
                                              height: 55,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 160,
                                                    child: Text(
                                                      "DashBoard_Form.pending"
                                                          .tr()
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff11120e),
                                                          fontWeight:
                                                          FontWeight.normal),
                                                    )),
                                                title: Text(
                                                  (GSM_PEN_N+DATA_PEN_N).toString()
                                                  ,
                                                ),
                                              ),
                                            ),
                                          ]),
                                    ),
                                  );
                                } else {
                                  return null;
                                }
                              },
                            ):Container(),
///////////////////////////////////////////////////////////////////PostPaid Part/////////////////////////////////////////
                            widget.Permessions.contains('01.04')?Container(
                              padding: EdgeInsets.only(
                                  left: 16, right: 10, top: 3, bottom: 15),
                              margin: EdgeInsets.only(top: 20),
                              child: Text(
                                "DashBoard_Form.Current_month_sales_postpaid".tr().toString(),
                                style: TextStyle(
                                  color: Color(0xFF11120e),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ):Container(),

                            widget.Permessions.contains('01.04')?BlocBuilder<
                                PostpaidStatisticsBlock,
                                GetPostpaidStatisticsState>(
                                 builder: (context, state) {
                                var totalAccepted = '0';
                                var totalRejected = '0';
                                var totalPending = '0';
                                if (state is GetPostpaidStatisticsSuccessState ||
                                    state
                                    is GetPostpaidStatisticsLoadingState ||
                                    state
                                    is GetPostpaidStatisticsErrorState) {
                                  if (state
                                  is GetPostpaidStatisticsSuccessState) {
                                    totalAccepted =
                                    state.data['data']['totalAccepted'].toString();
                                    totalRejected =
                                    state.data['data']['totalRejected'].toString();
                                    totalPending =
                                    state.data['data']['totalPending'].toString();
                                  }
                                  return Container(
                                    color: Colors.white,
                                    child: Center(
                                      child: ListView(
                                          physics: ClampingScrollPhysics(),
                                          shrinkWrap: true,
                                          children: [
                                            SizedBox(
                                              height: 50,
                                              child: ListTile(
                                                leading: Container(
                                                  width: 160,
                                                  child: Text(
                                                    "DashBoard_Form.accepted"
                                                        .tr()
                                                        .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Color(0xff11120e),
                                                        fontWeight:
                                                        FontWeight.normal),
                                                  ),
                                                ),
                                                title: Text(
                                                  totalAccepted,
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Color(0xff11120e),
                                                      fontWeight:
                                                      FontWeight.normal),
                                                ),

                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Color(0xFFedeff3),
                                            ),
                                            SizedBox(
                                              height: 50,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 160,
                                                    child: Text(
                                                      "DashBoard_Form.rejected"
                                                          .tr()
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff11120e),
                                                          fontWeight:
                                                          FontWeight.normal),
                                                    )),
                                                title: Text(
                                                  totalRejected,
                                                ),


                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Color(0xFFedeff3),
                                            ),
                                            SizedBox(
                                              height: 55,
                                              child: ListTile(
                                                leading: Container(
                                                    width: 160,
                                                    child: Text(
                                                      "DashBoard_Form.pending"
                                                          .tr()
                                                          .toString(),
                                                      style: TextStyle(
                                                          fontSize: 16,
                                                          color: Color(0xff11120e),
                                                          fontWeight:
                                                          FontWeight.normal),
                                                    )),
                                                title: Text(
                                                  totalPending,
                                                ),


                                              ),
                                            ),
                                          ]),
                                    ),
                                  );
                                } else {
                                  return Container();
                                }
                              },
                            ):Container(),

                          ]),
                    );
                  }
                })),
      ),
    );
  }
}

