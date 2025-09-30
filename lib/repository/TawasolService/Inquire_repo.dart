import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class InquireRepository {
  APP_URLS urls = new APP_URLS();
  postInquire(String msisdn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(urls.BASE_URL +
      "/Lines/special-number/inquire"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode(
          {"msisdn": msisdn}),
    );

    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200 ) {
      var result = json.decode(res.body);
      return result;
    }
    if(statusCode==500 ||statusCode==401 ){
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }

    return data;
  }
}


