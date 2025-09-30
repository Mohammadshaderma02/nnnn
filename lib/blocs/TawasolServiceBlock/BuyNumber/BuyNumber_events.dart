import 'package:equatable/equatable.dart';

class BuyNumberEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BuyNumberStartEvent extends BuyNumberEvents {}

class BuyNumberPressed extends BuyNumberEvents {
  final String msisdn;
  final String paymentMethod;
  final String operationReference;
  final String otp;
  BuyNumberPressed({this.msisdn,this.paymentMethod,this.operationReference,this.otp});
}


