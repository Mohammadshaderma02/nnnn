
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/getPending_RejectedLineDocQueue_repo.dart';
import 'package:sales_app/repository/getTawasolNumber_repo.dart';
import 'getPendingLineDocQueue_events.dart';
import 'getPendingLineDocQueue_state.dart';


class GetPendingLineDocQueueBloc extends  Bloc<GetPendingLineDocQueueEvents ,GetPendingLineDocQueueState>{
  GetPendingRejectedLineDocQueueRepository repo;
  GetPendingLineDocQueueBloc(GetPendingLineDocQueueState initialState,   this.repo )
      : super(initialState){
    on<GetPendingLineDocQueueFetchEvent>(_GetPendingLineDocQueueFetchEvent);
  }

  List<dynamic> userList = [];
  int page =1;
  int limit =15;
  bool isLoading =false;

  _GetPendingLineDocQueueFetchEvent(GetPendingLineDocQueueFetchEvent event,
      Emitter<GetPendingLineDocQueueState> emit,) async {

    List<dynamic> newList = [];
    try{
      if (state is PendingLineDocQueueLoadingState) return;
      final currentState = state;
      var oldList = <dynamic>[];
      if (currentState is PendingLineDocQueueLoaded) {
        oldList = currentState.list;
      }
      emit (PendingLineDocQueueLoadingState(oldList: userList,isFirstFetch: page==1));
      newList = await repo.getPendingRejectedLineDocQueueList(page,limit,event.status);
      page++;
      final list = (state as PendingLineDocQueueLoadingState).oldList;
      list.addAll(newList);
      emit( PendingLineDocQueueLoaded(list));

    }catch(e){
      if(newList==null || newList.length==0 ){
        print('yesNull');
        emit (GetPendingLineDocQueueErrorEmptyState());
      }
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }


}





