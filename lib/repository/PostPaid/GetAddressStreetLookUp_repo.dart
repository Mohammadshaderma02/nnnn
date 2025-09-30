import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

class GetAdressStreetLookUpRepository{
  APP_URLS urls = new APP_URLS();
  getAdressStreetLookUpRepository(String areaName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL +'/Lookup/FTTHStreet';
    print(url);
    var body={
      "areaName":areaName
    };

    final response = await http.post(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;

    print('statusCode ${statusCode}');

    if (statusCode == 200) {
      print('hello adreess STREETS ${areaName}');

      var result = json.decode(response.body);
      print(result);
      return result;
    }

    else {
      Map<String,dynamic> error = {
        'error': statusCode,
      };
      return error;
    }
  }
}
