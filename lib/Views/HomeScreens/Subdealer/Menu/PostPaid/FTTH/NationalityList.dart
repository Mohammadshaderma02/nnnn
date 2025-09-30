import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/JordainianCustomerInformation.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/FTTHpackage.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_block.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_events.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';

import 'NonJordainianCustomerInformation.dart';

//import '../../CustomBottomNavigationBar.dart';

class NationalityList extends StatefulWidget {
  final List<dynamic> Permessions;
  var role;
  var   outDoorUserName;
  String marketType;
  String packageCode;
  NationalityList({this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode});

  @override
  _NationalityListState createState() =>
      _NationalityListState(this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode);
}

class _NationalityListState extends State<NationalityList> {
  final List<dynamic> Permessions;
  String marketType;
  String packageCode;
  var role;
  var   outDoorUserName;
  bool emptyNationalNo = false;
  bool emptyPassportNo = false;
  bool errorNationalNo = false;
  bool errorPassportNo = false;
  bool isJordanian = false;

  String msisdn='';
  String userName='';
  String password='';

  bool checkNationalDisabled=false;
  bool checkPassportDisabled=false;

  TextEditingController nationalNo = TextEditingController();
  TextEditingController passportNo = TextEditingController();
  _NationalityListState(this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode);
  PostValidateSubscriberBlock postValidateSubscriberBlock;
  String packagesSelect;
  void initState() {
    super.initState();
    print(widget.marketType);
    print(widget.packageCode);
    postValidateSubscriberBlock = BlocProvider.of<PostValidateSubscriberBlock>(context);
  }
  void clearNationalNo (){
    setState(() {
      nationalNo.text='';
    });
  }
  void clearPassportNo (){
    setState(() {
      passportNo.text='';
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
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
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

  showAlertDialogSucssesJordanian(BuildContext context, arabicMessage, englishMessage, msisdn, Username,Password,Price) {
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
            clearNationalNo();
            Navigator.of(context).pop();
            Navigator.of(context).pop();

          },
          child: Text(
            "Postpaid.Cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
            // Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JordainianCustomerInformation(role:role,outDoorUserName:outDoorUserName,
                    Permessions: Permessions,msisdn: msisdn, nationalNumber:nationalNo.text,passportNumber:null,
                    userName:userName,password:password,marketType:marketType,packageCode:packageCode),
              ),
            );
          },
          child: Text(
            "Postpaid.Next".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),

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
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: Text(
            "Postpaid.Cancel".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            Navigator.pop(context);

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => NonJordainianCustomerInformation(role:role,outDoorUserName:outDoorUserName,
                    Permessions: Permessions,msisdn: msisdn, nationalNumber:null,passportNumber :passportNo.text,

                    userName:userName,password:password,marketType:marketType,packageCode:packageCode),
              ),
            );

          },
          child: Text(
            "Postpaid.Next".tr().toString(),
            style: TextStyle(
              color: Color(0xFF4f2565),
              fontSize: 16,
            ),
          ),
        ),

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


  final msg = BlocBuilder<PostValidateSubscriberBlock, PostValidateSubscriberState>(builder: (context, state) {
    if (state is PostValidateSubscriberLoadingState   ) {

      return Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
            ),
          ));
    } else {
      return Container();
    }
  });
  final msgTwo = BlocBuilder<PostValidateSubscriberBlock, PostValidateSubscriberState>(builder: (context, state) {
    if (state is PostValidateSubscriberLoadingState   ) {
      return Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF4f2565)),
            ),
          ));
    } else {
      return Container();
    }
  });
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
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
            checkNationalDisabled==true? msg:Container(),
            Container(
              height: 48,
              width: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: TextButton(

                onPressed: checkNationalDisabled
                    ? null
                    :  ()
                     {
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

                  if(nationalNo.text!='' ){
                    if(nationalNo.text.length!=10){
                      setState(() {
                        errorNationalNo = true;
                      });

                    }else {
                      postValidateSubscriberBlock.add(
                          PostValidateSubscriberPressed(
                              marketType:marketType,isJordanian:isJordanian,
                              nationalNo:nationalNo.text,
                              passportNo:passportNo.text,
                              packageCode:packageCode,
                            msisdn: null
                          ));

                    }
                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor:Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                child: Text(
                  "Postpaid.check".tr().toString(),
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
                    const BorderSide(color: Color(0xFF4f2565), width: 1.0),
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
            /* errorPassportNo==true ?ReusableRequiredText(
            text:  EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Your National Number shoud be 10 digit "
                : "يجب أن يتكون رقمك الوطني من 10 أرقام"): Container(),*/
            SizedBox(height: 10),
            checkPassportDisabled==true? msgTwo:Container(),
            Container(
              height: 48,
              width: 420,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Color(0xFF4f2565),
              ),
              child: TextButton(

                onPressed: checkPassportDisabled
                    ? null
                    :   () {
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

                    postValidateSubscriberBlock.add(
                        PostValidateSubscriberPressed(marketType:marketType,
                            isJordanian:isJordanian,nationalNo:nationalNo.text,
                            passportNo:passportNo.text,packageCode:packageCode,
                            msisdn: null
                        ));


                  }
                },
                style: TextButton.styleFrom(
                  backgroundColor:Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                child: Text(
                  "Postpaid.check".tr().toString(),
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
              "Select_Nationality.select_nationality".tr().toString(),
            ),
            backgroundColor: Color(0xFF4f2565),
          ),
          backgroundColor: Color(0xFFEBECF1),
          body:  ListView(padding: EdgeInsets.only(top: 10),
            children: <Widget>[
              _buildListPanel(),
            ],
          )),
    );




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
