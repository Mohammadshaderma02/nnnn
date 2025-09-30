import 'package:equatable/equatable.dart';

class ChangePasswordState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ChangePasswordInitState extends ChangePasswordState {}

class ChangePasswordLoadingState extends ChangePasswordState {}

class ChangePasswordSuccessState extends ChangePasswordState {
  final String arabicMessage;
  final String englishMessage;
  ChangePasswordSuccessState({this.arabicMessage, this.englishMessage});
}

class ChangePasswordErrorState extends ChangePasswordState {
  final String arabicMessage;
  final String englishMessage;
  ChangePasswordErrorState({this.arabicMessage, this.englishMessage});
}

class NewChangePasswordErrorState extends ChangePasswordState {}