import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class AddRemoveServiceRepository {
  APP_URLS urls = new APP_URLS();
  postAddRemoveService(String msisdn, String serviceId, String actionType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(urls.BASE_URL + "/Services/add-remove"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode(
          {
            "msisdn": msisdn, 
            "serviceId":serviceId,
            "actionType":actionType ,
            "otp": prefs.getString('CustomerServiceOtp')
          }),
    );
    print(json.decode(res.body));
    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200 ) {
      var result = json.decode(res.body);
      print(result);
      return result;
    }
    /*if(statusCode==500 ||statusCode==401 ){
      print('500 erro');

      return Map;
    }*/

    return data;
  }
}


