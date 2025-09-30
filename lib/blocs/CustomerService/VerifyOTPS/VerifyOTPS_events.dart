import 'package:equatable/equatable.dart';

class VerifyOTPSEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VerifyOTPSStartEvent extends VerifyOTPSEvents {}

class VerifyOTPSPressed extends VerifyOTPSEvents {
  final String msisdn;
  final String otp;

  VerifyOTPSPressed({this.msisdn, this.otp});
}


