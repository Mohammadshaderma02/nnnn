import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';




import 'package:sales_app/blocs/UnReservedLine/UnReservedLine_events.dart';
import 'package:sales_app/blocs/UnReservedLine/UnReservedLine_state.dart';
import 'package:sales_app/repository/UnReserveLineProgressKit_repo.dart';

import 'package:sales_app/repository/uploadImage_repo.dart';


class UnReservedLineBloc extends Bloc<UnReservedLineEvents, UnReservedLineState> {
  UnReservedLineRepository repo;


  UnReservedLineBloc(UnReservedLineState initialState, this.repo)
      : super(initialState) {
    on<UnPressReservedLineEvent>(_UnPressReservedLineEvent);

  }

  _UnPressReservedLineEvent(UnPressReservedLineEvent event,
      Emitter<UnReservedLineState> emit,) async {
    emit(UnReservedLineInitState());
    emit(UnReservedLineLoadingState());

    try {
      Map<String,dynamic> data = await repo.putUnReservedLineRepository(event.kitCode);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("UnReservedLineRepository");
      print(data);

      if (data["status"] == 0) {
        print("ssssss");
        //Map<dynamic,dynamic> data = await uploadImageRepository.putUploadImageRepository(event.kitCode, event.idImageBase64, event.contractImageBase64);

        emit( UnReservedLineSuccessState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
      else if (data["status"] == -1) {
        emit( UnReservedLineErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
    }
    catch (e) {
      print('UnReservedLineevent error ${e}');
    }
  }

}