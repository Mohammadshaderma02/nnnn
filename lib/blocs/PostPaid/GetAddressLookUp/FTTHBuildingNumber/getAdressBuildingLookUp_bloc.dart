import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/PostPaid/GetAdressAreaLookUp_repo.dart';
import 'package:sales_app/repository/PostPaid/GetAdressBuildingLookUp_repo.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'getAdressBuildingLookUp_events.dart';
import 'getAdressBuildingLookUp_state.dart';

class GetAddressLookupBuildingBloc extends  Bloc<GetAddressLookupBuildingEvents ,GetAddressLookupBuildingState> {
  GetAdressBuildingLookUpRepository repo;

  GetAddressLookupBuildingBloc(GetAddressLookupBuildingState initialState,
      this.repo) : super(initialState){
    on<GetAddressLookupBuildingFetchEvent>(_GetAddressLookupBuildingFetchEvent);
  }


  _GetAddressLookupBuildingFetchEvent(GetAddressLookupBuildingFetchEvent event,
      Emitter<GetAddressLookupBuildingState> emit,) async {
    emit(GetAddressLookupBuildingInitState());
    emit(GetAddressLookupBuildingLoadingState());


    try {
      Map<String, dynamic> data = await repo.getAdressBuildingLookUpRepository(
          event.value);
      List list = data['data'];
      if (data['status'] == 0) {
        print(data['data']);
        emit(GetAddressLookupBuildingSuccessState(data: list));
      }
    }
    catch (e) {
      print('GetAddressLookupBuilding error ${e}');
      emit(GetAddressLookupBuildingErrorState(
          arabicMessage: e.toString(), englishMessage: e.toString()));
    }
  }

}