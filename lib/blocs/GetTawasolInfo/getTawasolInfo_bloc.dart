import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/getTawasolNumber_repo.dart';
import 'getTawasoInfo_state.dart';
import 'getTawasolInfo_events.dart';
class GetTawasolInfoBloc extends  Bloc<GetTawasolInfoEvents ,GetTawasolInfoState> {
  GetTawasolNumberRepository repo;

  GetTawasolInfoBloc(GetTawasolInfoState initialState, this.repo)
      : super(initialState) {
    on<GetTawasolInfoFetchEvent>(_GetTawasolInfoEvents);
  }


  _GetTawasolInfoEvents(GetTawasolInfoEvents event,
      Emitter<GetTawasolInfoState> emit,) async {
    emit(GetTawasolInfoInitState());
    emit(GetTawasolInfoLoadingState());

    try {
      Map<String, dynamic> data = await repo.getTawasolNumber();
      print('getTawasol info satate');
      print(data);
      if (data['status'] == 0) {
        emit(GetTawasolInfoSuccessState(data: data));
      }
      else if (data['status'] != 0) {
        emit(GetTawasolInfoErrorState(
            arabicMessage: data['messageAr'], englishMessage: data['message']));
      }
      else if (data['error'] != null) {
        if (data['error'] == 401) {
          emit(GetTawasolInfoTokenErrorState());
        }
        else {
          emit(GetTawasolInfoErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));
        }
      }
    } catch (e) {
      print('GetTawasolInfo error ${e}');
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }

}