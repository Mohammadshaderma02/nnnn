import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../main.dart';
import '../../../../ReusableComponents/requiredText.dart';
import 'package:http/http.dart' as http;

import '../../../Corporate/MainPages/Home/AccountManager/ClientMessages.dart';
import 'add_darak_log_visit_screen.dart';
import 'logVisitDetails.dart';

class DarakLogVisitScreen extends StatefulWidget {
  @override
  _DarakLogVisitScreenState createState() => _DarakLogVisitScreenState();
}

class _DarakLogVisitScreenState extends State<DarakLogVisitScreen> {
  final TextEditingController msisdnController = TextEditingController();
  ScrollController scrollController = ScrollController();

  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

  bool isMsisdnFilled = false;
  bool isFromDateFilled = false;
  bool isToDateFilled = false;

  bool showValidationError = false;
  bool isDataSearched = false;
  String fromDateApiFormat = "";
  String toDateApiFormat = "";
  List<dynamic> logs = [];
  bool isInitLoading = false;

  void clearMsisdn() {
    msisdnController.clear();
  }
  void clearFromDate(){
    fromDate.clear();
  }
  void clearToDate(){
    toDate.clear();
  }

  void _validateAndSubmitSearch() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    FocusScope.of(context).unfocus();

    String msisdn = msisdnController.text.trim();
    String fromText = fromDate.text.trim();
    String toText = toDate.text.trim();

    isMsisdnFilled = msisdn.isNotEmpty;
    isFromDateFilled = fromText.isNotEmpty;
    isToDateFilled = toText.isNotEmpty;

    final bool canSearch =
        isMsisdnFilled || (isFromDateFilled && isToDateFilled);

    if (!canSearch) {
      setState(() {
        showValidationError = true;
      });
      return;
    }

    setState(() {
      showValidationError = false;
      isInitLoading = true;
      isDataSearched = false;
      logs.clear();
    });

    try {
      // ✅ Format from/to dates for API
      String fromDateApiFormat = "";
      String toDateApiFormat = "";

      if (isFromDateFilled) {
        DateTime parsedFrom = DateFormat("dd/MM/yyyy").parse(fromText);
        fromDateApiFormat =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(parsedFrom);
      }

      if (isToDateFilled) {
        DateTime parsedTo = DateFormat("dd/MM/yyyy").parse(toText);
        toDateApiFormat =
            DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'").format(parsedTo);
      }

      final body = {
        "msisdn": msisdn,
        "customerId": "",
        "fromDate": fromDateApiFormat == '' ? null : fromDateApiFormat,
        "toDate": toDateApiFormat == '' ? null : toDateApiFormat,
      };

      debugPrint("Sending API request with body: $body");

      var apiArea = urls.BASE_URL + '/Customer360/getDynamicsVisitsHistory';
      final Uri url = Uri.parse(apiArea);

      final response = await http.post(
        url,
        headers: {
          "Content-Type": "application/json",
          "Authorization": prefs.getString("accessToken") ?? "",
        },
        body: jsonEncode(body),
      );

      debugPrint("API body: $body");
      final result = jsonDecode(response.body);
      debugPrint("API Response: $result");

      if (response.statusCode == 200 && result['status'] == 0) {
        List<dynamic> data = result['data'];

        if (data != null && data.isNotEmpty) {
          List<dynamic> newLogs = [];

          newLogs = result['data'];

          setState(() {
            logs = newLogs;
          });
        } else {
          setState(() {
            logs = [];
          });
        }
      } else if (response.statusCode == 200 && result['status'] != 0) {
        setState(() {
          logs = [];
          isDataSearched = false;
          isInitLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "No Data Found",
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.grey,
            behavior: SnackBarBehavior.floating,
            duration: Duration(seconds: 3),
          ),
        );
      } else if (response.statusCode != 200) {
        SnackBar(
          content: Text(
            "Some thing went wrong",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.grey,
          behavior: SnackBarBehavior.floating,
          duration: Duration(seconds: 3),
        );
      }
    } catch (e) {
      debugPrint("Error fetching logs: $e");
    } finally {
      setState(() {
        isInitLoading = false;
        isDataSearched = true;
      });
    }
  }

