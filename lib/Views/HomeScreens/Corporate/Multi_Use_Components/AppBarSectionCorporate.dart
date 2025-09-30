import 'package:flutter/material.dart';

import '../MainPages/newAccountsDocumentsChecking.dart';


class AppBarSectionCorporate extends StatelessWidget implements PreferredSizeWidget {
  final AppBar appBar;
  final PermessionCorporate;
  var role;


  final Text title;

  AppBarSectionCorporate({Key key, this.title, this.appBar, this.PermessionCorporate,this.role, actions});


  @override
  Widget build(BuildContext context) {
    print('AppBarSectionCorporate$PermessionCorporate');
    return AppBar(
      leading:role=="Reseller"? IconButton(
        icon: Icon(Icons.arrow_back),
        //tooltip: 'Menu Icon',
        onPressed: () {
        //  Navigator.pop(context);
           Navigator.push(
             context,
             MaterialPageRoute(
               builder: (context) => NewAccountDocumnetChecking(PermessionCorporate,role),
             ),
           );
        },
      ):null,
        automaticallyImplyLeading: false,
        title: title,
        backgroundColor: Color(0xFF392156),
        actions: <Widget>[



        ]);
  }

  @override
  Size get preferredSize {
    return new Size.fromHeight(appBar.preferredSize.height);
  }

}