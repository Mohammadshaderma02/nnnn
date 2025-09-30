import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class PostValidateSubscriberRepository {
  APP_URLS urls = new APP_URLS();
  PostValidateSubscriber(
      String marketType,
      bool isJordanian,
      String nationalNo,
      String packageCode,
      String passportNo,
      String msisdn,
      bool isRental,
      String device5GType,
      String buildingCode,
      String serialNumber,
      String itemCode,
      bool isLocked,
      ) async {
    var url =  urls.BASE_URL+'/Postpaid/validate';
    Map body;
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if(isJordanian == true ){
      body ={
        "marketType": marketType,
        "isJordanian": isJordanian,
        "nationalNo": nationalNo,
        "packageCode": packageCode,
        "msisdn":msisdn,
        "isRental":isRental,
        "device5GType":device5GType,
        "buildingCode":buildingCode,
        "serialNumber":serialNumber,
        "itemCode":itemCode,
        "isLocked":isLocked

      };
      print("THE BODY");
      print(body);
      print("THE BODY");

    }else{
      body ={
        "marketType": marketType,
        "isJordanian": isJordanian,
        "passportNo": passportNo,
        "packageCode": packageCode,
        "msisdn":msisdn,
        "isRental":isRental,
        "device5GType":device5GType,
        "buildingCode":buildingCode,
        "serialNumber":serialNumber,
        "itemCode":itemCode,
        "isLocked":isLocked

      };
    }

    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));
    int statusCode = response.statusCode;

    print(url);
    print(statusCode);
    print(body);

    json.decode(response.body);
    if(statusCode==200){
      var result = json.decode(response.body);
      print(result);
      return result;
    } else{

      print("Postpaid/validate");
      print(response);
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }
  }
}



