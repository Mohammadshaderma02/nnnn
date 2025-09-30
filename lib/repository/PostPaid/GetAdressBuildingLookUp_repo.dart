import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

class GetAdressBuildingLookUpRepository{
  APP_URLS urls = new APP_URLS();
  getAdressBuildingLookUpRepository(String streetName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL +'/Lookup/FTTHBuildingNumber';
    print(url);
    var body={
      "streetName":streetName
    };

    final response = await http.post(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var result = json.decode(response.body);
      print(' BUILDINGS ${result}');
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
