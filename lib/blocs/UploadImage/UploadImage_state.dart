import 'package:equatable/equatable.dart';

class UploadImageState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UploadImageStateInitState extends UploadImageState {}

class UploadImageStateLoadingState extends UploadImageState {}

class UploadImageStateSuccessState extends UploadImageState {


  final String arabicMessage;
  final String englishMessage;
  UploadImageStateSuccessState({this.arabicMessage, this.englishMessage});
}

class UploadImageStateErrorState extends UploadImageState {
  final String arabicMessage;
  final String englishMessage;
  UploadImageStateErrorState({this.arabicMessage, this.englishMessage});
}

