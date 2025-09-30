import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/PostPaid/GetAdressAreaLookUp_repo.dart';
import 'package:sales_app/repository/PostPaid/GetPostpaidGSM_MSISDNList.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';

import 'PostpaidGSMMSISDNList_events.dart';
import 'PostpaidGSMMSISDNList_state.dart';


class GetPostPaidGSMMSISDNListBloc extends  Bloc<GetPostPaidGSMMSISDNListEvents ,GetPostPaidGSMMSISDNListState>{
  GetPostpaidGSMMSISDNListRepository repo;
  GetPostPaidGSMMSISDNListBloc(GetPostPaidGSMMSISDNListState initialState,   this.repo )
      : super(initialState){
    on<GetPostPaidGSMMSISDNListFetchEvent>(_GetPostPaidGSMMSISDNListFetchEvent);
  }



  _GetPostPaidGSMMSISDNListFetchEvent(GetPostPaidGSMMSISDNListFetchEvent event,
      Emitter<GetPostPaidGSMMSISDNListState> emit,) async {
    emit(GetPostPaidGSMMSISDNListInitState());
    emit(GetPostPaidGSMMSISDNListLoadingState());

    try {
      Map<String,dynamic> data = await repo.getPostpaidGSMMSISDNListRepository();

      List list = data['data'];

      if(data['status']==0) {


        emit( GetPostPaidGSMMSISDNListSuccessState(data: list));

      }
    }
    catch (e) {
      print('GetPostPaidGSMMSISDNList error ${e}');
      emit(GetPostPaidGSMMSISDNListErrorState(
          arabicMessage: e.toString(), englishMessage: e.toString()));
    }
  }

}
