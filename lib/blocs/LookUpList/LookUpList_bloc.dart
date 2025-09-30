import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'package:sales_app/repository/lookUpList_repo.dart';
import 'LokkUpList_state.dart';
import 'LookUpList_events.dart';

class GetLookUpListBloc extends  Bloc<GetLookUpListEvents ,GetLookUpListState>{
  GetLookUpListRepository repo;
  GetLookUpListBloc(GetLookUpListState initialState,   this.repo ) : super(initialState){
    on<GetLookUpListEvents>(_GetLookUpListEvents);
  }

  _GetLookUpListEvents(
      GetLookUpListEvents event,
      Emitter<GetLookUpListState> emit,) async {
    emit(GetLookUpListLoadingState());
    try{
      List<dynamic> data = await repo.getLookUpList();
      emit( GetLookUpListSuccessState(data:data));
    }
        catch(e){
      print('GetLookUpList error ${e}');
      emit( GetLookUpListListErrorState(arabicMessage: e.toString(),englishMessage: e.toString()));
        }

  }


}

