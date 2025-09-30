import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class ExtendValidityRepository {
  APP_URLS urls = new APP_URLS();
  postExtendValidity(String msisdn, String kitCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(urls.BASE_URL +
      "Lines/extend-validity"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode(
          {"msisdn": msisdn, "kitCode": kitCode}),
    );

    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200 ) {
      var result = json.decode(res.body);
      print("/*************ExtendValidity**************/");
      print(result);
      print("/***************************/");
      return result;
    }
    if(statusCode==500 ||statusCode==401 ){
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }
  }
}


