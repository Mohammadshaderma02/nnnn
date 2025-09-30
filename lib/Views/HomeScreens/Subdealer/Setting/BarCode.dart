/*
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/CustomBottomNavigationBar.dart';
import 'package:sales_app/Views/ReusableComponents/requiredText.dart';
import 'package:sales_app/blocs/ChangePassword/changePassword_bloc.dart';
import 'package:sales_app/blocs/ChangePassword/changePassword_events.dart';
import 'package:sales_app/blocs/ChangePassword/changePassword_state.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';

import 'SettingsScreen.dart';

class BarCode extends StatefulWidget {
  final List<dynamic> Permessions;
  BarCode({this.Permessions});


  @override
  _BarCodeState createState() => _BarCodeState(this.Permessions);

}

class _BarCodeState extends State<BarCode> {
  int selectedLanguage = 2;
  bool showPassword = true;
  bool showConfirmPassword = true;
  bool emptyOldPassword = false;
  bool emptyNewPassword = false;
  bool emptyConfirmPassword = false;

  String _data="";
  final List<dynamic> Permessions;
  _BarCodeState(this.Permessions);

  FocusNode passwordFocusNode;
  FocusNode confirmPasswordFocusNode;
  TextEditingController old_password = TextEditingController();
  TextEditingController new_password = TextEditingController();
  TextEditingController confirm_password = TextEditingController();

  ChangePasswordBloc changePasswordBloc;
  @override
  void initState() {
    changePasswordBloc = BlocProvider.of<ChangePasswordBloc>(context);

    super.initState();
    passwordFocusNode = FocusNode();
    confirmPasswordFocusNode = FocusNode();
  }



  @override
  void dispose() {
    super.dispose();
    passwordFocusNode.dispose();
    confirmPasswordFocusNode.dispose();
  }







  @override
  Widget build(BuildContext context) {

    _Scan() async{
      await FlutterBarcodeScanner.scanBarcode("#ff6666", "Cancel", true, ScanMode.BARCODE).then((value)=>setState(()=>_data=value));
      print("haya");
      print(_data);
    }

    return Scaffold(
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
        title: Text(
         "Barcode",
        ),
        backgroundColor: Color(0xFF4f2565),
      ),
      backgroundColor: Color(0xFFEBECF1),
      body: ListView(padding: EdgeInsets.only(top: 10), children: <Widget>[
    ( _data != ''?
    Container(
      height: 58,
      color: Colors.white,
      padding: EdgeInsets.only(left: 15, right: 15),
      child: Column(
        children: <Widget>[

          Text(
            "Barcode Value is "+ _data,
            style: TextStyle(
              color: Colors.black,
              fontSize: 16,
            ),
          ),

        ],
      ),
    ):Container()),

        SizedBox(height: 20),

        Container(
          height: 48,
          width: 420,
          margin: EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: Color(0xFF4f2565),
          ),
          child: RaisedButton(
            elevation: 0,
            color: Color(0xFF4f2565),
              onPressed:()=> _Scan(),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            child: Text(
              "Scan Barcode",
              style: TextStyle(
                  color: Colors.white,
                  letterSpacing: 0,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ]),
    );
  }
}
*/
