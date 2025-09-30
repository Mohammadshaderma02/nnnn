import 'package:equatable/equatable.dart';
class CreateTicketEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class CreateTicketEvent extends CreateTicketEvents{}
class  CreateTicketButtonPressed extends CreateTicketEvents{
  final String categoryID;
  final String ticketMessage;
  final String attachName;
  final String attachValueBase64;
  final String dealerID;
  final String dealerName;
  final bool visibility;
  CreateTicketButtonPressed({this.categoryID, this.ticketMessage,this.attachName,this.attachValueBase64,
    this.dealerID,this.dealerName,this.visibility });
}