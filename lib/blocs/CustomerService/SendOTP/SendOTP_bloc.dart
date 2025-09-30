import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_state.dart';
import 'package:sales_app/blocs/CustomerService/SendOTP/SendOTP_events.dart';
import 'package:sales_app/repository/CustomerService/SendOTP_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SendOTPBloc
    extends Bloc<SendOTPEvents, SendOTPState> {
  SendOTPRepository repo;
  SendOTPBloc(SendOTPState initialState, this.repo) : super(initialState){
    on<SendOTPPressed>(_SendOTPPressed);
  }


  _SendOTPPressed(SendOTPPressed event,
      Emitter<SendOTPState> emit,) async {
    emit(SendOTPLoadingState());
    try{
      final data= await repo.postSendOTP(event.msisdn);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit (SendOTPSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
        ));
      } else  {

        emit( SendOTPErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
    }
     catch(e){
      print('send otp bloc ${e}');
     }

  }

}
