import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/SaveProfileInfo/SaveProfileInfo_events.dart';
import 'package:sales_app/repository/saveProfileInfo_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'SaveProfileInfo_state.dart';
class SaveProfileInfoBloc extends  Bloc<SaveProfileInfoEvents,SaveProfileInfoState>{
 SaveProfileInfoRepository repo;
  SaveProfileInfoBloc(SaveProfileInfoState initialState,  this.repo ) : super(initialState){
    on<SaveProfileInfoButtonPressed>(_SaveProfileInfoButtonPressed);
  }



 _SaveProfileInfoButtonPressed(SaveProfileInfoButtonPressed event,
     Emitter<SaveProfileInfoState> emit,) async {
   emit(SaveProfileInfoLoadingState());

   try {
     Map<String,dynamic> data = await repo.saveProfileInfo(event.gender, event.nationality, event.profession, event.language,event.comtype,
         event.marital_status, event.education, event.gift, event.email,event.day, event.month, event.year, event.MobileNumber,event.MobileNumber1,
         event.MobileNumber2, event.MobileNumber3, event.FirstName, event.SecondName,event.ThirdName, event.FamilytName
     );
     print(data);
     if (data["status"] == 0) {
       //print(data);
       // print(data['message']);
       emit( SaveProfileInfoSuccessState(
           arabicMessage: data["messageAr"],
           englishMessage: data["message"]));

     } else {
       emit( SaveProfileInfoErrorState(
           arabicMessage: data["messageAr"],
           englishMessage: data["message"]));
     }
   }
   catch (e) {
     print('SaveProfileInfoButtonPressed error ${e}');
   }
 }


}


