import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GetTawasolListRepository {
  APP_URLS urls = new APP_URLS();
  getTawasolList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url =  urls.BASE_URL+'/Tawasol/list/${prefs.getString("channelNumber")}';
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    var result = json.decode(response.body);
    return result;
  }
}
