import 'package:equatable/equatable.dart';
class CheckMSISDNAssignedSDLREvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class CheckMSISDNAssignedSDLRStartEvent extends CheckMSISDNAssignedSDLREvents{}
class CheckMSISDNAssignedSDLRPressed extends CheckMSISDNAssignedSDLREvents{
  final String msisdn;
  CheckMSISDNAssignedSDLRPressed({this.msisdn});
}
