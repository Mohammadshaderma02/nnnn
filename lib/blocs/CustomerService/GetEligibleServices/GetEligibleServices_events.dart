import 'package:equatable/equatable.dart';

class GetEligibleServicesEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetEligibleServicesStartEvent extends GetEligibleServicesEvents {}

class GetEligibleServicesFetchEvent extends GetEligibleServicesEvents{

  final String msisdn;
  GetEligibleServicesFetchEvent({this.msisdn});
}




