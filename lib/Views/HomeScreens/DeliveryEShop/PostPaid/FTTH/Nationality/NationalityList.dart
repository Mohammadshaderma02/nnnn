import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/FTTH/Nationality/JordainianCustomerInformation.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/PostPaid/FTTH/Nationality/NonJordainianCustomerInformation.dart';

import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/FTTHpackage.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_block.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_events.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';




class NationalityList extends StatefulWidget {
  var PermessionDeliveryEShop = [];
  var role;
  var outDoorUserName;
  String marketType;
  String packageCode;
  String packageName;
  var orderID;
  NationalityList( this.PermessionDeliveryEShop,
      this.role,
      this.orderID,
      this.packageName,
      this.packageCode,
      this.marketType);

  @override
  _NationalityListState createState() =>
      _NationalityListState( this.PermessionDeliveryEShop,
          this.role,
          this.orderID,
          this.packageName,
          this.packageCode,
          this.marketType);
}

class _NationalityListState extends State<NationalityList> {
  DateTime backButtonPressedTime;
  var PermessionDeliveryEShop = [];
  String marketType;
  String packageCode;
  var role;
  String packageName;
  var orderID;
  var   outDoorUserName;
  bool emptyNationalNo = false;
  bool emptyPassportNo = false;
  bool errorNationalNo = false;
  bool errorPassportNo = false;
  bool isJordanian = false;

  String msisdn='';
  String userName='';
  String password='';
  String passport_Number='';
  String national_Number='';

  bool checkNationalDisabled=false;
  bool checkPassportDisabled=false;



