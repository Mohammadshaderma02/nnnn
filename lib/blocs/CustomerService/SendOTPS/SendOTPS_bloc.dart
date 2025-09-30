import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPS/SendOTPS_state.dart';
import 'package:sales_app/blocs/CustomerService/SendOTPS/SendOTPS_events.dart';
import 'package:sales_app/repository/CustomerService/SendOTP_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendOTPSBloc
    extends Bloc<SendOTPSEvents, SendOTPSState> {
  SendOTPRepository repo;
  SendOTPSBloc(SendOTPSState initialState, this.repo) : super(initialState){
    on<SendOTPSPressed>(_SendOTPSPressed);
  }


  _SendOTPSPressed(SendOTPSPressed event,
      Emitter<SendOTPSState> emit,) async {
    emit(SendOTPSLoadingState());
    try{
      final data= await repo.postSendOTP(event.msisdn);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit (SendOTPSSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
        ));
      } else  {

        emit( SendOTPSErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
    }
    catch(e){
      print('sendotps bloc ${e}');
    }

  }


}
