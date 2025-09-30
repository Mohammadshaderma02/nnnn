
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sales_app/repository/PostPaid/GenerateWFMToken_repo.dart';
import 'GenerateWFMToken_events.dart';
import 'GenerateWFMToken_state.dart';

class GenerateWFMTokenBlock extends  Bloc<GetGenerateWFMTokenEvents ,PostGenerateWFMTokenState>{
  GetGenerateWFMToken  repo;
  GenerateWFMTokenBlock(PostGenerateWFMTokenState initialState,   this.repo ) : super(initialState){
    on<GetGenerateWFMTokenMSISDN>(_GetGenerateWFMTokenMSISDN);
  }



  _GetGenerateWFMTokenMSISDN(GetGenerateWFMTokenMSISDN event,
      Emitter<PostGenerateWFMTokenState> emit,) async {
    emit(PostGenerateWFMTokenInitState());
    emit(PostGenerateWFMTokenLoadingState());

    try {
      Map<String,dynamic> data = await repo.getGenerateWFMTokenRepository(event.msisdn);
      SharedPreferences prefs = await SharedPreferences.getInstance();

      if(data['error']==401){
        emit( PostGenerateWFMTokenTokenErrorState());
      }
      else if(data['status']==0){

        emit( PostGenerateWFMTokenSuccessState(data:data,arabicMessage:
        data['messageAr'],englishMessage: data['message'],
            url: data['data']['url'],accessToken: data['data']['accessToken']));
      }
      else if(data['status']!=0){
        emit( PostGenerateWFMTokenErrorState(
            arabicMessage: data['messageAr'],englishMessage: data['message']));

      }

    }
    catch (e) {
      print('PostGenerateWFMToken error ${e}');

    }
  }


}

