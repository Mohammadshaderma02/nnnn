import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Recharge/DirectRecharge/DirectRecharge_events.dart';
import 'package:sales_app/blocs/Recharge/DirectRecharge/DirectRecharge_state.dart';
import 'package:sales_app/repository/DirectRecharge_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DirectRechargeBloc
    extends Bloc<DirectRechargeEvents, DirectRechargeState> {
  DirectRechargeRepository repo;
  DirectRechargeBloc(DirectRechargeState initialState, this.repo) : super(initialState){
    on<DirectRechargeStartEvent>(_DirectRechargeStartEvent);
    on<DirectRechargePressed>(_DirectRechargePressed);
  }


  _DirectRechargeStartEvent(DirectRechargeStartEvent event,
      Emitter<DirectRechargeState> emit,) async {
    emit(DirectRechargeInitState());


  }


  _DirectRechargePressed(DirectRechargePressed event,
      Emitter<DirectRechargeState> emit,) async {
    emit(DirectRechargeLoadingState());


    try {
      final data = await repo.postDirectRecharge(event.msisdn, event.hrn);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit( DirectRechargeSuccessState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      } else  {

        emit( DirectRechargeErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
      emit( DirectRechargeInitState());
    }
    catch (e) {
      print('DirectRechargePressed error ${e}');
    }
  }




}