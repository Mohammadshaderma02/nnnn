import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:sales_app/blocs/ReservedLine/ReservedLine_events.dart';
import 'package:sales_app/blocs/ReservedLine/ReservedLine_state.dart';
import 'package:sales_app/repository/reserveLineDocProgressKit_repo.dart';

import 'package:sales_app/repository/uploadImage_repo.dart';



class ReservedLineBloc extends Bloc<ReservedLineEvents, ReservedLineState> {
  ReservedLineRepository repo;


  ReservedLineBloc(ReservedLineState initialState, this.repo)
      : super(initialState) {
    on<PressReservedLineEvent>(_PressReservedLineEvent);
  }


  _PressReservedLineEvent(PressReservedLineEvent event,
      Emitter<ReservedLineState> emit,) async {
    emit(ReservedLineInitState());
    emit(ReservedLineLoadingState());

    try {
      Map<String, dynamic> ReservedLinedata = await repo
          .putReservedLineRepository(event.kitCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("putReservedLineRepository");
      print(ReservedLinedata);

      if (ReservedLinedata["status"] == 0) {
        print("ReservedLineState");

        emit(ReservedLineSuccessState(
            arabicMessage: ReservedLinedata["messageAr"],
            englishMessage: ReservedLinedata["message"]));
      }
      else if (ReservedLinedata["status"] == -1) {
        print("ReservedLineState error");
        emit(ReservedLineErrorState(
            arabicMessage: ReservedLinedata["messageAr"],
            englishMessage: ReservedLinedata["message"]));
      }
    }
    catch (e) {
      print('ReservedLine error ${e}');
    }
  }

}




