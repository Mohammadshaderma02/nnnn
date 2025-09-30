import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

class GetAdressAreaLookUpRepository{
  APP_URLS urls = new APP_URLS();
  getAdressAreaLookUpRepository(String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL +'/Lookup/FTTHArea';
    print(url);

    final response = await http.post(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode({}));
    int statusCode = response.statusCode;

      print('statusCode ${statusCode}');

    if (statusCode == 200) {
      print('hello adreess aAREA');

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
