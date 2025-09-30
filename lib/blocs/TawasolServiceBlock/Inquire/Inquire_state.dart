import 'package:equatable/equatable.dart';

class InquireState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class InquireInitState extends InquireState {}

class InquireLoadingState extends InquireState {}

class InquireSuccessState extends InquireState {
  Map<String,dynamic> data ;

  final String kitcode;
  final String msisdn;
  final String price;
  final String arabicMessage;
  final String englishMessage;
  InquireSuccessState({this.arabicMessage, this.englishMessage,this.data, this.msisdn, this.kitcode,this.price});
}

class InquireErrorState extends InquireState {
  Map<String,dynamic> data ;
  final String arabicMessage;
  final String englishMessage;
  InquireErrorState({this.arabicMessage, this.englishMessage,this.data});
}

class NewInquireErrorState extends InquireState {}




