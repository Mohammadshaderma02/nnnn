import 'package:equatable/equatable.dart';

class ReservedLineEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class ReservedLineyStartEvent extends ReservedLineEvents{}

class PressReservedLineEvent extends ReservedLineEvents{
  final String kitCode;
  final String idImageBase64;
  final String contractImageBase64;
  PressReservedLineEvent({this.kitCode, this.idImageBase64, this.contractImageBase64});
}
