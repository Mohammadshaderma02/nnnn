import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';

class PostpaidEligiblePackages {
  APP_URLS urls = new APP_URLS();
  postPostpaidEligiblePackages(String marketType,bool MADA_Activat) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL +'/Postpaid/eligible-packages';
    Map body ={
      "marketType": marketType,
      "isMada": MADA_Activat
    };
    final response = await http.post(Uri.parse(url), headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;
    print (url);
    print("PostpaidEligiblePackages Repository");
    print(response.statusCode);
    print("body.length");
    print('marketType');
    print(marketType);
    print(MADA_Activat);
    print(body);

    print(response.body);
    if(response.body.isNotEmpty) {
      var result= json.decode(response.body);
      print(result['data']);
    } else{
      print("Testing error body is Empty");
      print('body: [${response.body}]');
    }
    if (statusCode == 200) {
      var result = json.decode(response.body);
      print("PostpaidEligiblePackages");
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
