
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/GSM_JordainianCustomerInformation.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/GSM/SearchDropDown.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/Views/LoginScreens/SignInScreen.dart';
import 'package:sales_app/blocs/PostPaid/GSM_MSISDN_LIST/PostpaidGSMMSISDNList_block.dart';
import 'package:sales_app/blocs/PostPaid/GSM_MSISDN_LIST/PostpaidGSMMSISDNList_events.dart';
import 'package:sales_app/blocs/PostPaid/GSM_MSISDN_LIST/PostpaidGSMMSISDNList_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/PostPaid/FTTH/FTTHpackage.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_block.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_events.dart';
import 'package:sales_app/blocs/PostPaid/PostValidateSubscriber/PostValidateSubscriber_state.dart';


import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_switch/sliding_switch.dart';
import 'package:textfield_search/textfield_search.dart';

import 'GSM_NonJordainianCustomerInformation.dart';
import 'PRETOPOST_Packages.dart';

//import '../../CustomBottomNavigationBar.dart';

class PRETOPOSTCheckValidation extends StatefulWidget {

  var role;
  var   outDoorUserName;
  String marketType;
  String packageCode;
  final List<dynamic> Permessions;
  PRETOPOSTCheckValidation({this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode});

  @override
  _PRETOPOSTCheckValidationState createState() =>
      _PRETOPOSTCheckValidationState(this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode);
}

class _PRETOPOSTCheckValidationState extends State<PRETOPOSTCheckValidation> {
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
  bool emptyMSISDN=false;
  bool emptyMSISDNNumber=false;
  bool errorMSISDNNumber=false;


  bool sendOTP=true;
  bool showSimCard =true;

  List<String> MSISDN = <String>[];
  String msisdn;
  String price ='';
  String userName='';
  String password='';

  bool checkNationalDisabled=false;
  bool checkPassportDisabled=false;

  TextEditingController nationalNo = TextEditingController();
  TextEditingController passportNo = TextEditingController();
  TextEditingController msisdnNumber= TextEditingController();
  TextEditingController msisdnList = TextEditingController();
  _PRETOPOSTCheckValidationState(this.Permessions,this.role,this.outDoorUserName,this.marketType,this.packageCode);
  PostValidateSubscriberBlock postValidateSubscriberBlock;
  GetPostPaidGSMMSISDNListBloc getPostPaidGSMMSISDNListBloc;


  bool isTextJordianian = false;
  bool isTextNoNJordianian = false;
  bool isArmy;
  bool showCommitmentList;

  String packagesSelect;
  List<Item> _data = generateItems(0);

  void initState() {
    super.initState();

    if(marketType=="GSM"){
      _data= generateItems(  2) ;
    }else{
      _data= generateItems(  1) ;
    }

    print(marketType);
    print(packageCode);

    getPostPaidGSMMSISDNListBloc =BlocProvider.of<GetPostPaidGSMMSISDNListBloc>(context);
    postValidateSubscriberBlock = BlocProvider.of<PostValidateSubscriberBlock>(context);
    getPostPaidGSMMSISDNListBloc.add(GetPostPaidGSMMSISDNListFetchEvent());
  }
  void clearNationalNo (){
    setState(() {
      nationalNo.text='';
    });
    setState(() {
      msisdn='';
      msisdn=null;

    });
  }
  void clearPassportNo (){
    setState(() {
      passportNo.text='';
    });




  }

