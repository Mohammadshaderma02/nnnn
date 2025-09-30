import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/CheckMSISDNAssignedSDLR/CheckMSISDNAssignedSDLR_events.dart';
import 'package:sales_app/blocs/CheckMSISDNAssignedSDLR/CheckMSISDNAssignedSDLR_state.dart';
import 'package:sales_app/repository/CheckMSISDNAssignedSDLR_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckMSISDNAssignedSDLRBloc extends  Bloc<CheckMSISDNAssignedSDLREvents ,CheckMSISDNAssignedSDLRState>{
  CheckMSISDNAssignedSDLRRepository repo;
  CheckMSISDNAssignedSDLRBloc(CheckMSISDNAssignedSDLRState initialState,   this.repo ) :
        super(initialState) {
    on<CheckMSISDNAssignedSDLRPressed>(_CheckMSISDNAssignedSDLRPressed);
  }


  _CheckMSISDNAssignedSDLRPressed(CheckMSISDNAssignedSDLRPressed event,
      Emitter<CheckMSISDNAssignedSDLRState> emit,) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      emit( CheckMSISDNAssignedSDLRInitState());
      emit( CheckMSISDNAssignedSDLRLoadingState());
      Map<String,dynamic> data = await repo.getCheckMSISDNAssignedSDLR(event.msisdn);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print(" check data ${data}");
      if(data['status']==0){
        prefs.setString('UpgradePackageOtp', '0');
        print('otp is ${prefs.getString('UpgradePackageOtp')}');
        emit( CheckMSISDNAssignedSDLRSuccessState( arabicMessage: data["messageAr"],
            englishMessage: data["message"]));
      }
      else{
        emit( CheckMSISDNAssignedSDLRErrorState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"]));
      }
      emit( CheckMSISDNAssignedSDLRInitState());
    }catch (e) {
      print('CheckMSISDNAssignedSDLR error');
      // emit(ErrorState(message: e.toString()));
    }
  }


}




