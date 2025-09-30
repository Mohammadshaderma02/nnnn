import 'package:equatable/equatable.dart';

class BuyNumberState extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class BuyNumberInitState extends BuyNumberState {}

class BuyNumberLoadingState extends BuyNumberState {}

class BuyNumberSuccessState extends BuyNumberState {
  Map<String,dynamic> data ;
  final String msisdn;
  final String expiryDate;
  final String arabicMessage;
  final String englishMessage;
  BuyNumberSuccessState({this.arabicMessage, this.englishMessage,this.data, this.expiryDate,this.msisdn});
}

class BuyNumberErrorState extends BuyNumberState {
  final String arabicMessage;
  final String englishMessage;
  BuyNumberErrorState({this.arabicMessage, this.englishMessage});
}

class NewBuyNumberErrorState extends BuyNumberState {}