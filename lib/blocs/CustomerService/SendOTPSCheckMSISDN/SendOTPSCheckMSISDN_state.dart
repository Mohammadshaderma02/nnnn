import 'package:equatable/equatable.dart';

class SendOTPSCheckMSISDNState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendOTPSCheckMSISDNInitState extends SendOTPSCheckMSISDNState {}

class SendOTPSCheckMSISDNLoadingState extends SendOTPSCheckMSISDNState {}

class SendOTPSCheckMSISDNSuccessState extends SendOTPSCheckMSISDNState {

  final String arabicMessage;
  final String englishMessage;

  SendOTPSCheckMSISDNSuccessState({this.arabicMessage, this.englishMessage});
}

class SendOTPSCheckMSISDNErrorState extends SendOTPSCheckMSISDNState {
  final String arabicMessage;
  final String englishMessage;
  SendOTPSCheckMSISDNErrorState({this.arabicMessage, this.englishMessage});
}

class NewSendOTPSCheckMSISDNErrorState extends SendOTPSCheckMSISDNState {}