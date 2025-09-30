import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidity/ExtendValidity_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidity/ExtendValidity_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidity/ExtendValidity_events.dart';


import 'package:sales_app/repository/TawasolService/ExtendValidity_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExtendValidityBloc
    extends Bloc<ExtendValidityEvents, ExtendValidityState> {
  ExtendValidityRepository repo;
  ExtendValidityBloc(ExtendValidityState initialState, this.repo) : super(initialState){

    on<ExtendValidityStartEvent>(_ExtendValidityStartEvent);
    on<ExtendValidityPressed>(_ExtendValidityPressed);

  }



  _ExtendValidityStartEvent(ExtendValidityStartEvent event,
      Emitter<ExtendValidityState> emit,) async {
    emit(ExtendValidityInitState());

  }


  _ExtendValidityPressed(ExtendValidityPressed event,
      Emitter<ExtendValidityState> emit,) async {
    emit(ExtendValidityLoadingState());



    try {
      final data = await repo.postExtendValidity(event.msisdn, event.kitCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit( ExtendValiditySuccessState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      } else  {

        emit( ExtendValidityErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
      emit( ExtendValidityInitState());
    }


    catch (e) {
      print('ChangePackagePreToPreRqTawasol error ${e}');
    }
  }


}