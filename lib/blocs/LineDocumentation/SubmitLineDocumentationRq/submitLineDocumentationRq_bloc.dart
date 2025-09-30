import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_state.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/repository/submitLineDocumentationRq_repo.dart';
import 'package:sales_app/repository/validateKitCodeRq_repo.dart';


class SubmitLineDocumentationRqBloc extends  Bloc<SubmitLineDocumentationRqEvents,SubmitLineDocumentationRqState> {
  SubmitLineDocumentationRqRepository repo;

  SubmitLineDocumentationRqBloc(SubmitLineDocumentationRqState initialState,
      this.repo) : super(initialState) {
    on<SubmitLineDocumentationRqButtonPressed>(
        _SubmitLineDocumentationRqButtonPressed);
  }


  _SubmitLineDocumentationRqButtonPressed(
      SubmitLineDocumentationRqButtonPressed event,
      Emitter<SubmitLineDocumentationRqState> emit,) async {
    emit(SubmitLineDocumentationRqLoadingState());

    try {
      Map<String, dynamic> data = await repo.submitLineDocumentationRq(
          event.msisdn,
          event.kitCode,
          event.iccid,
          event.listed,
          event.remark
          ,
          event.idImageBase64,
          event.contractImageBase64,
          event.indCompany,
          event.customerTitle,
          event.customerProfession,
          event.customerFirstName,
          event.customerSecondName,
          event.customerThirdName,
          event.customerLastName,
          event.customerMaritalStatus,
          event.customerLanguage,
          event.customerAddressType,
          event.customerHomeTel,
          event.customerHomeTel2,
          event.customerBirthDate,
          event.customerGender,
          event.customerGovernorate
          ,
          event.customerNationality,
          event.customerNationalNumber,
          event.customerIdType,
          event.customerIdNumber,
          event.customerBusinessType,
          event.customerArea,
          event.customerCity,
          event.customerTrade,
          event.customerPF,
          event.customerDepartment,
          event.militaryId,
          event.armyRegisterationTypeId,
          event.armyTypeId,
          event.armyRankId,
          event.documentExpiryDate
      );
      if (data["status"] == 0) {
        emit(SubmitLineDocumentationRqSuccessState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"]));
      }
      else if (data["status"] != 0) {
        emit(SubmitLineDocumentationRqErrorState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"]));
      }
      else if (data['error'] != null) {
        if (data['error'] == 401) {
          emit(SubmitLineDocumentationRqErrorState());
        }
        else {
          emit(SubmitLineDocumentationRqErrorState(

              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));
        }
      }
    } catch (e) {
      print('SubmitLineDocumentation error ${e}');
      //   yield GetPendingLineDocQueueErrorState(arabicMessage: e.toString(),englishMessage: e.toString());
    }
  }


}

