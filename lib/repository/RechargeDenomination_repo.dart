import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RechargeDenominationRepository  {
  APP_URLS urls = new APP_URLS();
  getRechargeDenomination () async {

    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/Lookup/VOUCHERS_TYPES';

    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
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
