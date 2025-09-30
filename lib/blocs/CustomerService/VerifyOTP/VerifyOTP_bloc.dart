import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTP/VerifyOTP_state.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTP/VerifyOTP_events.dart';
import 'package:sales_app/repository/CustomerService/VerifyOTP_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTPBloc extends Bloc<VerifyOTPEvents, VerifyOTPState> {
  VerifyOTPRepository repo;
  VerifyOTPBloc(VerifyOTPState initialState, this.repo) : super(initialState){

    on<VerifyOTPStartEvent>(_VerifyOTPStartEvent);
    on<VerifyOTPPressed>(_VerifyOTPPressed);

  }



  _VerifyOTPStartEvent(VerifyOTPStartEvent event,
      Emitter<VerifyOTPState> emit,) async {
    emit(VerifyOTPInitState());

  }

  _VerifyOTPPressed(VerifyOTPPressed event,
      Emitter<VerifyOTPState> emit,) async {
    emit(VerifyOTPLoadingState());
    try {
      final data = await repo.postVerifyOTP(event.msisdn, event.otp);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit( VerifyOTPSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
        ));
      } else {

        emit( VerifyOTPErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
    }
    catch (e) {
      print('VerifyOTPPressed bloc error ${e}');
    }
  }


}
