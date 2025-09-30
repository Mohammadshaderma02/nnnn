import 'package:equatable/equatable.dart';
class GetPendingLineDocQueueEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class GetPendingLineDocQueueFetchEvent extends GetPendingLineDocQueueEvents{
  final int status;
  GetPendingLineDocQueueFetchEvent(this.status);
}
