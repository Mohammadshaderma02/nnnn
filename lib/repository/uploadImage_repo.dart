import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class UploadImageRepository  {
  APP_URLS urls = new APP_URLS();
  putUploadImageRepository (String kitCode, String idImageBase64, String contractImageBase64) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/LineDocumentation/images';
    Map body ={
      "kitCode": kitCode,
      "idImageBase64": idImageBase64,
      "contractImageBase64": contractImageBase64
    };
    final response = await http.put(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
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








