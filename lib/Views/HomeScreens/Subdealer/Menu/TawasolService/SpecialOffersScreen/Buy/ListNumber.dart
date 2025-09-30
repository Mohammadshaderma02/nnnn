import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/BuyNumber/BuyNumber_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyNumber/BuyNumber_block.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyNumber/BuyNumber_events.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/TawasolService/SpecialOffersScreen/Buy/Buy.dart';


import '../../../../CustomBottomNavigationBar.dart';


class ListNumber extends StatefulWidget {

  final String categoryID;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  ListNumber({this.categoryID,this.Permessions,this.role,this.outDoorUserName});

  @override
  _ListNumberState createState() => _ListNumberState(this.categoryID,this.Permessions,this.role,this.outDoorUserName);
}

class _ListNumberState extends State<ListNumber> {
  final String categoryID;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _ListNumberState(this.categoryID,this.Permessions,this.role,this.outDoorUserName);
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

  /***********Tow variable for select Payment Method****************/
  bool TawasolBalance = false;
  bool EVD = false;
  /******************************************************************/
  TextEditingController merchantID = TextEditingController();
  TextEditingController terminalID = TextEditingController();
  TextEditingController otp = TextEditingController();

  bool emptyMerchantID = false;
  bool emptyTerminalID = false;
  bool emptyOTP = false;

  String paymentMethod;
  String MSISDN;
  String operationReference;


  /*void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels >= scrollController.position.maxScrollExtent && !isLoading) {
          page++;
          print(page);

          callApi(page);
        }
      }
    });
  }*/
  BuyNumberBloc buyNumberBloc;

  @override
  void initState() {
    buyNumberBloc = BlocProvider.of<BuyNumberBloc>(context);
    print(widget.categoryID);
    callApi();
  //setupScrollController(context);
    super.initState();
  }

