import 'package:equatable/equatable.dart';
class CheckVoucherEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class CheckVoucherStartEvent extends CheckVoucherEvents{}
class CheckVoucherPressed extends CheckVoucherEvents{
  final String serialNumber;
  CheckVoucherPressed({this.serialNumber});
}
