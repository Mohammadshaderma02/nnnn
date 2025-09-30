import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/ChangePassword/changePassword_events.dart';
import 'package:sales_app/blocs/ChangePassword/changePassword_state.dart';
import 'package:sales_app/repository/changePassword_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvents, ChangePasswordState> {
  ChangePasswordRepository repo;

  ChangePasswordBloc(ChangePasswordState initialState, this.repo)
      : super(initialState){
    on<ChangeStartEvent>(_ChangeStartEvent);
    on<SubmitChangeButtonPressed>(_SubmitChangeButtonPressed);
  }


  _ChangeStartEvent(ChangeStartEvent event,
      Emitter<ChangePasswordState> emit,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit( ChangePasswordInitState());

    try {

    } catch (e) {
      print('caled bloc error');
      // emit(ErrorState(message: e.toString()));
    }
  }

  _SubmitChangeButtonPressed(SubmitChangeButtonPressed event,
      Emitter<ChangePasswordState> emit,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    emit(ChangePasswordLoadingState());
    try {
      final data =
      await repo.changePass(event.currentPassword, event.newPassword);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("SubmitChangeButtonPressed");
      print(data);

      if (data['status'] == 0) {
        emit (ChangePasswordSuccessState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      } else {
        emit (ChangePasswordErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }


    } catch (e) {
      print(' forget password error');
      // emit(ErrorState(message: e.toString()));
    }
  }


}