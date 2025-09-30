import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/TawasolService/ChangePackagePreToPreRqTawasol_repo.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ChangePackagePreToPreRqTawasol/ChangePackagePreToPreRqTawasol_events.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/ChangePackagePreToPreRqTawasol/ChangePackagePreToPreRqTawasol_state.dart';



class ChangePackagePreToPreRqTawasolBloc extends  Bloc<ChangePackagePreToPreRqTawasolEvents ,ChangePackagePreToPreRqTawasolState>{
  ChangePackagePreToPreRqTawasolRepository repo;
  ChangePackagePreToPreRqTawasolBloc(ChangePackagePreToPreRqTawasolState initialState,
      this.repo ) : super(initialState){
    on<ChangePackagePreToPreRqFetchTawasolEvent>(_ChangePackagePreToPreRqFetchTawasolEvent);
  }


  _ChangePackagePreToPreRqFetchTawasolEvent(ChangePackagePreToPreRqFetchTawasolEvent event,
      Emitter<ChangePackagePreToPreRqTawasolState> emit,) async {
    emit(ChangePackagePreToPreRqTawasolLoadingState());



    try {
      Map<String,dynamic> data = await repo.postChangePackagePreToPreRq(event.kitCode,event.mssid,event.newPackageCode,event.isPOSOffer);
      if(data['status']==0){
        emit (ChangePackagePreToPreRqTawasolSuccessState(arabicMessage:
        data['messagAr'] ,englishMessage:data['message']));
      }
      else if(data['error']!=null){
        emit( ChangePackagePreToPreRqTawasolErrorState(englishMessage: "Something went wrong please try again",
            arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
      }
      else{
        emit( ChangePackagePreToPreRqTawasolErrorState(arabicMessage:
        data['messageAr'] ,englishMessage:data['message'] ));
      }
    }


    catch (e) {
      print('ChangePackagePreToPreRqTawasol error ${e}');
    }
  }


}

