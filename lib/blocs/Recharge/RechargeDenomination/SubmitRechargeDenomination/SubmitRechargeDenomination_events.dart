import 'package:equatable/equatable.dart';

class SubmitRechargeDenominationEvents extends Equatable {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SubmitRechargeDenominationStartEvent extends SubmitRechargeDenominationEvents {}

class SubmitRechargeDenominationPressed extends SubmitRechargeDenominationEvents {
  final String bPartyMSISDN;
  final String rechargeAmount;
  final String voucherType;
  SubmitRechargeDenominationPressed({this.bPartyMSISDN, this.rechargeAmount, this.voucherType});
}