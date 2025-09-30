import 'package:equatable/equatable.dart';

class VerifyOTPEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VerifyOTPStartEvent extends VerifyOTPEvents {}

class VerifyOTPPressed extends VerifyOTPEvents {
  final String msisdn;
  final String otp;

  VerifyOTPPressed({this.msisdn, this.otp});
}


