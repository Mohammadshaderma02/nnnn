import 'package:equatable/equatable.dart';

class VerifyOTPSState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VerifyOTPSInitState extends VerifyOTPSState {}

class VerifyOTPSLoadingState extends VerifyOTPSState {}

class VerifyOTPSSuccessState extends VerifyOTPSState {

  final String arabicMessage;
  final String englishMessage;

  VerifyOTPSSuccessState({this.arabicMessage, this.englishMessage});
}

class VerifyOTPSErrorState extends VerifyOTPSState {
  final String arabicMessage;
  final String englishMessage;
  VerifyOTPSErrorState({this.arabicMessage, this.englishMessage});
}

class NewVerifyOTPSErrorState extends VerifyOTPSState {}