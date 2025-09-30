import 'package:equatable/equatable.dart';

class CreateTicketState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class CreateTicketInitState extends CreateTicketState{}
class CreateTicketLoadingState extends CreateTicketState{}
class CreateTicketSuccessState extends CreateTicketState{
  final String arabicMessage ;
  final String englishMessage ;
  final String data ;
  CreateTicketSuccessState({this.arabicMessage, this.englishMessage,this.data});
}

class CreateTicketErrorState extends CreateTicketState{
  final String arabicMessage ;
  final String englishMessage ;
  CreateTicketErrorState({this.arabicMessage, this.englishMessage});
}
class  CreateTicketTokenErrorState extends CreateTicketState{
}