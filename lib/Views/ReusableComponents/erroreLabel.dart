import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
class ErroreLabel extends StatelessWidget {
  ErroreLabel({@required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            alignment:Alignment.centerLeft,
            padding: EasyLocalization.of(context).locale == Locale("en", "US") ?  EdgeInsets.only(left:4 ,right: 16) : EdgeInsets.only(left:16 ,right: 4) ,
            height:24,
            color:Colors.transparent,
            child: Row (
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  Container(
                    child: Icon(Icons.info,color: Colors.white, size: 25,)
                  ),
                  Container(
                    padding:  EasyLocalization.of(context).locale == Locale("en", "US") ? EdgeInsets.only(top: 6,left: 6,)  : EdgeInsets.only(top: 4,right: 6),
                    child: Text(
                      text,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        // fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ]
            ),
          ),]

    );
  }
}