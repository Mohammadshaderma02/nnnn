import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class SubmitRechargeDenominationRepository {
  APP_URLS urls = new APP_URLS();
  postSubmitRechargeDenomination(String bPartyMSISDN, String rechargeAmount, String voucherType) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var res = await http.post(Uri.parse(
      urls.BASE_URL+"/Recharge/voucherless"),
      headers: {
        "Content-Type": "application/json",
        "Authorization": prefs.getString("accessToken"),
      },
      body: jsonEncode(
          {"bPartyMSISDN": bPartyMSISDN, "rechargeAmount": rechargeAmount, "voucherType":voucherType}),
    );
    final data = json.decode(res.body);
    int statusCode = res.statusCode;
    if (statusCode == 200 ) {
      var result = json.decode(res.body);
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
