import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_state.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_events.dart';
import 'package:sales_app/blocs/PostPaid/PostpaidGenerateContract/postpaidGenerateContract_state.dart';
import 'package:sales_app/repository/PostPaid/Postpaid%E2%80%8BGenerate%E2%80%8BContract_repo.dart';
import 'package:sales_app/repository/submitLineDocumentationRq_repo.dart';
import 'package:sales_app/repository/validateKitCodeRq_repo.dart';


class PostpaidGenerateContractBloc extends  Bloc<PostpaidGenerateContractEvents,PostpaidGenerateContractState> {
  PostpaidGenerateContractRepository repo;

  PostpaidGenerateContractBloc(PostpaidGenerateContractState initialState,
      this.repo) : super(initialState){
    on<PostpaidGenerateContractButtonPressed>(_PostpaidGenerateContractButtonPressed);
  }


  _PostpaidGenerateContractButtonPressed(
      PostpaidGenerateContractButtonPressed event,
      Emitter<PostpaidGenerateContractState> emit,) async {
    emit(PostpaidGenerateContractLoadingState());


    try {
      Map<String, dynamic> data = await repo.postpaidGenerateContract(
          event.isRental,
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
          event.locationScreenshotImageBase64,
          event.extraFreeMonths,
          event.extraExtender,
          event.simCard,
          event.contractImageBase64,
          event.deviceSerialNumber,
          event.deviceSerialNumberImageBase64,
          event.onBehalfUser,
          event.resellerID,
          event.isClaimed,
          event.salesLeadType,
          event.salesLeadValue,
          event.backPassportImageBase64,
          event.note,
          event.militaryID,
          event.scheduledDate,
          event.jeeranPromoCode,

          event.device5GType,
          event.serialNumber,
          event.itemCode,
          event.rentalMsisdn,
          event.eshopOrderId



      );
      print('block');
      print(data);
      if (data['status'] == 0) {
        emit(PostpaidGenerateContractSuccessState(
            filePath: data['data']['contractBase64']
        ));


      }

      if(data['status']==0){
        emit(PostpaidGenerateContractRentalSuccessState(
          filePathRental:data['data']['contractRentalBase64'],
        ));
      }

      else if (data['status'] != 0) {
        emit(PostpaidGenerateContractErrorState(
            arabicMessage: data['messageAr'],
            englishMessage: data['message']));
      }

      if (data['error'] != null) {
        if (data['error'] == 401) {
          emit(PostpaidGenerateContractErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));
        }
        else if (data['error'] == 400) {
          emit(PostpaidGenerateContractErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));
        }


        else {
          emit(PostpaidGenerateContractErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));
        }
      }
    }
    catch (e) {
      print('ostpaidGenerateContractButton error ${e}');
    }
  }

}