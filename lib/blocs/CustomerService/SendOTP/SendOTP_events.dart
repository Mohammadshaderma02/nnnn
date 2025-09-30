import 'package:equatable/equatable.dart';

class SendOTPEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendOTPStartEvent extends SendOTPEvents {}

class SendOTPPressed extends SendOTPEvents {
  final String msisdn;
  SendOTPPressed({this.msisdn});
}


