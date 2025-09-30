import 'package:equatable/equatable.dart';
class GetJordainainLookUpListState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetJordainainLookUpListInitState extends GetJordainainLookUpListState{}
class GetJordainainLookUpListLoadingState extends GetJordainainLookUpListState{}
class GetJordainainLookUpListSuccessState extends GetJordainainLookUpListState{
  List data ;
  GetJordainainLookUpListSuccessState ({this.data});
}
class GetJordainainLookUpListListErrorState extends GetJordainainLookUpListState{
  final String arabicMessage ;
  final String englishMessage ;
  GetJordainainLookUpListListErrorState({this.arabicMessage, this.englishMessage});
}
