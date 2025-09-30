import 'package:equatable/equatable.dart';

class SendOTPSState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendOTPSInitState extends SendOTPSState {}

class SendOTPSLoadingState extends SendOTPSState {}

class SendOTPSSuccessState extends SendOTPSState {

  final String arabicMessage;
  final String englishMessage;

  SendOTPSSuccessState({this.arabicMessage, this.englishMessage});
}

class SendOTPSErrorState extends SendOTPSState {
  final String arabicMessage;
  final String englishMessage;
  SendOTPSErrorState({this.arabicMessage, this.englishMessage});
}

class NewSendOTPSErrorState extends SendOTPSState {}