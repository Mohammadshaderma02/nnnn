import 'package:equatable/equatable.dart';

class AddRemoveServiceState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddRemoveServiceInitState extends AddRemoveServiceState {}

class AddRemoveServiceLoadingState extends AddRemoveServiceState {}

class AddRemoveServiceSuccessState extends AddRemoveServiceState {

  final String arabicMessage;
  final String englishMessage;

  AddRemoveServiceSuccessState({this.arabicMessage, this.englishMessage});
}

class AddRemoveServiceErrorState extends AddRemoveServiceState {
  final String arabicMessage;
  final String englishMessage;
  AddRemoveServiceErrorState({this.arabicMessage, this.englishMessage});
}

class NewAddRemoveServiceErrorState extends AddRemoveServiceState {}