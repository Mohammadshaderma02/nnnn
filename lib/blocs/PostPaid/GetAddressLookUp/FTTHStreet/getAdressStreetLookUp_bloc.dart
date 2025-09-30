import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/PostPaid/GetAddressStreetLookUp_repo.dart';
import 'package:sales_app/repository/PostPaid/GetAdressAreaLookUp_repo.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'getAdressStreetLookUp_events.dart';
import 'getAdressStreetLookUp_state.dart';

class GetAddressLookupStreetBloc extends  Bloc<GetAddressLookupStreetEvents ,GetAddressLookupStreetState> {
  GetAdressStreetLookUpRepository repo;

  GetAddressLookupStreetBloc(GetAddressLookupStreetState initialState,
      this.repo)
      : super(initialState) {
    on<GetAddressLookupStreetFetchEvent>(_GetAddressLookupStreetFetchEvent);
  }


  _GetAddressLookupStreetFetchEvent(GetAddressLookupStreetFetchEvent event,
      Emitter<GetAddressLookupStreetState> emit,) async {
    emit(GetAddressLookupStreetInitState());
    emit(GetAddressLookupStreetLoadingState());


    try {
      Map<String, dynamic> data = await repo.getAdressStreetLookUpRepository(
          event.value);

      List list = data['data'];
      //yield GetAddressLookupStreetSuccessState(data: list);
      if (data['status'] == 0) {
        print(data['data']);
        print('block ${list.length}');

        emit(GetAddressLookupStreetSuccessState(data: list));
      }
    }
    catch (e) {
      print('GetAddressLookupStreet error ${e}');
      emit(GetAddressLookupStreetErrorState(
          arabicMessage: e.toString(), englishMessage: e.toString()));
    }
  }


}