  Widget buildMSISDN() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: "Menu_Form.msisdn".tr().toString(),
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
            InkWell(
              child: Text(EasyLocalization.of(context).locale == Locale("en", "US") ? "Clear" : "ازالة", style: TextStyle(color: Color(0xFF5A6F84))) ,
              onTap: (){ clearMsisdn();},
            ),

          ],
        ),

        SizedBox(height: 10),

        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            maxLength: 10,
            buildCounter: (BuildContext context,
                {int currentLength, int maxLength, bool isFocused}) =>
            null,
            controller: msisdnController,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFF5A6F84)),
            decoration: InputDecoration(
              enabledBorder:
              (showValidationError && msisdnController.text.trim().isEmpty)
                  ? OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFB10000)))
                  : OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFD1D7E0))),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              hintText: "Postpaid.enter_msisdn".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
          ),
        ),

      ],
    );
  }

  Widget buildFromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: "Reports.from".tr().toString(),
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
            InkWell(
              child: Text(EasyLocalization.of(context).locale == Locale("en", "US") ? "Clear" : "ازالة", style: TextStyle(color: Color(0xFF5A6F84))) ,
              onTap: (){ clearFromDate();},
            )

        ],),

        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          // color: Colors.purpleAccent,
          child: TextField(
            controller: fromDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder:
                  (showValidationError && fromDate.text.trim().isEmpty)
                      ? OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFB10000)))
                      : OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFD1D7E0))),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/icon-calendar.png"),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(DateTime.now().year,
                            DateTime.now().month, DateTime.now().day - 60),
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
                              from = fromData;
                              fromDate.text =
                                  "${fromData.day.toString().padLeft(2, '0')}/${fromData.month.toString().padLeft(2, '0')}/${fromData.year.toString()}";
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

  Widget buildToDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            RichText(
              text: TextSpan(
                text: "Reports.to".tr().toString(),
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
            InkWell(
              child: Text(EasyLocalization.of(context).locale == Locale("en", "US") ? "Clear" : "ازالة", style: TextStyle(color: Color(0xFF5A6F84))) ,
              onTap: (){ clearToDate();},
            ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          // color: Colors.purpleAccent,
          child: TextField(
            controller: toDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder: (showValidationError && toDate.text.trim().isEmpty)
                  ? OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFB10000)))
                  : OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD1D7E0))),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
              ),
              contentPadding: EdgeInsets.all(16),
              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/icon-calendar.png"),
                    onPressed: fromDate == ''
                        ? null
                        : () async {
                            showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate:
                                  DateTime(from.year, from.month, from.day),
                              lastDate: DateTime.now(),
                              builder: (BuildContext context, Widget child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    colorScheme: ColorScheme.light(
                                      primary: Color(0xFF4f2565),
                                      onPrimary:
                                          Colors.white, // header text color
                                      onSurface:
                                          Colors.black, // body text color
                                    ),
                                    textButtonTheme: TextButtonThemeData(
                                      style: TextButton.styleFrom(
                                        primary: Color(
                                            0xFF4f2565), // button text color
                                      ),
                                    ),
                                  ),
                                  child: child,
                                );
                              },
                            ).then((toData) => {
                                  setState(() {
                                    to = toData;
                                    toDate.text =
                                        "${toData.day.toString().padLeft(2, '0')}/${toData.month.toString().padLeft(2, '0')}/${toData.year.toString()}";
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

  Widget buildLogsList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      padding: EdgeInsets.only(top: 8, left: 0, right: 0),
      itemCount: logs.length,
      itemBuilder: (BuildContext context, int index) {
        final log = logs[index];

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => LogDetailsScreen(logData: log),
              ),
            );
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: Colors.white,
            ),
            margin: EdgeInsets.only(bottom: 15),
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 15, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// TOP ROW WITH ARROW ICON
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Visit #${index + 1}",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Icon(Icons.arrow_forward_ios, size: 18),
                  ],
                ),

                SizedBox(height: 10),

                buildLabel("SubscriberView.Actions".tr(), log['actions'] ?? ""),
                buildLabel("SubscriberView.visitDescription".tr(),
                    log['visitDescription']),
              ],
            ),
          ),
        );
      },
    );
  }
  
  Widget buildLabel(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${label}' +
                ":  " +
                '${value != null && value.isNotEmpty ? value : '--'}',
            style: TextStyle(
              color: Color(0xff11120e),
              fontSize: 14,
              fontWeight: FontWeight.normal,
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFEBECF1),
      appBar: AppBar(
        title: Text('Darak Log Visit'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          physics: ClampingScrollPhysics(),
          controller: scrollController,
          shrinkWrap: true,

          children: [

           Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.white,
              ),
              padding: EdgeInsets.only(top: 0,bottom: 10,left: 12,right: 12),
             child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [
                  SizedBox(
                    height: 20,
                  ),
                  buildMSISDN(),
                  SizedBox(
                    height: 20,
                  ),
                  buildFromDate(),
                  SizedBox(
                    height: 20,
                  ),
                  buildToDate(),
                  SizedBox(
                    height: 10,
                  ),
                  showValidationError == true
                      ? ReusableRequiredText(
                      text: EasyLocalization.of(context).locale ==
                          Locale("en", "US")
                          ? "You need to insert msisdn or dates"
                          : "يجب عليك إدخال msisdn أو التواريخ ")
                      : Container(),
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    height: 48,
                    width: 420,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xFF4f2565),
                    ),
                    child: TextButton(
                      onPressed: _validateAndSubmitSearch,
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF4f2565),
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24))),
                      ),
                      child: Text(
                        "Menu_Form.Search".tr().toString(),
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 48,
                    width: 420,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xFF4f2565),
                    ),
                    child: TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => AddDarakLogVisitScreen(),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Color(0xFF4f2565),
                        shape: const BeveledRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(24))),
                      ),
                      child: Text(
                        "Menu_Form.Add".tr().toString(),
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              )
             ),




            isInitLoading
                ? Container(
                    padding: EdgeInsets.only(top: 16),
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
                  )
                : isDataSearched
                    ? buildLogsList()
                    : Container()
          ],
        ),
      ),
    );
  }
}
