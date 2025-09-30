import 'package:equatable/equatable.dart';
class LookupSearchCriteriaState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class LookupSearchCriteriaInitState extends LookupSearchCriteriaState{}
class LookupSearchCriteriaLoadingState extends LookupSearchCriteriaState{}
class LookupSearchCriteriaSuccessState extends LookupSearchCriteriaState{
  List data ;
  LookupSearchCriteriaSuccessState ({this.data});
}
class LookupSearchCriteriaErrorState extends LookupSearchCriteriaState{
  final String arabicMessage ;
  final String englishMessage ;
  LookupSearchCriteriaErrorState({this.arabicMessage, this.englishMessage});
}
class LookupSearchCriteriaNoDataState extends LookupSearchCriteriaState{
  final String arabicMessage ;
  final String englishMessage ;
  LookupSearchCriteriaNoDataState({this.arabicMessage, this.englishMessage});
}
class LookupSearchCriteriaTokenErrorState extends LookupSearchCriteriaState{
  final String arabicMessage ;
  final String englishMessage ;
  LookupSearchCriteriaTokenErrorState({this.arabicMessage, this.englishMessage});
}