import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

class ChangePasswordRepository {
  APP_URLS urls = new APP_URLS();
  changePass(String currentPassword, String newPassword) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(
      urls.BASE_URL +"/Account/change-password"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode(
          {"currentPassword": currentPassword, "newPassword": newPassword}),
    );
    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200 || statusCode == 401) {
      var result = json.decode(res.body);
      return result;
    }
    return data;
  }
}
