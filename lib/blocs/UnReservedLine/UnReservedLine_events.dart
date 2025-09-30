import 'package:equatable/equatable.dart';

class UnReservedLineEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class UnReservedLineyStartEvent extends UnReservedLineEvents{}

class UnPressReservedLineEvent extends UnReservedLineEvents{
  final String kitCode;
  UnPressReservedLineEvent({this.kitCode});
}
