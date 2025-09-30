import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class ChangePackageEligibilityRqRepository {
  APP_URLS urls = new APP_URLS();
  changePackageEligibilityRqList(String mssid,String isPOSOffer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var otp = prefs.getString('UpgradePackageOtp');
    var url = urls.BASE_URL +'/ChangePackage/eligible/${mssid}/${isPOSOffer}/${otp}';
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken"),
    });
    int statusCode = response.statusCode;
    if(statusCode==200){
      var result = json.decode(response.body);

      return result;
    }else{
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }

  }
}
