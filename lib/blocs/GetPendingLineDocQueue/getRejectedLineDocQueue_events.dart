import 'package:equatable/equatable.dart';
class GetRejectedLineDocQueueEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}

class GetRejectedLineDocQueueFetchEvent extends GetRejectedLineDocQueueEvents{
  final int status;
  GetRejectedLineDocQueueFetchEvent(this.status);
}
