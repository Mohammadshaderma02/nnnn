import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/blocs/UploadImage/UploadImage_events.dart';
import 'package:sales_app/blocs/UploadImage/UploadImage_state.dart';
import 'package:sales_app/repository/uploadImage_repo.dart';
import 'package:sales_app/repository/UnReserveLineProgressKit_repo.dart';

import 'package:shared_preferences/shared_preferences.dart';

class UploadImageBloc extends Bloc<UploadImageEvents, UploadImageState> {
  UploadImageRepository repo;

  // String kitcodee;

  UnReservedLineRepository unReservedLine; //New

  UploadImageBloc(UploadImageState initialState,
      this.repo) //New this.unReservedLine
      : super(initialState) {
    on<UploadImageRepositoryStartEvent>(_UploadImageRepositoryStartEvent);
    on<PressUploadImageRepositoryEvent>(_PressUploadImageRepositoryEvent);
  }


  _UploadImageRepositoryStartEvent(UploadImageRepositoryStartEvent event,
      Emitter<UploadImageState> emit,) async {
    emit(UploadImageStateInitState());
  }

  _PressUploadImageRepositoryEvent(PressUploadImageRepositoryEvent event,
      Emitter<UploadImageState> emit,) async {
    emit(UploadImageState());

    try {
      Map<dynamic, dynamic> Imagedata = await repo.putUploadImageRepository(
          event.kitCode, event.idImageBase64, event.contractImageBase64);
      //kitcodee = event.kitCode;//New


      // print("test kitcode in uploadimage");
      //  print('${kitcodee}');

      SharedPreferences prefs = await SharedPreferences.getInstance();
      print("UploadImageStateInitState");
      print(Imagedata);

      if (Imagedata["status"] == 0) {
        //  Map<dynamic,dynamic> testhaya = await unReservedLine.putUnReservedLineRepository(kitcodee);//New

        emit(UploadImageStateSuccessState(
            arabicMessage: Imagedata["messageAr"],
            englishMessage: Imagedata["message"]));
      } else if (Imagedata["status"] == -1) {
        emit(UploadImageStateErrorState(
            arabicMessage: Imagedata["messageAr"],
            englishMessage: Imagedata["message"]));
      }
    }
    catch (e) {
      print('UploadImageState error ${e}');
    }
  }

}