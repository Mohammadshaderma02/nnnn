import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/repository/PostPaid/PostValidateSubscriber.dart';
import 'PostValidateSubscriber_events.dart';
import 'PostValidateSubscriber_state.dart';

class PostValidateSubscriberBlock extends  Bloc<PostValidateSubscriberEvents ,PostValidateSubscriberState> {
  PostValidateSubscriberRepository repo;

  PostValidateSubscriberBlock(PostValidateSubscriberState initialState,
      this.repo)
      : super(initialState) {
    on<PostValidateSubscriberPressed>(_PostValidateSubscriberPressed);
  }


  _PostValidateSubscriberPressed(PostValidateSubscriberPressed event,
      Emitter<PostValidateSubscriberState> emit,) async {
    emit(PostValidateSubscriberInitState());
    emit(PostValidateSubscriberLoadingState());


    try {
      Map<String, dynamic> data = await repo.PostValidateSubscriber(
          event.marketType,
          event.isJordanian,
          event.nationalNo,
          event.packageCode,
          event.passportNo,
          event.msisdn,
          event.isRental,
          event.device5GType,
          event.buildingCode,
          event.serialNumber,
          event.itemCode,
        event.isLocked


      );
      if (data['status'] == 0) {
        print("hhhhhhhhhhhhhhhhhhhh");
        emit(PostValidateSubscriberSuccessState(data: data,
            arabicMessage: data['messageAr'],
            englishMessage: data['message'],
            msisdn: data['data']['msisdn'],
            Username: data['data']['generatedUsername'],
            Password: data['data']['generatedPassword'],
            Price: data['data']['price'],
            sendOTP: data['data']['sendOTP'],
            showSimCard:data['data']['showSimCard'],
            isArmy:data['data']['isArmy'],
            showCommitmentList:data['data']['showCommitmentList'],
            rentalMsisdn:data['data']['rentalMsisdn'],
            rentalPrice:data['data']['rentalPrice'],
            commitment:data['data']['commitment'],

        ));
        // yield GetSubdealerLineDocProgressCurrentCountRqLoadingState();
      }
      else if (data['status'] != 0 && data['status'] != null) {
        emit(PostValidateSubscriberErrorState(arabicMessage: data['messageAr'],
            englishMessage: data['message']));
      }
      else if (data['error'] != null) {
        if (data['error'] == 401) {
          print('errrrror');
          emit(PostValidateSubscriberTokenErrorState());
        }
        else {
          emit(PostValidateSubscriberErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));
        }
      }
    }


    catch (e) {
      print('PostValidateSubscriber error ${e}');
    }
  }
}