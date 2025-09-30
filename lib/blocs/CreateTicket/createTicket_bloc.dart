import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/SubmitLineDocumentationRq/submitLineDocumentationRq_state.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_events.dart';
import 'package:sales_app/blocs/LineDocumentation/ValidateKitCodeRq/validateKitCodeRq_state.dart';
import 'package:sales_app/blocs/Login/login_events.dart';
import 'package:sales_app/repository/create-ticket.dart';
import 'package:sales_app/repository/submitLineDocumentationRq_repo.dart';
import 'package:sales_app/repository/validateKitCodeRq_repo.dart';

import 'createTicket_events.dart';
import 'createTicket_state.dart';


class CreateTicketBloc extends  Bloc<CreateTicketEvents,CreateTicketState>{
  CreateTicketRepository repo;
  CreateTicketBloc(CreateTicketState initialState,  this.repo ) : super(initialState){

    on<CreateTicketButtonPressed>(_CreateTicketButtonPressed);
  }

  _CreateTicketButtonPressed(CreateTicketButtonPressed event,
      Emitter<CreateTicketState> emit,) async {

    emit(  CreateTicketLoadingState());
    try {
      Map<String,dynamic> data = await repo.createTicket(event.categoryID,event.ticketMessage,event.attachName,
          event.attachValueBase64,event.dealerID,event.dealerName,event.visibility
      );



      print(data);
      if (data["status"] == 0) {
        emit ( CreateTicketSuccessState(
          arabicMessage: data["messageAr"] + " "+data['data'] ,
          englishMessage: data["message"] +" "+data['data'],
        ));

      }
      else if(data["status"] != 0){
        emit  (CreateTicketErrorState(
            arabicMessage: data["messageAr"],
            englishMessage: data["message"]));

      }
      else if(data['error']!=null){
        if(data['error']==401) {
          emit ( CreateTicketErrorState());
        }
        else{
          emit(  CreateTicketErrorState(
              arabicMessage: "حدث خطأ ما. أعد المحاولة من فضلك",
              englishMessage: "Something went wrong please try again"));

        }
      }
    }catch (e) {
      print('CheckMSISDNAssignedSDLR error');
      // emit(ErrorState(message: e.toString()));
    }
  }


}

