
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
class HeaderSection extends StatefulWidget {
  HeaderSection({@required this.text});
  final String text;

  @override
  State<HeaderSection> createState() => _HeaderSectionState();
}

class _HeaderSectionState extends State<HeaderSection> {
  double getPadding(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (size.width < 600) {
      return 20;
    }else if(size.width < 800){
      return 20;
    }else if(size.width <= 1200){
      return 200;
    }else {
      return 600;
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
      padding:  EdgeInsets.only(left:getPadding(context),right: getPadding(context)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Image(image:
          AssetImage('assets/images/logoo.png'),
              width:153,
              height:40
          ),
          GestureDetector(
            onTap: context.locale.toString() == "en_US"?
                () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              context.setLocale(Locale('ar', 'AR'))  ;
              prefs.setInt('lang',2);

            } :()async{
              SharedPreferences prefs = await SharedPreferences.getInstance();
              context.setLocale(Locale('en', 'US')) ;

              prefs.setInt('lang',1);
            },
            child: RichText(
              text: TextSpan(
                children: <TextSpan>[
                  TextSpan(
                    text: widget.text,
                    style: TextStyle(fontSize: 20, color: Colors.white,fontWeight: FontWeight.bold),)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}