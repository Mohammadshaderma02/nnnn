import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/changePackageEligibilityRq_repo.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';
import 'changePackageEligibilityRq_events.dart';
import 'changePackageEligibilityRq_state.dart';

class ChangePackageEligibilityRqBloc extends  Bloc<ChangePackageEligibilityRqEvents ,ChangePackageEligibilityRqState>{
  ChangePackageEligibilityRqRepository repo;
  ChangePackageEligibilityRqBloc(ChangePackageEligibilityRqState initialState,   this.repo )
      : super(initialState){
    on<ChangePackageEligibilityRqFetchEvent>(_ChangePackageEligibilityRqFetchEvent);
  }

  _ChangePackageEligibilityRqFetchEvent(ChangePackageEligibilityRqFetchEvent event,
      Emitter<ChangePackageEligibilityRqState> emit,) async {
    emit( ChangePackageEligibilityRqLoadingState());
    Map<String,dynamic> data = await repo.changePackageEligibilityRqList(event.mssid, event.isPOSOffer);
    List list = data['data'];
    print('from bloc');
    print(list);
    if(data['error']==401){
      emit (ChangePackageEligibilityRqTokenErrorState(arabicMessage: 'لا يوجد بينات متاحة',
          englishMessage:"No eligible packages found"));
    }
    if(data['status']==0){
      emit (ChangePackageEligibilityRqSuccessState(data:list));
    }
    else if(data['error']!=null){
      emit (ChangePackageEligibilityRqNoDataState(englishMessage: "Something went wrong please try again",
          arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
    }
    else{
      emit (ChangePackageEligibilityRqNoDataState(arabicMessage: data['messageAr'],
          englishMessage:data['message']));
    }

  }


}



