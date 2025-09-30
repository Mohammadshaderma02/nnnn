import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TicketHistory extends StatefulWidget {
  List<dynamic> Permessions=[];
  var role;
  var outDoorUserName;
  TicketHistory({this.Permessions,this.role,this.outDoorUserName});
  @override
  _TicketHistoryState createState() => _TicketHistoryState(this.Permessions,this.role,this.outDoorUserName);
}

class _TicketHistoryState extends State<TicketHistory> {
  List<dynamic> Permessions=[];
  var role;
  var outDoorUserName;
  _TicketHistoryState(this.Permessions,this.role,this.outDoorUserName);
  ScrollController scrollController = ScrollController();
  APP_URLS urls = new APP_URLS();

  bool emptyfromDate = false;
  bool emptytoDate = false;
  bool invalidtoDate = false;
  bool isLoading = false;
  bool allLoaded = false;
  bool isInitLoading = false;
  List<dynamic> UserList = [];
  bool ErrorFlag = false;
  bool emptyList = false;
  String arabicMessage = '';
  String englishMessage = '';
  int page = 1;
  TextEditingController fromDate = TextEditingController();
  TextEditingController toDate = TextEditingController();
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

  @override
  void initState() {
    super.initState();
    setupScrollController(context);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent &&
            !isLoading) {
          page++;
          //BlocProvider.of<GetPendingLineDocQueueBloc>(context);
          //  callApi(page);
        }
      }
    });
  }

  void callApi(int page) async {
    if (allLoaded) {
      return;
    }
    setState(() {
      isLoading = true;
    });

    var url =  urls.BASE_URL+'/MenaTracks/tickets?FromDate=${from.year.toString().padLeft(2, '0')}-${from.month.toString().padLeft(2, '0')}-${from.day.toString()}&ToDate=${to.year.toString().padLeft(2, '0')}-${to.month.toString().padLeft(2, '0')}-${to.day.toString()}';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    if (statusCode == 200) {
      var result = json.decode(response.body);
      if (result['status'] == 0) {
        List<dynamic> list = result['data'];
        print(list);
        if (list.isNotEmpty) {
          list.map((data) => UserList.add(data)).toList();
        }
        if (UserList.length == 0) {
          setState(() {
            emptyList = true;
          });
        }
        await Future.delayed(Duration(milliseconds: 500));
        setState(() {
          isLoading = false;
          allLoaded = list.isEmpty;
          //
          // UserList =UserList;
        });
        setState(() {
          isInitLoading = false;
        });
      } else {
        setState(() {
          arabicMessage = result['messageAr'];
          englishMessage = result['message'];
          ErrorFlag = true;
        });
      }
    }
    if (statusCode == 401) {
      UnotherizedError();
    }
  }

  Widget buildFromDate() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
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
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          height: 58,
          child: TextField(
            controller: fromDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder: emptyfromDate == true
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
              contentPadding: EdgeInsets.all(16),
              suffixIcon: Container(
                child: IconButton(
                    icon: new Image.asset("assets/images/icon-calendar.png"),
                    onPressed: () async {
                      showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(2000,
                        ),
                        lastDate:DateTime(DateTime.now().year+20,
                        ),
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
              hintText: "Test.dd/mm/yyyy".tr().toString(),
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
        RichText(
          text: TextSpan(
            text: "Test.to".tr().toString(),
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
            controller: toDate,
            readOnly: true,
            keyboardType: TextInputType.name,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: new InputDecoration(
              enabledBorder: emptytoDate == true
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
                        lastDate:DateTime(DateTime.now().year+20),
                        builder: (BuildContext context, Widget child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: ColorScheme.light(
                                primary: Color(
                                    0xFF4f2565), // header background color
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
              hintText: "Test.dd/mm/yyyy".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
      ],
    );
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
  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
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
            Navigator.pop(context, true);
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

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),

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
              "Test.ticket_history".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          // bottomNavigationBar: CustomBottomNavigationBar(),
          body: ListView(
            physics: ClampingScrollPhysics(),
            controller: scrollController,
            shrinkWrap: true,
            padding: EdgeInsets.only(top: 8),
            children: <Widget>[
          Container(
          color: Colors.white,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20),
                  buildFromDate(),
                  emptyfromDate
                      ? ReusableRequiredText(
                      text: "Postpaid.this_feild_is_required"
                          .tr()
                          .toString())
                      : Container(),
                  SizedBox(height: 20),
                  buildToDate(),
                  emptytoDate
                      ? ReusableRequiredText(
                      text: "Postpaid.this_feild_is_required"
                          .tr()
                          .toString())
                      : Container(),
                  invalidtoDate
                      ? ReusableRequiredText(
                      text: "Basic_Info_Edit.this_feild_is_required"
                          .tr()
                          .toString())
                      : Container(),
                  SizedBox(height: 20),
                  Container(
                    height: 48,
                    width: 420,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      color: Color(0xFF4f2565),
                    ),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor:Color(0xFF4f2565),
                        shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                      ),
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        setState(() {
                          UserList = [];
                          allLoaded = false;
                        });
                        if (fromDate.text == '') {
                          setState(() {
                            emptyfromDate = true;
                          });
                        }
                        if (fromDate.text != '') {
                          setState(() {
                            emptyfromDate = false;
                          });
                        }
                        if (toDate.text == '') {
                          setState(() {
                            emptytoDate = true;
                          });
                        }
                        if (toDate.text != '') {
                          setState(() {
                            emptytoDate = false;
                          });
                        }

                        if (fromDate.text != '' && toDate.text != '') {
                          final difference = to.difference(from).inDays;

                          callApi(1);
                          setState(() {
                            isInitLoading = true;
                          });
                        }
                      },

                      child: Text(
                        "Test.search".tr().toString(),
                        style: TextStyle(
                            color: Colors.white,
                            letterSpacing: 0,
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
          isInitLoading == true
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
              : ErrorFlag == true
              ? AlertDialog(
            content: Text(
              EasyLocalization.of(context).locale ==
                  Locale("en", "US")
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
                  setState(() {
                    ErrorFlag = false;
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
          )
              : Container(
            padding: EdgeInsets.only(bottom: 16),
            /* padding: allLoaded
                    ? EdgeInsets.only(bottom: 16)
                    : EdgeInsets.only(bottom: 0),*/
            child: emptyList == true
                ? Container(
              padding: EdgeInsets.only(top: 16),
              width: MediaQuery.of(context).size.width,
              child: Container(
                color: Colors.white,
                padding: EdgeInsets.only(
                    top: 16, left: 16, right: 16, bottom: 16),
                alignment:
                EasyLocalization.of(context).locale ==
                    Locale("en", "US")
                    ? Alignment.centerLeft
                    : Alignment.centerRight,
                width: MediaQuery.of(context).size.width,
                child: Text(
                  EasyLocalization.of(context).locale ==
                      Locale("en", "US")
                      ? "No tickets found"
                      : "Ù„Ø§ ÙŠÙˆØ¬Ø¯ Ø´ÙƒØ§ÙˆÙŠ",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff778ca2),
                      fontWeight: FontWeight.normal),
                ),
              ),
            )
                : Stack(children: [
                ListView.builder(
                physics: ClampingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            padding: EdgeInsets.only(top: 8),
            itemCount: UserList.length,
            itemBuilder: (context, index) {
              return Container(
                  padding: EdgeInsets.only(top: 20),
                  alignment: Alignment.centerLeft,
                  child: Column(
                    children: [
                      Container(
                          alignment:
                          EasyLocalization.of(context)
                              .locale ==
                              Locale("en", "US")
                              ? Alignment.centerLeft
                              : Alignment.centerRight,
                          padding: EdgeInsets.only(
                              left: 15, right: 15),
                          child: UserList[index]
                          ['refcode'] !=
                              null
                              ? Text(
                            "Test.ticket_number"
                                .tr()
                                .toString() +
                                " " +
                                '${UserList[index]['refcode']}',
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(
                                    0xff11120e),
                                fontWeight:
                                FontWeight
                                    .normal),
                          )
                              : Text(
                            "Test.ticket_number"
                                .tr()
                                .toString() +
                                " ",
                            style: TextStyle(
                                fontSize: 16,
                                color: Color(
                                    0xff11120e),
                                fontWeight:
                                FontWeight
                                    .normal),
                          )),
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.only(
                            left: 15, right: 15),
                        color: Colors.white,
                        width: MediaQuery.of(context)
                            .size
                            .width,
                        child: Column(children: [
                          Container(
                              alignment: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8),
                              child: UserList[index]
                              ['description'] !=
                                  null
                                  ? Text(
                                "Test.ticket_description"
                                    .tr()
                                    .toString() +
                                    " " +
                                    '${UserList[index]['description']}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xff11120e),
                                    fontWeight:
                                    FontWeight
                                        .normal),
                              )
                                  : Text(
                                "Test.ticket_description"
                                    .tr()
                                    .toString() +
                                    " ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xff11120e),
                                    fontWeight:
                                    FontWeight
                                        .normal),
                              )),
                          Container(
                              alignment: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8),
                              child: UserList[index]
                              ['submitDate'] !=
                                  null
                                  ? Text(
                                "Test.ticket_date"
                                    .tr()
                                    .toString() +
                                    " " +
                                    '${UserList[index]['submitDate']}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xff11120e),
                                    fontWeight:
                                    FontWeight
                                        .normal),
                              )
                                  : Text(
                                "Test.ticket_date"
                                    .tr()
                                    .toString() +
                                    " ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xff11120e),
                                    fontWeight:
                                    FontWeight
                                        .normal),
                              )),
                          Container(
                              alignment: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8),
                              child: UserList[index][
                              'Dealer Name'] !=
                                  null
                                  ? Text(
                                "Test.dealer_name"
                                    .tr()
                                    .toString() +
                                    " " +
                                    '${UserList[index]['Dealer Name']}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xff11120e),
                                    fontWeight:
                                    FontWeight
                                        .normal),
                              )
                                  : Text(
                                "Test.dealer_name"
                                    .tr()
                                    .toString() +
                                    " ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xff11120e),
                                    fontWeight:
                                    FontWeight
                                        .normal),
                              )),
                          Container(
                              alignment: EasyLocalization
                                  .of(context)
                                  .locale ==
                                  Locale("en", "US")
                                  ? Alignment.centerLeft
                                  : Alignment.centerRight,
                              padding: EdgeInsets.only(
                                  top: 8, bottom: 8),
                              child: UserList[index]
                              ['status'] !=
                                  null
                                  ? Text(
                                "Test.status"
                                    .tr()
                                    .toString() +
                                    " " +
                                    '${UserList[index]['status']}',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xff11120e),
                                    fontWeight:
                                    FontWeight
                                        .normal),
                              )
                                  : Text(
                                "Test.status"
                                    .tr()
                                    .toString() +
                                    " ",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Color(
                                        0xff11120e),
                                    fontWeight:
                                    FontWeight
                                        .normal),
                              )),

                        ]),
                      )
                    ],
                  ));
            },
          ),
          if (isLoading) ...[
      Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
      height: 100,
      child: Padding(
      padding:
      const EdgeInsets.only(bottom: 13),
      child: Center(
      child: Container(
      child: Center(
      child:
      CircularProgressIndicator(
      valueColor:
      AlwaysStoppedAnimation<
      Color>(
      Color(0xFF4f2565)),
      )),
      ),
      )),
      ),
      )
      ]
      ]),
      )
      ]),
      ),
    );
  }
}