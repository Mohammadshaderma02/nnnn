import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'getTawasolList_events.dart';
import 'getTawasolList_state.dart';
class GetTawasolListBloc extends  Bloc<GetTawasolListEvents ,GetTawasolListState>{
  GetTawasolListRepository repo;
  GetTawasolListBloc(GetTawasolListState initialState,   this.repo ) : super(initialState){

    on<GetTawasolListFetchEvent>(_GetTawasolListFetchEvent);
  }


  _GetTawasolListFetchEvent(GetTawasolListFetchEvent event,
      Emitter<GetTawasolListState> emit,) async {
    emit(GetTawasolListLoadingState());

    try {
      Map<String,dynamic> data = await repo.getTawasolList();
      List list = data['data'];
      if(data['status']==0) {
        emit(GetTawasolListSuccessState(data: list));
      }
    } catch (e) {
      emit( GetTawasolListErrorState(arabicMessage: e.toString(),englishMessage: e.toString()));
      print('GetTawasolList error ${e}');
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }

}

