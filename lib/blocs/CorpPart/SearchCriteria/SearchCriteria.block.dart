import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_events.dart';
import 'package:sales_app/blocs/CorpPart/SearchCriteria/SearchCriteria_state.dart';
import 'package:sales_app/repository/CorpPart/SearchCriteria/SearchCriteria.dart';
import 'package:shared_preferences/shared_preferences.dart';
class SearchCriteriaBloc
    extends Bloc<SearchCriteriaEvents, SearchCriteriaState> {
  SearchCriteriaRepository repo;
  var counter;
  SearchCriteriaBloc(SearchCriteriaState initialState, this.repo)
      : super(initialState){
    on<SearchCriteriaEvents>(_SearchCriteriaEvents);
    on<SubmitButtonSearchPressed>(_SubmitButtonSearchPressed);
  }


  _SearchCriteriaEvents(SearchCriteriaEvents event,
      Emitter<SearchCriteriaState> emit,) async {
    emit(SearchCriteriaInitState());

  }

  _SubmitButtonSearchPressed(SubmitButtonSearchPressed event, Emitter<SearchCriteriaState> emit) async {
    try {




        //emit (SearchCriteriaLoadingState());
        Map<String,dynamic> data = await repo.postSearchCriteria(event.searchID, event.searchValue);


        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.getString('statusCode');


        print(data["status"]);
        print(data);



        counter=data['data'].length;
        print(data['data'].length);


        if (data["status"] == 0) {

          print(data['data'][0]['msisdn']);
          print(data);

          emit( SearchCriteriaSuccessState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"],
              customerNumber:data['data'][0]['customerNumber'],
              msisdn:data['data'][0]['msisdn'],
              data:data['data'],
              highestCustomerID:data['data'][0]['highestCustomerID']

          ));
        } else if (data["status"] == -1) {
          emit( SearchCriteriaErrorState(
              arabicMessage: data["messageAr"],
              englishMessage: data["message"]));
        }else{
          emit( SearchCriteriaTokenErrorState(
              arabicMessage: 'لا توجد بيانات بحاجة إلى تسجيل الدخول مرة أخرى.',
              englishMessage:"No data found need to login again."));

        }

    }

    catch (e) {
      if(counter== 0){
        emit( SearchCriteriaDataEmptyState(
            arabicMessage: "لاتوجد بيانات.",
            englishMessage: "No Data Found."));
      }else{
        print('SubmitButtonSearchPressed bloc error ${e}');
        emit( SearchCriteriaTokenErrorState(arabicMessage: 'something wrong ', englishMessage:"something wrong "));

      }
       }
  }



}



