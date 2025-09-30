import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/AccountManager/Account.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Home/Home.dart';

import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/Settings/Settings.dart';
import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/RaiseTicket/RaiseTicket.dart';
//import 'package:sales_app/Views/HomeScreens/Corporate/MainPages/LogVisit.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MainPages/Home/LogVisit/LogVisitMain.dart';
import '../MainPages/Home/LogVisit/SelectUser.dart';

class CorpNavigationBar extends StatefulWidget {

  //var PermessionCorporate;
  final List<dynamic> PermessionCorporate ;
  final String role;

  CorpNavigationBar({this.PermessionCorporate,this.role});

  @override
  _CorpNavigationBarState createState() =>
      _CorpNavigationBarState(this.PermessionCorporate,this.role);
}

class _CorpNavigationBarState extends State<CorpNavigationBar> {
  int _currentIndex = 0;
  final List<dynamic> PermessionCorporate ;
  // var PermessionCorporate;
  var role;


  List<Widget> _children;
  _CorpNavigationBarState(this.PermessionCorporate,this.role);

  void getSavePageIndex()async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.getInt('SavePageIndex');
    print("**********************SavePageIndex*****************************");
    print(prefs.getInt('SavePageIndex'));
    print("*****************************************************************");

    if(prefs.containsKey("SavePageIndex")){
      print("onTappedBar in if");
      setState(() {
        _currentIndex = prefs.getInt('SavePageIndex');
      });
      print(_currentIndex);
    }
  }
  void initState() {
    print('Haya Hazaimeh ${PermessionCorporate} ${role} ');

    getSavePageIndex();
    PermessionCorporate.contains('06')==false?
    _children= [
      RaiseTicket(PermessionCorporate,role),
      SelectUser(PermessionCorporate,role),
      Account(PermessionCorporate,role),
      Settings(PermessionCorporate,role)]
        :PermessionCorporate.contains('08')==false?
    _children= [
      Home(PermessionCorporate,role),
      SelectUser(PermessionCorporate,role),
      Account(PermessionCorporate,role),
      Settings(PermessionCorporate,role)]
        :PermessionCorporate.contains('09')==false?
    _children= [
      Home(PermessionCorporate,role),
      RaiseTicket(PermessionCorporate,role),
      Account(PermessionCorporate,role),
      Settings(PermessionCorporate,role)]
        :PermessionCorporate.contains('10')==false?
    _children= [
      Home(PermessionCorporate,role),
      RaiseTicket(PermessionCorporate,role),
      SelectUser(PermessionCorporate,role),
      Settings(PermessionCorporate,role)]:
    PermessionCorporate.contains('07')==false?
    _children= [
      Home(PermessionCorporate,role),
      RaiseTicket(PermessionCorporate,role),
      SelectUser(PermessionCorporate,role),
      Account(PermessionCorporate,role),
    ]:

    _children= [
      Home(PermessionCorporate,role),
      RaiseTicket(PermessionCorporate,role),
      SelectUser(PermessionCorporate,role),
      Account(PermessionCorporate,role),
      Settings(PermessionCorporate,role)
    ];

    if(   PermessionCorporate.contains('06')==false
        &&PermessionCorporate.contains('08')==false
        &&PermessionCorporate.contains('09')==false
        &&PermessionCorporate.contains('10')==false
        &&PermessionCorporate.contains('07')==false )
    {_children=[Settings(PermessionCorporate,role)
    ];
    }

    super.initState();
  }



  static const List<Widget> _pages = <Widget>[
    Icon(
      Icons.home,
    ),
    Icon(
      Icons.account_tree,
    ),
    Icon(
      Icons.person,
    ),
    Icon(
      Icons.settings,
    ),
    // Icon(
    //   Icons.chat,
    //   size: 150,
    // ),
  ];

  void onTappedBar(int index) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();


      print("onTappedBar in else");

      setState(() {
        _currentIndex = index;
      });
      print(_currentIndex);



  }


  //final List<Widget> _children = [Home(), Tawasol(), Profile(), Menu()];

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
      body:_children[_currentIndex],
      bottomNavigationBar: PermessionCorporate.contains('06')==false
          &&PermessionCorporate.contains('08')==false
          &&PermessionCorporate.contains('09')==false
          &&PermessionCorporate.contains('10')==false
          &&PermessionCorporate.contains('07')==false?null:
      BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: onTappedBar,
        selectedItemColor: Color(0xFF392156),
        unselectedItemColor: Color(0xFF778ca2),
        selectedLabelStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
        //selectedFontSize: 14,
        items:
        PermessionCorporate.contains('06')==false?
        [
          BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(
                Icons.note_add,
              )
                  : Icon(
                Icons.note_add_outlined,
              ),
              label: "corpNavBar.Raise_Ticket".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(
                Icons.person_pin_circle,
              )
                  : Icon(
                Icons.person_pin_circle,
              ),
              label: "corpNavBar.Log_Visit".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(
                  Icons.account_circle
              )
                  : Icon(
                Icons.account_circle_outlined,
              ),
              label: "corpNavBar.Account".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? Icon(
                  Icons.settings
              )
                  : Icon(
                  Icons.settings
              ),
              label:"corpNavBar.Settings".tr().toString()),
        ]
            :PermessionCorporate.contains('08')==false?[
          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(
                Icons.home,
              ) : Icon(
                Icons.home_outlined,
              ),

              label: "corpNavBar.Home".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(
                Icons.person_pin_circle,
              )
                  : Icon(
                Icons.person_pin_circle,
              ),
              label: "corpNavBar.Log_Visit".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(
                  Icons.account_circle
              )
                  : Icon(
                Icons.account_circle_outlined,
              ),
              label: "corpNavBar.Account".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? Icon(
                  Icons.settings
              )
                  : Icon(
                  Icons.settings
              ),
              label:"corpNavBar.Settings".tr().toString()),
        ]
            :PermessionCorporate.contains('09')==false?[
          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(
                Icons.home,
              ) : Icon(
                Icons.home_outlined,
              ),

              label: "corpNavBar.Home".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(
                Icons.note_add,
              )
                  : Icon(
                Icons.note_add_outlined,
              ),
              label: "corpNavBar.Raise_Ticket".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(
                  Icons.account_circle
              )
                  : Icon(
                Icons.account_circle_outlined,
              ),
              label: "corpNavBar.Account".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? Icon(
                Icons.settings,
              )
                  : Icon(
                Icons.settings,
              ),
              label:"corpNavBar.Settings".tr().toString()),

        ]

            :PermessionCorporate.contains('10')==false?[
          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(
                Icons.home,
              ) : Icon(
                Icons.home_outlined,
              ),

              label: "corpNavBar.Home".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(
                Icons.note_add,
              )
                  : Icon(
                Icons.note_add_outlined,
              ),
              label: "corpNavBar.Raise_Ticket".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(
                Icons.person_pin_circle,
              )
                  : Icon(
                Icons.person_pin_circle,
              ),
              label: "corpNavBar.Log_Visit".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? Icon(
                  Icons.settings
              )
                  : Icon(
                Icons.settings,
              ),
              label:"corpNavBar.Settings".tr().toString()),
        ]:
        PermessionCorporate.contains('07')==false?[
          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(
                Icons.home,
              ) : Icon(
                Icons.home_outlined,
              ),

              label: "corpNavBar.Home".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(
                Icons.note_add,
              )
                  : Icon(
                Icons.note_add_outlined,
              ),
              label: "corpNavBar.Raise_Ticket".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(
                Icons.person_pin_circle,
              )
                  : Icon(
                Icons.person_pin_circle,
              ),
              label: "corpNavBar.Log_Visit".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(
                  Icons.account_circle
              )
                  : Icon(
                Icons.account_circle_outlined,
              ),
              label: "corpNavBar.Account".tr().toString()),

        ]:


        [

          BottomNavigationBarItem(
              icon: _currentIndex == 0
                  ? Icon(
                Icons.home,
              ) : Icon(
                Icons.home_outlined,
              ),

              label: "corpNavBar.Home".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 1
                  ? Icon(
                Icons.note_add,
              )
                  : Icon(
                Icons.note_add_outlined,
              ),
              label: "corpNavBar.Raise_Ticket".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 2
                  ? Icon(
                Icons.person_pin_circle,
              )
                  : Icon(
                Icons.person_pin_circle,
              ),
              label: "corpNavBar.Log_Visit".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 3
                  ? Icon(
                  Icons.account_circle
              )
                  : Icon(
                Icons.account_circle_outlined,
              ),
              label: "corpNavBar.Account".tr().toString()),
          BottomNavigationBarItem(
              icon: _currentIndex == 4
                  ? Icon(
                Icons.settings,
              )
                  : Icon(
                Icons.settings,
              ),
              label:"corpNavBar.Settings".tr().toString()),
        ],
      ),

    );
  }
}