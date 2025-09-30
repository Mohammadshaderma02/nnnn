import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class UpdateIOS  {
  APP_URLS urls = new APP_URLS();
  getAndroidIOS() async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/Version/IOS';
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;

    if(statusCode==200 ){

      var result = json.decode(response.body);
      print('IOS_Version');
      print(result);
      return result;
    }
    if(statusCode==500 ||statusCode==401 ){
      print('500 erro');
      Map error ={
        'error' : statusCode,
      };
      return Map;
    }

  }
}
