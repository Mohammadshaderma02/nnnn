import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/repository/validateKitCodeRq_repo.dart';


class ValidateKitCodeRqBloc extends  Bloc<ValidateKitCodeRqEvents,ValidateKitCodeRqState>{
  ValidateKitCodeRqRepository repo;
  ValidateKitCodeRqBloc(ValidateKitCodeRqState initialState,  this.repo ) : super(initialState){
    on<ValidateKitCodeRqStartEvent>(_ValidateKitCodeRqStartEvent);
    on<ValidateKitCodeRqButtonPressed>(_ValidateKitCodeRqButtonPressed);
    on<ValidateKitCodeRqScanButtonPressed>(_ValidateKitCodeRqScanButtonPressed);
  }



  _ValidateKitCodeRqStartEvent(
      ValidateKitCodeRqStartEvent _ValidateKitCodeRqStartEvent,
      Emitter<ValidateKitCodeRqState> emit,) async {
    emit(ValidateKitCodeRqInitState());

  }


  _ValidateKitCodeRqButtonPressed(
      ValidateKitCodeRqButtonPressed event,
      Emitter<ValidateKitCodeRqState> emit,) async {
    emit(ValidateKitCodeRqLoadingState());

    try {
      Map<String,dynamic> data = await repo.validateKitCodeRq(event.msisdn, event.kitCode,event.iccid );
      print(data);
      if (data["status"] == 0) {
        print(data['data']['isArmyActivation']);
        emit( ValidateKitCodeRqSuccessState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
          // displayReference: false,
          // isShahamah:true,
          isShahamah : data['data']['isArmyActivation'] != null && data['data']['isArmyActivation'] == true ?true:false,
          displayReference :data['data']['subMarket'] != null && data['data']['subMarket'] != 'GSM' ?true:false,
          showJordanian:data['data']['showJordanian'],
          showNonJordanian:data['data']['showNonJordanian'],
        ));

      }
      else if(data["status"] != 0){
        emit( ValidateKitCodeRqErrorState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],));
      }
      else if(data['error']!=null){
        if(data['error']==401) {
          emit( ValidateKitCodeRqErrorState());
        }
        else{
          emit( ValidateKitCodeRqErrorState(

              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));

        }
      }


    } catch (e) {
      print('_ValidateKitCodeRqButtonPressed error ${e}');
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }

  _ValidateKitCodeRqScanButtonPressed(
      ValidateKitCodeRqScanButtonPressed event,
      Emitter<ValidateKitCodeRqState> emit,) async {
    emit(ValidateKitCodeRqScanLoadingState());

    try {
      Map<String,dynamic> data = await repo.validateKitCodeRq(event.msisdn, event.kitCode,event.iccid );
      print(data);
      if (data["status"] == 0) {
        print(data['data']['isArmyActivation']);
        emit( ValidateKitCodeRqSuccessScanState(
          arabicMessage: data["messageAr"],
          englishMessage: data["message"],
          // displayReference: false,
          // isShahamah:true,
          isShahamah : data['data']['isArmyActivation'] != null && data['data']['isArmyActivation'] == true ?true:false,
          displayReference :data['data']['subMarket'] != null && data['data']['subMarket'] != 'GSM' ?true:false,
          showJordanian:data['data']['showJordanian'],
          showNonJordanian:data['data']['showNonJordanian'],
          msisdn:data['data']['msisdn'],
        ));

      }

      else if(data["status"] != 0){
        emit( ValidateKitCodeRqErrorScanState(
          arabicMessageScan: data["messageAr"],
          englishMessageScan: data["message"],));
      }
      else if(data['error']!=null){
        if(data['error']==401) {
          emit( ValidateKitCodeRqErrorScanState(
            arabicMessageScan: data["messageAr"],
            englishMessageScan: data["message"],
          ));
        }
        else{
          emit( ValidateKitCodeRqErrorScanState(

              arabicMessageScan: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessageScan: "Something went wrong please try again"));

        }
      }

    } catch (e) {
      print('_ValidateKitCodeRqScanButtonPressederror ${e}');
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }


  }