  void clearMsisdn(){
    setState(() {
      msisdnNumber.text='';
    });


    setState(() {
      msisdn=null;

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
            marketType=="GSM"?
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+ msisdn.toString()
                  : "رقم الخط"+" : "+" "+ msisdn.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+ msisdnNumber.text
                  : "رقم الخط"+" : "+" "+ msisdnNumber.text,
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
            // clearNationalNo();
            //clearMsisdn();
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
                builder: (context) => PRETOPOSTPackages(
                    role:role,outDoorUserName:outDoorUserName,
                    Permessions: Permessions,
                    msisdn: marketType=="GSM"?msisdn:msisdnNumber.text, nationalNumber:nationalNo.text,
                    userName:userName,password:password,marketType:marketType,packageCode:'',
                    sendOtp:sendOTP,
                    showSimCard:showSimCard,
                    price:price
                ),
              ),
            );

          /*  Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => JordainianCustomerInformation(
                    role:role,outDoorUserName:outDoorUserName,
                    Permessions: Permessions,
                    msisdn: marketType=="GSM"?msisdn:msisdnNumber.text, nationalNumber:nationalNo.text,passportNumber:null,
                    userName:userName,password:password,marketType:marketType,packageCode:packageCode,
                    sendOtp:sendOTP,
                    showSimCard:showSimCard
                ),
              ),
            );*/
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
            marketType=="GSM"?
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+ msisdn.toString()
                  : "رقم الخط"+" : "+" "+ msisdn.toString(),
              style: TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ):
            Text(
              EasyLocalization.of(context).locale == Locale("en", "US")
                  ? "MSISDN"+" : "+" "+ msisdnNumber.text
                  : "رقم الخط"+" : "+" "+ msisdnNumber.text,
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
            // clearPassportNo();
            //  clearMsisdn();
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
                    Permessions: Permessions,msisdn: marketType=="GSM"?msisdn:msisdnNumber.text,  nationalNumber:null,passportNumber :passportNo.text,

                    userName:userName,password:password,marketType:marketType,packageCode:packageCode,
                    sendOtp:sendOTP,showSimCard:showSimCard
                ),
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
        print("statestatestatestatestatestatestatestatestatestatestate");
        print(state.data);
        print("statestatestatestatestatestatestatestatestatestatestate");
        setState(() {
          //  msisdn=state.msisdn;
          userName=state.Username;
          password=state.Password;
          sendOTP=state.sendOTP;
          price=state.Price.toString();
          showSimCard=state.showSimCard;
          isArmy=state.isArmy;
          showCommitmentList=state.showCommitmentList;

        });

        print('sendOTP ${state.sendOTP}');
        print(state);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PRETOPOSTPackages(
                role:role,outDoorUserName:outDoorUserName,
                Permessions: Permessions,
                msisdn: marketType=="GSM"?msisdn:msisdnNumber.text, nationalNumber:nationalNo.text,
                userName:userName,password:password,marketType:marketType,packageCode:'',
                sendOtp:state.sendOTP,
                price:price,
                showSimCard:showSimCard,
                isArmy:isArmy,
                showCommitmentList:showCommitmentList
            ),
          ),
        );
       // showAlertDialogSucssesJordanian(context, state.arabicMessage, state.englishMessage,msisdn,state.Username,state.Password,state.Price);
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


                  print('msisdn');
                  print(msisdn);
                  print(msisdnNumber.text);

                  if( marketType=="GSM"){
                    if(isTextJordianian==false){
                      if(msisdn==null){
                        setState(() {
                          emptyMSISDN=true;
                        });
                      }else if(msisdn!=null){
                        setState(() {
                          emptyMSISDN=false;
                        });
                      }
                    }else{
                      if(msisdnNumber.text==''){
                        setState(() {
                          emptyMSISDNNumber=true;
                        });
                      }else if(msisdnNumber.text!=''){
                        setState(() {
                          emptyMSISDNNumber=false;
                        });
                      }
                    }
                  }
                  else
                  if(marketType=="PRETOPOST"){
                    if(msisdnNumber.text==''){
                      setState(() {
                        emptyMSISDNNumber=true;
                      });
                    }else if(msisdnNumber.text!=''){
                      setState(() {
                        emptyMSISDNNumber=false;
                      });
                    }
                  }
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

                  if(nationalNo.text!=''   &&  (msisdn!=null ||msisdnNumber.text!='')){
                    if(nationalNo.text.length!=10){
                      setState(() {
                        errorNationalNo = true;
                      });

                    }else {

                      postValidateSubscriberBlock.add(PostValidateSubscriberPressed(
                          marketType:marketType,
                          isJordanian:isJordanian,
                          nationalNo:nationalNo.text,
                          passportNo:passportNo.text,
                        //  packageCode:packageCode,
                          packageCode: '',
                          msisdn: marketType=="GSM"?msisdn:msisdnNumber.text
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
          //  msisdn=state.msisdn;
          userName=state.Username;
          password=state.Password;
          sendOTP=state.sendOTP;
          price=state.Price.toString();
          showSimCard=state.showSimCard;


        });
        showAlertDialogSucssesNoneJordanian(context,
            state.arabicMessage, state.englishMessage,msisdn,state.Username,
            state.Password,state.Price);
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
                style: TextButton.styleFrom(
                  backgroundColor:Color(0xFF4f2565),
                  shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                ),
                onPressed: checkPassportDisabled
                    ? null
                    :   () {


                  if( marketType=="GSM"){
                    if(isTextNoNJordianian==false){
                      if(msisdn==null){
                        setState(() {
                          emptyMSISDN=true;
                        });
                      }else if(msisdn!=null){
                        setState(() {
                          emptyMSISDN=false;
                        });
                      }
                    }else{
                      if(msisdnNumber.text==''){
                        setState(() {
                          emptyMSISDNNumber=true;
                        });
                      }else if(msisdnNumber.text!=''){
                        setState(() {
                          emptyMSISDNNumber=false;
                        });
                      }
                    }
                  }
                  else
                  if(marketType=="PRETOPOST"){
                    if(msisdnNumber.text==''){
                      setState(() {
                        emptyMSISDNNumber=true;
                      });
                    }else if(msisdnNumber.text!=''){
                      setState(() {
                        emptyMSISDNNumber=false;
                      });
                    }
                  }
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

                  if(passportNo.text!='' &&( msisdn!=null || msisdnNumber.text!='')){

                    postValidateSubscriberBlock.add(
                        PostValidateSubscriberPressed(marketType:marketType,
                            isJordanian:isJordanian,
                            nationalNo:nationalNo.text,
                            passportNo:passportNo.text,
                            //packageCode:packageCode,
                            packageCode: '',
                            msisdn: marketType=="GSM"?msisdn:msisdnNumber.text
                        ));


                  }
                },

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

  Widget buildMSISDNNumber() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        RichText(
          text: TextSpan(
            text: "Postpaid.msisdn".tr().toString(),
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
            controller: msisdnNumber,
            maxLength: 10,
            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xff11120e)),
            decoration: InputDecoration(
              enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
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
                onPressed: clearMsisdn,
                icon: Icon(
                    Icons.close
                ),
                color: Color(0xFFA4B0C1),
              ),
              hintText: "Postpaid.enter_msisdn".tr().toString(),
              hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
            ),
          ),
        ),
        emptyMSISDNNumber  == true
            ? ReusableRequiredText(
            text: "Postpaid.passportNo_required".tr().toString())
            : Container(),
        errorMSISDNNumber==true ?ReusableRequiredText(
            text:  EasyLocalization.of(context).locale == Locale("en", "US")
                ? "Your MSISDN should be 10 digit and valid"
                : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
      ],
    );
  }
