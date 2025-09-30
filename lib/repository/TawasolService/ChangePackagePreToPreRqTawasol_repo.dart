import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class ChangePackagePreToPreRqTawasolRepository {
  APP_URLS urls = new APP_URLS();
  postChangePackagePreToPreRq(String kitCode,String msisdn, String newPackageCode , bool isPOSOffer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var otp = prefs.getString('UpgradePackageOtp');
    var url = urls.BASE_URL +'/ChangePackage/change';
    Map<String,dynamic> body ={
      "msisdn": msisdn,
      "newPackageCode": newPackageCode,
      "isPOSOffer": true,
      "kitCode":kitCode,
      "otp":prefs.getString('UpgradePackageOtp')

    };

    final response = await http.post(Uri.parse(url),headers: {
      "Authorization": prefs.getString("accessToken"),
      "content-type": "application/json",
    },body:jsonEncode(body));
    int statusCode = response.statusCode;
    var result = json.decode(response.body);

    if(statusCode==200){

      return result;
    }else{
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }

  }
}
