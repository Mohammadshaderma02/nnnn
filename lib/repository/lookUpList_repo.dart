import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GetLookUpListRepository {
  APP_URLS urls = new APP_URLS();
  getLookUpList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<dynamic> data = new List();
    var array =[
      "GENDER",
      "NATIONALITY",
      "PROFESSION",
      "EDUCATION",
      "MARITAL_STATUS",
      "LANGUAGE",
      "COMTYPE",
      "GIFTS",
      "ARMY_TYPES",
      "ARMY_REGISTERATION_TYPES",
      "ARMY_RANKS",
      "SERVICECATEGORIES_MT",
      "DEALERS"
    ];
    var url = urls.BASE_URL+'/Tawasol/sdlr-user-profile';
    final response1 = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode1 = response1.statusCode;
    var result1 = json.decode(response1.body);

    if(result1['status']==0){
      prefs.setString('profileId', result1['data']['profileId'] );
    }else{
      prefs.setString('profileId', '0' );
    }
   for(var i =0;i<array.length;i++){
     var url = urls.BASE_URL+'/Lookup/${array[i]}';
     final response = await http.get(Uri.parse(url),headers: {
       "content-type": "application/json",
       "Authorization": prefs.getString("accessToken")
     });
     int statusCode = response.statusCode;
     var result = json.decode(response.body);
     data.add({
       "label": array[i],
       "value":result});


   }
   print('dara');
    print(data[10]);
    return data;
  }
}