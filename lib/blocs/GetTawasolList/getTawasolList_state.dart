import 'package:equatable/equatable.dart';
class GetTawasolListState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetTawasolListInitState extends GetTawasolListState{}
class GetTawasolListLoadingState extends GetTawasolListState{}
class GetTawasolListSuccessState extends GetTawasolListState{
  List data ;
  GetTawasolListSuccessState ({this.data});
}
class GetTawasolListErrorState extends GetTawasolListState{
  final String arabicMessage ;
  final String englishMessage ;
  GetTawasolListErrorState({this.arabicMessage, this.englishMessage});
}
class GetTawasolListTokenErrorState extends GetTawasolListState{

}