import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class SaveProfileInfoRepository  {
  APP_URLS urls = new APP_URLS();
  saveProfileInfo (String gender, String nationality, String profession,String language,String comtype,String marital_status,String education,
      String gift,String email,String day,String month,String year,String MobileNumber,String MobileNumber1,String MobileNumber2,String MobileNumber3,
      String FirstName,String SecondName,String ThirdName,String FamilytName) async {

    if(day.substring(0,1)!='0'){
        if(int.parse(day)<10){
          day= '0' + day;}
    }
    if(month.substring(0,1)!='0'){
    if(int.parse(month)<10){
      month= '0' + month;
    }
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL+'/Tawasol/sdlr-user-profile';

    Map body ={
      "profileId":  int.parse( prefs.getString('profileId')),
      "firstName": FirstName,
      "secondName": SecondName,
      "thirdName": ThirdName,
      "familyName":FamilytName,
      "gender": int.parse(gender),
      "birthDate":  year+'-'+month+'-'+day,
      "nationality":  int.parse(nationality),
      "nationalId": "",
      "idNumber": "",
      "education":  int.parse(education),
      "profession": int.parse(profession),
      "maritalStatus":  int.parse(marital_status),
      "email": email,
      "preferedLang":  int.parse(language),
      "commType":  int.parse(comtype),
      "giftId": gift,
      "telephone1": MobileNumber1,
      "telephone2":MobileNumber2,
      "telephone3": MobileNumber3,

    };


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