  final msg = BlocBuilder<BuyNumberBloc,
      BuyNumberState>(builder: (context, state) {
    if (state is BuyNumberLoadingState) {
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
    if(allLoaded){
      return ;
    }setState(() {
      isLoading=true;
    });
    var url = urls.BASE_URL+'/Lines/special-number/list/${widget.categoryID}';

    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
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


  Widget enterMerchantID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "merchantID",
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
          height: 70,
          child: TextField(
            // maxLength: 10,
           // enabled: checkLine==true?false:true,
            controller: merchantID,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyMerchantID == true
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
              contentPadding: EdgeInsets.all(16),
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){
              setState(() {
                emptyMerchantID=false;

              });
            },
            onChanged: (MerchantID){

              if (MerchantID.length != 0) {
                setState(() {
                  emptyMerchantID=false;

                });


              }
              else {
                setState(() {
                  emptyMerchantID=true;
                });
              }
            },
          ),
        ),


      ],
    );
  }


  Widget enterTerminalID() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "terminalID",
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
          height: 70,
          child: TextField(
            // maxLength: 10,
            // enabled: checkLine==true?false:true,
            controller: terminalID,
            keyboardType: TextInputType.text,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              filled: true,
              fillColor:Colors.white,
              enabledBorder: emptyTerminalID == true
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
              contentPadding: EdgeInsets.all(16),
              hintText: "xxxxxxxxxx",
              hintStyle: TextStyle(color: Color(0xFFA4B0C1), fontSize: 14),
            ),
            onTap: (){
              setState(() {
                emptyTerminalID=false;

              });
            },
            onChanged: (MerchantID){

              if (MerchantID.length != 0) {
                setState(() {
                  emptyTerminalID=false;
                });
              }
              else {
                setState(() {
                  emptyTerminalID=true;
                });
              }
            },
          ),
        ),


      ],
    );
  }


  void specialNumberInitalize()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var apiArea = urls.BASE_URL+'/Lines/special-number/initalize';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    print(url);

    Map body = {
      "msisdn":MSISDN,
      "paymentMethod": paymentMethod,
      "merchantID": merchantID.text,
      "terminalID": terminalID.text
    };

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: json.encode(body),);


    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(response);
    print('body: [${response.body}]');

    if (statusCode == 401) {
      print('401  error ');
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
            backgroundColor: Colors.red,
            // Change background color
          ));

    }

    if (statusCode == 200) {
      var result = json.decode(response.body);
      if( result["status"]==0){
        setState(() {
          operationReference=result["data"]["operationReference"];
        });

        if (EVD==true){

          ensirtOTP(context);

        }

        if (TawasolBalance==true){
          buyNumberBloc.add(
              BuyNumberPressed(
                msisdn:MSISDN,
               paymentMethod:paymentMethod,
               operationReference:operationReference,
               otp: otp.text
              ));
        }

      }else{
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
              backgroundColor: Colors.red,));
      }
      return result;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(EasyLocalization.of(context).locale == Locale("en", "US")?statusCode.toString():statusCode.toString()),
            backgroundColor: Colors.red,));
    }

  }

  void ensirtOTP(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "CustomerService.verify_code".tr().toString(),
          style: TextStyle(
            color: Color(0xff11120e),
            fontSize: 16,
          ),
        ),


        content: Container(
          width: double.maxFinite,
          height:  110,
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(
                child: ListView(
                  // shrinkWrap: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: ListTile(
                          contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                          title: Text(
                            "CustomerService.enter_OTP".tr().toString(),
                            style: TextStyle(
                              color: Color(0xff11120e),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 50,
                        child: ListTile(
                          contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 4),
                          title: TextField(
                            controller: otp,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              enabledBorder: emptyOTP == true
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
                                borderSide: const BorderSide(
                                    color: Color(0xFF4F2565), width: 1.0),
                              ),
                              contentPadding: EdgeInsets.all(16),
                              hintText:
                              "CustomerService.verify_hint".tr().toString(),
                              hintStyle: TextStyle(
                                  color: Color(0xFFA4B0C1), fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ]))
          ]),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
              setState(() {
                emptyOTP = false;
              });
            },
            child: Text(
              "CustomerService.Cancel".tr().toString(),
              style: TextStyle(
                color: Color(0xFF392156),
                fontSize: 16,
              ),
            ),
          ),

          TextButton(
            onPressed: () {
              if(otp.text ==""){
                setState(() {
                  emptyOTP = true;
                });
              }
              else{
                Navigator.pop(context, true);
                buyNumberBloc.add(
                    BuyNumberPressed(
                        msisdn:MSISDN,
                        paymentMethod:paymentMethod,
                        operationReference:operationReference,
                        otp: otp.text
                    ));
              }

            },
            child: Text(
              "CustomerService.verify".tr().toString(),
              style: TextStyle(
                color: Color(0xFF392156),
                fontSize: 16,
              ),
            ),
          ),


        ],
      ),
    );
  }


  void availableMethod(BuildContext context) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "Warning",
          style: TextStyle(
            color: Color(0xff11120e),
            fontSize: 16,
          ),
        ),


        content: Container(
          width: double.maxFinite,
          height:  110,
          child: Column(mainAxisSize: MainAxisSize.max, children: <Widget>[
            Expanded(
                child: ListView(
                  // shrinkWrap: false,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      SizedBox(
                        width: double.maxFinite,
                        height: 50,
                        child: ListTile(
                          contentPadding: new EdgeInsets.fromLTRB(4, 0, 4, 0),
                          title: Text(
                            "No Payment Method Available",
                            style: TextStyle(
                              color: Color(0xff11120e),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),

                    ]))
          ]),
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);

            },
            child: Text(
              "CustomerService.Cancel".tr().toString(),
              style: TextStyle(
                color: Color(0xFF392156),
                fontSize: 16,
              ),
            ),
          ),




        ],
      ),
    );
  }


  @override
  void dispose(){
    scrollController.dispose();
    super.dispose();
  }

  showAlertDialog(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.close".tr().toString(),
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
        tryAgainButton,
      ],
    );

    // show the dialog
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
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







  @override
  Widget build(BuildContext context) {
    return BlocListener<BuyNumberBloc, BuyNumberState>(
        listener: (context, state) {

          if (state is BuyNumberErrorState) {
            showAlertDialog(context, state.arabicMessage, state.englishMessage);
          }
          if (state is BuyNumberSuccessState) {
            return showDialog(
              context: context,
              builder: (ctx) => AlertDialog(
                content:  Container(
                  width: double.maxFinite,
                  // width: 200,
                  height: 130,
                  child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: <Widget>[
                        Expanded(
                            child: ListView(
                                shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                children: [
                                  SizedBox(
                                    height:20,
                                    child: ListTile(
                                      title: Text(
                                        "TawasolService.msisdn".tr().toString(),
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff11120e),
                                            fontWeight: FontWeight.bold),
                                      ),

                                    ),
                                  ),

                                  SizedBox(
                                    height: 40,
                                    child: ListTile(
                                      title: Text(
                                        state.msisdn,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff11120e),
                                            fontWeight: FontWeight.normal),
                                      ),

                                    ),
                                  ),

                                  SizedBox(
                                    height: 30,
                                    child: ListTile(
                                      title: Text(
                                        "TawasolService.expiryDate".tr().toString()+" ",

                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff11120e),
                                            fontWeight: FontWeight.bold),
                                      ),

                                    ),
                                  ),

                                  SizedBox(
                                    height: 50,
                                    child: ListTile(
                                      title: Text(
                                        state.expiryDate,
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff11120e),
                                            fontWeight: FontWeight.normal),
                                      ),

                                    ),
                                  ),

                                ]
                            )
                        )
                      ]
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                        Navigator.of(ctx).pop();
                      showToast(
                          EasyLocalization.of(context).locale == Locale("en", "US")
                              ? state.englishMessage
                              : state.arabicMessage,
                          context: context,
                          animation: StyledToastAnimation.scale,
                          fullWidth: true);
                    },
                    child: Text("TawasolService.OK".tr().toString(),

                      style: TextStyle(
                        color: Color(0xFF4f2565),
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            );

          }
        },
      child: GestureDetector(
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
                  "Menu_Form.please_choose".tr().toString()),
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
                                        UserList[index]['mobileNumber'],
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color(0xff11120e),
                                            fontWeight: FontWeight.normal),
                                      ),
                                    ),

                                    trailing: GestureDetector(
                                        child: BlocListener<BuyNumberBloc, BuyNumberState>(
                                          listener: (context, state) {
                                            if(state is BuyNumberLoadingState){
                                              setState(() {
                                                loooding = 1;
                                              });
                                           showToast(
                                              EasyLocalization.of(context).locale == Locale("en", "US")
                                                  ?  "TawasolService.verifying".tr().toString()
                                                  :  "TawasolService.verifying".tr().toString(),
                                              context: context,
                                              animation: StyledToastAnimation.fadeScale,
                                              fullWidth: true);

                                            }

                                            if (state is BuyNumberSuccessState) {

                                                setState(() {
                                                merchantID.text = "";
                                                terminalID.text = "";
                                                otp.text ="";
                                                });

                                            }
                                          },


                                          child:
                                          Container(
                                            child: GestureDetector(
                                             onTap:Permessions.contains('05.04.02.01.01')? () {

                                               Permessions.contains('05.04.02.01.01.02') || Permessions.contains('05.04.02.01.01.01')?
                                                  showModalBottomSheet(
                                                      isScrollControlled: true,
                                                      context: context,
                                                      builder: ( BuildContext context ) {
                                                        return Padding(padding: MediaQuery.of(context).viewInsets,
                                                        child: SingleChildScrollView(
                                                          child: StatefulBuilder(
                                                            builder: (BuildContext context, StateSetter setState) {
                                                              return Container(
                                                                  child: Column(
                                                                    mainAxisSize: MainAxisSize.min,
                                                                    crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start
                                                                    children: <Widget>[
                                                                      Container(
                                                                        margin: EdgeInsets.only(left: 25,right: 25,top: 20,bottom: 20), // Adjust the margin as needed
                                                                        child: Text(
                                                                          EasyLocalization.of(context).locale == Locale("en", "US")
                                                                              ?  "Payment Method" :  "طريقة الدفع",

                                                                          style: TextStyle(
                                                                            fontWeight: FontWeight.w500,
                                                                            fontSize: 18,
                                                                          ),
                                                                        ),
                                                                      ),

                                                                      Permessions.contains('05.04.02.01.01.02')?
                                                                      ListTile(
                                                                        leading: TawasolBalance==false?Icon(Icons.circle_outlined,color:Color(0xFF4f2565)):Icon(Icons.check_circle,color:Color(0xFF4f2565) ),
                                                                        title: Text( EasyLocalization.of(context).locale == Locale("en", "US")
                                                                            ?  "Tawasol Balance" :  "رصيد التواصل",),
                                                                        onTap: ()async{
                                                                          setState(() {
                                                                            merchantID.text = "";
                                                                            terminalID.text = "";
                                                                            otp.text ="";
                                                                            paymentMethod ="1";
                                                                            TawasolBalance = true;
                                                                            EVD = false; // Ensure only one option is selected
                                                                          });
                                                                        },
                                                                      ):Container(),
                                                                      Permessions.contains('05.04.02.01.01.01')? ListTile(
                                                                        leading: EVD==false?Icon(Icons.circle_outlined,color:Color(0xFF4f2565)):Icon(Icons.check_circle,color:Color(0xFF4f2565) ),
                                                                        title: Text("EVD"),
                                                                        onTap: ()async{
                                                                          setState(() {
                                                                            paymentMethod ="2";
                                                                            TawasolBalance = false;
                                                                            EVD = true; // Ensure only one option is selected
                                                                          });
                                                                        },
                                                                      ):Container(),
                                                                      SizedBox(height: 20),
                                                                      // Add some space between the list and the button
                                                                      EVD==true?
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 22.0,vertical: 5), // Adjust margins as needed
                                                                        child: enterMerchantID(),
                                                                      ):Container(),

                                                                      EVD==true?
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 22.0,vertical: 5), // Adjust margins as needed
                                                                        child: enterTerminalID(),
                                                                      ):Container(),
                                                                      Container(
                                                                        margin: EdgeInsets.symmetric(horizontal: 22), // Adjust margins as needed
                                                                        width: double.infinity,// Make the button take the full width
                                                                        height: 50,
                                                                        child: ElevatedButton(
                                                                          style: ElevatedButton.styleFrom(
                                                                              primary: Color(0xFF4f2565) // Change the color of the button
                                                                          ),
                                                                          onPressed: () {
                                                                            if(EVD==true){

                                                                              if(merchantID.text == ""){
                                                                                setState(() {
                                                                                  emptyMerchantID= true;
                                                                                });

                                                                              }else{
                                                                                setState(() {
                                                                                  emptyMerchantID= false;
                                                                                });
                                                                              }

                                                                              if(terminalID.text == ""){
                                                                                setState(() {
                                                                                  emptyTerminalID= true;
                                                                                });
                                                                              }else{
                                                                                setState(() {
                                                                                  emptyTerminalID= false;
                                                                                });

                                                                                if(merchantID.text !="" && terminalID.text != ""){

                                                                                  setState(() {
                                                                                    MSISDN= UserList[index]['mobileNumber'];
                                                                                  });

                                                                                  showDialog(
                                                                                    context: context,
                                                                                    builder: (ctx) => AlertDialog(
                                                                                      title: Text("TawasolService.Buying_Confirmation".tr().toString(),
                                                                                        style: TextStyle(
                                                                                          color: Color(0xff11120e),
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),

                                                                                      content:
                                                                                      Text(
                                                                                        EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                            ? 'Are you sure you want to buy this number:'+" " +UserList[index]['mobileNumber'] +", "+"TawasolService.Price".tr().toString()+" "+UserList[index]['price']+ "JD"+' ?'+'The price will be deducted from EVD Wallet.'
                                                                                            :"هل أنت متأكد أنك تريد شراء هذا الرقم:  " +UserList[index]['mobileNumber']+", "+ "TawasolService.Price".tr().toString()+" "+UserList[index]['price']+"د.أ"+' ؟'+'سيتم خصم السعر من محفظة EDV .',
                                                                                        style: TextStyle(
                                                                                          color: Colors.black,
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),



                                                                                      actions: <Widget>[

                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(ctx).pop();
                                                                                            Navigator.of(ctx).pop();
                                                                                          },
                                                                                          child: Text("TawasolService.Cancel".tr().toString(),

                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF4f2565),
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                        TextButton(
                                                                                          onPressed: () {
                                                                                            Navigator.of(ctx).pop();
                                                                                            Navigator.of(ctx).pop();
                                                                                            return showDialog(
                                                                                              context: context,
                                                                                              builder: (ctx) => AlertDialog(
                                                                                                content: Text("TawasolService.Buy_Daialog_Activate".tr().toString() ),
                                                                                                actions: <Widget>[

                                                                                                  TextButton(
                                                                                                    onPressed: () {
                                                                                                      print("close");
                                                                                                      Navigator.of(ctx).pop();
                                                                                                    },
                                                                                                    child: Text("TawasolService.Cancel".tr().toString(),

                                                                                                      style: TextStyle(
                                                                                                        color: Color(0xFF4f2565),
                                                                                                        fontSize: 16,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                  TextButton(
                                                                                                    onPressed: () {
                                                                                                      Navigator.of(ctx).pop();
                                                                                                      specialNumberInitalize();

                                                                                                    },
                                                                                                    child: Text("TawasolService.OK".tr().toString(),

                                                                                                      style: TextStyle(
                                                                                                        color: Color(0xFF4f2565),
                                                                                                        fontSize: 16,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ),
                                                                                                ],
                                                                                              ),
                                                                                            );
                                                                                          },
                                                                                          child:  Text("TawasolService.OK".tr().toString(),

                                                                                            style: TextStyle(
                                                                                              color: Color(0xFF4f2565),
                                                                                              fontSize: 16,
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  );
                                                                                }
                                                                              }
                                                                            }
                                                                            /*..............................................................................*/
                                                                            if(TawasolBalance == true){
                                                                              showDialog(
                                                                                context: context,
                                                                                builder: (ctx) => AlertDialog(
                                                                                  title: Text("TawasolService.Buying_Confirmation".tr().toString(),
                                                                                    style: TextStyle(
                                                                                      color: Color(0xff11120e),
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),

                                                                                  content: Text(
                                                                                    EasyLocalization.of(context).locale == Locale("en", "US")
                                                                                        ? 'Are you sure you want to buy this number:'+" " +UserList[index]['mobileNumber'] +", "+"TawasolService.Price".tr().toString()+" "+UserList[index]['price']+ "JD"+' ?'+'The price will be deducted from Tawasol Wallet.'
                                                                                        :"هل أنت متأكد أنك تريد شراء هذا الرقم:  " +UserList[index]['mobileNumber']+", "+ "TawasolService.Price".tr().toString()+" "+UserList[index]['price']+"د.أ"+' ؟'+'سيتم خصم السعر من محفظة تواصل .',
                                                                                    style: TextStyle(
                                                                                      color: Colors.black,
                                                                                      fontSize: 16,
                                                                                    ),
                                                                                  ),

                                                                                  actions: <Widget>[

                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(ctx).pop();
                                                                                        Navigator.of(ctx).pop();
                                                                                      },
                                                                                      child: Text("TawasolService.Cancel".tr().toString(),

                                                                                        style: TextStyle(
                                                                                          color: Color(0xFF4f2565),
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                    TextButton(
                                                                                      onPressed: () {
                                                                                        Navigator.of(ctx).pop();
                                                                                        Navigator.of(ctx).pop();
                                                                                        return showDialog(
                                                                                          context: context,
                                                                                          builder: (ctx) => AlertDialog(
                                                                                            content: Text("TawasolService.Buy_Daialog_Activate".tr().toString() ),
                                                                                            actions: <Widget>[

                                                                                              TextButton(
                                                                                                onPressed: () {
                                                                                                  print("close");
                                                                                                  Navigator.of(ctx).pop();
                                                                                                },
                                                                                                child: Text("TawasolService.Cancel".tr().toString(),

                                                                                                  style: TextStyle(
                                                                                                    color: Color(0xFF4f2565),
                                                                                                    fontSize: 16,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              TextButton(
                                                                                                onPressed: () {
                                                                                                  Navigator.of(ctx).pop();
                                                                                                  specialNumberInitalize();
                                                                                                },
                                                                                                child: Text("TawasolService.OK".tr().toString(),

                                                                                                  style: TextStyle(
                                                                                                    color: Color(0xFF4f2565),
                                                                                                    fontSize: 16,
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                            ],
                                                                                          ),
                                                                                        );
                                                                                      },
                                                                                      child:  Text("TawasolService.OK".tr().toString(),

                                                                                        style: TextStyle(
                                                                                          color: Color(0xFF4f2565),
                                                                                          fontSize: 16,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              );
                                                                            }
                                                                          },
                                                                          child: Text(EasyLocalization.of(context).locale == Locale("en", "US")
                                                                              ?  "Next" :  "التالي",
                                                                              style: TextStyle(
                                                                                  fontSize: 16,
                                                                                  fontWeight: FontWeight.w600)),
                                                                        ),
                                                                      ),


                                                                      SizedBox(height: 15), // Add some space between the list and the button

                                                                    ],
                                                                  )
                                                              );
                                                            } ,
                                                          ),
                                                        ),);
                                                      }
                                                  ):availableMethod(context);


                                          }:null,


                                            /*  onTap: Permessions.contains('05.04.02.01.01')?() {
                                                return showDialog(
                                                  context: context,
                                                  builder: (ctx) => AlertDialog(
                                                    title: Text("TawasolService.Buying_Confirmation".tr().toString(),
                                                      style: TextStyle(
                                                        color: Color(0xff11120e),
                                                        fontSize: 16,
                                                      ),
                                                    ),

                                                    content:  Text(
                                                      EasyLocalization.of(context).locale == Locale("en", "US")
                                                          ? 'Are you sure you want to buy this number:'+" " +UserList[index]['mobileNumber'] +", "+"TawasolService.Price".tr().toString()+" "+UserList[index]['price']+ "JD"+' ?'+'The price will be deducted from Tawasol Wallet.'
                                                          :"هل أنت متأكد أنك تريد شراء هذا الرقم:  " +UserList[index]['mobileNumber']+", "+ "TawasolService.Price".tr().toString()+" "+UserList[index]['price']+"د.أ"+' ؟'+'سيتم خصم السعر من محفظة تواصل .',
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),



                                                    actions: <Widget>[

                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx).pop();
                                                        },
                                                        child: Text("TawasolService.Cancel".tr().toString(),

                                                          style: TextStyle(
                                                            color: Color(0xFF4f2565),
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                      TextButton(
                                                        onPressed: () {
                                                          Navigator.of(ctx).pop();
                                                          return showDialog(
                                                            context: context,
                                                            builder: (ctx) => AlertDialog(
                                                              content: Text("TawasolService.Buy_Daialog_Activate".tr().toString() ),
                                                              actions: <Widget>[

                                                                TextButton(
                                                                  onPressed: () {
                                                                    print("close");
                                                                    Navigator.of(ctx).pop();
                                                                  },
                                                                  child: Text("TawasolService.Cancel".tr().toString(),

                                                                    style: TextStyle(
                                                                      color: Color(0xFF4f2565),
                                                                      fontSize: 16,
                                                                    ),
                                                                  ),
                                                                ),
                                                                TextButton(
                                                                  onPressed: () {

                                                                    Navigator.of(ctx).pop();
                                                                    buyNumberBloc.add(
                                                                        BuyNumberPressed(
                                                                          msisdn: UserList[index]['mobileNumber'],
                                                                        ));
                                                                    // msg;


                                                                  },
                                                                  child: Text("TawasolService.OK".tr().toString(),

                                                                    style: TextStyle(
                                                                      color: Color(0xFF4f2565),
                                                                      fontSize: 16,
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                          );
                                                        },
                                                        child:  Text("TawasolService.OK".tr().toString(),

                                                          style: TextStyle(
                                                            color: Color(0xFF4f2565),
                                                            fontSize: 16,
                                                          ),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }:null,*/

                                              child: new Text(
                                                "TawasolService.Select".tr().toString(),
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                    color: Permessions.contains('05.04.02.01.01')? Color(0xff0070c9):Color(0xFFA4B0C1),
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600),
                                              ),),),


                                        )




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


            ],

        ),

    ),

    )

    ),
      ),


    );}







}

