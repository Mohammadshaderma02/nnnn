import 'package:equatable/equatable.dart';

class SubmitRechargeDenominationState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SubmitRechargeDenominationInitState extends SubmitRechargeDenominationState {}

class SubmitRechargeDenominationLoadingState extends SubmitRechargeDenominationState {}

class SubmitRechargeDenominationSuccessState extends SubmitRechargeDenominationState {
  final String arabicMessage;
  final String englishMessage;
  SubmitRechargeDenominationSuccessState({this.arabicMessage, this.englishMessage});
}

class SubmitRechargeDenominationErrorState extends SubmitRechargeDenominationState {
  final String arabicMessage;
  final String englishMessage;
  SubmitRechargeDenominationErrorState({this.arabicMessage, this.englishMessage});
}

class NewSubmitRechargeDenominationErrorState extends SubmitRechargeDenominationState {}