import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/SaveProfileInfo/SaveProfileInfo_events.dart';


import 'package:sales_app/blocs/TawasolServiceBlock/PosNetOffer_GetPackages/GetPackages_events.dart';
import 'package:sales_app/blocs/TawasolServiceBlock/PosNetOffer_GetPackages/GetPackages_state.dart';
import 'package:sales_app/repository/TawasolService/PosNetOffer_GetPackages_repo.dart';


class GetPackageBloc extends  Bloc<GetPackageEvents,GetPackageState>{
  GetPosNetOfferPackageRepository repo;
  GetPackageBloc(GetPackageState initialState,  this.repo ) : super(initialState){
    on<PackageButtonPressed>(_PackageButtonPressed);
  }

  _PackageButtonPressed(PackageButtonPressed event,
      Emitter<GetPackageState> emit,) async {

    emit(GetPackageLoadingState());
    try {
      Map<String,dynamic> data = await repo.getPosNetOfferPackage(event.msisdn );
      List list = data['data'];
      if (data["status"] == 0 ) {
        print("haya");
        print(list[0]);
        emit( GetPackageSuccessState(
            data:list ,
            arabicName: data['data'][0]['arabicDescription'],
            englishName: data['data'][0]['englishDescription']));
      }

      else if(data['error']!=null){
        if(data['error']!=401){
          emit( GetPackageTokenErrorState());
        }else{
          emit( GetPackageErrorState(englishMessage: "Something went wrong please try again",
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك"));
        }
      }
      else{
        emit( GetPackageErrorState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"]));
      }
    }


    catch (e) {
      print('PackageButtonPressed error ${e}');
    }
  }




}


