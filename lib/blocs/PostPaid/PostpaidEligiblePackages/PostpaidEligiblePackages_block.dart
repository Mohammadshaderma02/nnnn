
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidEligiblePackages/PostpaidEligiblePackages_state.dart';
import 'package:sales_app/repository/PostPaid/PostpaidEligiblePackages.dart';

class PostpaidEligiblePackagesBlock extends  Bloc<PostpaidEligiblePackagesEvents ,PostpaidEligiblePackagesState> {
  PostpaidEligiblePackages repo;

  PostpaidEligiblePackagesBlock(PostpaidEligiblePackagesState initialState,
      this.repo) : super(initialState) {
    on<PostpaidEligiblePackagesSelect>(_PostpaidEligiblePackagesSelect);
  }


  _PostpaidEligiblePackagesSelect(PostpaidEligiblePackagesSelect event,
      Emitter<PostpaidEligiblePackagesState> emit,) async {
    emit(PostpaidEligiblePackagesStateInitState());
    emit(PostpaidEligiblePackagesStateLoadingState());

    try {
      Map<String, dynamic> data = await repo.postPostpaidEligiblePackages(
          event.marketType,event.isMada);
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List list = data['data'];
      print("""""""""""""""""""""""""""""""""""""""""""");
      print(list);
      print("""""""""""""""""""""""""""""""""""""""""""");

      if (data['error'] == 401) {
        emit(PostpaidEligiblePackagesStateTokenErrorState());
      }
      else if (data['status'] == 0) {
        emit(PostpaidEligiblePackagesStateSuccessState(data: list));
      }
      else if (data['status'] != 0) {
        emit(PostpaidEligiblePackagesStateErrorState(
            arabicMessage: data['messageAr'], englishMessage: data['message']));
      }
    }
    catch (e) {
      print('PostpaidEligiblePackages error ${e}');
    }
  }

}