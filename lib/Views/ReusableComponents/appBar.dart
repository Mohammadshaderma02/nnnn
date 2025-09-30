import 'package:flutter/material.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/NotificationsScreen.dart';
import 'package:sales_app/Views/HomeScreens/Subdealer/Setting/SettingsScreen.dart';
import 'package:sales_app/Views/ReusableComponents/logoutButton.dart';
import 'package:shared_preferences/shared_preferences.dart';
class appBarSection extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final Permessions;
  var role;
  var outDoorUserName;

  final Text title;

  appBarSection({Key key, this.title, this.appBar, this.Permessions,this.role,this.outDoorUserName});


  @override
  Widget build(BuildContext context) {
    print('hello$Permessions');
    return AppBar(
        automaticallyImplyLeading: false,
        title: title,
        backgroundColor: Color(0xFF4f2565),
        actions: <Widget>[
          Permessions.contains('02')? IconButton(
              icon: Icon(Icons.notifications_none),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
                  ),
                )
              }):Container(),
          Permessions.contains('03')? IconButton(
              icon: Icon(Icons.settings_outlined),
              onPressed: () => {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SettingsScreen(Permessions:Permessions,role:role,outDoorUserName:outDoorUserName),
                  ),
                )
              }):Container(),
          LogoutButton(),
        ]);
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(appBar.preferredSize.height);
  }

}


