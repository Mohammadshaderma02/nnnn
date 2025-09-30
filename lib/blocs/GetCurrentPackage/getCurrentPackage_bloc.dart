import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/SaveProfileInfo/SaveProfileInfo_events.dart';
import 'package:sales_app/repository/getCurrentPackage_repo.dart';
import 'getCurrentPackage_events.dart';
import 'getCurrentPackage_state.dart';
class GetCurrentPackageBloc extends  Bloc<GetCurrentPackageEvents,GetCurrentPackageState>{
  GetCurrentPackageRepository repo;
  GetCurrentPackageBloc(GetCurrentPackageState initialState,  this.repo )
      : super(initialState){

    on<GetCurrentPackageButtonPressed>(_GetCurrentPackageState);

  }

  _GetCurrentPackageState(GetCurrentPackageButtonPressed event,
      Emitter<GetCurrentPackageState> emit,) async {
    emit(GetCurrentPackageState());
    try {
      Map<String,dynamic> data = await repo.getCurrentPackage(event.msisdn );
      if (data["status"] == 0 && data["data"]['packageID']!='0') {
        emit( GetCurrentPackageSuccessState(
            arabicName: data['data']["arabicDescription"],
            englishName: data['data']["englishDescription"]));
      }
      else if(data["status"] == 0 && data["data"]['packageID']=='0'){
        emit( GetCurrentPackageSuccessState(
          arabicName: 'لا يوجد حزم نشطة',
          englishName: 'No active packege found',));
      }
      else if(data['error']!=null){
        if(data['error']!=401){
          emit( GetCurrentPackageTokenErrorState());
        }else{
          emit( GetCurrentPackageErrorState(
              englishMessage: "Something went wrong please try again",
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
        }
      }
      else{
        emit( GetCurrentPackageErrorState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"]));
      }

    }

    catch (e) {
      print('ForgetPassword bloc error ${e}');
    }
  }


}


