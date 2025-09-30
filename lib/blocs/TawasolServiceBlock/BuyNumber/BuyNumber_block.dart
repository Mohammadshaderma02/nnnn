import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyNumber/BuyNumber_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyNumber/BuyNumber_events.dart';
import 'package:sales_app/repository/TawasolService/BuyNumber_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BuyNumberBloc
    extends Bloc<BuyNumberEvents, BuyNumberState> {
  BuyNumberRepository repo;

  BuyNumberBloc(BuyNumberState initialState, this.repo) : super(initialState){
    on<BuyNumberStartEvent>(_BuyNumberStartEvent);
    on<BuyNumberPressed>(_BuyNumberPressed);
  }


  _BuyNumberStartEvent(BuyNumberStartEvent event,
      Emitter<BuyNumberState> emit,) async {
    emit(BuyNumberInitState());
  }


  _BuyNumberPressed(BuyNumberPressed event,
      Emitter<BuyNumberState> emit,) async {
    emit(BuyNumberInitState());
    emit(BuyNumberLoadingState());


    try {
      Map<String,dynamic> data = await repo.postBuyNumber(event.msisdn,event.paymentMethod,event.operationReference, event.otp);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit( BuyNumberSuccessState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"],
            msisdn:data["data"]["msisdn"],
            expiryDate:data["data"]["expiryDate"]));

      } else  {

        emit( BuyNumberErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
    }


    catch (e) {
      print('BuyListPressed error ${e}');
    }
  }


}