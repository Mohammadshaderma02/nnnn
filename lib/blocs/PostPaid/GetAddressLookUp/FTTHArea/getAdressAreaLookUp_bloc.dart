import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/PostPaid/GetAdressAreaLookUp_repo.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'getAdressAreaLookUp_events.dart';
import 'getAdressAreaLookUp_state.dart';

class GetAddressLookupAreaBloc extends  Bloc<GetAddressLookupAreaEvents ,GetAddressLookupAreaState>{
  GetAdressAreaLookUpRepository repo;
  GetAddressLookupAreaBloc(GetAddressLookupAreaState initialState,   this.repo )
      : super(initialState){
    on<GetAddressLookupAreaFetchEvent>(_GetAddressLookupAreaFetchEvent);
  }



  _GetAddressLookupAreaFetchEvent(GetAddressLookupAreaFetchEvent event,
      Emitter<GetAddressLookupAreaState> emit,) async {
    emit(GetAddressLookupAreaInitState());
    emit(GetAddressLookupAreaLoadingState());

    try {
      Map<String,dynamic> data = await repo.getAdressAreaLookUpRepository(event.value);

      List list = data['data'];

      if(data['status']==0) {

        print(data['data']);


        emit( GetAddressLookupAreaSuccessState(data: list));

      }
    }
    catch (e) {
      print('GetAddressLookupArea error ${e}');
      emit(GetAddressLookupAreaErrorState(
          arabicMessage: e.toString(), englishMessage: e.toString()));
    }
  }

}

