import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/Login/login_state.dart';
import 'package:sales_app/repository/Notifications_repo.dart';
import 'package:sales_app/repository/login_repo.dart';
import 'package:sales_app/repository/logout_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:sales_app/blocs/Notifications/Notifications_events.dart';
import 'package:sales_app/blocs/Notifications/Notifications_state.dart';





class GetNotificationsListBloc extends  Bloc<GetNotificationsListEvents ,GetNotificationsListState>{
  GetNotificationsRepository  repo;
  GetNotificationsListBloc(GetNotificationsListState initialState,   this.repo ) : super(initialState){
    on<GetNotificationsListFetchEvent>(_GetNotificationsListFetchEvent);
  }


  _GetNotificationsListFetchEvent(
      GetNotificationsListFetchEvent event,
      Emitter<GetNotificationsListState> emit,) async {
    emit(GetNotificationsListInitState());
    emit(GetNotificationsListLoadingState());
    try{
      Map<String,dynamic> data = await repo.getNotificationsList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List list = data['data'];
      if(data['error']==401){
        emit  ( GetNotificationsListTokenErrorState());
      }
      else if(data['status']==0){

        emit( GetNotificationsListSuccessState(data:list));
      }
      else if(data['status']!=0){
        emit (GetNotificationsListErrorState(arabicMessage: data['messageAr'],englishMessage: data['message']));

      }
    }
    catch(e){
      print('GetNotificationsList error ${e}');

    }

  }

}

