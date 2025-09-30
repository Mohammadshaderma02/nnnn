import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class LogoutRepository {
  APP_URLS urls = new APP_URLS();
  logout() async {
    var url = urls.BASE_URL+'/Account/logout';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;
    if(statusCode==200)
    {var result = json.decode(response.body);
   return result;}
    else{
      return ({
        'result' :401,
      });
    }
  }
}
