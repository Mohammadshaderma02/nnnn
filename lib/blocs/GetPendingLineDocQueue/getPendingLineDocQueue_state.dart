import 'package:equatable/equatable.dart';
class GetPendingLineDocQueueState extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class GetPendingLineDocQueueInitState extends GetPendingLineDocQueueState{}

class GetPendingLineDocQueueLoadingState extends GetPendingLineDocQueueState{}
class PendingLineDocQueueLoadingState extends GetPendingLineDocQueueState{
  List<dynamic> oldList ;
  final bool isFirstFetch;
  PendingLineDocQueueLoadingState({this.oldList,this.isFirstFetch=false});
}
class PendingLineDocQueueLoaded extends GetPendingLineDocQueueState{
final List<dynamic> list;
PendingLineDocQueueLoaded(this.list);
}
class GetPendingLineDocQueueErrorState extends GetPendingLineDocQueueState{
  final String arabicMessage ;
  final String englishMessage ;
  GetPendingLineDocQueueErrorState({this.arabicMessage, this.englishMessage});
}
class GetPendingLineDocQueueErrorEmptyState extends GetPendingLineDocQueueState{
}


