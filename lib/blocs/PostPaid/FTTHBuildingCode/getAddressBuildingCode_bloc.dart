import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/PostPaid/GetFTTHBuildingCode.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'getAddressBuildingCode_events.dart';
import 'getAddressBuildingCode_state.dart';
class GetBuildingCodeBloc extends  Bloc<GetBuildingCodeEvents ,GetBuildingCodeState> {
  GetBuildingCodeRepository repo;

  GetBuildingCodeBloc(GetBuildingCodeState initialState, this.repo)
      : super(initialState) {
    on<GetBuildingCodeFetchEvent>(_GetBuildingCodeFetchEvent);
  }

  _GetBuildingCodeFetchEvent(GetBuildingCodeFetchEvent event,
      Emitter<GetBuildingCodeState> emit,) async {
    emit(GetBuildingCodeLoadingState());

    try {
      Map<String, dynamic> data = await repo.getBuildingCode(
          event.area, event.street, event.building);
      String buildingCode = data['data'];
      print("buildingCode");
      print(buildingCode);
      if (data['status'] == 0) {
        emit(GetBuildingCodeSuccessState(data: buildingCode));
      }
    }
    catch (e) {
      print('GetBuildingCodeFetchEvent error ${e}');
      emit(GetBuildingCodeErrorState(
          arabicMessage: e.toString(), englishMessage: e.toString()));
    }
  }

}

