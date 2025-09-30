
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/Shared/BaseUrl.dart';
class CreateTicketRepository  {
  APP_URLS urls = new APP_URLS();
  createTicket(String categoryID, String ticketMessage,String attachName, String attachValueBase64, String dealerID, String dealerName, bool visibility
      )  async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var url = urls.BASE_URL +'/MenaTracks/create-ticket';
    Map body ={
      "categoryID": int.parse(categoryID),
      "ticketMessage": ticketMessage,
      "attachName": attachName,
      "attachValueBase64": attachValueBase64,
      "dealerID": dealerID,
      "dealerName": dealerName,
      "visibility": visibility
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
