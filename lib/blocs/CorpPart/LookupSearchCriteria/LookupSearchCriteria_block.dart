
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/CorpPart/LookupSearchCriteria/LookupSearchCriteria.dart';
import 'LookupSearchCriteria_events.dart';
import 'LookupSearchCriteria_state.dart';

class LookupSearchCriteriaBloc extends  Bloc<LookupSearchCriteriaEvents ,LookupSearchCriteriaState>{
  LookupSearchCriteriaRepository repo;
  LookupSearchCriteriaBloc(LookupSearchCriteriaState initialState,   this.repo ) : super(initialState){
    on<LookupSearchCriteriaFetchEvent>(_LookupSearchCriteriaFetchEvent);
  }

  _LookupSearchCriteriaFetchEvent(LookupSearchCriteriaFetchEvent event,
      Emitter<LookupSearchCriteriaState> emit,) async {
    emit(LookupSearchCriteriaLoadingState());
    try {
      Map<String,dynamic> data = await repo.getLookupSearchCriteria();
      List list = data['data'];
      print("haya haya haya");
      print(data['data']);
      if(data['error']==401){
        emit( LookupSearchCriteriaTokenErrorState(
            arabicMessage: 'لا يوجد بينات متاحة',
            englishMessage:"No eligible packages found"));
      }
      if(data['status']==0){
        emit(LookupSearchCriteriaSuccessState(data:list));
      }
      if(data['status']==-1 || data['status']==-2 || data['status']==-3 ){
        emit(LookupSearchCriteriaNoDataState(arabicMessage: 'لا يوجد بينات متاحة',
            englishMessage:"No eligible packages found"));
      }
    }
    catch (e) {
      print('_LookupSearchCriteriaFetchEvent error ${e}');
    }
  }

}




