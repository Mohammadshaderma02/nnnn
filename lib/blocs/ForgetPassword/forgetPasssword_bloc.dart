import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/ForgetPassword/forgetPasssword_events.dart';
import 'package:sales_app/blocs/ForgetPassword/forgetPasssword_state.dart';
import 'package:sales_app/repository/forgetPassword_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';
class ForgetPasswordBloc
    extends Bloc<ForgetPasswordEvents, ForgetPasswordState> {
  ForgetPasswordRepository repo;
  var counter = 0;
  ForgetPasswordBloc(ForgetPasswordState initialState, this.repo)
      : super(initialState){
    on<ForgetStartEvent>(_ForgetStartEvent);
    on<SubmitButtonPressed>(_SubmitButtonPressed);
  }


  _ForgetStartEvent(ForgetStartEvent event,
      Emitter<ForgetPasswordState> emit,) async {
    emit(ForgetPasswordInitState());

  }

  _SubmitButtonPressed(SubmitButtonPressed event,
      Emitter<ForgetPasswordState> emit,) async {
    try {
      if ((event.userName == '' || event.userName == null)) {
        emit( UserNameForgetErrorState());
      } else {
        //yield ForgetPasswordSuccessState();
        emit (ForgetPasswordLoadingState());
        //final data = repo.login(event.userName, event.password, event.userType);
        final data = await repo.forget(event.userName, event.userType);
        SharedPreferences prefs = await SharedPreferences.getInstance();
        print("haya");
        print(data);
        if (data["status"] == 0) {
          print("haya");
          print(data);
          print(data['message']);
          emit( ForgetPasswordSuccessState());
        } else if (data["status"] == -1) {
          emit( ForgetPasswordErrorState(
              arabicMessage: data["messageAr"],
              englishMessage: data["message"]));
        }
      }
    }

    catch (e) {
      print('ForgetPassword bloc error ${e}');
    }
  }



}