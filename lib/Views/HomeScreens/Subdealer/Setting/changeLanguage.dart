import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../CustomBottomNavigationBar.dart';
import 'SettingsScreen.dart';
class ChangeLanguage extends StatefulWidget {

  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  ChangeLanguage({this.Permessions,this.role,this.outDoorUserName});
  @override
  _ChangeLanguageState createState() => _ChangeLanguageState(this.Permessions,this.role,this.outDoorUserName);
}
class _ChangeLanguageState extends State<ChangeLanguage> {
  int selectedLanguage= -1 ;
  final List<dynamic> Permessions;
  var role;
  var outDoorUserName;
  _ChangeLanguageState(this.Permessions,this.role,this.outDoorUserName);

  void initState() {
   getSharedPrefernece();
  }
  void getSharedPrefernece() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      selectedLanguage = prefs.getInt('lang')==null ? 2 :prefs.getInt('lang') ;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          //tooltip: 'Menu Icon',
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SettingsScreen(Permessions:Permessions,role:role,outDoorUserName: outDoorUserName,),
              ),
            );
          },
        ),
        centerTitle:false,
        title: Text(
          "Settings_Form.change_language".tr().toString(),
        ),
        backgroundColor: Color(0xFF4f2565),
      ),
      backgroundColor: Color(0xFFEBECF1),
      body: ListView(padding: EdgeInsets.only(top: 10), children: <Widget>[
        Container(
          child: Column(
            children: [
              Container(
                color: Colors.white,
                child: Center(
                  child: ListView(shrinkWrap: true, children: [
                    RadioListTile(
                        title: Text(
                          "عربي",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                        value: 1,
                        groupValue: selectedLanguage ,
                        activeColor: Color(0xFF4f2565),
                        onChanged: (value)  {
                          setState(() {
                           selectedLanguage = value;
                         });
                          print(value);

                        }),
                    Divider(
                      thickness: 1,
                      color: Color(0xFFedeff3),
                    ),
                    RadioListTile(
                        title: Text(
                          "English",
                          style: TextStyle(
                              fontSize: 14,
                              color: Color(0xff11120e),
                              fontWeight: FontWeight.normal),
                        ),
                        value: 2,
                        groupValue: selectedLanguage ,
                        activeColor: Color(0xff4f2565),
                        onChanged: (value) {
                          setState(() {
                            selectedLanguage = value;

                          });
                          print(value);

                        }),
                  ]),
                ),
              ),
            ],
          ),
        )
        ,
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.only(left: 15, right: 15),
          child: Column(
            children: <Widget>[
              Container(
                height: 48,
                width: 420,
                margin: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50),
                  color: Color(0xFF4f2565),
                ),
                child: TextButton(

                  onPressed: () async {
                    print(selectedLanguage);
                    SharedPreferences prefs = await SharedPreferences.getInstance();
                    if(selectedLanguage==1 ){
                      context.setLocale(Locale('ar', 'AR'));
                      prefs.setInt('lang',1);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomBottomNavigationBar(Permessions: Permessions,role: role,outDoorUserName: outDoorUserName,),
                        ),
                      );
                    }
                    else if(selectedLanguage==2 ){
                      context.setLocale(Locale('en', 'US'));
                      prefs.setInt('lang',2);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CustomBottomNavigationBar(Permessions: Permessions,role:role,outDoorUserName: outDoorUserName,),
                        ),
                      );
                    }

                  },
                  style: TextButton.styleFrom(
                    backgroundColor:Color(0xFF4f2565),
                    shape: const BeveledRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(24))),
                  ),
                  child: Text(
                    "Settings_Form.save_changes".tr().toString(),
                    style: TextStyle(
                        color: Colors.white,
                        letterSpacing: 0,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 20),
      ]),
    );
  }
}
