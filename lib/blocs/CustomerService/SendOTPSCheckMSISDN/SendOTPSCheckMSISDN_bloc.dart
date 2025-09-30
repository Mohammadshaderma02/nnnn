import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_events.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPSCheckMSISDN/SendOTPSCheckMSISDN_state.dart';
import 'package:sales_app/repository/CustomerService/SendOTP_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendOTPSCheckMSISDNBloc
    extends Bloc<SendOTPSCheckMSISDNEvents, SendOTPSCheckMSISDNState> {
  SendOTPRepository repo;

  SendOTPSCheckMSISDNBloc(SendOTPSCheckMSISDNState initialState, this.repo)
      : super(initialState) {
    on<SendOTPSCheckMSISDNPressed>(_SendOTPSCheckMSISDNPressed);
  }


  _SendOTPSCheckMSISDNPressed(SendOTPSCheckMSISDNPressed event,
      Emitter<SendOTPSCheckMSISDNState> emit,) async {
    emit(SendOTPSCheckMSISDNLoadingState());
    try {
      final data = await repo.postSendOTP(event.msisdn);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit(SendOTPSCheckMSISDNSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
        ));
      } else {
        emit(SendOTPSCheckMSISDNErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
    }
    catch (e) {
      print('SendOTPSCheckMSISDN bloc error ${e}');
    }
  }
}