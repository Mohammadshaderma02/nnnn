import 'package:equatable/equatable.dart';

class ActivateState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ActivateInitState extends ActivateState {}

class ActivateLoadingState extends ActivateState {}

class ActivateSuccessState extends ActivateState {
  Map<String,dynamic> data ;
  final String arabicMessage;
  final String englishMessage;

  final String msisdn;
  final String  kitcode;
  final String password;
  final String iccid;
  final String expiryDate;
  ActivateSuccessState({this.arabicMessage, this.englishMessage,this.data, this.msisdn,this.kitcode,this.password,this.expiryDate,this.iccid});
}

class ActivateErrorState extends ActivateState {
  final String arabicMessage;
  final String englishMessage;
  ActivateErrorState({this.arabicMessage, this.englishMessage});
}

class NewActivateErrorState extends ActivateState {}