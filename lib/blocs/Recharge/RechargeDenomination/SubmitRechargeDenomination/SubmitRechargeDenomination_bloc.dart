import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/SubmitRechargeDenomination/SubmitRechargeDenomination_events.dart';
import 'package:sales_app/blocs/Recharge/RechargeDenomination/SubmitRechargeDenomination/SubmitRechargeDenomination_state.dart';
import 'package:sales_app/repository/SubmitRechargeDenomination_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SubmitRechargeDenominationBloc
    extends Bloc<SubmitRechargeDenominationEvents, SubmitRechargeDenominationState> {
  SubmitRechargeDenominationRepository repo;

  var counter = 0;

  SubmitRechargeDenominationBloc(SubmitRechargeDenominationState initialState,
      this.repo)
      : super(initialState) {
    on<SubmitRechargeDenominationStartEvent>(_SubmitRechargeDenominationStartEvent);
    on<SubmitRechargeDenominationPressed>(_SubmitRechargeDenominationPressed);

  }

  _SubmitRechargeDenominationStartEvent(
      SubmitRechargeDenominationStartEvent event,
      Emitter<SubmitRechargeDenominationState> emit,) async {
    emit(SubmitRechargeDenominationInitState());
  }

  _SubmitRechargeDenominationPressed(SubmitRechargeDenominationPressed event,
      Emitter<SubmitRechargeDenominationState> emit,) async {
    emit(SubmitRechargeDenominationLoadingState());


    try {
      final data = await repo.postSubmitRechargeDenomination(event.bPartyMSISDN, event.rechargeAmount, event.voucherType);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        print("SubmitRechargeDenomination Success");
        emit( SubmitRechargeDenominationSuccessState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
        emit( SubmitRechargeDenominationInitState());
      } else {
        emit( SubmitRechargeDenominationErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
    }
    catch (e) {
      print('SubmitRechargeDenominationPressed error ${e}');
    }
  }

}


