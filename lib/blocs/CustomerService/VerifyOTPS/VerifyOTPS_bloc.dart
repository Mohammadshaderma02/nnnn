import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPS/VerifyOTPS_state.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPS/VerifyOTPS_events.dart';
import 'package:sales_app/repository/CustomerService/VerifyOTP_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTPSBloc extends Bloc<VerifyOTPSEvents, VerifyOTPSState> {

  VerifyOTPRepository repo;
  VerifyOTPSBloc(VerifyOTPSState initialState, this.repo) : super(initialState){
    on<VerifyOTPSPressed>(_VerifyOTPSPressed);
  }


  _VerifyOTPSPressed(VerifyOTPSPressed event,
      Emitter<VerifyOTPSState> emit,) async {
    emit(VerifyOTPSLoadingState());
    try {
      final data = await repo.postVerifyOTP(event.msisdn, event.otp);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        prefs.setString('CustomerServiceOtp', event.otp);

        emit( VerifyOTPSSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
        ));
      } else  {

        emit( VerifyOTPSErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
      // yield VerifyOTPInitState();

    }
    catch (e) {
      print('VerifyOTPSPressed bloc error ${e}');
    }
  }

}
