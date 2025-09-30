import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GetSubdealerLineDocProgressCurrentCountRqRepository {
  APP_URLS urls = new APP_URLS();
  GetSubdealerLineDocProgressCurrentCountRq() async {
    var url =  urls.BASE_URL+'/Tawasol/sdlr-contracts-status';
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    if(statusCode==200){
    var result = json.decode(response.body);
    return result;
    } else{
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }
  }
}
