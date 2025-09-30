import 'package:equatable/equatable.dart';

class DirectRechargeEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DirectRechargeStartEvent extends DirectRechargeEvents {}

class DirectRechargePressed extends DirectRechargeEvents {
  final String msisdn;
  final String hrn;

  DirectRechargePressed({this.msisdn, this.hrn});
}