  TextEditingController nationalNo = TextEditingController();
  TextEditingController passportNo = TextEditingController();
  _NationalityListState( this.PermessionDeliveryEShop,
      this.role,
      this.orderID,
      this.packageName,
      this.packageCode,
      this.marketType);
  PostValidateSubscriberBlock postValidateSubscriberBlock;
  String packagesSelect;
  void initState() {
    super.initState();
    print(widget.marketType);
    print(widget.packageCode);
    postValidateSubscriberBlock = BlocProvider.of<PostValidateSubscriberBlock>(context);
  }
  void clearNationalNo (){
   // Navigator.of(context).pop();
   // Navigator.of(context).pop();
    setState(() {
      nationalNo.text='';
      errorNationalNo=false;
    });
  }
  void clearPassportNo (){
    setState(() {
      passportNo.text='';
      errorPassportNo=false;
    });
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
  showAlertDialogError(BuildContext context, arabicMessage, englishMessage) {

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
            Navigator.of(context).pop();
            Navigator.of(context).pop();


          },
          child: Text(
            "alert.close".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        ),
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

  void showAlertDialogSucssesJordanian(BuildContext context, arabicMessage, englishMessage, msisdn, Username,Password,Price) {
    AlertDialog alert = AlertDialog(
      title: Text("Postpaid.OperationSuccess".tr().toString()),
      content: SingleChildScrollView(
        child: ListBody(
          children:  <Widget>[
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+msisdn
                  : "رقم الخط"+" : "+" "+msisdn,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Username"+" : "+" "+Username
                  : "اسم المستخدم"+" : "+" "+Username,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Password"+" : "+" "+Password
                  : "كلمه السر"+" : "+" "+Password,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Price"+" : "+" "+Price.toString()
                  : "السعر"+" : "+" "+Price.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),),


      actions: <Widget>[
        TextButton(
          onPressed: () async{
            clearNationalNo();
            Navigator.pop(context); // Dismisses dialog
            Navigator.pop(context); // Navigates back to previous screen


          },
          child: Text(
            "Postpaid.Cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: ()async {
            FocusScope.of(context).unfocus();
            Navigator.pop(context); // Dismisses dialog
            Navigator.pop(context);
            await Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) => JordainianCustomerInformation(
              this.PermessionDeliveryEShop,
              this.role,
              this.orderID,
              this.packageName,
              this.packageCode,
              this.marketType ,
              this.msisdn,
              this.national_Number,
              this.passport_Number,
              this.userName,
              this.password,
            )));


          },
          child: Text(
            "Postpaid.Next".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        ),

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
  showAlertDialogSucssesNoneJordanian(BuildContext context, arabicMessage, englishMessage, msisdn, Username,Password,Price) {
    AlertDialog alert = AlertDialog(
      title: Text("Postpaid.OperationSuccess".tr().toString()),
      content: SingleChildScrollView(
        child: ListBody(
          children:  <Widget>[
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+msisdn
                  : "رقم الخط"+" : "+" "+msisdn,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Username"+" : "+" "+Username
                  : "اسم المستخدم"+" : "+" "+Username,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Password"+" : "+" "+Password
                  : "كلمه السر"+" : "+" "+Password,
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "Price"+" : "+" "+Price.toString()
                  : "السعر"+" : "+" "+Price.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ],
        ),),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            clearPassportNo();

            Navigator.pop(context); // Dismisses dialog
            Navigator.pop(context); // Navigates back to previous screen
           // Navigator.of(context).pop();
           // Navigator.of(context).pop();
          },
          child: Text(
            "Postpaid.Cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () async{

            FocusScope.of(context).unfocus();
            Navigator.pop(context); // Dismisses dialog
            Navigator.pop(context);
            await Navigator.of(context)
                .push(new MaterialPageRoute(builder: (context) => NonJordainianCustomerInformation(
              this.PermessionDeliveryEShop,
              this.role,
              this.orderID,
              this.packageName,
              this.packageCode,
              this.marketType ,
              this.msisdn,
              this.national_Number,
              this.passport_Number,
              this.userName,
              this.password,
            )));

          },
          child: Text(
            "Postpaid.Next".tr().toString(),
            style: TextStyle(
              color: Color(0xFF392156),
              fontSize: 16,
            ),
          ),
        ),

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


  Widget nationalNumber() {
    return  BlocListener<PostValidateSubscriberBlock, PostValidateSubscriberState>
      (listener:(context, state) {
      if (state is PostValidateSubscriberErrorState) {
        setState(() {
          checkNationalDisabled=false;
        });
        showAlertDialogError(
            context, state.arabicMessage, state.englishMessage);
      }
      if(state is PostValidateSubscriberLoadingState){
        setState(() {
          checkNationalDisabled=true;
        });
      }
      if(state  is PostValidateSubscriberTokenErrorState){
        UnotherizedError();
        setState(() {
          checkNationalDisabled=false;
        });
      }
      if (state is PostValidateSubscriberSuccessState) {
        setState(() {
          checkNationalDisabled=false;
        });
        setState(() {
          msisdn=state.msisdn;
          userName=state.Username;
          password=state.Password;
          passport_Number=null;
          national_Number=nationalNo.text;

        });
        showAlertDialogSucssesJordanian(context, state.arabicMessage, state.englishMessage,state.msisdn,state.Username,state.Password,state.Price);
        FocusScope.of(context).unfocus();
      }},
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Postpaid.nationalNo".tr().toString(),
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
                controller: nationalNo,
                maxLength: 10,
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.phone,
                style: TextStyle(color: Color(0xff11120e)),
                decoration: InputDecoration(
                  enabledBorder: emptyNationalNo == true || errorNationalNo ==true?
                  const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                  ):
                  const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                  )
                  ,
                  border: const OutlineInputBorder(),

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF392156), width: 1.0),
                  ),
                  contentPadding: EdgeInsets.all(16),
                  suffixIcon: IconButton(
                    onPressed: clearNationalNo,
                    icon: Icon(
                        Icons.close
                    ),
                    color: Color(0xFFA4B0C1),
                  ),
                  hintText: "Postpaid.enter_nationalNo".tr().toString(),
                  hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                ),
              ),
            ),
            emptyNationalNo  == true
                ? ReusableRequiredText(
                text: "Postpaid.nationalNo_required".tr().toString())
                : Container(),
            errorNationalNo==true ?ReusableRequiredText(
                text:  EasyLocalization.of(context).locale == Locale("en", "US")
                    ? "Your National Number shoud be 10 digit "
                    : "يجب أن يتكون رقمك الوطني من 10 أرقام"): Container(),
            SizedBox(height: 10),


            Container(
                height: 48,
                width: 400,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF392156)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF392156),
                    textStyle: TextStyle(fontSize: 16),
                    minimumSize: Size.fromHeight(30),
                    shape: StadiumBorder(),
                  ),
                  child: checkNationalDisabled
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? "Please wait"
                              : "يرجى الانتظار",
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(
                        width: 24,
                      ),
                      CircularProgressIndicator(
                        color: Colors.white,
                      )
                    ],
                  )
                      : Text("Postpaid.check".tr().toString(),
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: checkNationalDisabled
                      ? null
                      : () async {
                    if (checkNationalDisabled) return;
                    print('checked');
                    if (nationalNo.text == '') {
                      setState(() {
                        emptyNationalNo = true;
                      });
                    }
                    if (nationalNo.text != '') {
                      setState(() {
                        emptyNationalNo = false;
                      });
                    }

                    if (nationalNo.text != '') {
                      if(nationalNo.text.length!=10){
                        setState(() {
                          errorNationalNo = true;
                        });

                      }else {
                        setState(() {
                          checkNationalDisabled=true;
                        });
                        postValidateSubscriberBlock.add(
                            PostValidateSubscriberPressed(
                                marketType:marketType,isJordanian:isJordanian,
                                nationalNo:nationalNo.text,
                                passportNo:passportNo.text,
                                packageCode:packageCode,
                                msisdn: null,
                                isRental:false,
                                device5GType:"0",
                                buildingCode:"null",
                                serialNumber:"",
                                itemCode:"null",
                                isLocked:false
                            ));

                      }

                    }
                  },
                )),
            SizedBox(height: 20),
          ],
        )


    );

  }

  Widget passportNumber() {
    return  BlocListener<PostValidateSubscriberBlock, PostValidateSubscriberState>
      (listener:(context, state) {
      if(state is PostValidateSubscriberLoadingState){
        setState(() {
          checkPassportDisabled=true;
        });
      }
      if (state is PostValidateSubscriberErrorState) {
        setState(() {
          checkPassportDisabled=false;
        });
        showAlertDialogError(
            context, state.arabicMessage, state.englishMessage);
      }
      if(state  is PostValidateSubscriberTokenErrorState){
        UnotherizedError();
        setState(() {
          checkPassportDisabled=false;
        });
      }
      if (state is PostValidateSubscriberSuccessState) {
        setState(() {
          checkPassportDisabled=false;
        });
        setState(() {
          msisdn=state.msisdn;
          userName=state.Username;
          password=state.Password;
          passport_Number=passportNo.text;
          national_Number=null;


        });
        showAlertDialogSucssesNoneJordanian(context, state.arabicMessage, state.englishMessage,state.msisdn,state.Username,state.Password,state.Price);
        FocusScope.of(context).unfocus();
      }},
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            RichText(
              text: TextSpan(
                text: "Postpaid.passportNo".tr().toString(),
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
                controller: passportNo,
                maxLength: 10,
                buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                keyboardType: TextInputType.name,
                style: TextStyle(color: Color(0xff11120e)),
                decoration: InputDecoration(
                  enabledBorder: emptyPassportNo == true || errorPassportNo ==true?
                  const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Color(0xFFB10000), width: 1.0),
                  ):
                  const OutlineInputBorder(
                    // width: 0.0 produces a thin "hairline" border
                    borderSide: const BorderSide(color: Color(0xFFD1D7E0), width: 1.0),
                  )
                  ,
                  border: const OutlineInputBorder(),

                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    const BorderSide(color: Color(0xFF392156), width: 1.0),
                  ),
                  contentPadding: EdgeInsets.all(16),
                  suffixIcon: IconButton(
                    onPressed: clearPassportNo,
                    icon: Icon(
                        Icons.close
                    ),
                    color: Color(0xFFA4B0C1),
                  ),
                  hintText: "Postpaid.enter_passportNo".tr().toString(),
                  hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                ),
              ),
            ),
            emptyPassportNo  == true
                ? ReusableRequiredText(
                text: "Postpaid.passportNo_required".tr().toString())
                : Container(),

            SizedBox(height: 10),



            Container(
                height: 48,
                width: 400,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                    color: Color(0xFF392156)),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF392156),
                    textStyle: TextStyle(fontSize: 16),
                    minimumSize: Size.fromHeight(30),
                    shape: StadiumBorder(),
                  ),
                  child: checkPassportDisabled
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                          EasyLocalization.of(context).locale ==
                              Locale("en", "US")
                              ? "Please wait"
                              : "يرجى الانتظار",
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(
                        width: 24,
                      ),
                      CircularProgressIndicator(
                        color: Colors.white,
                      )
                    ],
                  )
                      : Text("Postpaid.check".tr().toString(),
                      style:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  onPressed: checkPassportDisabled
                      ? null
                      : () async {
                    if (checkPassportDisabled) return;
                    print('checked');
                    if (passportNo.text == '') {
                      setState(() {
                        emptyPassportNo = true;
                      });
                    }
                    if (passportNo.text != '') {
                      setState(() {
                        emptyPassportNo = false;
                      });
                    }

                    if(passportNo.text!='' ){
                      setState(() {
                        checkPassportDisabled=true;
                      });
                      postValidateSubscriberBlock.add(
                          PostValidateSubscriberPressed(
                              marketType:marketType,
                              isJordanian:isJordanian,
                              nationalNo:nationalNo.text,
                              passportNo:passportNo.text,
                              packageCode:packageCode,
                              msisdn: null
                          ));


                    }


                  },
                )),



            SizedBox(height: 20),
          ],
        ));
  }

  List<Item> _data = generateItems(2);
  Widget _buildListPanel(){

    return ExpansionPanelList(
      expansionCallback: (int index, bool isExpanded){
        if (isExpanded == false) {
          for (final item in _data) {
            if (_data[index] != item) {
              setState(() {
                item.isExpanded = true;

              });
            }
            setState(() {
              item.isExpanded = false;

            });
          }
        }
        setState(() {
          _data[index].isExpanded = !isExpanded;
          print(_data[index].headerValue);

        });

        _data[index].headerValue=='Jordanian' || _data[index].headerValue=='أردني'?setState(() {
          isJordanian = true;
          print(isJordanian);
          print('haya');
        }):setState(() {
          isJordanian = false;
          print(isJordanian);
          print('testing');
        });
      },
      children: _data.map<ExpansionPanel>((Item item){
        return  isJordanian == true?
        ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded){
              return ListTile(
                title: Text(item.headerValue,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff11120e),
                      fontWeight: FontWeight.normal),),
              );
            },
            body: ListTile(
              title: nationalNumber(),
              //subtitle: Text('To delete this panel '),
              /* trailing: Icon(Icons.delete),
              onTap: (){
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              },*/
            ),

            isExpanded: item.isExpanded
        ):
        ExpansionPanel(
            headerBuilder: (BuildContext context, bool isExpanded){
              return ListTile(
                title: Text(item.headerValue,
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xff11120e),
                      fontWeight: FontWeight.normal),),
              );
            },
            body: ListTile(
              title: passportNumber(),
              //subtitle: Text('To delete this panel '),
              /* trailing: Icon(Icons.delete),
              onTap: (){
                setState(() {
                  _data.removeWhere((currentItem) => item == currentItem);
                });
              },*/
            ),

            isExpanded: item.isExpanded
        );

      }).toList(),

    );


  }



  /******** for back button on mobile tap ******/
  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 0);
    if (backButton) {
      backButtonPressedTime = currentTime;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => OrdersScreen()),
      );

      return true;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(child: GestureDetector(
      onTap: ()=>FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back),

              onPressed: () {
              //  Navigator.pop(context,);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersScreen()),
                );
              },
            ),
            centerTitle:false,
            title: Text(
              "Select_Nationality.select_nationality".tr().toString(),
            ),
            backgroundColor: Color(0xFF392156),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body:  ListView(padding: EdgeInsets.only(top: 10),
            children: <Widget>[
              _buildListPanel(),
            ],
          )),
    ), onWillPop: onWillPop);




  }
}

class Item{
  String expandedValue;
  String headerValue;
  bool isExpanded;


  Item({this.expandedValue,this.headerValue,this.isExpanded=false});
}

List<Item> generateItems(int numberOfItem){
  return List.generate(numberOfItem, (index) {
    return Item(

      headerValue:  index == 0?"Select_Nationality.jordanian".tr().toString(): "Select_Nationality.non_jordanian".tr().toString(),
      // expandedValue: 'this is item number $index'
    );
  });
}
