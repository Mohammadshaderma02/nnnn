import 'package:equatable/equatable.dart';

class VerifyOTPSCheckMSISDNState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class VerifyOTPSCheckMSISDNInitState extends VerifyOTPSCheckMSISDNState {}

class VerifyOTPSCheckMSISDNLoadingState extends VerifyOTPSCheckMSISDNState {}

class VerifyOTPSCheckMSISDNSuccessState extends VerifyOTPSCheckMSISDNState {

  final String arabicMessage;
  final String englishMessage;

  VerifyOTPSCheckMSISDNSuccessState({this.arabicMessage, this.englishMessage});
}

class VerifyOTPSCheckMSISDNErrorState extends VerifyOTPSCheckMSISDNState {
  final String arabicMessage;
  final String englishMessage;
  VerifyOTPSCheckMSISDNErrorState({this.arabicMessage, this.englishMessage});
}

class NewVerifyOTPSCheckMSISDNErrorState extends VerifyOTPSCheckMSISDNState {}