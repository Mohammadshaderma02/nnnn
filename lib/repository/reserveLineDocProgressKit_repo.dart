import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class ReservedLineRepository  {
  APP_URLS urls = new APP_URLS();
  putReservedLineRepository (String kitCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/LineDocumentation/reserve/${kitCode}';
    final response = await http.put(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },);
    int statusCode = response.statusCode;

    if(statusCode==200 ){
      var result = json.decode(response.body);

      return result;
    }
    if(statusCode==500 ||statusCode==401 ){

      Map error ={
        'error' : statusCode,
      };
      return error;
    }

  }
}













