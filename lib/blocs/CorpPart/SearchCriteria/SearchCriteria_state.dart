import 'package:equatable/equatable.dart';

class SearchCriteriaState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class SearchCriteriaInitState extends SearchCriteriaState{}
class SearchCriteriaLoadingState extends SearchCriteriaState{}
class SearchCriteriaSuccessState extends SearchCriteriaState{
  List data ;
  final String arabicMessage;
  final String englishMessage;
  final String customerNumber;

  final String msisdn;
  final String highestCustomerID;
  SearchCriteriaSuccessState({this.arabicMessage, this.englishMessage, this.customerNumber,this.msisdn,this.data,this.highestCustomerID});
}
class SearchCriteriaErrorState extends SearchCriteriaState{
  final String arabicMessage ;
  final String englishMessage ;
  SearchCriteriaErrorState({this.arabicMessage, this.englishMessage});
}
class SearchCriteriaForgetErrorState extends SearchCriteriaState{}


class SearchCriteriaTokenErrorState extends SearchCriteriaState{
  final String arabicMessage ;
  final String englishMessage ;
  SearchCriteriaTokenErrorState({this.arabicMessage, this.englishMessage});
}

class SearchCriteriaDataEmptyState extends SearchCriteriaState{
  final String arabicMessage ;
  final String englishMessage ;
  SearchCriteriaDataEmptyState({this.arabicMessage, this.englishMessage});
}