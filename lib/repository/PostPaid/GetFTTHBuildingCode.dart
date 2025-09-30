import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GetBuildingCodeRepository {
  APP_URLS urls = new APP_URLS();
  getBuildingCode(String areaName,String streetName,String buildingNumber) async {
    var url =  urls.BASE_URL+'/Lookup/FTTHBuildingCode';
    Map body;
    SharedPreferences prefs = await SharedPreferences.getInstance();

      body ={
        "streetName": streetName,
        "areaName": areaName,
        "buildingNumber": buildingNumber,

      };


    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;
    print('building code');
    print(body);
    print(statusCode);
    if(statusCode==200){
      var result = json.decode(response.body);
     print(result);
      return result;
    } else{
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }
  }
}



