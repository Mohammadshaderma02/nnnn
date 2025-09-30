import 'package:equatable/equatable.dart';

class DirectRechargeState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DirectRechargeInitState extends DirectRechargeState {}

class DirectRechargeLoadingState extends DirectRechargeState {}

class DirectRechargeSuccessState extends DirectRechargeState {
  final String arabicMessage;
  final String englishMessage;
  DirectRechargeSuccessState({this.arabicMessage, this.englishMessage});
}

class DirectRechargeErrorState extends DirectRechargeState {
  final String arabicMessage;
  final String englishMessage;
  DirectRechargeErrorState({this.arabicMessage, this.englishMessage});
}

class NewDirectRechargeErrorState extends DirectRechargeState {}