import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

class GetGenerateWFMToken{
  APP_URLS urls = new APP_URLS();
  getGenerateWFMTokenRepository(String msisdn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL +'/Postpaid/ftth/appointment';
    print(url);
    var body={
      "msisdn":msisdn
    };

    final response = await http.post(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;

    print('statusCode ${statusCode}');

    if (statusCode == 200) {
      print('MSISDN ${msisdn}');

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
