import 'package:equatable/equatable.dart';

class SearchCriteriaEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class SearchCriteriaEvent extends SearchCriteriaEvents{}
class SubmitButtonSearchPressed extends SearchCriteriaEvents{
  final int searchID;
  final String searchValue;
  SubmitButtonSearchPressed({this.searchID,this.searchValue} );
}