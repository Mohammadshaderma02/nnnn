import 'package:equatable/equatable.dart';
class VoucherAmountEvents extends Equatable{
  @override
  // TODO: implement props
  List<Object> get props => [] ;
}
class VoucherAmountFetchEvent extends VoucherAmountEvents{
  final String mssid;
  final String voucherType;
  VoucherAmountFetchEvent(this.mssid,this.voucherType);

}
