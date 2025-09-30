import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:sales_app/Animation/FadeAnimation.dart';
import 'package:sales_app/Views/Biometric/Biometric_FaceID.dart';
import 'package:sales_app/Views/Biometric/Biometric_FingerPrint.dart';
import 'package:sales_app/Views/ForgerPasswordScreens/ForgetPasswordScreen.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/newAccountsDocumentsChecking.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/Eshope_Menu.dart';
import 'package:sales_app/Views/HomeScreens/DeliveryEShop/OrdersScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/CustomBottomNavigationBar.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/Multi_Use_Components/CorpNavigationBar.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/RaiseTicket/SubmitTicket.dart';
import 'package:sales_app/Views/HomeScreens/ZainOutdoorHeads/ZainOutdoorHeads_Dashboard.dart';
import 'package:sales_app/Views/ReusableComponents/headerSection.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/Views/ReusableComponents/erroreLabel.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Login/login_bloc.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/Login/login_state.dart';
import 'package:local_auth/local_auth.dart';
import 'dart:async';


import 'package:shared_preferences/shared_preferences.dart';
import 'package:variable_app_icon/variable_app_icon.dart';
/*2023*/
/*const List<String> androidIconIds = [
  "appicon.DEFAULT",
  "appicon.Mada",
  "appicon.Zain"
];*/

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreen createState() => _SignInScreen();
}

class Item {
  const Item(this.value, this.text);
  final String value;
  final String text;
}


class _SignInScreen extends State<SignInScreen> {
  LocalAuthentication auth = LocalAuthentication();
  bool _canCheckBiometrics;
  List<BiometricType> _availableBiometrics = List<BiometricType>();
  var hasFingerPrintLock = false;
  bool hasFaceLock = false;
  var Permessions =[];
  var PermessionCorporate =[];
  var PermessionDeliveryEShop=[];
  var PermessionZainOutdoorHeads=[];
  var PermessionDealerAgent=[];
  var PermessionReseller=[];
  var role ='';
  var isUserAuthenticated = false;
  String autherized = "Not autherized";
  bool isRememberMe = false;
  bool isRememberMeSaved= false;
  String userNameSaved='';
  String passwordSaved='';
  bool isSwitched = false;
  bool userTypeEmptyFlag = false;
  bool userNameEmptyFlag = false;
  bool passwordEmptyFlag = false;
  bool isDisabled = false;
  bool _isObscure = true;
  TextEditingController tawasol_number ;
  TextEditingController password;
  FocusNode passwordFocusNode;
  String userType = '4';
  LoginBloc loginBlock;
  Timer _timer;
  int _start;
  String _text;
  String isFirstLogin='';
  DateTime backButtonPressedTime;
  int currentIconIndex = 0;




  @override
  void initState() {
    getSharedPrefernece();

    loginBlock = BlocProvider.of<LoginBloc>(context);
    passwordFocusNode = FocusNode();
    tawasol_number = TextEditingController();
    password = TextEditingController();
    loginBlock.add(StartEvent());
    super.initState();
    _getAvailableBiometrics();
    _checkBiometric();
    // loadCurrentIcon();

  }
/*2023*/
  /*Future<void> loadCurrentIcon() async {
    final prefs = await SharedPreferences.getInstance();
    final index = prefs.getInt("currentIconIndex") ?? currentIconIndex;
    setState(() {
      currentIconIndex = index;
    });
  }

  Future<void> changeIcon( index) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("currentIconIndex", index);
    print(index);
    setState(() {
      currentIconIndex = index;
    });
    await VariableAppIcon.changeAppIcon(
        androidIconId: androidIconIds[currentIconIndex]);
  }*/

  void getSharedPrefernece() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Permessions = prefs.getStringList('Permessions') ?? [];
    PermessionCorporate = prefs.getStringList('PermessionCorporate') ?? [];
    PermessionDeliveryEShop= prefs.getStringList('PermessionDeliveryEShop')??[];
    PermessionReseller=prefs.getStringList('PermessionReseller')??[];
    role =prefs.get('role');
    print('SignScreen ${Permessions}');
    print('SIGNSCREEN ${PermessionCorporate}');
    print('SignScreen${PermessionDeliveryEShop}');
    print('PermessionReseller${PermessionReseller}');
    isSwitched = prefs.getBool('BiometriceSwitchedIn') == null
        ? false
        : prefs.getBool('BiometriceSwitchedIn');
    bool isRememberMeSaved= prefs.getBool("isRememberMe");
    tawasol_number.text=prefs.getString("userName");
    if(isRememberMeSaved==true){
      tawasol_number.text=prefs.getString("userName");
      password.text=prefs.getString("password");
      isRememberMe=prefs.getBool('isRememberMe');
    }

