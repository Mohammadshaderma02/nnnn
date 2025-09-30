import 'package:equatable/equatable.dart';

class VerifyOTPState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VerifyOTPInitState extends VerifyOTPState {}

class VerifyOTPLoadingState extends VerifyOTPState {}

class VerifyOTPSuccessState extends VerifyOTPState {

  final String arabicMessage;
  final String englishMessage;

  VerifyOTPSuccessState({this.arabicMessage, this.englishMessage});
}

class VerifyOTPErrorState extends VerifyOTPState {
  final String arabicMessage;
  final String englishMessage;
  VerifyOTPErrorState({this.arabicMessage, this.englishMessage});
}

class NewVerifyOTPErrorState extends VerifyOTPState {}