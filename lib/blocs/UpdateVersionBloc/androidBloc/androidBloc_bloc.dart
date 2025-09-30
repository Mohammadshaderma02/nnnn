import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/UpdateVersion/AndroidVersion.dart';
import 'package:sales_app/blocs/UpdateVersionBloc/androidBloc/androidBloc_events.dart';
import 'package:sales_app/blocs/UpdateVersionBloc/androidBloc/androidBloc_state.dart';

class AndroidBloc extends  Bloc<AndroidEvents ,AndroidState>{
  UpdateAndroid repo;
  AndroidBloc(AndroidState initialState,   this.repo ) : super(initialState){
    on<AndroidFetchEvent>(_AndroidFetchEvent);
  }



  _AndroidFetchEvent(AndroidFetchEvent event,
      Emitter<AndroidState> emit,) async {
    emit(AndroidLoadingState());

    try {
      Map<String,dynamic> data = await repo.getAndroidVersion();
      print(data);
      List list = data['data'];
      emit( AndroidSuccessState(
        minimumVersion:data['minimumVersion'],
        currentVersion:data['currentVersion'],

      ));
      if(data['error']==401){
        emit( AndroidTokenErrorState(arabicMessage: 'لا يوجد بينات متاحة',
            englishMessage:"No eligible packages found"));
      }

      else{
        emit( AndroidNoDataState(arabicMessage: data['messageAr'],englishMessage: data['message']));
      }

    }
    catch (e) {
      print('_AndroidFetchEvent error ${e}');
    }
  }



}



