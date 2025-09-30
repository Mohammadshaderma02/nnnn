import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
class SubmitLineDocumentationRqRepository  {
  APP_URLS urls = new APP_URLS();
  submitLineDocumentationRq(String msisdn, String kitCode,String iccid, String listed,String remark,String idImageBase64,
      String contractImageBase64, String indCompany, String customerTitle,String customerProfession,String customerFirstName,
      String customerSecondName, String customerThirdName, String customerLastName,String customerMaritalStatus,String customerLanguage,
      String customerBuildingType, String customerHomeTel, String customerHomeTel2,String customerBirthDate,String customerGender,String customerGovernorate,
      String customerNationality, String customerNationalNumber, String customerIdType,String customerIdNumber,String customerBusinessType,
      String customerArea, String customerCity, String customerTrade,String customerPF,String customerDepartment, String militaryId,
      String armyRegisterationTypeId, String armyTypeId, String armyRankId, String documentExpiryDate
      )  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/LineDocumentation/submit';
    print([armyRankId,armyTypeId,armyRegisterationTypeId,militaryId,msisdn,kitCode,iccid,customerHomeTel,customerNationalNumber,customerIdNumber]);
    print([customerFirstName,customerSecondName,customerThirdName,customerLastName,customerBirthDate,customerHomeTel]);
    Map body ={
      "msisdn": msisdn,
      "kitCode":kitCode,
      "iccid": iccid,
      "listed": listed,
      "remark": remark,
      "idImageBase64": idImageBase64,
      "contractImageBase64": contractImageBase64,
      "indCompany": indCompany,
      "customerTitle": customerTitle,
      "customerProfession": customerProfession,
      "customerFirstName": customerFirstName,
      "customerSecondName": customerSecondName,
      "customerThirdName": customerThirdName,
      "customerLastName": customerLastName,
      "customerMaritalStatus":customerMaritalStatus,
      "customerLanguage": customerLanguage,
      "customerBuildingType": customerBuildingType,
      "customerHomeTel": customerHomeTel,
      // "customerHomeTel2":customerHomeTel2,
      "customerBirthDate": customerBirthDate,
      "customerGender": customerGender,
      "customerGovernorate": customerGovernorate,
      "customerNationality": customerNationality,
      "customerNationalNumber": customerNationalNumber,
      "customerIdType": customerIdType,
      "customerIdNumber": customerIdNumber,
      "customerBusinessType": customerBusinessType,
      "customerArea": customerArea,
      "customerCity": customerCity,
      "customerTrade": customerTrade,
      "customerPF":customerPF,
      "customerDepartment": customerDepartment,
      "militaryId": militaryId,
      "armyRegisterationTypeId": armyRegisterationTypeId,
      "armyTypeId": armyTypeId,
      "armyRankId": armyRankId,
      "documentExpiryDate":  documentExpiryDate
    };
    print(jsonEncode(body));
    final response = await http.post(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    },body:jsonEncode(body));

    int statusCode = response.statusCode;
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
