import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Login/login_events.dart';

import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidityPrice/ExtendValidityPrice_events.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ExtendValidityPrice/ExtendValidityPrice_state.dart';
import 'package:sales_app/repository/TawasolService/GetExtendValidityPrice_repo.dart';


class GetExtendValidityPriceBloc extends  Bloc<GetExtendValidityPriceEvents,GetExtendValidityPriceState>{
  GetExtendValidityPriceRepository repo;
  GetExtendValidityPriceBloc(GetExtendValidityPriceState initialState,  this.repo )
      : super(initialState){

    on<GetExtendValidityPriceButtonPressed>(_GetExtendValidityPriceButtonPressed);
  }



  _GetExtendValidityPriceButtonPressed(GetExtendValidityPriceButtonPressed event,
      Emitter<GetExtendValidityPriceState> emit,) async {
    emit(GetExtendValidityPriceLoadingState());

    try {
      Map<String,dynamic> data = await repo.getExtendValidityPrice(event.kitCode );
      // List list = data['data'];
      if (data["status"] == 0 ) {
        print("haya");
        // print(list[0]);
        emit( GetExtendValidityPriceSuccessState(
            price: data['data']['price'],
            arabicName: data['messageAr'],
            englishName: data['message'],
            expiryDate: data['data']['expiryDate']));
        print("GetExtendValidityPriceSuccessState");
        print(data['data']['price']);

      }

      else if(data['error']!=null){
        if(data['error']!=401){
          emit( GetExtendValidityPriceTokenErrorState());
        }else{
          emit( GetExtendValidityPriceErrorState(englishMessage: "Something went wrong please try again",
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
        }
      }
      else{
        emit( GetExtendValidityPriceErrorState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"]));
      }
      //yield GetPackageInitState();

    }

    catch (e) {
      print('GetExtendValidityPrice error ${e}');
    }
  }




}