/*  Widget buildMSISDNListJordainian() {
    return  Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              children:[ RichText(
                text: TextSpan(
                  text: "Postpaid.msisdn".tr().toString(),
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
                Spacer(),
                marketType=="GSM"? new SlidingSwitch(
                  value: isTextJordianian,

                  width: 70,
                  onChanged: (bool value) {
                    setState(() {
                      isTextJordianian = value;
                      isTextNoNJordianian=false;
                    });
                  },
                  height : 30,
                  animationDuration : const Duration(milliseconds: 400),
                  iconOff: Icons.search_outlined,
                  iconOn: Icons.text_format,
                  contentSize: 17,
                  colorOn : const Color(0xFF4f2565),
                  colorOff : const Color(0xFF4f2565),
                  background : const Color(0xffe4e5eb),
                  buttonColor : const Color(0xfff7f5f7),
                  inactiveColor : const Color(0xff636f7b),
                ):Container(),]
          ),
          SizedBox(height: 10,),


          isTextJordianian==false?

          BlocBuilder<GetPostPaidGSMMSISDNListBloc,GetPostPaidGSMMSISDNListState>(
              builder: (context, state) {
                if (state is GetPostPaidGSMMSISDNListSuccessState ||
                    state is GetPostPaidGSMMSISDNListLoadingState ||
                    state is GetPostPaidGSMMSISDNListErrorState) {
                  MSISDN = [];
                  if (state is GetPostPaidGSMMSISDNListSuccessState) {
                    MSISDN = [];
                    for (var obj in state.data) {

                      MSISDN.add(obj.toString());
                    }
                  }
                  return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          //color: Color(0xFFB10000), red color
                          color: emptyMSISDN == true
                              ? Color(0xFFB10000)
                              : Color(0xFFD1D7E0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: ButtonTheme(
                          alignedDropdown: true,
                          child: DropdownButton<String>(
                            hint: Text(
                              "Personal_Info_Edit.select_an_option".tr().toString(),
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
                              color: Color(0xFF11120e),
                              fontSize: 14,
                            ),
                            value: msisdn,
                            onChanged: (String newValue) {
                              setState(() {
                                msisdn = newValue;
                              });
                            },
                            items: MSISDN.map((valueItem) {
                              return DropdownMenuItem<String>(
                                value: valueItem,
                                child: EasyLocalization.of(context).locale ==
                                    Locale("en", "US")
                                    ? Text(valueItem.toString())
                                    : Text(valueItem.toString()),
                              );
                            }).toList(),
                          ),
                        ),
                      )
                  );
                } else {
                  return Container();
                }
              }):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
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
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ),
          SizedBox(height: 10,),
          emptyMSISDN  == true
              ? ReusableRequiredText(
              text: "Postpaid.nationalNo_required".tr().toString())
              : Container(),
        ],
      ),
    );
  }*/
  Widget buildMSISDNListJordainian() {
    return  Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              children:[ RichText(
                text: TextSpan(
                  text: "Postpaid.msisdn".tr().toString(),
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
                Spacer(),
                marketType=="GSM"? new SlidingSwitch(
                  value: isTextJordianian,

                  width: 70,
                  onChanged: (bool value) {
                    setState(() {
                      isTextJordianian = value;
                      isTextNoNJordianian=false;
                    });
                  },
                  height : 30,
                  animationDuration : const Duration(milliseconds: 400),
                  iconOff: Icons.search_outlined,
                  iconOn: Icons.text_format,
                  contentSize: 17,
                  colorOn : const Color(0xFF4f2565),
                  colorOff : const Color(0xFF4f2565),
                  background : const Color(0xffe4e5eb),
                  buttonColor : const Color(0xfff7f5f7),
                  inactiveColor : const Color(0xff636f7b),
                ):Container(),]
          ),
          SizedBox(height: 10,),


          isTextJordianian==false?

          BlocBuilder<GetPostPaidGSMMSISDNListBloc,GetPostPaidGSMMSISDNListState>(
              builder: (context, state) {
                if (state is GetPostPaidGSMMSISDNListSuccessState ||
                    state is GetPostPaidGSMMSISDNListLoadingState ||
                    state is GetPostPaidGSMMSISDNListErrorState) {
                  MSISDN = [];
                  if (state is GetPostPaidGSMMSISDNListSuccessState) {

                    for (var obj in state.data) {

                      MSISDN.add(obj.toString());
                    }

                  }
                  return Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        //color: Color(0xFFB10000), red color
                        color: emptyMSISDN == true
                            ? Color(0xFFB10000)
                            : Color(0xFFD1D7E0),
                      ),
                    ),
                    child:CustomSearchableDropDown(
                      items: MSISDN,
                      dropdownHintText: "Personal_Info_Edit.select_an_option".tr().toString() ,
                      label:msisdn ,
                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(4),
                          border:null
                      ),

                      dropDownMenuItems: MSISDN?.map((item) {
                        return item;
                      })?.toList() ??
                          [],
                      onChanged: (value){
                        if(value!=null)
                        {
                          msisdn = value;
                        }
                        else{
                          msisdn=null;
                        }
                      },

                    ),

                  );
                } else {
                  return Container();
                }
              }):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
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
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ),
          SizedBox(height: 10,),
          emptyMSISDN  == true
              ? ReusableRequiredText(
              text: "Postpaid.nationalNo_required".tr().toString())
              : Container(),
        ],
      ),
    );
  }


  Widget buildMSISDNListNonJordainian() {
    return  Container(

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
              children:[ RichText(
                text: TextSpan(
                  text: "Postpaid.msisdn".tr().toString(),
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
                Spacer(),
                marketType=="GSM"?  SlidingSwitch(
                  value: isTextNoNJordianian,
                  width: 70,
                  onChanged: (bool value) {
                    setState(() {

                      isTextNoNJordianian = value;
                      isTextJordianian=false;
                    });
                  },
                  height : 30,
                  animationDuration : const Duration(milliseconds: 400),
                  iconOff: Icons.search_outlined,
                  iconOn: Icons.text_format,
                  contentSize: 17,
                  colorOn : const Color(0xFF4f2565),
                  colorOff : const Color(0xFF4f2565),
                  background : const Color(0xffe4e5eb),
                  buttonColor : const Color(0xfff7f5f7),
                  inactiveColor : const Color(0xff636f7b),
                ):Container(),]
          ),
          SizedBox(height: 10,),

          isTextNoNJordianian==false?

          BlocBuilder<GetPostPaidGSMMSISDNListBloc,GetPostPaidGSMMSISDNListState>(
              builder: (context, state) {
                if (state is GetPostPaidGSMMSISDNListSuccessState ||
                    state is GetPostPaidGSMMSISDNListLoadingState ||
                    state is GetPostPaidGSMMSISDNListErrorState) {
                  MSISDN = [];
                  if (state is GetPostPaidGSMMSISDNListSuccessState) {
                    MSISDN = [];
                    for (var obj in state.data) {

                      MSISDN.add(obj.toString());
                    }
                  }
                  return Container(
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white,

                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        //color: Color(0xFFB10000), red color
                        color: emptyMSISDN == true
                            ? Color(0xFFB10000)
                            : Color(0xFFD1D7E0),
                      ),
                    ),
                    child:CustomSearchableDropDown(
                      items: MSISDN,
                      dropdownHintText: "Personal_Info_Edit.select_an_option".tr().toString() ,


                      decoration: BoxDecoration(

                          borderRadius: BorderRadius.circular(4),
                          border:null
                      ),


                      dropDownMenuItems: MSISDN?.map((item) {
                        return item;
                      })?.toList() ??
                          [],
                      onChanged: (value){
                        if(value!=null)
                        {
                          msisdn = value;
                        }
                        else{
                          msisdn=null;
                        }
                      },

                    ),

                  );
                } else {
                  return Container();
                }
              }):
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                alignment: Alignment.centerLeft,
                height: 58,
                child: TextField(
                  controller: msisdnNumber,
                  maxLength: 10,
                  buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
                  onTap: () {
                    FocusScope.of(context).unfocus();
                  },
                  keyboardType: TextInputType.phone,
                  style: TextStyle(color: Color(0xff11120e)),
                  decoration: InputDecoration(
                    enabledBorder: emptyMSISDNNumber == true || errorMSISDNNumber ==true?
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
                      onPressed: clearMsisdn,
                      icon: Icon(
                          Icons.close
                      ),
                      color: Color(0xFFA4B0C1),
                    ),
                    hintText: "Postpaid.enter_msisdn".tr().toString(),
                    hintStyle: TextStyle(color: Color(0xffa4b0c1), fontSize: 14),
                  ),
                ),
              ),
              emptyMSISDNNumber  == true
                  ? ReusableRequiredText(
                  text: "Postpaid.passportNo_required".tr().toString())
                  : Container(),
              errorMSISDNNumber==true ?ReusableRequiredText(
                  text:  EasyLocalization.of(context).locale == Locale("en", "US")
                      ? "Your MSISDN should be 10 digit and valid"
                      : "رقم الهاتف يجب أن يتكون من 10 خانات وصالح "): Container(),
            ],
          ),
          SizedBox(height: 10,),
          emptyMSISDN  == true
              ? ReusableRequiredText(
              text: "Postpaid.nationalNo_required".tr().toString())
              : Container(),
        ],
      ),
    );
  }




  Widget _buildListPanel(){return ExpansionPanelList(
    expansionCallback: (int index, bool isExpanded){
      if (isExpanded == false) {
        for (final item in _data) {
          if (_data[index] != item) {
            setState(() {
              item.isExpanded = true;
              msisdn=null;
              nationalNo.text='';
              passportNo.text='';
              msisdnNumber.text='';
              isTextJordianian=false;
              isTextNoNJordianian=false;

            });
          }
          setState(() {
            item.isExpanded = false;
            msisdn=null;
            nationalNo.text='';
            passportNo.text='';
            msisdnNumber.text='';
            isTextJordianian=false;
            isTextNoNJordianian=false;

          });
        }
      }
      setState(() {
        _data[index].isExpanded = !isExpanded;
        isTextJordianian=false;
        isTextNoNJordianian=false;

      });

      _data[index].headerValue=='Jordanian' || _data[index].headerValue=='أردني'?setState(() {
        isJordanian = true;
        isTextJordianian=false;

      }):setState(() {
        isJordanian = false;
        isTextNoNJordianian=false;

      });
    },
    children:

    _data.map<ExpansionPanel>((Item item){
      return  isJordanian == true ?
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
            title:Column(
              children: [
                marketType=="GSM"? buildMSISDNListJordainian(): buildMSISDNNumber(),
                SizedBox(height: 10,),
                nationalNumber()
              ],
            )

            ,
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
              title:
              Column(
                children: [
                  marketType=="GSM"? buildMSISDNListNonJordainian(): buildMSISDNNumber(),
                  SizedBox(height: 10,),
                  passportNumber()
                ],
              )


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
