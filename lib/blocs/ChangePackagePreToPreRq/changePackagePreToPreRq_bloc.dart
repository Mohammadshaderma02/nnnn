import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/ChangePackageEligibilityRq/changePackageEligibilityRq_state.dart';
import 'package:sales_app/repository/changePackageEligibilityRq_repo.dart';
import 'package:sales_app/repository/changePackagePreToPreRq_repo.dart';
import 'package:sales_app/repository/getTawasolList_repo.dart';

import 'changePackagePreToPreRq_events.dart';
import 'changePackagePreToPreRq_state.dart';

class ChangePackagePreToPreRqBloc extends  Bloc<ChangePackagePreToPreRqEvents ,ChangePackagePreToPreRqState>{
  ChangePackagePreToPreRqRepository repo;
  ChangePackagePreToPreRqBloc(ChangePackagePreToPreRqState initialState,   this.repo )
      : super(initialState){
    on<ChangePackagePreToPreRqFetchEvent>(_ChangePackagePreToPreRqLoadingState);
  }

  _ChangePackagePreToPreRqLoadingState(ChangePackagePreToPreRqFetchEvent event,
      Emitter<ChangePackagePreToPreRqState> emit,) async {
    emit ( ChangePackagePreToPreRqLoadingState());
    Map<String,dynamic> data = await repo.changePackagePreToPreRq(event.mssid,event.newPackageCode,event.isPOSOffer);
    if(data['status']==0){
      emit (ChangePackagePreToPreRqSuccessState(arabicMessage: data['messagAr'] ,
          englishMessage:data['message']));
    }
    else if(data['error']!=null){
      emit (ChangePackagePreToPreRqErrorState(englishMessage: "Something went wrong please try again",
          arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
    }
    else{
      emit (ChangePackagePreToPreRqErrorState(arabicMessage: data['messageAr']
          ,englishMessage:data['message'] ));
    }

  }





}

