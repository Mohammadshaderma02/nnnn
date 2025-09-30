import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/RechargeDenomination_repo.dart';
import 'RechargeDenomination_events.dart';
import 'RechargeDenomination_state.dart';

class RechargeDenominationBloc extends  Bloc<RechargeDenominationEvents ,RechargeDenominationState> {
  RechargeDenominationRepository repo;

  RechargeDenominationBloc(RechargeDenominationState initialState, this.repo)
      : super(initialState){
    on<RechargeDenominationFetchEvent>(_RechargeDenominationFetchEvent);
  }


  _RechargeDenominationFetchEvent(RechargeDenominationFetchEvent event,
      Emitter<RechargeDenominationState> emit,) async {
    emit(RechargeDenominationLoadingState());


    try {
      emit(RechargeDenominationLoadingState());
      Map<String, dynamic> data = await repo.getRechargeDenomination();
      List list = data['data'];
      if (data['error'] == 401) {
        emit(RechargeDenominationTokenErrorState(arabicMessage:
        'لا يوجد بينات متاحة', englishMessage: "No eligible packages found"));
      }
      if (data['status'] == 0) {
        emit(RechargeDenominationSuccessState(data: list));
      }
      else {
        emit(RechargeDenominationNoDataState(arabicMessage:
        data['messageAr'], englishMessage: data['message']));
      }
    }
    catch (e) {
      print('_RechargeDenominationFetchEvent error ${e}');
    }
  }

}
