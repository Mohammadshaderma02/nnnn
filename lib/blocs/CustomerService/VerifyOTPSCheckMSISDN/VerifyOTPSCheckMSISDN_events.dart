import 'package:equatable/equatable.dart';

class VerifyOTPSCheckMSISDNEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VerifyOTPSCheckMSISDNStartEvent extends VerifyOTPSCheckMSISDNEvents {}

class VerifyOTPSCheckMSISDNPressed extends VerifyOTPSCheckMSISDNEvents {
  final String msisdn;
  final String otp;

  VerifyOTPSCheckMSISDNPressed({this.msisdn, this.otp});
}


