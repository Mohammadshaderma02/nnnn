import 'package:equatable/equatable.dart';

class ExtendValidityState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ExtendValidityInitState extends ExtendValidityState {}

class ExtendValidityLoadingState extends ExtendValidityState {}

class ExtendValiditySuccessState extends ExtendValidityState {
  final String arabicMessage;
  final String englishMessage;
  ExtendValiditySuccessState({this.arabicMessage, this.englishMessage});
}

class ExtendValidityErrorState extends ExtendValidityState {
  final String arabicMessage;
  final String englishMessage;
  ExtendValidityErrorState({this.arabicMessage, this.englishMessage});
}

class NewExtendValidityErrorState extends ExtendValidityState {}