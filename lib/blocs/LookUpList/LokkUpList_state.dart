import 'package:equatable/equatable.dart';
class GetLookUpListState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetLookUpListInitState extends GetLookUpListState{}
class GetLookUpListLoadingState extends GetLookUpListState{}
class GetLookUpListSuccessState extends GetLookUpListState{
  List data ;
  GetLookUpListSuccessState ({this.data});
}
class GetLookUpListListErrorState extends GetLookUpListState{
  final String arabicMessage ;
  final String englishMessage ;
  GetLookUpListListErrorState({this.arabicMessage, this.englishMessage});
}
