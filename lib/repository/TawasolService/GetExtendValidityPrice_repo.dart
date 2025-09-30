import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class GetExtendValidityPriceRepository{
  APP_URLS urls = new APP_URLS();
  getExtendValidityPrice (String kitCode,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url =urls.BASE_URL + '/Lines/extend-validity/${kitCode}';
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    if(statusCode==200 ){
      var result = json.decode(response.body);
      print(url);
      print(result);
      return result;
    }
    else{
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }

  }
}
