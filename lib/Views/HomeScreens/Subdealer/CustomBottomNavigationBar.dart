import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Dashboard/Dashboard.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Profile/Profile.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Menu/Menu.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Tawasol.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final List<dynamic> Permessions ;
  final String role;
  final String outDoorUserName;
  CustomBottomNavigationBar({this.Permessions,this.role,this.outDoorUserName});

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState(this.Permessions,this.role,this.outDoorUserName);
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  int _currentIndex = 0;
  final List<dynamic> Permessions ;
  var role;
  var  outDoorUserName;
  List<Widget> _children;
  _CustomBottomNavigationBarState(this.Permessions,this.role,this.outDoorUserName);

  void initState() {
    print('PERMIShello ${Permessions} ${role} ${outDoorUserName}');

    Permessions.contains('01')==false?
    _children= [Tawasol(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName), Menu(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName)]
    :Permessions.contains('04')==false?
    _children= [Dashboard(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName), Menu(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName)]
    :Permessions.contains('05')==false?
    _children= [Dashboard(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),Tawasol(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName)]
    : _children= [Dashboard(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),Tawasol(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
      Menu(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName)];

    if(Permessions.contains('05')==false
        &&Permessions.contains('04')==false
        &&Permessions.contains('01')==false)
        {_children=[Menu(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName)
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
      Icons.menu_outlined,
    ),
    // Icon(
    //   Icons.chat,
    //   size: 150,
    // ),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }


  //final List<Widget> _children = [Dashboard(), Tawasol(), Profile(), Menu()];

  @override
  Widget build(BuildContext context) {
    return  new Scaffold(
        body:_children[_currentIndex],
        bottomNavigationBar: Permessions.contains('05')==false
            &&Permessions.contains('04')==false
            &&Permessions.contains('01')==false?null: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: _currentIndex,
              onTap: onTappedBar,
              selectedItemColor: Color(0xFF4f2565),
              unselectedItemColor: Color(0xFF778ca2),
              selectedLabelStyle: TextStyle(fontSize: 12,fontWeight: FontWeight.bold),
              //selectedFontSize: 14,
              items:
              Permessions.contains('01')==false?
              [
                BottomNavigationBarItem(
                    icon: _currentIndex == 1
                        ? Icon(
                      Icons.account_tree,
                    )
                        : Icon(
                      Icons.account_tree_outlined,
                    ),
                    label: "Custom_Bottom_Navigation_Bar_Form.tawasol".tr().toString()),
                /*BottomNavigationBarItem(
                    icon: _currentIndex == 2
                        ? Icon(
                            Icons.person,
                          )
                        : Icon(
                            Icons.perm_identity_outlined,
                          ),
                    title: new Text(
                      "Custom_Bottom_Navigation_Bar_Form.profile".tr().toString(),
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    )),*/
                BottomNavigationBarItem(
                    icon: _currentIndex == 3
                        ? Icon(
                      Icons.menu_outlined,
                    )
                        : Icon(
                      Icons.menu,
                    ),
                    label: "Custom_Bottom_Navigation_Bar_Form.menu".tr().toString(),),
              ]
              :Permessions.contains('04')==false?[
              BottomNavigationBarItem(
                icon: _currentIndex == 0
                    ? Icon(
                  Icons.home,
                )
                    : Icon(
                  Icons.home_outlined,
                ),
                label: "Custom_Bottom_Navigation_Bar_Form.home".tr().toString(),),
            /*BottomNavigationBarItem(
                icon: _currentIndex == 2
                    ? Icon(
                        Icons.person,
                      )
                    : Icon(
                        Icons.perm_identity_outlined,
                      ),
                title: new Text(
                  "Custom_Bottom_Navigation_Bar_Form.profile".tr().toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )),*/
             BottomNavigationBarItem(
                icon: _currentIndex == 3
                    ? Icon(
                  Icons.menu_outlined,
                )
                    : Icon(
                  Icons.menu,
                ),
                label:  "Custom_Bottom_Navigation_Bar_Form.menu".tr().toString(),),
             ]
              :Permessions.contains('05')==false?[
            BottomNavigationBarItem(
                icon: _currentIndex == 0
                    ? Icon(
                  Icons.home,
                )
                    : Icon(
                  Icons.home_outlined,
                ),
                label: "Custom_Bottom_Navigation_Bar_Form.home".tr().toString(),),
            BottomNavigationBarItem(
                icon: _currentIndex == 1
                    ? Icon(
                  Icons.account_tree,
                )
                    : Icon(
                  Icons.account_tree_outlined,
                ),
                label: "Custom_Bottom_Navigation_Bar_Form.tawasol".tr().toString(),),
            /*BottomNavigationBarItem(
                icon: _currentIndex == 2
                    ? Icon(
                        Icons.person,
                      )
                    : Icon(
                        Icons.perm_identity_outlined,
                      ),
                title: new Text(
                  "Custom_Bottom_Navigation_Bar_Form.profile".tr().toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )),*/

          ]

          :


         [
            BottomNavigationBarItem(
                icon: _currentIndex == 0
                    ? Icon(
                        Icons.home,
                      )
                    : Icon(
                        Icons.home_outlined,
                      ),
                label:  "Custom_Bottom_Navigation_Bar_Form.home".tr().toString(),),
            BottomNavigationBarItem(
                icon: _currentIndex == 1
                    ? Icon(
                        Icons.account_tree,
                      )
                    : Icon(
                        Icons.account_tree_outlined,
                      ),
                label:  "Custom_Bottom_Navigation_Bar_Form.tawasol".tr().toString(),),
            /*BottomNavigationBarItem(
                icon: _currentIndex == 2
                    ? Icon(
                        Icons.person,
                      )
                    : Icon(
                        Icons.perm_identity_outlined,
                      ),
                title: new Text(
                  "Custom_Bottom_Navigation_Bar_Form.profile".tr().toString(),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                )),*/
            BottomNavigationBarItem(
                icon: _currentIndex == 3
                    ? Icon(
                        Icons.menu_outlined,
                      )
                    : Icon(
                        Icons.menu,
                      ),
                label:"Custom_Bottom_Navigation_Bar_Form.menu".tr().toString(),),
          ],
        ),

    );
  }
}
