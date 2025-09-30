import 'package:equatable/equatable.dart';
class GetPostPaidGSMMSISDNListState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetPostPaidGSMMSISDNListInitState extends GetPostPaidGSMMSISDNListState{}
class GetPostPaidGSMMSISDNListLoadingState extends GetPostPaidGSMMSISDNListState{}
class GetPostPaidGSMMSISDNListSuccessState extends GetPostPaidGSMMSISDNListState{
  List data ;
  GetPostPaidGSMMSISDNListSuccessState ({this.data});
}

class GetPostPaidGSMMSISDNListErrorState extends GetPostPaidGSMMSISDNListState{
  final String arabicMessage ;
  final String englishMessage ;
  GetPostPaidGSMMSISDNListErrorState({this.arabicMessage, this.englishMessage});
}
class GetPostPaidGSMMSISDNListTokenErrorState extends GetPostPaidGSMMSISDNListState{

}