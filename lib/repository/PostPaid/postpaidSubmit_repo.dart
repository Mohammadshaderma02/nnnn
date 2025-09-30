
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class PostpaidSubmitRepository  {
  APP_URLS urls = new APP_URLS();
  postpaidSubmit(
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
      String signatureImageBase64,
      String locationScreenshotImageBase64,
      String  extraFreeMonths,
      String extraExtender,
      String simCard,
      String contractImageBase64,
      String deviceSerialNumber,
      String deviceSerialNumberImageBase64,
      String parentMSISDN,
      int salesLeadType,
      String salesLeadValue,
      String onBehalfUser,
      String resellerID,
      bool isClaimed,
      String backPassportImageBase64,
      String note,
      String scheduledDate,
      String militaryID,
      String jeeranPromoCode,
      bool isRental,
      String device5GType,
      String serialNumber,
      String itemCode,
      String rentalMsisdn,
      String eshopOrderId,
      String authCode,
      String last4Digits,
      String receiptImageBase64,
      String documentExpiryDate,
      String countryId,
      String email,
      String homeInternetSpecialPromo,
      String SimLock



      )  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/Postpaid/submit';
    print(url);
    Map body ={
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
      "signatureImageBase64":signatureImageBase64,
      "locationScreenshotImageBase64": locationScreenshotImageBase64,
      "extraFreeMonths": extraFreeMonths==null?'':extraFreeMonths,
      "extraExtender": extraExtender==null?'':extraExtender,
      "simCard":simCard,
      "contractImageBase64":contractImageBase64,
      "deviceSerialNumber":deviceSerialNumber,
      "deviceSerialNumberImageBase64":deviceSerialNumberImageBase64,
      "parentMSISDN": parentMSISDN,
       "salesLeadType":salesLeadType,
       "salesLeadValue":salesLeadValue,
      "onBehalfUser":onBehalfUser,
      "resellerID":resellerID,
      "isClaimed":isClaimed,
      "backPassportImageBase64": backPassportImageBase64,
      "note":note,
      "scheduledDate":scheduledDate,
      "militaryID":militaryID,
      "jeeranPromoCode":jeeranPromoCode,
      "isRental":isRental,
      "device5GType":device5GType,
      "serialNumber":serialNumber,
      "itemCode":itemCode,
      "rentalMsisdn":rentalMsisdn,
      "eshopOrderId": eshopOrderId,
      "authCode": authCode,
      "last4Digits": last4Digits,
      "receiptImageBase64": receiptImageBase64,
      "documentExpiryDate":documentExpiryDate,
      "countryId":countryId,
      "email":email,
      "homeInternetSpecialPromo":homeInternetSpecialPromo,
      "SimLock":SimLock

    };

    print('body');
    print(body);

    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));

    int statusCode = response.statusCode;
    print("111111111111111");
    print("*********************************************************json.decode(response.body)**************************************************");
    print(statusCode);
    print(json.decode(response.body));
    print("****************************************************************End json body********************************************************");


    print(response.statusCode);
    if(statusCode==400 ){
    var result =  json.decode(response.body);
    print("000000000000000000000000000000000000000");
    print(result);
    print("000000000000000000000000000000000000000");
    }

    if(statusCode==200 ){

      var result =  json.decode(response.body);
      print("00000000000000000000....statusCode==200 .....0000000000000000000");
      print(result);
      print("00000000000000000000....statusCode==200 .....0000000000000000000");


      return result;
    }
    else{
      var result =  json.decode(response.body);
      print("00000000000000000000....statusCode!=200 .....0000000000000000000");
      print(result);
      print("00000000000000000000....statusCode!=200 .....0000000000000000000");
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }

  }


}
