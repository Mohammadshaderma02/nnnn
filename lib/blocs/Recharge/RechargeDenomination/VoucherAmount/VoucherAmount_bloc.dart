import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/VoucherAmount_repo.dart';
import 'VoucherAmount_events.dart';
import 'VoucherAmount_state.dart';

class VoucherAmountBloc extends  Bloc<VoucherAmountEvents ,VoucherAmountState>{
  VoucherAmountRepository repo;
  VoucherAmountBloc(VoucherAmountState initialState,   this.repo ) : super(initialState){

    on<VoucherAmountFetchEvent>(_VoucherAmountFetchEvent);
  }


  _VoucherAmountFetchEvent(VoucherAmountFetchEvent event,
      Emitter<VoucherAmountState> emit,) async {
    emit(VoucherAmountLoadingState());


    try {
      Map<String,dynamic> data = await repo.getVoucherAmount(event.mssid, event.voucherType);
      List list = data['data'];
      if(data['error']==401){
        emit( ChangePackageEligibilityRqTokenErrorState(arabicMessage: 'لا يوجد بينات متاحة'
            ,englishMessage:"No eligible packages found"));
      }
      if(data['status']==0){
        emit( VoucherAmountSuccessState(data:list));
      }
      if(data['status']==-1 || data['status']==-2 || data['status']==-3 ){
        emit( VoucherAmountNoDataState(arabicMessage: 'لا يوجد بينات متاحة',
            englishMessage:"No eligible packages found"));
      }
    }
    catch (e) {
      print('_SubmitRechargeDenominationPressed error ${e}');
    }
  }


}



