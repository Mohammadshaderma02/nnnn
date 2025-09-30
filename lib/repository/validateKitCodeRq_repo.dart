import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ValidateKitCodeRqRepository  {
  APP_URLS urls = new APP_URLS();
  validateKitCodeRq(String msisdn, String kitCode,String iccid) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/LineDocumentation/validate';
    Map body ={
      "msisdn": msisdn,
      "kitCode": kitCode,
      "iccid":iccid

    };
    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;
 print("...............................................validate........................................");
 print(statusCode);
 print(body);
 print(json.decode(response.body));
    if(statusCode==200 ){
      var result = json.decode(response.body);

      return result;
    }
    else{
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }

  }


}
