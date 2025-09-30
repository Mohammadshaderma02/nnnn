import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Inquire/Inquire_state.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/Inquire/Inquire_events.dart';
import 'package:sales_app/repository/TawasolService/Inquire_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InquireBloc
    extends Bloc<InquireEvents, InquireState> {
  InquireRepository repo;
  InquireBloc(InquireState initialState, this.repo) : super(initialState){
    on<InquirePressed>(_InquirePressed);
  }


  _InquirePressed(InquirePressed event,
      Emitter<InquireState> emit,) async {


    try {
      Map<String,dynamic> data = await repo.postInquire(event.msisdn);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      if (data['status'] == 0) {
        emit( InquireSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
          msisdn:data["data"]["msisdn"],
          kitcode:data["data"]["kitcode"],
          price:data["data"]["price"],

        ));

      } else  {

        emit( InquireErrorState(
            arabicMessage: data["messageAr"], englishMessage: data["message"]));
      }
      emit( InquireInitState());
    }


    catch (e) {
      print('Inquire error ${e}');
    }
  }



}