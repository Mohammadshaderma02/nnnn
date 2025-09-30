
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyList/BuyList_events.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/BuyList/BuyList_state.dart';
import 'package:sales_app/repository/TawasolService/BuyList_repo.dart';

class BuyListBloc extends  Bloc<BuyListEvents ,BuyListState> {
  BuyListRepository repo;

  BuyListBloc(BuyListState initialState, this.repo) : super(initialState) {
    on<BuyListFetchEvent>(_BuyListFetchEvent);
  }


  _BuyListFetchEvent(BuyListFetchEvent event,
      Emitter<BuyListState> emit,) async {
    emit(BuyListInitState());
    emit(BuyListLoadingState());


    try {
      Map<String, dynamic> data = await repo.getBuyList();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List list = data['data'];
      if (data['error'] == 401) {
        emit(BuyListTokenErrorState());
      }
      else if (data['status'] == 0) {
        emit(BuyListSuccessState(data: list));
      }
      else if (data['status'] != 0) {
        emit(BuyListErrorState(arabicMessage: data['messageAr'],
            englishMessage: data['message']));
      }
    }


    catch (e) {
      print('BuyListPressed error ${e}');
    }
  }


}