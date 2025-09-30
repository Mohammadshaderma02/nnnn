import 'package:equatable/equatable.dart';

class SendOTPSCheckMSISDNEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendOTPSCheckMSISDNStartEvent extends SendOTPSCheckMSISDNEvents {}

class SendOTPSCheckMSISDNPressed extends SendOTPSCheckMSISDNEvents {
  final String msisdn;
  SendOTPSCheckMSISDNPressed({this.msisdn});
}


