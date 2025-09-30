import 'package:equatable/equatable.dart';

class SendOTPState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendOTPInitState extends SendOTPState {}

class SendOTPLoadingState extends SendOTPState {}

class SendOTPSuccessState extends SendOTPState {

  final String arabicMessage;
  final String englishMessage;

  SendOTPSuccessState({this.arabicMessage, this.englishMessage});
}

class SendOTPErrorState extends SendOTPState {
  final String arabicMessage;
  final String englishMessage;
  SendOTPErrorState({this.arabicMessage, this.englishMessage});
}

class NewSendOTPErrorState extends SendOTPState {}