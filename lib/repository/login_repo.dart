import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:sales_app/Shared/BaseUrl.dart';
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginRepository {
  APP_URLS urls = new APP_URLS();

  login(String userName, String password, String userType,  bool isRememberMe, bool isSwitched) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL +'/Account/login';
    print(userName);
    print(password);
    Map body ={
      "username": userName,
      "password": password,
      "userType": 0
    };
    final response = await http.post(Uri.parse(url),headers: {
    "content-type": "application/json"
    },body:jsonEncode(body));
    int statusCode = response.statusCode;
    if(statusCode==200 || statusCode==401){
      var result = json.decode(response.body);
      print(result);
      print('result');

     if(statusCode==200){

       List<String> Permessions=[];
       List<String> PermessionCorporate=[];
       List<String> PermessionDeliveryEShop=[];
       List<String> PermessionZainOutdoorHeads=[];
       List<String> PermessionDealerAgent=[];
       List<String> PermessionReseller=[];


       if(result['data']['role']!='Corporate' && result['data']['role']!='DeliveryEShop' && result['data']['role']!='ZainOutdoorHeads' && result['data']["role"]!="DealerAgent" && result['data']["role"]!="Reseller"){
         prefs.setString('SalesAppUser', result['data']['role']);
         for (var i=0;i<result['data']['permissions'].length;i++){
           String  str=result['data']['permissions'][i]['permissionID'];
           Permessions.add(str);
         }
         prefs.setStringList('Permessions', Permessions);

         print("SalesAppUser");
         print(prefs.getString('SalesAppUser'));
       }

       if(result['data']['role']=='Corporate'){
        prefs.setString('CorporateUser', result['data']['role']);
         for (var j=0;j<result['data']['permissions'].length;j++){
           String  str=result['data']['permissions'][j]['permissionID'];
           PermessionCorporate.add(str);
         }
         prefs.setStringList('PermessionCorporate', PermessionCorporate);

       }

       if(result['data']['role']=='DeliveryEShop'){
         prefs.setString('DeliveryEShopUser', result['data']['role']);
         for (var j=0;j<result['data']['permissions'].length;j++){
           String  str=result['data']['permissions'][j]['permissionID'];
           PermessionDeliveryEShop.add(str);
         }
         prefs.setStringList('PermessionDeliveryEShop', PermessionDeliveryEShop);

       }

       if(result['data']['role']=='ZainOutdoorHeads'){
         prefs.setString('ZainOutdoorHeadsUser', result['data']['role']);
         for (var j=0;j<result['data']['permissions'].length;j++){
           String  str=result['data']['permissions'][j]['permissionID'];
           PermessionZainOutdoorHeads.add(str);
         }
         prefs.setStringList('PermessionZainOutdoorHeads', PermessionZainOutdoorHeads);

       }

       if(result['data']['role']=='DealerAgent'){
         prefs.setString('DealerAgentUser', result['data']['role']);
         for (var j=0;j<result['data']['permissions'].length;j++){
           String  str=result['data']['permissions'][j]['permissionID'];
           PermessionDealerAgent.add(str);
         }
         prefs.setStringList('PermessionDealerAgent', PermessionDealerAgent);

       }


       if(result['data']['role']=='Reseller'){
         prefs.setString('Reseller', result['data']['role']);
         for (var j=0;j<result['data']['permissions'].length;j++){
           String str=result['data']['permissions'][j]['permissionID'];
         PermessionReseller.add(str);
       } prefs.setStringList('PermessionReseller', PermessionReseller);}

       /*prefs.setString('PermessionCorporate',result['data']['permissions'][0]['permissionID']);
       print("PermessionCorporatePermessionCorporatePermessionCorporate");*/
       //print(prefs.getString('PermessionCorporate'));
     }
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
