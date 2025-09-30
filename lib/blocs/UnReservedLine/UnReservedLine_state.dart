import 'package:equatable/equatable.dart';

class UnReservedLineState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UnReservedLineInitState extends UnReservedLineState {}

class UnReservedLineLoadingState extends UnReservedLineState {}

class UnReservedLineSuccessState extends UnReservedLineState {

  final String arabicMessage;
  final String englishMessage;
  UnReservedLineSuccessState({this.arabicMessage, this.englishMessage});
}

class UnReservedLineErrorState extends UnReservedLineState {
  final String arabicMessage;
  final String englishMessage;
  UnReservedLineErrorState({this.arabicMessage, this.englishMessage});
}

