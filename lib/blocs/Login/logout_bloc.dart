import 'dart:convert';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/Login/login_state.dart';
import 'package:sales_app/repository/login_repo.dart';
import 'package:sales_app/repository/logout_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'logout_events.dart';
import 'logout_state.dart';
class LogoutBloc extends  Bloc<LogoutEvents ,LogoutState>{
  LogoutRepository repo;
  LogoutBloc(LogoutState initialState,   this.repo ) :
        super(initialState){

    on<LogoutButtonPressed>(_LogoutButtonPressed);
  }

  _LogoutButtonPressed(LogoutButtonPressed event,
      Emitter<LogoutState> emit,) async {
      SharedPreferences prefs = await SharedPreferences.getInstance();

    try {

        Map<String,dynamic> data = await repo.logout();
        SharedPreferences prefs = await SharedPreferences.getInstance();
        //  if(data['status']==0){
        prefs.setBool('is_logged_in', false);
        prefs.setBool('biomitric_is_logged_in', false);
        prefs.remove("accessToken");
        prefs.remove("customerID");
        prefs.remove("SubscriberNumber");
        prefs.remove("customerName");
        if(prefs.getBool('isRememberMe')==false){
          prefs.remove("passsword");
        }
        prefs.remove('counter');
        emit(LogoutInitState());
        emit(LogoutSuccessState());

        // }

    } catch (e) {
      print('caled bloc error');
      // emit(ErrorState(message: e.toString()));
    }
  }

}


