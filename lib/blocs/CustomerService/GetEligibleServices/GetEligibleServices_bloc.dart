
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/blocs/CustomerService/GetEligibleServices/GetEligibleServices_events.dart';
import 'package:sales_app/blocs/CustomerService/GetEligibleServices/GetEligibleServices_state.dart';
import 'package:sales_app/repository/CustomerService/GetEligibleServices_repo.dart';


class GetEligibleServicesBloc extends  Bloc<GetEligibleServicesEvents ,GetEligibleServicesState> {
  GetEligibleServicesRepository repo;

  GetEligibleServicesBloc(GetEligibleServicesState initialState, this.repo)
      : super(initialState) {
    on<GetEligibleServicesStartEvent>(_GetEligibleServicesStartEvent);
    on<GetEligibleServicesFetchEvent>(_GetEligibleServicesFetchEvent);
  }

  _GetEligibleServicesStartEvent(GetEligibleServicesStartEvent event,
      Emitter<GetEligibleServicesState> emit,) async {
    emit(GetEligibleServicesInitState());
  }

  _GetEligibleServicesFetchEvent(GetEligibleServicesFetchEvent event,
      Emitter<GetEligibleServicesState> emit,) async {
    emit(GetEligibleServicesLoadingState());
    try {
      Map<String,dynamic> data = await repo.getEligibleServices(event.msisdn);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List list = data['data'];
      if(data['error']==401){
        emit  (GetEligibleServicesTokenErrorState());
      }
      else if(data['status']==0){

        emit( GetEligibleServicesSuccessState(data:list));
      }
      else if(data['status']!=0){
        emit( GetEligibleServicesErrorState(arabicMessage: data['messageAr']
            ,englishMessage: data['message']));

      }

    }
    catch (e) {
      print(' AddRemoveServiceLoadingState error  ${e}');
      // emit(ErrorState(message: e.toString()));
    }
  }

}