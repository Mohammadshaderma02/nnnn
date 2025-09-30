import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sales_app/Shared/BaseUrl.dart';
import 'package:shared_preferences/shared_preferences.dart';
class GetPendingRejectedLineDocQueueRepository {
  APP_URLS urls = new APP_URLS();
  getPendingRejectedLineDocQueueList(int pageNum, int limit,int status) async {
    var url =  urls.BASE_URL+'/LineDocumentation/pending?Limit=${limit}&Page=${pageNum}&Status=${status}';
    print(url);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final response = await http.get(Uri.parse(url),headers: {
      "content-type": "application/json",
      "Authorization": prefs.getString("accessToken")
    });
    int statusCode = response.statusCode;
    if(statusCode ==200) {
      var result = json.decode(response.body);
      List<dynamic> list =  result['data']['items'];
      List<dynamic> UserList =[];
      list.map((data) => UserList.add(data)).toList();
      return UserList;
    } else{
      Map<String,dynamic> error ={
        'error' : statusCode,
      };
      return error;
    }
  }
}
