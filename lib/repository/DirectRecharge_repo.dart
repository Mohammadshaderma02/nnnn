import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class DirectRechargeRepository {
  APP_URLS urls = new APP_URLS();
  postDirectRecharge(String msisdn, String hrn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(
      urls.BASE_URL +"/Recharge/direct"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode(
          {"msisdn": msisdn, "hrn": hrn}),
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
