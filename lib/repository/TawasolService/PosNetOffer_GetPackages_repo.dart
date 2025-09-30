import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class GetPosNetOfferPackageRepository  {
  APP_URLS urls = new APP_URLS();
  getPosNetOfferPackage (String msisdn,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL +'/ChangePackage/eligible/${msisdn}/true';
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    if(statusCode==200 ){
      var result = json.decode(response.body);

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
