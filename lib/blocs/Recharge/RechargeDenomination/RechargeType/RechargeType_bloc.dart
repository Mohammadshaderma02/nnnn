import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/RechargeType_repo.dart';
import 'RechargeType_events.dart';
import 'RechargeType_state.dart';

class RechargeTypeBloc extends  Bloc<RechargeTypeEvents ,RechargeTypeState>{
  RechargeTypeRepository repo;
  RechargeTypeBloc(RechargeTypeState initialState,   this.repo ) : super(initialState){

    on<RechargeTypeFetchEvent>(_RechargeTypeFetchEvent);
  }

  _RechargeTypeFetchEvent(RechargeTypeFetchEvent event,
      Emitter<RechargeTypeState> emit,) async {
    emit(RechargeTypeLoadingState());


    try {
      Map<String,dynamic> data = await repo.getRechargeType();
      List list = data['data'];
      if(data['error']==401){
        emit( RechargeTypeTokenErrorState(
            arabicMessage: 'لا يوجد بينات متاحة',
            englishMessage:"No eligible packages found"));
      }
      if(data['status']==0){
        emit( RechargeTypeSuccessState(data:list));
      }
      if(data['status']==-1 || data['status']==-2 || data['status']==-3 ){
        emit( RechargeTypeNoDataState(arabicMessage: 'لا يوجد بينات متاحة',
            englishMessage:"No eligible packages found"));
      }
    }
    catch (e) {
      print('_RechargeTypeFetchEvent error ${e}');
    }
  }


  }




