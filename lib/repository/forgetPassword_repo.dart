import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
class ForgetPasswordRepository {
  APP_URLS urls = new APP_URLS();
  forget(String userName, String userType) async {

    Map body={
      "username": userName,
      "userType": 0
    } ;

    var res = await http.post(Uri.parse(
      urls.BASE_URL+"/Account/forget-password"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );

    print("forget body");
    print(body);

    final data = json.decode(res.body);

    return data;
  }
}