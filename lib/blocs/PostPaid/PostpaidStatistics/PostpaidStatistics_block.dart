import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/PostPaid/PostpaidStatistics.dart';
import 'PostpaidStatistics_events.dart';
import 'PostpaidStatistics_state.dart';

class PostpaidStatisticsBlock extends  Bloc<GetPostpaidStatisticsEvents ,GetPostpaidStatisticsState> {
  PostpaidStatisticsRepository repo;

  PostpaidStatisticsBlock(GetPostpaidStatisticsState initialState, this.repo) :
        super(initialState) {
    on<GetPostpaidStatisticsEvents>(_GetPostpaidStatisticsEvents);
  }


  _GetPostpaidStatisticsEvents(GetPostpaidStatisticsEvents event,
      Emitter<GetPostpaidStatisticsState> emit,) async {
    emit(GetPostpaidStatisticsLoadingState());


    try {
      Map<String,dynamic> data = await repo.PostpaidStatistics();
      if(data['status']==0){
        emit( GetPostpaidStatisticsSuccessState(data:data));
        // yield GetSubdealerLineDocProgressCurrentCountRqLoadingState();
      }
      else if(data['status']!=0 && data['status']!=null){
        emit( GetPostpaidStatisticsErrorState(arabicMessage:
        data['messageAr'],englishMessage: data['message']));
      }
      else if(data['error']!=null){
        if(data['error']==401) {
          print('errrrror');
          emit(  GetPostpaidStatisticsTokenErrorState());
        }
        else{
          emit(  GetPostpaidStatisticsErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));

        }
      }
    }
    catch (e) {
      print('GetPostpaidStatistics error ${e}');
    }
  }

}

