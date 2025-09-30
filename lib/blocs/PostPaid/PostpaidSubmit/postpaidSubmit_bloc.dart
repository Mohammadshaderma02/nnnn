import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_state.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_state.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidSubmit/postpaidSubmit_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidSubmit/postpaidSubmit_state.dart';
import 'package:sales_app/repository/PostPaid/Postpaid%E2%80%8BGenerate%E2%80%8BContract_repo.dart';
import 'package:sales_app/repository/PostPaid/postpaidSubmit_repo.dart';
import 'package:sales_app/repository/submitLineDocumentationRq_repo.dart';
import 'package:sales_app/repository/validateKitCodeRq_repo.dart';


class PostpaidSubmitBloc extends  Bloc<PostpaidSubmitEvents,PostpaidSubmitState> {
  PostpaidSubmitRepository repo;

  PostpaidSubmitBloc(PostpaidSubmitState initialState, this.repo) :
        super(initialState) {
    on<PostpaidSubmitButtonPressed>(_PostpaidSubmitButtonPressed);
  }


  _PostpaidSubmitButtonPressed(PostpaidSubmitButtonPressed event,
      Emitter<PostpaidSubmitState> emit,) async {
    emit(PostpaidSubmitLoadingState());


    try {
      Map<String, dynamic> data = await repo.postpaidSubmit(
        event.marketType,
        event.isJordanian,
        event.nationalNo,
        event.passportNo,
        event.firstName,
        event.secondName,
        event.thirdName,
        event.lastName,
        event.birthDate,
        event.msisdn,
        event.buildingCode,
        event.migrateMBB,
        event.mbbMsisdn,
        event.packageCode,
        event.username,
        event.password,
        event.referenceNumber,
        event.referenceNumber2,
        event.frontIdImageBase64,
        event.backIdImageBase64,
        event.passportImageBase64,
        event.signatureImageBase64,
        event.locationScreenshotImageBase64,
        event.extraFreeMonths,
        event.extraExtender,
        event.simCard,
        event.contractImageBase64,
        event.deviceSerialNumber,
        event.deviceSerialNumberImageBase64,
        event.parentMSISDN,
        event.salesLeadType,
        event.salesLeadValue,
        event.onBehalfUser,
        event.resellerID,
        event.isClaimed,
        event.backPassportImageBase64,
        event.note,
        event.scheduledDate,
        event.militaryID,
        event.jeeranPromoCode,
        event.isRental,
        event.device5GType,
        event.serialNumber,
        event.itemCode,
        event.rentalMsisdn,
          event.eshopOrderId,
          event.authCode,
          event.last4Digits,
          event.receiptImageBase64,
        event.documentExpiryDate,
        event.countryId,
        event.email,
          event.homeInternetSpecialPromo,
        event.SimLock


      );

      if (data['status'] == 0) {
        emit(PostpaidSubmitSuccessState(
            arabicMessage: data['messageAr'],
            englishMessage: data['message'],
            contractUrl: data['data']['contractUrl'],
            showAppointment: data['data']['showAppointment']
          //contractUrl: "http://www.africau.edu/images/default/sample.pdf"
        ));
      } else if (data['status'] != 0) {
        print("00000000000000000000....BLOCK...0000000000000000000");
        print( data['messageAr']);
        print( data['message']);
        print(data['status']);
        emit(PostpaidSubmitErrorState(
            arabicMessage: data['messageAr'],
            englishMessage: data['message']));
      }else if (data['status'] == 503) {

        print( data['messageAr']);
        print( data['message']);
        print(data['status']);
        emit(PostpaidSubmitErrorState(
            arabicMessage:data['status'],
            englishMessage: data['status']));
      }

      if (data['error'] != null) {
        if (data['error'] == 401) {
          emit(PostpaidSubmitTokenErrorState());
        }
        else {
          emit(PostpaidSubmitErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));
        }
      }
    }
    catch (e) {
      print('GetPostpaidStatistics error ${e}');
    }
  }

}