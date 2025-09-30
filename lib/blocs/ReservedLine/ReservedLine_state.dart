import 'package:equatable/equatable.dart';

class ReservedLineState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ReservedLineInitState extends ReservedLineState {}

class ReservedLineLoadingState extends ReservedLineState {

}

class ReservedLineSuccessState extends ReservedLineState {

  final String arabicMessage;
  final String englishMessage;
  ReservedLineSuccessState({this.arabicMessage, this.englishMessage});
}

class ReservedLineErrorState extends ReservedLineState {
  final String arabicMessage;
  final String englishMessage;
  ReservedLineErrorState({this.arabicMessage, this.englishMessage});
}

