import 'package:equatable/equatable.dart';
class GetRejectedLineDocQueueState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetRejectedLineDocQueueInitState extends GetRejectedLineDocQueueState{}
class GetRejectedLineDocQueueLoadingState extends GetRejectedLineDocQueueState{}
class RejectedLineDocQueueLoadingState extends GetRejectedLineDocQueueState{
  List<dynamic> oldList ;
  final bool isFirstFetch;
  RejectedLineDocQueueLoadingState({this.oldList,this.isFirstFetch=false});
}
class RejectedLineDocQueueLoaded extends GetRejectedLineDocQueueState{
  final List<dynamic> list;
  RejectedLineDocQueueLoaded(this.list);
}
class GetRejectedLineDocQueueErrorState extends GetRejectedLineDocQueueState{
  final String arabicMessage ;
  final String englishMessage ;
  GetRejectedLineDocQueueErrorState({this.arabicMessage, this.englishMessage});
}
class GetRejectedLineDocQueueErrorEmptyState extends GetRejectedLineDocQueueState{
}