    if(prefs.getInt('lang')!=null && prefs.getInt('lang')==1){

      context.setLocale(Locale('ar', 'AR'));
    }else{
      context.setLocale(Locale('en', 'US'));
    }


  }

  void changeSwitched(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('BiometriceSwitchedIn', value);
    setState(() {
      isSwitched = prefs.getBool('BiometriceSwitchedIn');
    });
  }

  void startTimer() {
    _start = 30;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        if (_start == 0) {
          setState(() {
            timer.cancel();
            isDisabled = false;
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
  // ignore: missing_retur
  final msg = BlocBuilder<LoginBloc, LoginState>(builder: (context, state) {
    if (state is LoginLoadingState) {
      return Center(
          child: Container(
            padding: EdgeInsets.only(bottom: 10),
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF348A98)),
            ),
          ));
    } else {
      return Container();
    }
  });
  Widget buildUserNameError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color:  Color(0xFF9C0101),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Color(0xFFFF0000),

                width: 1,
              )),
          height: 30,
          child: ErroreLabel(
              text: "Login_Form.userName_required"
                  .tr()
                  .toString()),
        )
      ],
    );
  }
  Widget buildUserName() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Login_Form.userName".tr().toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color: userNameEmptyFlag
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: userNameEmptyFlag
                    ? Color(0xFFaf9090)
                    : Colors.white,
                width: userNameEmptyFlag ? 1 : 0,
              )),
          height: 58,
          child: TextField(

            controller: tawasol_number,
            maxLength: 10,

            buildCounter: (BuildContext context, { int currentLength, int maxLength, bool isFocused }) => null,
            keyboardType: TextInputType.phone,
            style: TextStyle(color: Color(0xFFFFFFFF)),
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.all(16),
              hintText: "Login_Form.userName".tr().toString(),
              hintStyle: TextStyle(color: Color(0xFF99B7C3), fontSize: 14),
            ),
          ),
        )
      ],
    );
  }
  Widget buildPasswordError() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // SizedBox(height: 10),
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
              color:  Color(0xFF9C0101),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: Color(0xFFFF0000),

                width: 1,
              )),
          height: 30,
          child: ErroreLabel(
              text: "Login_Form.password_required"
                  .tr()
                  .toString()),
        )
      ],
    );
  }
  Widget buildPassword() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Login_Form.password".tr().toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ForgetPassword(tawasol_number.text,"0"),
                    ),
                  );
                  // Navigator.pushNamed(context, '/ForgetPassword',);
                },

                child: Text(
                  "Login_Form.forget_password".tr().toString(),
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          Container(
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: passwordEmptyFlag
                  ? Color(0xFFB10000).withOpacity(0.1)
                  : Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(
                color: passwordEmptyFlag
                    ? Color(0xFFaf9090)
                    : Colors.white,
                width: passwordEmptyFlag ? 1 : 0,
              ),
            ),
            height: 58,
            child: TextField(
              controller: password,
              obscureText: _isObscure,
              style: TextStyle(
                color: Color(0xFFFFFFFF),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.all(16),
                suffixIcon: IconButton(
                  onPressed: _togglePasswordView,
                  icon: Icon(
                    _isObscure ? Icons.visibility : Icons.visibility_off,
                  ),
                  color: Colors.white,
                ),
                hintText: "Login_Form.password".tr().toString(),
                hintStyle: TextStyle(color: Color(0xFF99B7C3), fontSize: 14),
              ),
            ),
          ),
        ]);
  }
  void _togglePasswordView() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }
  Widget buildUserType() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          "Login_Form.user_type".tr().toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
        SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: userTypeEmptyFlag
                ? Color(0xFFB10000).withOpacity(0.1)
                : Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: userTypeEmptyFlag
                  ? Color(0xFFaf9090)
                  : Colors.white,
              width: userTypeEmptyFlag ? 1 : 0,
            ),
          ),
          height: 58,
          child: Container(
              child: DropdownButtonHideUnderline(
                child: ButtonTheme(
                  alignedDropdown: true,
                  child: DropdownButton<String>(
                    //      hint: Text(
                    //     "Login_Form.select_userType".tr().toString(),
                    //      style: TextStyle(
                    //     color: Color(0xFF99B7C3),
                    //     fontSize: 14,
                    //   ),
                    // ),
                    dropdownColor: Color(0xFF1f5f7b),
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    iconSize: 30,
                    iconEnabledColor: Colors.white,
                    underline: SizedBox(),
                    isExpanded: true,
                    style: TextStyle(
                      color: Color(0xFFFFFFFF),
                      fontSize: 14,
                    ),
                    items:[
                      DropdownMenuItem(
                        child: Text( "Login_Form.subdealer".tr().toString(),),
                        value: '4',
                      ),
                      DropdownMenuItem(
                          child: Text( "Login_Form.corporate".tr().toString(),),
                          value: '3'
                      ),
                      DropdownMenuItem(
                        child: Text( "Login_Form.outdoor".tr().toString(),),
                        value: '2',
                      ),
                    ],
                    onChanged: (String value) {
                      setState(() {
                        userType  = value;
                      });
                    },

                    value:userType,

                  ),
                ),
              )),
        ),
      ],
    );
  }
  Widget buildForgotPassBtn() {
    return Container(
      alignment: EasyLocalization.of(context).locale == Locale("en", "US")
          ? Alignment.centerRight
          : Alignment.centerLeft,
    );
  }
  Widget buildRememberCb() {
    return Container(
      alignment: EasyLocalization.of(context).locale == Locale("en", "US")
          ? Alignment.centerLeft
          : Alignment.centerRight,
      height: 20,
      child: Row(
        children: <Widget>[
          Theme(
              data: ThemeData(
                unselectedWidgetColor: Colors.white,
              ),
              child: Checkbox(
                value: isRememberMe,
                checkColor: Color(0xFF127485),
                activeColor: Colors.white,
                onChanged: (bool value) {
                  setState(() {
                    isRememberMe = value;
                  });
                },
              )),
          SizedBox(
            width: 10,
          ),
          Text(
            "Login_Form.remember_me".tr().toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );
  }
  Future<void> _checkBiometric() async {
    bool canCheckBiometric;
    try {
      canCheckBiometric = await auth.canCheckBiometrics;
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;
    setState(() {
      _canCheckBiometrics = canCheckBiometric;
    });
  }
  Future<void> _getAvailableBiometrics() async {
    List<BiometricType> availableBiometric;
    try {
      //availableBiometric = await auth.getAvailableBiometrics();
      List<BiometricType> availableBiometric =
      await auth.getAvailableBiometrics();
      hasFaceLock = availableBiometric.contains(BiometricType.face);
      hasFingerPrintLock =
          availableBiometric.contains(BiometricType.fingerprint);
    } on PlatformException catch (e) {
      print(e);
    }
    if (!mounted) return;

    setState(() {
      _availableBiometrics = availableBiometric;
    });
  }
  Widget buildEnableBiometric() {
    // final biometrics = await _getAvailableBiometrics();
    return Container(
      padding:EdgeInsets.only(left: 0),
      height: 20,
      child: Row(
        children: <Widget>[
          Switch(
            value: isSwitched,
            onChanged: (value) {
              _canCheckBiometrics == true
                  ? changeSwitched(value)
                  : Fluttertoast.showToast(
                  msg: EasyLocalization.of(context).locale ==
                      Locale("en", "US")
                      ? 'Your device does not support beiometric authentication'
                      : 'جهازك لا يدعم المقاييس الحيوية',
                  backgroundColor: Color(0xFF323232),

                  textColor: Colors.white);
            },
            activeTrackColor: Color(0xFF348A98),
            activeColor: Color(0xFF2ed9c3),
            inactiveTrackColor: Color(0xFF767699),
          ),
          Text(
            "Login_Form.enable_biometric".tr().toString(),
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          )
        ],
      ),
    );

  }
  Widget buildLoginBtn() {
    return Column(children: [
      isDisabled == true
          ? Text(
        EasyLocalization.of(context).locale == Locale("en", "US")
            ? "Try again in $_start seconds"
            : "حاول مرة أخرى في $_start ثانية ",
        style: TextStyle(
            color: Colors.white,
            letterSpacing: 0,
            fontSize: 14,
            fontWeight: FontWeight.bold),
      )
          : Container(),
      SizedBox(
        height: isDisabled == true ? 16 : 0, //*
      ),
      Container(
        height: 48,
        width: 400,
        margin: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50), color: Colors.white),
        child: TextButton(
          // disabledColor: Colors.white.withOpacity(0.50),
          onPressed: isDisabled
              ? null
              : () async {
            print('hello');
            if (tawasol_number.text == '') {
              setState(() {
                userNameEmptyFlag = true;
              });
            }
            if (password.text == '') {
              setState(() {
                passwordEmptyFlag = true;
              });
            }
            /* if (userType == null) {
              setState(() {
                userTypeEmptyFlag = true;
              });
            }*/
            if (tawasol_number.text != '') {
              setState(() {
                userNameEmptyFlag = false;
              });
            }
            if (password.text != '') {
              setState(() {
                passwordEmptyFlag = false;
              });
            }
            /*  if (userType != null) {
              setState(() {
                userTypeEmptyFlag = false;
              });
            }*/
            if (tawasol_number.text != '' &&
                password.text != '' ) {

              var tawasolNumberLeft =tawasol_number.text.trimLeft();
              var TawasolNumberRight =tawasolNumberLeft.trimRight();
              loginBlock.add(LoginButtonPressed(
                  userName: TawasolNumberRight,
                  password: password.text,
                  //userType: userType,
                  userType: "0",
                  isRememberMe: isRememberMe,
                  isSwitched: isSwitched)
              );
            }
          },
          style: TextButton.styleFrom(
            backgroundColor:  isDisabled  ? Colors.white.withOpacity(0.50): Colors.white,
            shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
          ),
          child: Text(
            "Login_Form.login".tr().toString(),
            style: TextStyle(
                color: Color(0xFF4f2565),
                letterSpacing: 0,
                fontSize: 16,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    ]);
  }
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
        Navigator.pop(context);

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

  showAlertDialogInactivity(BuildContext context, arabicMessage, englishMessage) {
    Widget tryAgainButton = TextButton(
      child: Text(
        "alert.tryAgain".tr().toString(),
        style: TextStyle(
          color: Color(0xFF4f2565),
          fontSize: 16,
        ),
      ),
      onPressed: () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => SignInScreen(),
          ),
        );
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

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();
    bool backButton = backButtonPressedTime == null ||
        currentTime.difference(backButtonPressedTime) > Duration(seconds: 3);
    print(backButton);
    if (backButton) {
      backButtonPressedTime = currentTime;
      Fluttertoast.showToast(
          msg: EasyLocalization.of(context).locale == Locale("en", "US")
              ? 'Double click to exit'
              : 'انقر مرتين لخروج',
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop,
      child:BlocListener <LoginBloc, LoginState>(
          listener: (context, state) {

            if (state is LoginErrorState) {
              showAlertDialog(
                  context, state.arabicMessage, state.englishMessage);
            }
            if (state is LoginErrorTokenState) {
              showAlertDialogInactivity(
                  context, 'لقد تم تسجيل الخروج نظراً لعدم وجود اي نشاط','You have been logged out due to inactivity');
            }
            if (state is SubdealerLoginSuccessState) {
              print('SubdealerLoginSuccessStateSubdealerLoginSuccessStateSubdealerLoginSuccessStateSubdealerLoginSuccessState');
              print(state.userName);
              print(state.Permessions);
              print(state.role);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder:(context)=>CustomBottomNavigationBar
                      (
                        Permessions:state.Permessions,role:state.role,
                        outDoorUserName:state.userName)
                ),
              );

            }
            else if (state is CorporateLoginSuccessState) {
              print('CorporateLoginSuccessState CorporateLoginSuccessState CorporateLoginSuccessState');

              print(state.PermessionCorporate);
              print(state.role);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder:(context)=>CorpNavigationBar(PermessionCorporate: state.PermessionCorporate,role:state.role)
                ),
              );

              /* Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder:(context)=>Home(state.PermessionCorporate,state.role,state.userName )
                ),
              );*/
            }
            else if (state is ResellerLoginSuccessState) {
              print('ResellerLoginSuccessState');

              print(state.PermessionReseller);
              print(state.role);
              Navigator.pushReplacement( context, MaterialPageRoute( builder:(context)=>NewAccountDocumnetChecking(state.PermessionReseller,state.role) ),);

              /* Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder:(context)=>Home(state.PermessionCorporate,state.role,state.userName )
                ),
              );*/
            }
            else if (state is DeliveryEShopLoginSuccessState) {
              print('PermessionDeliveryEShop PermessionDeliveryEShop');

              print(state.PermessionDeliveryEShop);
              print(state.role);

              Navigator.pushReplacement(
                context,
               /* MaterialPageRoute(
                  builder: (context) => OrdersScreen(),
                ),*/
                MaterialPageRoute(builder: (context) => Eshope_Menu()),
              );
            }
            else if (state is ZainOutdoorHeadsLoginSuccessState) {
              print('PermessionZainOutdoorHeads');

              print(state.PermessionZainOutdoorHeads);
              print(state.role);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => ZainOutdoorHeads_Dashboard(PermessionZainOutdoorHeads:state.PermessionZainOutdoorHeads,role:state.role, outDoorUserName:
                    state.userName)),
              );
            }
            else if (state is DealerAgentLoginSuccessState) {
              print('PermessionDealerAgent');

              print(state.PermessionDealerAgent);
              print(state.role);

              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder:(context)=>CustomBottomNavigationBar
                      (
                        Permessions:state.PermessionDealerAgent,role:state.role,
                        outDoorUserName:state.userName)
                ),
              );
            }
            else if (state is SubdealerLoginSuccessStateWithBiometric) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BiometricFingerPrint(),
                ),
              );
            }
            else if (state is CorporateLoginSuccessStateWithBiometric) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BiometricFingerPrint(),
                ),
              );
            }
            else if (state is ResellerLoginSuccessStateWithBiometric) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BiometricFingerPrint(),
                ),
              );
            }
            else if (state is DeliveryEShopLoginSuccessStateWithBiometric) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BiometricFingerPrint(),
                ),
              );
            }
            else if (state is ZainOutdoorHeadsLoginSuccessStateWithBiometric) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BiometricFingerPrint(),
                ),
              );
            }
            else if (state is DealerAgentLoginSuccessStateWithBiometric) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => BiometricFingerPrint(),
                ),
              );
            }
            else if (state is DisabeledLoginState) {
              startTimer();
              isDisabled = true;
            }
          },
          child: Scaffold(
            body: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xFF008388), Color(0xFF4f2565)],
                ),
              ),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 40, //*
                  ),
                  HeaderSection(
                    text: "Login_Form.language".tr().toString(),
                  ),
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: Column(
                          children: <Widget>[
                            SizedBox(height: 10),
                            Center(
                              child: Image(image: AssetImage('assets/images/loginIcon.png'),
                                  width: 184,
                                  height: 184
                              ),),

                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(left: 25, right: 25),
                              child: Column(
                                children: <Widget>[
                                  /*buildUserType(),
                                    SizedBox(height: 10),
                                    userTypeEmptyFlag == true
                                        ? ReusableRequiredText(
                                        text: "Login_Form.userType_required"
                                            .tr()
                                            .toString())
                                        : Container(),
                                    SizedBox(height: 15),*/
                                  buildUserName(),
                                  SizedBox(height: 10),
                                  userNameEmptyFlag == true
                                      ?buildUserNameError()
                                      : Container(),
                                  SizedBox(height: 5),
                                  buildPassword(),
                                  SizedBox(height: 10),
                                  passwordEmptyFlag == true
                                      ?buildPasswordError()
                                      : Container(),

                                ],
                              ),
                            ),
                            Container(
                              child: Column(children: [
                                SizedBox(height: 18),
                                Container(
                                    padding: EdgeInsets.only(left: 15, right: 25),
                                    child:buildRememberCb()),
                                SizedBox(height: 18,),
                                Container(
                                    padding: EdgeInsets.only(left: 15, right: 25),
                                    child:buildEnableBiometric()),
                                SizedBox(height: 50),
                                msg,
                                Container(
                                    padding: EdgeInsets.only(left: 20, right: 20),
                                    child: buildLoginBtn()),
                                SizedBox(height: 10),
                              ],),
                            ),

                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          )),
    );

  }
}
