
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class PostpaidGenerateContractRepository  {
  APP_URLS urls = new APP_URLS();
  postpaidGenerateContract(
      bool isRental,
      String marketType,
      bool isJordanian,
      String nationalNo,
      String passportNo,
      String firstName,
      String secondName,
      String thirdName,
      String lastName ,
      String birthDate,
      String msisdn,
      String buildingCode,
      bool migrateMBB,
      String mbbMsisdn,
      String packageCode,
      String username,
      String password,
      String referenceNumber,
      String referenceNumber2,
      String frontIdImageBase64,
      String backIdImageBase64,
      String passportImageBase64,
      String locationScreenshotImageBase64,
      String extraFreeMonths,
      String extraExtender,
      String simCard,
      String contractImageBase64,
      String deviceSerialNumber,
      String deviceSerialNumberImageBase64,
      String onBehalfUser,
      String resellerID ,
      bool isClaimed,
      int salesLeadType,
      String salesLeadValue,
      String backPassportImageBase64,
      String note,
      String militaryID,
      String scheduledDate,
      String jeeranPromoCode,

      String device5GType,
      String serialNumber,
      String itemCode,
      String rentalMsisdn,
      String eshopOrderId,



      )  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/Postpaid/generate/contractV2';
    print(url);
    Map body ={
      "isRental":isRental,
      "marketType": marketType,
      "isJordanian":isJordanian,
      "nationalNo": nationalNo,
      "passportNo": passportNo,
      "firstName": firstName,
      "secondName": secondName,
      "thirdName": thirdName,
      "lastName": lastName,
      "birthDate": birthDate,
      "msisdn": msisdn,
      "buildingCode": buildingCode,
      "migrateMBB": migrateMBB,
      "mbbMsisdn": mbbMsisdn,
      "packageCode": packageCode,
      "username":username,
      "password": password,
      "referenceNumber": referenceNumber,
      "referenceNumber2": referenceNumber2,
      "frontIdImageBase64": frontIdImageBase64,
      "backIdImageBase64": backIdImageBase64,
      "passportImageBase64": passportImageBase64,
      "locationScreenshotImageBase64": locationScreenshotImageBase64,
      "extraFreeMonths": extraFreeMonths==null?'':extraFreeMonths,
      "extraExtender": extraExtender==null?'':extraExtender,
      "simCard":simCard,
      "contractImageBase64":contractImageBase64,
      "deviceSerialNumber":deviceSerialNumber,
      "deviceSerialNumberImageBase64":deviceSerialNumberImageBase64,
      "onBehalfUser":onBehalfUser,
      "resellerID":resellerID,
      "isClaimed":isClaimed,
      "salesLeadType":salesLeadType,
      "salesLeadValue":salesLeadValue,
      "backPassportImageBase64":backPassportImageBase64,
      "note":note,
      "militaryID":militaryID,
      "scheduledDate":scheduledDate,
      "jeeranPromoCode":jeeranPromoCode,

      "device5GType":device5GType,
      "serialNumber":serialNumber,
      "itemCode":itemCode,
      "rentalMsisdn":rentalMsisdn,
      "eshopOrderId":eshopOrderId,



    };
    //print(jsonEncode(body));



    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));

    int statusCode = response.statusCode;

    print('status code generate contract ${statusCode}');
    print("request body contract");
    print(response.body);
    print(jsonEncode(body));
  /*  if(statusCode==200 ){
      var result =  json.decode(response.body);
      return result;

    }
    else{
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }*/




    if (statusCode == 200) {
      try {
        if (response.body.isEmpty) {
          print("Empty response body!");
          return {'error': 'Empty response body'};
        }

        final result = json.decode(response.body);

        // Debug what we actually received
        print("Decoded result: $result");

        // Defensive check: Does it contain reasons?
        if (result.containsKey('reasons')) {
          print("Reasons found: ${result['reasons']}");
        } else {
          print("Reasons key missing in response");
        }

        return result;
      } catch (e, stackTrace) {
        print("JSON decode error: $e");
        print(stackTrace);
        return {'error': 'JSON decode failed'};
      }
    }














  }


}
