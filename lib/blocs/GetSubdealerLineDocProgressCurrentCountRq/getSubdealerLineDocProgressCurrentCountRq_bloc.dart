import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/getSubdealerLineDocProgressCurrentCountRq_repo.dart';
import 'getSubdealerLineDocProgressCurrentCountRq_events.dart';
import 'getSubdealerLineDocProgressCurrentCountRq_state.dart';

class GetSubdealerLineDocProgressCurrentCountRqBloc extends  Bloc<GetSubdealerLineDocProgressCurrentCountRqEvents ,GetSubdealerLineDocProgressCurrentCountRqState>{
  GetSubdealerLineDocProgressCurrentCountRqRepository repo;
  GetSubdealerLineDocProgressCurrentCountRqBloc(GetSubdealerLineDocProgressCurrentCountRqState initialState,
      this.repo ) : super(initialState){
    on<GetSubdealerLineDocProgressCurrentCountRqFetchEvent>(_GetSubdealerLineDocProgressCurrentCountRqFetchEvent);
  }

  _GetSubdealerLineDocProgressCurrentCountRqFetchEvent(GetSubdealerLineDocProgressCurrentCountRqFetchEvent event,
      Emitter<GetSubdealerLineDocProgressCurrentCountRqState> emit,) async {
    emit(GetSubdealerLineDocProgressCurrentCountRqLoadingState());

    try{
      Map<String,dynamic> data = await repo.GetSubdealerLineDocProgressCurrentCountRq();
      if(data['status']==0){
        emit( GetSubdealerLineDocProgressCurrentCountRqSuccessState(data:data));
        // yield GetSubdealerLineDocProgressCurrentCountRqLoadingState();
      }
      else if(data['status']!=0 && data['status']!=null){
        emit( GetSubdealerLineDocProgressCurrentCountRqErrorState(arabicMessage: data['messageAr'],
            englishMessage: data['message']));
      }
      else if(data['error']!=null){
        if(data['error']==401) {
          print('errrrror');
          emit(  GetSubdealerLineDocProgressCurrentCountRqTokenErrorState());
        }
        else{
          emit(  GetSubdealerLineDocProgressCurrentCountRqErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));

        }
      }

    }catch(e){
      print('GetSubdealerLineDocProgressCurrentCountRq ${e}');
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }
}


