
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/getPending_RejectedLineDocQueue_repo.dart';
import 'package:sales_app/repository/getTawasolNumber_repo.dart';

import 'getRejectedLineDocQueue_events.dart';
import 'getRejectedLineDocQueue_state.dart';

class GetRejectedLineDocQueueBloc extends  Bloc<GetRejectedLineDocQueueEvents ,GetRejectedLineDocQueueState>{
  GetPendingRejectedLineDocQueueRepository repo;
  GetRejectedLineDocQueueBloc(GetRejectedLineDocQueueState initialState,   this.repo )
      : super(initialState){
    on<GetRejectedLineDocQueueFetchEvent>(_GetRejectedLineDocQueueFetchEvent);
  }
  List<dynamic> userList = [];
  int page =1;
  int limit =15;
  bool isLoading =false;


  _GetRejectedLineDocQueueFetchEvent(GetRejectedLineDocQueueFetchEvent event,
      Emitter<GetRejectedLineDocQueueState> emit,) async {
    List<dynamic> newList = [];
    try{
      if (state is RejectedLineDocQueueLoadingState) return;
      final currentState = state;
      var oldList = <dynamic>[];
      if (currentState is RejectedLineDocQueueLoaded) {
        oldList = currentState.list;
      }
      emit( RejectedLineDocQueueLoadingState(oldList: userList,isFirstFetch: page==1));
      newList = await repo.getPendingRejectedLineDocQueueList(page,limit,event.status);
      page++;
      final list = (state as RejectedLineDocQueueLoadingState).oldList;
      list.addAll(newList);
      emit( RejectedLineDocQueueLoaded(list));

    }catch(e){
      if(newList==null || newList.length==0 ){
        print('yesNull');
        emit( GetRejectedLineDocQueueErrorEmptyState());
      }
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }

}



