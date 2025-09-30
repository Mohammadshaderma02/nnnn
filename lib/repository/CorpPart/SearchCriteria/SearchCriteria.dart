
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

class SearchCriteriaRepository {
  APP_URLS urls = new APP_URLS();
  postSearchCriteria(int searchID, String searchValue) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map test = {
      "searchID": searchID,
      "searchValue": searchValue
    };

    String body = json.encode(test);
    var apiArea = urls.BASE_URL + '/Customer360/search';
    final Uri url = Uri.parse(apiArea);
    prefs.getString("accessToken");
    final access = prefs.getString("accessToken");

    final response = await http.post(url, headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    }, body: body,);
    int statusCode = response.statusCode;
    var data = response.request;
    print(statusCode);
    print(data);
    print(response);
    print('body: [${response.body}]');
    if (statusCode == 500) {
      print('500  error ');

    }
    if(statusCode==401 ){
      prefs.setString('UnotherizedError', 'UnotherizedError');

      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;

    }
    if (statusCode == 200) {
      print("yes");
      var result = json.decode(response.body);
      print(result);


      print('Sucses API');
      print(urls.BASE_URL +'/Customer360/search');
/* setState(() {
        _loadedData = result['result']['area'];
      });*/
// print("_loadedData");

      return result;
    }
  }}





