import 'package:equatable/equatable.dart';

class AddRemoveServiceEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddRemoveServiceStartEvent extends AddRemoveServiceEvents {}

class AddRemoveServicePressed extends AddRemoveServiceEvents {
  final String msisdn;
  final String serviceId;
  final String actionType;


  AddRemoveServicePressed({this.msisdn, this.serviceId, this.actionType});
}


