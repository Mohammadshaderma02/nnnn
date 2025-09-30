import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_state.dart';
import 'package:sales_app/blocs/CustomerService/VerifyOTPSCheckMSISDN/VerifyOTPSCheckMSISDN_events.dart';
import 'package:sales_app/repository/CustomerService/VerifyOTP_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VerifyOTPSCheckMSISDNBloc extends Bloc<VerifyOTPSCheckMSISDNEvents, VerifyOTPSCheckMSISDNState> {

  VerifyOTPRepository repo;
  VerifyOTPSCheckMSISDNBloc(VerifyOTPSCheckMSISDNState initialState, this.repo)
      : super(initialState){
    on<VerifyOTPSCheckMSISDNPressed>(_VerifyOTPSCheckMSISDNPressed);
  }



  _VerifyOTPSCheckMSISDNPressed(VerifyOTPSCheckMSISDNPressed event,
      Emitter<VerifyOTPSCheckMSISDNState> emit,) async {
    emit(VerifyOTPSCheckMSISDNLoadingState());
    try {
      final data = await repo.postVerifyOTP(event.msisdn, event.otp);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        prefs.setString('UpgradePackageOtp', event.otp);

        print(prefs.getString('UpgradePackageOtp'));
        emit( VerifyOTPSCheckMSISDNSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
        ));
      } else  {

        emit( VerifyOTPSCheckMSISDNErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
      // yield VerifyOTPInitState();

    }
    catch (e) {
      print('VerifyOTPSCheckMSISDN bloc error ${e}');
    }
  }


}
