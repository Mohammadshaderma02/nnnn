import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Activate/Activate_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Activate/Activate_events.dart';
import 'package:sales_app/repository/TawasolService/Activate_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ActivateBloc
    extends Bloc<ActivateEvents, ActivateState> {
  ActivateRepository repo;
  ActivateBloc(ActivateState initialState, this.repo) : super(initialState){
    on<ActivateStartEvent>(_ActivateStartEvent);
    on<ActivatePressed>(_ActivatePressed);
  }




  _ActivateStartEvent(ActivateStartEvent event,
      Emitter<ActivateState> emit,) async {
    emit(ActivateInitState());

  }


  _ActivatePressed(ActivatePressed event,
      Emitter<ActivateState> emit,) async {
    emit(ActivateLoadingState());



    try {
      Map<String,dynamic> data = await repo.postActivate(event.msisdn, event.simNumber, event.puk);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit( ActivateSuccessState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"],
            msisdn:data["data"]["msisdn"],
            kitcode:data["data"]["kitcode"],
            password:data["data"]["password"],
            iccid:data["data"]["iccid"],
            expiryDate:data["data"]["expiryDate"]));
      } else  {

        emit( ActivateErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
      emit( ActivateInitState());
    }



    catch (e) {
      print('ActivatePressed error ${e}');
    }
  }

}
