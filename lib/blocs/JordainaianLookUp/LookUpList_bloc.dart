import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'package:sales_app/repository/jordainianLookUpList.dart';
import 'package:sales_app/repository/lookUpList_repo.dart';
import 'LokkUpList_state.dart';
import 'LookUpList_events.dart';

class GetJordainainLookUpListBloc extends  Bloc<GetJordainainLookUpListEvents ,GetJordainainLookUpListState>{
  GetJordainainLookUpListRepository repo;
  GetJordainainLookUpListBloc(GetJordainainLookUpListState initialState,   this.repo ) : super(initialState){
    on<GetJordainainLookUpListEvents>(_GetJordainainLookUpListEvents);
  }



  _GetJordainainLookUpListEvents(GetJordainainLookUpListEvents event,
      Emitter<GetJordainainLookUpListState> emit,) async {
    emit(GetJordainainLookUpListLoadingState());

    try {
      List<dynamic> data = await repo.getLookUpList();
      emit( GetJordainainLookUpListSuccessState(data:data));
    } catch (e) {
      emit( GetJordainainLookUpListListErrorState(arabicMessage: e.toString(),englishMessage: e.toString()));
      print('GetJordainainLookUpList error ${e}');
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }

}

