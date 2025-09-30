import 'package:equatable/equatable.dart';

class GetNotificationsListState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetNotificationsListInitState extends GetNotificationsListState{}
class GetNotificationsListLoadingState extends GetNotificationsListState{}
class GetNotificationsListSuccessState extends GetNotificationsListState{
  List data ;
  GetNotificationsListSuccessState ({this.data});
}
class GetNotificationsListErrorState extends GetNotificationsListState{
  final String arabicMessage ;
  final String englishMessage ;
  GetNotificationsListErrorState({this.arabicMessage, this.englishMessage});
}

class GetNotificationsListTokenErrorState extends GetNotificationsListState{}