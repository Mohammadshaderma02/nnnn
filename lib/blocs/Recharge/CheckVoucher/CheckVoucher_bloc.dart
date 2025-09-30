import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Recharge/CheckVoucher/CheckVoucher_events.dart';
import 'package:sales_app/blocs/Recharge/CheckVoucher/CheckVoucher_states.dart';
import 'package:sales_app/repository/Checkvoucher_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckVoucherBloc extends  Bloc<CheckVoucherEvents ,CheckVoucherState> {
  CheckVoucherRepository repo;

  CheckVoucherBloc(CheckVoucherState initialState, this.repo)
      : super(initialState){
    on<CheckVoucherPressed>(_CheckVoucherPressed);
  }


  _CheckVoucherPressed(CheckVoucherPressed event,
      Emitter<CheckVoucherState> emit,) async {
    emit(CheckVoucherLoadingState());


    try {
      Map<String,dynamic> data = await repo.getCheckVoucher(event.serialNumber);

      if(data['status']==0){
        emit (CheckVoucherSuccessState(
            arabicMessage:data['data']["status"],

            englishMessage: data['data']["status"]));
      }
      if(data['status']==-1 || data['status']==-2 || data['status']==-3 ){
        emit (CheckVoucherErrorState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"]));
      }
    }
    catch (e) {
      print('CheckVoucher error ${e}');
    }
  }

}











