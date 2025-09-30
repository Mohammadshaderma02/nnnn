import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/blocs/CustomerService/AddRemoveService/AddRemoveService_state.dart';
import 'package:sales_app/blocs/CustomerService/AddRemoveService/AddRemoveService_events.dart';
import 'package:sales_app/repository/CustomerService/AddRemoveService_repo.dart';


class AddRemoveServiceBloc
    extends Bloc<AddRemoveServiceEvents, AddRemoveServiceState> {
  AddRemoveServiceRepository repo;

  AddRemoveServiceBloc(AddRemoveServiceState initialState, this.repo)
      : super(initialState) {
    on<AddRemoveServiceStartEvent>(_AddRemoveServiceStartEvent);
    on<AddRemoveServicePressed>(_AddRemoveServicePressed);
  }


  _AddRemoveServiceStartEvent(AddRemoveServiceStartEvent event,
      Emitter<AddRemoveServiceState> emit,) async {
    emit(AddRemoveServiceInitState());
  }

  _AddRemoveServicePressed(AddRemoveServicePressed event,
      Emitter<AddRemoveServiceState> emit,) async {
    emit(AddRemoveServiceLoadingState());
    try {
      final data = await repo.postAddRemoveService(
          event.msisdn, event.serviceId, event.actionType);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit(AddRemoveServiceSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
        ));
      } else {
        emit(AddRemoveServiceErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
      emit(AddRemoveServiceInitState());
    }
    catch (e) {
      print(' AddRemoveServiceLoadingState error  ${e}');
      // emit(ErrorState(message: e.toString()));
    }
  }


}
