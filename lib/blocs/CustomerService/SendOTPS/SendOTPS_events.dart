import 'package:equatable/equatable.dart';

class SendOTPSEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendOTPSStartEvent extends SendOTPSEvents {}

class SendOTPSPressed extends SendOTPSEvents {
  final String msisdn;
  SendOTPSPressed({this.msisdn});
}


